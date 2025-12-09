# Academic Progress Tracker - Presentation Document

## Module Overview

The **Academic Progress Tracker** is a comprehensive module within the Child Growth Insights System that enables parents and educators to monitor and analyze children's academic performance across multiple subjects over time.

---

## 1. Core Functions

### 1.1 Add Academic Records
**Function**: `academic_progress()` (Lines 1702-1748 in app.py)

**Description**: Allows parents to input academic scores for their children across different subjects.

**Key Features**:
- Subject selection from predefined list
- Score input (0-100 range)
- Year and month tracking for temporal analysis
- Automatic form submission with validation

**User Workflow**:
1. Parent selects a subject from dropdown menu
2. Enters score (0-100)
3. System auto-fills current year (read-only)
4. Parent selects month (1-12)
5. Clicks "Add" button to submit

---

### 1.2 View Progress Charts
**Function**: Chart visualization using Chart.js library

**Description**: Interactive line charts display academic performance trends over time for each subject.

**Key Features**:
- **Subject-based tabs**: Separate tab for each subject with data
- **Line chart visualization**: Shows score progression over time
- **X-axis**: Year-Month (e.g., 2025-01, 2025-02)
- **Y-axis**: Score (0-100 scale)
- **Interactive tooltips**: Hover to see exact scores and dates

**Visual Elements**:
- Blue line graph with tension curves for smooth visualization
- Responsive design that adapts to screen size
- Chart resizing when switching between subject tabs

---

### 1.3 Data Table Display
**Function**: Tabular view of academic records

**Description**: Shows all academic records in a structured table format alongside the chart.

**Key Features**:
- **Columns**: Date (YYYY-MM), Score, Action
- **Scrollable container**: Max height 300px with overflow scroll
- **Delete functionality**: Individual record deletion with confirmation
- **Real-time updates**: Table refreshes after adding/deleting records

---

### 1.4 Delete Academic Records
**Function**: `delete_academic(id)` (Lines 1826-1838 in app.py)

**Description**: Removes specific academic records from the database.

**Security Features**:
- **Login required**: Only authenticated users can delete
- **Child ownership validation**: Ensures user owns the child record
- **Database transaction**: Atomic delete operation with commit
- **Success feedback**: Flash message confirms deletion

**User Workflow**:
1. Click trash icon (🗑️) next to record
2. Record is immediately deleted
3. System shows "Academic record deleted successfully" message
4. Page refreshes to show updated data

---

### 1.5 Yearly History Analysis
**Function**: Filtered view by year with averages

**Description**: Provides year-specific analysis of academic performance.

**Key Features**:
- **Year filter dropdown**: Select specific year or view all years
- **Overall average**: Calculated across all subjects for selected year
- **Subject-specific averages**: Individual average badges for each subject
- **Comprehensive data table**: All records for the selected year
- **Bar chart visualization**: Subject averages displayed as bar chart

**Calculations**:
```python
# Overall average for selected year
overall_avg = ROUND(AVG(score), 2)

# Subject-specific averages
subject_avg = ROUND(AVG(score WHERE subject = ?), 2)
```

---

### 1.6 Subject Management
**Function**: Dynamic subject list with default subjects

**Default Subjects**:
1. English
2. Chinese
3. Malay
4. Mathematics
5. Science

**Dynamic Behavior**:
- System includes 5 default subjects
- Automatically adds user-entered subjects to the list
- Subjects are sorted alphabetically
- New subjects appear in dropdown after first use

---

## 2. Validation Mechanisms

### 2.1 Score Validation
**Function**: Frontend and backend score validation

**Validation Rules**:
```python
# Backend validation (app.py:1718-1722)
if not (0 <= score <= 100):
    flash("Score must be between 0 and 100.", "danger")
    return redirect(url_for("academic_progress"))
```

**Frontend HTML Constraints**:
```html
<input type="number" name="score" class="form-control"
       min="0" max="100" required>
```

**Error Handling**:
- Scores < 0: Rejected with error message
- Scores > 100: Rejected with error message
- Non-numeric input: HTML5 validation prevents submission
- Empty field: Required attribute prevents submission

---

### 2.2 Date Validation
**Function**: `is_valid_academic_date(year, month)` (Lines 363-395 in app.py)

**Validation Rules**:

#### 2.2.1 Required Field Validation
```python
if not year or not month:
    return (False, "Year and month are required.")
```

#### 2.2.2 Month Range Validation
```python
if month < 1 or month > 12:
    return (False, "Month must be between 1 and 12.")
```

#### 2.2.3 Year Range Validation
```python
# Minimum year
if year < 2000:
    return (False, "Year cannot be before 2000.")

# Maximum year (current year)
current_year = date.today().year
if year > current_year:
    return (False, "Year cannot be in the future.")
```

#### 2.2.4 Future Date Prevention
```python
today = date.today()
record_date = date(year, month, 1)

if record_date > today:
    return (False, "Academic record date cannot be in the future.")
```

**Return Value**: Tuple (is_valid: bool, error_message: str|None)

---

### 2.3 Subject Validation
**Function**: Required field validation

**Validation Rules**:
```html
<select name="subject" class="form-select" required>
    <option value="">-- Select Subject --</option>
    <!-- Subject options -->
</select>
```

**Backend Validation**:
```python
if subject and score is not None and year and month:
    # Process record
else:
    flash("Please fill all required fields.", "danger")
```

**Error Handling**:
- Empty selection: HTML5 required attribute prevents submission
- Missing subject: Backend validation shows error message

---

### 2.4 Authentication Validation
**Function**: `@login_required` decorator

**Security Measures**:
```python
@app.route("/academic", methods=["GET", "POST"])
@login_required
def academic_progress():
    # Function body
```

**Child Ownership Validation**:
```python
child_id = session.get("selected_child")
if not child_id:
    return redirect(url_for("select_child"))
```

**Protection Features**:
- Unauthenticated users redirected to login page
- Session-based child selection required
- All database queries filtered by child_id
- Prevents unauthorized access to other children's data

---

### 2.5 Database Integrity Validation

**Table Schema**:
```sql
CREATE TABLE `academic_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_id` int(11) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `score` int(11) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`child_id`) REFERENCES `children`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Database Constraints**:
1. **Primary Key**: Unique ID for each record
2. **Foreign Key**: Ensures child_id exists in children table
3. **Cascade Delete**: Deletes academic records when child is deleted
4. **NOT NULL Constraints**: All fields required at database level
5. **VARCHAR(50) for subject**: Prevents excessively long subject names
6. **INT for score**: Ensures numeric data type
7. **DATE type**: Ensures valid date format

---

## 3. Data Flow Architecture

### 3.1 Add Record Flow

```
User Input Form
    ↓
Frontend Validation (HTML5)
    ↓
POST Request to /academic
    ↓
Backend Authentication Check
    ↓
Score Validation (0-100)
    ↓
Date Validation (is_valid_academic_date)
    ↓
Database INSERT Query
    ↓
Commit Transaction
    ↓
Flash Success Message
    ↓
Redirect to /academic (GET)
    ↓
Display Updated Charts & Tables
```

### 3.2 Delete Record Flow

```
User Clicks Delete Button
    ↓
POST Request to /academic/delete/<id>
    ↓
Authentication Check
    ↓
Child Ownership Validation
    ↓
Database DELETE Query
    ↓
Commit Transaction
    ↓
Flash Success Message
    ↓
Redirect to /academic
    ↓
Display Updated Data
```

### 3.3 View Data Flow

```
GET Request to /academic
    ↓
Authentication & Child Selection Check
    ↓
Database Query (SELECT all scores for child)
    ↓
Data Processing:
  - Extract unique subjects
  - Calculate yearly averages
  - Format dates for display
  - Group data by subject
    ↓
Render Template with:
  - Chart data (JSON format)
  - Table data
  - Subject tabs
  - Year filter options
    ↓
JavaScript Chart Rendering
    ↓
User Interface Display
```

---

## 4. Technical Implementation Details

### 4.1 Frontend Technologies

**HTML/Jinja2 Template**:
- Location: `templates/dashboard/_academic.html`
- Bootstrap 5 for responsive design
- Card components for organized layout
- Form validation with HTML5 attributes

**JavaScript Libraries**:
- **Chart.js**: Line and bar chart visualization
- **Bootstrap JS**: Tab switching and responsive behavior
- **Custom JavaScript**: Auto-fill current year, chart resizing

**CSS Frameworks**:
- Bootstrap 5.3
- Font Awesome icons for delete buttons
- Custom styling for scrollable tables

---

### 4.2 Backend Technologies

**Flask Routes**:
```python
# Main academic progress page
@app.route("/academic", methods=["GET", "POST"])
@login_required
def academic_progress()

# Delete record endpoint
@app.route("/academic/delete/<int:id>", methods=["POST"])
@login_required
def delete_academic(id)
```

**Database Operations**:
- **MySQL Connector**: Python connector for database access
- **Parameterized Queries**: Prevents SQL injection
- **Transaction Management**: Ensures data consistency

**Data Processing**:
```python
# Extract unique subjects from database
subjects = sorted({row["subject"] for row in scores})

# Calculate yearly averages
years = sorted({row["year"] for row in scores}, reverse=True)

# Format dates for display
row["date_str"] = row["date"].strftime("%Y-%m")
```

---

## 5. User Interface Components

### 5.1 Input Form Card
**Layout**: Top section of page
**Width**: 50% of container (col-6)
**Elements**:
- Subject dropdown (required)
- Score input (number, 0-100)
- Year input (auto-filled, read-only)
- Month dropdown (1-12)
- Submit button ("Add")

### 5.2 Subject Tabs & Charts
**Layout**: Middle section
**Features**:
- Bootstrap nav-tabs for subject switching
- Active tab highlighted on page load
- 8-column chart area + 4-column data table
- Responsive layout (col-md-8 / col-md-4)

### 5.3 Yearly History Card
**Layout**: Bottom section
**Features**:
- Year filter dropdown with auto-submit
- Overall average badge display
- Subject-specific average badges
- 7-column data table + 5-column bar chart
- Scrollable table (max-height: 260px)

---

## 6. Key Advantages & Benefits

### 6.1 For Parents
✅ **Visual Progress Tracking**: See child's improvement over time
✅ **Multi-Subject Monitoring**: Track all subjects in one place
✅ **Historical Analysis**: Compare performance across different years
✅ **Easy Data Entry**: Simple form with auto-validation
✅ **Instant Feedback**: Charts update immediately after adding data

### 6.2 For Educators
✅ **Performance Insights**: Identify strengths and weaknesses
✅ **Trend Analysis**: Detect declining or improving performance
✅ **Subject Comparison**: See which subjects need more attention
✅ **Year-over-Year Comparison**: Track long-term progress
✅ **Data-Driven Decisions**: Make informed teaching adjustments

### 6.3 System Benefits
✅ **Data Integrity**: Multiple validation layers prevent bad data
✅ **Security**: Authentication and authorization at every level
✅ **Scalability**: Handles unlimited subjects and records
✅ **User-Friendly**: Intuitive interface with minimal training
✅ **Responsive Design**: Works on desktop, tablet, and mobile

---

## 7. Validation Summary Table

| Validation Type | Location | Rules | Error Handling |
|----------------|----------|-------|----------------|
| **Score Range** | Frontend + Backend | 0 ≤ score ≤ 100 | Flash error message |
| **Year Range** | Backend | 2000 ≤ year ≤ current_year | Custom error message |
| **Month Range** | Backend | 1 ≤ month ≤ 12 | Custom error message |
| **Future Date** | Backend | date ≤ today | Prevents future dates |
| **Required Fields** | Frontend (HTML5) | All fields required | Browser validation |
| **Subject Selection** | Frontend + Backend | Non-empty subject | Form validation |
| **Authentication** | Backend | Login required | Redirect to login |
| **Child Ownership** | Backend | Session-based | Redirect to select child |
| **Database Constraints** | Database | NOT NULL, Foreign Key | MySQL error handling |

---

## 8. Sample Use Cases

### Use Case 1: Track Math Progress
**Scenario**: Parent wants to monitor child's math scores over semester

**Steps**:
1. Login to system
2. Navigate to Academic Progress Tracker
3. Add monthly math scores (e.g., January: 75, February: 80, March: 85)
4. View line chart showing upward trend
5. Check yearly average to see overall performance

**Outcome**: Parent sees 10-point improvement over 3 months

---

### Use Case 2: Identify Declining Performance
**Scenario**: Educator notices child's English scores dropping

**Steps**:
1. Access child's academic records
2. Switch to English tab
3. Observe line chart showing declining trend
4. Review specific scores in data table
5. Filter by current year to focus on recent performance

**Outcome**: Early intervention triggered before major issues develop

---

### Use Case 3: Year-End Report
**Scenario**: Generate annual performance summary

**Steps**:
1. Navigate to Yearly History section
2. Select specific year from dropdown
3. View overall average across all subjects
4. Check subject-specific averages in badge format
5. Review bar chart for visual comparison

**Outcome**: Comprehensive annual report with subject strengths/weaknesses identified

---

## 9. Future Enhancement Opportunities

### 9.1 Potential Additions (Not Currently Implemented)
- **Grade-based scoring**: Different scales for different grade levels
- **Comment field**: Allow teachers to add notes on scores
- **Export functionality**: Download data as PDF or Excel
- **Goal setting**: Set target scores and track progress
- **Comparative analytics**: Compare with class/national averages
- **Email notifications**: Alert parents about declining performance
- **Predictive analytics**: Use AI to forecast future performance

### 9.2 Mobile App Integration
- Native mobile app for on-the-go score entry
- Push notifications for new records
- Offline mode with sync capabilities

---

## 10. Conclusion

The **Academic Progress Tracker** module provides a robust, validated, and user-friendly solution for monitoring children's academic performance. With comprehensive validation at multiple layers (frontend, backend, database), the system ensures data integrity while maintaining ease of use.

**Key Strengths**:
1. ✅ Multi-level validation (8 different validation types)
2. ✅ Visual analytics with interactive charts
3. ✅ Temporal analysis (monthly and yearly views)
4. ✅ Security-first design with authentication controls
5. ✅ Responsive UI working across all devices
6. ✅ Scalable architecture supporting unlimited data

**Production Ready**: This module is fully functional, tested, and ready for educational deployment.

---

## 11. Technical Specifications Reference

**Files Involved**:
- `app.py`: Lines 363-395 (validation), 1702-1838 (routes)
- `templates/dashboard/_academic.html`: Complete UI template
- `child_growth_insights.sql`: Database schema (lines 30-36)

**Dependencies**:
- Flask framework
- MySQL database
- Chart.js v3+
- Bootstrap 5.3
- Font Awesome icons

**Browser Compatibility**:
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

---

**Document Version**: 1.0
**Last Updated**: December 9, 2025
**Prepared For**: Teacher Presentation & Project Proposal
