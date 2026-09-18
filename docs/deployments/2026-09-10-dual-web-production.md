# Cyberneom — despliegue web junto con Gigmeout

## Publicación

- Fecha local: 10 de septiembre de 2026, 20:09:17 (Ciudad de México).
- Fecha UTC: `2026-09-11T02:09:17.921Z`.
- Proyecto/sitio Firebase: `cyberneom-edd2d`, canal `live`.
- Dominios: https://cyberneom.xyz y https://cyberneom-edd2d.web.app.
- Versión de la app: `3.0.1+28`.
- Versión Hosting nueva: `db366ef3e4e24030`, estado `FINALIZED`.
- Versión Hosting anterior: `13364b78a3cca0a4`, conservada en el historial.
- Base Git: `22aa5cd2`, más los cambios locales existentes de app y módulos.

Se publicó exclusivamente Hosting usando el `firebase.json` raíz. No se
desplegaron reglas, índices, Functions, aplicaciones móviles ni EMXI, ni se
realizaron migraciones de datos. No se hizo commit, push o actualización de
dependencias. Se preservaron los cambios locales existentes.

## Contenido y compilación

Se incluyen voz con autoarranque, controles compactos, osciloscopio en la
primera vista de escritorio, experiencias sincronizadas y los cambios actuales
de módulos compartidos. El comportamiento de voz y sus límites de validación
se describen en [el registro de QA](../qa/2026-09-10-chamber-compact-voice.md).

SDK: Flutter `3.44.8` estable, Dart `3.12.2`, desde
`/Users/serzen/src/flutter`, correspondiente a esta app.

```sh
/Users/serzen/src/flutter/bin/flutter build web --release --no-pub --no-wasm-dry-run
firebase deploy --only hosting --project cyberneom-edd2d --config firebase.json --non-interactive
```

- 190 pruebas de Cyberneom, releases y modelos/utilidades compartidos aprobadas.
- 6 pruebas de consultas aprobadas desde `neom_core`, con sus dependencias de
  desarrollo. Las 33 pruebas propias de Gigmeout también pasaron.
- Se reconstruyó la app; no se reutilizó el artefacto anterior a los últimos
  cambios compartidos. Huella estable de 2.664 archivos fuente antes/después:
  `053621ce15fe9694b349c880cc90983be2f110dfb2036ff59d6e875826d1d350`.
- Las 667 pruebas de Cámara/experiencias documentadas en QA son evidencia de
  la iteración anterior; no se repitió esa suite completa en este despliegue.

SHA-256 de `build/web/main.dart.js`:
`1e5f063781971148ac3f15c56ad71d6b227da0a023f9cdd294cb7368b247b499`.

## Verificación en producción

- Ambos dominios sirven el JavaScript exacto del build, HTTP 200.
- `/`, `/generator` y `/neomatics/fullscreen` devuelven el `index.html` Flutter
  esperado. Se conserva `/generator` → `/index.html`.
- Chrome aislado mostró portadas y publicaciones en Inicio. No aparecen
  Libros ni Levitación en su navegación principal.
- Cámara Neom verificada a 1440×900 y 390×844: voz arriba, controles compactos
  y osciloscopio visible en la primera pantalla. Sin excepciones JavaScript
  en esas páginas ni en Inicio durante el recorrido.
- No se capturó micrófono real ni se probó audio en un smartphone físico.
- Las comprobaciones HEAD de paths de credenciales y mapas devuelven fallback
  HTML, no esos archivos. Se conservan las exclusiones de Hosting.
- El conjunto de verificaciones HTTP de ambas apps pasó sus 22 comprobaciones.

## Pendientes que no cambia esta publicación

- Firebase repitió el aviso previo de endpoint no disponible para
  `stateOgMeta`; se preservó su rewrite y no se desplegó esa Function.
- Dos solicitudes de medios a Storage fallaron en el recorrido de Inicio;
  no impidieron que cargaran las publicaciones y portadas observadas.
- El despliegue exitoso no certifica todos los flujos ni sustituye la prueba
  física de audio/micrófono en iOS y Android.

Evidencias temporales de esta operación: `/tmp/neom-dual-web-deploy.dgLztc`
(logs, hashes, comprobaciones HTTP y capturas de Chrome).
