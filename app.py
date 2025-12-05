from flask import (
    Flask, render_template, request, redirect,
    url_for, flash, session, jsonify, has_request_context
)
from flask_bcrypt import Bcrypt
from flask_login import (
    LoginManager, UserMixin, login_user,
    login_required, logout_user, current_user
)
from flask_mail import Mail, Message
from flask_apscheduler import APScheduler
from itsdangerous import URLSafeTimedSerializer
import mysql.connector
from datetime import date, datetime, timedelta
from config import Config
from functools import wraps
import pandas as pd
import google.generativeai as genai
import re
import os
import json
from dotenv import load_dotenv
import time

# -------------------------------------------------
# App & extensions
# -------------------------------------------------
app = Flask(__name__)
app.config.from_object(Config)

# Educational Resource Hub
RESOURCE_TYPES = ['video', 'book', 'article']

# ---------- File upload settings for test questions ----------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
QUESTION_UPLOAD_SUBDIR = os.path.join("static", "uploads", "questions")
QUESTION_UPLOAD_FOLDER = os.path.join(BASE_DIR, QUESTION_UPLOAD_SUBDIR)

os.makedirs(QUESTION_UPLOAD_FOLDER, exist_ok=True)

app.config["QUESTION_UPLOAD_FOLDER"] = QUESTION_UPLOAD_FOLDER

ALLOWED_IMAGE_EXT = {"png", "jpg", "jpeg", "gif"}
ALLOWED_AUDIO_EXT = {"mp3", "wav", "ogg"}

load_dotenv()
bcrypt = Bcrypt(app)
login_manager = LoginManager(app)
login_manager.login_view = "login"
mail = Mail(app)
serializer = URLSafeTimedSerializer(app.config["SECRET_KEY"])

# Initialize APScheduler for automated tasks
scheduler = APScheduler()
app.config['SCHEDULER_API_ENABLED'] = False  # Disable API for security
app.config['SCHEDULER_TIMEZONE'] = 'UTC'  # Set timezone

EMAIL_REGEX = re.compile(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$")
ADMIN_PASSKEY = "child1234"

# -------------- GEMINI + BENCHMARK SETUP --------------
genai.configure(api_key=app.config["GOOGLE_API_KEY"])

BENCHMARK_PATH = "static/data/developmental_milestones.csv"
benchmark_df = pd.read_csv(BENCHMARK_PATH)
benchmark_df.columns = [c.strip().capitalize() for c in benchmark_df.columns]


# -------------------------------------------------
# DB helper
# -------------------------------------------------
def get_db_conn():
    return mysql.connector.connect(
        host=app.config["DB_HOST"],
        user=app.config["DB_USER"],
        password=app.config["DB_PASS"],
        database=app.config["DB_NAME"],
    )


# -------------------------------------------------
# Product Recommendation Helpers
# -------------------------------------------------
def generate_product_links(keywords, product_type):
    """
    Generate search URLs for multiple e-commerce platforms based on keywords.
    """
    import urllib.parse

    search_query = urllib.parse.quote_plus(keywords)

    links = {
        'amazon': f"https://www.amazon.com/s?k={search_query}",
        'shopee': f"https://shopee.com.my/search?keyword={search_query}",
        'lazada': f"https://www.lazada.com.my/catalog/?q={search_query}"
    }

    return links


def extract_products_from_response(full_response, child_id, cursor):
    """
    Extract product recommendations from AI response and store in database.
    Returns cleaned HTML (without product tags) and list of product dictionaries.
    """
    import re

    # Pattern to match product blocks
    product_pattern = r'\[PRODUCT_START\](.*?)\[PRODUCT_END\]'
    product_matches = re.findall(product_pattern, full_response, re.DOTALL)

    products = []
    tutoring_result_id = None

    for product_text in product_matches:
        # Parse product fields
        product_data = {}

        # Extract Name
        name_match = re.search(r'Name:\s*(.+?)(?:\n|$)', product_text)
        if name_match:
            product_data['name'] = name_match.group(1).strip()

        # Extract Type
        type_match = re.search(r'Type:\s*(.+?)(?:\n|$)', product_text)
        if type_match:
            product_data['type'] = type_match.group(1).strip().lower()

        # Extract Category
        category_match = re.search(r'Category:\s*(.+?)(?:\n|$)', product_text)
        if category_match:
            product_data['category'] = category_match.group(1).strip().lower()

        # Extract Subject
        subject_match = re.search(r'Subject:\s*(.+?)(?:\n|$)', product_text)
        if subject_match:
            product_data['subject'] = subject_match.group(1).strip().lower()

        # Extract Learning Style
        learning_style_match = re.search(r'Learning Style:\s*(.+?)(?:\n|$)', product_text)
        if learning_style_match:
            product_data['learning_style'] = learning_style_match.group(1).strip().lower()

        # Extract Age
        age_match = re.search(r'Age:\s*(.+?)(?:\n|$)', product_text)
        if age_match:
            product_data['age_range'] = age_match.group(1).strip()

        # Extract Price
        price_match = re.search(r'Price:\s*RM\s*([\d.]+)', product_text)
        if price_match:
            product_data['price'] = float(price_match.group(1))

        # Extract Why (description)
        why_match = re.search(r'Why:\s*(.+?)(?:\nKeywords:|$)', product_text, re.DOTALL)
        if why_match:
            product_data['why'] = why_match.group(1).strip()

        # Extract Keywords
        keywords_match = re.search(r'Keywords:\s*(.+?)(?:\nPriority:|$)', product_text, re.DOTALL)
        if keywords_match:
            product_data['keywords'] = keywords_match.group(1).strip()

        # Extract Priority
        priority_match = re.search(r'Priority:\s*(.+?)(?:\n|$)', product_text)
        if priority_match:
            product_data['priority'] = priority_match.group(1).strip().lower()

        # Only add if we have minimum required fields
        if 'name' in product_data and 'keywords' in product_data:
            products.append(product_data)

    # Remove product tags from HTML response
    cleaned_html = re.sub(product_pattern, '', full_response, flags=re.DOTALL)

    # Store products in database if any were found
    if products and cursor:
        for prod in products:
            # Generate product links
            links = generate_product_links(
                prod.get('keywords', prod['name']),
                prod.get('type', 'book')
            )

            # Calculate price range
            price = prod.get('price', 0.0)
            if price <= 20:
                price_range = 'budget'
            elif price <= 50:
                price_range = 'mid_range'
            else:
                price_range = 'premium'

            try:
                cursor.execute("""
                    INSERT INTO product_recommendations
                    (child_id, tutoring_result_id, product_name, product_type, category,
                     subject, learning_style, description, age_range, price_myr, price_range,
                      amazon_url, shopee_url, lazada_url, priority, reason,
                     created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW())
                """, (
                    child_id,
                    tutoring_result_id,
                    prod['name'],
                    prod.get('type', 'book'),
                    prod.get('category', 'other'),
                    prod.get('subject', 'general'),
                    prod.get('learning_style', 'mixed'),
                    prod.get('keywords', ''),
                    prod.get('age_range', ''),
                    price,
                    price_range,
                    links['amazon'],
                    links['shopee'],
                    links['lazada'],
                    prod.get('priority', 'medium'),
                    prod.get('why', '')
                ))
            except Exception as e:
                # Log error but continue processing
                print(f"Error storing product: {e}")

    return cleaned_html.strip(), products


# -------------------------------------------------
# User model for Flask-Login
# -------------------------------------------------
class User(UserMixin):
    def __init__(self, id, name, email, role):
        self.id = id
        self.name = name
        self.email = email
        self.role = role

    def get_id(self):
        return str(self.id)


@login_manager.user_loader
def load_user(user_id):
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT id, name, email, role FROM users WHERE id = %s", (user_id,)
    )
    row = cursor.fetchone()
    cursor.close()
    conn.close()
    if row:
        return User(row["id"], row["name"], row["email"], row["role"])
    return None

# -------------------------------------------------
# Session Management Middleware
# -------------------------------------------------
@app.before_request
def check_session_timeout():
    """
    Role-based session timeout:
    - Parents: 30 minute timeout
    - Admins: No timeout

    """

    # Skip timeout check for static files and non-authenticated routes
    if request.endpoint and (request.endpoint == 'static' or not current_user.is_authenticated):
        return

    # Only apply timeout to parent users
    if normalize_role(current_user.role) == "parent":
        # Check if this is the first request (login)
        if 'last_activity' not in session:
            session['last_activity'] = datetime.now().isoformat()
            session.permanent = True
            return


        # Get last activity time
        last_activity = datetime.fromisoformat(session['last_activity'])
        timeout_duration = app.config['PERMANENT_SESSION_LIFETIME']

        # Check if session has expired
        if datetime.now() - last_activity > timeout_duration:
           # Logout user and show timeout message
            logout_user()
            flash("Your session has expired due to inactivity. Please log in again.", "warning")
            return redirect(url_for('login'))

        # Update last activity time
        session['last_activity'] = datetime.now().isoformat()

    # Admins don't have timeout - set permanent session
    elif normalize_role(current_user.role) == "admin":
        session.permanent = True

# -------------------------------------------------
# Helpers
# -------------------------------------------------
def is_strong_password(password: str) -> bool:
    if not password:
        return False
    pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9])(?=.{8,})"
    return re.search(pattern, password) is not None

def is_valid_name(name: str) -> bool:
    """
    Validate that a name contains only alphabet letters and spaces.
    Returns True if valid, False otherwise.
    """
    if not name or not name.strip():
        return False
    # Allow only letters (any language) and spaces
    pattern = r"^[A-Za-z\s]+$"
    return re.match(pattern, name.strip()) is not None

def is_valid_grade_level(grade_level: str) -> bool:
    """
    Validate that grade level contains only alphanumeric characters and spaces.
    No special characters like commas, periods, etc. are allowed.
    Returns True if valid, False otherwise.
    """
    if not grade_level or not grade_level.strip():
        return False

    # Allow only letters, numbers, and spaces (e.g., "K1", "Pre-K", "A", "Preschool")
    # Using a simple pattern that allows letters, numbers, hyphens, and spaces
    pattern = r"^[A-Za-z0-9\s-]+$"

    # Additional check: must be reasonable length (1-20 characters)
    stripped = grade_level.strip()
    if len(stripped) > 20:
        return False
    return re.match(pattern, stripped) is not None

def is_valid_dob(dob_str: str) -> tuple:

    """
    Validate date of birth.
    Returns (is_valid, error_message) tuple.
    - Cannot be in the future
    - Cannot be more than 18 years ago (reasonable for preschool app)
    """
    if not dob_str:
        return (False, "Date of birth is required.")
    try:
        dob = datetime.strptime(dob_str, "%Y-%m-%d").date()
    except ValueError:
        return (False, "Invalid date format. Please use YYYY-MM-DD.")
    today = date.today()

    # Check if date is in the future
    if dob > today:
        return (False, "Date of birth cannot be in the future.")

    # Check if date is more than 18 years ago (unrealistic for preschool app)
    eighteen_years_ago = date(today.year - 18, today.month, today.day)
    if dob < eighteen_years_ago:
        return (False, "Date of birth cannot be more than 18 years ago.")
    return (True, None)

def is_valid_academic_date(year: int, month: int) -> tuple:

    """
    Validate academic record date (year and month).
    Returns (is_valid, error_message) tuple.
    - Year must be between 2000 and current year
    - Month must be between 1 and 12
    - Date cannot be in the future
    """

    if not year or not month:
        return (False, "Year and month are required.")

    # Validate month range
    if month < 1 or month > 12:
        return (False, "Month must be between 1 and 12.")

    current_year = date.today().year

    # Validate year range (reasonable for educational records)
    if year < 2000:
        return (False, f"Year cannot be before 2000.")

    if year > current_year:
        return (False, f"Year cannot be in the future.")

    # Check if the date is in the future
    today = date.today()
    record_date = date(year, month, 1)

    if record_date > today:
        return (False, "Academic record date cannot be in the future.")
    return (True, None)

def normalize_role(role):
    if not role:
        return None
    normalized = str(role).strip().lower()
    aliases = {
        "administrator": "admin",
        "admin": "admin",
        "parent": "parent",
    }
    return aliases.get(normalized)


def roles_required(*roles):
    def wrapper(f):
        @wraps(f)
        def wrapped(*args, **kwargs):
            normalized_user_role = (
                normalize_role(current_user.role)
                if current_user.is_authenticated
                else None
            )
            normalized_roles = [normalize_role(r) for r in roles]

            if (
                not current_user.is_authenticated
                or normalized_user_role not in normalized_roles
            ):
                flash("You don't have access to that page.", "danger")
                return redirect(url_for("login"))
            return f(*args, **kwargs)

        return wrapped

    return wrapper



def save_question_media(file_storage, test_id, index):
    """
    Save uploaded file for a question and return (media_type, media_path).
    media_path is relative to static/, e.g. 'uploads/questions/xxx.png'
    """
    if not file_storage or not file_storage.filename:
        return None, None

    filename = file_storage.filename
    ext = filename.rsplit(".", 1)[-1].lower()

    if ext in ALLOWED_IMAGE_EXT:
        media_type = "image"
    elif ext in ALLOWED_AUDIO_EXT:
        media_type = "audio"
    else:
        # unsupported extension
        return None, None

    safe_name = f"test{test_id}_q{index+1}_{int(time.time())}.{ext}"
    full_path = os.path.join(app.config["QUESTION_UPLOAD_FOLDER"], safe_name)

    file_storage.save(full_path)

    # store path relative to static/
    media_path = os.path.join("uploads", "questions", safe_name).replace("\\", "/")
    return media_type, media_path




# -------------------------------------------------
# AUTH
# -------------------------------------------------
@app.route("/register")
def register_redirect():
    return redirect(url_for("register_select"))


@app.route("/register/select")
def register_select():
    return render_template("register_select.html")


@app.route("/register/parent", methods=["GET", "POST"])
def register_parent():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        password = request.form["password"]
        confirm_password = request.form.get("confirm_password", "")

        if not all([name, email, password, confirm_password]):
            flash("Please fill all fields", "warning")
            return redirect(url_for('register_parent'))

        if password != confirm_password:
            flash("Passwords do not match.", "danger")
            return redirect(url_for("register_parent"))

        if not EMAIL_REGEX.match(email):
            flash("Please enter a valid email address.", "danger")
            return redirect(url_for("register_parent"))
        
        if not is_strong_password(password):
            flash("Password must be at least 8 characters long and include one uppercase letter, one lowercase letter, and one symbol.", "warning")
            return redirect(url_for('register_parent'))

        # Validate name contains only alphabet letters
        if not is_valid_name(name):
            flash("Name must contain only alphabet letters and spaces.", "danger")
            return redirect(url_for("register_parent"))
        
        # Check for duplicate email
        conn = get_db_conn()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            cursor.close()
            conn.close()
            flash("An account with this email already exists.", "danger")
            return redirect(url_for("register_parent"))

        cursor.close()
        conn.close()

        hashed_password = bcrypt.generate_password_hash(password).decode("utf-8")

        conn = get_db_conn()
        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO users (name, email, password, role)
            VALUES (%s, %s, %s, 'parent')
            """,
            (name, email, hashed_password),
        )
        conn.commit()
        cursor.close()
        conn.close()

        flash("Parent account created successfully. Please log in.", "success")
        return redirect(url_for("login"))

    return render_template("register_parent.html")


@app.route("/register/admin", methods=["GET", "POST"])
def register_admin():
    if request.method == "POST":
        key = request.form.get("admin_passkey", "").strip()
        if key != ADMIN_PASSKEY:
            flash("Invalid admin key.", "danger")
            return redirect(url_for("register_admin"))

        name = request.form["name"]
        email = request.form["email"]
        password = request.form["password"]
        confirm_password = request.form.get("confirm_password", "")

        if not all([name, email, password, confirm_password, key]):
            flash("Please fill all fields", "warning")
            return redirect(url_for('register_admin'))

        if password != confirm_password:
            flash("Passwords do not match.", "danger")
            return redirect(url_for("register_admin"))
        
        # Check for duplicate email
        conn = get_db_conn()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
        existing_user = cursor.fetchone()

        if existing_user:
            cursor.close()
            conn.close()
            flash("An account with this email already exists.", "danger")
            return redirect(url_for("register_admin"))

        cursor.close()
        conn.close()

        # Validate name contains only alphabet letters
        if not is_valid_name(name):
            flash("Name must contain only alphabet letters and spaces.", "danger")
            return redirect(url_for("register_admin"))
        
        if not EMAIL_REGEX.match(email):
            flash("Please enter a valid email address.", "danger")
            return redirect(url_for("register_admin"))
        
        if not is_strong_password(password):
            flash("Password must be at least 8 characters long and include one uppercase letter, one lowercase letter, and one symbol.", "warning")
            return redirect(url_for('register_admin'))

        hashed_password = bcrypt.generate_password_hash(password).decode("utf-8")

        conn = get_db_conn()
        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO users (name, email, password, role)
            VALUES (%s, %s, %s, 'admin')
            """,
            (name, email, hashed_password),
        )
        conn.commit()
        cursor.close()
        conn.close()

        flash("Admin account created successfully. Please log in.", "success")
        return redirect(url_for("login"))

    return render_template("register_admin.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"].strip().lower()
        password = request.form["password"]

        conn = get_db_conn()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT id, name, email, password, role, is_active, deleted_at FROM users WHERE email = %s",
            (email,),
        )
        user = cursor.fetchone()

        if user and bcrypt.check_password_hash(user["password"], password):
            # Check if account has been deleted
            if user.get("deleted_at"):
                flash("Your account has been deleted. Please contact an administrator to restore it.", "danger")
                cursor.close()
                conn.close()
                return redirect(url_for("login"))

            # Check if account is active
            if not user.get("is_active", 1):
                flash("Your account has been deactivated. Please contact an administrator.", "danger")
                cursor.close()
                conn.close()
                return redirect(url_for("login"))

            # Update last_login timestamp and reactivate account
            cursor.execute(
                "UPDATE users SET last_login = %s, is_active = 1, inactive_warning_sent = NULL WHERE id = %s",
                (datetime.now(), user["id"])
            )
            conn.commit()
            cursor.close()
            conn.close()

            user_obj = User(
                user["id"], user["name"], user["email"], user["role"]
            )

            # Regenerate session to prevent session fixation attacks
            session.clear()
            session.regenerate = True

            login_user(user_obj)

            # Role-based session configuration
            if normalize_role(user_obj.role) == "parent":
                # Parents get 30-minute timeout
                session.permanent = True
                session['last_activity'] = datetime.now().isoformat()
            else:
                # Admins get no timeout
                session.permanent = True

            flash("Logged in successfully.", "success")

            if normalize_role(user_obj.role) == "admin":
                return redirect(url_for("admin_dashboard"))
            else:
                return redirect(url_for("profile"))

        # Close connection if authentication fails
        if cursor:
            cursor.close()
        if conn:
            conn.close()
        flash("Invalid credentials.", "danger")
        return redirect(url_for("login"))

    return render_template("login.html")


@app.route("/logout")
@login_required
def logout():
    # Clear all session data
    session.clear()
    logout_user()
    flash("You have been logged out.", "info")
    return redirect(url_for("login"))

def build_external_url(endpoint, **values):
    """Safely build external URLs even when no request context is active."""
    if has_request_context():
        return url_for(endpoint, _external=True, **values)

    base_url = None
    server_name = app.config.get("SERVER_NAME")
    if server_name:
        scheme = app.config.get("PREFERRED_URL_SCHEME", "http")
        base_url = f"{scheme}://{server_name}"

    with app.test_request_context(base_url=base_url):
        return url_for(endpoint, _external=True, **values)

def send_reset_email(to_email, token):
    reset_url = url_for("reset_password", token=token, _external=True)
    msg = Message("ChildGrowth Insights - Password Reset", recipients=[to_email])

    msg.body = f"""
To reset your password for ChildGrowth Insights, click the link below (valid for 1 hour):

{reset_url}

If you didn't request this, you can safely ignore this email.
"""

    msg.html = f"""
<html>
  <body style="font-family: Arial, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0;">
    <table width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center" style="padding: 30px 0;">
          <table width="600" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
            <tr>
              <td style="background: #0d6efd; padding: 20px; text-align: center; color: #ffffff; font-size: 22px; font-weight: bold;">
                ChildGrowth Insights
              </td>
            </tr>
            <tr>
              <td style="padding: 30px; color: #333333; font-size: 16px;">
                <p>Hello,</p>
                <p>We received a request to reset your password for your <strong>ChildGrowth Insights</strong> account.</p>
                <p>Click the button below to reset it. This link is valid for <strong>1 hour</strong>:</p>
                <p style="text-align: center; margin: 30px 0;">
                  <a href="{reset_url}" style="background: #0d6efd; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 6px; font-weight: bold; display: inline-block;">
                    Reset Password
                  </a>
                </p>
                <p>If you did not request this, you can safely ignore this email.</p>
                <p>Best regards,<br><strong>ChildGrowth Insights Team</strong></p>
              </td>
            </tr>
            <tr>
              <td style="background: #f4f6f8; text-align: center; padding: 15px; font-size: 12px; color: #888888;">
                &copy; 2025 ChildGrowth Insights. All rights reserved.
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
"""
    mail.send(msg)


def send_inactivity_warning_email(to_email, user_name, days_until_deletion):
    """Send warning email to user about upcoming account deletion due to inactivity"""
    login_url = build_external_url("login")
    msg = Message(
        "ChildGrowth Insights - Account Inactivity Warning",
        recipients=[to_email]
    )

    msg.body = f"""
Hello {user_name},

We noticed that you haven't logged into your ChildGrowth Insights account in a while.

Your account will be automatically deleted in {days_until_deletion} days due to inactivity (30 days without login).

To keep your account active, simply log in:
{login_url}

If you have any questions or concerns, please contact our support team.

Best regards,
ChildGrowth Insights Team
"""

    msg.html = f"""
<html>
  <body style="font-family: Arial, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0;">
    <table width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center" style="padding: 30px 0;">
          <table width="600" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
            <tr>
              <td style="background: #ffc107; padding: 20px; text-align: center; color: #000000; font-size: 22px; font-weight: bold;">
                ⚠️ Account Inactivity Warning
              </td>
            </tr>
            <tr>
              <td style="padding: 30px; color: #333333; font-size: 16px;">
                <p>Hello <strong>{user_name}</strong>,</p>
                <p>We noticed that you haven't logged into your <strong>ChildGrowth Insights</strong> account in a while.</p>
                <p style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;">
                  <strong>⏰ Your account will be automatically deleted in {days_until_deletion} days</strong> due to inactivity (30 days without login).
                </p>
                <p>To keep your account active and prevent deletion, simply log in:</p>
                <p style="text-align: center; margin: 30px 0;">
                  <a href="{login_url}" style="background: #0d6efd; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 6px; font-weight: bold; display: inline-block;">
                    Log In Now
                  </a>
                </p>
                <p>If you have any questions or concerns, please contact our support team.</p>
                <p>Best regards,<br><strong>ChildGrowth Insights Team</strong></p>
              </td>
            </tr>
            <tr>
              <td style="background: #f4f6f8; text-align: center; padding: 15px; font-size: 12px; color: #888888;">
                &copy; 2025 ChildGrowth Insights. All rights reserved.
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
"""
    mail.send(msg)


def send_final_warning_email(to_email, user_name, days_until_deletion):
    """Send final warning email before account deletion"""
    login_url = build_external_url("login")
    msg = Message(
        f"ChildGrowth Insights - URGENT: Account Deletion in {days_until_deletion} Days",
        recipients=[to_email]
    )

    msg.body = f"""
Hello {user_name},

URGENT: Your ChildGrowth Insights account will be permanently deleted in {days_until_deletion} days!

This is your final warning. Your account has been inactive for nearly 30 days.

To prevent deletion and keep all your data, log in immediately:
{login_url}

Once deleted, all your children's data, assessments, and progress records will be permanently lost and cannot be recovered.

Please act now to save your account.

Best regards,
ChildGrowth Insights Team
"""

    msg.html = f"""
<html>
  <body style="font-family: Arial, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0;">
    <table width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center" style="padding: 30px 0;">
          <table width="600" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
            <tr>
              <td style="background: #dc3545; padding: 20px; text-align: center; color: #ffffff; font-size: 22px; font-weight: bold;">
                🚨 URGENT: Account Deletion Warning
              </td>
            </tr>
            <tr>
              <td style="padding: 30px; color: #333333; font-size: 16px;">
                <p>Hello <strong>{user_name}</strong>,</p>
                <p><strong style="color: #dc3545; font-size: 18px;">URGENT: Your account will be permanently deleted in {days_until_deletion} days!</strong></p>
                <p style="background: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;">
                  This is your <strong>final warning</strong>. Your <strong>ChildGrowth Insights</strong> account has been inactive for nearly 30 days.
                </p>
                <p>To prevent deletion and keep all your data, log in immediately:</p>
                <p style="text-align: center; margin: 30px 0;">
                  <a href="{login_url}" style="background: #dc3545; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 6px; font-weight: bold; display: inline-block;">
                    Log In Now to Save Account
                  </a>
                </p>
                <p style="background: #fff3cd; padding: 15px; border-radius: 6px;">
                  ⚠️ <strong>Important:</strong> Once deleted, all your children's data, assessments, and progress records will be <strong>permanently lost</strong> and cannot be recovered.
                </p>
                <p>Please act now to save your account.</p>
                <p>Best regards,<br><strong>ChildGrowth Insights Team</strong></p>
              </td>
            </tr>
            <tr>
              <td style="background: #f4f6f8; text-align: center; padding: 15px; font-size: 12px; color: #888888;">
                &copy; 2025 ChildGrowth Insights. All rights reserved.
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
"""
    mail.send(msg)


def send_deletion_confirmation_email(to_email, user_name):
    """Send confirmation email after account has been deleted"""
    msg = Message(
        "ChildGrowth Insights - Account Deleted",
        recipients=[to_email]
    )

    msg.body = f"""
Hello {user_name},

Your ChildGrowth Insights account has been permanently deleted due to 30 days of inactivity.

All your data, including children's profiles, assessments, and progress records, has been removed from our system.

If you believe this was done in error or would like to create a new account, please contact our support team.

Thank you for using ChildGrowth Insights.

Best regards,
ChildGrowth Insights Team
"""

    msg.html = f"""
<html>
  <body style="font-family: Arial, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0;">
    <table width="100%" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center" style="padding: 30px 0;">
          <table width="600" cellpadding="0" cellspacing="0" style="background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
            <tr>
              <td style="background: #6c757d; padding: 20px; text-align: center; color: #ffffff; font-size: 22px; font-weight: bold;">
                Account Deleted
              </td>
            </tr>
            <tr>
              <td style="padding: 30px; color: #333333; font-size: 16px;">
                <p>Hello <strong>{user_name}</strong>,</p>
                <p>Your <strong>ChildGrowth Insights</strong> account has been permanently deleted due to 30 days of inactivity.</p>
                <p style="background: #e2e3e5; border-left: 4px solid #6c757d; padding: 15px; margin: 20px 0;">
                  All your data, including children's profiles, assessments, and progress records, has been removed from our system.
                </p>
                <p>If you believe this was done in error or would like to create a new account, please contact our support team.</p>
                <p>Thank you for using ChildGrowth Insights.</p>
                <p>Best regards,<br><strong>ChildGrowth Insights Team</strong></p>
              </td>
            </tr>
            <tr>
              <td style="background: #f4f6f8; text-align: center; padding: 15px; font-size: 12px; color: #888888;">
                &copy; 2025 ChildGrowth Insights. All rights reserved.
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
"""
    mail.send(msg)


def check_inactive_users():
    """
    Automated function to check for inactive PARENT users and take action:
    - 23+ days: Send first warning (7 days until deletion)
    - 28+ days: Send final warning (2 days until deletion)
    - 30+ days: Delete account (unless protected)

    NOTE: Admin accounts are EXCLUDED from automatic deletion.
    This function should be called daily by a cron job or scheduler.
    """
    from datetime import datetime, timedelta

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    now = datetime.now()
    warning_threshold = now - timedelta(days=23)  # 7 days before deletion
    final_warning_threshold = now - timedelta(days=28)  # 2 days before deletion
    deletion_threshold = now - timedelta(days=30)  # Delete after 30 days

    # Track statistics
    stats = {
        'warnings_sent': 0,
        'final_warnings_sent': 0,
        'accounts_deleted': 0,
        'errors': []
    }

    try:
        # 1. Find PARENT users who need first warning (23+ days inactive, no warning sent yet)
        cursor.execute("""
            SELECT id, name, email, last_login
            FROM users
            WHERE role = 'parent'
            AND is_active = 1
            AND protected_from_deletion = 0
            AND deleted_at IS NULL
            AND last_login IS NOT NULL
            AND last_login <= %s
            AND inactive_warning_sent IS NULL
        """, (warning_threshold,))

        users_for_warning = cursor.fetchall()
        for user in users_for_warning:
            try:
                send_inactivity_warning_email(user['email'], user['name'], 7)
                cursor.execute(
                    "UPDATE users SET inactive_warning_sent = %s WHERE id = %s",
                    (now, user['id'])
                )
                conn.commit()
                stats['warnings_sent'] += 1
            except Exception as e:
                stats['errors'].append(f"Error sending warning to {user['email']}: {str(e)}")

        # 2. Find PARENT users who need final warning (28+ days inactive, warning already sent)
        cursor.execute("""
            SELECT id, name, email, last_login
            FROM users
            WHERE role = 'parent'
            AND is_active = 1
            AND protected_from_deletion = 0
            AND deleted_at IS NULL
            AND last_login IS NOT NULL
            AND last_login <= %s
            AND inactive_warning_sent IS NOT NULL
        """, (final_warning_threshold,))

        users_for_final_warning = cursor.fetchall()
        for user in users_for_final_warning:
            try:
                send_final_warning_email(user['email'], user['name'], 2)
                stats['final_warnings_sent'] += 1
            except Exception as e:
                stats['errors'].append(f"Error sending final warning to {user['email']}: {str(e)}")

        # 3. Find and soft-delete PARENT users inactive for 30+ days (not protected)
        cursor.execute("""
            SELECT id, name, email, last_login
            FROM users
            WHERE role = 'parent'
            AND is_active = 1
            AND protected_from_deletion = 0
            AND deleted_at IS NULL
            AND last_login IS NOT NULL
            AND last_login <= %s
        """, (deletion_threshold,))

        users_for_deletion = cursor.fetchall()
        for user in users_for_deletion:
            try:
                # Send deletion confirmation email before soft-deleting
                send_deletion_confirmation_email(user['email'], user['name'])

                # Soft delete user (mark as deleted instead of actually deleting)
                cursor.execute("""
                    UPDATE users
                    SET deleted_at = %s,
                        deletion_reason = 'Inactive for 30+ days',
                        is_active = 0
                    WHERE id = %s
                """, (now, user['id']))
                conn.commit()
                stats['accounts_deleted'] += 1
            except Exception as e:
                stats['errors'].append(f"Error soft-deleting user {user['email']}: {str(e)}")
                conn.rollback()

        # 4. Also check for PARENT users who have never logged in and were created 30+ days ago
        cursor.execute("""
            SELECT id, name, email, created_at
            FROM users
            WHERE role = 'parent'
            AND is_active = 1
            AND protected_from_deletion = 0
            AND deleted_at IS NULL
            AND last_login IS NULL
            AND created_at <= %s
        """, (deletion_threshold,))

        never_logged_in_users = cursor.fetchall()
        for user in never_logged_in_users:
            try:
                send_deletion_confirmation_email(user['email'], user['name'])
                # Soft delete user who never logged in
                cursor.execute("""
                    UPDATE users
                    SET deleted_at = %s,
                        deletion_reason = 'Never logged in - account created 30+ days ago',
                        is_active = 0
                    WHERE id = %s
                """, (now, user['id']))
                conn.commit()
                stats['accounts_deleted'] += 1
            except Exception as e:
                stats['errors'].append(f"Error soft-deleting never-logged-in user {user['email']}: {str(e)}")
                conn.rollback()

    finally:
        cursor.close()
        conn.close()

    return stats


def permanently_delete_old_accounts():
    """
    Permanently delete soft-deleted accounts after 90 days.
    This provides a grace period for account recovery before permanent deletion.

    Returns statistics about the operation.
    """
    from datetime import datetime, timedelta

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    now = datetime.now()
    permanent_deletion_threshold = now - timedelta(days=90)

    stats = {
        'permanently_deleted': 0,
        'errors': []
    }

    try:
        # Find soft-deleted accounts older than 90 days
        cursor.execute("""
            SELECT id, name, email, deleted_at, deletion_reason
            FROM users
            WHERE deleted_at IS NOT NULL
            AND deleted_at <= %s
        """, (permanent_deletion_threshold,))

        old_deleted_accounts = cursor.fetchall()

        for user in old_deleted_accounts:
            try:
                # Permanently delete the user (cascade will handle related data)
                cursor.execute("DELETE FROM users WHERE id = %s", (user['id'],))
                conn.commit()
                stats['permanently_deleted'] += 1
                app.logger.info(f"Permanently deleted account: {user['email']} (soft-deleted on {user['deleted_at']})")
            except Exception as e:
                stats['errors'].append(f"Error permanently deleting user {user['email']}: {str(e)}")
                conn.rollback()

    finally:
        cursor.close()
        conn.close()

    return stats


# -------------------------------------------------
# SCHEDULED TASKS (APScheduler)
# -------------------------------------------------
@scheduler.task('cron', id='cleanup_inactive_users', hour=2, minute=0)
def scheduled_cleanup_inactive_users():
    """
    Scheduled task to run inactive user cleanup daily at 2:00 AM UTC.
    This runs automatically when the Flask app is running.
    """
    with app.app_context():
        try:
            stats = check_inactive_users()
            app.logger.info(f"Scheduled cleanup completed: {stats}")
        except Exception as e:
            app.logger.error(f"Scheduled cleanup failed: {e}")
            import traceback
            traceback.print_exc()


@scheduler.task('cron', id='permanent_deletion', hour=3, minute=0)
def scheduled_permanent_deletion():
    """
    Scheduled task to permanently delete soft-deleted accounts after 90 days.
    Runs daily at 3:00 AM UTC (1 hour after soft delete cleanup).
    """
    with app.app_context():
        try:
            stats = permanently_delete_old_accounts()
            app.logger.info(f"Permanent deletion completed: {stats}")
        except Exception as e:
            app.logger.error(f"Permanent deletion failed: {e}")
            import traceback
            traceback.print_exc()


@app.route("/forgot", methods=["GET", "POST"])
def forgot():
    if request.method == "POST":
        email = request.form["email"].strip().lower()
        conn = get_db_conn()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()
        if user:
            token = serializer.dumps(email, salt="password-reset-salt")
            send_reset_email(email, token)
        flash("If email exists, a reset link has been sent.", "info")
        return redirect(url_for("login"))
    return render_template("forgot.html")


@app.route("/reset/<token>", methods=["GET", "POST"])
def reset_password(token):
    try:
        email = serializer.loads(
            token, salt="password-reset-salt", max_age=3600
        )
    except Exception:
        flash("The reset link is invalid or expired.", "danger")
        return redirect(url_for("forgot"))

    if request.method == "POST":
        new_password = request.form["password"]
        confirm_password = request.form.get("confirm_password", "")

        if new_password != confirm_password:
            flash(
                "New password and confirmation do not match.", "danger"
            )
            return redirect(url_for("reset_password", token=token))
            
        if not is_strong_password(new_password):
            flash(
                "Password must be at least 8 characters long and include one uppercase letter, one lowercase letter, and one symbol.",

                "warning"
            )
            return redirect(url_for("reset_password", token=token))

        hashed = bcrypt.generate_password_hash(new_password).decode("utf-8")
        conn = get_db_conn()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE users SET password = %s WHERE email = %s",
            (hashed, email),
        )
        conn.commit()
        cursor.close()
        conn.close()
        flash("Your password has been updated. Please log in.", "success")
        return redirect(url_for("login"))

    return render_template("reset.html")


# -------------------------------------------------
# DASHBOARD & CHILD SELECTION
# -------------------------------------------------
@app.route("/select-child", methods=["GET", "POST"])
@login_required
def select_child():
    if normalize_role(current_user.role) == "admin":
        flash(
            "Admins cannot select a child profile. Please use the admin dashboard.",
            "warning",
        )
        return redirect(url_for("admin_dashboard"))
        
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT * FROM children WHERE parent_id=%s", (current_user.id,)
    )
    children = cursor.fetchall()
    cursor.close()
    conn.close()

    if request.method == "POST":
        child_id = request.form.get("child_id")
        if child_id:
            session["selected_child"] = child_id
            return redirect(url_for("dashboard"))
        flash("Please choose a child.", "warning")

    return render_template("select_child.html", children=children)


@app.route("/dashboard")
@login_required
def dashboard():
    if "selected_child" not in session:
        return redirect(url_for("select_child"))

    child_id = session["selected_child"]

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    selected_child = cursor.fetchone()
    if not selected_child:
        flash("Child not found.", "danger")
        cursor.close()
        conn.close()
        return redirect(url_for("select_child"))

    cursor.execute(
        "SELECT * FROM academic_scores WHERE child_id=%s ORDER BY date ASC",
        (child_id,),
    )
    scores = cursor.fetchall()
    subjects = sorted({row["subject"] for row in scores})
    for row in scores:
        if isinstance(row["date"], (datetime, date)):
            row["date_str"] = row["date"].strftime("%Y-%m")
        else:
            row["date_str"] = str(row["date"])[:7]

    cursor.execute(
        """
        SELECT module, result, updated_at
        FROM ai_results
        WHERE child_id=%s
          AND module IN ('preschool', 'learning', 'tutoring')
        """,
        (child_id,),
    )
    ai_results = cursor.fetchall()
    ai_map = {r["module"]: r for r in ai_results}

    preschool_ai = ai_map.get("preschool", {}).get(
        "result", "<p class='text-muted'>No preschool analysis yet.</p>"
    )
    learning_ai = ai_map.get("learning", {}).get(
        "result", "<p class='text-muted'>No learning style analysis yet.</p>"
    )
    tutoring_ai = ai_map.get("tutoring", {}).get(
        "result", "<p class='text-muted'>No tutoring recommendations yet.</p>"
    )

    cursor.close()
    conn.close()

    return render_template(
        "dashboard.html",
        content_template="dashboard/_dashboard.html",
        selected_child=selected_child,
        scores=scores,
        subjects=subjects,
        preschool=[preschool_ai],
        learning=[learning_ai],
        tutoring=[tutoring_ai],
        active="dashboard",
    )


# -------------------------------------------------
# CHILDREN (standalone page)
# -------------------------------------------------
@app.route("/children", methods=["GET", "POST"])
@login_required
def children():
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST":
        name = request.form["name"]
        dob = request.form["dob"]
        age_input = request.form["age"]
        grade_level = request.form["grade_level"]
        gender = request.form["gender"]
        notes = request.form.get("notes", "")

        try:
            age = int(age_input)
        except ValueError:
            flash("Age must be a number between 1 and 6.", "danger")
            cursor.execute(
                "SELECT * FROM children WHERE parent_id=%s", (current_user.id,)
            )
            children_list = cursor.fetchall()
            cursor.close()
            conn.close()
            return render_template("select_child.html", children=children_list)

        if age < 1 or age > 6:
            flash("Age must be between 1 and 6.", "danger")
            cursor.execute(
                "SELECT * FROM children WHERE parent_id=%s", (current_user.id,)
            )
            children_list = cursor.fetchall()
            cursor.close()
            conn.close()
            return render_template("select_child.html", children=children_list)

        # Validate name contains only alphabet letters
        if not is_valid_name(name):
            flash("Child name must contain only alphabet letters and spaces.", "danger")
            cursor.execute(
                "SELECT * FROM children WHERE parent_id=%s", (current_user.id,)
            )
            children_list = cursor.fetchall()
            cursor.close()
            conn.close()
            return render_template("select_child.html", children=children_list)
        
        
        # Validate date of birth
        is_valid, error_msg = is_valid_dob(dob)
        if not is_valid:
            flash(error_msg, "danger")
            cursor.execute(
                "SELECT * FROM children WHERE parent_id=%s", (current_user.id,)
            )

            children_list = cursor.fetchall()
            cursor.close()
            conn.close()
            return render_template("select_child.html", children=children_list)

        cursor.execute(
            """
            INSERT INTO children
            (parent_id, name, dob, age, grade_level, gender, notes)
            VALUES (%s,%s,%s,%s,%s,%s,%s)
            """,
            (current_user.id, name, dob, age, grade_level, gender, notes),
        )
        conn.commit()
        flash("Child profile added!", "success")
        cursor.close()
        conn.close()
        return redirect(url_for("children"))

    cursor.execute(
        "SELECT * FROM children WHERE parent_id=%s", (current_user.id,)
    )
    children_rows = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template("children.html", children=children_rows)


# -------------------------------------------------
# PROFILE (no test management here anymore)
# -------------------------------------------------
@app.route("/profile", methods=["GET", "POST"])
@login_required
def profile():
    from datetime import datetime, timedelta

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM users WHERE id=%s", (current_user.id,))
    user = cursor.fetchone()

    cursor.execute(
        "SELECT * FROM children WHERE parent_id=%s", (current_user.id,)
    )
    children = cursor.fetchall()

    # Calculate inactivity warning
    inactivity_warning = None
    if user and user.get('last_login'):
        now = datetime.now()
        last_login = user['last_login']
        if isinstance(last_login, str):
            last_login = datetime.fromisoformat(last_login)
        days_inactive = (now - last_login).days

        if days_inactive >= 23 and not user.get('protected_from_deletion'):
            days_until_deletion = 30 - days_inactive
            if days_until_deletion > 0:
                inactivity_warning = {
                    'days_inactive': days_inactive,
                    'days_until_deletion': days_until_deletion,
                    'is_critical': days_inactive >= 28
                }
            elif days_until_deletion <= 0:
                inactivity_warning = {
                    'days_inactive': days_inactive,
                    'days_until_deletion': 0,
                    'is_critical': True
                }

    cursor.close()
    conn.close()

    # tests removed from profile in Option A – just pass empty list
    return render_template(
        "profile.html",
        user=user,
        children=children,
        tests=[],
        inactivity_warning=inactivity_warning
    )

@app.route("/admin/profile")
@roles_required("admin")
def admin_profile():
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM users WHERE id=%s", (current_user.id,))
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template("admin/profile.html", user=user)

@app.route("/profile/edit", methods=["POST"])
@login_required
def edit_profile():
    name = request.form["name"].strip()
    email = request.form["email"].strip().lower()

    # Validate name contains only alphabet letters
    if not is_valid_name(name):
        flash("Name must contain only alphabet letters and spaces.", "danger")
        return redirect(url_for("profile"))

    if not EMAIL_REGEX.match(email):
        flash("Please enter a valid email address.", "danger")
        return redirect(url_for("profile"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT id FROM users WHERE email = %s AND id != %s",
        (email, current_user.id),
    )
    existing_user = cursor.fetchone()

    if existing_user:
        cursor.close()
        conn.close()
        flash("An account with this email already exists.", "danger")
        return redirect(url_for("profile"))
    
    cursor.close()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE users SET name=%s, email=%s WHERE id=%s",
        (name, email, current_user.id),
    )
    conn.commit()
    cursor.close()
    conn.close()

    flash("Profile updated successfully.", "success")
    return redirect(url_for("profile"))


@app.route("/profile/child/add", methods=["POST"])
@login_required
def add_child():
    name = request.form["name"]
    dob = request.form["dob"]
    age_input = request.form["age"]
    grade_level = request.form["grade_level"]
    gender = request.form["gender"]
    notes = request.form.get("notes", "")

    try:
        age = int(age_input)
    except ValueError:
        flash("Age must be a number between 1 and 6.", "danger")
        return redirect(url_for("profile"))

    if age < 1 or age > 6:
        flash("Age must be between 1 and 6.", "danger")
        return redirect(url_for("profile"))

    # Validate name contains only alphabet letters
    if not is_valid_name(name):
        flash("Child name must contain only alphabet letters and spaces.", "danger")
        return redirect(url_for("profile"))
    
    # Validate grade level contains only alphanumeric characters
    if not is_valid_grade_level(grade_level):
        flash("Grade level must contain only letters, numbers, hyphens, and spaces (e.g., A, K1, Pre-K).", "danger")
        return redirect(url_for("profile"))
    
    # Validate date of birth
    is_valid, error_msg = is_valid_dob(dob)
    if not is_valid:

        flash(error_msg, "danger")
        return redirect(url_for("profile"))

    conn = get_db_conn()
    cursor = conn.cursor()
    cursor.execute(
        """
        INSERT INTO children
        (parent_id, name, dob, age, grade_level, gender, notes)
        VALUES (%s,%s,%s,%s,%s,%s,%s)
        """,
        (current_user.id, name, dob, age, grade_level, gender, notes),
    )
    conn.commit()
    cursor.close()
    conn.close()

    flash("Child profile added!", "success")
    return redirect(url_for("profile"))


@app.route("/profile/child/delete/<int:child_id>", methods=["POST"])
@login_required
def delete_child(child_id):
    conn = get_db_conn()
    cursor = conn.cursor()
    cursor.execute(
        "DELETE FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    conn.commit()
    cursor.close()
    conn.close()

    flash("Child profile deleted.", "info")
    return redirect(url_for("profile"))


@app.route("/profile/child/edit/<int:child_id>", methods=["POST"])
@login_required
def edit_child(child_id):
    name = request.form["name"]
    dob = request.form["dob"]
    age_input = request.form["age"]
    grade_level = request.form["grade_level"]
    gender = request.form["gender"]
    notes = request.form.get("notes", "")

    try:
        age = int(age_input)
    except ValueError:
        flash("Age must be a number between 1 and 6.", "danger")
        return redirect(url_for("profile"))

    if age < 1 or age > 6:
        flash("Age must be between 1 and 6.", "danger")
        return redirect(url_for("profile"))

    # Validate name contains only alphabet letters
    if not is_valid_name(name):
        flash("Child name must contain only alphabet letters and spaces.", "danger")
        return redirect(url_for("profile"))
    # Validate grade level contains only alphanumeric characters

    if not is_valid_grade_level(grade_level):
        flash("Grade level must contain only letters, numbers, hyphens, and spaces (e.g., A, K1, Pre-K).", "danger")
        return redirect(url_for("profile"))

# Validate date of birth
    is_valid, error_msg = is_valid_dob(dob)
    if not is_valid:
        flash(error_msg, "danger")
        return redirect(url_for("profile"))
    
    conn = get_db_conn()
    cursor = conn.cursor()
    cursor.execute(
        """
        UPDATE children
        SET name=%s, dob=%s, age=%s, grade_level=%s, gender=%s, notes=%s
        WHERE id=%s AND parent_id=%s
        """,
        (
            name,
            dob,
            age,
            grade_level,
            gender,
            notes,
            child_id,
            current_user.id,
        ),
    )
    conn.commit()
    cursor.close()
    conn.close()

    flash("Child profile updated!", "success")
    return redirect(url_for("profile"))


# -------------------------------------------------
# ACADEMIC
# -------------------------------------------------
@app.route("/academic", methods=["GET", "POST"])
@login_required
def academic_progress():
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("select_child"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST":
        subject = request.form.get("subject")
        score = request.form.get("score", type=int)
        year = request.form.get("year", type=int)
        month = request.form.get("month", type=int)

        if subject and score is not None and year and month:
            # Validate score range
            if not (0 <= score <= 100):
                flash("Score must be between 0 and 100.", "danger")
                cursor.close()
                conn.close()
                return redirect(url_for("academic_progress"))

            # Validate academic date
            is_valid, error_msg = is_valid_academic_date(year, month)
            if not is_valid:
                flash(error_msg, "danger")
                cursor.close()
                conn.close()
                return redirect(url_for("academic_progress"))

            # All validations passed, insert record
            record_date = date(year, month, 1)
            cursor.execute(
                """
                INSERT INTO academic_scores (child_id, subject, score, date)
                VALUES (%s, %s, %s, %s)
                """,
                (child_id, subject, score, record_date),
            )
            conn.commit()
            flash("Academic record added successfully!", "success")
        else:
            flash("Please fill all required fields.", "danger")

        cursor.close()
        conn.close()
        return redirect(url_for("academic_progress"))

    cursor.execute(
        "SELECT * FROM academic_scores WHERE child_id = %s ORDER BY date ASC",
        (child_id,),
    )
    scores = cursor.fetchall()
    for row in scores:
        row["date_str"] = row["date"].strftime("%Y-%m")
        row["year"] = row["date"].year

    # Define default subjects for preschool
    default_subjects = [
        "English",
        "Chinese",
        "Malay",
        "Mathematics",
        "Science"
    ]

    # Merge default subjects with user's existing subjects
    user_subjects = {row["subject"] for row in scores}
    subjects = default_subjects + [s for s in user_subjects if s not in default_subjects]

    # Build yearly records and averages
    years = sorted({row["year"] for row in scores}, reverse=True)
    selected_year = request.args.get("year", type=int)

    if years and (selected_year is None or selected_year not in years):
        selected_year = years[0]

    display_scores = scores
    if selected_year:
        display_scores = [row for row in scores if row["year"] == selected_year]

    yearly_records = []
    overall_avg = None
    subject_year_avgs = {}

    if selected_year:
        yearly_records = sorted(
            [row for row in scores if row["year"] == selected_year],
            key=lambda r: r["date"],
        )

        if yearly_records:
            overall_avg = round(
                sum(r["score"] for r in yearly_records) / len(yearly_records),
                1,
            )
            subject_scores = {}
            for record in yearly_records:
                subject_scores.setdefault(record["subject"], []).append(record["score"])

            subject_year_avgs = {
                sub: round(sum(vals) / len(vals), 1) for sub, vals in subject_scores.items()
            }


    cursor.close()
    conn.close()

    return render_template(
        "dashboard.html",
        content_template="dashboard/_academic.html",
        selected_child={"id": child_id},
        scores=display_scores,
        subjects=subjects,
        years=years,
        selected_year=selected_year,
        yearly_records=yearly_records,
        overall_avg=overall_avg,
        subject_year_avgs=subject_year_avgs,
        active="academic",
    )

@app.route("/academic/delete/<int:id>", methods=["POST"])
@login_required
def delete_academic(id):
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("academic_progress"))

    conn = get_db_conn()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM academic_scores WHERE id = %s", (id,))
    conn.commit()
    cursor.close()
    conn.close()
    flash("Academic record deleted successfully.", "success")
    return redirect(url_for("academic_progress"))


# -------------------------------------------------
# PRESCHOOL
# -------------------------------------------------
def calculate_months_difference(start_date, end_date):
    return (end_date.year - start_date.year) * 12 + (
        end_date.month - start_date.month
    )


@app.route("/dashboard/preschool", methods=["GET", "POST"])
@login_required
def preschool_tracker():
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("dashboard"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM children WHERE id=%s", (child_id,))
    child = cursor.fetchone()
    if not child:
        flash("Child not found.", "danger")
        cursor.close()
        conn.close()
        return redirect(url_for("dashboard"))

    child_info = (
        f"Name: {child['name']}, Gender: {child['gender']}, "
        f"Date of Birth: {child['dob']}, Grade Level: {child['grade_level']}"
    )

    if request.method == "POST" and "domain" in request.form:
        domain = request.form.get("domain", "").strip()
        description = request.form.get("description", "").strip()
        form_date = request.form.get("date", "").strip()

        # Server-side validation
        valid_domains = [
            "Social/Emotional Milestones",
            "Cognitive Milestones",
            "Language/Communication",
            "Movement/Physical Development"
        ]

        if not domain or domain not in valid_domains:
            flash("Invalid domain selected.", "danger")
            cursor.close()
            conn.close()
            return redirect(url_for("preschool_tracker"))

        if not description or len(description) > 500:
            flash("Description is required and must be less than 500 characters.", "danger")
            cursor.close()
            conn.close()
            return redirect(url_for("preschool_tracker"))

        if not form_date:
            flash("Date is required.", "danger")
            cursor.close()
            conn.close()
            return redirect(url_for("preschool_tracker"))

        formatted_date = f"{form_date}-01"

        try:
            cursor.execute(
                """
                INSERT INTO preschool_assessments (child_id, domain, description, date)
                VALUES (%s, %s, %s, %s)
                """,
                (child_id, domain, description, formatted_date),
            )
            conn.commit()
            flash("Assessment added successfully.", "success")
        except Exception as e:
            conn.rollback()
            flash(f"Error adding assessment: {str(e)}", "danger")
        finally:
            cursor.close()
            conn.close()
        return redirect(url_for("preschool_tracker"))

    cursor.execute(
        "SELECT * FROM preschool_assessments WHERE child_id=%s ORDER BY date DESC",
        (child_id,),
    )
    assessments = cursor.fetchall()

    dob = child.get("dob")
    if isinstance(dob, (datetime, date)):
        dob_dt = datetime.combine(dob, datetime.min.time())
    elif isinstance(dob, str):
        dob_dt = datetime.strptime(dob, "%Y-%m-%d")
    else:
        dob_dt = None

    for a in assessments:
        milestone_date = a.get("date")
        if isinstance(milestone_date, (datetime, date)):
            milestone_dt = datetime.combine(
                milestone_date, datetime.min.time()
            )
            a["date_str"] = milestone_dt.strftime("%Y-%m")
        elif isinstance(milestone_date, str):
            a["date_str"] = milestone_date[:7]
            milestone_dt = datetime.strptime(a["date_str"], "%Y-%m")
        else:
            milestone_dt = None
            a["date_str"] = "Unknown"

        a["age_months"] = (
            calculate_months_difference(dob_dt, milestone_dt)
            if dob_dt and milestone_dt
            else None
        )

    cursor.execute(
        "SELECT * FROM ai_results WHERE child_id=%s AND module='preschool' LIMIT 1",
        (child_id,),
    )
    ai_row = cursor.fetchone()

    data_payload = json.dumps(assessments, default=str)
    benchmark_summary = None
    last_generated = None
    use_cached = False

    if not assessments:
        benchmark_summary = (
            "<p class='text-muted'>No preschool milestone data available yet. "
            "Add some assessments to view AI analysis.</p>"
        )
    else:
        if ai_row and ai_row.get("data") == data_payload:
            benchmark_summary = ai_row["result"]
            last_generated = ai_row["updated_at"] or ai_row["created_at"]
            use_cached = True
        else:
            try:
                # Filter out assessments with None age_months to avoid "None months" in AI prompt
                valid_assessments = [a for a in assessments if a.get('age_months') is not None]

                if not valid_assessments:
                    benchmark_summary = (
                        "<p class='text-muted'>Unable to generate benchmark analysis. "
                        "Please ensure the child's date of birth is set correctly.</p>"
                    )
                else:
                    combined_text = "\n".join(
                        f"- {a['domain']}: {a['description']} (at {a['age_months']} months)"
                        for a in valid_assessments
                    )

                    prompt = f"""
                    You are an early childhood development expert.

                    This is the data of the child: {child_info}

                    The following are recorded preschool milestones for a child, including their age in months when achieved:
                    {combined_text}

                    Based on these milestones, compare the child's development to standard age-based benchmarks in {benchmark_df.shape[0]} developmental records (see attached data sample below).

                    {benchmark_df.to_string(index=False)}

                    Summarize in clear, short language:
                    - Areas that are age-appropriate
                    - Areas that are delayed
                    - Areas that are advanced for the child's age

                    Follow the below rules strictly:
                    - End with a one-sentence summary of overall development progress.
                    - Provide the summary in HTML styled.
                    - Do not self introduce yourself.
                    """

                    model = genai.GenerativeModel("gemini-2.5-flash")
                    response = model.generate_content(prompt)
                    benchmark_summary = response.text.strip()

                    if ai_row:
                        cursor.execute(
                            """
                            UPDATE ai_results
                            SET data=%s, result=%s, updated_at=NOW()
                            WHERE id=%s
                            """,
                            (data_payload, benchmark_summary, ai_row["id"]),
                        )
                    else:
                        cursor.execute(
                            """
                            INSERT INTO ai_results
                            (child_id, module, data, result, created_at, updated_at)
                            VALUES (%s, %s, %s, %s, NOW(), NOW())
                            """,
                            (
                                child_id,
                                "preschool",
                                data_payload,
                                benchmark_summary,
                            ),
                        )
                    conn.commit()

            except Exception as e:
                if "quota" in str(e).lower() or "api key" in str(e).lower():
                    benchmark_summary = (
                        "<p class='text-danger'>Your Google AI key has reached its usage limit or expired. "
                        "Please update your API key in Settings.</p>"
                    )
                else:
                    # Use HTML escaping to prevent HTML injection
                    from markupsafe import escape
                    benchmark_summary = (
                        f"<p class='text-danger'>(Error generating analysis: {escape(str(e))})</p>"
                    )

    cursor.close()
    conn.close()

    return render_template(
        "dashboard.html",
        content_template="dashboard/_preschool.html",
        selected_child=child,
        assessments=assessments,
        benchmark_summary=benchmark_summary,
        last_generated=last_generated,
        use_cached=use_cached,
        active="preschool",
    )


@app.route("/dashboard/preschool/regenerate", methods=["POST"])
@login_required
def regenerate_preschool_benchmark():
    child_id = session.get("selected_child")
    if not child_id:
        return jsonify({"error": "No child selected"}), 400

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM children WHERE id=%s", (child_id,))
    child = cursor.fetchone()
    if not child:
        cursor.close()
        conn.close()
        return jsonify({"error": "Child not found"}), 404

    child_info = (
        f"Name: {child['name']}, Gender: {child['gender']}, "
        f"Date of Birth: {child['dob']}, Grade Level: {child['grade_level']}"
    )

    cursor.execute(
        "SELECT * FROM preschool_assessments WHERE child_id=%s ORDER BY date DESC",
        (child_id,),
    )
    assessments = cursor.fetchall()

    if not assessments:
        cursor.close()
        conn.close()
        return jsonify({"error": "No assessment data available"}), 400

    dob = child.get("dob")
    if isinstance(dob, (datetime, date)):
        dob_dt = datetime.combine(dob, datetime.min.time())
    elif isinstance(dob, str):
        dob_dt = datetime.strptime(dob, "%Y-%m-%d")
    else:
        dob_dt = None

    for a in assessments:
        milestone_date = a.get("date")
        if isinstance(milestone_date, (datetime, date)):
            milestone_dt = datetime.combine(
                milestone_date, datetime.min.time()
            )
            a["date_str"] = milestone_dt.strftime("%Y-%m")
        elif isinstance(milestone_date, str):
            a["date_str"] = milestone_date[:7]
            milestone_dt = datetime.strptime(a["date_str"], "%Y-%m")
        else:
            milestone_dt = None
            a["date_str"] = "Unknown"

        a["age_months"] = (
            calculate_months_difference(dob_dt, milestone_dt)
            if dob_dt and milestone_dt
            else None
        )

    try:
        # Filter out assessments with None age_months to avoid "None months" in AI prompt
        valid_assessments = [a for a in assessments if a.get('age_months') is not None]

        if not valid_assessments:
            cursor.close()
            conn.close()
            return jsonify({"error": "Unable to generate benchmark analysis. Please ensure the child's date of birth is set correctly."}), 400

        combined_text = "\n".join(
            f"- {a['domain']}: {a['description']} (at {a['age_months']} months)"
            for a in valid_assessments
        )

        prompt = f"""
        You are an early childhood development expert.

        This is the data of the child: {child_info}

        The following are recorded preschool milestones for a child, including their age in months when achieved:
        {combined_text}

        Based on these milestones, compare the child's development to standard age-based benchmarks in {benchmark_df.shape[0]} developmental records (see attached data sample below).

        {benchmark_df.to_string(index=False)}

        Summarize in clear, short language:
        - Areas that are age-appropriate
        - Areas that are delayed
        - Areas that are advanced for the child's age

        Follow the below rules strictly:
        - End with a one-sentence summary of overall development progress.
        - Provide the summary in HTML styled.
        - Do not self introduce yourself.
        """

        model = genai.GenerativeModel("gemini-2.5-flash")
        response = model.generate_content(prompt)
        benchmark_summary = response.text.strip()

        data_payload = json.dumps(assessments, default=str)

        cursor.execute(
            "SELECT * FROM ai_results WHERE child_id=%s AND module='preschool' LIMIT 1",
            (child_id,),
        )
        ai_row = cursor.fetchone()

        if ai_row:
            cursor.execute(
                """
                UPDATE ai_results
                SET data=%s, result=%s, updated_at=NOW()
                WHERE id=%s
                """,
                (data_payload, benchmark_summary, ai_row["id"]),
            )
        else:
            cursor.execute(
                """
                INSERT INTO ai_results
                (child_id, module, data, result, created_at, updated_at)
                VALUES (%s, %s, %s, %s, NOW(), NOW())
                """,
                (child_id, "preschool", data_payload, benchmark_summary),
            )
        conn.commit()

        cursor.execute(
            "SELECT updated_at FROM ai_results WHERE child_id=%s AND module='preschool' LIMIT 1",
            (child_id,),
        )
        updated_row = cursor.fetchone()
        last_generated = updated_row["updated_at"].strftime("%Y-%m-%d %H:%M:%S") if updated_row and updated_row["updated_at"] else None

        cursor.close()
        conn.close()

        return jsonify({
            "success": True,
            "benchmark_summary": benchmark_summary,
            "last_generated": last_generated
        })

    except Exception as e:
        print(f"Error in regenerate_preschool_benchmark: {type(e).__name__}: {str(e)}")
        import traceback
        traceback.print_exc()
        cursor.close()
        conn.close()
        if "quota" in str(e).lower() or "api key" in str(e).lower():
            return jsonify({"error": "token_limit"}), 429
        return jsonify({"error": str(e)}), 500


@app.route("/preschool/delete/<int:id>", methods=["POST"])
@login_required
def delete_preschool(id):
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("dashboard"))

    conn = get_db_conn()
    cursor = conn.cursor()

    try:
        # Verify the record belongs to the current user's child before deleting
        cursor.execute(
            "DELETE FROM preschool_assessments WHERE id = %s AND child_id = %s",
            (id, child_id)
        )

        if cursor.rowcount == 0:
            flash("Record not found or unauthorized.", "danger")
        else:
            flash("Preschool record deleted.", "success")

        conn.commit()
    except Exception as e:
        conn.rollback()
        flash(f"Error deleting record: {str(e)}", "danger")
    finally:
        cursor.close()
        conn.close()

    return redirect(url_for("preschool_tracker"))


# -------------------------------------------------
# LEARNING STYLE
# -------------------------------------------------
@app.route("/dashboard/learning", methods=["GET", "POST"])
@login_required
def learning_style():
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("select_child"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    child = cursor.fetchone()
    if not child:
        cursor.close()
        conn.close()
        flash("Child not found.", "danger")
        return redirect(url_for("profile"))

    if request.method == "POST" and "observation" in request.form:
        observation = request.form["observation"]
        cursor.execute(
            """
            INSERT INTO learning_observations (child_id, observation, created_at)
            VALUES (%s, %s, NOW())
            """,
            (child_id, observation),
        )
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for("learning_style"))

    # IMPORTANT: Option A — only admin-created tests (user_id IS NULL)
    cursor.execute(
    "SELECT * FROM tests ORDER BY id DESC"
    )
    user_tests = cursor.fetchall()

    cursor.execute(
        """
        SELECT * FROM learning_observations
        WHERE child_id=%s
        ORDER BY created_at DESC
        """,
        (child_id,),
    )
    learning_notes = cursor.fetchall()

    cursor.execute("""
        SELECT
            ta.id AS answer_id,
            ta.test_id,
            ta.question_id,
            ta.answer,
            ta.created_at,
            t.name AS test_name,
            tq.question AS question_text,
            tq.category AS question_category
        FROM test_answers ta
        JOIN tests t ON ta.test_id = t.id
        JOIN test_questions tq ON ta.question_id = tq.id
        WHERE ta.child_id = %s
        ORDER BY ta.created_at DESC
    """, (child_id,))
    test_answers = cursor.fetchall()

    combined_data = {"observations": learning_notes, "answers": test_answers}
    data_payload = json.dumps(
        combined_data, default=str, ensure_ascii=False, indent=2
    )

    cursor.execute(
        """
        SELECT * FROM ai_results
        WHERE child_id=%s AND module='learning'
        ORDER BY created_at DESC
        LIMIT 1
        """,
        (child_id,),
    )
    cached = cursor.fetchone()

    use_cached = cached and cached["data"] == data_payload
    benchmark_summary = cached["result"] if use_cached else None
    last_generated = cached["updated_at"] if cached else None
    regen = request.args.get("regen")

    if regen == "1" and (learning_notes or test_answers):
        try:
            # --- Build observations text with optional date ---
            obs_lines = []
            for note in learning_notes:
                date_val = note.get("created_at")
                if date_val:
                    date_str = date_val.strftime("%Y-%m-%d")
                    obs_lines.append(f"- {note['observation']} (on {date_str})")
                else:
                    obs_lines.append(f"- {note['observation']}")
            obs_text = "\n".join(obs_lines) if obs_lines else "No observations provided."

            # --- Group test answers by learning style category ---
            style_groups = {
                "visual": [],
                "auditory": [],
                "reading": [],
                "kinesthetic": [],
                "other": [],
            }

            for ans in test_answers:
                raw_cat = (ans.get("question_category") or "").strip().lower()

                if "visual" in raw_cat:
                    key = "visual"
                elif "auditory" in raw_cat or "audio" in raw_cat:
                    key = "auditory"
                elif (
                    "reading" in raw_cat
                    or "read" in raw_cat
                    or "writing" in raw_cat
                    or "write" in raw_cat
                ):
                    key = "reading"
                elif "kinesthetic" in raw_cat or "kinaesthetic" in raw_cat:
                    key = "kinesthetic"
                else:
                    key = "other" 

                answer_val = ans.get("answer")
                question_text = ans.get("question_text", "Unknown question")
                test_name = ans.get("test_name", "Unnamed questionnaire")

                # If numeric, treat as scale; otherwise treat as Yes/No or text
                if str(answer_val).isdigit():
                    display = (
                        f"- [{test_name}] Q: {question_text} | "
                        f"A: {answer_val} (scale 1–5)"
                    )
                else:
                    display = (
                        f"- [{test_name}] Q: {question_text} | A: {answer_val}"
                    )

                style_groups[key].append(display)

            # --- Build grouped text for AI prompt ---
            sections = []
            label_map = {
                "visual": "VISUAL (prefers pictures, images, diagrams)",
                "auditory": "AUDITORY (prefers sound, listening, speaking)",
                "reading": "READING/WRITING (prefers text, reading, writing)",
                "kinesthetic": "KINESTHETIC (prefers hands-on, movement, doing)",
                "other": "UNSPECIFIED / MIXED QUESTIONS",
            }

            for key, label in label_map.items():
                lines = style_groups[key]
                if not lines:
                    continue
                section_text = f"{label} RESPONSES:\n" + "\n".join(lines)
                sections.append(section_text)

            ans_text = (
                "\n\n".join(sections)
                if sections
                else "No questionnaire responses provided."
            )

             # --- New AI prompt using grouped questionnaire data ---
            prompt = f"""
                You are an educational psychologist specializing in early childhood learning styles.

                Use the parent questionnaires and observations below to summarise this preschool child's learning style.

                PARENT OBSERVATIONS:
                {obs_text}

                PARENT QUESTIONNAIRE RESPONSES (GROUPED BY LEARNING STYLE CATEGORY):
                {ans_text}

                TASK:
                1. For each of the four VARK styles (Visual, Auditory, Reading/Writing, Kinesthetic),
                give a SHORT rating such as "Strong", "Moderate", or "Weak" plus at most one short reason.
                2. State the child's main learning style (or mixed style) in ONE simple sentence.
                3. Give 3 short, practical tips for parents (one sentence each) to support the child at home.

                IMPORTANT RULES:
                - Keep the total length under 180 words.
                - Use simple, warm, non-technical language suitable for parents.

                HTML FORMAT:
                <h5>Learning Style Summary</h5>
                <ul>
                <li>Visual          : ...</li>
                <li>Auditory        : ...</li>
                <li>Reading/Writing : ...</li>
                <li>Kinesthetic     : ...</li>
                </ul>

                <h5>Main Learning Style</h5>
                <p>...</p>

                <h6>Tips for Parents</h6>
                <ul>
                <li>Tip 1...</li>
                <li>Tip 2...</li>
                <li>Tip 3...</li>
                </ul>

                Do NOT mention that you are an AI model or refer to these instructions.
                """
            model = genai.GenerativeModel("gemini-2.5-flash")
            response = model.generate_content(prompt)
            benchmark_summary = (response.text or "").strip()
            
            # 1) Remove any existing AI result for this child + module='learning'
            cursor.execute(
                """
                DELETE FROM ai_results
                WHERE child_id=%s AND module='learning'
                """,
                (child_id,),
            )
            
             # 2) Insert the new result
            cursor.execute(
                """
                INSERT INTO ai_results
                (child_id, module, data, result, created_at, updated_at)
                VALUES (%s, 'learning', %s, %s, NOW(), NOW())
                """,
                (child_id, data_payload, benchmark_summary),
            )

            conn.commit()
            last_generated = datetime.now()

        except Exception as e:
            if "token" in str(e).lower():
                cursor.close()
                conn.close()
                return jsonify({"error": "token_limit"})
            benchmark_summary = (
                f"<p class='text-danger'>(Error generating analysis: {e})</p>"
            )

    elif not learning_notes and not test_answers:
        benchmark_summary = (
            "<p class='text-muted'>No data available yet. "
            "Add observations or questionnaires answers first.</p>"
        )

    cursor.close()
    conn.close()

    if request.headers.get("X-Requested-With") == "XMLHttpRequest":
        return jsonify(
            {
                "benchmark_summary": benchmark_summary,
                "last_generated": last_generated.strftime(
                    "%Y-%m-%d %H:%M:%S"
                )
                if last_generated
                else None,
                "use_cached": use_cached,
            }
        )

    return render_template(
        "dashboard.html",
        content_template="dashboard/_learning.html",
        selected_child=child,
        learning_notes=learning_notes,
        test_answers=test_answers,
        user_tests=user_tests,
        benchmark_summary=benchmark_summary,
        last_generated=last_generated,
        use_cached=use_cached,
        active="learning",
    )


# ---- Change password ----
@app.route("/profile/change-password", methods=["POST"])
@login_required
def change_password():
    current_password = request.form.get("current_password", "")
    new_password = request.form.get("new_password", "")
    confirm_password = request.form.get("confirm_password", "")

    if not all([current_password, new_password, confirm_password]):
        flash("Please fill in all password fields.", "warning")
        return redirect(url_for("profile"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        "SELECT password FROM users WHERE id=%s", (current_user.id,)
    )
    user = cursor.fetchone()

    if not user or not bcrypt.check_password_hash(
        user["password"], current_password
    ):
        cursor.close()
        conn.close()
        flash("Current password is incorrect.", "danger")
        return redirect(url_for("profile"))

    if new_password != confirm_password:
        cursor.close()
        conn.close()
        flash("New passwords do not match.", "danger")
        return redirect(url_for("profile"))

    if not is_strong_password(new_password):
        cursor.close()
        conn.close()
        flash(
            "Password must be at least 8 characters with uppercase, "
            "lowercase, and a special character.",
            "warning",
        )
        return redirect(url_for("profile"))

    hashed_password = bcrypt.generate_password_hash(new_password).decode(
        "utf-8"
    )
    cursor.execute(
        "UPDATE users SET password=%s WHERE id=%s",
        (hashed_password, current_user.id),
    )
    conn.commit()
    cursor.close()
    conn.close()
    flash("Password changed successfully.", "success")
    return redirect(url_for("profile"))


# ---- AJAX: get questions for a test (admin-created only) ----
@app.route("/learning/test_questions/<int:test_id>")
@login_required
def get_test_questions(test_id):
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    # Just ensure the test exists
    cursor.execute("SELECT * FROM tests WHERE id=%s", (test_id,))
    test = cursor.fetchone()
    if not test:
        cursor.close()
        conn.close()
        return jsonify([])

    cursor.execute("SELECT * FROM test_questions WHERE test_id=%s", (test_id,))
    questions = cursor.fetchall()

    cursor.close()
    conn.close()
    return jsonify(questions)



@app.route("/learning/take_test/<int:child_id>", methods=["POST"])
@login_required
def take_learning_test(child_id):
    conn = get_db_conn()
    cursor = conn.cursor()

    test_id = request.form.get("test_id")
    if not test_id:
        flash("Please select a questionnaire.", "danger")
        cursor.close()
        conn.close()
        return redirect(url_for("learning_style"))

    cursor.execute(
        """
        DELETE FROM test_answers
        WHERE child_id = %s AND test_id = %s
        """,
        (child_id, test_id),
    )

    # Insert the new set of answers
    for key in request.form:
        if key.startswith("answers[") and key.endswith("[answer]"):
            idx = key.split("[")[1].split("]")[0]
            question_id = request.form.get(f"answers[{idx}][question_id]")
            answer_value = request.form.get(f"answers[{idx}][answer]")

            if question_id and answer_value is not None:
                cursor.execute(
                    """
                    INSERT INTO test_answers
                    (child_id, test_id, question_id, answer, created_at)
                    VALUES (%s, %s, %s, %s, NOW())
                    """,
                    (child_id, test_id, question_id, answer_value),
                )

    conn.commit()
    cursor.close()
    conn.close()

    flash("Questionnaire answers submitted successfully.", "success")
    return redirect(url_for("learning_style"))


@app.route("/learning/observation/submit/<int:child_id>", methods=["POST"])
@login_required
def submit_learning_observation(child_id):
    observation = request.form.get("observation")
    if not observation:
        flash("Observation cannot be empty.", "danger")
        return redirect(url_for("learning_style"))

    conn = get_db_conn()
    cursor = conn.cursor()
    cursor.execute(
        """
        INSERT INTO learning_observations (child_id, observation, created_at)
        VALUES (%s, %s, NOW())
        """,
        (child_id, observation),
    )
    conn.commit()
    cursor.close()
    conn.close()

    return redirect(url_for("learning_style"))


@app.route("/learning/observation/delete/<int:observation_id>", methods=["POST"])
@login_required
def delete_learning_observation(observation_id):
    conn = get_db_conn()
    cursor = conn.cursor()

    cursor.execute(
        """
        DELETE lo FROM learning_observations lo
        JOIN children c ON c.id = lo.child_id
        WHERE lo.id=%s AND c.parent_id=%s
        """,
        (observation_id, current_user.id),
    )
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(request.referrer or url_for("profile"))


# -------------------------------------------------
# TUTORING, INSIGHTS, PLAN, RESOURCES
# (unchanged logic, just using get_db_conn)
# -------------------------------------------------

# --- TUTORING ---
@app.route("/dashboard/tutoring")
@login_required
def tutoring_recommendations():
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("select_child"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    child = cursor.fetchone()
    if not child:
        flash("Child not found.", "danger")
        cursor.close()
        conn.close()
        return redirect(url_for("dashboard"))

    cursor.execute(
        """
        SELECT module, result, updated_at
        FROM ai_results
        WHERE child_id=%s AND module IN ('learning', 'preschool')
        """,
        (child_id,),
    )
    child_ai = cursor.fetchall()

    learning_result = next(
        (r["result"] for r in child_ai if r["module"] == "learning"),
        None,
    )
    preschool_result = next(
        (r["result"] for r in child_ai if r["module"] == "preschool"),
        None,
    )

    cursor.execute(
        "SELECT * FROM ai_results WHERE child_id=%s AND module='tutoring' LIMIT 1",
        (child_id,),
    )
    cached = cursor.fetchone()

    regen = request.args.get("regen")

    data_payload = json.dumps(
        {"learning": learning_result, "preschool": preschool_result},
        ensure_ascii=False,
        indent=2,
    )
    use_cached = cached and cached["data"] == data_payload and not regen
    tutoring_summary = cached["result"] if use_cached else None
    last_generated = cached["updated_at"] if cached else None

    if not learning_result and not preschool_result:
        tutoring_summary = (
            "<p class='text-muted'>No AI analysis data available yet. "
            "Run preschool and learning style assessments first.</p>"
        )
    elif regen == "1" or not use_cached:
        try:
            prompt = f"""
            You are an expert child education advisor specializing in personalized learning recommendations.

            CHILD PROFILE:
            - Name: {child['name']}
            - Age: {child['age']} years old
            - Grade Level: {child['grade_level'] or 'Not specified'}

            BACKGROUND DATA (for your analysis only - DO NOT repeat these in your output):
            --- Preschool Development Summary ---
            {preschool_result if preschool_result else "No preschool data available."}

            --- Learning Style Analysis ---
            {learning_result if learning_result else "No learning style data available."}

            IMPORTANT: Use the above data to inform your recommendations, but DO NOT include or repeat
            the Preschool Development Summary or Learning Style Analysis in your output.

            Based on your analysis of the child's profile and background data, provide ONLY these 4 sections:

            1. **Potential Weak Areas**: Identify specific skills that need support
            2. **Recommended Focus Areas**: Subjects or domains where tutoring would be most beneficial
            3. **Personalized Activities**: Specific activities aligned with the child's learning style

            4. **RECOMMENDED LEARNING MATERIALS** (IMPORTANT):
               Recommend 3-5 SPECIFIC products (books, learning tools, stationery, toys, workbooks, flashcards, or games) that parents can purchase to support this child's learning.

               Format each product like this (use this EXACT format):
               [PRODUCT_START]
               Name: [Exact product name]
               Type: [book|learning_tool|stationery|toy|workbook|flashcard|game]
               Category: [books|art_craft|math_tools|stationery|educational_toys|digital_apps|other]
               Subject: [mathematics|english|science|social_emotional|physical_development|general]
               Learning Style: [visual|auditory|kinesthetic|reading_writing|mixed]
               Age: [e.g., 3-5 years]
               Price: RM [estimated price, e.g., 25.90]
               Why: [1-2 sentences explaining why this helps the child]
               Keywords: [keywords for searching online, e.g., "phonics workbook kids age 5"]
               Priority: [high|medium|low]
               [PRODUCT_END]

            OUTPUT FORMAT (HTML):

            <h3>1. Potential Weak Areas</h3>
            <ul>
              <li>Specific skill or area that needs support</li>
              <li>Another weak area with brief explanation</li>
            </ul>

            <h3>2. Recommended Focus Areas</h3>
            <ul>
              <li>Subject or domain for tutoring</li>
              <li>Another recommended focus area</li>
            </ul>

            <h3>3. Personalized Activities</h3>
            <ul>
              <li>Activity aligned with learning style</li>
              <li>Another recommended activity</li>
            </ul>

            <h3>4. Recommended Learning Materials</h3>
            <p>Here are specific products to support {child['name']}'s learning:</p>

            [Include ALL product recommendations using the [PRODUCT_START]...[PRODUCT_END] format]

            <p><strong>Parent Action Plan:</strong> [2-3 sentence summary of what parents should focus on first]</p>

            IMPORTANT:
            - DO NOT include Preschool Development Summary
            - DO NOT include Learning Style Analysis
            - Only output the 4 sections listed above
            - Be specific and actionable
            - Avoid generic disclaimers
            """

            model = genai.GenerativeModel("gemini-2.5-flash")
            response = model.generate_content(prompt)
            full_response = response.text.strip()

            # Extract product recommendations
            tutoring_summary, products = extract_products_from_response(full_response, child_id, cursor)

            if cached:
                cursor.execute(
                    """
                    UPDATE ai_results
                    SET data=%s, result=%s, updated_at=NOW()
                    WHERE id=%s
                    """,
                    (data_payload, tutoring_summary, cached["id"]),
                )
            else:
                cursor.execute(
                    """
                    INSERT INTO ai_results
                    (child_id, module, data, result, created_at, updated_at)
                    VALUES (%s, 'tutoring', %s, %s, NOW(), NOW())
                    """,
                    (child_id, data_payload, tutoring_summary),
                )
            conn.commit()
            last_generated = datetime.now()

        except Exception as e:
            if "token" in str(e).lower():
                cursor.close()
                conn.close()
                return jsonify({"error": "token_limit"})
            tutoring_summary = (
                f"<p class='text-danger'>(Error generating recommendations: {e})</p>"
            )

    # Fetch product recommendations for this child
    cursor.execute("""
        SELECT * FROM product_recommendations
        WHERE child_id = %s
        ORDER BY
            CASE priority
                WHEN 'high' THEN 1
                WHEN 'medium' THEN 2
                WHEN 'low' THEN 3
            END,
            created_at DESC
        LIMIT 10
    """, (child_id,))
    products = cursor.fetchall()

    cursor.close()
    conn.close()

    if request.headers.get("X-Requested-With") == "XMLHttpRequest":
        return jsonify(
            {
                "tutoring_summary": tutoring_summary,
                "last_generated": last_generated.strftime(
                    "%Y-%m-%d %H:%M:%S"
                )
                if last_generated
                else None,
                "use_cached": use_cached,
                "products": products
            }
        )

    return render_template(
        "dashboard.html",
        content_template="dashboard/_tutoring.html",
        selected_child=child,
        tutoring_summary=tutoring_summary,
        last_generated=last_generated,
        use_cached=use_cached,
        products=products,
        active="tutoring",
    )



# --- AI INSIGHTS ---
@app.route("/dashboard/insights")
@login_required
def ai_insights():
    child_id = session.get("selected_child")
    if not child_id:
        flash("Please select a child first.", "warning")
        return redirect(url_for("select_child"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    child = cursor.fetchone()
    if not child:
        cursor.close()
        conn.close()
        flash("Child not found.", "danger")
        return redirect(url_for("dashboard"))

    cursor.execute(
        """
        SELECT subject, score, date
        FROM academic_scores
        WHERE child_id=%s
        ORDER BY date ASC
        """,
        (child_id,),
    )
    scores = cursor.fetchall()

    #fetch mini-game results for this child
    cursor.execute(
        """
        SELECT gr.*, g.title AS game_title, g.game_key
        FROM game_results gr
        JOIN games g ON gr.game_id = g.id
        WHERE gr.child_id=%s
        ORDER BY gr.played_at ASC
        """,
        (child_id,),
    )

    game_results = cursor.fetchall()

    strengths = []
    weaknesses = []
    for row in scores:
        subject = row["subject"]
        score = row["score"]
        if score is None:
            continue
        if score >= 80:
            strengths.append(f"{subject} is a strong subject (score {score}).")
        elif score <= 50:
            weaknesses.append(f"{subject} needs improvement (score {score}).")

    payload_obj = {
        "scores": scores,
        "games": game_results,
    }

    data_payload = json.dumps(payload_obj, default=str, ensure_ascii=False)

    cursor.execute(
        "SELECT * FROM ai_results WHERE child_id=%s AND module='insights' LIMIT 1",
        (child_id,),
    )
    cached = cursor.fetchone()

    regen = request.args.get("regen")
    use_cached = cached and cached["data"] == data_payload and not regen

    ai_summary = None
    last_generated = cached["updated_at"] if cached else None

    if use_cached:
        ai_summary = cached["result"]
    else:
       # Only call AI if we have at least scores or game data
        if scores or game_results:
            try:
                # Academic scores text
                score_lines = [
                    f"{row['subject']}: {row['score']}"
                    for row in scores
                    if row["score"] is not None
                ]
                scores_text = (
                    "\n".join(score_lines)
                    if score_lines
                    else "No academic scores recorded yet."
                )

                # Mini-game performance text
                game_lines = []
                for row in game_results:
                    title = row.get("game_title", "Unknown game")
                    score = row.get("score")
                    total_q = row.get("total_questions")
                    time_spent = row.get("time_spent_seconds")
                    played_at = row.get("played_at")
                    date_str = (
                        played_at.strftime("%Y-%m-%d") if played_at else "unknown date"
                    )
                    game_lines.append(
                        f"{title}: score {score}/{total_q}, time {time_spent}s, played on {date_str}"
                    )

                    games_text = (
                    "\n".join(game_lines)
                    if game_lines
                    else "No mini-game results recorded yet."
                )
                    child_name = child["name"]

                    prompt = f"""
                You are an educational psychologist for preschool children.

                CHILD:
                - Name: {child_name}
                - Age: {child.get('age', 'unknown')}

                ACADEMIC SCORES (may be missing):
                {scores_text}

                MINI EDUCATIONAL GAME PERFORMANCE (counting, vocabulary, spelling):
                {games_text}

                INTERPRETATION NOTES:
                - Counting games reflect early maths and number sense, logic, and basic problem-solving.
                - Vocabulary games reflect word–picture matching and receptive language.
                - Spelling games reflect phonics, letter–sound mapping, and early writing skills.

                TASK:
                Using ONLY the information above, create a short, parent-friendly insight.

                OUTPUT FORMAT:
                Return VALID HTML only, using exactly this structure:

                <h5>Quick Snapshot</h5>
                <ul>
                <li><strong>Main strengths:</strong> 1–2 short phrases combining academic AND game performance
                    (e.g., "very confident with numbers and quick to learn new game rules").</li>
                <li><strong>Key areas to support:</strong> 1–2 short phrases
                    (e.g., "spelling and confident English speaking still developing").</li>
                <li><strong>Overall progress:</strong> 1 short sentence about improvement, stability, or mixed pattern.</li>
                </ul>

                <h5>Detailed Insight</h5>
                <p>Write a warm paragraph of 4–6 sentences directly to {child_name}'s parents.
                Explain:
                - what the scores and game patterns suggest about how {child_name} thinks and learns,
                - why certain areas look strong,
                - why some areas need gentle support.
                Use simple, non-technical language and keep the tone encouraging.</p>

                <h6>Suggested Activities at Home</h6>
                <ul>
                <li>Tip 1 based on the main strengths and how to build on them.</li>
                <li>Tip 2 focused on one weaker area (e.g., language or spelling) with a very practical daily activity.</li>
                <li>Tip 3 that involves play or mini-games to keep learning fun.</li>
                </ul>

                IMPORTANT RULES:
                - Total length (all sections) must stay under 180 words.
                - Do NOT mention exact score numbers or percentages.
                - Do NOT mention 'database', 'tables', or that you are an AI.
                - If academic scores are missing, focus on game performance and do not apologise for missing data.
                """

                model = genai.GenerativeModel("gemini-2.5-flash")
                response = model.generate_content(prompt)
                ai_summary = response.text.strip()

                if cached:
                    cursor.execute(
                        """
                        UPDATE ai_results
                        SET data=%s, result=%s, updated_at=NOW()
                        WHERE id=%s
                        """,
                        (data_payload, ai_summary, cached["id"]),
                    )
                else:
                    cursor.execute(
                        """
                        INSERT INTO ai_results
                        (child_id, module, data, result, created_at, updated_at)
                        VALUES (%s, 'insights', %s, %s, NOW(), NOW())
                        """,
                        (child_id, data_payload, ai_summary),
                    )
                conn.commit()
                last_generated = datetime.now()
            except Exception as e:
                app.logger.error(f"AI insights error: {e}")
                ai_summary = None
        else:
            ai_summary = None

    cursor.close()
    conn.close()

    return render_template(
        "dashboard.html",
        content_template="dashboard/_insights.html",
        selected_child=child,
        scores=scores,
        game_results=game_results,
        strengths=strengths,
        weaknesses=weaknesses,
        ai_summary=ai_summary,
        last_generated=last_generated,
        active="insights",
    )


# --- LEARNING PLAN ---
@app.route("/dashboard/plan")
@login_required
def learning_plan():
    child_id = session.get("selected_child")
    if not child_id:
        flash("Please select a child first.", "warning")
        return redirect(url_for("select_child"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    child = cursor.fetchone()
    if not child:
        cursor.close()
        conn.close()
        flash("Child not found.", "danger")
        return redirect(url_for("dashboard"))

    cursor.execute(
        """
        SELECT subject, score, date
        FROM academic_scores
        WHERE child_id=%s
        ORDER BY date ASC
        """,
        (child_id,),
    )
    scores = cursor.fetchall()

    score_lines = [
        f"{row['subject']}: {row['score']}"
        for row in scores
        if row["score"] is not None
    ]
    scores_text = "\n".join(score_lines) if score_lines else "No academic scores yet."

    cursor.execute(
        """
        SELECT module, result
        FROM ai_results
        WHERE child_id=%s AND module IN ('learning', 'preschool', 'tutoring')
        """,
        (child_id,),
    )
    other_ai = cursor.fetchall()

    learning_result = next(
        (r["result"] for r in other_ai if r["module"] == "learning"), None
    )
    preschool_result = next(
        (r["result"] for r in other_ai if r["module"] == "preschool"), None
    )
    tutoring_result = next(
        (r["result"] for r in other_ai if r["module"] == "tutoring"), None
    )

    payload_obj = {
        "scores": scores,
        "learning_result": learning_result,
        "preschool_result": preschool_result,
        "tutoring_result": tutoring_result,
    }
    data_payload = json.dumps(payload_obj, default=str, ensure_ascii=False)

    cursor.execute(
        "SELECT * FROM ai_results WHERE child_id=%s AND module='learning_plan' LIMIT 1",
        (child_id,),
    )
    cached = cursor.fetchone()

    regen = request.args.get("regen")
    use_cached = cached and cached["data"] == data_payload and not regen

    plan_html = None
    last_generated = cached["updated_at"] if cached else None

    if use_cached:
        plan_html = cached["result"]
    else:
        if scores or learning_result or preschool_result or tutoring_result:
            try:
                child_info = (
                    f"Name: {child['name']}, Age: {child.get('age', 'unknown')}, "
                    f"Grade Level: {child.get('grade_level', 'unknown')}"
                )

                prompt = f"""
You are an expert preschool educational planner.

Child information:
{child_info}

Academic scores:
{scores_text}

Learning style analysis (if available):
{learning_result or "Not available."}

Preschool development summary (if available):
{preschool_result or "Not available."}

Tutoring recommendations (if available):
{tutoring_result or "Not available."}

Your task:
Create a one-week personalized learning plan for this child.

OUTPUT REQUIREMENTS (VERY IMPORTANT):
- Return HTML ONLY (no Markdown, no explanations outside HTML).
- Use this exact structure:

<h3>Learning Plan Summary</h3>
<p>Write 3–6 warm, parent-friendly sentences describing:
- What the child is doing well
- What to focus on this week
- Overall encouragement for the family.
Do NOT mention exact scores or percentages.</p>

<h3>Weekly Action Plan</h3>
<table class="table table-striped">
  <thead>
    <tr><th>Day</th><th>Recommended Activities</th></tr>
  </thead>
  <tbody>
  </tbody>
</table>

<h3>Long-Term Strategy</h3>
<ul>
  <li>3–5 bullet points about habits, routines, and ways parents can support the child over the next few months.</li>
</ul>

RULES:
- Make activities short (around 10–20 minutes each) and realistic for a preschool child.
- Align activities with the child's likely learning style if that information is available.
- Use simple, encouraging language that Malaysian parents can easily understand.
- Do NOT mention exam scores, percentages, or grade labels directly.
"""

                model = genai.GenerativeModel("gemini-2.5-flash")
                response = model.generate_content(prompt)
                plan_html = response.text.strip()

                if cached:
                    cursor.execute(
                        """
                        UPDATE ai_results
                        SET data=%s, result=%s, updated_at=NOW()
                        WHERE id=%s
                        """,
                        (data_payload, plan_html, cached["id"]),
                    )
                else:
                    cursor.execute(
                        """
                        INSERT INTO ai_results
                        (child_id, module, data, result, created_at, updated_at)
                        VALUES (%s, 'learning_plan', %s, %s, NOW(), NOW())
                        """,
                        (child_id, data_payload, plan_html),
                    )
                conn.commit()
                last_generated = datetime.now()

            except Exception as e:
                app.logger.error(f"Learning plan AI error: {e}")
                plan_html = (
                    "<p class='text-danger'>(Error generating learning plan. "
                    "Please try again later.)</p>"
                )
        else:
            plan_html = (
                "<p class='text-muted'>Not enough data yet. "
                "Please add some academic scores and/or run other AI analyses first.</p>"
            )

    cursor.close()
    conn.close()

    return render_template(
        "dashboard.html",
        content_template="dashboard/_plan.html",
        selected_child=child,
        plan_html=plan_html,
        last_generated=last_generated,
        use_cached=use_cached,
        active="learning_plan",
    )


# --- RESOURCES HUB ---
@app.route("/dashboard/resources")
@login_required
def resources_hub():
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("select_child"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

# 1) Get selected child (only if it belongs to this parent)
    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    child = cursor.fetchone()

    if not child:
        cursor.close()
        conn.close()
        flash("Child not found.", "danger")
        return redirect(url_for("dashboard"))
    
    # 2) Determine child's age (prefer stored age; else compute from DOB)
    child_age = child.get("age")

    if child_age is None and child.get("dob"):
        dob = child["dob"]
        if isinstance(dob, str):
            try:
                dob = datetime.strptime(dob, "%Y-%m-%d").date()
            except ValueError:
                dob = None

        if isinstance(dob, date):
            today = date.today()
            child_age = (
                today.year
                - dob.year
                - ((today.month, today.day) < (dob.month, dob.day))
            )
            

    # If still None, just treat as generic preschool age (4)
    if child_age is None:
        child_age = 4

    # 3) Optional type filter from query string (?type=video, etc.)
    selected_type = request.args.get("type", "").strip().lower()
    if selected_type not in RESOURCE_TYPES:
        selected_type = ""

    # 4) Load resources from DB
    params = []
    query = "SELECT * FROM resources WHERE 1=1"

    # Filter by age range if available
    if child_age is not None:
        query += " AND (age_min IS NULL OR age_min <= %s)"
        query += " AND (age_max IS NULL OR age_max >= %s)"
        params.extend([child_age, child_age])

    # Filter by type if chosen
    if selected_type:
        query += " AND type = %s"
        params.append(selected_type)

    query += " ORDER BY created_at DESC"

    cursor.execute(query, tuple(params))
    resources = cursor.fetchall()

    cursor.close()
    conn.close()

    # Group resources by type
    grouped = {}
    for r in resources:
        rtype = r["type"].capitalize()  # Book / Video / App / Article
        if rtype not in grouped:
            grouped[rtype] = []
        grouped[rtype].append(r)

    return render_template(
        "dashboard.html",
        content_template="dashboard/_resources.html",
        selected_child=child,
        grouped_resources=grouped,
        resource_types=RESOURCE_TYPES,
        selected_type=selected_type,
        active="resources",
    )

@app.route("/dashboard/games")
@login_required
def dashboard_games():
    # Ensure a child is selected
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("select_child"))

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    # Get selected child (and ensure it belongs to the current parent)
    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )

    child = cursor.fetchone()

    if not child:
        cursor.close()
        conn.close()
        flash("Child not found.", "danger")
        return redirect(url_for("dashboard"))
    
    # --- Determine child's age (from age column or DOB) ---
    child_age = child.get("age")

    # If `age` not stored, compute from DOB
    if child_age is None and child.get("dob"):
        dob = child["dob"]
        if isinstance(dob, str):
            try:
                dob = datetime.strptime(dob, "%Y-%m-%d").date()
            except ValueError:
                dob = None

        if isinstance(dob, date):
            today = date.today()
            child_age = (
                today.year
                - dob.year
                - ((today.month, today.day) < (dob.month, dob.day))
            )

    # Final fallback if age still None
    if child_age is None:
        child_age = 4

    # --- Load games appropriate for age and active status ---
    cursor.execute(
        """
        SELECT *
        FROM games
        WHERE is_active = 1
          AND (age_min IS NULL OR age_min <= %s)
          AND (age_max IS NULL OR age_max >= %s)
        ORDER BY created_at DESC
        """,
        (child_age, child_age),
    )
    games = cursor.fetchall()
    cursor.close()
    conn.close()

    # Render the dashboard with the mini-games partial
    return render_template(
        "dashboard.html",
        content_template="dashboard/_games.html",
        selected_child=child,
        games=games,
        active="games",
    )

@app.route("/dashboard/games/<int:game_id>")
@login_required
def play_mini_game(game_id):
    child_id = session.get("selected_child")
    if not child_id:
        return redirect(url_for("select_child"))
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    # Get child
    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    child = cursor.fetchone()

    # Get game
    cursor.execute("SELECT * FROM games WHERE id=%s", (game_id,))
    game = cursor.fetchone()
    cursor.close()
    conn.close()

    if not child or not game:
        flash("Game or child not found.", "danger")
        return redirect(url_for("dashboard_games"))
    
    # Decide which template to use based on game_key
    template_map = {
        "counting_animals": "dashboard/game_counting.html",
        "vocab_animals": "dashboard/game_vocab.html",
        "spelling_animals": "dashboard/game_spelling.html",
    }
    template_name = template_map.get(game["game_key"])

    if not template_name:
        flash("This game is not implemented yet.", "warning")
        return redirect(url_for("dashboard_games"))
    return render_template(
        template_name,
        selected_child=child,
        game=game,
    )

@app.route("/api/game-result", methods=["POST"])
@login_required
def save_game_result():
    data = request.get_json(silent=True) or {}

    child_id = data.get("child_id")
    game_id = data.get("game_id")
    score = data.get("score")
    total_questions = data.get("total_questions")
    time_spent_seconds = data.get("time_spent_seconds")

    if not child_id or not game_id:
        return {"success": False, "error": "Missing child_id or game_id"}, 400

    try:
        child_id = int(child_id)
        game_id = int(game_id)
        score = int(score) if score is not None else None
        total_questions = int(total_questions) if total_questions is not None else None
        time_spent_seconds = int(time_spent_seconds) if time_spent_seconds is not None else None
    except (ValueError, TypeError):
        return {"success": False, "error": "Invalid data types"}, 400

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM children WHERE id=%s AND parent_id=%s",
        (child_id, current_user.id),
    )
    child = cursor.fetchone()

    if not child:
        cursor.close()
        conn.close()
        return {"success": False, "error": "Child not found or not yours"}, 403

    cursor2 = conn.cursor()
    cursor2.execute(
        """
        INSERT INTO game_results
            (child_id, game_id, score, total_questions, time_spent_seconds)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (child_id, game_id, score, total_questions, time_spent_seconds),
    )
    conn.commit()
    cursor2.close()
    cursor.close()
    conn.close()
    return {"success": True}, 200


# -------------------------------------------------
# ADMIN AREA
# -------------------------------------------------
@app.route("/admin/dashboard")
@login_required
@roles_required("admin")
def admin_dashboard():
    return render_template("admin/dashboard.html", active="admin")


@app.route("/admin/users")
@login_required
@roles_required("admin")
def admin_users():
    search = request.args.get("q", "").strip()
    sort_by = request.args.get("sort", "created_at")
    order = request.args.get("order", "desc")

    # Whitelist allowed columns to prevent SQL injection
    allowed_columns = ["id", "name", "email", "role", "created_at"]
    if sort_by not in allowed_columns:
        sort_by = "created_at"

    # Validate order direction
    if order not in ["asc", "desc"]:
        order = "desc"

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    # Build ORDER BY clause
    order_clause = f"ORDER BY {sort_by} {order.upper()}"

    if search:
        like = f"%{search}%"
        cursor.execute(
            f"""
            SELECT id, name, email, role, created_at
            FROM users
            WHERE name LIKE %s
               OR email LIKE %s
               OR CAST(id AS CHAR) LIKE %s
            {order_clause}
            """,
            (like, like, like),
        )
    else:
        cursor.execute(
            f"""
            SELECT id, name, email, role, created_at
            FROM users
            {order_clause}
            """
        )

    users = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template("admin/users.html", users=users, search=search, sort_by=sort_by, order=order)


@app.route("/admin/users/<int:user_id>/edit", methods=["GET", "POST"])
@login_required
@roles_required("admin")
def admin_edit_user(user_id):
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT id, name, email, role FROM users WHERE id=%s", (user_id,)
    )
    user = cursor.fetchone()

    if not user:
        cursor.close()
        conn.close()
        flash("User not found.", "danger")
        
        

    if request.method == "POST":
        name = request.form.get("name", "").strip()
        email = request.form.get("email", "").strip().lower()
        password = request.form.get("password", "")

        if not name or not email:
            flash("Name and email are required.", "warning")
            cursor.close()
            conn.close()
            return render_template("admin/edit_user.html", user=user)
            
        # Validate name contains only alphabet letters
        if not is_valid_name(name):
            flash("Name must contain only alphabet letters and spaces.", "danger")
            cursor.close()
            conn.close()
            return render_template("admin/edit_user.html", user=user)

        try:
            if password:
                hashed = bcrypt.generate_password_hash(password).decode(
                    "utf-8"
                )
                cursor.execute(
                    """
                    UPDATE users
                    SET name=%s, email=%s, password=%s
                    WHERE id=%s
                    """,
                    (name, email, hashed, user_id),
                )
            else:
                cursor.execute(
                    """
                    UPDATE users
                    SET name=%s, email=%s
                    WHERE id=%s
                    """,
                    (name, email, user_id),
                )

            conn.commit()
            flash("User updated successfully.", "success")

        except mysql.connector.errors.IntegrityError:
            conn.rollback()
            flash(
                "That email is already in use by another account.", "danger"
            )
            cursor.close()
            conn.close()
            return render_template("admin/edit_user.html", user=user)

        cursor.close()
        conn.close()
        return redirect(url_for("admin_users"))

    cursor.close()
    conn.close()
    return render_template("admin/edit_user.html", user=user)


@app.route("/admin/users/<int:user_id>/delete", methods=["POST"])
@login_required
@roles_required("admin")
def admin_delete_user(user_id):
    if user_id == current_user.id:
        flash(
            "You cannot delete your own account while logged in.", "warning"
        )
        return redirect(url_for("admin_users"))

    conn = get_db_conn()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT COUNT(*) FROM children WHERE parent_id = %s", (user_id,)
    )
    (child_count,) = cursor.fetchone()

    if child_count > 0:
        cursor.close()
        conn.close()
        flash(
            "This user still has child profiles linked. "
            "Delete or reassign them first.",
            "danger",
        )
        return redirect(url_for("admin_users"))

    cursor.execute("DELETE FROM users WHERE id = %s", (user_id,))
    conn.commit()
    cursor.close()
    conn.close()

    flash("User account deleted successfully.", "success")
    return redirect(url_for("admin_users"))

# -------------------------------------------------
# ADMIN - EDUCATIONAL RESOURCES MANAGEMENT
# -------------------------------------------------
@app.route("/admin/resources")
@login_required
@roles_required("admin")
def admin_resources():
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM resources ORDER BY created_at DESC"
    )
    resources = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "admin/resources.html",
        resources=resources,
        resource_types=RESOURCE_TYPES,
    )


@app.route("/admin/resources/create", methods=["GET", "POST"])
@login_required
@roles_required("admin")
def admin_create_resource():
    if request.method == "POST":
        title = request.form.get("title", "").strip()
        rtype = request.form.get("type", "").strip().lower()
        description = request.form.get("description", "").strip()
        age_min = request.form.get("age_min", "").strip()
        age_max = request.form.get("age_max", "").strip()
        url = request.form.get("url", "").strip()

        if not title:
            flash("Title is required.", "danger")
            return redirect(request.url)

        if rtype not in RESOURCE_TYPES:
            flash("Invalid resource type.", "danger")
            return redirect(request.url)

        # Convert age fields to integers or NULL
        def to_int_or_none(value):
            try:
                return int(value) if value else None
            except ValueError:
                return None

        age_min_val = to_int_or_none(age_min)
        age_max_val = to_int_or_none(age_max)

        conn = get_db_conn()
        cursor = conn.cursor()

        cursor.execute(
            """
            INSERT INTO resources
                (title, type, description, age_min, age_max, url)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (title, rtype, description, age_min_val, age_max_val, url or None),
        )
        conn.commit()

        cursor.close()
        conn.close()

        flash("Resource created successfully.", "success")
        return redirect(url_for("admin_resources"))

    return render_template(
        "admin/create_resource.html",
        resource_types=RESOURCE_TYPES,
    )


@app.route("/admin/resources/<int:resource_id>/edit", methods=["GET", "POST"])
@login_required
@roles_required("admin")
def admin_edit_resource(resource_id):
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM resources WHERE id=%s", (resource_id,))
    resource = cursor.fetchone()

    if not resource:
        cursor.close()
        conn.close()
        flash("Resource not found.", "danger")
        return redirect(url_for("admin_resources"))

    if request.method == "POST":
        title = request.form.get("title", "").strip()
        rtype = request.form.get("type", "").strip().lower()
        description = request.form.get("description", "").strip()
        age_min = request.form.get("age_min", "").strip()
        age_max = request.form.get("age_max", "").strip()
        url = request.form.get("url", "").strip()

        if not title:
            flash("Title is required.", "danger")
            return redirect(request.url)

        if rtype not in RESOURCE_TYPES:
            flash("Invalid resource type.", "danger")
            return redirect(request.url)

        def to_int_or_none(value):
            try:
                return int(value) if value else None
            except ValueError:
                return None

        age_min_val = to_int_or_none(age_min)
        age_max_val = to_int_or_none(age_max)

        cursor2 = conn.cursor()
        cursor2.execute(
            """
            UPDATE resources
            SET title=%s,
                type=%s,
                description=%s,
                age_min=%s,
                age_max=%s,
                url=%s
            WHERE id=%s
            """,
            (
                title,
                rtype,
                description,
                age_min_val,
                age_max_val,
                url or None,
                resource_id,
            ),
        )
        conn.commit()
        cursor2.close()
        cursor.close()
        conn.close()

        flash("Resource updated successfully.", "success")
        return redirect(url_for("admin_resources"))

    cursor.close()
    conn.close()

    return render_template(
        "admin/edit_resource.html",
        resource=resource,
        resource_types=RESOURCE_TYPES,
    )


@app.route("/admin/resources/<int:resource_id>/delete", methods=["POST"])
@login_required
@roles_required("admin")
def admin_delete_resource(resource_id):
    conn = get_db_conn()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM resources WHERE id=%s", (resource_id,))
    conn.commit()

    cursor.close()
    conn.close()

    flash("Resource deleted.", "success")
    return redirect(url_for("admin_resources"))






# ---- ADMIN MINI GAMES MANAGEMENT----
@app.route("/admin/games")
@login_required
@roles_required("admin")
def admin_games():
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM games ORDER BY id ASC")
    games = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template(
        "admin/games.html",
        games=games,
        active="manage_games",
    )

# ---- ADMIN: EDIT A GAME ----
@app.route("/admin/games/<int:game_id>/edit", methods=["GET", "POST"])
@login_required
@roles_required("admin")
def admin_edit_game(game_id):
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST":
        title = (request.form.get("title") or "").strip()
        game_key = (request.form.get("game_key") or "").strip()
        description = (request.form.get("description") or "").strip()
        difficulty = request.form.get("difficulty") or "easy"

        age_min_raw = request.form.get("age_min")
        age_max_raw = request.form.get("age_max")

        # convert ages to int or None
        try:
            age_min = int(age_min_raw) if age_min_raw else None
        except ValueError:
            age_min = None

        try:
            age_max = int(age_max_raw) if age_max_raw else None
        except ValueError:
            age_max = None

        is_active = 1 if request.form.get("is_active") == "1" else 0

        cursor.execute(
            """
            UPDATE games
            SET title=%s,
                game_key=%s,
                description=%s,
                age_min=%s,
                age_max=%s,
                difficulty=%s,
                is_active=%s,
                updated_at=NOW()
            WHERE id=%s
            """,
            (title, game_key, description, age_min, age_max,
             difficulty, is_active, game_id),
        )
        conn.commit()
        cursor.close()
        conn.close()

        flash("Game updated successfully.", "success")
        return redirect(url_for("admin_games"))

    # GET: load game
    cursor.execute("SELECT * FROM games WHERE id=%s", (game_id,))
    game = cursor.fetchone()
    cursor.close()
    conn.close()

    if not game:
        flash("Game not found.", "danger")
        return redirect(url_for("admin_games"))

    return render_template("admin/edit_game.html", game=game)


# ---- ADMIN: DELETE A GAME ----
@app.route("/admin/games/<int:game_id>/delete", methods=["POST"])
@login_required
@roles_required("admin")
def admin_delete_game(game_id):
    conn = get_db_conn()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM games WHERE id=%s", (game_id,))
    conn.commit()
    cursor.close()
    conn.close()

    flash("Game deleted successfully.", "success")
    return redirect(url_for("admin_games"))

# ---- ADMIN TEST MANAGEMENT (GLOBAL TESTS) ----
@app.route("/admin/tests")
@login_required
@roles_required("admin")
def admin_tests():
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT t.id, t.name, t.user_id, u.name AS owner_name
        FROM tests t
        LEFT JOIN users u ON t.user_id = u.id
        ORDER BY t.id DESC
        """
    )
    tests = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("admin/test.html", tests=tests)


@app.route("/admin/tests/create", methods=["GET", "POST"])
@login_required
@roles_required("admin")
def admin_create_test():
    if request.method == "POST":
        name = request.form.get("name", "").strip()
        questions = request.form.getlist("questions[]")
        categories = request.form.getlist("categories[]")
        media_files = request.files.getlist("question_media[]")

        conn = get_db_conn()
        cursor = conn.cursor()

        # 🔴 OLD: user_id = NULL  (causes error)
        # cursor.execute(
        #     "INSERT INTO tests (name, user_id) VALUES (%s, NULL)", (name,)
        # )

        # ✅ NEW: store the ID of the logged-in admin
        cursor.execute(
            "INSERT INTO tests (name, user_id) VALUES (%s, %s)",
            (name, current_user.id),
        )
        test_id = cursor.lastrowid

        for idx, (q, cat) in enumerate(zip(questions, categories)):
            file_obj = media_files[idx] if idx < len(media_files) else None
            media_type, media_path = save_question_media(file_obj, test_id, idx)

            cursor.execute(
                """
                INSERT INTO test_questions
                (test_id, question, answer_type, category, media_type, media_path)
                VALUES (%s, %s, 'scale', %s, %s, %s)
                """,
                (test_id, q, cat, media_type, media_path),
            )

        conn.commit()
        cursor.close()
        conn.close()

        flash("Test created successfully!", "success")
        return redirect(url_for("admin_tests"))

    return render_template("admin/create_test.html")




@app.route("/admin/tests/<int:test_id>/edit", methods=["GET", "POST"])
@login_required
@roles_required("admin")
def admin_edit_test(test_id):
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM tests WHERE id=%s", (test_id,))
    test = cursor.fetchone()

    cursor.execute("SELECT * FROM test_questions WHERE test_id=%s", (test_id,))
    questions = cursor.fetchall()

    if not test:
        cursor.close()
        conn.close()
        flash("Test not found.", "danger")
        return redirect(url_for("admin_tests"))

    if request.method == "POST":
        new_name = request.form.get("name", "").strip()
        new_questions = request.form.getlist("questions[]")
        new_categories = request.form.getlist("categories[]")
        media_files = request.files.getlist("question_media[]")

        # Safety: if categories shorter than questions, pad
        if len(new_categories) < len(new_questions):
            new_categories = (
                new_categories + ["reading"] * len(new_questions)
            )[: len(new_questions)]

        # Update test name
        cursor.execute(
            "UPDATE tests SET name=%s WHERE id=%s", (new_name, test_id)
        )

        # Remove old questions (and their media)
        cursor.execute("DELETE FROM test_questions WHERE test_id=%s", (test_id,))

        # Re-insert questions with media
        for idx, (q, cat) in enumerate(zip(new_questions, new_categories)):
            file_obj = media_files[idx] if idx < len(media_files) else None
            media_type, media_path = save_question_media(file_obj, test_id, idx)

            cursor.execute(
                """
                INSERT INTO test_questions
                (test_id, question, answer_type, category, media_type, media_path)
                VALUES (%s, %s, 'scale', %s, %s, %s)
                """,
                (test_id, q, cat, media_type, media_path),
            )

        conn.commit()
        cursor.close()
        conn.close()

        flash("Test updated!", "success")
        return redirect(url_for("admin_tests"))

    cursor.close()
    conn.close()

    return render_template(
        "admin/edit_test.html", test=test, questions=questions
    )



@app.route("/admin/tests/<int:test_id>/delete", methods=["POST"])
@login_required
@roles_required("admin")
def admin_delete_test(test_id):
    conn = get_db_conn()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM test_questions WHERE test_id=%s", (test_id,))
    cursor.execute("DELETE FROM tests WHERE id=%s", (test_id,))

    conn.commit()
    cursor.close()
    conn.close()

    flash("Test deleted.", "success")
    return redirect(url_for("admin_tests"))


# -------------------------------------------------
# ADMIN - INACTIVE USER MANAGEMENT
# -------------------------------------------------
@app.route("/admin/inactive-users")
@login_required
@roles_required("admin")
def admin_inactive_users():
    """Admin page to view and manage inactive PARENT users (admins are excluded)"""
    from datetime import datetime, timedelta

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    now = datetime.now()
    warning_threshold = now - timedelta(days=23)
    final_warning_threshold = now - timedelta(days=28)
    deletion_threshold = now - timedelta(days=30)

    # Get all PARENT users with their activity status (admins excluded, non-deleted only)
    cursor.execute("""
        SELECT
            id,
            name,
            email,
            role,
            created_at,
            last_login,
            is_active,
            protected_from_deletion,
            inactive_warning_sent,
            CASE
                WHEN last_login IS NULL THEN DATEDIFF(%s, created_at)
                ELSE DATEDIFF(%s, last_login)
            END as days_inactive
        FROM users
        WHERE role = 'parent'
        AND deleted_at IS NULL
        ORDER BY
            CASE WHEN last_login IS NULL THEN created_at ELSE last_login END ASC
    """, (now, now))

    users = cursor.fetchall()

    # Categorize users
    categorized_users = {
        'at_risk': [],  # 23-29 days
        'pending_deletion': [],  # 30+ days
        'protected': [],  # Protected from deletion
        'active': []  # Less than 23 days
    }

    for user in users:
        days_inactive = user['days_inactive']

        if user['protected_from_deletion']:
            categorized_users['protected'].append(user)
        elif days_inactive >= 30:
            categorized_users['pending_deletion'].append(user)
        elif days_inactive >= 23:
            categorized_users['at_risk'].append(user)
        else:
            categorized_users['active'].append(user)

    cursor.close()
    conn.close()

    return render_template(
        "admin/inactive_users.html",
        users=categorized_users,
        now=now
    )


@app.route("/admin/users/<int:user_id>/toggle-protection", methods=["POST"])
@login_required
@roles_required("admin")
def admin_toggle_user_protection(user_id):
    """Toggle protection status for a user"""
    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT protected_from_deletion, name FROM users WHERE id = %s",
        (user_id,)
    )
    user = cursor.fetchone()

    if not user:
        flash("User not found.", "danger")
        cursor.close()
        conn.close()
        return redirect(url_for("admin_inactive_users"))

    new_status = 0 if user['protected_from_deletion'] else 1
    cursor.execute(
        "UPDATE users SET protected_from_deletion = %s WHERE id = %s",
        (new_status, user_id)
    )
    conn.commit()
    cursor.close()
    conn.close()

    status_text = "protected from" if new_status else "no longer protected from"
    flash(f"User {user['name']} is now {status_text} automatic deletion.", "success")
    return redirect(url_for("admin_inactive_users"))


@app.route("/admin/users/<int:user_id>/activate", methods=["POST"])
@login_required
@roles_required("admin")
def admin_activate_user(user_id):
    """Manually activate a user and reset their last_login"""
    from datetime import datetime

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT name FROM users WHERE id = %s", (user_id,))
    user = cursor.fetchone()

    if not user:
        flash("User not found.", "danger")
        cursor.close()
        conn.close()
        return redirect(url_for("admin_inactive_users"))

    cursor.execute(
        "UPDATE users SET is_active = 1, last_login = %s, inactive_warning_sent = NULL WHERE id = %s",
        (datetime.now(), user_id)
    )
    conn.commit()
    cursor.close()
    conn.close()

    flash(f"User {user['name']} has been reactivated.", "success")
    return redirect(url_for("admin_inactive_users"))


@app.route("/admin/deleted-users")
@login_required
@roles_required("admin")
def admin_deleted_users():
    """Admin page to view soft-deleted users and restore them"""
    from datetime import datetime, timedelta

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    now = datetime.now()
    permanent_deletion_date = now - timedelta(days=90)

    # Get all soft-deleted users with time until permanent deletion
    cursor.execute("""
        SELECT
            id,
            name,
            email,
            role,
            deleted_at,
            deletion_reason,
            DATEDIFF(%s, deleted_at) as days_deleted,
            DATEDIFF(DATE_ADD(deleted_at, INTERVAL 90 DAY), %s) as days_until_permanent
        FROM users
        WHERE deleted_at IS NOT NULL
        ORDER BY deleted_at DESC
    """, (now, now))

    deleted_users = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "admin/deleted_users.html",
        deleted_users=deleted_users,
        now=now,
        permanent_deletion_threshold=90
    )


@app.route("/admin/users/<int:user_id>/restore", methods=["POST"])
@login_required
@roles_required("admin")
def admin_restore_user(user_id):
    """Restore a soft-deleted user account"""
    from datetime import datetime

    conn = get_db_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT name, email, deleted_at FROM users WHERE id = %s AND deleted_at IS NOT NULL",
        (user_id,)
    )
    user = cursor.fetchone()

    if not user:
        flash("Deleted user not found or already restored.", "danger")
        cursor.close()
        conn.close()
        return redirect(url_for("admin_deleted_users"))

    # Restore the user by clearing soft delete fields and reactivating
    cursor.execute("""
        UPDATE users
        SET deleted_at = NULL,
            deletion_reason = NULL,
            is_active = 1,
            last_login = %s,
            inactive_warning_sent = NULL
        WHERE id = %s
    """, (datetime.now(), user_id))

    conn.commit()
    cursor.close()
    conn.close()

    flash(f"User {user['name']} ({user['email']}) has been successfully restored!", "success")
    return redirect(url_for("admin_deleted_users"))


@app.route("/admin/run-cleanup", methods=["POST"])
@login_required
@roles_required("admin")
def admin_run_cleanup():
    """Manually trigger the inactive user cleanup process"""
    try:
        stats = check_inactive_users()
        flash(
            f"Cleanup completed: {stats['warnings_sent']} warnings sent, "
            f"{stats['final_warnings_sent']} final warnings sent, "
            f"{stats['accounts_deleted']} accounts deleted.",
            "success"
        )
        if stats['errors']:
            for error in stats['errors']:
                flash(error, "warning")
    except Exception as e:
        flash(f"Error running cleanup: {str(e)}", "danger")

    return redirect(url_for("admin_inactive_users"))


# -------------------------------------------------
# INDEX
# -------------------------------------------------
@app.route("/")
def index():
    if current_user.is_authenticated:
        # send admin to admin dashboard, parents to dashboard
        if normalize_role(current_user.role) == "admin":
            return redirect(url_for("admin_dashboard"))
        else:
            return redirect(url_for("dashboard"))
    return redirect(url_for("login"))


if __name__ == "__main__":
    # Initialize and start the scheduler for automated tasks
    scheduler.init_app(app)
    scheduler.start()
    print("✅ APScheduler started - Inactive user cleanup will run daily at 2:00 AM UTC")

    app.run(debug=True, use_reloader=True)
    