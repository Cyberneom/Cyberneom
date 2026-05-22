# Cyberneom — Regression Testing

Carpeta de pruebas de regresión para Cyberneom Web (la app de wellness /
biohacking del ecosistema Open Neom). Sigue el mismo patrón que
`gigmeout/`, `Emxi/` e `Itzli/` `docs/regression-testing/`, adaptado a las
features distintivas de Cyberneom.

## Archivos

| Archivo | Tipo | Propósito |
|---|---|---|
| `Cyberneom_Web_Regression_Testing_Checklist.xlsx` | generado | Checklist con 159 casos |
| `cases.json` | generado | Input para el submódulo agnóstico `neom_qa_tracker` |
| `generate_xlsx.py` | fuente | Script Python que produce ambos |
| `README.md` | doc | Este archivo |

> El manual `.docx` no está aún. Cuando se necesite, copiar el patrón de
> `Itzli/docs/regression-testing/generate_docx.js` y adaptar texto/colores.

## Cómo regenerar

```bash
pip install openpyxl                      # solo la primera vez
cd Cyberneom/docs/regression-testing/
python3 generate_xlsx.py
```

Output:
```
OK written: .../Cyberneom_Web_Regression_Testing_Checklist.xlsx
Total cases: 159
OK written: .../cases.json
```

## Distribución de los 159 casos

| Área | Prefijo | # | Notas |
|---|---|---|---|
| Smoke / Boot | SMK | 7 | |
| Auth + Onboarding | AUTH/ONB | 9 | |
| **PAR — Cognitive Fitness** | PAR | 12 | **distintivo** — readiness, protocolos, percentiles, deskSensor |
| **Biofeedback (mic-based)** | BIO | 7 | **distintivo** — breath, movement, HSS calculator |
| **Historic State (frequency descent)** | HST | 8 | **distintivo** — Anchor → Diffusion → ExistentialBase |
| **Frequencies / sound therapy** | FRQ | 5 | **distintivo** — 528Hz, 432Hz, beats |
| **States (estados emocionales)** | STA | 3 | **distintivo** |
| **VR experiences** | VR | 3 | **distintivo** |
| **Experiences** | EXP | 3 | |
| Generator / Inter / Downloads | GEN/INT/DLD | 3 | |
| Profile + Mates | PRF/MAT | 6 | |
| Home / Posts | HOM/PST | 8 | |
| Audio + Releases | AUD/REL | 8 | |
| Inbox + Notif + Search | MSG/NOT/SCH | 7 | |
| Events + Calendar + Booking | EVT/CAL/BKG | 5 | |
| Stripe + Subscriptions | SUB | 6 | |
| Wallet | WAL | 2 | |
| ERP + Admin | ERP/ADM | 3 | ADM-02 referencia el QA tracker via `neom_qa_tracker` |
| Learning + Books | LRN/BOK | 5 | |
| Itzli embed | EMB | 4 | |
| Camera + uploads | CAM | 3 | |
| TTS + Cloud | TTS/CLD | 3 | |
| Settings | SET | 3 | |
| Routing / Deep links | RTE | 6 | incluye `/par` y `/historicState` |
| Performance | PRF | 4 | |
| Cross-platform | XPL | 8 | énfasis en mic permissions iOS/Android/Web |
| Errors | ERR | 4 | |
| Security | SEC | 5 | **incluye SEC-04 mic privacy + SEC-05 audio raw no persiste** |
| Localization | I18N | 6 | |
| Accessibility | A11Y | 3 | |

Las áreas en negrita son **distintivas de Cyberneom** vs Gigmeout/EMXI/Itzli.

## 8 Release Gates automáticos

1. P0 100% pass
2. P1 ≥95%
3. P2 ≥80% ejecutados
4. 0 defectos P0 abiertos
5. Cobertura ≥90%
6. **PAR-04** (readiness funciona) en Passed
7. **HST-04** (frequency descent llega a 7.5Hz) en Passed
8. **SEC-04** (mic data privacy — solo CV local, audio raw no se sube) en Passed

Los últimos 3 gates protegen lo que diferencia a Cyberneom: la promesa
de privacidad biofeedback + el correcto funcionamiento de los protocolos
únicos.

## Diferencias con Gigmeout, Itzli, EMXI

| Aspecto | Gigmeout | Itzli | EMXI | **Cyberneom** |
|---|---|---|---|---|
| Plataforma | Web | Desktop | Web + mobile | Web + mobile |
| Vertical principal | Música/social | Asistente IA desktop | Multi-vertical | **Wellness / biohacking** |
| Casos totales | 140 | 198 | 257 | **159** |
| Distintivos | DAW, VST | Daemon, Tool Guard, MCP | Museum, Galeria, ERP, Woo | **PAR, biofeedback, frequencies, HSS** |
| Privacidad sensible | media | alta (shell) | media | **alta (mic, biofeedback)** |

## Consume el submódulo `neom_qa_tracker`

Cyberneom es `AppInUse.c`. Para que el QA Tracker agnóstico funcione, el
host debe declarar:

### 1) Asset

Copia `cases.json` a `Cyberneom/assets/qa/cases.json` (script de pre-build,
o comando manual tras regenerar). Declara en `Cyberneom/pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/qa/cases.json
```

### 2) `qaTrackerConfig.c` en `properties.json`

```jsonc
{
  "qaTrackerConfig": {
    "c": {
      "casesAssetPath": "assets/qa/cases.json",
      "defectIdPrefix": "CYB",
      "accentColor": "00897B",
      "platforms": ["web", "android", "ios"],
      "screenshotStoragePath": "qa-screenshots",
      "supportsRequestsLink": true
    }
  }
}
```

### 3) Ruta en `app_routes.dart`

```dart
import 'package:neom_qa_tracker/neom_qa_tracker.dart';

SintPage(
  name: '/admin/qa-tracker',
  page: () => const SaiaQaTrackerPage(),
  binding: SaiaQaTrackerBinding(),
);
```

Sin tocar el submódulo. Cero dependencias hardcoded.

## Mantenimiento

Cuando añadas:

- **Nuevo nodo en PAR (más protocolos, percentile metrics):** caso PAR-XX
- **Nueva frecuencia / preset de sound therapy:** caso FRQ-XX
- **Nueva fase del Historic State:** caso HST-XX
- **Nueva experiencia VR:** caso VR-XX
- **Cambio en biofeedback algorithm (HSS, Butterworth):** caso BIO-XX

Después: regenerar XLSX, regenerar `cases.json`, copiar a
`assets/qa/cases.json`, commitear los archivos juntos.

Owner: Serzen.
