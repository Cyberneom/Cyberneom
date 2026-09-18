# Voz web y pantalla posterior a la sesión

Fecha: 2026-09-09. Alcance: correcciones locales; este trabajo no publica Hosting
ni modifica reglas, usuarios, documentos de Firestore o datos de producción.

## Causas confirmadas

- `neom_home` mostraba una simulación en `NeomOnboardingOverlay`: elegía un
  número aleatorio de 150 a 400 Hz y animaba su convergencia durante cinco
  segundos. No solicitaba ni analizaba el micrófono. No era una medición fallida
  por permisos de Firebase.
- La Cámara Neom tiene otro flujo de micrófono. Al revisar la dependencia
  instalada `pitch_detector_dart 0.0.7`, su conversión de buffer entero no
  conservaba el PCM16 firmado little-endian. Se evita esa conversión mediante
  un decodificador explícito y la API de muestras flotantes del detector.
- `StateAfterglow` llamaba a `SharePlus`, abriendo compartir fuera de la app, y
  carecía de una salida explícita al inicio. El historial no estaba protegido y
  leía propiedades reactivas con un builder que no reaccionaba a sus cambios.
- La captura mostraba `/statesHistory` junto a contenido de Afterglow. No se
  atribuye esa discrepancia a una causa no reproducida: el mapa local sí apunta
  a `SessionHistoryPage`; se verifican navegación e historial separadamente.

## Cambios

### Medición de voz

- `neom_home` recibe callbacks inyectados; no depende de `neom_generator`.
  El overlay muestra solamente resultados reales, con detener, reintentar y
  errores localizados mediante `HomeTranslationConstants` y `.tr`.
- Cyberneom conecta esos callbacks a `VoicePitchMeasurement`, que reutiliza
  `NeomVoiceCapture`, AudioWorklet y el detector YIN instalado. Se utiliza la
  frecuencia de muestreo real del AudioContext, no una constante de móvil.
- Captura explícita de cinco segundos después del permiso, con límite de
  quince segundos para adquirir/inicializar el micrófono. Se solicitan
  preferencias de captura sin procesamiento de llamada de voz. No se guarda
  ningún archivo de audio ni se envían muestras al servidor.
- Resultado de mediana estable sin redondeo prematuro; silencio, ruido o tono
  insuficiente devuelven ausencia de resultado. Cancelación, permiso tardío y
  cierre liberan la captura sin afectar una medición nueva.
- El controlador existente de Cámara usa también la decodificación correcta
  del PCM; se conserva su integración de grabador nativo.
- Antes del demo se prepara una sesión libre sin octava, preset ni efectos
  heredados. La preparación corre durante la medición; cerrar/cancelar invalida
  las respuestas pendientes y Play utiliza el valor medido.

### Resultados y AuthGuard

- Compartir abre un `BlogEntry` local y editable en `neom_blog`. No abre el
  diálogo externo, no publica automáticamente y no copia parámetros de audio.
  Un protocolo no se etiqueta como Incienso si no tiene tal referencia.
- `AuthGuard` protege compartir, guardar emoción e historial. La ruta directa
  de historial para invitados muestra el acceso requerido sin cargar datos
  personales. Terminar una experiencia o volver a Inicio sigue permitido.
- Hay controles explícitos Cerrar y Volver a Inicio. El diseño permite scroll
  y ajuste de los controles con pantallas estrechas y texto ampliado.
- La confirmación de emoción ocurre solamente después de guardarla; se actualiza
  la sesión exacta. El historial nuevo queda separado por cuenta local. La caja
  antigua sin dueño no se borra ni se adjudica automáticamente a una cuenta.
  La clave local usa hexadecimal porque Hive normaliza los nombres a minúsculas;
  base64 habría permitido colisiones entre identificadores distintos.
- Los borradores de reflexión también tienen claves distintas por perfil, para
  no sobrescribir el texto de otra cuenta al alternar usuarios en la misma
  pantalla de resultados.
- El modo inmersivo se restaura al salir y cada pantalla de experiencia posee
  su controlador, evitando reutilizar el estado de otra experiencia.

## Verificación

- Suite integrada: **641 pruebas aprobadas** en generador, estados, home, blog y
  pruebas de integración de Cyberneom. Incluye la decodificación del controlador
  de Cámara a 44.1/48 kHz y el demo sin configuración heredada.
- Tras separar las claves de borrador por perfil: **35 pruebas focalizadas
  aprobadas** (31 de estados y cuatro de integración del demo), incluida la
  regresión nueva de cambio de cuenta. Hay 642 casos únicos validados en total.
- Análisis dirigido: sin errores; persisten avisos informativos sobre `Get`
  deprecado y dependencias transitivas ya usadas por Cyberneom.
- Compilación final `flutter build web --release --no-pub --no-wasm-dry-run`
  correcta (74.2 s), posterior al último cambio de código. Artefacto local:
  `Cyberneom/build/web`, sin despliegue. SHA-256 de `main.dart.js`:
  `5cc7a8ab74cf8899bf9d9ce6b00ebc46d18d85ca399e4dfbed75b520f9b25044`.
- Pruebas deterministas con PCM16 sintético a 44.1/48 kHz: 110, 220 y 440 Hz,
  valores fraccionales, silencio, ruido, cancelación, permiso tardío y reinicio.
- Prueba real de Chrome headless con AudioWorklet y MediaStream sintético:
  110 Hz → 110.0003 Hz; 220 Hz → 220.0022 Hz; 440 Hz → 440.0182 Hz.
  El silencio devolvió `null`, sin actualizaciones de frecuencia.
- En esa prueba todas las pistas terminaron y los AudioContext cerraron; no hubo
  conexión a los altavoces. Nunca se invocó el micrófono real del equipo.
- Prueba de permisos/cancelación web: seis solicitudes simuladas, cinco pistas
  liberadas, cero URLs de módulo filtradas.
- Las pruebas de UI cubren invitado frente a usuario autenticado, apertura del
  editor sin publicación y controles de salida en pantalla estrecha.

La precisión anterior corresponde a tonos sintéticos controlados, no promete
una frecuencia vocal única, inmutable ni exactitud de laboratorio. Queda probar
la voz y el micrófono reales del usuario y dispositivos físicos/Safari.

Los logs locales de esta verificación están en
`/tmp/cyberneom-frequency-qa.Xrrhwd/`. El aviso preexistente de fuente
`CupertinoIcons` pendiente no pertenece al detector ni impide la compilación.

## Pendiente separado descubierto

El reproductor de protocolos `neom_states` contiene una rampa `_fadeIn()` que
no actualiza el volumen y una pausa que sólo detiene el contador. Sus fases usan
temporizadores de pared. Es un flujo distinto del generador de Cámara Neom;
no se da por validado ni se modifica su motor en este trabajo.
