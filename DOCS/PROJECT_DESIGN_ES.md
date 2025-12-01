# Documentación de Diseño - Proyecto Bolsa de Empleo

## 1. Casos de Uso

### Actores
- **Aspirante**: Usuario que busca empleo.
- **Empresa**: Usuario que publica ofertas de empleo.
- **Sistema**: La plataforma de bolsa de empleo.

### Casos de Uso Principales

#### Actor: Aspirante
1.  **Registrarse**: Crear una cuenta como aspirante.
2.  **Iniciar Sesión**: Acceder a la plataforma.
3.  **Gestionar Perfil**: Crear, ver, actualizar y eliminar su perfil (incluyendo habilidades y experiencia).
4.  **Ver Ofertas**: Listar y ver detalles de ofertas de trabajo disponibles.
5.  **Postularse**: Aplicar a una oferta de trabajo específica.
6.  **Ver Mis Postulaciones**: Consultar el estado de sus postulaciones.

#### Actor: Empresa
1.  **Registrarse**: Crear una cuenta como empresa.
2.  **Iniciar Sesión**: Acceder a la plataforma.
3.  **Gestionar Perfil de Empresa**: Crear, ver y actualizar la información de la empresa.
4.  **Gestionar Ofertas**: Crear, ver, actualizar y eliminar ofertas de trabajo.
5.  **Ver Postulaciones**: Ver los aspirantes que se han postulado a sus ofertas.
6.  **Gestionar Estado de Postulación**: Cambiar el estado de una postulación (ej: de "Pendiente" a "Entrevista").

---

## 2. Diagramas de Flujo

### Flujo de Registro e Inicio de Sesión
```mermaid
flowchart TD
    A[Inicio] --> B{¿Tiene Cuenta?}
    B -- Sí --> C[Iniciar Sesión]
    B -- No --> D[Registrarse]
    D --> E{Seleccionar Rol}
    E -->|Aspirante| F[Formulario Aspirante]
    E -->|Empresa| G[Formulario Empresa]
    F --> H[Crear Cuenta]
    G --> H
    H --> C
    C --> I{Validar Credenciales}
    I -- Válido --> J[Acceso al Dashboard]
    I -- Inválido --> K[Mostrar Error]
    K --> C
```

### Flujo de Postulación (Aspirante)
```mermaid
flowchart TD
    A[Dashboard Aspirante] --> B[Ver Lista de Ofertas]
    B --> C[Seleccionar Oferta]
    C --> D[Ver Detalles]
    D --> E{¿Postularse?}
    E -- Sí --> F{¿Está Logueado?}
    F -- No --> G[Redirigir a Login]
    F -- Sí --> H[Enviar Postulación]
    H --> I[Confirmación]
    E -- No --> B
```

### Flujo de Gestión de Oferta (Empresa)
```mermaid
flowchart TD
    A[Dashboard Empresa] --> B{Acción}
    B -->|Crear| C[Formulario Nueva Oferta]
    B -->|Editar| D[Seleccionar Oferta Existente]
    B -->|Eliminar| E[Seleccionar Oferta Existente]
    C --> F[Guardar Oferta]
    D --> G[Modificar Datos] --> F
    E --> H[Confirmar Eliminación] --> I[Oferta Eliminada]
```

---

## 3. Diagrama de Clases UML (Backend)

Este diagrama representa las entidades principales y sus relaciones en la base de datos.

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
    User "1" -- "1" AspirantProfile : tiene
    User "1" -- "1" CompanyProfile : tiene
    CompanyProfile "1" -- "*" JobOffer : publica
    JobOffer "1" -- "*" Application : recibe
    AspirantProfile "1" -- "*" Application : realiza
    AspirantProfile "1" -- "*" ExperienceItem : tiene
    AspirantProfile "1" -- "*" SkillItem : tiene
```
[VOLVER](README.md)