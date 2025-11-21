
# Bolsa de Empleo - Frontend (Flutter)

Este proyecto es el frontend de una aplicación de bolsa de empleo desarrollada en Flutter. Se conecta con un backend en NestJS y utiliza Supabase para autenticación y base de datos.

## Descripción del modelo de datos

El sistema maneja dos tipos de usuarios: **Candidatos** y **Empresas**. Además, incluye entidades para **Ofertas de empleo** y **Aplicaciones**.

### Usuario
- `id`: Identificador único.
- `nombre`: Nombre completo.
- `email`: Correo electrónico.
- `password`: Contraseña (en Supabase).
- `rol`: Puede ser `candidato` o `empresa`.
- `perfil`: Información adicional (CV, descripción, etc.).

### Oferta de empleo
- `id`: Identificador único.
- `titulo`: Título del puesto.
- `descripcion`: Detalles del trabajo.
- `empresa_id`: Referencia al usuario con rol empresa.
- `ubicacion`: Ciudad o remoto.
- `salario`: Rango salarial.
- `fecha_publicacion`: Fecha en que se creó la oferta.

### Aplicación
- `id`: Identificador único.
- `candidato_id`: Referencia al usuario con rol candidato.
- `oferta_id`: Referencia a la oferta de empleo.
- `estado`: Puede ser `pendiente`, `aceptado` o `rechazado`.
- `fecha_aplicacion`: Fecha en que se realizó la aplicación.

## Instalación y configuración


### Buenas prácticas
- Usa Riverpod o Provider para gestión de estado.
- Implementa validaciones en formularios.
- Maneja errores y estados de carga en las pantallas.

