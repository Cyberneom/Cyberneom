# Cyberneom: despliegue web de Cámara Neom y notas de práctica

- Solicitud: publicar en web la versión local validada en el turno anterior.
- Publicado: 2026-09-09 19:11:57, America/Mexico_City (2026-09-10 01:11:57 UTC).
- Destino: https://cyberneom.xyz, Firebase Hosting `cyberneom-edd2d`, canal live.
- Versión publicada: `367b790b2d9e6674`.
- Versión anterior, disponible en historial: `429ce1e4ffe2784c`.
- Alcance: solo Hosting. No se desplegaron reglas, índices, Functions, configuraciones de Auth, ni cambios de datos o de otras aplicaciones.
- No se hizo commit ni push; se publicaron los cambios locales previamente validados.

## Artefacto y comprobaciones

Se reutilizó la compilación release final validada (Flutter 3.44.8 / Dart 3.12.2, `--release --no-pub --no-wasm-dry-run`), con 580 pruebas integradas aprobadas en el turno anterior. Se confirmó que ninguna fuente Dart/pubspec de Cyberneom o sus 61 módulos locales, ni los archivos de `web/`, era posterior a la compilación.

El despliegue terminó correctamente con `firebase deploy --only hosting --project cyberneom-edd2d --non-interactive`: 1002 archivos en Hosting, 490 nuevos subidos.

Los siete recursos siguientes devolvieron HTTP 200 desde el dominio público, con el mismo SHA-256 que el artefacto local y `Cache-Control: no-cache, max-age=0, must-revalidate`:

| Recurso | SHA-256 |
| --- | --- |
| `main.dart.js` | `0dede6c69c6470080accc357fb43f9d6bf7841b8181b0737438130d061aab8e0` |
| `flutter_bootstrap.js` | `2b6c3f6f67aafab94c87ba8e7a18e96c34809cd6eddf966b206fd5a4298f77fa` |
| `index.html` | `156e426495598736d1ad2dee17d2e8ae0b9dadcd5393d8729529b986cb48409b` |
| `generator.html` | `4f468e452e909035daa824b2b6e24bfada0567fe3d418c7cffb4433f9457d2ab` |
| `main.dart.js_429.part.js` (Cámara) | `feae8dbd03c948f78118dfae45ff13e04421615bd691e4e56713489ece327401` |
| `main.dart.js_149.part.js` (blog) | `c84c4891f53f62fa897befe1bc7a57582ac5442ad1fbbe42856e42ea0609264e` |
| `main.dart.js_150.part.js` (blog) | `a09f59e1421941ca26d8ad26e1324b71c2abe9f41ab597ec395e5e456297636f` |

Se conservaron las exclusiones de service accounts, llaves, archivos de entorno y source maps. La comprobación HEAD de la ruta del service account devolvió el fallback HTML, no un archivo JSON; no se abrió su contenido. El control local de patrones sensibles de la configuración pública no reportó coincidencias y no imprimió valores.

## Contenido y límites

Incluye las herramientas de práctica, temporizador de audio, favoritos/recientes locales, entrada/salida suaves, comprobación L/R, referencias a Incienso por ID y borradores de notas en `neom_blog`. Los parámetros/audio no se copian al blog ni a los archivos de referencia. El historial detallado está en `neom_generator/docs/2026-09-09-chamber-practice-features.md`.

Persisten dos avisos previos: fuente CupertinoIcons no incluida y rewrite `stateOgMeta` sin endpoint válido. No bloquean este despliegue; no se intentó corregirlos aquí.

Esta verificación confirma el despliegue y los archivos servidos, no un recorrido autenticado completo de publicar → feed → abrir Incienso. No se crearon notas, cuentas ni otros datos para probar producción. Las pruebas de dispositivos físicos y las incidencias previas de medios/Storage siguen siendo validaciones separadas.
