# Frontend Documentation - Proyecto Bolsa de Empleo

## Introduction
The frontend of the Job Board project is built with **Flutter**. It follows a **Clean Architecture** approach and uses **Provider** for state management (MVVM pattern).

## Architecture
The project is structured into three main layers:

### 1. Core (`lib/core`)
Contains shared resources and services.
- **Services**: `ApiService` (HTTP client), `SecureStorageService` (Token storage).
- **Theme**: `AppTheme` (Light/Dark mode).

### 2. Data (`lib/data`)
Handles data retrieval and transformation.
- **Models**: `JobOffer`, `User`, `AppStats`, etc.
- **Repositories**:
    - `AuthRepository`: Login, Register.
    - `RecruitmentRepository`: Fetch job offers, stats.
    - `ApplicationsRepository`: Apply to jobs.

### 3. Presentation (`lib/presentation`)
Contains the UI and ViewModels.
- **State Management**: Uses `Provider` with `ChangeNotifier` (MVVM).
- **Structure**:
    - `view`: The UI widgets (Stateless/Stateful).
    - `viewmodel`: The logic and state (`ChangeNotifier`).

## Key Components

### Main Entry Point (`main.dart`)
- Initializes `Repositories` with `ApiService`.
- Sets up `MultiProvider` to inject ViewModels (`AuthViewModel`, `HomeViewModel`, `ThemeViewModel`).
- Launches `MaterialApp` with `HomePage`.

### Navigation
The app currently uses Flutter's native **Navigator 1.0** (`Navigator.push`, `Navigator.pop`) for simple transitions between screens (e.g., Home -> Login).

### Screens
#### HomePage (`presentation/home`)
- **Responsive Layout**: Adapts to Mobile, Tablet, and Web.
- **Features**:
    - Displays App Statistics (Users, Aspirants, Companies).
    - Lists Job Offers.
    - Theme Toggle.
    - Login/Logout actions.
- **ViewModel**: `HomeViewModel` (fetches offers and stats).

#### Auth (`presentation/auth`)
- **LoginPage**: Handles user login.
- **ViewModel**: `AuthViewModel` (manages auth state `authenticated`, `unauthenticated`).

## State Management
- **AuthViewModel**: Tracks authentication status and user role.
- **HomeViewModel**: Manages the list of job offers and loading states (`loading`, `loaded`, `error`).
- **ThemeViewModel**: Manages the application theme (Light/Dark).

[BACK](README_EN.md)