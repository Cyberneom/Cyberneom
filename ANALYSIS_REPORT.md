# CYBERNEOM — Phase 1 Analysis Report

## 1. Module Inventory (67 modules)

### Framework (2)
| Module | Version | Platform | Notes |
|--------|---------|----------|-------|
| sint | 1.2.2 | web+mobile | Core framework: state, DI, navigation, translation (GetX wrapper) |
| sint_sentinel | 1.0.0 | web+mobile | Circuit breaker & rate limiter for Firebase |

### Core (3)
| Module | Version | Platform | Notes |
|--------|---------|----------|-------|
| neom_core | 3.0.0 | web+mobile | 54 Firestore services, 45 repository interfaces, 60+ enums |
| neom_commons | 3.0.0 | web+mobile | Shared UI widgets, utilities, icons, animations |
| neom_maps_services | 2.0.0 | web+mobile | Pure Dart Google Maps Web Services |

### Audio & Sound (7)
| Module | Version | Platform | Key Capability |
|--------|---------|----------|----------------|
| neom_sound | 1.0.0 | mobile | Audio processing, pitch detection, EQ, voice effects (flutter_soloud, flutter_sound) |
| neom_audio_player | 2.1.0 | mobile | Full music player: 7 queue modes, jam sessions, equalizer (just_audio) |
| neom_media_player | 1.4.0 | mobile | Video & YouTube playback |
| neom_daw | 1.0.0 | mobile | 16-track DAW: recording, waveforms, effects (audio_waveforms) |
| neom_generator | 2.0.0 | mobile | **CRITICAL: Sine engine, binaural beats, isochronic tones, FM synthesis, EEG bands** |
| neom_vst | 1.0.0 | web+mobile | 12 virtual instruments via SF2 synthesis (dart_melty_soundfont) |
| neom_live | 1.0.0 | mobile | Live audio streaming with SoLoud effects |

### Frequency & BLE (2)
| Module | Version | Platform | Key Capability |
|--------|---------|----------|----------------|
| neom_frequencies | 1.4.0 | mobile | Frequency browser UI, Firestore persistence, route integration |
| neom_ble | 0.0.1 | mobile | LED control, bio-sensors, haptic sync (flutter_blue_plus declared, simulation-based) |

### Real-Time & Social (2)
| Module | Version | Platform | Key Capability |
|--------|---------|----------|----------------|
| neom_rooms | 1.0.0 | mobile | **WebRTC mesh networking (72 files), room models, Firestore signaling, audio levels** |
| neom_live | 1.0.0 | mobile | Live sessions layer on top of WebRTC |

### Content & Social (10)
| Module | Version | Notes |
|--------|---------|-------|
| neom_posts | 2.0.0 | Post CRUD with media |
| neom_timeline | 2.0.0 | Activity feed |
| neom_blog | 1.0.0 | Blog creation |
| neom_stories | 1.0.0 | Stories module |
| neom_profile | 2.0.0 | User profiles |
| neom_mates | 2.0.0 | Friendships |
| neom_communities | 1.0.0 | Community management |
| neom_love | 1.0.0 | Librinder dating game |
| neom_inbox | 2.0.0 | Messaging + media |
| neom_bands | 1.6.0 | Band details + DAW studio |

### Commerce & Payment (6)
| Module | Version | Notes |
|--------|---------|-------|
| neom_stripe | 1.4.0 | Stripe integration |
| neom_woo | 1.1.1 | WooCommerce API |
| neom_shop | 1.0.0 | Native shop + PDF invoices |
| neom_bank | 1.2.0 | Wallet features |
| neom_nupale | 1.0.0 | Statistics + analytics |
| neom_commerce | 1.6.0 | Commerce routes |

### Books & Reading (3)
| Module | Version | Notes |
|--------|---------|-------|
| neom_books | 1.0.0 | PDF/ePub reader + Google Books |
| neom_freebooks | 1.2.0 | Free EPUB reader (Provider state) |
| neom_flipbook | 1.0.0 | FlippingBook-style reader (web-first) |

### AI & Learning (4)
| Module | Version | Notes |
|--------|---------|-------|
| neom_ia | 1.0.0 | Firebase AI generative |
| neom_memory | 1.0.0 | Conversation memory + caching |
| neom_corpus | 1.1.0 | Semantic analysis, vector math |
| neom_learning | 1.0.0 | Duolingo-style music education (643 nodes) |

### Games (2)
| Module | Version | Notes |
|--------|---------|-------|
| neom_games | 1.0.0 | Chess, word games, literary games |
| neom_animations | 1.0.0 | Physics word games |

### Utility & Other (20+)
| Module | Notes |
|--------|-------|
| neom_admin, neom_analytics, neom_creator_analytics | Admin + analytics |
| neom_usage | Rate limiting & tier management |
| neom_notifications | Push + local notifications |
| neom_onboarding, neom_settings, neom_home | App shell |
| neom_search, neom_directory, neom_calendar | Discovery |
| neom_events, neom_booking, neom_requests | Events system |
| neom_instruments, neom_genres | Music metadata |
| neom_itemlists, neom_releases | Collections |
| neom_downloads, neom_camera, neom_image_editor, neom_video_editor | Media tools |
| neom_tts | Multi-provider TTS |
| neom_cloud | Google Drive + Gmail |
| neom_rc | Itzli remote control |
| neom_docs | PDF/Excel/DOCX generation |
| neom_web_search, neom_google_books, neom_google_places, neom_spotify | External APIs |
| neom_vr | Experimental VR (sensors_plus) |
| neom_sat, neom_cli | Desktop CLI tools |

---

## 2. Deep Dive: neom_ble

**Status:** v0.0.1 — simulation-based MVP, flutter_blue_plus declared but not wired

**Architecture:** 3 subsystems

| Subsystem | Controller | Status | Key Feature |
|-----------|-----------|--------|-------------|
| **Lighting** | `LedHackingController` | UI complete, BLE mock | ColorWheel HSL picker, 3 effects (pulse/strobe/fade) |
| **Bio-Sensors** | `BioSensorController` | UI complete, BLE mock | HR/HRV/EEG simulation streams |
| **Haptics** | `HapticSyncController` | UI complete, BLE mock | Audio amplitude → intensity sync |
| **Dashboard** | `NeomBleDashboard` | Complete | Unified 3-subsystem view |

**Device abstraction:** Planned (`NeomBleDriver` interface) but not implemented. Controllers are per-capability, not per-device.

**LED protocol reference exists** in Blup app (`HardwareLink`): ELK-BLEDOM, Triones/MagicHome, QHM — 3 protocol variants with dictionary attack pattern.

**Web Bluetooth:** NOT implemented. No js_interop for navigator.bluetooth. Mobile-first.

**Extension for LED control:** Ready — replace Timer simulation with `FlutterBluePlus.startScan()`, add GATT characteristic write. Protocol encoders from Blup can be ported.

---

## 3. Existing Audio/Frequency Capabilities

### neom_generator — THE FREQUENCY ENGINE (already exists!)

**This is the mathematical brain the plan calls for.** It already implements:

| Engine | Capability |
|--------|-----------|
| `NeomSineEngine` | Real-time stereo sine oscillators, binaural beat support (separate L/R Hz), 44100Hz/16-bit PCM streaming via FlutterSoundPlayer |
| `NeomIsochronicEngine` | Pulsing beat at specified Hz with duty cycle control |
| `NeomBreathingEngine` | Amplitude modulation for breath patterns |
| `NeomModulatorEngine` | FM synthesis |
| `NeomNeuroStateEngine` | EEG brainwave state mapping |
| `NeomFrequencyPainterEngine` | Binaural visualization, EEG band detection (delta/theta/alpha/beta/gamma), hemispheric coherence, Lissajous curves |

**Constants:** Min 40Hz, Default 345Hz, User limit 1500Hz, Binaural beat max 250Hz

### surround_frequency_generator — Web Audio Bridge

**Location:** `libraries/surround_frequency_generator/`

Web Audio API wrapper via WebView JavaScript bridge:
- `OscillatorNode` (sinusoidal/square)
- `PannerNode` with HRTF spatial model
- 3D positioning (x, y, z)
- Dynamic frequency/volume control

### Frequency Database (frequencies.json)

**672 lines, 100+ frequencies** with brainwave mappings:
- 0.5Hz Epsilon → 40Hz Gamma
- Includes: Schumann resonance (7.83Hz), pain relief (2.5Hz), lucid dreaming (4.5Hz), focus (14Hz)
- Spanish names/descriptions, tags (nature, medicine, spiritual, etc.)

### neom_rooms — WebRTC Infrastructure

**72 Dart files with production-grade WebRTC:**

| Component | Capability |
|-----------|-----------|
| `RoomWebRtcController` | Mesh topology, broadcaster/listener patterns, Firestore signaling |
| `AudioStreamManager` | Audio level polling, speaking detection, network quality monitoring |
| `AudioDeviceManager` | Speaker/earpiece/bluetooth routing |
| `ConnectionRecoveryManager` | Exponential backoff reconnection (8 attempts) |
| WebRTC config | Opus 48kHz, echo cancellation, noise suppression, adaptive bitrate 8-32kbps |

**Room model already supports:** participant tracking, reactions, scheduled events, access control, live sessions

### Audio Package Matrix

| Package | Used By | Capability |
|---------|---------|-----------|
| flutter_sound | neom_sound, neom_generator, neom_rooms | PCM recording/streaming |
| just_audio | neom_audio_player, neom_daw | Media playback |
| flutter_soloud | neom_sound, neom_vst, neom_daw, neom_live | Pure Dart audio synthesis |
| pitch_detector_dart | neom_sound | Real-time mic frequency detection |
| flutter_webrtc | neom_rooms | P2P audio/video/data |
| dart_melty_soundfont | neom_vst | SF2 instrument synthesis |
| audio_waveforms | neom_daw | Waveform visualization |
| audio_service | neom_audio_player | Background audio |

---

## 4. Project Patterns

| Aspect | Pattern | Details |
|--------|---------|---------|
| **State Management** | SINT (GetX wrapper) | `SintController`, `.obs`, `Obx()`, `SintBuilder<T>` |
| **Routing** | SintPage/GetPage | Module `*_routes.dart` → spread in `app_routes.dart` |
| **DI** | SINT Binding | `RootBinding`, `Bind.lazyPut(() => ..., fenix: true)` |
| **Architecture** | Clean Architecture | domain/ (models, interfaces) → data/ (firestore, implementations) → ui/ (pages, controllers) |
| **i18n** | SINT Translations | `Map<String, String>` per language per module, aggregated in `app_*_translations.dart`. **2 languages: ES, EN** |
| **Theming** | AppColor + AppTheme | `AppColor.getMain()` by `AppInUse` enum, dark default, Open Sans |
| **Serialization** | Manual toJSON/fromJSON | No freezed. json_serializable only in neom_woo |
| **Linting** | flutter_lints 6.0.0 | Standard rules |
| **Web/Mobile** | kIsWeb + conditional imports | Platform stubs, route/DI conditionals |
| **Firestore** | Repository pattern | Abstract interfaces in domain/, Firestore implementations in data/ |
| **Local Storage** | Hive | `AppHiveController` singleton, lazy box opening |

---

## 5. Dependency Graph (Key Relationships)

```
sint ─────────────────────────────────────────────────────┐
  └─ neom_core ──────────────────────────────────────────┐│
       ├─ neom_commons ──────────────────────────────────┤│
       │    ├─ neom_audio_player ← neom_sound            ││
       │    ├─ neom_generator ← neom_sound, neom_vr      ││
       │    ├─ neom_frequencies                           ││
       │    ├─ neom_rooms ← neom_sound, flutter_webrtc   ││
       │    ├─ neom_ble ← flutter_blue_plus              ││
       │    ├─ neom_games ← neom_corpus, neom_ia         ││
       │    ├─ neom_live ← flutter_soloud                 ││
       │    ├─ neom_daw ← neom_sound, just_audio          ││
       │    ├─ neom_vst ← dart_melty_soundfont            ││
       │    └─ (40+ other modules)                       ││
       └─ neom_usage ← hive                              ┘│
                                                           ┘
```

---

## 6. Reusable Components for Frequency Orchestration Platform

### ALREADY HAVE (no need to build from scratch)

| Need from Plan | Existing Solution | Gap |
|----------------|-------------------|-----|
| Frequency engine (math) | `neom_generator` — sine, binaural, isochronic, FM, breathing engines | Works on mobile only (FlutterSoundPlayer). Need Web Audio API path. |
| Brainwave band definitions | `NeomFrequencyPainterEngine` — delta/theta/alpha/beta/gamma with color mapping | Complete |
| Frequency presets | `frequencies.json` — 100+ brainwave-mapped frequencies | Need to map to state link IDs |
| Binaural beat calculation | `NeomSineEngine` — separate L/R oscillators, PCM stereo | Need web equivalent (WebAudioContext) |
| Room presence | `neom_rooms` — WebRTC mesh, participant tracking, Firestore signaling | Need simple presence counter (non-WebRTC) for free tier |
| WebRTC voice | `RoomWebRtcController` — full mesh, adaptive bitrate | Complete for PRO rooms |
| BLE LED control | `neom_ble` — `LedHackingController`, `ColorWheel` | Wire flutter_blue_plus, port Blup protocols |
| Bio-sensors | `neom_ble` — `BioSensorController` (HR/HRV/EEG) | Wire to real BLE notify |
| Haptic sync | `neom_ble` — `HapticSyncController` (audio→vibration) | Wire to real BLE write |
| Pitch detection | `neom_sound` — `pitch_detector_dart` | Complete for resonance scanner |
| Spatial audio | `surround_frequency_generator` — HRTF panning via WebView | Works but needs refactor for direct Web Audio |
| Payment | `neom_stripe` — Stripe Checkout | Complete |
| Usage tiers | `neom_usage` — rate limiting, tier management | Complete |
| Analytics | `neom_analytics` — fl_chart, CSV export | Need state link analytics |
| i18n | SINT translations (ES, EN) | Need FR, DE additions |
| Theming | `AppColor` + `AppTheme` | Need full-screen immersive theme variant |

### NEED TO BUILD (new)

| Component | Priority | Reason |
|-----------|----------|--------|
| **Web Audio Engine** | P1 | neom_generator uses FlutterSoundPlayer (mobile). Web needs OscillatorNode via js_interop |
| **StateExperienceScreen** | P1 | Standalone no-auth full-screen experience (landing→experience→afterglow) |
| **FrequencyState model** | P1 | Map state IDs → frequency configs with multi-phase support |
| **State link routing** | P1 | `/x/{stateId}` working on web AND mobile |
| **Screen pulse/strobe** | P1 | Full-screen color animation synced to frequency |
| **Afterglow screen** | P1 | Emotion feedback + share + explore + PRO upsell |
| **4-language strings** | P1 | Add FR + DE to state experience UI |
| **State analytics** | P1 | Track opens/starts/completions/shares/conversions per state link |
| **Simple presence counter** | P2 | Firebase Realtime Database counter (non-WebRTC, free tier) |
| **Web Bluetooth wrapper** | P3 | js_interop for navigator.bluetooth (Chrome/Edge) |
| **Ritual composer** | P4 | DAW-style timeline for multi-layer experiences |

---

## 7. Recommendations

### Architecture Approach

1. **DO NOT create `neom_frequency_engine`** — `neom_generator` already IS the frequency engine. Extend it with a web audio backend instead of rebuilding.

2. **DO NOT create `neom_audio_orchestrator`** from scratch — create a **platform adapter** inside neom_generator that switches between `FlutterSoundPlayer` (mobile) and `WebAudioContext` (web) via conditional imports.

3. **State links (`/x/{stateId}`) should be a new module: `neom_states`** — self-contained, no dependency on app shell, works standalone on web and mobile. Contains:
   - `FrequencyState` model + preset catalog
   - `StateExperienceScreen` (landing → experience → afterglow)
   - `StateAudioEngine` (abstract, with mobile/web implementations)
   - Routes, translations (ES/EN/FR/DE), analytics

4. **neom_rooms is massive and ready** — use its WebRTC infrastructure for PRO rooms. For free tier state links, use a simple Firebase Realtime Database presence counter (much lighter).

5. **neom_ble needs wiring, not rewriting** — the architecture is good, just replace Timer mocks with real FlutterBluePlus calls. Port Blup's protocol encoders.

6. **i18n: extend existing pattern** — add FR/DE translation maps to each module following the same `*_fr_translations.dart`, `*_de_translations.dart` pattern. Update `AppTranslations` to include `'fr'` and `'de'` keys.

### Implementation Priority (matching plan Phase 5)

```
P1: neom_states module + Web Audio Engine adapter
    → FrequencyState model + presets
    → StateExperienceScreen (standalone)
    → /x/{stateId} routing (web + mobile)
    → Web Audio via js_interop (binaural oscillators)
    → Core states: first-contact, sleep, focus, calm
    → 4-language support
    → Analytics tracking

P2: Extended states + Room presence
    → meditate, energy, create, relief, 432, 528
    → Firebase Realtime presence counter
    → Connect afterglow → rooms

P3: BLE device integration
    → Wire neom_ble to real flutter_blue_plus
    → Port Blup LED protocols
    → Web Bluetooth (optional)

P4: Ritual composer
    → Multi-layer timeline editor
    → Template rituals
    → Shareable ritual links
```
