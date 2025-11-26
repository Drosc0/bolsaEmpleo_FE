# Documentación del Proyecto: Bolsa de Empleo

## Agradecimientos
*(Esta sección es opcional. A rellenar por el autor si desea dedicar el proyecto a personas, instituciones o empresas).*

---

## Resumen
El presente proyecto, denominado "Bolsa de Empleo", consiste en el desarrollo de una plataforma integral para la gestión de procesos de reclutamiento y búsqueda de empleo. El objetivo principal es facilitar la conexión entre empresas que buscan talento y candidatos que buscan oportunidades laborales, mediante una interfaz moderna, intuitiva y accesible desde múltiples dispositivos.

El sistema se ha construido utilizando una arquitectura cliente-servidor robusta. En el lado del cliente (Frontend), se ha empleado **Flutter**, lo que permite ofrecer una experiencia de usuario fluida tanto en entornos web como móviles con una única base de código. Para el servidor (Backend), se ha optado por **NestJS**, un framework de Node.js que garantiza escalabilidad y mantenibilidad, junto con **PostgreSQL** como sistema de gestión de base de datos relacional para asegurar la integridad y persistencia de la información.

La aplicación permite a los usuarios registrarse bajo dos roles diferenciados: **Candidato** y **Empresa**. Los candidatos pueden crear y gestionar su perfil profesional, explorar ofertas de empleo y postularse a las mismas. Por su parte, las empresas tienen la capacidad de gestionar su perfil corporativo, publicar ofertas de trabajo y revisar las candidaturas recibidas. El sistema implementa medidas de seguridad como autenticación mediante JWT (JSON Web Tokens) y validación de datos para garantizar un entorno seguro.

Este proyecto no solo demuestra la aplicación práctica de tecnologías modernas de desarrollo web y móvil, sino que también ofrece una solución real a la necesidad de digitalizar y optimizar los procesos de selección de personal.

---

## Palabras Clave
Bolsa de Empleo, Reclutamiento, Flutter, NestJS, PostgreSQL, Gestión de Candidatos, Aplicación Multiplataforma.

---

## Índice General

### CAPÍTULO 1. MEMORIA DEL PROYECTO
1.1 RESUMEN DE LA MOTIVACIÓN
1.2 OBJETIVOS

### CAPÍTULO 2. INTRODUCCIÓN
2.1 JUSTIFICACIÓN DEL PROYECTO
2.2 ESTUDIO DE LA SITUACIÓN ACTUAL

### CAPÍTULO 3. ASPECTOS TEÓRICOS
3.1 FLUTTER (FRONTEND)
3.2 NESTJS (BACKEND)
3.3 POSTGRESQL (BASE DE DATOS)
3.4 ARQUITECTURA LIMPIA (CLEAN ARCHITECTURE)

### CAPÍTULO 4. ANÁLISIS
4.1 DEFINICIÓN DEL SISTEMA
4.2 CATÁLOGO DE REQUISITOS
4.3 IDENTIFICACIÓN DE ACTORES DEL SISTEMA
4.4 ESPECIFICACIÓN DE CASOS DE USO
4.5 DIAGRAMA DE CLASES PRELIMINAR DEL ANÁLISIS
4.6 GUÍAS DE ESTILO

### CAPÍTULO 5. PLAN DE PRUEBAS
5.1 INTRODUCCIÓN
5.2 DISEÑO Y PLANIFICACIÓN DEL PLAN DE PRUEBAS
5.3 ANÁLISIS E INTERPRETACIÓN DE RESULTADOS

### CAPÍTULO 6. DISEÑO DEL SISTEMA
6.1 ARQUITECTURA DEL SISTEMA
6.2 DISEÑO DE CLASES
6.3 DIAGRAMAS DE INTERACCIÓN Y ESTADOS
6.4 DIAGRAMAS DE ACTIVIDADES
6.5 DISEÑO DE LA BASE DE DATOS
6.6 DISEÑO DE LA INTERFAZ

### CAPÍTULO 7. IMPLEMENTACIÓN DEL SISTEMA
7.1 ESTÁNDARES Y NORMAS SEGUIDOS
7.2 LENGUAJES DE PROGRAMACIÓN
7.3 HERRAMIENTAS Y PROGRAMAS USADOS
7.4 CREACIÓN DEL SISTEMA

### CAPÍTULO 8. MANUALES DEL SISTEMA
8.1 MANUAL DE INSTALACIÓN
8.2 MANUAL DE USUARIO

### CAPÍTULO 9. CONCLUSIONES Y AMPLIACIONES
9.1 CONCLUSIONES
9.2 AMPLIACIONES

### CAPÍTULO 10. APÉNDICES
10.1 GLOSARIO Y DICCIONARIO DE DATOS

---

## Capítulo 1. Memoria del proyecto

### 1.1 Resumen de la motivación
La idea de este proyecto surge de la necesidad de modernizar y simplificar los procesos de intermediación laboral. A menudo, las plataformas existentes son complejas, poco intuitivas o no ofrecen una experiencia unificada entre dispositivos móviles y web. La motivación principal ha sido crear una herramienta que elimine estas barreras, permitiendo a los candidatos encontrar empleo de manera más eficiente y a las empresas gestionar sus vacantes con mayor agilidad. Se ha buscado aplicar una arquitectura de software profesional que garantice la escalabilidad y el mantenimiento a largo plazo.

### 1.2 Objetivos
1.  Desarrollar una aplicación multiplataforma (Web/Móvil) funcional para la gestión de ofertas de empleo.
2.  Implementar un sistema de autenticación y autorización seguro para diferentes roles de usuario (Candidato y Empresa).
3.  Permitir a las empresas crear, editar y eliminar ofertas de trabajo, así como visualizar los candidatos inscritos.
4.  Permitir a los candidatos gestionar su perfil profesional y postularse a las ofertas disponibles.
5.  Asegurar la persistencia y consistencia de los datos mediante una base de datos relacional robusta.

---

## Capítulo 2. Introducción

### 2.1 Justificación del proyecto
En el mercado laboral actual, la agilidad es clave. Las empresas necesitan cubrir vacantes rápidamente y los candidatos buscan oportunidades que se ajusten a su perfil sin perder tiempo en procesos burocráticos. Este proyecto se justifica por su capacidad para centralizar estas interacciones en una plataforma tecnológica moderna, reduciendo tiempos de gestión y mejorando la experiencia de usuario mediante una interfaz limpia y reactiva. A diferencia de soluciones genéricas, este sistema se enfoca en la usabilidad y la eficiencia del flujo de reclutamiento.

### 2.2 Estudio de la situación actual
Existen numerosas plataformas de empleo (LinkedIn, InfoJobs, Indeed).
*   **LinkedIn**: Red social profesional. Muy completa pero a veces saturada de contenido social no relacionado con ofertas.
*   **InfoJobs**: Portal clásico de empleo. Funcional, pero con interfaces a veces anticuadas y procesos de registro largos.
*   **Indeed**: Agregador de ofertas. Gran volumen, pero menor control sobre la calidad de la oferta por parte de la empresa publicadora directa en ocasiones.

Nuestra propuesta busca cubrir el nicho de una gestión más directa y simplificada, eliminando el "ruido" de las redes sociales y centrando la experiencia puramente en la oferta y la demanda de empleo, con una tecnología más moderna y reactiva.

---

## Capítulo 3. Aspectos teóricos

### 3.1 Flutter
Framework de código abierto creado por Google para crear aplicaciones hermosas, compiladas nativamente y multiplataforma desde una única base de código. En este proyecto se usa para el Frontend, aprovechando su sistema de Widgets y el lenguaje Dart.

### 3.2 NestJS
Framework progresivo de Node.js para construir aplicaciones del lado del servidor eficientes y escalables. Utiliza TypeScript por defecto y se inspira en la arquitectura de Angular (módulos, controladores, servicios), lo que facilita la organización del código y la inyección de dependencias.

### 3.3 PostgreSQL
Sistema de gestión de bases de datos relacional de objetos de código abierto potente. Se utiliza para almacenar toda la información del sistema (usuarios, ofertas, aplicaciones) garantizando integridad ACID.

### 3.4 Clean Architecture
El proyecto sigue principios de arquitectura limpia, separando el código en capas (Presentación, Dominio, Datos) para asegurar que la lógica de negocio sea independiente de la interfaz de usuario y de los frameworks externos, facilitando las pruebas y el mantenimiento.

---

## Capítulo 4. Análisis

### 4.1 Definición del sistema
#### 4.1.1 Determinación del alcance del sistema
El sistema abarcará la gestión completa del ciclo de vida de una oferta de empleo básica: desde su creación por una empresa hasta la postulación de un candidato. No incluirá funcionalidades avanzadas como chat en tiempo real, videollamadas integradas o pruebas psicométricas en esta primera versión.

### 4.2 Catálogo de requisitos
#### 4.2.1 Requisitos funcionales
*   **RF 1**: Gestión de Usuarios (Registro e Inicio de Sesión).
*   **RF 2**: Gestión de Perfil de Empresa (Edición de datos, logo).
*   **RF 3**: Gestión de Perfil de Candidato (Edición de datos, CV).
*   **RF 4**: Gestión de Ofertas (Crear, Editar, Eliminar, Listar).
*   **RF 5**: Postulación a Ofertas (Candidatos aplican a ofertas).
*   **RF 6**: Visualización de Candidatos (Empresas ven quién aplicó).

#### 4.2.2 Requisitos no funcionales
*   **RNF 1**: Seguridad (Contraseñas encriptadas, JWT).
*   **RNF 2**: Disponibilidad (Servicio 24/7).
*   **RNF 3**: Escalabilidad (Capacidad de soportar múltiples usuarios concurrentes).

### 4.3 Identificación de actores del sistema
*   **Candidato**: Usuario que busca empleo.
*   **Empresa**: Usuario que oferta empleo.
*   **Administrador**: (Opcional) Gestiona el sistema globalmente.

### 4.4 Especificación de casos de uso
*   **CU-01 Registrarse**: El usuario crea una cuenta.
*   **CU-02 Iniciar Sesión**: El usuario accede al sistema.
*   **CU-03 Publicar Oferta**: La empresa crea una nueva vacante.
*   **CU-04 Aplicar a Oferta**: El candidato se inscribe en una vacante.

### 4.6 Guías de estilo
*   **Paleta de colores**: Colores corporativos sobrios (Azules, Blancos, Grises) para transmitir profesionalidad.
*   **Fuentes**: Tipografías Sans-Serif modernas (ej. Roboto, Open Sans) para legibilidad en pantalla.

---

## Capítulo 5. Plan de pruebas

### 5.2 Diseño y planificación
*   **Pruebas Unitarias**: Verificación de lógica de negocio en servicios de NestJS y repositorios.
*   **Pruebas de Integración**: Verificación de endpoints de la API (Controladores + Servicios + BD).
*   **Pruebas Funcionales**: Flujos completos de usuario (Registro -> Login -> Crear Oferta).

---

## Capítulo 6. Diseño del sistema

### 6.1 Arquitectura del sistema
Arquitectura de N-Capas.
*   **Frontend**: Capa de presentación (Flutter).
*   **Backend**: Capa de lógica de negocio y acceso a datos (NestJS).
*   **Base de Datos**: Capa de persistencia (PostgreSQL).

### 6.5 Diseño de la base de datos
#### 6.5.3 Diagrama E-R (Descripción)
*   **Tabla Users**: Almacena credenciales y rol.
*   **Tabla Companies**: Extiende Users, datos de empresa.
*   **Tabla Applicants**: Extiende Users, datos del candidato.
*   **Tabla JobOffers**: Ofertas publicadas, FK a Companies.
*   **Tabla Applications**: Relación N:M entre Applicants y JobOffers.

---

## Capítulo 7. Implementación del sistema

### 7.2 Lenguajes de programación
*   **Dart**: Versión 3.x (Frontend).
*   **TypeScript**: Versión 5.x (Backend).

### 7.3 Herramientas y programas usados
*   **Visual Studio Code**: IDE principal.
*   **Postman/Insomnia**: Pruebas de API.
*   **Docker**: Contenerización de la base de datos.
*   **Git**: Control de versiones.

---

## Capítulo 8. Manuales del sistema

### 8.1 Manual de instalación
1.  Clonar el repositorio.
2.  Backend: `npm install` -> Configurar `.env` -> `npm run start:dev`.
3.  Frontend: `flutter pub get` -> `flutter run`.

### 8.2 Manual de usuario
*   **Registro**: Acceder a la pantalla de registro, seleccionar rol y completar datos.
*   **Empresa**: Ir al dashboard, pulsar "+" para nueva oferta.
*   **Candidato**: Navegar por la lista de ofertas, pulsar en una y dar a "Aplicar".

---

## Capítulo 9. Conclusiones y ampliaciones

### 9.1 Conclusiones
Se ha logrado desarrollar un sistema funcional que cumple con los objetivos de conectar oferta y demanda laboral. La elección de Flutter y NestJS ha demostrado ser acertada para un desarrollo rápido y robusto.

### 9.2 Ampliaciones
*   Chat en tiempo real entre empresa y candidato.
*   Notificaciones Push.
*   Integración con LinkedIn para importar perfil.
*   Sistema de pagos para destacar ofertas.

---

## Capítulo 10. Apéndices

### 10.1 Glosario
*   **API**: Interfaz de Programación de Aplicaciones.
*   **JWT**: JSON Web Token, estándar para autenticación.
*   **Widget**: Elemento básico de construcción de interfaz en Flutter.
