# Cyberneom: validación de SintApp (2026-09-12)

> Registro histórico. La implementación y las compilaciones se revisaron de
> nuevo el [21 de septiembre de 2026](2026-09-21-sint-app-compilation.md).

## Alcance

Se migra la configuración de `MyApp` de `SintMaterialApp` a `SintApp` utilizando
`material_ui.ThemeData`, `material_ui.TimePickerThemeData` y
`cupertino_ui.CupertinoThemeData`. Los delegates Material/Cupertino pertenecen a
las bibliotecas standalone. Se mantienen los bindings, las rutas, el overlay
SAIA y la composición con `SentinelApp`.

El bootstrap de Firebase, anuncios y audio de producción no se ejecuta como parte
de esta validación. Una compilación completa comprueba que ese código compila;
no certifica su comportamiento conectado a los servicios.

Se conservan los cambios locales previos del proyecto. Las dependencias se
resuelven contra el checkout local de SINT mediante `pubspec_overrides.yaml`.

## Herramientas

- Flutter `3.48.0-1.0.pre-228`, master, revisión `dd7b7f7c96`.
- Dart `3.14.0-134.0.dev`.
- macOS `26.6.2`, Apple Silicon.
- Android SDK: plataforma 36, Build Tools 36.1.0, NDK 27.0.12077973.
- JDK de Android Studio: 21.0.8.
- Emulador disponible: `Medium_Phone_API_36.1`.
- Dependencias standalone: `material_ui 1.2.0`, `cupertino_ui 1.0.2`.

El mínimo declarado de la aplicación pasa a Flutter 3.44 / Dart 3.12 por los
requisitos de los nuevos paquetes. Esta sesión utiliza un SDK de desarrollo;
no certifica por sí sola la versión estable mínima.

## Resultados

La resolución de dependencias (`flutter pub get`) terminó correctamente.
Las compilaciones Android y web quedan pendientes de la integración del host
`SintApp`. Los logs se guardan en `build/sint-app-qa/` (directorio ignorado).

El target macOS corresponde a Giglab según la aclaración de alcance. No se
incorpora un runner macOS a Cyberneom.
