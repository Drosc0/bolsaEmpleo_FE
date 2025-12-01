
# **Design Documentation - Job Board Project**

## **1. Use Cases**

### **Actors**
- **Applicant**: User looking for a job.
- **Company**: User posting job offers.
- **System**: The job board platform.

### **Main Use Cases**

#### **Actor: Applicant**
1. **Register**: Create an account as an applicant.
2. **Log In**: Access the platform.
3. **Manage Profile**: Create, view, update, and delete their profile (including skills and experience).
4. **View Job Offers**: List and view details of available job offers.
5. **Apply**: Apply to a specific job offer.
6. **View My Applications**: Check the status of their applications.

#### **Actor: Company**
1. **Register**: Create an account as a company.
2. **Log In**: Access the platform.
3. **Manage Company Profile**: Create, view, and update company information.
4. **Manage Job Offers**: Create, view, update, and delete job offers.
5. **View Applications**: See applicants who have applied to their offers.
6. **Manage Application Status**: Change the status of an application (e.g., from "Pending" to "Interview").

---

## **2. Flowcharts**

### **Registration and Login Flow**
```mermaid
flowchart TD
    A[Start] --> B{Do you have an account?}
    B -- Yes --> C[Log In]
    B -- No --> D[Register]
    D --> E{Select Role}
    E -->|Applicant| F[Applicant Form]
    E -->|Company| G[Company Form]
    F --> H[Create Account]
    G --> H
    H --> C
    C --> I{Validate Credentials}
    I -- Valid --> J[Access Dashboard]
    I -- Invalid --> K[Show Error]
    K --> C
```

### Application Flow (Applicant)
```mermaid
flowchart TD
    A[Applicant Dashboard] --> B[View Job List]
    B --> C[Select Job Offer]
    C --> D[View Details]
    D --> E{Apply?}
    E -- Yes --> F{Logged In?}
    F -- No --> G[Redirect to Login]
    F -- Yes --> H[Submit Application]
    H --> I[Confirmation]
    E -- No --> B
```

### Job Offer Management Flow (Company)
```mermaid
flowchart TD
    A[Company Dashboard] --> B{Action}
    B -->|Create| C[New Offer Form]
    B -->|Edit| D[Select Existing Offer]
    B -->|Delete| E[Select Existing Offer]
    C --> F[Save Offer]
    D --> G[Modify Data] --> F
    E --> H[Confirm Deletion] --> I[Offer Deleted]
```

---

## 3. UML Class Diagram (Backend)

This diagram represents the main entities and their relationships in the database.

```mermaid
classDiagram
    class User {
        +int id
        +string email
        +string password
        +UserRole role
    }

    class AspirantProfile {
        +int id
        +string firstName
        +string lastName
        +string bio
        +string cvUrl
        +int userId
    }

    class CompanyProfile {
        +int id
        +string companyName
        +string description
        +string website
        +int userId
    }

    class JobOffer {
        +int id
        +string title
        +string description
        +string location
        +string salaryRange
        +string status
        +int companyId
    }

    class Application {
        +int id
        +ApplicationStatus status
        +string coverLetter
        +Date appliedAt
        +int aspirantId
        +int jobOfferId
    }

    class ExperienceItem {
        +int id
        +string title
        +string company
        +Date startDate
        +Date endDate
        +int profileId
    }

    class SkillItem {
        +int id
        +string skillName
        +SkillLevel level
        +int profileId
    }

    %% Relaciones
    User "1" -- "1" AspirantProfile : Has
    User "1" -- "1" CompanyProfile : Has
    CompanyProfile "1" -- "*" JobOffer : publish
    JobOffer "1" -- "*" Application : Gets
    AspirantProfile "1" -- "*" Application : receives
    AspirantProfile "1" -- "*" ExperienceItem : Has
    AspirantProfile "1" -- "*" SkillItem : Has
```

[BACK](README_EN.md)
