# Experiencias visuales y conjunto de frecuencias — 2026-09-09

## Alcance y estado

Trabajo local sobre las cinco experiencias visuales de Cámara Neom: NeuroFlocking,
Neuro Respiración, Fractales, Neomatics y NeuroMandala. No se han desplegado
Hosting, reglas, Functions ni cambios de datos de Firebase en esta iteración.
Los protocolos de `neom_states` son otro flujo: no confundir su reproductor con
estas cinco experiencias.

Actualización posterior: esta versión fue publicada por solicitud del usuario
el 2026-09-10; véase el [registro de deployment](../deployments/2026-09-10-experience-frequency-sync.md).

## Problema confirmado

- Flocking convertía fase visual en frecuencia y fase binaural en Hz.
- Neomatics usaba `waveStretch * 300`; Mandala usaba `waveStretch * 80` y,
  sin fuente, inventaba una frecuencia y una coherencia con senos temporales.
- El contrato visual anterior no exponía L/R/sub, estado de reproducción ni
  nivel PCM. Cada experiencia resolvía una referencia solo al inicializarse.
- Cámara ofrecía solo tres de las cinco experiencias en su catálogo general.

## Fuente de verdad y compatibilidad

`neom_core` añade el contrato opcional `NeomAudioSessionSignal` y el snapshot
inmutable `NeomAudioSessionSnapshot`. El contrato anterior permanece válido.
`neom_generator` obtiene la telemetría de la síntesis existente:

- Frecuencias L/R/sub a partir de los incrementos de los osciladores, después
  de FM, ajuste espacial de tono y límite Nyquist. En PM se reportan las
  frecuencias portadoras, no una estimación espectral de sus bandas laterales.
- Nivel RMS del PCM estéreo final y ganancia real de mezcla del subgrave.
- Respiración, relación de fase L/R y posición del reloj de salida.
- Se selecciona el bloque que corresponde al playhead, no un bloque futuro
  que ya se generó pero aún no se escucha.

Resolución: un bloque de 1024/44100 s, aproximadamente 23,2 ms. Los Hz son
promedios por bloque; la interpolación de fase con FM y la envolvente de
respiración tienen esa resolución, no precisión óptica muestra a muestra.
El backend nativo puede tener latencia de hardware no expuesta por su API.

La telemetría no cambia PCM, grabación ni replay del incienso. No abre micrófono,
no inicia otro motor, no modifica volumen y no genera escrituras en Firestore.
No se notifican widgets por cada muestra: las experiencias mantienen su reloj
visual con suspensión por visibilidad/lifecycle. Start/Stop sí notifican al
panel de estado aunque la animación esté pausada.

## Mapeo visual (artístico, no medición cerebral)

| Experiencia | Relación con la sesión |
| --- | --- |
| NeuroFlocking | L/R/sub influyen por separado en separación, alineación y cohesión; fase L/R y nivel influyen en movimiento. El atractor táctil sigue disponible. |
| Neuro Respiración | Usa la envolvente respiratoria de Cámara cuando está activa; L/R/sub influyen en radio, color y halo. Sin respiración de audio, conserva guía manual. |
| Fractales | L/R desplazan suavemente ejes independientes y sub influye en zoom; conserva desplazamiento/zoom manual. |
| Neomatics | Superposición visual de patrones para L/R/sub; conserva selección manual de modo y placa. No es una simulación física calibrada de una placa real. |
| NeuroMandala | Capas asociadas a L/R/sub, crecimiento por envolvente respiratoria o intervalo artístico basado en el playhead; controles manuales conservados. |

El panel distingue reproduciendo, detenido, demo sin conexión y señal visual
legacy sin telemetría. Expone Hz, diferencia L/R, RMS, respiración y tiempo de
audio. Los controles visuales no cambian el sonido. La relación de fases no es
EEG ni coherencia hemisférica medida; RMS no mide volumen físico de audífonos.

## Archivos/módulos afectados en esta iteración

- `neom_core`: contrato opcional, compatible con productores antiguos.
- `neom_generator`: telemetría de salida, limpieza de referencia al cerrar,
  reset de pulso con beat cero, cinco accesos en Cámara/catálogo.
- `neom_experiences`: conexión dinámica, mapeos, panel explicativo y traducciones,
  pantallas responsivas, pruebas de sincronización y ciclo de vida.
- `Cyberneom`: carga de traducciones del módulo y este registro de QA.

EMXI/Gigmeout no fueron desplegadas. Usarán estos cambios compartidos solo si
se recompilan con estos módulos. No se añadieron llamadas a Firestore, ni reglas
especiales por app, ni una nueva dependencia generator→experiences.

## Validación

Suite integrada: **723 pruebas aprobadas** (generator, experiences, states,
home, blog y tests de Cyberneom), concurrencia 2. Log local:
`/tmp/cyberneom-experiences-qa.JKBmu4/integrated-tests-final.log`.
Incluye la regresión que garantiza que renderizar PCM offline no consulta un
backend de audio. Análisis focal sin errores; dos warnings de variables sin uso
y avisos legacy de importaciones/Color permanecen fuera del cambio funcional.

Pruebas automatizadas cubren PCM RMS, L/R/sub, FM/ajuste espacial, silencio,
Start/Stop/reinicio, desacoplamiento, cambio de parámetros en cola, registro
tardío/reemplazo, interpretación independiente de las tres frecuencias, controles
manuales, historial de reproducción exacta y lifecycle de animación.

La prueba de páginas monta las cinco experiencias reales en 320×568, 568×320 y
1440×900; los tests de HUD cubren texto ampliado. La validación de layouts no
equivale a una prueba física en iPhone/Android, Safari o auriculares.

También se corrigen el desbordamiento de los controles de Flocking en horizontal,
las métricas de Mandala en ancho reducido y el zoom acumulativo del gesto de
Fractales. El panel extendido tiene scroll y deja acceso a los controles.

### Web real y artefacto

- `flutter build web --release --no-pub --no-wasm-dry-run`: correcto (83,2 s).
- SHA256 final de `build/web/main.dart.js`:
  `35084c727c06f1ac4613ad175a71aca3d3eef96d351ccc9da7eca9ea51d37e33`.
- Chrome con build release local: las cinco rutas abrieron la experiencia
  correspondiente y mostraron `Conectado · detenido`, sin errores JavaScript
  de ejecución. Capturas y log en
  `/tmp/cyberneom-experiences-qa.JKBmu4/release-chrome-final.log`.
- Se completaron además seis etiquetas legacy de Mandala en cuatro idiomas;
  una prueba adicional verifica su presencia y valores legibles.
- Recorrido release en Chrome: iniciar Cámara → catálogo → Neomatics → abrir
  panel → volver a Cámara → detener → volver a Neomatics. El panel pasó de
  `Conectado · reproduciendo` a `Conectado · detenido`, mostró L/R de 345,0 Hz
  y no hubo excepciones JavaScript. No se cuenta como validación de reproducción
  sostenida: el AudioContext del navegador de QA no avanzó más de 0,00533 s.
- Se aisló esa limitación fuera de Flutter con una página mínima: oscilador
  Web Audio conectado mediante ganancia cero y activado por clic real. Tanto
  con Chrome silenciado como sin `--mute-audio`, después de 1,5 s el contexto
  informó `state=running`, `sampleRate=48000`, `currentTime=0.005333333333333333`.
  Scripts reproducibles: `live-sync.cjs` y `audio-environment.cjs` en el directorio
  temporal de QA. Se requiere validar audio continuo en un navegador/dispositivo
  cuya salida de audio esté funcionando; no se sustituyó su reloj por tiempo
  de pared ni se alteró el motor para hacer pasar esta comprobación.
- El runner `flutter test --platform chrome` (DDC) no llegó a ejecutar tests:
  falló la carga de `sint/translation/.../locale_extension.dart.js` al acceder
  a `intl_host`. No se cuenta ese intento como una prueba aprobada. La
  comprobación anterior se realizó sobre la compilación release, que sí abrió.
- Permanece la advertencia previa de fuente `CupertinoIcons` durante el build.

El servidor de QA usa solo loopback y no publica en Firebase Hosting.

## Hallazgo separado pendiente

En `neom_states`, `StateExperienceController.begin()` inicia su otro reproductor
con volumen 0 y `_fadeIn()` solo espera, sin modificar el volumen; `togglePause()`
pausa el contador pero no el audio/los temporizadores de fases. Este flujo de
protocolos necesita una corrección e integración aparte antes de afirmar que
todas las funciones denominadas “Estados” usan la misma Cámara Neom.
