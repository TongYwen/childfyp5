# ChildGrowth Insight System - Actual System Flow Analysis

**Generated**: 2025-12-08
**Focus**: Real implementation flows, data movement, and system behavior
**Codebase**: /home/user/childfyp5/

---

## 1. SYSTEM ARCHITECTURE OVERVIEW

### Technology Stack
- **Backend**: Flask (Python) - Single monolithic application (app.py)
- **Database**: MySQL with direct SQL queries (no ORM)
- **AI Engine**: Google Gemini 2.5 Flash API
- **Frontend**: Server-side rendered Jinja2 templates with Bootstrap
- **Session**: Flask-Login + server-side sessions
- **Email**: Flask-Mail (SMTP)
- **Scheduler**: APScheduler for background tasks

### Architecture Pattern
**Monolithic Flask Application** - All logic in single app.py file (4,549 lines):
```
Request → Flask Route → Business Logic → Database → Response
         ↓
    Direct SQL queries (no service layer)
```

---

## 2. AUTHENTICATION & SESSION FLOW

### 2.1 User Registration Flow

**Parent Registration** (`app.py:478-540`):
```
1. User visits /register/parent
2. User fills: name, email, password
3. System validates:
   - Password strength (8+ chars, uppercase, lowercase, symbol)
   - Name format (letters only, no special chars)
   - Email format (regex validation)
4. System checks duplicate email in database
5. System hashes password with Bcrypt (cost factor 12)
6. System inserts user record:
   - role: 'parent'
   - is_active: 1
   - created_at: now
   - last_login: now
7. User redirected to /login
```

**Admin Registration** (`app.py:543-610`):
```
1. User visits /register/admin
2. User enters admin passkey: "child1234"
3. If correct → same flow as parent but role = 'admin'
4. If wrong → registration denied
```

### 2.2 Login Flow (`app.py:613-685`)

```
1. User enters email + password at /login

2. System queries database:
   SELECT id, name, email, password, role, is_active, deleted_at
   FROM users WHERE email = ?

3. System checks password:
   bcrypt.check_password_hash(stored_hash, entered_password)

4. If password correct:

   4a. Check if account deleted:
       - If deleted_at IS NOT NULL → Block login, show "account deleted"

   4b. Check if account active:
       - If is_active = 0 → Block login, show "account deactivated"

   4c. Update account status:
       UPDATE users SET
         last_login = NOW(),
         is_active = 1,  -- Reactivate if was inactive
         inactive_warning_sent = NULL  -- Clear warning flag
       WHERE id = ?

   4d. Security: Regenerate session
       - session.clear()
       - session.regenerate = True

   4e. Login user via Flask-Login:
       - login_user(user_obj)

   4f. Configure session based on role:
       - If PARENT: session.permanent = True, 30-min timeout
       - If ADMIN: session.permanent = True, NO timeout

   4g. Role-based redirect:
       - Admin → /admin/dashboard
       - Parent → /profile

5. If password wrong → Show "Invalid credentials"
```

### 2.3 Session Management Flow (`app.py:258-297`)

**Executed on EVERY request via @app.before_request**:

```
For each HTTP request:

1. Skip if:
   - Static file (CSS, JS, images)
   - User not authenticated

2. If user is PARENT:

   a. First request after login?
      - Set session['last_activity'] = now
      - Return (allow request)

   b. Subsequent requests:
      - Get last_activity from session
      - Calculate: time_elapsed = now - last_activity
      - If time_elapsed > 30 minutes:
          * logout_user()
          * Flash "session expired" message
          * Redirect to /login
      - Else:
          * Update session['last_activity'] = now
          * Allow request to proceed

3. If user is ADMIN:
   - session.permanent = True
   - NO timeout check (admins never time out)
```

**Session Timeout Summary**:
- Parents: 30-minute inactivity timeout
- Admins: Never timeout
- Timeout resets on any activity (page load, form submit, AJAX call)

---

## 3. PARENT USER JOURNEY FLOW

### 3.1 Initial Setup Flow

**After First Login** (`app.py:1261-1586`):
```
1. Parent logs in → Redirected to /profile

2. Profile page shows:
   - Parent's name, email
   - List of children (initially empty)
   - "Add Child" button

3. Parent clicks "Add Child" → /profile/child/add

4. Parent fills child form:
   - Name (required, letters only)
   - Date of Birth (required, YYYY-MM-DD, must be 0-18 years ago)
   - Age (auto-calculated from DOB)
   - Grade Level (optional, alphanumeric + hyphens)
   - Gender (Male/Female/Other)
   - Notes (optional, free text)

5. System validates all fields

6. System inserts child:
   INSERT INTO children (parent_id, name, dob, age, grade_level, gender, notes, created_at)
   VALUES (current_user.id, ...)

7. Parent redirected to /profile
   - Can add multiple children
   - Can edit/delete children
```

### 3.2 Child Selection Flow (`app.py:1261-1286`)

**Before accessing dashboard, parent must select which child to track**:

```
1. Parent clicks "Dashboard" → System checks session['selected_child']

2. If NO child selected:
   - Redirect to /select-child
   - Show all children linked to parent
   - Parent clicks on a child
   - System sets: session['selected_child'] = child_id
   - Redirect to /dashboard

3. If child already selected:
   - Proceed to dashboard with that child's data

4. Switching children:
   - Parent can change selected child anytime
   - All dashboard modules automatically switch to new child's data
```

### 3.3 Main Dashboard Flow (`app.py:1289-1359`)

**Central hub that loads all child data**:

```
1. Verify child selected (or redirect to select-child)

2. Load child details:
   SELECT * FROM children
   WHERE id = session['selected_child']
   AND parent_id = current_user.id

3. Load academic scores:
   SELECT * FROM academic_scores
   WHERE child_id = ?
   ORDER BY date ASC

4. Load AI analysis summaries:
   SELECT module, result, updated_at
   FROM ai_results
   WHERE child_id = ?
   AND module IN ('preschool', 'learning', 'tutoring')

5. Render dashboard with tabs:
   - Overview (academic chart)
   - Academic Progress
   - Preschool Tracker
   - Learning Style
   - Tutoring
   - Games
   - Resources
   - AI Insights
   - Learning Plan
```

---

## 4. DATA COLLECTION FLOWS

### 4.1 Academic Progress Data Flow (`app.py:1700-1822`)

**Parent records academic scores**:

```
1. Parent navigates to Academic Progress tab

2. System loads existing scores:
   SELECT * FROM academic_scores
   WHERE child_id = ?
   ORDER BY date ASC

3. System extracts unique subjects for dropdown

4. System groups scores by subject for charting

5. Parent enters new score:
   - Subject (dropdown or custom text)
   - Score (0-100, validated)
   - Year (dropdown, 2000-current)
   - Month (dropdown, 1-12)

6. System validates:
   - Score between 0-100
   - Date not in future
   - All fields present

7. System inserts:
   INSERT INTO academic_scores (child_id, subject, score, date)
   VALUES (?, ?, ?, 'YYYY-MM-01')

8. System recalculates:
   - Subject-wise averages
   - Overall average
   - Chart data for visualization

9. Page reloads with updated chart
```

**Data Flow**: Parent → academic_scores table → Chart.js visualization

### 4.2 Preschool Assessment Data Flow (`app.py:1850-2267`)

**Parent records developmental milestones**:

```
1. Parent navigates to Preschool Tracker tab

2. System loads existing assessments:
   SELECT * FROM preschool_assessments
   WHERE child_id = ?
   ORDER BY date DESC

3. For each assessment, system calculates child's age at that time:
   age_in_months = calculate_months_difference(child.dob, assessment.date)

4. Parent adds new assessment:
   - Domain: Social/Emotional, Cognitive, Language/Communication, Movement/Physical
   - Description: Free text (max 500 chars)
   - Date: YYYY-MM (month of observation)

5. System validates and inserts:
   INSERT INTO preschool_assessments (child_id, domain, description, date)
   VALUES (?, ?, ?, ?)

6. After insert, system automatically:
   - Recalculates age for all assessments
   - Triggers AI analysis check (see section 5.2)

7. Page reloads with new assessment + updated AI analysis
```

**Data Flow**: Parent → preschool_assessments table → Gemini AI analysis → ai_results table → Display

### 4.3 Learning Style Data Flow (`app.py:2268-2729`)

**Two parallel data collection methods**:

**Method 1: Manual Observations** (`app.py:2680-2703`):
```
1. Parent navigates to Learning Style tab

2. Parent enters observation text:
   - Example: "She prefers looking at picture books"
   - Example: "Gets excited with hands-on activities"

3. System saves:
   INSERT INTO learning_observations (child_id, observation, created_at)
   VALUES (?, ?, NOW())

4. Observations accumulate over time
   - Each observation timestamped
   - Used as context for AI analysis
```

**Method 2: Structured Questionnaires** (`app.py:2634-2679`):
```
1. Admin creates questionnaire:
   - Test name: "VARK Learning Style Assessment"
   - Questions with categories: visual, auditory, reading, kinesthetic

2. Parent takes questionnaire:
   - Answers on scale 1-5 for each question
   - Example: "Child enjoys listening to stories" (Auditory)

3. System saves each answer:
   INSERT INTO test_answers (test_id, question_id, child_id, answer)
   VALUES (?, ?, ?, ?)

4. System groups answers by VARK category for AI analysis
```

**Data Flow**:
- Parent → learning_observations table → AI analysis
- Parent → test_answers table (grouped by category) → AI analysis
- Both → Gemini AI → ai_results table → Display

---

## 5. AI PROCESSING FLOWS

### 5.1 AI Caching Strategy

**All AI modules use intelligent caching to save API costs**:

```
1. Before calling Gemini AI:

   a. Create data_payload (JSON of input data)

   b. Check cached result:
      SELECT * FROM ai_results
      WHERE child_id = ? AND module = ?

   c. Compare data:
      - If cached.data == current_data_payload:
          * Return cached result
          * Skip AI call
      - Else:
          * Data changed, need new analysis

2. When to regenerate:
   - Data changed (new assessments, observations, answers)
   - User clicks "Regenerate" button (regen=1 parameter)
   - No cached result exists

3. After AI processing:
   - Save both input (data) and output (result)
   - Update updated_at timestamp
```

**Caching Impact**:
- Reduces API costs (Gemini charges per token)
- Faster page loads (no AI wait time)
- Consistent results (same data = same analysis until regenerated)

### 5.2 Preschool AI Analysis Flow (`app.py:1995-2045`)

**Developmental milestone analysis with benchmark comparison**:

```
1. Trigger points:
   - Parent visits preschool page
   - New assessment added
   - Parent clicks "Regenerate Analysis"

2. Check cache (see 5.1)

3. If analysis needed:

   a. Load child data:
      - Name, DOB, age, grade

   b. Load all assessments with calculated ages:
      - Assessment 1: "Shares toys with others" at 36 months
      - Assessment 2: "Recognizes colors" at 38 months
      - etc.

   c. Load benchmark data:
      - Read static/data/developmental_milestones.csv
      - 200+ milestones from 2-60 months
      - Categories: Language, Cognitive, Movement, Social/Emotional

   d. Build AI prompt:
      """
      You are a child development expert.

      Child: {name}, {age} years old, Grade {grade}

      Developmental Assessments:
      {list of assessments with ages}

      Benchmark Milestones:
      {CSV data of expected milestones}

      Compare this child's development to benchmarks.
      Identify: Age-appropriate, Advanced, Delayed areas
      Provide tips for parents.
      Format as HTML.
      """

   e. Send to Gemini AI:
      model = genai.GenerativeModel("gemini-2.5-flash")
      response = model.generate_content(prompt)

   f. Save result:
      INSERT/UPDATE ai_results
      SET data = {assessments_json},
          result = {html_response},
          updated_at = NOW()
      WHERE child_id = ? AND module = 'preschool'

4. Display HTML analysis on page
```

**Data Flow**:
```
preschool_assessments → Child age calculation →
Benchmark CSV → Gemini AI prompt →
Gemini API → HTML response →
ai_results table → Display
```

### 5.3 Learning Style AI Analysis Flow (`app.py:2356-2531`)

**VARK learning style assessment**:

```
1. Trigger points:
   - Parent visits learning style page
   - New observation added
   - New questionnaire completed
   - Parent clicks "Generate/Regenerate Analysis"

2. Check if data exists:
   - If NO observations AND NO questionnaire answers:
      * Show "No data available" message
      * Don't call AI

3. Check cache (see 5.1)

4. If analysis needed:

   a. Prepare observations:
      - Format with dates: "2024-12-01: Loves drawing pictures"

   b. Group questionnaire answers by VARK category:
      Visual: [5, 4, 5, 3] (answers to visual questions)
      Auditory: [3, 3, 4, 2]
      Reading: [4, 5, 5, 4]
      Kinesthetic: [5, 5, 4, 5]

   c. Build AI prompt:
      """
      You are a learning style assessment expert.

      Child: {name}, {age} years old

      Parent Observations:
      {formatted observations}

      Questionnaire Responses (VARK):
      Visual: {scores}
      Auditory: {scores}
      Reading/Writing: {scores}
      Kinesthetic: {scores}

      Analyze the child's learning style using VARK framework.

      Provide:
      1. Rating for each style (Strong/Moderate/Weak)
      2. Identify main learning style
      3. 3 practical tips for parents

      Format as HTML.
      """

   d. Send to Gemini AI

   e. Parse response for:
      - Visual rating
      - Auditory rating
      - Reading/Writing rating
      - Kinesthetic rating
      - Main style identification
      - Parent tips

   f. Save result:
      DELETE FROM ai_results WHERE child_id = ? AND module = 'learning'
      INSERT INTO ai_results (child_id, module, data, result, created_at)

5. Display HTML analysis
```

**Data Flow**:
```
learning_observations + test_answers →
Group by VARK → Format observations →
Gemini AI prompt → Gemini API →
VARK analysis HTML → ai_results table → Display
```

### 5.4 Tutoring Recommendations AI Flow (`app.py:2730-2952`)

**AI-powered learning recommendations with product suggestions**:

```
1. Prerequisites:
   - Learning style analysis exists
   - OR preschool analysis exists
   - (At least one required)

2. If no prerequisite data:
   - Show "Run assessments first" message
   - Don't call AI

3. Fetch dependency data:
   SELECT result FROM ai_results
   WHERE child_id = ?
   AND module IN ('learning', 'preschool')

4. Check cache (comparing learning + preschool data)

5. If analysis needed:

   a. Build comprehensive prompt:
      """
      You are a child education advisor.

      Child: {name}, {age} years old, Grade {grade}

      BACKGROUND DATA (for analysis only, don't repeat):

      Preschool Development:
      {preschool_analysis_html}

      Learning Style:
      {learning_style_analysis_html}

      Based on above, provide 4 sections:

      1. Potential Weak Areas
      2. Recommended Focus Areas for Tutoring
      3. Personalized Activities
      4. Recommended Learning Materials (3-5 products)

      For products, use this EXACT format:
      [PRODUCT_START]
      Name: Learning to Read Workbook
      Type: workbook
      Category: books
      Subject: english
      Learning Style: visual
      Age: 4-6 years
      Price: RM 29.90
      Why: Helps with letter recognition...
      Keywords: reading workbook phonics
      Priority: high
      [PRODUCT_END]

      Format response as HTML.
      """

   b. Send to Gemini AI

   c. Extract products from response:
      - Regex match [PRODUCT_START]...[PRODUCT_END] blocks
      - Parse each product field
      - For each product:
          * Generate shopping links:
            - Amazon: https://amazon.com/s?k={keywords}
            - Shopee: https://shopee.com.my/search?keyword={keywords}
            - Lazada: https://lazada.com.my/catalog/?q={keywords}
          * Calculate price_range: budget/mid_range/premium
          * INSERT INTO product_recommendations

   d. Remove product tags from HTML (clean for display)

   e. Save result:
      INSERT/UPDATE ai_results (module='tutoring', data={dependencies}, result={html})

6. Fetch top 10 products for display:
   SELECT * FROM product_recommendations
   WHERE child_id = ?
   ORDER BY priority DESC, created_at DESC
   LIMIT 10

7. Display recommendations + product cards with shopping links
```

**Data Flow**:
```
ai_results(learning) + ai_results(preschool) →
Gemini AI prompt → Gemini API →
HTML with [PRODUCT_START] tags →
Extract products → Generate e-commerce links →
product_recommendations table + ai_results table →
Display recommendations + Product cards with Amazon/Shopee/Lazada links
```

**Product Extraction Function** (`app.py:101-228`):
```python
def extract_products_from_response(response_text, child_id, cursor):
    # Regex: \[PRODUCT_START\](.*?)\[PRODUCT_END\]
    matches = re.findall(pattern, response_text, re.DOTALL)

    for match in matches:
        # Parse fields
        name = extract_field(match, 'Name')
        type = extract_field(match, 'Type')
        keywords = extract_field(match, 'Keywords')

        # Generate shopping links
        links = generate_product_links(keywords, type)
        # Returns: {amazon_url, shopee_url, lazada_url}

        # Insert product
        INSERT INTO product_recommendations (
            child_id, product_name, product_type,
            amazon_url, shopee_url, lazada_url, ...
        )

    # Remove tags from HTML
    cleaned_html = re.sub(pattern, '', response_text)
    return cleaned_html
```

---

## 6. MODULE INTEGRATION & DATA DEPENDENCIES

### 6.1 Data Dependency Graph

```
                    ┌──────────────┐
                    │   children   │
                    │   (parent)   │
                    └──────┬───────┘
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
┌─────────────────┐ ┌──────────────┐ ┌──────────────────┐
│academic_scores  │ │  preschool_  │ │   learning_      │
│                 │ │  assessments │ │   observations   │
└─────────────────┘ └──────┬───────┘ └────────┬─────────┘
                           │                  │
                           ▼                  ▼
                    ┌──────────────┐   ┌──────────────┐
                    │  ai_results  │   │test_answers  │
                    │   (module:   │   └──────┬───────┘
                    │  'preschool')│          │
                    └──────┬───────┘          │
                           │                  │
                           └────────┬─────────┘
                                    │
                                    ▼
                             ┌──────────────┐
                             │  ai_results  │
                             │   (module:   │
                             │  'learning') │
                             └──────┬───────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
             ┌──────────────┐              ┌─────────────────┐
             │  ai_results  │              │    product_     │
             │   (module:   │              │ recommendations │
             │  'tutoring') │              └─────────────────┘
             └──────────────┘
```

### 6.2 Module Dependencies

**Independent Modules** (no dependencies):
- Academic Progress Tracker
- Preschool Performance Tracker
- Learning Style Analyzer

**Dependent Module**:
- **Tutoring Recommendations** requires:
  - Learning Style analysis (ai_results where module='learning')
  - OR Preschool analysis (ai_results where module='preschool')
  - Minimum 1 required, both preferred

### 6.3 Cross-Module Data Flow Example

**Complete parent workflow to get tutoring recommendations**:

```
Step 1: Add Child
  POST /profile/child/add
  → children table

Step 2: Record Preschool Assessments
  POST /dashboard/preschool
  → preschool_assessments table
  → Trigger AI analysis
  → ai_results (module='preschool')

Step 3: Add Learning Observations
  POST /learning/observation/submit
  → learning_observations table

Step 4: Take VARK Questionnaire
  POST /learning/take_test
  → test_answers table
  → Trigger AI analysis
  → ai_results (module='learning')

Step 5: Generate Tutoring Recommendations
  GET /dashboard/tutoring
  → Fetch ai_results (learning + preschool)
  → Send to Gemini AI with combined data
  → Extract products
  → product_recommendations table
  → ai_results (module='tutoring')
  → Display recommendations + products
```

---

## 7. BACKGROUND PROCESSES & SCHEDULED TASKS

### 7.1 Inactive User Detection Flow (`app.py:966-1193`)

**APScheduler runs daily at 2:00 AM UTC**:

```
1. Job starts: check_inactive_users()

2. Query all active parents:
   SELECT id, name, email, last_login, inactive_warning_sent
   FROM users
   WHERE role = 'parent'
   AND is_active = 1
   AND deleted_at IS NULL

3. For each parent:

   Calculate: days_inactive = today - last_login

   IF days_inactive >= 23 AND warning_sent != 'first_warning':
      - Send first warning email: "7 days until deletion"
      - UPDATE users SET inactive_warning_sent = 'first_warning'

   ELIF days_inactive >= 28 AND warning_sent != 'final_warning':
      - Send final warning email: "2 days until deletion"
      - UPDATE users SET inactive_warning_sent = 'final_warning'

   ELIF days_inactive >= 30:
      - Check if protected:
          IF protected_from_deletion = 0:
             - Soft delete:
               UPDATE users SET
                 deleted_at = NOW(),
                 deletion_reason = 'Inactivity (30 days)',
                 is_active = 0
             - Send deletion confirmation email
             - Add to report

4. Generate inactivity report:
   - Total parents checked
   - First warnings sent (count)
   - Final warnings sent (count)
   - Accounts deleted (count)
   - List of deleted accounts

5. Email report to admins

6. Job completes, sleeps until next day 2 AM
```

### 7.2 Permanent Deletion Job (`app.py:1163-1193`)

**APScheduler runs daily at 3:00 AM UTC**:

```
1. Job starts: permanent_delete_old_accounts()

2. Query soft-deleted accounts older than 90 days:
   SELECT * FROM users
   WHERE deleted_at IS NOT NULL
   AND deleted_at < (NOW() - INTERVAL 90 DAY)

3. For each account:
   - Delete related data:
      * DELETE FROM children WHERE parent_id = ?
      * DELETE FROM academic_scores (cascade via child_id)
      * DELETE FROM preschool_assessments (cascade via child_id)
      * DELETE FROM learning_observations (cascade via child_id)
      * DELETE FROM test_answers (cascade via child_id)
      * DELETE FROM ai_results (cascade via child_id)
      * DELETE FROM product_recommendations (cascade via child_id)

   - Delete user:
      * DELETE FROM users WHERE id = ?

4. Log: "Permanently deleted {count} users"

5. Job completes
```

**Account Lifecycle Timeline**:
```
Day 0: Last login
Day 23: First warning email (7 days remaining)
Day 28: Final warning email (2 days remaining)
Day 30: Soft delete (deleted_at set, account blocked)
Day 120: Permanent delete (all data removed)
```

---

## 8. ADMIN WORKFLOW FLOWS

### 8.1 User Management Flow (`app.py:3746-4067`)

**Admin dashboard features**:

```
1. View all users:
   GET /admin/users

   Features:
   - Search by name/email
   - Filter by role (parent/admin)
   - Filter by status (active/inactive/deleted)
   - Sort by: name, email, created_at, last_login
   - Pagination (20 per page)

2. Create user manually:
   POST /admin/users

   - Admin can create parent/admin accounts
   - Send welcome email with credentials
   - Bypass registration validation

3. Edit user:
   GET/POST /admin/users/<user_id>/edit

   - Change name, email, role
   - Cannot change password (security)
   - Update last_login to keep active

4. Delete user:
   POST /admin/users/<user_id>/delete

   - Soft delete (sets deleted_at)
   - Check dependencies (children count)
   - Send deletion notification email

5. Toggle protection:
   POST /admin/users/<user_id>/toggle-protection

   - Set protected_from_deletion = 1
   - Prevents auto-deletion by scheduled job
   - Used for important accounts

6. Reactivate user:
   POST /admin/users/<user_id>/activate

   - Set is_active = 1
   - Clear inactive_warning_sent
   - User can log in again

7. Restore deleted user:
   POST /admin/users/<user_id>/restore

   - Set deleted_at = NULL
   - Set is_active = 1
   - User can log in again
```

### 8.2 Resource Management Flow (`app.py:4089-4271`)

**Admin curates educational resources**:

```
1. Create resource:
   POST /admin/resources/create

   Fields:
   - Title
   - Type: video, book, article, app, game
   - Description
   - Age range: age_min, age_max
   - URL (external link)

2. Edit resource:
   POST /admin/resources/<id>/edit

3. Delete resource:
   POST /admin/resources/<id>/delete

4. Parents view resources:
   GET /dashboard/resources

   - Filtered by selected child's age
   - Categorized by type
   - Clickable links to external sites
```

### 8.3 Questionnaire Management Flow (`app.py:4471-4549`)

**Admin creates learning assessments**:

```
1. Create questionnaire:
   POST /admin/tests/create

   - Test name (e.g., "VARK Learning Style")
   - Upload CSV with questions

2. CSV format:
   question,type,options,category,correct_answer
   "Child enjoys picture books",scale,,visual,
   "Child likes music",scale,,auditory,

3. System parses CSV:
   - Validates format
   - Inserts into test_questions table
   - Links to test_id

4. Parents take test:
   GET /learning/take_test/<child_id>

   - Displays all questions for test
   - Parent answers each question
   - Answers grouped by category for AI analysis

5. Edit test:
   POST /admin/tests/<id>/edit

   - Upload new CSV (replaces all questions)

6. Delete test:
   POST /admin/tests/<id>/delete

   - Cascade deletes questions and answers
```

---

## 9. DATA LIFECYCLE & STORAGE PATTERNS

### 9.1 Data Creation Patterns

**User-Generated Data** (Parent creates):
- children (profile data)
- academic_scores (performance tracking)
- preschool_assessments (milestone observations)
- learning_observations (free-text notes)
- test_answers (questionnaire responses)
- game_results (mini-game scores)

**System-Generated Data** (Automated):
- ai_results (AI analysis outputs)
- product_recommendations (extracted from AI)
- notifications (system alerts)

**Admin-Generated Data**:
- users (manual user creation)
- tests (questionnaires)
- test_questions (assessment items)
- resources (curated content)
- games (mini-game configs)

### 9.2 Data Update Patterns

**Immutable Data** (Never updated, only inserted):
- academic_scores (historical record)
- preschool_assessments (historical record)
- learning_observations (historical record)
- test_answers (historical record)
- game_results (historical record)

**Mutable Data** (Can be updated):
- users (profile changes, login timestamps, activity flags)
- children (profile updates)
- ai_results (regenerated when data changes)
- product_recommendations (refreshed with new AI analysis)

**Soft Delete Pattern**:
- users: deleted_at timestamp (not removed from DB)
- Permanent delete after 90 days

### 9.3 Data Deletion Patterns

**Cascade Deletes** (When parent user deleted):
```
DELETE user
  → DELETE children WHERE parent_id = user.id
    → DELETE academic_scores WHERE child_id IN (children.id)
    → DELETE preschool_assessments WHERE child_id IN (children.id)
    → DELETE learning_observations WHERE child_id IN (children.id)
    → DELETE test_answers WHERE child_id IN (children.id)
    → DELETE ai_results WHERE child_id IN (children.id)
    → DELETE product_recommendations WHERE child_id IN (children.id)
    → DELETE game_results WHERE child_id IN (children.id)
```

**Manual Deletes** (Individual records):
- DELETE single academic_score
- DELETE single preschool_assessment
- DELETE single learning_observation

---

## 10. SECURITY & VALIDATION FLOWS

### 10.1 Input Validation Flow

**Every user input goes through validation**:

```
Password Validation (app.py:301-305):
- Min 8 characters
- At least 1 uppercase letter
- At least 1 lowercase letter
- At least 1 special character
- Regex: ^(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9])(?=.{8,})

Name Validation (app.py:307-316):
- Letters and spaces only
- No numbers, no special chars
- Regex: ^[A-Za-z\s]+$

Grade Level Validation (app.py:318-335):
- Alphanumeric + hyphens + spaces
- Max 20 characters
- Examples: "K1", "Pre-K", "Preschool A"
- Regex: ^[A-Za-z0-9\s-]+$

Date of Birth Validation (app.py:337-361):
- Format: YYYY-MM-DD
- Not in future
- Not more than 18 years ago
- Reasonable for preschool app

Academic Date Validation (app.py:363-395):
- Year: 2000 to current year
- Month: 1-12
- Not in future

Score Validation:
- Integer between 0-100
- No negative numbers
- No decimals
```

### 10.2 Authorization Flow

**Role-Based Access Control**:

```
Public Routes (no login required):
- /
- /register/*
- /login
- /forgot
- /reset/<token>

Parent Routes (requires login, role='parent'):
- /profile
- /dashboard
- /academic
- /dashboard/preschool
- /dashboard/learning
- /dashboard/tutoring
- /dashboard/games
- /dashboard/resources

Admin Routes (requires login, role='admin'):
- /admin/dashboard
- /admin/users
- /admin/resources
- /admin/tests
- /admin/games

Decorator Pattern:
@app.route("/admin/users")
@login_required
@roles_required("admin")
def admin_users():
    # Only admins can access
    ...
```

### 10.3 Session Security

**Security Measures**:

```
1. Session Fixation Prevention:
   - On login: session.clear() + session.regenerate = True
   - New session ID generated

2. Session Cookie Security (config.py):
   - SESSION_COOKIE_SECURE = True (HTTPS only)
   - SESSION_COOKIE_HTTPONLY = True (no JavaScript access)
   - SESSION_COOKIE_SAMESITE = 'Lax' (CSRF protection)

3. Password Security:
   - Bcrypt hashing (cost factor 12)
   - Never stored in plaintext
   - Hash checked with bcrypt.check_password_hash()

4. SQL Injection Prevention:
   - Parameterized queries everywhere
   - Example: cursor.execute("SELECT * WHERE id = %s", (id,))
   - Never string concatenation

5. Email Validation:
   - Normalized to lowercase
   - Duplicate check before insert
```

---

## 11. ERROR HANDLING & EDGE CASES

### 11.1 AI Error Handling

**Gemini API errors handled gracefully**:

```
try:
    response = model.generate_content(prompt)
    html_result = response.text

except Exception as e:
    error_message = str(e).lower()

    if "quota" in error_message or "429" in error_message:
        # API quota exceeded
        return {"error": "quota_exceeded"}

    elif "token" in error_message:
        # Prompt too long
        return {"error": "token_limit"}

    else:
        # Other error
        return {"error": str(e)}
```

**Frontend Handling**:
- Quota exceeded: Show "API limit reached, try later"
- Token limit: Show "Too much data, reduce inputs"
- Other: Show generic error message

### 11.2 Database Error Handling

**Connection and query errors**:

```
def get_db_conn():
    try:
        conn = mysql.connector.connect(
            host=app.config["MYSQL_HOST"],
            user=app.config["MYSQL_USER"],
            password=app.config["MYSQL_PASSWORD"],
            database=app.config["MYSQL_DATABASE"]
        )
        return conn
    except mysql.connector.Error as e:
        flash("Database connection error", "danger")
        return None
```

**Transaction Pattern**:
```
conn = get_db_conn()
cursor = conn.cursor()
try:
    cursor.execute("INSERT ...")
    conn.commit()
except Exception as e:
    conn.rollback()
    flash("Operation failed", "danger")
finally:
    cursor.close()
    conn.close()
```

### 11.3 Edge Cases Handled

**No Data Scenarios**:
- No children linked → Redirect to add child
- No child selected → Redirect to select child
- No assessments → Show "Add first assessment" message
- No AI results → Show "Run analysis first" message
- No products → Show "Generate recommendations first"

**Invalid State Scenarios**:
- Deleted account tries to login → Block with message
- Inactive account tries to login → Block with message
- Wrong child_id in session → Clear session, redirect
- Parent tries admin route → Block with flash message
- Admin tries parent route → Redirect to admin dashboard

**Data Integrity**:
- Child belongs to different parent → Access denied
- Score out of range → Validation error
- Date in future → Validation error
- Duplicate email → Registration blocked

---

## 12. PERFORMANCE OPTIMIZATION PATTERNS

### 12.1 AI Caching Strategy

**Saves API costs and improves performance**:

```
Cache Hit Rate Optimization:
- Cache key: child_id + module + data_hash
- Cache invalidation: Only when data changes
- Cache lifetime: Indefinite (until data changes)

Example Savings:
- Without cache: 3 API calls per page load (preschool, learning, tutoring)
- With cache: 0 API calls if no data changed
- Cost reduction: ~95% (only new analyses)
```

### 12.2 Database Query Optimization

**Efficient query patterns**:

```
1. Single query for dashboard:
   SELECT module, result, updated_at
   FROM ai_results
   WHERE child_id = ?
   AND module IN ('preschool', 'learning', 'tutoring')

   Instead of 3 separate queries

2. Early return pattern:
   if not child_id:
       return redirect(url_for("select_child"))

   Avoid unnecessary database queries

3. Limit results:
   SELECT * FROM product_recommendations
   WHERE child_id = ?
   LIMIT 10

   Don't fetch all products if only showing top 10
```

### 12.3 Session Management Optimization

**Minimize session data**:

```
Session stores only:
- selected_child (child_id integer)
- last_activity (timestamp string)

Does NOT store:
- Child details (query on each page)
- Scores (query on each page)
- AI results (query on each page)

Benefit: Small session cookie, faster requests
```

---

## SUMMARY: COMPLETE SYSTEM FLOW

### Typical Parent Journey (Full Cycle)

```
1. REGISTRATION & SETUP
   Register → Login → Add Child → Select Child

2. DATA COLLECTION PHASE
   Record Academic Scores (ongoing)
   ↓
   Add Preschool Assessments (ongoing)
   ↓
   Add Learning Observations (ongoing)
   ↓
   Take VARK Questionnaire (once)

3. AI ANALYSIS PHASE
   Preschool AI analyzes developmental milestones
   ↓
   Learning Style AI analyzes VARK + observations
   ↓
   Tutoring AI combines both analyses

4. ACTIONABLE INSIGHTS
   View AI recommendations
   ↓
   View product suggestions
   ↓
   Click shopping links (Amazon/Shopee/Lazada)
   ↓
   Implement tips with child

5. CONTINUOUS MONITORING
   Add new assessments/scores
   ↓
   AI automatically regenerates when data changes
   ↓
   Track progress over time
   ↓
   Play educational games
   ↓
   View curated resources

6. ACCOUNT MAINTENANCE
   Stay active (login every 30 days)
   ↓
   Or receive inactivity warnings
   ↓
   Reactivate account if needed
```

### Data Flow Summary

```
Parent Input → MySQL Tables → AI Processing → AI Results → Parent Display
     ↓              ↓              ↓              ↓              ↓
  children    academic_scores   Gemini AI    ai_results    Dashboard
  profile      preschool        Cache        product_      Charts
  edit         assessments      Check        recommendations E-commerce
               learning_obs     Benchmark                   links
               test_answers     Prompt
```

### System Characteristics

**Strengths**:
1. Intelligent AI caching reduces costs
2. Role-based session management (parent timeout, admin no timeout)
3. Automated account cleanup (30-day inactivity, 90-day permanent delete)
4. Comprehensive input validation
5. Direct e-commerce integration (Amazon, Shopee, Lazada)
6. Modular AI pipeline (preschool → learning → tutoring)

**Architecture Patterns**:
1. Monolithic Flask application (simple, maintainable)
2. Direct SQL queries (no ORM overhead)
3. Server-side rendering (SEO-friendly, fast initial load)
4. Scheduled background jobs (APScheduler for cleanup)
5. Session-based authentication (Flask-Login)

---

## CONCLUSION

The ChildGrowth Insight System implements a **straightforward data collection → AI analysis → actionable recommendations** flow. The system prioritizes:

1. **Parent-centric design**: Easy data entry, automatic AI analysis
2. **Cost efficiency**: Intelligent caching minimizes AI API calls
3. **Data-driven insights**: Benchmark comparison + VARK analysis + combined tutoring recommendations
4. **Actionable outputs**: Direct shopping links for recommended products
5. **Account hygiene**: Automated cleanup of inactive accounts

The monolithic architecture keeps the system simple and maintainable while delivering sophisticated AI-powered features through the Gemini API integration.
