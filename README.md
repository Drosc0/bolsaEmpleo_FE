
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

## Buenas prácticas
- Usa Riverpod o Provider para gestión de estado.
- Implementa validaciones en formularios.
- Maneja errores y estados de carga en las pantallas.

## Próximos pasos

- Añadir internacionalización (i18n) para soportar múltiples idiomas.
- Implementar notificaciones push para avisar a candidatos y empresas sobre nuevas ofertas o cambios en aplicaciones.
- Mejorar el diseño utilizando Material 3 y adaptarlo a diferentes tamaños de pantalla.
- Integrar pruebas unitarias y de integración para asegurar la calidad del código.
- Configurar CI/CD para despliegue automático en entornos de desarrollo y producción.
- Añadir soporte para autenticación social (Google, LinkedIn) mediante Supabase.
- Optimizar el rendimiento y reducir tiempos de carga en dispositivos móviles.
