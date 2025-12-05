# System Diagrams - Mermaid Format

## 4.1 Use Case Diagrams

### 4.1.1 User Authentication Module
```mermaid
graph TB
    subgraph Actors
        Parent((Parent))
        Admin((Admin))
    end

    subgraph "User Authentication System"
        Login[Login]
        Logout[Logout]
        ResetPassword[Reset Password]
        ValidateCredentials[Validate Credentials]
        SendEmail[Send Reset Email]
        UpdatePassword[Update Password]
        CheckAccountStatus[Check Account Status]
    end

    Parent --> Login
    Parent --> Logout
    Parent --> ResetPassword
    Admin --> Login
    Admin --> Logout
    Admin --> ManageUsers[Manage User Accounts]

    Login -.<<include>>.-> ValidateCredentials
    Login -.<<include>>.-> CheckAccountStatus
    ResetPassword -.<<include>>.-> SendEmail
    ResetPassword -.<<include>>.-> UpdatePassword
```

### 4.1.2 User Account Management Module (includes Inactive Parent Detection)
```mermaid
graph TB
    subgraph Actors
        Parent((Parent))
        Admin((Admin))
    end

    subgraph "User Account Management System"
        ViewProfile[View Profile]
        EditProfile[Edit Profile]
        LinkChild[Link Child Account]
        CreateAccount[Create User Account]
        DeleteAccount[Delete User Account]
        UpdateAccount[Update User Account]
        ViewAllUsers[View All Users]
        UpdateInfo[Update Personal Information]
        ChangePassword[Change Password]
        DetectInactive[Detect Inactive Parents]
        SendReminder[Send Activity Reminder]
        GenerateReport[Generate Inactivity Report]
    end

    Parent --> ViewProfile
    Parent --> EditProfile
    Parent --> LinkChild

    Admin --> CreateAccount
    Admin --> DeleteAccount
    Admin --> UpdateAccount
    Admin --> ViewAllUsers
    Admin --> ViewProfile
    Admin --> EditProfile
    Admin --> DetectInactive

    EditProfile -.<<include>>.-> UpdateInfo
    EditProfile -.<<extend>>.-> ChangePassword
    DetectInactive -.<<include>>.-> GenerateReport
    DetectInactive -.<<extend>>.-> SendReminder
    ViewAllUsers -.<<extend>>.-> DetectInactive
```

### 4.1.3 Academic Progress Tracker Module
```mermaid
graph TB
    subgraph Actors
        Parent((Parent))
        Admin((Admin))
    end

    subgraph "Academic Progress Tracker System"
        ViewProgress[View Child Progress]
        ViewReports[View Progress Reports]
        ExportData[Export Progress Data]
        RecordProgress[Record Student Progress]
        GenerateReports[Generate Progress Reports]
        ViewAnalytics[View Analytics]
        EnterGrades[Enter Grades]
        AddComments[Add Comments]
        TrackMilestones[Track Milestones]
        NotifyParent[Notify Parent]
        CalculateTrends[Calculate Trends]
    end

    Parent --> ViewProgress
    Parent --> ViewReports
    Parent --> ExportData

    Admin --> RecordProgress
    Admin --> ViewProgress
    Admin --> GenerateReports
    Admin --> ViewAnalytics

    RecordProgress -.<<include>>.-> EnterGrades
    RecordProgress -.<<extend>>.-> AddComments
    RecordProgress -.<<extend>>.-> TrackMilestones
    RecordProgress -.<<extend>>.-> NotifyParent
    ViewProgress -.<<include>>.-> CalculateTrends
    GenerateReports -.<<include>>.-> ViewAnalytics
```

### 4.1.4 Preschool Performance Tracker Module
```mermaid
graph TB
    subgraph Actors
        Parent((Parent))
        Admin((Admin))
    end

    subgraph "Preschool Performance Tracker System"
        ViewPerformance[View Performance Metrics]
        ViewBehavior[View Behavior Records]
        ViewAttendance[View Attendance]
        RecordPerformance[Record Performance]
        RecordBehavior[Record Behavior]
        RecordAttendance[Record Attendance]
        GenerateReport[Generate Performance Report]
        AssessSocial[Assess Social Skills]
        AssessMotor[Assess Motor Skills]
        AssessCognitive[Assess Cognitive Skills]
        IdentifyConcerns[Identify Concerns]
        SendAlert[Send Alert to Parent]
    end

    Parent --> ViewPerformance
    Parent --> ViewBehavior
    Parent --> ViewAttendance

    Admin --> RecordPerformance
    Admin --> RecordBehavior
    Admin --> RecordAttendance
    Admin --> ViewPerformance
    Admin --> GenerateReport

    RecordPerformance -.<<include>>.-> AssessSocial
    RecordPerformance -.<<include>>.-> AssessMotor
    RecordPerformance -.<<include>>.-> AssessCognitive
    RecordPerformance -.<<extend>>.-> IdentifyConcerns
    IdentifyConcerns -.<<include>>.-> SendAlert
    GenerateReport -.<<include>>.-> ViewPerformance
```

### 4.1.5 Learning Style Analyzer Module
```mermaid
graph TB
    subgraph Actors
        Parent((Parent))
        System((System/Gemini AI))
    end

    subgraph "Learning Style Analyzer System"
        AddObservation[Add Observation]
        ViewQuestionnaires[View Questionnaires]
        SubmitAnswers[Submit Questionnaire Answers]
        ViewAnalysis[View Learning Style Analysis]
        GenerateAnalysis[Generate/Regenerate Analysis]
        CheckCached[Check Cached Results]
        AnalyzeVARK[Analyze VARK Data]
        GroupByCategory[Group Answers by Category]
        CalculateRatings[Calculate Style Ratings]
        IdentifyMainStyle[Identify Main Learning Style]
        GenerateTips[Generate Parent Tips]
        CacheResults[Cache Analysis Results]
        FormatHTML[Format HTML Output]
    end

    Parent --> AddObservation
    Parent --> ViewQuestionnaires
    Parent --> SubmitAnswers
    Parent --> ViewAnalysis
    Parent --> GenerateAnalysis

    System --> AnalyzeVARK
    System --> CacheResults

    GenerateAnalysis -.<<include>>.-> CheckCached
    GenerateAnalysis -.<<include>>.-> AnalyzeVARK
    AnalyzeVARK -.<<include>>.-> GroupByCategory
    AnalyzeVARK -.<<include>>.-> CalculateRatings
    AnalyzeVARK -.<<include>>.-> IdentifyMainStyle
    AnalyzeVARK -.<<include>>.-> GenerateTips
    AnalyzeVARK -.<<include>>.-> FormatHTML
    AnalyzeVARK -.<<include>>.-> CacheResults
    SubmitAnswers -.<<extend>>.-> GenerateAnalysis
```

### 4.1.6 Tutoring Recommendations Module
```mermaid
graph TB
    subgraph Actors
        Parent((Parent))
        Admin((Admin))
        System((System))
    end

    subgraph "Tutoring Recommendations System"
        ViewRecommendations[View Tutoring Recommendations]
        RequestTutoring[Request Tutoring]
        ProvideFeedback[Provide Feedback]
        ImplementRecommendations[Implement Recommendations]
        UpdateProgress[Update Implementation Progress]
        GenerateRecommendations[Generate Recommendations]
        AnalyzePerformance[Analyze Performance Data]
        MatchLearningStyle[Match Learning Style]
        SuggestActivities[Suggest Activities]
        SuggestResources[Suggest Resources]
        SuggestStrategies[Suggest Strategies]
        CreatePlan[Create Personalized Plan]
        TrackEffectiveness[Track Effectiveness]
    end

    Parent --> ViewRecommendations
    Parent --> RequestTutoring
    Parent --> ProvideFeedback

    Admin --> ViewRecommendations
    Admin --> ImplementRecommendations
    Admin --> UpdateProgress

    System --> GenerateRecommendations
    System --> AnalyzePerformance
    System --> MatchLearningStyle

    GenerateRecommendations -.<<include>>.-> AnalyzePerformance
    GenerateRecommendations -.<<include>>.-> MatchLearningStyle
    GenerateRecommendations -.<<include>>.-> SuggestActivities
    GenerateRecommendations -.<<include>>.-> SuggestResources
    GenerateRecommendations -.<<include>>.-> SuggestStrategies
    GenerateRecommendations -.<<include>>.-> CreatePlan
    ImplementRecommendations -.<<extend>>.-> TrackEffectiveness
    UpdateProgress -.<<extend>>.-> ProvideFeedback
```

---

## 4.2 Activity Diagrams

### 4.2.1 User Authentication Module
```mermaid
flowchart TD
    Start([Start]) --> EnterCredentials[Enter Username and Password]
    EnterCredentials --> ValidateInput{Validate Input Format}
    ValidateInput -->|Invalid| ShowError1[Show Input Error]
    ShowError1 --> EnterCredentials
    ValidateInput -->|Valid| CheckCredentials{Check Credentials in Database}
    CheckCredentials -->|Invalid| IncrementAttempts[Increment Failed Attempts]
    IncrementAttempts --> CheckAttempts{Attempts > 3?}
    CheckAttempts -->|Yes| LockAccount[Lock Account]
    LockAccount --> SendLockNotification[Send Lock Notification Email]
    SendLockNotification --> End1([End])
    CheckAttempts -->|No| ShowError2[Show Invalid Credentials Error]
    ShowError2 --> EnterCredentials
    CheckCredentials -->|Valid| CheckAccountStatus{Account Active?}
    CheckAccountStatus -->|No| ShowInactive[Show Account Inactive Message]
    ShowInactive --> End2([End])
    CheckAccountStatus -->|Yes| GenerateToken[Generate Session Token]
    GenerateToken --> LogActivity[Log Login Activity]
    LogActivity --> RedirectDashboard[Redirect to Dashboard]
    RedirectDashboard --> End3([End])
```

### 4.2.2 User Account Management Module (includes Inactive Parent Detection)
```mermaid
flowchart TD
    Start([Start]) --> SelectAction{Select Action}
    SelectAction -->|Create Account| EnterDetails[Enter User Details]
    SelectAction -->|Edit Profile| LoadProfile[Load User Profile]
    SelectAction -->|Delete Account| ConfirmDelete{Confirm Deletion?}
    SelectAction -->|Check Inactive Parents| StartDetection[Start Inactivity Detection]

    EnterDetails --> ValidateDetails{Validate Details}
    ValidateDetails -->|Invalid| ShowValidationError[Show Validation Error]
    ShowValidationError --> EnterDetails
    ValidateDetails -->|Valid| CheckDuplicate{Check Duplicate Email}
    CheckDuplicate -->|Exists| ShowDuplicateError[Show Duplicate Error]
    ShowDuplicateError --> EnterDetails
    CheckDuplicate -->|Unique| CreateUser[Create User in Database]
    CreateUser --> SendWelcomeEmail[Send Welcome Email]
    SendWelcomeEmail --> Success1[Show Success Message]
    Success1 --> End1([End])

    LoadProfile --> EditFields[Edit Profile Fields]
    EditFields --> ValidateChanges{Validate Changes}
    ValidateChanges -->|Invalid| ShowError2[Show Error]
    ShowError2 --> EditFields
    ValidateChanges -->|Valid| SaveChanges[Save Changes to Database]
    SaveChanges --> UpdateTimestamp[Update Last Activity Timestamp]
    UpdateTimestamp --> Success2[Show Success Message]
    Success2 --> End2([End])

    ConfirmDelete -->|No| End3([End])
    ConfirmDelete -->|Yes| CheckDependencies{Has Dependencies?}
    CheckDependencies -->|Yes| ShowWarning[Show Warning Message]
    ShowWarning --> ForceDelete{Force Delete?}
    ForceDelete -->|No| End4([End])
    ForceDelete -->|Yes| DeleteUser
    CheckDependencies -->|No| DeleteUser[Delete User from Database]
    DeleteUser --> NotifyUser[Send Deletion Notification]
    NotifyUser --> Success3[Show Success Message]
    Success3 --> End5([End])

    StartDetection --> QueryDatabase[Query Parent Login History]
    QueryDatabase --> CheckLastLogin{Last Login > 30 Days?}
    CheckLastLogin -->|No| CheckNext{More Parents?}
    CheckLastLogin -->|Yes| FlagInactive[Flag as Inactive Parent]
    FlagInactive --> SendReminder[Send Activity Reminder Email]
    SendReminder --> LogInactivity[Log Inactivity Record]
    LogInactivity --> CheckNext
    CheckNext -->|Yes| QueryDatabase
    CheckNext -->|No| GenerateReport[Generate Inactivity Report]
    GenerateReport --> DisplayReport[Display Report to Admin]
    DisplayReport --> End6([End])
```

### 4.2.3 Academic Progress Tracker Module
```mermaid
flowchart TD
    Start([Start]) --> SelectStudent[Select Student]
    SelectStudent --> SelectAction{Select Action}

    SelectAction -->|Record Progress| SelectSubject[Select Subject/Skill]
    SelectSubject --> EnterGrade[Enter Grade/Score]
    EnterGrade --> AddComments[Add Comments]
    AddComments --> ValidateData{Validate Data}
    ValidateData -->|Invalid| ShowError1[Show Error]
    ShowError1 --> EnterGrade
    ValidateData -->|Valid| SaveProgress[Save Progress Data]
    SaveProgress --> UpdateAnalytics[Update Analytics]
    UpdateAnalytics --> CalculateTrends[Calculate Performance Trends]
    CalculateTrends --> CheckSignificant{Significant Change?}
    CheckSignificant -->|Yes| NotifyParent1[Notify Parent]
    CheckSignificant -->|No| End1([End])
    NotifyParent1 --> End1

    SelectAction -->|View Progress| LoadProgressData[Load Progress Data]
    LoadProgressData --> GenerateCharts[Generate Progress Charts]
    GenerateCharts --> DisplayProgress[Display Progress Dashboard]
    DisplayProgress --> ExportOption{Export Data?}
    ExportOption -->|Yes| SelectFormat[Select Export Format]
    SelectFormat --> GenerateExport[Generate Export File]
    GenerateExport --> DownloadFile[Download File]
    DownloadFile --> End2([End])
    ExportOption -->|No| End3([End])

    SelectAction -->|Generate Report| SelectPeriod[Select Time Period]
    SelectPeriod --> AnalyzeData[Analyze Progress Data]
    AnalyzeData --> GenerateReport[Generate Detailed Report]
    GenerateReport --> ReviewReport[Review Report]
    ReviewReport --> SendReport{Send to Parent?}
    SendReport -->|Yes| EmailReport[Email Report to Parent]
    EmailReport --> End4([End])
    SendReport -->|No| End5([End])
```

### 4.2.4 Preschool Performance Tracker Module
```mermaid
flowchart TD
    Start([Start]) --> SelectStudent[Select Student]
    SelectStudent --> SelectCategory{Select Performance Category}

    SelectCategory -->|Social Skills| AssessSocial[Assess Social Interaction]
    AssessSocial --> RateSocial[Rate Social Behaviors]
    RateSocial --> AddObservations1[Add Observations]
    AddObservations1 --> SaveSocial

    SelectCategory -->|Motor Skills| AssessMotor[Assess Motor Development]
    AssessMotor --> RateFineMotor[Rate Fine Motor Skills]
    RateFineMotor --> RateGrossMotor[Rate Gross Motor Skills]
    RateGrossMotor --> AddObservations2[Add Observations]
    AddObservations2 --> SaveMotor

    SelectCategory -->|Cognitive Skills| AssessCognitive[Assess Cognitive Development]
    AssessCognitive --> RateProblemSolving[Rate Problem Solving]
    RateProblemSolving --> RateMemory[Rate Memory]
    RateMemory --> RateAttention[Rate Attention Span]
    RateAttention --> AddObservations3[Add Observations]
    AddObservations3 --> SaveCognitive

    SelectCategory -->|Behavior| RecordBehavior[Record Behavior Incident]
    RecordBehavior --> SelectBehaviorType[Select Behavior Type]
    SelectBehaviorType --> DescribeIncident[Describe Incident]
    DescribeIncident --> AddAction[Add Action Taken]
    AddAction --> SaveBehavior

    SaveSocial[Save Social Assessment] --> UpdateProfile
    SaveMotor[Save Motor Assessment] --> UpdateProfile
    SaveCognitive[Save Cognitive Assessment] --> UpdateProfile
    SaveBehavior[Save Behavior Record] --> UpdateProfile

    UpdateProfile[Update Performance Profile] --> GenerateInsights[Generate Insights]
    GenerateInsights --> CompareMilestones[Compare to Developmental Milestones]
    CompareMilestones --> CheckConcerns{Identify Concerns?}
    CheckConcerns -->|Yes| FlagConcerns[Flag for Review]
    FlagConcerns --> NotifyParent[Notify Parent and Admin]
    NotifyParent --> CreateActionPlan[Create Action Plan]
    CreateActionPlan --> End1([End])
    CheckConcerns -->|No| NotifyParentUpdate[Send Update to Parent]
    NotifyParentUpdate --> End2([End])
```

### 4.2.5 Learning Style Analyzer Module
```mermaid
flowchart TD
    Start([Start]) --> LoadPage[Parent Navigates to Learning Style Page]
    LoadPage --> LoadData[Load Observations, Questionnaires, and Cached Analysis]
    LoadData --> SelectAction{Parent Selects Action}

    SelectAction -->|Add Observation| EnterObservation[Enter Observation Text]
    EnterObservation --> SaveObservation[Save to learning_observations Table]
    SaveObservation --> RedirectPage[Redirect to Learning Style Page]
    RedirectPage --> LoadPage

    SelectAction -->|Take Questionnaire| ViewQuestions[View VARK Questionnaire Questions]
    ViewQuestions --> AnswerQuestions[Parent Answers Questions Scale 1-5]
    AnswerQuestions --> SubmitAnswers[Submit Questionnaire Answers]
    SubmitAnswers --> SaveAnswers[Save to test_answers Table]
    SaveAnswers --> RedirectPage

    SelectAction -->|Generate Analysis| CheckDataExists{Has Observations or Answers?}
    CheckDataExists -->|No| ShowNoData[Show 'No Data Available' Message]
    ShowNoData --> End1([End])

    CheckDataExists -->|Yes| CreateDataPayload[Create JSON Data Payload]
    CreateDataPayload --> CheckCached{Compare with Cached Data}
    CheckCached -->|Cached & No Regen| DisplayCached[Display Cached Analysis]
    DisplayCached --> End2([End])

    CheckCached -->|Not Cached or Regen| PrepareObservations[Format Observations with Dates]
    PrepareObservations --> GroupAnswers[Group Answers by VARK Category]
    GroupAnswers --> BuildPrompt[Build AI Prompt]
    BuildPrompt --> SendToGemini[Send to Gemini AI]

    SendToGemini --> GeminiAnalyze[AI Analyzes VARK Data]
    GeminiAnalyze --> GenerateRatings[Generate Visual/Auditory/Reading/Kinesthetic Ratings]
    GenerateRatings --> IdentifyMainStyle[Identify Main Learning Style]
    IdentifyMainStyle --> GenerateTips[Generate 3 Tips for Parents]
    GenerateTips --> FormatHTML[Format as HTML]

    FormatHTML --> DeleteOldResult[Delete Old ai_results Entry]
    DeleteOldResult --> InsertNewResult[Insert New ai_results Entry]
    InsertNewResult --> CommitDB[Commit to Database]
    CommitDB --> DisplayAnalysis[Display Learning Style Analysis]
    DisplayAnalysis --> End3([End])

    SendToGemini -->|Error| HandleError{Check Error Type}
    HandleError -->|Token Limit| ReturnTokenError[Return Token Limit Error]
    ReturnTokenError --> End4([End])
    HandleError -->|Other Error| ShowError[Show Error Message]
    ShowError --> End5([End])
```

### 4.2.6 Tutoring Recommendations Module
```mermaid
flowchart TD
    Start([Start]) --> TriggerEvent{Trigger Event}

    TriggerEvent -->|New Assessment| LoadLearningStyle
    TriggerEvent -->|Poor Performance| LoadPerformanceData
    TriggerEvent -->|Manual Request| LoadAllData

    LoadLearningStyle[Load Learning Style Profile] --> CollectData
    LoadPerformanceData[Load Performance Data] --> CollectData
    LoadAllData[Load All Student Data] --> CollectData

    CollectData[Collect All Relevant Data] --> AnalyzeProgress[Analyze Academic Progress]
    AnalyzeProgress --> AnalyzePerformance[Analyze Performance Metrics]
    AnalyzePerformance --> IdentifyWeaknesses[Identify Weak Areas]
    IdentifyWeaknesses --> IdentifyStrengths[Identify Strengths]
    IdentifyStrengths --> MatchLearningStyle[Match to Learning Style]

    MatchLearningStyle --> GenerateActivities[Generate Activity Recommendations]
    GenerateActivities --> GenerateResources[Generate Resource Recommendations]
    GenerateResources --> GenerateStrategies[Generate Teaching Strategies]

    GenerateStrategies --> PrioritizeRecommendations[Prioritize by Impact]
    PrioritizeRecommendations --> CreatePlan[Create Personalized Tutoring Plan]
    CreatePlan --> ReviewPlan{Admin Review Required?}

    ReviewPlan -->|Yes| SendToAdmin[Send to Admin for Review]
    SendToAdmin --> AdminApproval{Admin Approves?}
    AdminApproval -->|No| AdjustRecommendations[Admin Adjusts Recommendations]
    AdjustRecommendations --> CreatePlan
    AdminApproval -->|Yes| PublishPlan

    ReviewPlan -->|No| PublishPlan[Publish Recommendations]
    PublishPlan --> NotifyParent[Notify Parent]
    NotifyParent --> NotifyAdmin[Notify Admin]
    NotifyAdmin --> DisplayRecommendations[Display in Dashboard]
    DisplayRecommendations --> TrackImplementation[Track Implementation]
    TrackImplementation --> ScheduleFollowUp[Schedule Follow-up Review]
    ScheduleFollowUp --> End([End])
```

---

## 4.3 Sequence Diagrams

### 4.3.1 User Authentication Module
```mermaid
sequenceDiagram
    actor User
    participant UI as Login UI
    participant Controller as Auth Controller
    participant Service as Auth Service
    participant DB as Database
    participant Email as Email Service

    User->>UI: Enter credentials
    UI->>Controller: POST /login {username, password}
    Controller->>Service: authenticate(username, password)
    Service->>DB: findUser(username)
    DB-->>Service: user data

    alt User not found
        Service-->>Controller: AuthError: User not found
        Controller-->>UI: 401 Unauthorized
        UI-->>User: Show error message
    else User found
        Service->>Service: comparePassword(password, hashedPassword)

        alt Password incorrect
            Service->>DB: incrementFailedAttempts(userId)
            DB-->>Service: updated attempts count

            alt Attempts > 3
                Service->>DB: lockAccount(userId)
                Service->>Email: sendAccountLockedEmail(user)
                Email-->>Service: email sent
                Service-->>Controller: AuthError: Account locked
                Controller-->>UI: 403 Forbidden
                UI-->>User: Account locked message
            else Attempts <= 3
                Service-->>Controller: AuthError: Invalid password
                Controller-->>UI: 401 Unauthorized
                UI-->>User: Show error with remaining attempts
            end

        else Password correct
            Service->>Service: generateSessionToken()
            Service->>DB: createSession(userId, token)
            Service->>DB: resetFailedAttempts(userId)
            Service->>DB: updateLastLogin(userId)
            DB-->>Service: session created
            Service-->>Controller: {token, user, role}
            Controller-->>UI: 200 OK {token, userData}
            UI->>UI: Store token in localStorage
            UI->>UI: Redirect to dashboard
            UI-->>User: Dashboard page
        end
    end
```

### 4.3.2 User Account Management Module (includes Inactive Parent Detection)
```mermaid
sequenceDiagram
    actor Admin
    participant UI as Admin UI
    participant Controller as User Controller
    participant Service as User Service
    participant Validator as Data Validator
    participant DB as Database
    participant Email as Email Service
    participant Scheduler as Task Scheduler

    Note over Admin,Scheduler: Create User Account Flow

    Admin->>UI: Click "Create New User"
    UI->>Admin: Display user form
    Admin->>UI: Fill user details and submit
    UI->>Controller: POST /users {userData}
    Controller->>Validator: validate(userData)

    alt Validation fails
        Validator-->>Controller: ValidationError
        Controller-->>UI: 400 Bad Request {errors}
        UI-->>Admin: Show validation errors
    else Validation passes
        Validator-->>Controller: valid
        Controller->>Service: createUser(userData)
        Service->>DB: checkEmailExists(email)
        DB-->>Service: exists: true/false

        alt Email exists
            Service-->>Controller: ConflictError: Email exists
            Controller-->>UI: 409 Conflict
            UI-->>Admin: Email already registered
        else Email unique
            Service->>Service: hashPassword(password)
            Service->>DB: insertUser(userData)
            DB-->>Service: userId
            Service->>DB: assignRole(userId, role)
            Service->>DB: setLastActivityTimestamp(userId, now)
            Service->>Email: sendWelcomeEmail(user)
            Email-->>Service: email sent
            Service-->>Controller: {userId, userData}
            Controller-->>UI: 201 Created {user}
            UI-->>Admin: Success message with user details
        end
    end

    Note over Admin,Scheduler: Edit Profile Flow

    Admin->>UI: Edit user profile
    UI->>Controller: GET /users/{userId}
    Controller->>Service: getUserById(userId)
    Service->>DB: findUserById(userId)
    DB-->>Service: userData
    Service-->>Controller: userData
    Controller-->>UI: 200 OK {user}
    UI-->>Admin: Display editable form

    Admin->>UI: Update and submit
    UI->>Controller: PUT /users/{userId} {updates}
    Controller->>Service: updateUser(userId, updates)
    Service->>DB: updateUserData(userId, updates)
    Service->>DB: updateLastActivityTimestamp(userId, now)
    DB-->>Service: updated user
    Service-->>Controller: updated user
    Controller-->>UI: 200 OK {user}
    UI-->>Admin: Success message

    Note over Admin,Scheduler: Inactive Parent Detection Flow

    Scheduler->>Service: scheduledInactivityCheck()
    Service->>DB: getParentsWithLastActivity()
    DB-->>Service: parent activity records

    loop For each parent
        Service->>Service: calculateInactiveDays(lastActivity)

        alt Inactive > 30 days
            Service->>DB: flagAsInactive(parentId)
            Service->>DB: createInactivityRecord(parentId, days)
            Service->>Email: sendActivityReminderEmail(parent)
            Email-->>Service: email sent
            Service->>DB: logReminderSent(parentId, timestamp)
        end
    end

    Service->>DB: generateInactivityReport()
    DB-->>Service: report data
    Service->>Email: sendReportToAdmin(admin, report)
    Email-->>Admin: Inactivity report email
```

### 4.3.3 Academic Progress Tracker Module
```mermaid
sequenceDiagram
    actor Admin
    participant UI as Admin UI
    participant Controller as Progress Controller
    participant Service as Progress Service
    participant Analytics as Analytics Engine
    participant DB as Database
    participant Notification as Notification Service
    actor Parent

    Admin->>UI: Select student and subject
    UI->>Controller: GET /students/{studentId}/progress
    Controller->>Service: getStudentProgress(studentId)
    Service->>DB: fetchProgressRecords(studentId)
    DB-->>Service: progress records
    Service-->>Controller: progress data
    Controller-->>UI: 200 OK {progressData}
    UI-->>Admin: Display current progress

    Admin->>UI: Enter new grade and comments
    UI->>Controller: POST /progress {studentId, subjectId, grade, comments}
    Controller->>Service: recordProgress(progressData)
    Service->>Service: validateGrade(grade)

    alt Invalid grade
        Service-->>Controller: ValidationError
        Controller-->>UI: 400 Bad Request
        UI-->>Admin: Show error
    else Valid grade
        Service->>DB: insertProgressRecord(progressData)
        DB-->>Service: recordId

        Service->>Analytics: analyzeProgress(studentId, subjectId)
        Analytics->>DB: fetchHistoricalData(studentId, subjectId)
        DB-->>Analytics: historical records
        Analytics->>Analytics: calculateTrends()
        Analytics->>Analytics: identifyStrengths()
        Analytics->>Analytics: identifyWeaknesses()
        Analytics-->>Service: {trends, insights, alerts}

        Service->>DB: updateAnalytics(studentId, insights)

        alt Significant change detected
            Service->>Notification: notifyParent(parentId, progressUpdate)
            Notification->>DB: getParentContact(parentId)
            DB-->>Notification: parent email
            Notification->>Email: sendProgressAlert(parent, details)
            Email-->>Parent: Email notification
        end

        Service-->>Controller: {recordId, analytics}
        Controller-->>UI: 201 Created {progressRecord}
        UI-->>Admin: Success with insights
    end

    Note over Admin,Parent: Generate Report Flow

    Admin->>UI: Request progress report
    UI->>Controller: POST /progress/reports {studentId, period}
    Controller->>Service: generateProgressReport(studentId, period)
    Service->>DB: fetchProgressData(studentId, period)
    DB-->>Service: progress records
    Service->>Analytics: generateReport(records)
    Analytics->>Analytics: aggregateData()
    Analytics->>Analytics: generateCharts()
    Analytics->>Analytics: calculateStatistics()
    Analytics-->>Service: report PDF
    Service->>DB: saveReport(reportId, reportData)
    Service-->>Controller: {reportId, reportURL}
    Controller-->>UI: 200 OK {report}
    UI-->>Admin: Display/Download report

    Admin->>UI: Send report to parent
    UI->>Controller: POST /reports/{reportId}/send
    Controller->>Notification: sendReport(parentId, reportId)
    Notification->>Email: emailReport(parent, reportURL)
    Email-->>Parent: Report email
    Notification-->>Controller: sent
    Controller-->>UI: 200 OK
    UI-->>Admin: Confirmation
```

### 4.3.4 Preschool Performance Tracker Module
```mermaid
sequenceDiagram
    actor Admin
    participant UI as Admin UI
    participant Controller as Performance Controller
    participant Service as Performance Service
    participant Assessment as Assessment Engine
    participant DB as Database
    participant Alert as Alert Service
    participant Notification as Notification Service
    actor Parent

    Admin->>UI: Select student for assessment
    UI->>Controller: GET /students/{studentId}/performance
    Controller->>Service: getPerformanceProfile(studentId)
    Service->>DB: fetchPerformanceData(studentId)
    DB-->>Service: performance history
    Service-->>Controller: performanceData
    Controller-->>UI: 200 OK {performanceData}
    UI-->>Admin: Display performance dashboard

    Admin->>UI: Record new assessment
    UI->>Admin: Show assessment form
    Admin->>UI: Select category (Social/Motor/Cognitive)

    Note over Admin,Parent: Social Skills Assessment

    Admin->>UI: Rate social behaviors
    Admin->>UI: Add observations
    UI->>Controller: POST /performance/social {studentId, ratings, observations}
    Controller->>Service: recordSocialAssessment(data)
    Service->>Assessment: evaluateSocialSkills(ratings)
    Assessment->>Assessment: calculateSocialScore()
    Assessment->>Assessment: compareToMilestones()
    Assessment-->>Service: {score, insights, concerns}

    alt Below expected level
        Assessment->>Alert: createConcernAlert(studentId, category, details)
        Alert->>DB: saveAlert(alertData)
        Alert->>Notification: notifyStakeholders(studentId, alert)
        Notification->>Email: emailParent(parent, concern)
        Email-->>Parent: Concern notification
        Notification->>Email: emailAdmin(admin, concern)
        Email-->>Admin: Review required notification
    end

    Service->>DB: insertSocialAssessment(studentId, score, observations)
    DB-->>Service: assessmentId

    Note over Admin,Parent: Motor Skills Assessment

    Service->>DB: updatePerformanceProfile(studentId)

    Admin->>UI: Rate fine motor skills
    Admin->>UI: Rate gross motor skills
    UI->>Controller: POST /performance/motor {studentId, fineMotor, grossMotor, observations}
    Controller->>Service: recordMotorAssessment(data)
    Service->>Assessment: evaluateMotorSkills(data)
    Assessment->>Assessment: assessFineMotor()
    Assessment->>Assessment: assessGrossMotor()
    Assessment->>Assessment: identifyDelays()
    Assessment-->>Service: {scores, insights, recommendations}
    Service->>DB: insertMotorAssessment(data)

    Note over Admin,Parent: Cognitive Skills Assessment

    Admin->>UI: Complete cognitive assessment
    UI->>Controller: POST /performance/cognitive {studentId, assessmentData}
    Controller->>Service: recordCognitiveAssessment(data)
    Service->>Assessment: evaluateCognitive(data)
    Assessment->>Assessment: assessProblemSolving()
    Assessment->>Assessment: assessMemory()
    Assessment->>Assessment: assessAttentionSpan()
    Assessment-->>Service: {scores, developmentalStage}
    Service->>DB: insertCognitiveAssessment(data)

    Service->>DB: aggregateAllAssessments(studentId)
    DB-->>Service: comprehensive profile
    Service->>Assessment: generateOverallProfile(allAssessments)
    Assessment-->>Service: holistic performance profile
    Service->>DB: updatePerformanceProfile(studentId, profile)
    Service-->>Controller: {profileId, summary}
    Controller-->>UI: 201 Created {assessment}
    UI-->>Admin: Success with summary

    Service->>Notification: sendPerformanceUpdate(parentId, summary)
    Notification->>Email: emailPerformanceUpdate(parent)
    Email-->>Parent: Performance update
```

### 4.3.5 Learning Style Analyzer Module
```mermaid
sequenceDiagram
    actor Parent
    participant UI as Parent UI
    participant Flask as Flask App /dashboard/learning
    participant DB as MySQL Database
    participant Gemini as Gemini AI API

    Note over Parent,Gemini: Flow 1: Add Observation

    Parent->>UI: Navigate to Learning Style page
    UI->>Flask: GET /dashboard/learning
    Flask->>DB: SELECT * FROM children WHERE id={child_id}
    DB-->>Flask: child data
    Flask->>DB: SELECT * FROM tests
    DB-->>Flask: questionnaires list
    Flask->>DB: SELECT * FROM learning_observations WHERE child_id={child_id}
    DB-->>Flask: observations
    Flask->>DB: SELECT * FROM test_answers WHERE child_id={child_id}
    DB-->>Flask: test answers
    Flask->>DB: SELECT * FROM ai_results WHERE child_id={child_id} AND module='learning'
    DB-->>Flask: cached analysis
    Flask-->>UI: Render page with data
    UI-->>Parent: Display learning style page

    Parent->>UI: Enter observation text
    Parent->>UI: Submit observation
    UI->>Flask: POST /dashboard/learning {observation}
    Flask->>DB: INSERT INTO learning_observations (child_id, observation, created_at)
    DB-->>Flask: Success
    Flask-->>UI: Redirect to learning page
    UI-->>Parent: Show updated observations

    Note over Parent,Gemini: Flow 2: Take Questionnaire

    Parent->>UI: Select VARK questionnaire
    UI->>Flask: GET questionnaire questions
    Flask->>DB: SELECT * FROM test_questions WHERE test_id={test_id}
    DB-->>Flask: questions list
    Flask-->>UI: Display questionnaire
    UI-->>Parent: Show questions

    Parent->>UI: Answer questions (scale 1-5)
    Parent->>UI: Submit questionnaire
    UI->>Flask: POST questionnaire answers
    Flask->>DB: INSERT INTO test_answers (child_id, test_id, question_id, answer)
    DB-->>Flask: Success
    Flask-->>UI: Redirect to learning page
    UI-->>Parent: Show updated answers

    Note over Parent,Gemini: Flow 3: Generate/Regenerate Analysis

    Parent->>UI: Click "Generate/Regenerate Analysis"
    UI->>Flask: GET /dashboard/learning?regen=1
    Flask->>DB: SELECT * FROM learning_observations WHERE child_id={child_id}
    DB-->>Flask: observations
    Flask->>DB: SELECT * FROM test_answers WHERE child_id={child_id}
    DB-->>Flask: test answers with questions
    Flask->>Flask: Create JSON data_payload
    Flask->>DB: SELECT * FROM ai_results WHERE child_id={child_id} AND module='learning'
    DB-->>Flask: cached result

    alt Data not changed and no regen
        Flask-->>UI: Return cached analysis
        UI-->>Parent: Display cached result
    else Data changed or regen=1
        Flask->>Flask: Format observations with dates
        Flask->>Flask: Group answers by VARK category (visual, auditory, reading, kinesthetic)
        Flask->>Flask: Build AI prompt with observations and grouped answers

        Flask->>Gemini: generate_content(prompt)
        Gemini->>Gemini: Analyze VARK questionnaire responses
        Gemini->>Gemini: Analyze parent observations
        Gemini->>Gemini: Calculate Visual rating
        Gemini->>Gemini: Calculate Auditory rating
        Gemini->>Gemini: Calculate Reading/Writing rating
        Gemini->>Gemini: Calculate Kinesthetic rating
        Gemini->>Gemini: Identify main learning style
        Gemini->>Gemini: Generate 3 practical tips for parents
        Gemini->>Gemini: Format as HTML
        Gemini-->>Flask: Return HTML analysis

        Flask->>DB: DELETE FROM ai_results WHERE child_id={child_id} AND module='learning'
        DB-->>Flask: Deleted
        Flask->>DB: INSERT INTO ai_results (child_id, module, data, result, created_at, updated_at)
        DB-->>Flask: Success
        Flask-->>UI: Return JSON {benchmark_summary, last_generated}
        UI->>UI: Update page with new analysis
        UI-->>Parent: Display VARK analysis with tips
    end

    alt Error - Token limit
        Gemini-->>Flask: Token limit error
        Flask-->>UI: Return {error: "token_limit"}
        UI-->>Parent: Show token limit message
    else Error - Other
        Gemini-->>Flask: Other error
        Flask-->>UI: Return error message
        UI-->>Parent: Show error
    end
```

### 4.3.6 Tutoring Recommendations Module
```mermaid
sequenceDiagram
    actor System
    participant Service as Recommendation Service
    participant Aggregator as Data Aggregator
    participant AI as Recommendation AI
    participant DB as Database
    participant Notification as Notification Service
    participant UI as Admin UI
    participant Controller as Tutoring Controller
    actor Admin
    actor Parent

    Note over System,Parent: Triggered by learning style update or poor performance

    System->>Service: triggerRecommendations(studentId, trigger)
    Service->>Aggregator: collectStudentData(studentId)
    Aggregator->>DB: fetchLearningStyle(studentId)
    DB-->>Aggregator: learning style profile
    Aggregator->>DB: fetchAcademicProgress(studentId)
    DB-->>Aggregator: progress records
    Aggregator->>DB: fetchPerformanceData(studentId)
    DB-->>Aggregator: performance assessments
    Aggregator->>DB: fetchBehaviorData(studentId)
    DB-->>Aggregator: behavior records
    Aggregator-->>Service: {learningStyle, progress, performance, behavior}

    Service->>AI: analyzeStudentNeeds(allData)
    AI->>AI: identifyWeakAreas()
    AI->>AI: identifyStrengths()
    AI->>AI: assessLearningGaps()
    AI->>AI: considerLearningStyle()
    AI-->>Service: {weakAreas, strengths, gaps, priorities}

    Service->>AI: generateRecommendations(needs, learningStyle)

    par Activity Recommendations
        AI->>AI: matchActivitiesToStyle()
        AI->>AI: alignWithWeakAreas()
        AI->>AI: ensureEngagement()
        AI->>DB: fetchActivityLibrary(filters)
        DB-->>AI: matching activities
        AI->>AI: rankActivities()
    and Resource Recommendations
        AI->>AI: matchResourcesToStyle()
        AI->>AI: selectAppropriateLevel()
        AI->>DB: fetchResourceLibrary(filters)
        DB-->>AI: matching resources
        AI->>AI: rankResources()
    and Strategy Recommendations
        AI->>AI: matchStrategiesToStyle()
        AI->>AI: considerHomeContext()
        AI->>AI: ensurePracticality()
        AI->>AI: rankStrategies()
    end

    AI-->>Service: {activities, resources, strategies, reasoning}

    Service->>AI: createTutoringPlan(recommendations, studentProfile)
    AI->>AI: organizePriorities()
    AI->>AI: sequenceActivities()
    AI->>AI: defineGoals()
    AI->>AI: estimateDuration()
    AI->>AI: createMilestones()
    AI-->>Service: personalizedTutoringPlan

    Service->>DB: saveTutoringPlan(studentId, plan)
    DB-->>Service: planId

    Service->>Notification: notifyAdmin(adminId, plan)
    Notification->>Email: sendAdminNotification(admin, planSummary)
    Email-->>Admin: New tutoring plan notification

    Service->>Notification: notifyParent(parentId, plan)
    Notification->>Email: sendParentNotification(parent, planSummary)
    Email-->>Parent: New tutoring recommendations

    Service-->>System: recommendations generated

    Note over Admin,Parent: Admin Reviews and Implements

    Admin->>UI: View recommendations
    UI->>Controller: GET /tutoring/{planId}
    Controller->>Service: getTutoringPlan(planId)
    Service->>DB: fetchPlan(planId)
    DB-->>Service: plan details
    Service-->>Controller: plan
    Controller-->>UI: 200 OK {plan}
    UI-->>Admin: Display detailed plan

    Admin->>UI: Mark activity as implemented
    UI->>Controller: POST /tutoring/{planId}/implement {activityId, status}
    Controller->>Service: updateImplementation(planId, activityId, status)
    Service->>DB: updateActivityStatus(planId, activityId, status)
    DB-->>Service: updated
    Service->>DB: trackProgress(planId)
    Service-->>Controller: updated plan
    Controller-->>UI: 200 OK
    UI-->>Admin: Status updated

    Admin->>UI: Add implementation feedback
    UI->>Controller: POST /tutoring/{planId}/feedback {activityId, feedback}
    Controller->>Service: recordFeedback(planId, activityId, feedback)
    Service->>DB: insertFeedback(feedback)
    Service->>AI: analyzeFeedback(feedback)
    AI->>AI: assessEffectiveness()
    AI-->>Service: adjustedRecommendations
    Service->>DB: updatePlan(planId, adjustments)
    Service-->>Controller: updated
    Controller-->>UI: 200 OK
    UI-->>Admin: Feedback recorded

    Note over System,Parent: Periodic Review

    System->>Service: scheduledReview(planId)
    Service->>DB: fetchPlanProgress(planId)
    DB-->>Service: implementation data
    Service->>AI: evaluatePlanEffectiveness(progress, studentData)
    AI->>AI: measureImprovement()
    AI->>AI: assessEngagement()
    AI-->>Service: {effectiveness, recommendations}

    alt Plan effective
        Service->>Notification: sendSuccessReport(parent, admin)
        Notification-->>Parent: Progress update
        Notification-->>Admin: Effectiveness report
    else Plan needs adjustment
        Service->>AI: adjustPlan(currentPlan, effectiveness)
        AI-->>Service: revisedPlan
        Service->>DB: updatePlan(planId, revisedPlan)
        Service->>Notification: sendPlanUpdate(parent, admin)
        Notification-->>Parent: Updated recommendations
        Notification-->>Admin: Plan revision notice
    end
```

---

## Notes

These diagrams represent:

1. **Use Case Diagrams**: Show the interactions between different actors (Parent, Admin, System) and the system functionalities with proper <<include>> and <<extend>> relationships
   - **<<include>>**: Mandatory relationships that must execute (e.g., Login includes Validate Credentials)
   - **<<extend>>**: Optional relationships that may execute under certain conditions (e.g., Edit Profile extends to Change Password)

2. **Activity Diagrams**: Detail the workflow and decision points for each module's processes

3. **Sequence Diagrams**: Illustrate the interaction between different components (UI, Controllers, Services, Database) over time

### System Roles
- **Parent**: Can view their child's progress, performance, learning styles, and recommendations
- **Admin**: Manages all system operations including recording progress, conducting assessments, and managing user accounts (including inactive parent detection)
- **System**: Automated processes for analyzing data and generating recommendations

### Key Features
- No Teacher actors in any diagram
- User Account Management module includes Inactive Parent Detection functionality
- All use case diagrams use <<include>> for mandatory and <<extend>> for optional relationships
- Activity and Sequence diagrams remain detailed and comprehensive

You can render these Mermaid diagrams using:
- GitHub Markdown (supports Mermaid natively)
- Mermaid Live Editor (https://mermaid.live)
- VS Code with Mermaid extensions
- Documentation platforms like GitBook, Docusaurus, etc.
