
# Project Documentation: Employment Exchange

## Acknowledgments
*(This section is optional. To be completed by the author if they wish to dedicate the project to individuals, institutions, or companies).*

---

## Summary
The present project, called **"Employment Exchange"**, consists of developing a comprehensive platform for managing recruitment and job search processes. The main objective is to facilitate the connection between companies seeking talent and candidates looking for job opportunities through a modern, intuitive interface accessible from multiple devices.

The system has been built using a robust client-server architecture. On the client side (**Frontend**), **Flutter** has been used, allowing for a smooth user experience on both web and mobile environments with a single codebase. For the server (**Backend**), **NestJS** was chosen, a Node.js framework that ensures scalability and maintainability, along with **PostgreSQL** as the relational database management system to guarantee data integrity and persistence.

The application allows users to register under two distinct roles: **Candidate** and **Company**. Candidates can create and manage their professional profile, explore job offers, and apply for them. Companies, on the other hand, can manage their corporate profile, publish job offers, and review received applications. The system implements security measures such as authentication via **JWT (JSON Web Tokens)** and data validation to ensure a secure environment.

This project not only demonstrates the practical application of modern web and mobile development technologies but also provides a real solution to the need for digitizing and optimizing recruitment processes.

---

## Keywords
Employment Exchange, Recruitment, Flutter, NestJS, PostgreSQL, Candidate Management, Cross-Platform Application.

---


## General Index

### CHAPTER 1. PROJECT REPORT
1.1 SUMMARY OF MOTIVATION  
1.2 OBJECTIVES  

### CHAPTER 2. INTRODUCTION
2.1 PROJECT JUSTIFICATION  
2.2 STUDY OF THE CURRENT SITUATION  

### CHAPTER 3. THEORETICAL ASPECTS
3.1 FLUTTER (FRONTEND)  
3.2 NESTJS (BACKEND)  
3.3 POSTGRESQL (DATABASE)  
3.4 CLEAN ARCHITECTURE  

### CHAPTER 4. ANALYSIS
4.1 SYSTEM DEFINITION  
4.2 REQUIREMENTS CATALOG  
4.3 IDENTIFICATION OF SYSTEM ACTORS  
4.4 USE CASE SPECIFICATION  
4.5 PRELIMINARY CLASS DIAGRAM FOR ANALYSIS  
4.6 STYLE GUIDELINES  

### CHAPTER 5. TEST PLAN
5.1 INTRODUCTION  
5.2 DESIGN AND PLANNING OF THE TEST PLAN  
5.3 ANALYSIS AND INTERPRETATION OF RESULTS  

### CHAPTER 6. SYSTEM DESIGN
6.1 SYSTEM ARCHITECTURE  
6.2 CLASS DESIGN  
6.3 INTERACTION AND STATE DIAGRAMS  
6.4 ACTIVITY DIAGRAMS  
6.5 DATABASE DESIGN  
6.6 INTERFACE DESIGN  

### CHAPTER 7. SYSTEM IMPLEMENTATION
7.1 STANDARDS AND GUIDELINES FOLLOWED  
7.2 PROGRAMMING LANGUAGES  
7.3 TOOLS AND SOFTWARE USED  
7.4 SYSTEM CREATION  

### CHAPTER 8. SYSTEM MANUALS
8.1 INSTALLATION MANUAL  
8.2 USER MANUAL  

### CHAPTER 9. CONCLUSIONS AND EXTENSIONS
9.1 CONCLUSIONS  
9.2 FUTURE EXTENSIONS  

### CHAPTER 10. APPENDICES
10.1 GLOSSARY AND DATA DICTIONARY  

---


## Chapter 1. Project Report

### 1.1 Summary of Motivation
The idea for this project arises from the need to modernize and simplify labor intermediation processes. Existing platforms are often complex, unintuitive, or fail to provide a unified experience across mobile and web devices. The main motivation has been to create a tool that removes these barriers, enabling candidates to find jobs more efficiently and companies to manage their vacancies more easily. The goal was to apply a professional software architecture that ensures scalability and long-term maintainability.

### 1.2 Objectives
1. Develop a functional cross-platform (Web/Mobile) application for managing job offers.
2. Implement a secure authentication and authorization system for different user roles (Candidate and Company).
3. Allow companies to create, edit, and delete job postings, as well as view registered candidates.
4. Enable candidates to manage their professional profile and apply for available job offers.
5. Ensure data persistence and consistency through a robust relational database.

---

## Chapter 2. Introduction

### 2.1 Project Justification
In today’s job market, agility is key. Companies need to fill vacancies quickly, and candidates seek opportunities that match their profile without wasting time on bureaucratic processes. This project is justified by its ability to centralize these interactions in a modern technological platform, reducing management times and improving user experience through a clean and responsive interface. Unlike generic solutions, this system focuses on usability and efficiency in the recruitment workflow.


### 2.2 Study of the Current Situation
There are numerous employment platforms (LinkedIn, InfoJobs, Indeed):
* **LinkedIn**: A professional social network. Very comprehensive but sometimes cluttered with social content unrelated to job postings.
* **InfoJobs**: A classic job portal. Functional, but with occasionally outdated interfaces and lengthy registration processes.
* **Indeed**: A job offer aggregator. Large volume, but sometimes less control over the quality of postings by the publishing company.

Our proposal aims to fill the niche of more direct and simplified management, eliminating the “noise” of social networks and focusing the experience purely on job supply and demand, using more modern and responsive technology.

---

## Chapter 3. Theoretical Aspects

### 3.1 Flutter
An open-source framework created by Google to build beautiful, natively compiled, cross-platform applications from a single codebase. In this project, it is used for the Frontend, leveraging its Widget system and the Dart language.

### 3.2 NestJS
A progressive Node.js framework for building efficient and scalable server-side applications. It uses TypeScript by default and is inspired by Angular’s architecture (modules, controllers, services), which facilitates code organization and dependency injection.

### 3.3 PostgreSQL
A powerful open-source object-relational database management system. It is used to store all system information (users, job offers, applications), ensuring ACID integrity.

### 3.4 Clean Architecture
The project follows clean architecture principles, separating code into layers (Presentation, Domain, Data) to ensure that business logic is independent of the user interface and external frameworks, making testing and maintenance easier.

---


## Chapter 4. Analysis

### 4.1 System Definition
#### 4.1.1 Determining the Scope of the System
The system will cover the complete management of the lifecycle of a basic job offer: from its creation by a company to a candidate’s application. It will not include advanced features such as real-time chat, integrated video calls, or psychometric tests in this first version.

### 4.2 Requirements Catalog
#### 4.2.1 Functional Requirements
* **FR 1**: User Management (Registration and Login with JWT).
* **FR 2**: Company Profile Management (Edit corporate data).
* **FR 3**: Candidate Profile Management (Edit personal and professional data).
* **FR 4**: Job Offer Management (Create, Edit, Delete, List).
* **FR 5**: Job Application (Candidates apply to offers).
* **FR 6**: Candidate Visualization (Companies see who applied).
* **FR 7**: Role-specific dashboards (Company and Candidate).
* **FR 8**: Navigation between homepage and dashboards based on authentication.
* **FR 9**: Session persistence through secure storage.

#### 4.2.2 Non-Functional Requirements
* **NFR 1**: Security (Encrypted passwords, JWT).
* **NFR 2**: Availability (24/7 service).
* **NFR 3**: Scalability (Ability to support multiple concurrent users).

### 4.3 Identification of System Actors
* **Candidate**: User seeking employment.
* **Company**: User offering employment.
* **Administrator**: (Optional) Manages the system globally.

### 4.4 Use Case Specification
* **UC-01 Register**: The user creates an account.
* **UC-02 Log In**: The user accesses the system.
* **UC-03 Post Job Offer**: The company creates a new vacancy.
* **UC-04 Apply to Job Offer**: The candidate applies for a vacancy.

### 4.6 Style Guidelines
* **Color Palette**: Professional corporate colors (Blues, Whites, Grays) to convey professionalism.
* **Fonts**: Modern Sans-Serif typefaces (e.g., Roboto, Open Sans) for on-screen readability.

---


## Chapter 5. Test Plan

### 5.2 Design and Planning
* **Unit Tests**: Verification of business logic in NestJS services and repositories.
* **Integration Tests**: Verification of API endpoints (Controllers + Services + DB).
* **Functional Tests**: Complete user flows (Register → Login → Create Job Offer).

---

## Chapter 6. System Design

### 6.1 System Architecture
N-Tier Architecture:
* **Frontend**: Presentation layer (Flutter).
* **Backend**: Business logic and data access layer (NestJS).
* **Database**: Persistence layer (PostgreSQL).

### 6.5 Database Design
#### 6.5.3 E-R Diagram (Description)
* **Users Table**: Stores credentials and role.
* **Companies Table**: Extends Users, company data.
* **Applicants Table**: Extends Users, candidate data.
* **JobOffers Table**: Published offers, FK to Companies.
* **Applications Table**: N:M relationship between Applicants and JobOffers.

---


## Chapter 7. System Implementation

### 7.1 Standards and Guidelines Followed
* **Clean Architecture**: Layer separation (Core, Data, Presentation).
* **Provider Pattern**: State management using Provider for ViewModels.
* **Repository Pattern**: Data access abstraction.

### 7.2 Programming Languages
* **Dart**: Version 3.x (Frontend with Flutter).
* **TypeScript**: Version 5.x (Backend with NestJS).

### 7.3 Tools and Software Used
* **Visual Studio Code**: Main IDE.
* **Postman/Insomnia**: API testing.
* **Git**: Version control.
* **Flutter DevTools**: Debugging and performance analysis.

### 7.4 Frontend Structure
* **lib/core**: Core services (ApiService, SecureStorageService), themes, and utilities.
* **lib/data**: Data models and repositories (AuthRepository, RecruitmentRepository, ApplicationsRepository, etc.).
* **lib/presentation**: User interfaces organized by functionality:
    * **auth**: Registration and login screens with AuthViewModel.
    * **home**: Main page with job listings.
    * **dashboard/company**: Company dashboard for job management and candidate visualization.
    * **dashboard/applicant**: Applicant dashboard for profile and application management.
    * **common**: Shared components and ThemeViewModel.
    * **shared**: Reusable widgets.

---


## Chapter 8. System Manuals

### 8.1 Installation Manual
1. Clone the repository.
2. Backend: `cd bolsaEmpleo_BE` → `npm install` → Configure `.env` → `npm run start:dev`.
3. Frontend: `cd bolsaEmpleo_FE` → `flutter pub get` → `flutter run`.

### 8.2 User Manual

#### For Candidates:
1. **Registration**: Go to the registration screen, select the "Candidate" role, and complete personal details.
2. **Login**: Enter email and password. The system automatically redirects to the candidate dashboard.
3. **Browse Job Offers**: From the dashboard or homepage, navigate through the list of available offers.
4. **Apply to Job Offers**: Click on an offer to view details and then click "Apply."
5. **Manage Profile**: Edit personal and professional information from the dashboard.
6. **View Applications**: Check the status of submitted applications.

#### For Companies:
1. **Registration**: Go to the registration screen, select the "Company" role, and complete corporate details.
2. **Login**: Enter email and password. The system automatically redirects to the company dashboard.
3. **Create Job Offer**: In the dashboard, enter the new offer details in the form and click "Create Offer" to publish a job.
4. **Manage Offers**: View, edit, or delete existing offers from the dashboard.
5. **View Candidates**: Access offer details to see the list of applicants.
6. **Edit Profile**: Update company information from the dashboard.

#### General Navigation:
* **"Go to Dashboard" Button**: Available on the homepage when the user is authenticated, allowing navigation to the appropriate dashboard based on role.
* **Dark/Light Mode**: Toggle available in the interface to switch visual themes.

---

## Chapter 9. Conclusions and Extensions

### 9.1 Conclusions
A functional system has been developed that meets the objectives of connecting job supply and demand. The choice of Flutter and NestJS proved effective for fast and robust development.

### 9.2 Future Extensions
* Real-time chat between company and candidate.
* Push notifications.
* LinkedIn integration to import profiles.
* Payment system to highlight job offers.
* Implement AI to suggest candidates to companies.

---

## Chapter 10. Appendices

### 10.1 Glossary
* **API**: Application Programming Interface.
* **JWT**: JSON Web Token, a standard for authentication.
* **Widget**: Basic UI building block in Flutter.
