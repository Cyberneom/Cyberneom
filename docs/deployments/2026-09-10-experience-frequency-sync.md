# Cyberneom — experiencias sincronizadas, publicación web

- Solicitud: publicar en producción la versión local validada de Cámara Neom y sus experiencias.
- Publicación: 2026-09-10 21:10:44 UTC (15:10:44, Ciudad de México).
- Destino: https://cyberneom.xyz y https://cyberneom-edd2d.web.app.
- Proyecto/sitio Firebase: `cyberneom-edd2d`, canal `live`.
- Versión Hosting: `13364b78a3cca0a4`.
- Versión anterior conservada en Hosting: `367b790b2d9e6674`.
- Comando: `firebase deploy --only hosting --project cyberneom-edd2d --non-interactive`.
- Alcance: solo Hosting. No se desplegaron Functions, reglas o índices, ni se modificaron Auth, datos, facturación u otras apps.

## Artefacto y configuración

Se reutilizó exactamente el build release validado en la iteración anterior.
La revisión de fechas no encontró fuentes más recientes en `lib`, `web` o las
librerías locales `neom_*`/`sint`; no se ejecutó `pub get` ni se actualizaron dependencias.

SHA-256 de `build/web/main.dart.js`:
`35084c727c06f1ac4613ad175a71aca3d3eef96d351ccc9da7eca9ea51d37e33`.

Se corrigió un desvío de Hosting: `/generator` apuntaba a `generator.html`,
una implementación JavaScript independiente que no contiene estas experiencias.
Ahora apunta a `index.html` para cargar la ruta Flutter probada. Se conserva
`/generator.html` para acceso explícito al generador HTML anterior. No se
modificaron los demás rewrites. Dos pruebas nuevas de configuración pasaron:
entrada Flutter directa y conservación de exclusiones de credenciales/maps.

## Verificación posterior

En ambos dominios:

- `/main.dart.js`: HTTP 200 y SHA-256 idéntico al artefacto local.
- `/generator` y `/neomatics/fullscreen`: HTTP 200 y hash idéntico a
  `build/web/index.html` (`156e426495598736d1ad2dee17d2e8ae0b9dadcd5393d8729529b986cb48409b`).
- La comprobación HEAD del antiguo path sensible devolvió fallback `text/html`,
  no JSON. Las exclusiones de Hosting permanecieron activas; no se leyeron
  contenidos de credenciales ni se eliminaron archivos locales.
- Firebase confirmó la nueva versión `FINALIZED` en el canal live y el rewrite
  `/generator` → `/index.html`.

Los scripts conservan `no-cache, max-age=0, must-revalidate`. Las rutas sin
extensión responden con el valor preexistente `max-age=3600`; si un navegador
conserva el generador HTML anterior, debe recargarse ignorando caché.

## Límites y pendientes que no cambia esta publicación

- Las 723 pruebas integradas y el build release constan en
  [el registro de QA](../qa/2026-09-09-experience-frequency-sync.md).
- No se repitió la suite completa durante este deploy; se verificó identidad
  del artefacto y se ejecutaron las dos pruebas nuevas de Hosting.
- Sigue pendiente la validación de audio continuo en dispositivos físicos. La
  limitación de reloj Web Audio del Chrome automatizado está documentada en QA.
- Los protocolos de `neom_states` siguen siendo un flujo separado pendiente.
- Firebase repitió el aviso previo: no encuentra un endpoint válido para
  `stateOgMeta`. Se conservó su rewrite y no se desplegó esa Function.

No se creó commit ni se hizo push en esta operación.
