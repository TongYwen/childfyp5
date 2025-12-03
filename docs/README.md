# Preschool Performance Tracker - Activity Diagram Documentation

## Overview

This directory contains the overall activity diagram for the Preschool Performance Tracker module. The diagram illustrates the complete workflow and processes for all user roles and system components.

## Files

- `preschool_tracker_activity_diagram.puml` - PlantUML source file for the activity diagram

## Activity Diagram Contents

The activity diagram covers the following major areas:

### 1. **User Authentication**
- Login process for both Parent and Admin users
- Password reset workflow
- Session management

### 2. **Parent Workflows**

#### A. Preschool Development Tracking
- Enter developmental observations across 4 domains:
  - Social/Emotional Milestones
  - Cognitive Milestones
  - Language/Communication
  - Movement/Physical Development
- AI analysis against CDC benchmark data
- View developmental insights

#### B. Learning Style Analysis
- Log free-form learning observations
- Complete learning style questionnaires (Visual, Auditory, Kinesthetic, Reading/Writing)
- AI-powered learning preference identification
- View comprehensive learning style profile

#### C. Academic Progress Tracking
- Enter subject scores (Math, English, Science, Art, Music, etc.)
- Score validation (0-100 range)
- View progress charts and trends over time

#### D. AI Tutoring Recommendations
- System aggregates all child data (preschool assessments, learning style, academic performance)
- AI generates holistic analysis
- Personalized product recommendations with e-commerce links (Amazon, Shopee, Lazada)
- Identify weak areas and recommended focus areas

#### E. AI Insights Dashboard
- Comprehensive analysis of academic and game performance
- Strength/weakness identification
- Trend analysis
- Personalized improvement suggestions

#### F. Learning Plan Generator
- Synthesizes all AI modules
- Creates weekly/monthly learning plans
- Subject-specific strategies
- Activity recommendations

#### G. Educational Resources
- Browse curated learning resources (videos, books, articles, apps, games)
- Age-appropriate filtering
- Access external resource URLs

#### H. Interactive Mini-Games
- Play educational games:
  - Counting Animals (Ages 4-7)
  - Animal Vocabulary (Ages 4-7)
  - Animal Spelling (Ages 5-8)
- Score tracking with timing
- Performance monitoring

#### I. Child & Profile Management
- Add/edit/delete child profiles
- Update parent profile information
- Change password

### 3. **Admin Workflows**

#### A. User Management
- View all users (parents and admins)
- Edit user details
- Soft delete/restore users
- Toggle deletion protection
- View inactive and deleted users

#### B. Resource Management
- Create/edit/delete educational resources
- Set age ranges and URLs
- Categorize by type

#### C. Game Management
- Edit game metadata
- Set difficulty levels and age ranges
- Toggle active status

#### D. Test Management
- Create learning style questionnaires
- Add multimedia questions (images, audio)
- Categorize by learning style type

#### E. Manual Cleanup Operations
- Trigger inactive user cleanup
- View cleanup statistics

### 4. **Automated Background Processes**

#### A. Daily Inactive User Check (2:00 AM UTC)
- Calculate days since last login for all users
- **Day 23**: Send first warning email (7 days until deletion)
- **Day 28**: Send final warning email (2 days until deletion)
- **Day 30**: Soft delete account (unless protected)

#### B. Daily Permanent Deletion (3:00 AM UTC)
- Check soft-deleted users
- Permanently delete accounts > 90 days old
- Remove from database

### 5. **AI Analysis & Caching System**

The diagram shows the intelligent caching strategy used throughout the system:
- Calculate data hash from input parameters
- Check for cached AI results
- If cache hit and no regeneration requested: Return cached result
- If cache miss or regeneration: Call Google Gemini AI, store result, return fresh analysis
- Benefits: Cost reduction and faster response times

## How to View the Activity Diagram

### Option 1: Online PlantUML Viewer
1. Visit [PlantUML Online Server](http://www.plantuml.com/plantuml/uml/)
2. Copy the contents of `preschool_tracker_activity_diagram.puml`
3. Paste into the online editor
4. View the rendered diagram

### Option 2: VS Code Extension
1. Install the "PlantUML" extension in VS Code
2. Open `preschool_tracker_activity_diagram.puml`
3. Press `Alt+D` (Windows/Linux) or `Option+D` (Mac) to preview
4. Or right-click and select "Preview Current Diagram"

### Option 3: Command Line (requires PlantUML and Java)
```bash
# Install PlantUML
brew install plantuml  # macOS
# or
sudo apt-get install plantuml  # Ubuntu/Debian

# Generate PNG
plantuml preschool_tracker_activity_diagram.puml

# This will create preschool_tracker_activity_diagram.png
```

### Option 4: Docker
```bash
docker run -v $(pwd):/data plantuml/plantuml preschool_tracker_activity_diagram.puml
```

## Key Features Illustrated

1. **Multi-Role Support**: Clear separation between Parent and Admin workflows
2. **AI Integration**: Shows multiple AI analysis points with caching strategy
3. **Data Flow**: Demonstrates how data flows from parent input → database → AI analysis → insights
4. **Automated Processes**: Illustrates background scheduled tasks running independently
5. **User Lifecycle**: Complete inactive user management workflow with progressive warnings
6. **External Integrations**: Shows integration with Google Gemini AI and Gmail SMTP services

## System Architecture Highlights

- **User Roles**: Parent (30-min session timeout) and Admin (no timeout)
- **AI Model**: Google Gemini 2.5 Flash
- **Database**: MySQL with 13 core tables
- **Email Service**: Gmail SMTP for notifications
- **Scheduled Tasks**: Flask-APScheduler for automated cleanup

## Related Documentation

- See `/home/user/childfyp5/README.txt` for setup instructions
- See `/home/user/childfyp5/child_growth_insights (1).sql` for database schema
- See `/home/user/childfyp5/requirements.txt` for dependencies

## Notes

- The diagram uses standard UML activity diagram notation
- Swimlanes separate different actors (User, Parent, Admin, System, Email Service, Scheduled Tasks)
- Decision points show conditional logic flow
- Fork/join notation shows parallel automated processes
- Notes provide additional context for key features
