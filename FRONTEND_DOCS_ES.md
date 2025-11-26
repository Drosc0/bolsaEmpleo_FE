# Documentación del Frontend - Proyecto Bolsa de Empleo

## Introducción
El frontend del proyecto Bolsa de Empleo está construido con **Flutter**. Sigue un enfoque de **Arquitectura Limpia** (Clean Architecture) y utiliza **Provider** para la gestión de estado (patrón MVVM).

## Arquitectura
El proyecto se estructura en tres capas principales:

### 1. Core (`lib/core`)
Contiene recursos y servicios compartidos.
- **Servicios**: `ApiService` (Cliente HTTP), `SecureStorageService` (Almacenamiento de tokens).
- **Tema**: `AppTheme` (Modo Claro/Oscuro).

### 2. Data (`lib/data`)
Maneja la obtención y transformación de datos.
- **Modelos**: `JobOffer`, `User`, `AppStats`, etc.
- **Repositorios**:
    - `AuthRepository`: Login, Registro.
    - `RecruitmentRepository`: Obtener ofertas de trabajo, estadísticas.
    - `ApplicationsRepository`: Postularse a trabajos.

### 3. Presentation (`lib/presentation`)
Contiene la interfaz de usuario (UI) y los ViewModels.
- **Gestión de Estado**: Utiliza `Provider` con `ChangeNotifier` (MVVM).
- **Estructura**:
    - `view`: Los widgets de UI (Stateless/Stateful).
    - `viewmodel`: La lógica y el estado (`ChangeNotifier`).

## Componentes Clave

### Punto de Entrada (`main.dart`)
- Inicializa los `Repositorios` con `ApiService`.
- Configura `MultiProvider` para inyectar los ViewModels (`AuthViewModel`, `HomeViewModel`, `ThemeViewModel`).
- Lanza `MaterialApp` con `HomePage`.

### Navegación
La aplicación utiliza actualmente el **Navigator 1.0** nativo de Flutter (`Navigator.push`, `Navigator.pop`) para transiciones simples entre pantallas (ej: Home -> Login).

### Pantallas
#### HomePage (`presentation/home`)
- **Diseño Responsivo**: Se adapta a Móvil, Tablet y Web.
- **Características**:
    - Muestra Estadísticas de la App (Usuarios, Aspirantes, Empresas).
    - Lista Ofertas de Trabajo.
    - Cambio de Tema (Claro/Oscuro).
    - Acciones de Login/Logout.
- **ViewModel**: `HomeViewModel` (obtiene ofertas y estadísticas).

#### Auth (`presentation/auth`)
- **LoginPage**: Maneja el inicio de sesión del usuario.
- **ViewModel**: `AuthViewModel` (gestiona el estado de autenticación `authenticated`, `unauthenticated`).

## Gestión de Estado
- **AuthViewModel**: Rastrea el estado de autenticación y el rol del usuario.
- **HomeViewModel**: Gestiona la lista de ofertas de trabajo y los estados de carga (`loading`, `loaded`, `error`).
- **ThemeViewModel**: Gestiona el tema de la aplicación (Claro/Oscuro).
