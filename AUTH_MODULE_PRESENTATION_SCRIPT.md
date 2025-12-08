# User Authentication Module - Presentation Script

## Introduction
"Good day, teacher. Today I will present the User Authentication Module of my ChildGrowth Insights system. This module consists of 34 functions and operations that handle user registration, login, security, and validation."

---

## 1. CORE AUTHENTICATION FUNCTIONS (10 Functions)

### 1.1 register_redirect() - Line 469
**Script:** "This function handles the initial registration route. When users visit /register, it redirects them to the registration selection page where they can choose between parent or admin registration."

**Purpose:** Entry point for user registration process

---

### 1.2 register_select() - Line 474
**Script:** "This function displays the registration type selection page. It renders a template that allows users to choose whether they want to register as a parent or administrator."

**Purpose:** Provides user role selection interface

---

### 1.3 register_parent() - Line 479
**Script:** "This function handles parent user registration. It processes the registration form with GET and POST methods. The function validates the input data including name, email, and password, checks for duplicate emails in the database, hashes the password using bcrypt for security, and creates a new parent account in the users table."

**Purpose:** Complete parent registration workflow with validation

**Key Features:**
- Validates all required fields (name, email, password, confirm_password)
- Checks email format using regex
- Validates password strength
- Prevents duplicate email registration
- Securely hashes passwords with bcrypt
- Assigns 'parent' role automatically

---

### 1.4 register_admin() - Line 544
**Script:** "This function handles administrator registration with an additional security layer. It requires users to enter an admin passkey (ADMIN_PASSKEY) to verify they are authorized to create an admin account. The function performs the same validation as parent registration but also validates the admin key before allowing registration."

**Purpose:** Secure admin account creation with passkey verification

**Key Features:**
- Requires admin passkey verification
- Same validation as parent registration
- Prevents unauthorized admin account creation
- Assigns 'admin' role upon successful registration

---

### 1.5 login() - Line 614
**Script:** "This is the main login function that authenticates users into the system. When a user submits their email and password, the function queries the database to find the user account, verifies the password using bcrypt's check_password_hash, and performs multiple security checks. It checks if the account has been deleted, if it's deactivated, and only allows login if all checks pass. Upon successful login, it updates the last_login timestamp, reactivates the account if needed, clears any inactivity warnings, and creates a user session using Flask-Login."

**Purpose:** Secure user authentication with multi-layer validation

**Security Checks:**
1. Password verification with bcrypt
2. Deleted account check
3. Inactive account check
4. Updates last login timestamp
5. Creates secure session

---

### 1.6 logout() - Line 690
**Script:** "This function handles user logout. It uses Flask-Login's logout_user() function to clear the user session, ensuring the user is properly logged out from the system. After logout, it redirects the user to the login page."

**Purpose:** Secure session termination

---

### 1.7 forgot() - Line 1196
**Script:** "This function initiates the password reset process. When a user forgets their password and enters their email, the function checks if the email exists in the database. If it exists, it generates a secure time-limited token using URLSafeTimedSerializer and sends a password reset email with the token. For security reasons, it always shows the same success message whether the email exists or not, preventing email enumeration attacks."

**Purpose:** Secure password reset initiation

**Security Features:**
- Generates cryptographically secure tokens
- Prevents email enumeration
- Time-limited reset links

---

### 1.8 reset_password() - Line 1214
**Script:** "This function handles the actual password reset process. It validates the reset token from the email link with a 1-hour expiration time. If the token is valid, it allows the user to enter a new password. The function validates that the new password matches the confirmation, checks password strength requirements, hashes the new password with bcrypt, and updates it in the database."

**Purpose:** Complete password reset with token validation

**Validation Steps:**
1. Token validation (1-hour expiry)
2. Password confirmation match
3. Password strength validation
4. Secure password hashing
5. Database update

---

### 1.9 change_password() - Line 2556
**Script:** "This function allows authenticated users to change their password from their profile. It requires the user to enter their current password for verification, then validates the new password strength and confirmation match. If all validations pass, it updates the password in the database."

**Purpose:** Allow authenticated users to update their password

**Validation Steps:**
1. Verify current password
2. Check all fields are provided
3. Validate new password strength
4. Confirm password match
5. Update with hashed password

---

### 1.10 admin_activate_user() - Line 4396
**Script:** "This is an admin-only function that allows administrators to manually activate user accounts. It's protected by the @login_required and @roles_required('admin') decorators. When an admin activates a user, it sets is_active to 1 and resets the last_login timestamp, essentially giving the user a fresh start."

**Purpose:** Admin control over user account activation

---

## 2. VALIDATION FUNCTIONS (9 Functions)

### 2.1 is_strong_password() - Line 301
**Script:** "This function validates password strength using regular expressions. It enforces that passwords must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one special symbol. This ensures users create secure passwords."

**Validation Rules:**
- Minimum 8 characters
- At least 1 uppercase letter (A-Z)
- At least 1 lowercase letter (a-z)
- At least 1 special symbol (!@#$%^&*, etc.)

---

### 2.2 is_valid_name() - Line 307
**Script:** "This function validates user names to ensure they contain only alphabet letters and spaces. It prevents special characters, numbers, and empty names, ensuring data quality in the system."

**Validation Rules:**
- Only letters (A-Z, a-z) and spaces
- Not empty or only whitespace
- Uses regex pattern for validation

---

### 2.3 is_valid_grade_level() - Line 318
**Script:** "This function validates grade level input for child profiles. It allows alphanumeric characters, hyphens, and spaces, with a maximum length of 20 characters. This supports various grade formats like K1, Pre-K, Preschool, etc."

**Validation Rules:**
- Alphanumeric characters, hyphens, spaces
- 1-20 characters in length
- Not empty

---

### 2.4 is_valid_dob() - Line 337
**Script:** "This function validates date of birth for child profiles. It returns a tuple with validation status and error message. It checks that the date is not in the future and not more than 18 years ago, which is reasonable for a preschool application."

**Validation Rules:**
- Valid date format (YYYY-MM-DD)
- Not in the future
- Not more than 18 years ago
- Returns (True, None) or (False, error_message)

---

### 2.5 is_valid_academic_date() - Line 363
**Script:** "This function validates academic record dates by checking the year and month. It ensures the year is between 2000 and the current year, the month is between 1 and 12, and the date is not in the future."

**Validation Rules:**
- Year between 2000 and current year
- Month between 1-12
- Not in the future
- Returns validation tuple

---

### 2.6 Email Validation - Lines 58, 494, 584
**Script:** "The system uses a regex pattern called EMAIL_REGEX to validate email addresses. It checks that emails follow the standard format with username, @ symbol, domain name, and valid top-level domain. This validation is applied during registration and other email-related operations."

**Validation Pattern:**
```
^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$
```

---

### 2.7 Password Confirmation Validation - Lines 490, 560, 1227, 2580
**Script:** "Throughout the authentication module, whenever users create or change passwords, the system validates that the password and confirm_password fields match exactly. This prevents typos and ensures users know their password."

**Locations:**
- Parent registration (line 490)
- Admin registration (line 560)
- Password reset (line 1227)
- Password change (line 2580)

---

### 2.8 Duplicate Email Check - Lines 507-516, 564-573
**Script:** "Before creating any new account, the system queries the database to check if an account with the submitted email already exists. If a duplicate is found, registration is blocked and the user receives an error message. This ensures email uniqueness in the system."

**Implementation:**
- Queries users table by email
- Checks if any record exists
- Prevents duplicate registration
- Applied to both parent and admin registration

---

### 2.9 Admin Key Validation - Lines 547-548
**Script:** "For admin registration, the system validates an admin passkey (ADMIN_PASSKEY = 'child1234'). Users must enter this key correctly to register as an administrator. This adds an extra security layer to prevent unauthorized admin account creation."

**Security Purpose:**
- Prevents unauthorized admin access
- Simple but effective access control
- Can be changed in configuration

---

## 3. SECURITY & SESSION MANAGEMENT (4 Functions)

### 3.1 load_user() - Line 242
**Script:** "This is the Flask-Login user loader function. It's decorated with @login_manager.user_loader and is called automatically by Flask-Login to reload the user object from the user ID stored in the session. It queries the database for the user's current information and returns a User object."

**Purpose:** Session management and user persistence

---

### 3.2 check_session_timeout() - Line 259
**Script:** "This is a middleware function decorated with @app.before_request, meaning it runs before every request. It implements role-based session timeout. Parent users have a 30-minute inactivity timeout, while admin users have no timeout. If a parent user is inactive for 30 minutes, their session expires and they must log in again."

**Timeout Rules:**
- Parents: 30-minute inactivity timeout
- Admins: No timeout
- Skips static files and non-authenticated routes

---

### 3.3 roles_required() - Line 409
**Script:** "This is a custom decorator function for role-based access control. It wraps Flask routes to ensure only users with specific roles can access them. The function checks if the user is authenticated and if their role matches the required roles. If not, it redirects to login with an error message."

**Usage Example:**
```python
@app.route('/admin/dashboard')
@login_required
@roles_required('admin')
def admin_dashboard():
    # Only admins can access
```

---

### 3.4 Token Validation - Lines 1216-1220
**Script:** "For password reset functionality, the system generates and validates time-sensitive tokens using URLSafeTimedSerializer. Tokens expire after 1 hour (3600 seconds) for security. If a token is invalid or expired, the user must request a new reset link."

**Security Features:**
- Cryptographically secure tokens
- 1-hour expiration
- Salt-based token generation
- Exception handling for invalid tokens

---

## 4. ACCOUNT STATUS VALIDATION (3 Checks)

### 4.1 Deleted Account Check - Lines 629-633
**Script:** "During login, the system checks if the user account has been soft-deleted by checking the deleted_at field. If the account is deleted, login is blocked and the user is instructed to contact an administrator for account restoration."

**Implementation:**
- Checks `deleted_at` field
- Blocks deleted users from logging in
- Provides appropriate error message

---

### 4.2 Inactive Account Check - Lines 636-640
**Script:** "The system also checks the is_active flag during login. If an account has been deactivated by an administrator, the user cannot log in and receives a message to contact support."

**Implementation:**
- Checks `is_active` field
- Blocks inactive accounts
- Admin can reactivate accounts

---

### 4.3 Password Hash Verification - Line 627
**Script:** "Password verification is done securely using bcrypt's check_password_hash function. It compares the submitted password with the hashed password stored in the database. This is cryptographically secure and prevents password exposure."

**Security:**
- Uses bcrypt algorithm
- One-way hashing
- No password storage in plain text

---

## 5. HELPER FUNCTIONS (2 Functions)

### 5.1 normalize_role() - Line 397
**Script:** "This helper function normalizes user role names to ensure consistency. It converts role strings to lowercase and maps aliases like 'administrator' to 'admin'. This prevents role-based access control issues due to inconsistent role names."

**Mappings:**
- "administrator" → "admin"
- "admin" → "admin"
- "parent" → "parent"

---

### 5.2 User Class - Line 230
**Script:** "This is the User model class that inherits from Flask-Login's UserMixin. It represents a user object with id, name, email, and role attributes. The get_id() method is required by Flask-Login to retrieve the user ID for session management."

**Attributes:**
- id: User's unique identifier
- name: User's full name
- email: User's email address
- role: User's role (admin/parent)

---

## 6. EMAIL NOTIFICATION FUNCTIONS (4 Functions)

### 6.1 send_reset_email() - Line 711
**Script:** "This function sends password reset emails to users who forgot their password. It uses Flask-Mail to send an email containing a secure reset link with a time-limited token. The email includes instructions on how to reset the password."

**Email Content:**
- Reset link with token
- Expiration warning (1 hour)
- Instructions

---

### 6.2 send_inactivity_warning_email() - Line 764
**Script:** "This function sends warning emails to parent users who have been inactive for 23 days. It's part of the account lifecycle management system. The email warns users that their account will be deleted if they don't log in within 7 days."

**Purpose:** Account lifecycle management

---

### 6.3 send_final_warning_email() - Line 832
**Script:** "This function sends a final warning email to users who have been inactive for 28 days. It's their last notification before automatic account deletion. The email emphasizes urgency and provides the remaining days until deletion."

**Purpose:** Final deletion warning

---

### 6.4 send_deletion_confirmation_email() - Line 905
**Script:** "This function sends a confirmation email after an account has been soft-deleted. It informs users that their account was deleted due to inactivity and provides information on how to contact support if they wish to restore their account."

**Purpose:** Deletion confirmation and support information

---

## 7. PASSWORD SECURITY OPERATIONS (2 Operations)

### 7.1 Password Hashing - Lines 522, 592, 1241, 2596, 3766
**Script:** "Throughout the application, whenever a password is stored or updated, it is hashed using bcrypt's generate_password_hash function. Bcrypt is a secure password hashing algorithm that includes a salt and is computationally expensive, making it resistant to brute-force attacks. The hashed password is then decoded to UTF-8 and stored in the database."

**Security Features:**
- Bcrypt algorithm
- Automatic salt generation
- Slow hashing (prevents brute-force)
- One-way transformation

**Used In:**
- Parent registration
- Admin registration
- Password reset
- Password change

---

### 7.2 Password Verification - Lines 627, 2572
**Script:** "Password verification is performed using bcrypt's check_password_hash function. It takes the plain text password from the user and the hashed password from the database, and securely compares them. This function handles all the complexity of salt extraction and hashing internally."

**Used In:**
- Login authentication
- Current password verification during password change

---

## CONCLUSION

**Summary Script:**

"In conclusion, the User Authentication Module consists of 34 functions and operations organized into 7 categories:

1. **10 Core Authentication Functions** - Handle registration, login, logout, and password management
2. **9 Validation Functions** - Ensure data quality and security through input validation
3. **4 Security & Session Functions** - Manage user sessions and implement role-based access control
4. **3 Account Status Validations** - Verify account state during login
5. **2 Helper Functions** - Provide utility support for the authentication system
6. **4 Email Notification Functions** - Handle user communication throughout the account lifecycle
7. **2 Password Security Operations** - Implement secure password hashing and verification using bcrypt

This module ensures secure, robust user authentication with multiple layers of validation and security checks. It follows industry best practices including password hashing with bcrypt, time-limited tokens, role-based access control, and session management.

Thank you for your attention."

---

## KEY SECURITY FEATURES TO HIGHLIGHT

1. **Password Security**: Bcrypt hashing with salt
2. **Token-Based Reset**: Time-limited (1 hour) password reset tokens
3. **Role-Based Access Control**: Separate admin and parent roles with decorator-based protection
4. **Session Management**: Automatic 30-minute timeout for parent users
5. **Input Validation**: Comprehensive validation for all user inputs
6. **Account Protection**: Soft delete, activation status, and multiple login checks
7. **Email Enumeration Prevention**: Same response for existing/non-existing emails in password reset
8. **Admin Key Protection**: Passkey requirement for admin registration

---

## TECHNOLOGIES USED

- **Flask**: Web framework
- **Flask-Login**: Session management
- **Flask-Bcrypt**: Password hashing
- **Flask-Mail**: Email functionality
- **URLSafeTimedSerializer**: Secure token generation
- **MySQL**: Database storage
- **Regular Expressions**: Input validation

---

**END OF PRESENTATION SCRIPT**
