# Preschool Performance Tracker Module - Activity Diagram

## Overview

This activity diagram focuses exclusively on the **Preschool Performance Tracker** module, which allows parents to track their child's developmental progress across four key domains and receive AI-powered insights based on CDC developmental milestones.

## Main Activity Flow

```mermaid
flowchart TD
    Start([Start]) --> Login[Parent Logs In]
    Login --> Dashboard[Access Dashboard]
    Dashboard --> Navigate[Navigate to Preschool<br/>Performance Tracker]
    Navigate --> SelectChild[Select Child]

    SelectChild --> ChooseDomain[Choose Assessment Domain]

    ChooseDomain --> DomainNote["<b>4 Assessment Domains:</b><br/>• Social/Emotional Milestones<br/>• Cognitive Milestones<br/>• Language/Communication<br/>• Movement/Physical Development"]

    DomainNote --> EnterObs[Enter Developmental<br/>Observations]

    EnterObs --> ObsNote["Parent describes specific behaviors,<br/>milestones, or observations<br/>for the selected domain"]

    ObsNote --> Validate[System: Validate Input]
    Validate --> Store[System: Store Observation<br/>in Database]

    Store --> DBNote["<b>Table:</b> preschool_assessments<br/><b>Fields:</b> child_id, domain,<br/>observation, assessment_date"]

    DBNote --> MoreObs{Add More<br/>Observations?}

    MoreObs -->|Yes| ChooseDomain
    MoreObs -->|No| RequestAI[Parent: Request AI Analysis]

    RequestAI --> RetrieveObs[System: Retrieve All<br/>Child Observations]
    RetrieveObs --> LoadBench[System: Load CDC<br/>Developmental Milestones]

    LoadBench --> BenchNote["<b>Source:</b> developmental_milestones.csv<br/>Age-appropriate benchmarks for:<br/>• Social/Emotional skills<br/>• Cognitive development<br/>• Language/Communication<br/>• Physical/Motor development"]

    BenchNote --> CalcHash[System: Calculate Data Hash]

    CalcHash --> HashNote["Hash based on:<br/>• All observations<br/>• Child's age<br/>• Assessment dates"]

    HashNote --> CheckCache{Cached Result<br/>Exists AND No<br/>Regeneration?}

    CheckCache -->|Yes| GetCache[System: Retrieve<br/>Cached AI Analysis]
    GetCache --> CacheNote["<b>Table:</b> ai_results<br/><b>Fields:</b> child_id, module='preschool',<br/>result_data, data_hash, generated_at"]
    CacheNote --> FormatResults[System: Format<br/>Analysis Results]

    CheckCache -->|No| PrepPrompt[System: Prepare Prompt<br/>for Google Gemini AI]

    PrepPrompt --> PromptNote["Prompt includes:<br/>• Child's age<br/>• All developmental observations<br/>• CDC benchmark data<br/>• Request for analysis"]

    PromptNote --> CallAI[Google Gemini AI:<br/>Call Gemini 2.5 Flash API]
    CallAI --> AnalyzeObs[AI: Analyze Observations<br/>vs Benchmarks]
    AnalyzeObs --> GenInsights[AI: Generate Age-Appropriate<br/>Insights]

    GenInsights --> AINote["<b>AI Analysis includes:</b><br/>• Developmental progress assessment<br/>• Comparison to age norms<br/>• Identified strengths<br/>• Areas for improvement<br/>• Specific recommendations<br/>• Activity suggestions"]

    AINote --> ReceiveResp[System: Receive AI Response]
    ReceiveResp --> CacheResult[System: Cache Result<br/>in Database]
    CacheResult --> FormatResults

    FormatResults --> ViewAnalysis[Parent: View Developmental<br/>Analysis]

    ViewAnalysis --> ViewNote["<b>Display shows:</b><br/>• Domain-by-domain assessment<br/>• Strengths and achievements<br/>• Areas needing attention<br/>• Age-appropriate recommendations<br/>• Suggested activities<br/>• Comparison to milestones"]

    ViewNote --> ReviewRec[Parent: Review<br/>Recommendations]

    ReviewRec --> NeedDetails{Need More<br/>Details?}

    NeedDetails -->|Yes| ViewDomain[View Domain-Specific<br/>Insights]
    ViewDomain --> ReadActivities[Read Activity<br/>Suggestions]
    ReadActivities --> RegenAI{Regenerate Analysis<br/>with Fresh AI?}

    NeedDetails -->|No| RegenAI

    RegenAI -->|Yes| ClickRegen[Parent: Click<br/>"Regenerate Analysis"]
    ClickRegen --> ForceAI[System: Force AI Re-analysis]
    ForceAI --> ForceNote["Bypasses cache and calls<br/>Gemini AI again"]
    ForceNote --> CallAI

    RegenAI -->|No| ExportReport{Export or<br/>Save Report?}

    ExportReport -->|Yes| GenReport[System: Generate<br/>Assessment Report]
    GenReport --> Download[Parent: Download/Save Report]
    Download --> AddMoreObs{Add More<br/>Observations?}

    ExportReport -->|No| AddMoreObs

    AddMoreObs -->|Yes| BackToEntry[Return to<br/>Observation Entry]
    BackToEntry --> ChooseDomain

    AddMoreObs -->|No| ReturnDash[Return to Dashboard]
    ReturnDash --> End([End])

    classDef parentNode fill:#e1bee7,stroke:#4a148c,stroke-width:2px
    classDef systemNode fill:#c8e6c9,stroke:#1b5e20,stroke-width:2px
    classDef aiNode fill:#bbdefb,stroke:#0d47a1,stroke-width:2px
    classDef noteNode fill:#fff9c4,stroke:#f57f17,stroke-width:1px
    classDef decisionNode fill:#ffccbc,stroke:#bf360c,stroke-width:2px

    class Login,Dashboard,Navigate,SelectChild,EnterObs,RequestAI,ViewAnalysis,ReviewRec,ViewDomain,ReadActivities,ClickRegen,Download,ReturnDash parentNode
    class Validate,Store,RetrieveObs,LoadBench,CalcHash,CheckCache,GetCache,PrepPrompt,ReceiveResp,CacheResult,FormatResults,ForceAI,GenReport systemNode
    class CallAI,AnalyzeObs,GenInsights aiNode
    class DomainNote,ObsNote,DBNote,BenchNote,HashNote,CacheNote,PromptNote,AINote,ViewNote,ForceNote noteNode
    class MoreObs,NeedDetails,RegenAI,ExportReport,AddMoreObs decisionNode
```

## Key Components

### 1. Assessment Domains

The preschool performance tracker monitors four critical developmental areas:

| Domain | Description | Example Observations |
|--------|-------------|---------------------|
| **Social/Emotional** | Interpersonal skills, emotional regulation, self-awareness | Shares toys with peers, expresses feelings, shows empathy |
| **Cognitive** | Problem-solving, memory, attention, early math/logic | Counts objects, sorts by color, solves simple puzzles |
| **Language/Communication** | Speech development, vocabulary, comprehension | Uses 2-3 word sentences, follows simple instructions |
| **Movement/Physical** | Gross and fine motor skills, coordination | Runs, jumps, holds crayon, uses utensils |

### 2. Database Tables

#### `preschool_assessments`
Stores parent observations for each developmental domain:

```sql
CREATE TABLE preschool_assessments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    child_id INT NOT NULL,
    domain VARCHAR(50) NOT NULL,  -- social, cognitive, language, movement
    observation TEXT NOT NULL,
    assessment_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (child_id) REFERENCES children(id)
);
```

#### `ai_results`
Caches AI-generated analysis to reduce API costs and improve response time:

```sql
CREATE TABLE ai_results (
    id INT PRIMARY KEY AUTO_INCREMENT,
    child_id INT NOT NULL,
    module VARCHAR(50) NOT NULL,  -- 'preschool' for this module
    result_data TEXT NOT NULL,     -- JSON containing AI analysis
    data_hash VARCHAR(255) NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (child_id) REFERENCES children(id)
);
```

### 3. CDC Developmental Milestones

The system uses standardized CDC (Centers for Disease Control and Prevention) developmental milestones as benchmarks:

- **Source File**: `/static/data/developmental_milestones.csv`
- **Content**: Age-appropriate milestones for each domain
- **Usage**: AI compares child's observations against these benchmarks to assess developmental progress

### 4. AI Analysis Process

#### Input to Gemini AI:
1. Child's current age
2. All developmental observations organized by domain
3. CDC milestone benchmarks for the child's age group
4. Specific prompt requesting comparative analysis

#### AI Output Includes:
- ✅ **Progress Assessment**: Overall developmental status
- ✅ **Domain Analysis**: Strengths and challenges in each area
- ✅ **Milestone Comparison**: How child compares to age norms
- ✅ **Recommendations**: Specific activities and strategies
- ✅ **Activity Suggestions**: Age-appropriate games, exercises, and practices
- ✅ **Areas of Focus**: Where parents should concentrate efforts

### 5. Caching Strategy

The system implements intelligent caching to:
- **Reduce API Costs**: Avoid repeated calls for unchanged data
- **Improve Response Time**: Instant results for cached analyses
- **Smart Invalidation**: Data hash changes when observations are added/modified

**Cache Hit Conditions:**
- Cached result exists for child
- Data hash matches current observations
- User hasn't requested fresh regeneration

**Cache Miss Triggers:**
- New observation added
- Existing observation modified
- User clicks "Regenerate Analysis"
- No previous analysis exists

## User Workflow Steps

### Phase 1: Data Entry
1. Parent logs in and navigates to Preschool Performance Tracker
2. Selects child from profile list
3. Chooses developmental domain to assess
4. Enters detailed observations about child's behaviors and abilities
5. Repeats for additional domains as needed

### Phase 2: AI Analysis
6. Requests AI analysis of all observations
7. System loads CDC benchmarks for child's age
8. System checks cache for existing analysis
9. If cache miss: Calls Google Gemini AI for fresh analysis
10. AI compares observations against age-appropriate milestones
11. System caches result for future use

### Phase 3: Review and Action
12. Parent views comprehensive developmental analysis
13. Reviews domain-specific insights and recommendations
14. Reads suggested activities and strategies
15. Optional: Regenerates analysis if significant new observations added
16. Optional: Exports/saves report for records or sharing with educators

## Technical Integration

### Google Gemini AI
- **Model**: gemini-2.5-flash
- **API**: `google.generativeai` Python library
- **Rate Limiting**: Managed through caching strategy
- **Error Handling**: Fallback to cached results if API unavailable

### Data Flow
```
Parent Input → Validation → Database Storage → Hash Calculation → Cache Check
                                                                        ↓
                                                                    Hit? → Cached Result
                                                                        ↓
                                                                    Miss? → AI Analysis
                                                                        ↓
                                                                    Cache → Format → Display
```

## Key Features

🎯 **Age-Appropriate Analysis**: AI tailors feedback to child's specific age
🎯 **Evidence-Based**: Uses CDC developmental milestone standards
🎯 **Multi-Domain Assessment**: Covers all critical areas of early childhood development
🎯 **Actionable Insights**: Provides specific, practical recommendations
🎯 **Performance Optimized**: Smart caching reduces costs and improves speed
🎯 **Continuous Tracking**: Parents can add observations over time and see progress
🎯 **Regeneration Option**: Fresh analysis available when needed

## Benefit to Parents

✅ Understand child's developmental progress objectively
✅ Identify areas where child excels or needs support
✅ Receive expert-backed recommendations
✅ Get specific activities to support development
✅ Track progress over time with multiple assessments
✅ Make informed decisions about early intervention if needed

---

**Related Files:**
- **Main Application**: `/home/user/childfyp5/app.py` (route: `/dashboard/preschool`)
- **Database Schema**: `/home/user/childfyp5/child_growth_insights (1).sql`
- **Milestone Data**: `/home/user/childfyp5/static/data/developmental_milestones.csv`
- **Configuration**: `/home/user/childfyp5/config.py` (Gemini API settings)

---

*This focused activity diagram represents only the Preschool Performance Tracker module workflows and processes.*
