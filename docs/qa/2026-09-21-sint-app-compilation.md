# Cyberneom: revalidación de SintApp (2026-09-21)

## Estado verificado

`lib/main.dart` ya utiliza `SintApp`, `materialTheme`, `cupertinoTheme` y los
delegates de los paquetes standalone. SINT se resuelve desde el checkout local
`../neom_modules/framework/sint`, versión `1.7.0-dev.1`.

La compilación web release terminó correctamente después de corregir una
dependencia de cámara. Esta validación compila la aplicación completa; no ejecuta
el bootstrap ni verifica conexiones Firebase, navegación o servicios en runtime.

| Comprobación | SDK | Resultado |
| --- | --- | --- |
| Web release inicial | Flutter 3.48.0-1.0.pre-228 / Dart 3.14.0-134.0.dev | Falló por dos anotaciones `@JS` inválidas en `camera_web 0.3.5+4`. |
| Web release después de actualizar `camera_web` | Mismo SDK | Correcta, exit 0, 176.2 segundos. |
| Android debug inicial | Mismo SDK | Bloqueado antes de compilar Dart: Gradle 8.11.1 es menor que el mínimo 8.14.0 de este Flutter prerelease. |

El intento Android anterior no demuestra un error de SINT. La validación Android
con Flutter estable se documenta por separado al completar el build.

## Corrección de la dependencia web

Se ejecutó primero `flutter pub upgrade camera_web --dry-run` y luego la misma
actualización focal sin `--dry-run`. `camera_web` pasó de `0.3.5+4` a `0.3.5+6`;
el changelog de `0.3.5+5` identifica la eliminación de las anotaciones `@JS`
inválidas en constructores de extension types.

La resolución también ajustó cinco dependencias a los requisitos del SDK instalado:
`intl 0.20.3`, `matcher 0.12.20`, `meta 1.19.0`, `test_api 0.7.12` y
`vector_math 2.4.3`. El lockfile refrescó las versiones declaradas por módulos
locales que ya estaban referenciados mediante `path`; no se modificó su código.
Una resolución posterior con otro SDK puede volver a ajustar sus dependencias
fijadas: los logs conservan las versiones usadas por esta compilación web.

No se modificó `pubspec.yaml`, el SDK global ni la caché de paquetes manualmente.

## Reproducción y evidencia

Comando web exitoso:

```sh
flutter build web --release --no-pub --no-wasm-dry-run
```

Se utilizó `/opt/homebrew/bin/flutter`. `--no-wasm-dry-run` omite únicamente el
diagnóstico previo de Wasm; este resultado certifica compilación JavaScript.

Los logs y códigos de salida están en `build/sint-app-qa/2026-09-21/`:

- `web-release.log` y `web-release.exit`: error original.
- `camera-web-upgrade-dry-run.log` y `camera-web-upgrade.log`: resolución focal.
- `web-release-camera-fixed.log` y `web-release-camera-fixed.exit`: build exitoso.
- `android-debug.log` y `android-debug.exit`: bloqueo original de Gradle.

El artefacto `build/web/main.dart.js` se generó el 21 de septiembre, con tamaño
10,914,494 bytes y SHA-256
`661cf6b2de4bef7a748692013eb7c81f23fae1ba43f21ffb8ed350852f52459a`.

## Límites y pendientes

- El compilador advierte que falta la fuente `packages/cupertino_icons/CupertinoIcons`.
  No impide generar web, pero requiere revisar los iconos en una prueba visual.
- No se arrancó ni desplegó la aplicación. Compilar no certifica el comportamiento
  de temas, overlays, rutas o servicios conectados.
- No se compiló Wasm en la corrida final ni se probó un dispositivo iOS.
- El target macOS de esta validación corresponde a Giglab.

## Auditoría de la evidencia anterior

Los logs del 12 de septiembre no acreditaban las compilaciones: Android estaba
vacío, web sólo indicaba que comenzaba a compilar y el análisis no tenía resultado
final. Sí había artefactos web del 13 de septiembre, anteriores al código actual;
no se utilizaron para declarar exitoso el build del 21 de septiembre.

Se preservaron los cambios locales existentes en `lib/eeg/`, `lib/root_binding.dart`
y su prueba asociada.
