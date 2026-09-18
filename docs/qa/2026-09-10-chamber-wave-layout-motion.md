# Cámara Neom: bordes y movimiento de Lissajous

## Solicitud y alcance

Corregir ondas que atraviesan los controles y revisar la apariencia estática de
los bordes/Lissajous. Cambios locales en los cuatro painters de `neom_generator`
y sus pruebas; no hay despliegue, cambio de audio, grabaciones, reglas o datos.

## Diagnóstico

- CircuitWave construía un único Path: al terminar un perímetro y comenzar un
  puente entre paneles, un `lineTo` dibujaba una diagonal por el interior. El
  orden de registro tampoco garantizaba que dos nodos fueran vecinos; podía
  conectar las columnas cruzando el contenido central. Faltaba respetar los
  límites de las columnas desplazables.
- Ambos bordes usaban `visualPhase` para calcular densidad. Al avanzar la fase
  crecían los ciclos hasta superar la resolución del muestreo y formar dientes
  de sierra. Fase de movimiento y densidad deben ser parámetros independientes.
- Lissajous 2D dividía ángulos envueltos L/R para obtener una supuesta relación
  de frecuencias. Esta división no representa los Hz. El 3D también podía
  introducir osciladores de demostración no presentes en la sesión.
- La comprobación visual de la primera corrección reveló otro artefacto 3D:
  unir puntos históricos calculados con distintas fases binaurales producía
  barras, no una sola curva. Se corrigió antes de dar por terminada la revisión.
- El congelamiento total no se reprodujo en el Chrome de esta comprobación:
  con 408 Hz y beat de 10 Hz, reproducción y píxeles sí avanzaron. No se alteró
  el reloj global ni se desactivaron las protecciones de segundo plano o la
  preferencia de movimiento reducido para intentar forzar un resultado.

## Cambios

- Contornos independientes y cerrados; conexiones solamente en espacios
  locales, cortos y libres de obstáculos. El interior de los paneles queda
  excluido de la pintura, incluyendo el resplandor.
- Recorte de cada nodo al viewport real de su columna y seguimiento del scroll.
- Ondas acotadas, con densidad estable ligada al tono, muestreo suficiente y
  esquinas continuas; su fase temporal desplaza la onda sin aumentar sus ciclos.
- Lissajous usa Hz L/R y diferencia de fase de la telemetría de Cámara. Un punto
  recorre la curva a velocidad visual legible; no reconstruye una frecuencia
  ni simula una medición cerebral. Si L y R son iguales, una línea/elipse
  estable es un resultado válido, no un fallo que deba deformarse.
- La estela 3D conserva su posición de barrido, antigüedad y respiración real,
  pero se reproyecta completa con los Hz y la fase del fotograma actual. No
  conecta geometrías de momentos diferentes; al detener, se congela.
- No se añadieron dependencias de Firebase ni cambios de síntesis. Otros
  consumidores de `neom_generator` recibirán el cambio al recompilar, no antes.

## Validación

Directorio temporal de pruebas de navegador:
`/tmp/cyberneom-wave-motion.HoEpuu`.

El script `probe.cjs` recorre la UI real, configura 408 Hz + 10 Hz, inicia,
captura dos frames separados por 1,5 segundos, compara regiones y detiene la
sesión. Chrome usa un perfil nuevo, salida silenciada y ninguna credencial de
usuario; no se abre el micrófono ni se publica una sesión.

Pruebas integradas: **625 aprobadas** (`neom_generator/test`,
`neom_experiences/test` y `Cyberneom/test`, con concurrencia 2). Incluyen 20
regresiones nuevas de geometría, recorte, píxeles y movimiento de Lissajous.
El análisis focal de los cuatro painters y ambos archivos de pruebas terminó
sin incidencias. Log: `integrated-tests-final.log` en el directorio temporal de QA.

Comando reproducible desde `Cyberneom`:

```sh
flutter test --no-pub --concurrency=2 ../neom_modules/neom/neom_generator/test ../neom_modules/neom/neom_experiences/test test
```

Build web release final completado en 140,2 s:
`flutter build web --release --no-pub --no-wasm-dry-run`.
SHA-256 de `build/web/main.dart.js`:
`7a5eb15597d6072fbf66157529d58a7b8424e9b191ce25089673062445283281`.

Chrome local, 1440 × 1000, 408 Hz + beat de 10 Hz:

- Revisión visual de `final-beat10-frame0.png` y `final-beat10-frame1.png`:
  contornos estrechos y suaves, sin diagonales por los controles; figura 3D
  coherente, sin la cortina de barras detectada en la primera iteración.
- Entre capturas cambiaron 4627 píxeles de la región Lissajous 2D, 1711 del 3D
  y 2236 del perímetro central. Las cifras verifican movimiento, no tasa de FPS.
- El tiempo de sesión avanzó hasta 00:03; se verificaron Inicio y Detener.
  Ninguna excepción JavaScript durante este recorrido.
- Log: `chrome-final.log`; servidor temporal en
  `http://127.0.0.1:7362/generator`, con caché desactivada y archivos sensibles
  bloqueados. No se ejecutó despliegue: este artefacto sigue siendo local.

Esta revisión no equivale a pruebas físicas de iOS/Android o Safari.
