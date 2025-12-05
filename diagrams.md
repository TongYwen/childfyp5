# System Diagrams - Mermaid Format

## 4.1 Use Case Diagrams

### 4.1.1 User Authentication Module
```mermaid
graph TD
    Parent((Parent))
    Admin((Admin))

    Parent --> Login[Login]
    Parent --> Logout[Logout]
    Parent --> ResetPassword[Reset Password]

    Admin --> Login
    Admin --> Logout
    Admin --> ManageUsers[Manage User Accounts]

    Login -->|<<include>>| ValidateCredentials[Validate Credentials]
    Login -->|<<extend>>| TwoFactorAuth[Two-Factor Authentication]

    ResetPassword -->|<<include>>| SendEmail[Send Reset Email]
    ResetPassword -->|<<include>>| UpdatePassword[Update Password]

    Logout -->|<<include>>| InvalidateSession[Invalidate Session]
```

### 4.1.2 User Account Management Module
```mermaid
graph TD
    Parent((Parent))
    Admin((Admin))

    Parent --> ViewProfile[View Profile]
    Parent --> EditProfile[Edit Profile]
    Parent --> LinkChild[Link Child Account]

    Admin --> CreateAccount[Create User Account]
    Admin --> DeleteAccount[Delete User Account]
    Admin --> UpdateAccount[Update User Account]
    Admin --> ViewAllUsers[View All Users]
    Admin --> ViewProfile
    Admin --> EditProfile

    EditProfile -->|<<include>>| ValidateInput[Validate Input]
    EditProfile -->|<<include>>| SaveChanges[Save Changes]
    EditProfile -->|<<extend>>| UpdateInfo[Update Personal Information]
    EditProfile -->|<<extend>>| ChangePassword[Change Password]

    CreateAccount -->|<<include>>| ValidateInput
    CreateAccount -->|<<include>>| AssignRole[Assign Role]
    CreateAccount -->|<<extend>>| SendWelcomeEmail[Send Welcome Email]

    DeleteAccount -->|<<include>>| ConfirmDeletion[Confirm Deletion]
    DeleteAccount -->|<<extend>>| ArchiveData[Archive User Data]

    LinkChild -->|<<include>>| VerifyRelationship[Verify Relationship]
```

### 4.1.3 Academic Progress Tracker Module
```mermaid
graph TD
    Parent((Parent))
    Admin((Admin))

    Parent --> ViewProgress[View Child Progress]
    Parent --> ViewReports[View Progress Reports]
    Parent --> ExportData[Export Progress Data]

    Admin --> RecordProgress[Record Student Progress]
    Admin --> ViewProgress
    Admin --> GenerateReports[Generate Progress Reports]
    Admin --> ViewAnalytics[View Analytics]

    RecordProgress -->|<<include>>| ValidateData[Validate Data]
    RecordProgress -->|<<include>>| SaveToDatabase[Save to Database]
    RecordProgress -->|<<extend>>| EnterGrades[Enter Grades]
    RecordProgress -->|<<extend>>| AddComments[Add Comments]
    RecordProgress -->|<<extend>>| TrackMilestones[Track Milestones]
    RecordProgress -->|<<extend>>| NotifyParent[Notify Parent]

    ViewProgress -->|<<include>>| FetchData[Fetch Progress Data]
    ViewProgress -->|<<extend>>| FilterBySubject[Filter by Subject]
    ViewProgress -->|<<extend>>| CompareWithPeers[Compare with Peers]

    GenerateReports -->|<<include>>| AnalyzeData[Analyze Data]
    GenerateReports -->|<<include>>| CreateDocument[Create Document]
    GenerateReports -->|<<extend>>| SendEmail[Send via Email]

    ExportData -->|<<include>>| SelectFormat[Select Export Format]
```

### 4.1.4 Preschool Performance Tracker Module
```mermaid
graph TD
    Parent((Parent))
    Admin((Admin))

    Parent --> ViewPerformance[View Performance Metrics]
    Parent --> ViewBehavior[View Behavior Records]
    Parent --> ViewAttendance[View Attendance]

    Admin --> RecordPerformance[Record Performance]
    Admin --> RecordBehavior[Record Behavior]
    Admin --> RecordAttendance[Record Attendance]
    Admin --> ViewPerformance
    Admin --> GenerateReport[Generate Performance Report]

    RecordPerformance -->|<<include>>| SaveAssessment[Save Assessment]
    RecordPerformance -->|<<extend>>| AssessSocial[Assess Social Skills]
    RecordPerformance -->|<<extend>>| AssessMotor[Assess Motor Skills]
    RecordPerformance -->|<<extend>>| AssessCognitive[Assess Cognitive Skills]
    RecordPerformance -->|<<extend>>| FlagConcerns[Flag Concerns]

    AssessSocial -->|<<include>>| CompareMilestones[Compare to Milestones]
    AssessMotor -->|<<include>>| CompareMilestones
    AssessCognitive -->|<<include>>| CompareMilestones

    RecordBehavior -->|<<include>>| TimestampEvent[Timestamp Event]
    RecordBehavior -->|<<extend>>| NotifyParent[Notify Parent]
    RecordBehavior -->|<<extend>>| NotifyAdmin[Notify Admin]

    RecordAttendance -->|<<include>>| UpdateRecord[Update Attendance Record]

    GenerateReport -->|<<include>>| AggregateData[Aggregate Performance Data]
    GenerateReport -->|<<extend>>| IncludeRecommendations[Include Recommendations]

    ViewPerformance -->|<<include>>| LoadData[Load Performance Data]
```

### 4.1.5 Learning Style Analyzer Module
```mermaid
graph TD
    Parent((Parent))
    Admin((Admin))
    System((System))

    Parent --> ViewLearningStyle[View Learning Style]
    Parent --> RequestAssessment[Request Assessment]

    Admin --> ConductAssessment[Conduct Learning Assessment]
    Admin --> ViewLearningStyle
    Admin --> UpdateAssessment[Update Assessment]

    ConductAssessment -->|<<include>>| ValidateCompleteness[Validate Completeness]
    ConductAssessment -->|<<include>>| SubmitToSystem[Submit to System]
    ConductAssessment -->|<<extend>>| InputObservations[Input Observations]
    ConductAssessment -->|<<extend>>| CompleteQuestionnaire[Complete Questionnaire]
    ConductAssessment -->|<<extend>>| RecordActivities[Record Preferred Activities]

    System --> AnalyzeData[Analyze Learning Data]
    System --> GenerateProfile[Generate Learning Profile]

    AnalyzeData -->|<<include>>| CalculateScores[Calculate Style Scores]
    AnalyzeData -->|<<extend>>| IdentifyVisual[Identify Visual Learner]
    AnalyzeData -->|<<extend>>| IdentifyAuditory[Identify Auditory Learner]
    AnalyzeData -->|<<extend>>| IdentifyKinesthetic[Identify Kinesthetic Learner]
    AnalyzeData -->|<<extend>>| IdentifyMultimodal[Identify Multimodal Learner]

    GenerateProfile -->|<<include>>| CreateRecommendations[Create Teaching Recommendations]
    GenerateProfile -->|<<extend>>| ShareWithParent[Share with Parent]
    GenerateProfile -->|<<extend>>| TriggerTutoring[Trigger Tutoring Recommendations]

    ViewLearningStyle -->|<<include>>| LoadProfile[Load Learning Profile]
```

### 4.1.6 Tutoring Recommendations Module
```mermaid
graph TD
    Parent((Parent))
    Admin((Admin))
    System((System))

    Parent --> ViewRecommendations[View Tutoring Recommendations]
    Parent --> RequestTutoring[Request Tutoring]
    Parent --> ProvideFeedback[Provide Feedback]

    Admin --> ViewRecommendations
    Admin --> ImplementRecommendations[Implement Recommendations]
    Admin --> UpdateProgress[Update Implementation Progress]

    System --> GenerateRecommendations[Generate Recommendations]
    System --> AnalyzePerformance[Analyze Performance Data]
    System --> MatchLearningStyle[Match Learning Style]

    GenerateRecommendations -->|<<include>>| CollectStudentData[Collect Student Data]
    GenerateRecommendations -->|<<include>>| CreateTutoringPlan[Create Tutoring Plan]
    GenerateRecommendations -->|<<extend>>| SuggestActivities[Suggest Activities]
    GenerateRecommendations -->|<<extend>>| SuggestResources[Suggest Resources]
    GenerateRecommendations -->|<<extend>>| SuggestStrategies[Suggest Strategies]
    GenerateRecommendations -->|<<extend>>| PrioritizeByImpact[Prioritize by Impact]

    AnalyzePerformance -->|<<include>>| IdentifyWeakAreas[Identify Weak Areas]
    AnalyzePerformance -->|<<include>>| IdentifyStrengths[Identify Strengths]

    MatchLearningStyle -->|<<include>>| RetrieveLearningProfile[Retrieve Learning Profile]

    ImplementRecommendations -->|<<include>>| MarkAsImplemented[Mark as Implemented]
    ImplementRecommendations -->|<<extend>>| RecordFeedback[Record Feedback]

    UpdateProgress -->|<<include>>| SaveProgress[Save Progress]
    UpdateProgress -->|<<extend>>| NotifyParent[Notify Parent]

    ProvideFeedback -->|<<include>>| SubmitFeedback[Submit Feedback]
    ProvideFeedback -->|<<extend>>| AdjustPlan[Adjust Plan]

    ViewRecommendations -->|<<include>>| LoadRecommendations[Load Recommendations]
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

### 4.2.2 User Account Management Module
```mermaid
flowchart TD
    Start([Start]) --> SelectAction{Select Action}
    SelectAction -->|Create Account| EnterDetails[Enter User Details]
    SelectAction -->|Edit Profile| LoadProfile[Load User Profile]
    SelectAction -->|Delete Account| ConfirmDelete{Confirm Deletion?}

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
    SaveChanges --> Success2[Show Success Message]
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
    UpdateAnalytics --> NotifyParent1[Notify Parent]
    NotifyParent1 --> End1([End])

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
    GenerateInsights --> CheckConcerns{Identify Concerns?}
    CheckConcerns -->|Yes| FlagConcerns[Flag for Review]
    FlagConcerns --> NotifyParent[Notify Parent and Admin]
    NotifyParent --> End1([End])
    CheckConcerns -->|No| NotifyParentUpdate[Send Update to Parent]
    NotifyParentUpdate --> End2([End])
```

### 4.2.5 Learning Style Analyzer Module
```mermaid
flowchart TD
    Start([Start]) --> SelectStudent[Select Student]
    SelectStudent --> CheckExisting{Existing Assessment?}

    CheckExisting -->|Yes| ViewExisting[View Existing Profile]
    ViewExisting --> UpdateOrNew{Update or New?}
    UpdateOrNew -->|View Only| DisplayProfile
    UpdateOrNew -->|Update| StartAssessment

    CheckExisting -->|No| StartAssessment[Start New Assessment]
    StartAssessment --> ConductObservation[Conduct Classroom Observation]
    ConductObservation --> RecordVisual[Record Visual Learning Indicators]
    RecordVisual --> RecordAuditory[Record Auditory Learning Indicators]
    RecordAuditory --> RecordKinesthetic[Record Kinesthetic Learning Indicators]
    RecordKinesthetic --> CompleteQuestionnaire[Complete Learning Questionnaire]
    CompleteQuestionnaire --> ReviewActivities[Review Preferred Activities]
    ReviewActivities --> ValidateData{Validate Data}

    ValidateData -->|Incomplete| ShowError[Show Error - Complete All Sections]
    ShowError --> ConductObservation

    ValidateData -->|Complete| AnalyzeResponses[Analyze All Responses]
    AnalyzeResponses --> CalculateScores[Calculate Style Scores]
    CalculateScores --> DetermineStyle{Determine Primary Style}

    DetermineStyle -->|Visual > 60%| AssignVisual[Assign Visual Learner]
    DetermineStyle -->|Auditory > 60%| AssignAuditory[Assign Auditory Learner]
    DetermineStyle -->|Kinesthetic > 60%| AssignKinesthetic[Assign Kinesthetic Learner]
    DetermineStyle -->|Mixed| AssignMixed[Assign Mixed/Multimodal Learner]

    AssignVisual --> GenerateProfile
    AssignAuditory --> GenerateProfile
    AssignKinesthetic --> GenerateProfile
    AssignMixed --> GenerateProfile

    GenerateProfile[Generate Learning Profile] --> AddRecommendations[Add Teaching Recommendations]
    AddRecommendations --> SaveProfile[Save Profile to Database]
    SaveProfile --> DisplayProfile[Display Learning Profile]
    DisplayProfile --> ShareWithParent{Share with Parent?}

    ShareWithParent -->|Yes| SendToParent[Send Profile to Parent]
    SendToParent --> TriggerRecommendations[Trigger Tutoring Recommendations]
    TriggerRecommendations --> End1([End])

    ShareWithParent -->|No| End2([End])
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
    IdentifyWeaknesses --> MatchLearningStyle[Match to Learning Style]

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

### 4.3.2 User Account Management Module
```mermaid
sequenceDiagram
    actor Admin
    participant UI as Admin UI
    participant Controller as User Controller
    participant Service as User Service
    participant Validator as Data Validator
    participant DB as Database
    participant Email as Email Service

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
            Service->>Email: sendWelcomeEmail(user)
            Email-->>Service: email sent
            Service-->>Controller: {userId, userData}
            Controller-->>UI: 201 Created {user}
            UI-->>Admin: Success message with user details
        end
    end

    Note over Admin,Email: Edit Profile Flow

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
    DB-->>Service: updated user
    Service-->>Controller: updated user
    Controller-->>UI: 200 OK {user}
    UI-->>Admin: Success message
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
    actor Admin
    participant UI as Admin UI
    participant Controller as Learning Style Controller
    participant Service as Learning Style Service
    participant Analyzer as Learning Analyzer AI
    participant DB as Database
    participant Recommendation as Recommendation Service
    participant Notification as Notification Service
    actor Parent

    Admin->>UI: Initiate learning style assessment
    UI->>Controller: POST /learning-style/assess {studentId}
    Controller->>Service: startAssessment(studentId)
    Service->>DB: checkExistingAssessment(studentId)
    DB-->>Service: existing assessment or null

    alt Has recent assessment
        Service-->>Controller: {existingAssessment, status: "recent"}
        Controller-->>UI: 200 OK {assessment}
        UI-->>Admin: Show existing with update option
    else No recent assessment
        Service->>DB: createAssessmentSession(studentId)
        DB-->>Service: sessionId
        Service-->>Controller: {sessionId, questions}
        Controller-->>UI: 200 OK {assessmentSession}
        UI-->>Admin: Display assessment form
    end

    Admin->>UI: Complete observation checklist
    Admin->>UI: Rate visual learning indicators
    Admin->>UI: Rate auditory learning indicators
    Admin->>UI: Rate kinesthetic learning indicators
    Admin->>UI: Add behavioral observations
    UI->>Controller: POST /learning-style/session/{sessionId}/observations {observations}
    Controller->>Service: saveObservations(sessionId, observations)
    Service->>DB: insertObservations(sessionId, observations)
    DB-->>Service: saved

    Admin->>UI: Complete learning questionnaire
    UI->>Controller: POST /learning-style/session/{sessionId}/questionnaire {responses}
    Controller->>Service: saveQuestionnaire(sessionId, responses)
    Service->>DB: insertQuestionnaire(sessionId, responses)
    DB-->>Service: saved

    Admin->>UI: Submit assessment
    UI->>Controller: POST /learning-style/session/{sessionId}/complete
    Controller->>Service: completeAssessment(sessionId)
    Service->>DB: fetchAllAssessmentData(sessionId)
    DB-->>Service: {observations, questionnaire, activities}

    Service->>Analyzer: analyzeLearningSt‌yle(assessmentData)
    Analyzer->>Analyzer: scoreVisualIndicators()
    Analyzer->>Analyzer: scoreAuditoryIndicators()
    Analyzer->>Analyzer: scoreKinestheticIndicators()
    Analyzer->>Analyzer: calculateConfidenceLevels()
    Analyzer->>Analyzer: identifyPrimaryStyle()
    Analyzer->>Analyzer: identifySecondaryStyles()
    Analyzer-->>Service: {primaryStyle, secondaryStyles, scores, confidence}

    Service->>Analyzer: generateTeachingRecommendations(learningStyle)
    Analyzer->>Analyzer: matchStrategies(primaryStyle)
    Analyzer->>Analyzer: suggestActivities(learningStyle)
    Analyzer->>Analyzer: recommendResources(learningStyle)
    Analyzer-->>Service: recommendations

    Service->>DB: saveLearningProfile(studentId, profile, recommendations)
    DB-->>Service: profileId

    Service->>Recommendation: triggerTutoringRecommendations(studentId, learningStyle)
    Recommendation-->>Service: triggered

    Service-->>Controller: {profileId, learningStyle, recommendations}
    Controller-->>UI: 201 Created {learningProfile}
    UI-->>Admin: Display learning profile

    Admin->>UI: Share with parent
    UI->>Controller: POST /learning-style/{profileId}/share
    Controller->>Service: shareWithParent(profileId, studentId)
    Service->>DB: getParentContact(studentId)
    DB-->>Service: parent email
    Service->>Notification: sendLearningProfile(parent, profile)
    Notification->>Email: emailLearningProfile(parent)
    Email-->>Parent: Learning style profile
    Service-->>Controller: shared
    Controller-->>UI: 200 OK
    UI-->>Admin: Confirmation
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
    AI->>AI: sequencedActivities()
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

1. **Use Case Diagrams**: Show the interactions between different actors (Parent, Admin, System) and the system functionalities
2. **Activity Diagrams**: Detail the workflow and decision points for each module's processes
3. **Sequence Diagrams**: Illustrate the interaction between different components (UI, Controllers, Services, Database) over time

### System Roles
- **Parent**: Can view their child's progress, performance, learning styles, and recommendations
- **Admin**: Manages all system operations including recording progress, conducting assessments, and managing user accounts
- **System**: Automated processes for analyzing data and generating recommendations

You can render these Mermaid diagrams using:
- GitHub Markdown (supports Mermaid natively)
- Mermaid Live Editor (https://mermaid.live)
- VS Code with Mermaid extensions
- Documentation platforms like GitBook, Docusaurus, etc.
