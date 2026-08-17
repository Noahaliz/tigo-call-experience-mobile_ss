# Tigo Call Experience Mobile

Aplicación móvil académica desarrollada con Flutter y Dart.

## Objetivo

Centralizar una experiencia inicial de capacitación para asesores de Call Center mediante:
- Capacitación
- Consulta de procedimientos
- Simulaciones
- Evaluaciones
- Seguimiento de progreso

## Estado actual

Actividad Académica N.º 2: estructura inicial de la aplicación.

Actualmente incluye:
- Tema visual personalizado
- Splash Screen
- Inicio de sesión
- Registro
- Dashboard
- Navegación inicial
- Pantallas base para módulos
- Organización de carpetas

## Tecnologías

- Flutter
- Dart
- Android Studio
- Visual Studio Code
- Git
- GitHub
- Supabase (previsto para futuras etapas)
- PostgreSQL (previsto para futuras etapas)

## Estructura

```text
lib/
├── core/
│   ├── routes/
│   │   └── app_routes.dart
│   └── theme/
│       └── app_theme.dart
├── models/
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── training_screen.dart
│   ├── procedures_screen.dart
│   ├── simulations_screen.dart
│   └── evaluations_screen.dart
├── services/
├── widgets/
│   ├── primary_button.dart
│   └── module_card.dart
└── main.dart
```

## Ejecución

```bash
flutter pub get
flutter run
```

## Nota

Esta versión corresponde a la estructura técnica inicial del proyecto.
No incluye todavía conexión a base de datos ni autenticación real.
