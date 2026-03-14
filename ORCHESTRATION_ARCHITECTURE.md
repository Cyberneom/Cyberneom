# CYBERNEOM — Frequency Orchestration Architecture

> Master reference for the Frequency Orchestration Platform.
> Last updated: 2026-03-02

---

## 1. Platform Vision

Cyberneom is a **Frequency Orchestration Platform** — an app + web system (cyberneom.xyz) that uses sound, light, and vibration to create frequency-based experiences for brainwave entrainment, meditation, focus, and wellness.

**Primary growth engine:** State links (`/x/{stateId}`) — standalone, zero-auth experience URLs.

---

## 2. Module Map

### Core Platform

| Module | Purpose | Status |
|--------|---------|--------|
| `sint` | Framework: state, DI, navigation, i18n (GetX wrapper) | Production |
| `neom_core` | 54 Firestore services, 45 repositories, 60+ enums | Production |
| `neom_commons` | Shared UI widgets, utilities, icons | Production |

### Frequency & States (THE GROWTH ENGINE)

| Module | Purpose | Status |
|--------|---------|--------|
| `neom_states` | **State links system** — 13 frequency states, `/x/{stateId}` routing, standalone experience screens, 4-language, analytics, presence | **Production** |
| `neom_generator` | Frequency engine — sine, binaural, isochronic, FM, breathing, EEG bands | Production |
| `neom_frequencies` | Frequency browser UI, 100+ frequency database | Production |

### Real-Time & Social

| Module | Purpose | Status |
|--------|---------|--------|
| `neom_rooms` | WebRTC mesh networking (72 files), room models, Firestore signaling | Production |
| `neom_live` | Live audio streaming with SoLoud effects | Production |

### Devices & Hardware

| Module | Purpose | Status |
|--------|---------|--------|
| `neom_ble` | BLE LED control, bio-sensors, haptic sync (simulation-based MVP) | v0.0.1 |

### Audio Stack

| Module | Purpose | Status |
|--------|---------|--------|
| `neom_audio_player` | Full music player: 7 queue modes, equalizer, jam sessions | Production |
| `neom_sound` | Audio processing, pitch detection, EQ, voice effects | Production |
| `neom_daw` | 16-track DAW: recording, waveforms, effects | Production |
| `neom_vst` | 12 virtual instruments via SF2 synthesis | Production |

### Planned (Not Yet Created)

| Module | Purpose | Priority |
|--------|---------|----------|
| `neom_ritual_composer` | Multi-layer experience timeline editor | P4 |
| `neom_light_orchestrator` | BLE LED device control synced with audio | P3 |
| `neom_sync` | Device sync engine + multi-user coordination | P3 |
| `neom_biofeedback` | Wearable sensor integration + adaptive experiences | P5 |

---

## 3. State Links Architecture (`/x/{stateId}`)

### URL Structure

```
Web:     cyberneom.xyz/x/{stateId}
Web alt: cyberneom.xyz/x/{stateId}?lang={en|es|fr|de}&ref={source}
Mobile:  cyberneom://x/{stateId}
```

### 13 Frequency States

| State ID | Binaural | Duration | Free? |
|----------|----------|----------|-------|
| `first-contact` | 10Hz alpha (200/210Hz) | 5 min | Yes |
| `sleep` | 3Hz delta (150/153Hz) | 20 min | Yes |
| `focus` | 40Hz gamma (400/440Hz) | 25 min | Yes |
| `calm` | Alpha→theta (200/210Hz) | 10 min | Yes |
| `meditate` | 7Hz theta (200/207Hz) | 15 min | PRO |
| `energy` | Beta→gamma (300/320Hz) | 8 min | PRO |
| `create` | 7.5Hz theta-alpha (200/207.5Hz) | 20 min | PRO |
| `relief` | 10Hz alpha (200/210Hz) | 15 min | PRO |
| `presence` | 18.98Hz infrasound | 10 min | PRO |
| `lucid` | 5Hz theta+gamma bursts (200/205Hz) | 30 min | PRO |
| `heart` | 7.83Hz Schumann (200/207.83Hz) | 12 min | PRO |
| `432` | 432Hz pure tone | 15 min | PRO |
| `528` | 528Hz Solfeggio | 15 min | PRO |

### UX Flow (3 Steps)

```
Landing ──► Experience ──► Afterglow
  │              │              │
  │ - Icon       │ - Audio      │ - Emotion feedback
  │ - Name       │ - Pulse BG   │ - Share (pre-formatted)
  │ - Headphones │ - Timer      │ - Explore more
  │ - Begin btn  │ - Tap=pause  │ - Room presence
  │ - Social     │ - Hold=stop  │ - PRO upsell (free only)
  │   proof      │              │
```

### Data Flow

```
URL /x/meditate?lang=es&ref=reddit
         │
         ▼
StateExperienceController.onInit()
  ├─ Parse: stateId, lang, ref
  ├─ Lookup StateCatalog → FrequencyState
  ├─ createPlatformAudio() → Mobile(PCM) or Web(OscillatorNode)
  ├─ Analytics: recordOpen + recordRef(ref)
  └─ Load usageCount + presenceCount
         │
    Begin │
         ▼
  AudioService.play(leftHz, rightHz)
  PresenceService.join()
  Analytics.recordStart()
  Timer + Phase scheduling
         │
  Complete│
         ▼
  AudioService.fadeOut()
  PresenceService.leave()
  Analytics.recordComplete()
  PresenceStream → afterglow display
```

### Audio Engine (Platform-Adaptive)

```
StateAudioService (abstract)
  ├─ StateAudioMobile (flutter_sound, PCM16, 44.1kHz stereo)
  ├─ StateAudioWeb (Web Audio API, OscillatorNode, js_interop)
  └─ StateAudioStub (unsupported platforms)

Selection: conditional imports on dart.library.io / dart.library.js_interop
```

### Firebase Collections

| Collection | Data |
|------------|------|
| `state_usage/{stateId}` | total, daily opens/starts/completions, emotions, shares, refs |
| `state_presence/{stateId}/active/{anonId}` | joinedAt, lastSeen (heartbeat 30s) |

### Universal Links / App Links

| Platform | File | Status |
|----------|------|--------|
| iOS | `web/.well-known/apple-app-site-association` | Configured (Team 4ZY3D2GU99) |
| Android | `web/.well-known/assetlinks.json` | SHA256 pending (Play Console) |
| Firebase | `firebase.json` rewrites for `/api/og/x/**` | Configured |

### OG Meta Tags

Cloud Function `stateOgMeta` generates dynamic OG meta for social sharing:
- Path: `/api/og/x/{stateId}` → rewrite in firebase.json
- Returns HTML with `og:title`, `og:description`, `twitter:card`
- Bilingual (ES/EN based on Accept-Language or `?lang=`)
- `<meta http-equiv="refresh">` redirects to actual `/x/{stateId}` URL

### Analytics Per State Link

```
Tracked:
  - unique_opens (total + daily)
  - source (refs.{ref} from ?ref= param)
  - started (tapped Begin)
  - completed (reached end)
  - emotion_response (emoji distribution)
  - shared (tapped Share)

Key funnels:
  open → start → complete → share
  open → start → complete → PRO
```

---

## 4. Internationalization

| Scope | Languages | Mechanism |
|-------|-----------|-----------|
| State experience (neom_states) | ES, EN, FR, DE | Inline translations + SINT module translations |
| State names & descriptions | ES, EN, FR, DE | FrequencyState.names/descriptions maps |
| Afterglow UI | ES, EN, FR, DE | Inline `_translations` map |
| App-level SINT | ES, EN, FR*, DE* | `app_*_translations.dart` (* partial) |

FR/DE at app level only covers modules with translations: neom_bank, neom_daw, neom_states.
Other modules fall back to `fallbackLocale` (ES).

---

## 5. Dependency Graph

```
sint
 └─ neom_core
     └─ neom_commons
         ├─ neom_states ←── State Links (standalone, no app shell)
         │   ├─ cloud_firestore (analytics + presence)
         │   ├─ flutter_sound (mobile audio)
         │   ├─ web (Web Audio API)
         │   └─ share_plus
         │
         ├─ neom_generator ←── Frequency engine (mobile)
         │   └─ flutter_sound
         │
         ├─ neom_rooms ←── WebRTC real-time
         │   ├─ flutter_webrtc
         │   └─ flutter_sound
         │
         ├─ neom_ble ←── Hardware devices
         │   └─ flutter_blue_plus (declared, not wired)
         │
         └─ (55+ other modules)
```

---

## 6. Implementation Status

### Priority 1 — State Links (Growth Engine) ✅ COMPLETE

- [x] FrequencyState model + 13 state configs
- [x] StateExperienceScreen (standalone, no-auth)
- [x] `/x/{stateId}` routing (web + mobile)
- [x] Platform-adaptive audio (Mobile PCM + Web Audio API)
- [x] Landing → Experience → Afterglow flow
- [x] 4-language support (ES/EN/FR/DE)
- [x] Firebase analytics (opens, starts, completions, emotions, shares, refs)
- [x] Firebase presence (real-time user count)
- [x] PRO upsell in afterglow (free states only)
- [x] Share with pre-formatted message + URL
- [x] State catalog page (/statesExplore)
- [x] OG meta Cloud Function (stateOgMeta)
- [x] Universal Links iOS (apple-app-site-association)
- [x] `?ref=` source tracking in analytics
- [ ] Android App Links SHA256 (needs Play Console)

### Priority 2 — Extended States + Social (NEXT)

- [x] All 13 states implemented (meditate, energy, create, relief, 432, 528, etc.)
- [x] Room presence integrated in afterglow
- [ ] PRO paywall integration (route `/pro` exists in afterglow, needs destination)
- [x] Daily session limit for free states (1/state/day after first use, Hive)
- [ ] Connect rooms to state experiences (join synchronized session)

### Priority 3 — Devices

- [ ] Wire neom_ble to real flutter_blue_plus (replace Timer mocks)
- [ ] Port Blup LED protocols (ELK-BLEDOM, Triones, QHM)
- [ ] Web Bluetooth via js_interop
- [ ] Chromatic Sync experience (lights + audio)
- [ ] `/x/presence` state with real speakers

### Priority 4 — Ritual Composer

- [ ] neom_ritual_composer module
- [ ] Multi-layer timeline editor (audio, light, haptic tracks)
- [ ] Template rituals (deep_meditation, focus_boost, sleep_preparation)
- [ ] Shareable ritual links: `/r/{ritual_id}`
- [ ] DAW-style web composer (desktop layout)

### Priority 5 — Advanced

- [ ] neom_sync (multi-device timing, latency compensation)
- [ ] neom_biofeedback (HR, HRV, breathing detection)
- [ ] Group experiences (synchronized multi-user)
- [ ] Frequency Explorer (interactive picker)
- [ ] Object Resonance Scanner (mic FFT)
- [ ] Breathing Sync (amplitude modulation)

---

## 7. Key File Paths

```
Cyberneom/
├── lib/
│   ├── main.dart                    # App entry, 4 locales
│   ├── app_routes.dart              # ...StatesRoutes.routes
│   ├── root_binding.dart            # 223 DI bindings
│   └── localization/
│       ├── app_translations.dart    # ES, EN, FR, DE
│       ├── app_es_translations.dart
│       ├── app_en_translations.dart
│       ├── app_fr_translations.dart
│       └── app_de_translations.dart
├── web/.well-known/
│   ├── apple-app-site-association   # iOS Universal Links
│   └── assetlinks.json              # Android App Links
├── firebase.json                    # Hosting + OG rewrite
├── functions/index.js               # stateOgMeta + secureOps
├── CYBERNEOM_PLAN.md                # Original development plan
├── ANALYSIS_REPORT.md               # Phase 1 module inventory
└── ORCHESTRATION_ARCHITECTURE.md    # THIS FILE

neom_modules/neom_states/lib/
├── domain/models/
│   ├── frequency_state.dart         # Core model
│   └── frequency_phase.dart         # Multi-phase support
├── domain/use_cases/
│   └── state_audio_service.dart     # Abstract audio interface
├── data/
│   ├── state_catalog.dart           # 13 state definitions
│   ├── state_analytics_service.dart # Firestore analytics + ref tracking
│   ├── state_presence_service.dart  # Real-time presence
│   ├── implementations/
│   │   ├── state_audio_factory.dart # Platform selection
│   │   ├── state_audio_io.dart      # Mobile PCM
│   │   ├── state_audio_web.dart     # Web Audio API
│   │   └── state_audio_stub.dart    # Unsupported fallback
│   └── translations/
│       ├── states_es_translations.dart
│       ├── states_en_translations.dart
│       ├── states_fr_translations.dart
│       └── states_de_translations.dart
├── ui/
│   ├── state_experience_controller.dart  # State machine
│   ├── state_experience_screen.dart      # Main container
│   ├── state_catalog_page.dart           # Browse states
│   └── widgets/
│       ├── state_landing.dart            # Step 1
│       ├── state_player.dart             # Step 2
│       ├── state_afterglow.dart          # Step 3
│       ├── state_card.dart               # Catalog card
│       └── frequency_pulse_background.dart # Visual effect
└── neom_states_routes.dart               # /x/:stateId, /statesExplore
```

---

## 8. Distribution Strategy (from Plan)

| State | Target Communities | Keywords |
|-------|--------------------|----------|
| `/x/sleep` | r/insomnia, r/sleep | "can't sleep", "insomnia help" |
| `/x/focus` | r/productivity, r/ADHD | "study focus", "concentration" |
| `/x/calm` | r/anxiety, r/mentalhealth | "anxiety relief", "stress relief" |
| `/x/first-contact` | TikTok, r/woahdude | "closed-eye visuals" |
| `/x/432`, `/x/528` | YouTube, r/soundhealing | "432Hz meditation", "528Hz healing" |
| `/x/presence` | r/paranormal | "18.98Hz presence sensation" |

---

## 9. Monetization

```
FREE (unlimited):
  /x/first-contact, /x/sleep, /x/focus, /x/calm
  (Planned: 1 session/state/day limit after first use)

PRO ($3 USD/month):
  All 13 states unlimited
  Custom frequency input
  neom_rooms access
  BLE device connection
  Ritual composer
```

Payment: `neom_stripe` (Stripe Checkout), managed via `secureOps` Cloud Function.
