# Cámara Neom: voz con autoarranque e interfaz compacta

## Alcance

Cambios locales en `neom_generator`: voz, páginas web/móvil y controles
compartidos. No hay despliegue ni cambios de reglas o datos de Firebase.
Otros consumidores del módulo reciben los cambios cuando recompilen.

## Voz

El cierre de la detección antes solo actualizaba la frecuencia; ahora una
medición válida al finalizar los tres segundos libera el micrófono y comienza
la práctica. Se restablecen la octava Base y un solo oscilador principal, y se
separa cualquier Incienso cargado para que no sustituya la nueva frecuencia.
Se conservan volumen, beat y efectos.

Web prepara la salida silenciosamente durante el clic explícito de detección;
esto permite iniciar audio cuando termina el análisis asíncrono. La preparación
no genera PCM. Cancelar, detener, cerrar, permisos fallidos o una frecuencia
inválida no deben activar el audio. No se cambió el algoritmo de síntesis.

## Interfaz

- Voz en la parte superior y reloj compacto.
- Valores de Hz editables directamente, con botones ± de al menos 48 px.
- Octavas en un selector que conserva las nueve opciones.
- Dial acotado por el espacio disponible, con reproducción accesible.
- Web: osciloscopio inmediatamente después de los controles principales, antes
  de octavas y herramientas secundarias.
- Móvil: osciloscopio abierto antes de experiencias; experiencias agrupadas en
  una sección plegable, con dos columnas cuando hay espacio.
- Texto ampliado puede reorganizar y desplazar el contenido sin recortarlo.
- Play/Stop móvil escucha directamente el estado reactivo dentro del dial;
  ya no depende de modificar otro control para actualizar el icono.

## Comprobación

Directorio temporal de QA: `/tmp/cyberneom-compact-voice.USs3ru`.
La prueba de navegador usa una onda sintética de 178 Hz como micrófono ficticio,
salida silenciada y un perfil aislado; no captura voz del usuario ni guarda
una grabación personal. No se altera la política de autoplay de Chrome.

Pruebas integradas: **667 aprobadas**, incluidas 42 nuevas. Comando desde
`Cyberneom`:

```sh
flutter test --no-pub --concurrency=2 ../neom_modules/neom/neom_generator/test ../neom_modules/neom/neom_experiences/test test
```

Cobertura añadida: autoarranque y cancelaciones, preparación silenciosa del
backend, botones compactos, octavas, primera vista web (1440×900, 1366×768 y
1280×720), layout móvil (320, 360, 390, 430 y 768 px; escalas de texto 1 y 2).
Análisis de los seis archivos fuente y seis archivos de pruebas sin incidencias.
Logs: `integrated-tests.log` en el directorio de QA.

Build release exitoso en 90,3 s:
`flutter build web --release --no-pub --no-wasm-dry-run`.
SHA-256 de `build/web/main.dart.js`:
`8dc1dc8938efeb2f673e98a44cd2b431dabb8062378e30d5ccb37f76cd21362c`.

Chrome con el build final:

- 1440×900 y 390×844: clic de detección mediante entrada real de puntero;
  micrófono ficticio de 178 Hz; al terminar aparece Detener Frecuencia sin
  pulsar Play, raíz 178 Hz, octava Base y osciloscopio activo. El reloj avanza
  y Stop vuelve al estado Iniciar Frecuencia.
- 1280×720: osciloscopio completo dentro de la primera pantalla. 320×740:
  voz visible arriba, frecuencias reorganizadas y osciloscopio abierto, con
  opciones secundarias debajo.
- Ninguna excepción JavaScript en estos recorridos. Capturas revisadas:
  `desktop-voice-playing.png`, `laptop-initial.png`,
  `mobile-voice-playing.png`, `small-mobile-initial.png`.
- Log: `browser-qa.log`; script: `browser-qa.cjs`. El primer intento de
  automatización tuvo una intercepción de hit-test por la capa semántica de
  Flutter; se repitió con clic real de puntero omitiendo únicamente esa
  comprobación de Playwright, sin dispatch sintético ni políticas de autoplay
  permisivas.

Disponible localmente en `http://127.0.0.1:7362/generator`. Sin deploy.

La validación móvil de layout no sustituye una prueba física de micrófono y
audio en iOS/Android; esa comprobación sigue pendiente.
