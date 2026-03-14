# CYBERNEOM FREQUENCY ORCHESTRATION SYSTEM — Development Plan

> This file is a plan for Claude Code to execute. Run: `claude "Read CYBERNEOM_PLAN.md and execute the plan. Start with Phase 1."`

---

## WHAT IS CYBERNEOM BECOMING

Cyberneom is evolving from a meditation/neurotechnology app into a **Frequency Orchestration Platform** — an app + web system (www.cyberneom.xyz) that coordinates multiple physical devices (speakers, BLE LED lights, haptics, wearables) to create precise, synchronized frequency-based experiences.

Think of it as: **a conductor's baton for sound, light, and vibration, turning any room into a calculated wave field.**

The platform has a social layer called **neom_rooms** where each frequency is a live room showing how many people are experiencing it worldwide, with the ability to connect and synchronize with others.

---

## PHASE 1: ANALYZE BEFORE CREATING

**This phase is MANDATORY. Do not skip it. Do not create any new files until this is complete.**

### Step 1.1 — Inventory all existing modules

```
Action: List and analyze every directory inside neom_modules/
For each module:
  - Read pubspec.yaml → extract name, version, dependencies
  - Read main export file (lib/{module_name}.dart) → list exported classes/functions
  - Read lib/ directory structure → identify models, services, controllers, utils
  - Identify state management pattern (GetX, Riverpod, Bloc, Provider?)
  - Note any platform-specific code (web vs mobile)
```

### Step 1.2 — Deep dive into neom_ble

```
Action: Analyze neom_ble thoroughly
  - What BLE services/characteristics does it already handle?
  - What device types can it connect to?
  - What is the connection lifecycle (scan, connect, read, write, disconnect)?
  - Is there device abstraction (interface for different device types)?
  - Can it be extended for LED control, or does it need a wrapper?
```

### Step 1.3 — Check for existing audio capabilities

```
Action: Search across ALL modules for:
  - Any audio generation code (oscillators, tone generators)
  - References to surround_frequency_generator package
  - Web Audio API usage (dart:js, dart:html, js_interop)
  - Any frequency-related models or constants
  - WebSocket or real-time communication code
  - WebRTC or call/voice related code
  - Room or channel concepts already implemented
```

### Step 1.4 — Detect project patterns

```
Action: Identify patterns used across the project
  - State management: GetX? Riverpod? Bloc? Provider?
  - Routing: GoRouter? GetX routes? Navigator 2.0?
  - Code generation: freezed? json_serializable? build_runner?
  - Linting: Read analysis_options.yaml
  - Architecture: Clean architecture layers? Feature-first? Layer-first?
  - Naming conventions for files, classes, variables
  - How does the project handle web vs mobile differences?
```

### Step 1.5 — Output analysis report

```
Action: Create ANALYSIS_REPORT.md with:
  - Complete module inventory table
  - Dependency graph (which module depends on which)
  - Reusable components identified
  - Gaps that need new modules
  - Recommended approach based on existing patterns
```

**STOP HERE. Present findings and ask for confirmation before proceeding to Phase 2.**

---

## PHASE 2: NEW MODULES ARCHITECTURE

### Required new modules (adjust based on Phase 1 findings)

#### neom_frequency_engine — The mathematical brain
```
Purpose: Pure calculation engine, no UI, no platform dependencies
Contains:
  - WaveformGenerator: sine, square, triangle, sawtooth, Bessel patterns
  - HarmonicCalculator: octave relationships, fifths, sacred frequencies
  - PhaseController: phase offset calculations for multi-device sync
  - GeometryMapper: device spatial positions → interference pattern math
  - FrequencyPresets: brainwave bands (delta/theta/alpha/beta/gamma)
  - BinauralBeatCalculator: left/right differential computation
  - ResonanceAnalyzer: FFT-based resonance detection from mic input
```

#### neom_audio_orchestrator — Sound layer
```
Purpose: Platform-adaptive audio generation and control
Contains:
  - AudioEngine (abstract) → WebAudioEngine / MobileAudioEngine
  - WebAudioEngine: OscillatorNode, AudioContext, GainNode via js_interop
  - MobileAudioEngine: wraps surround_frequency_generator or audio plugins
  - MultiSpeakerController: individual frequency/phase/amplitude per BLE speaker
  - BinauralBeatPlayer: manages stereo separation for binaural effect
  - FrequencySweeper: linear/log frequency sweeps for resonance scanning
  - SpatialAudioMapper: 3D positioning of audio sources
Conditional imports:
  - 'audio_engine_stub.dart'
  - if (dart.library.html) 'audio_engine_web.dart'
  - if (dart.library.io) 'audio_engine_mobile.dart'
```

#### neom_light_orchestrator — Light layer
```
Purpose: BLE LED device control synchronized with audio
Extends: neom_ble
Contains:
  - LightDevice (abstract): color, brightness, pulse rate
  - BLELightController: GATT write for common LED protocols
  - WebBluetoothController: Web Bluetooth API via js_interop
  - ColorFrequencyMapper: maps audio frequency → visible color
  - StrobePatternGenerator: pulse patterns for brainwave entrainment
  - LightTimeline: scheduled color/brightness changes
  - DeviceDiscovery: scan and identify supported LED devices
Supported protocols:
  - Generic BLE RGB LEDs (common Chinese brands)
  - Govee (documented GATT services)
  - Any device with standard color GATT characteristics
```

#### neom_rooms — Social frequency spaces
```
Purpose: Real-time social layer where frequencies are rooms
Contains:
  Models:
    - FrequencyRoom: id, frequency, user_count, ritual_state, config
    - RoomParticipant: user_id, join_time, device_capabilities, biometrics
    - ConnectionRequest: from, to, status, room_id
    - RoomMessage: text, timestamp, fade_duration (for resonant text mode)
  Services:
    - RoomPresenceService: WebSocket/Firebase Realtime join/leave/count
    - RoomDiscoveryService: list/trending/nearby rooms
    - ConnectionService: request/accept/decline calls
    - RoomSyncService: synchronize frequency state across participants
  States:
    - idle: room exists, users listening independently
    - active: ritual in progress, devices synchronized
    - group_ceremony: scheduled event, all participants locked in
  Interaction modes:
    - silent_presence: no communication, just shared awareness
    - resonant_text: messages appear and fade at room frequency rhythm
    - synchronized_call: WebRTC voice + device sync
  Shareable URLs:
    - /room/{frequency_id} → enter room directly
    - /room/{frequency_id}/join → deeplink into app or web
```

#### neom_ritual_composer — Experience builder
```
Purpose: Create, edit, save, share multi-layer frequency experiences
Contains:
  Models:
    - Ritual: name, description, duration, layers[], shareable_url
    - RitualLayer: type (audio/light/haptic), events[]
    - RitualEvent: start_time, duration, frequency, amplitude, target_device
    - RitualTemplate: predefined ritual configurations
  Services:
    - RitualPlayerService: executes ritual timeline across all layers
    - RitualComposerService: CRUD operations on rituals
    - RitualSharingService: generate/resolve shareable URLs
    - RitualLibraryService: community-shared rituals
  Predefined templates:
    - first_contact: binaural 10Hz alpha + screen strobe (onboarding)
    - deep_meditation: theta progression 7Hz → 4Hz over 20 min
    - focus_boost: gamma 40Hz audio + 40Hz light flicker
    - sleep_preparation: beta → alpha → theta → delta descent
    - group_ceremony_432: 432Hz base with harmonic overtones
    - object_resonance_scan: frequency sweep with mic feedback
    - body_frequency_bath: multi-speaker standing wave patterns
```

#### neom_sync — Real-time communication
```
Purpose: Device synchronization and user-to-user real-time connection
Contains:
  - SyncEngine: master clock for multi-device timing
  - WebSocketService: room presence, state broadcasting
  - WebRTCService: peer-to-peer voice + data channels
  - DeviceSyncProtocol: ensure speakers/lights fire at correct phase
  - MultiUserSync: coordinate ritual playback across participants
  - LatencyCompensator: measure and compensate for device response delay
```

#### neom_biofeedback — Sensor integration (optional/future)
```
Purpose: Read biometric data and adapt experiences in real-time
Contains:
  - HeartRateService: smartwatch BLE heart rate characteristic
  - HRVAnalyzer: heart rate variability computation
  - BreathingDetector: microphone-based breathing pattern recognition
  - MotionAnalyzer: accelerometer stillness/movement detection
  - AdaptiveController: modifies ritual parameters based on bio input
  - GroupBiometricSync: visualize and synchronize multiple heartbeats
```

---

## PHASE 3: SCREEN ORGANIZATION

### Mobile screens (app)
```
screens/
├── home/
│   └── FrequencySpectrumHome    → Horizontal scrollable spectrum with room activity
├── rooms/
│   ├── RoomListScreen           → Browse active rooms with user counts
│   ├── RoomDetailScreen         → Inside a room: frequency viz + users + modes
│   └── RoomCallScreen           → Active synchronized call with another user
├── rituals/
│   ├── RitualPlayerScreen       → Full-screen immersive experience
│   ├── RitualComposerScreen     → Simple vertical timeline editor
│   └── RitualLibraryScreen      → Browse/search community rituals
├── devices/
│   ├── DeviceManagerScreen      → List connected BLE devices
│   └── DeviceSpatialMapScreen   → Position devices in room (simple 2D)
├── experiences/
│   ├── FirstContactScreen       → Onboarding ritual (full-screen, no chrome)
│   ├── FrequencyExplorerScreen  → Educational: pick frequency, hear it, see wave
│   ├── BrainwaveSelectorScreen  → Pick mental state, get binaural preset
│   ├── ResonanceScannerScreen   → Point phone at object, find resonance
│   └── BreathingSyncScreen      → Breathing + frequency guidance
└── profile/
    └── UserProfileScreen        → Stats, history, favorites, subscription
```

### Web screens (www.cyberneom.xyz) — DIFFERENT ORGANIZATION
```
web_screens/
├── landing/
│   └── LandingPage              → Hero: frequency spectrum map (large)
│                                  Sidebar: trending rooms, user count, CTA
│                                  Bottom: featured rituals, testimonials
├── first_contact/
│   └── FirstContactPage         → Full-screen, no navigation, standalone URL
│                                  /first-contact (works without login)
│                                  Larger screen = more intense light field
├── rooms/
│   ├── RoomBrowserPage          → Wide grid/list: rooms with activity viz
│   │                              Filter by: frequency range, user count, state
│   │                              Map view: geographic distribution of users
│   └── RoomPage                 → Three-column layout:
│                                  Left: participants + presence
│                                  Center: large frequency visualization
│                                  Right: interaction panel (chat/call controls)
│                                  URL: /room/{frequency_id}
├── composer/
│   └── RitualComposerPage       → DAW-style interface (web exclusive layout):
│                                  Top bar: device spatial map (drag & drop in 2D room)
│                                  Center: multi-track timeline
│                                    Track 1: audio frequencies
│                                    Track 2: light patterns
│                                    Track 3: haptic events
│                                    Track 4: biometric triggers
│                                  Bottom: property inspector panel
│                                  Sidebar: component library (drag onto timeline)
├── player/
│   └── RitualPlayerPage         → Full-screen immersive
│                                  Uses entire monitor as light source
│                                  Keyboard shortcuts for control
├── dashboard/
│   └── AnalyticsDashboardPage   → Personal stats + community frequency data
│                                  Heat map: which frequencies, when, how many
│                                  Session history with biometric overlay
├── shared/
│   └── SharedRitualPage         → /r/{ritual_id} — standalone shareable page
│                                  No login required to experience
│                                  CTA to create account after experience
└── devices/
    └── DeviceDashboardPage      → Grid: all connected devices
                                   Large spatial map: device positions in room
                                   Real-time status: connection, battery, signal
                                   Web Bluetooth pairing interface
```

### Responsive breakpoints
```
- Mobile: < 768px → Mobile layout (single column)
- Tablet: 768-1024px → Hybrid (some panels collapse)
- Desktop: > 1024px → Full web layout (multi-column, DAW composer)
- Use LayoutBuilder or MediaQuery to switch
- Share widgets between mobile/web, swap layout wrappers
```

---

## PHASE 4: SUGGESTED EXPERIENCES (implement these)

### Level 1 — Phone only (FREE tier)
| # | Name | Description | Hardware | Frequency |
|---|------|-------------|----------|-----------|
| 1 | First Contact | Binaural 10Hz alpha + screen strobe through closed eyelids. User sees geometric patterns in 2-3 min. THE onboarding experience. | Phone + earphones | 200Hz L / 210Hz R = 10Hz |
| 2 | Frequency Explorer | Pick any frequency, hear it, see waveform. Educational tool. | Phone speaker | User-selected |
| 3 | Brainwave Selector | Choose desired state (focus/relax/sleep/meditate), get appropriate binaural preset | Phone + earphones | Varies by state |
| 4 | Object Resonance Scanner | Sweep frequencies via speaker, detect resonance with mic. Glass of water forms patterns. | Phone speaker + mic | Sweep 20Hz-20kHz |
| 5 | Breathing Sync | Frequency rises/falls with breathing rhythm. Visual + audio guide | Phone | 4-12Hz modulation |

### Level 2 — With BLE speakers (PRO tier)
| # | Name | Description | Hardware | Frequency |
|---|------|-------------|----------|-----------|
| 6 | Body Frequency Bath | Standing waves from multiple speakers. Feel vibration in specific body areas. | 2+ BLE speakers | 20-200Hz |
| 7 | Spatial Sound Focus | Map speakers in room, create audio focal point at user position | 2+ speakers | Calculated per geometry |
| 8 | Infrasound Presence | 18.98Hz through subwoofer. Sensation of invisible presence in room. | Subwoofer | 18.98Hz |
| 9 | Chladni Patterns | Speaker under plate with sand creates visible geometric patterns | Speaker + plate + sand | 100-2000Hz |

### Level 3 — With BLE lights (PRO tier)
| # | Name | Description | Hardware | Frequency |
|---|------|-------------|----------|-----------|
| 10 | Chromatic Sync | Room lights pulse in sync with audio. Color mapped to frequency band. | BLE LED lights | Synced to audio |
| 11 | Aurora Mode | Slow color waves through lights + deep theta audio | Multiple BLE lights | 4-7Hz theta |
| 12 | Gamma Focus Chamber | 40Hz flicker + 40Hz audio = concentration boost (Alzheimer's research basis) | Lights + speakers | 40Hz |
| 13 | Circadian Reset | Graduated color temperature + frequency progression for sleep prep | BLE lights | Beta→Alpha→Theta→Delta |

### Level 4 — With wearables (PRO tier)
| # | Name | Description | Hardware | Frequency |
|---|------|-------------|----------|-----------|
| 14 | Heart Coherence | Read heart rate, generate frequency to guide coherent rhythm | Smartwatch BLE | Adaptive to HR |
| 15 | Stress Dissolve | Monitor HRV, adaptively shift beta → alpha → theta | Smartwatch BLE | Adaptive to HRV |

### Level 5 — Multi-user neom_rooms (PRO tier)
| # | Name | Description | Hardware | Frequency |
|---|------|-------------|----------|-----------|
| 16 | Group Meditation | Multiple users synced, heartbeats visualized, shared frequency | Phones + optional wearables | Room frequency |
| 17 | Resonance Match | Two strangers share synchronized experience before speaking | Phones | Room frequency |
| 18 | Distributed Ceremony | Scheduled global events (full moon 432Hz, etc.) with live participant count | Phones | Event frequency |
| 19 | Frequency DJ | One host controls mix for all room participants | Host: full setup | Host-controlled |

---

## PHASE 4B: STATE LINKS — The Marketing Engine

### Concept: Every link IS the product

Cyberneom's primary marketing is NOT ads, NOT app store descriptions. It's **direct experience links** where each URL points to a specific desired state. The person clicks, puts on headphones, closes eyes, and FEELS the result. No registration, no explanation, no download. The link is the ad.

### URL Structure

```
Web:     cyberneom.xyz/x/{state_id}
Web alt: cyberneom.xyz/x/{state_id}?lang={en|es|fr|de}&ref={source}
Mobile:  cyberneom://x/{state_id}
```

The `/x/` prefix means "experience". Short, clean, memorable, shareable.

Universal Links (iOS) + App Links (Android): if app is installed, opens there. If not, falls back to web. Zero friction either way.

### State Links Catalog

Implement ALL of these as standalone, zero-registration experiences:

#### Core states (Priority 1 — implement first)

| State ID | Name (EN) | Name (ES) | Name (FR) | Name (DE) | Frequency | Duration | Description |
|----------|-----------|-----------|-----------|-----------|-----------|----------|-------------|
| `sleep` | Deep Sleep | Sueño Profundo | Sommeil Profond | Tiefschlaf | Delta 3Hz binaural (150Hz L / 153Hz R) | 20 min | Screen: dark blue slow pulse. Descends from alpha→theta→delta. For insomnia. |
| `focus` | Deep Focus | Enfoque Total | Concentration | Fokus | Gamma 40Hz binaural (400Hz L / 440Hz R) | 25 min | Screen: subtle white pulse. Sustained gamma for study/work. |
| `calm` | Calm Down | Calma | Calme | Ruhe | Alpha 10Hz descending to theta 6Hz | 10 min | Screen: warm amber, decelerating pulse. For anxiety relief. |
| `meditate` | Deep Meditation | Meditación Profunda | Méditation | Meditation | Theta 7Hz binaural (200Hz L / 207Hz R) | 15 min | Screen: off/minimal. Pure sound experience. For experienced meditators. |
| `energy` | Wake Up | Energía | Énergie | Energie | Beta 20Hz ascending to gamma 35Hz | 8 min | Screen: bright warm light, accelerating pulse. Morning or pre-workout. |
| `first-contact` | First Contact | Primer Contacto | Premier Contact | Erstkontakt | Alpha 10Hz binaural (200Hz L / 210Hz R) + screen strobe | 5 min | THE onboarding experience. User sees mandalas/fractals with closed eyes. Viral hook. |

#### Extended states (Priority 2)

| State ID | Name (EN) | Frequency | Duration | Description |
|----------|-----------|-----------|----------|-------------|
| `create` | Creative Flow | Theta-Alpha border 7.5Hz | 20 min | For musicians, writers, artists. Ideas flow state. |
| `relief` | Pain Relief | Alpha stable 10Hz | 15 min | Entrainment alpha reduces pain perception. Soft tone. |
| `presence` | The Presence | Infrasound 18.98Hz (requires speakers) | 10 min | Sensation of invisible presence in room. For adventurers. |
| `lucid` | Lucid Dreaming | Theta 5Hz with gamma bursts 40Hz | 30 min | Pre-sleep protocol for lucid dream induction. |
| `heart` | Heart Sync | 7.83Hz (Schumann resonance) | 12 min | Earth's electromagnetic frequency. Grounding experience. |
| `432` | Universal Harmony | 432Hz pure tone + harmonics | 15 min | The "universe frequency". Popular in wellness communities. |
| `528` | DNA Repair | 528Hz pure tone + harmonics | 15 min | Solfeggio frequency. Massive search volume in wellness niche. |

### State Link UX Flow

Each state link follows this EXACT flow — no exceptions:

```
STEP 1 — Landing (0-5 seconds)
┌─────────────────────────────────┐
│                                 │
│   [Icon for the state]          │
│                                 │
│   "Deep Focus"                  │
│   "40Hz Gamma Enhancement"      │
│                                 │
│   🎧 Put on headphones          │
│   👁 Close your eyes             │
│                                 │
│   [ ▶ Begin ]                   │
│                                 │
│   ⚡ 12,847 people tried this   │
│      today                      │
│                                 │
└─────────────────────────────────┘
- Language auto-detected from browser or ?lang= param
- No login, no menu, no navigation, no distractions
- Social proof counter (total uses) builds trust
- One single button

STEP 2 — Experience (duration varies by state)
┌─────────────────────────────────┐
│                                 │
│   [Full screen color/pulse      │
│    matching the state]          │
│                                 │
│   Minimal timer at bottom       │
│   Tap to pause/stop             │
│                                 │
└─────────────────────────────────┘
- Audio starts with 3-second fade in
- Screen becomes the light therapy device
- On web desktop: full browser tab = large light field
- On mobile: suggest "place phone face-up on eyes" for strobe effect
- NO interruptions, NO notifications overlay

STEP 3 — Afterglow (post-experience)
┌─────────────────────────────────┐
│                                 │
│   "How do you feel?"            │
│                                 │
│   😌  😊  🤯  😴               │
│                                 │
│   [ Share this experience ]     │
│   [ Explore more states ]       │
│                                 │
│   ─── or ───                    │
│                                 │
│   "Right now, 234 people are    │
│    in the Focus room"           │
│   [ Join them → PRO ]           │
│                                 │
└─────────────────────────────────┘
- Quick emotion feedback (one tap, anonymous, builds data)
- Share generates a pre-formatted message with the link
- "Explore more" shows the full state catalog — SOME locked as PRO
- Room presence creates FOMO and social pull toward PRO
- This is the ONLY moment any paywall appears
```

### Free vs PRO state links

```
FREE (always, unlimited):
  - /x/first-contact (the viral hook, never gate this)
  - /x/sleep (highest demand, brings people back)
  - /x/focus (second highest demand)
  - /x/calm (third highest demand)
  All free states: limited to 1 session per state per day after first use

PRO ($3 USD/month — unlocks everything):
  - All states unlimited
  - /x/meditate, /x/energy, /x/create, /x/relief
  - /x/presence, /x/lucid, /x/heart, /x/432, /x/528
  - Custom frequency input (create your own state)
  - neom_rooms access (see people, connect, call)
  - BLE device connection (lights, speakers)
  - Ritual composer
```

### Technical implementation for state links

```dart
// Router configuration (GoRouter or GetX — match project pattern)
// These routes work identically on web and mobile

/x/:stateId          → StateExperienceScreen(stateId)
/x/:stateId?lang=xx  → auto-set locale before rendering
/x/:stateId?ref=xx   → track source in analytics

// StateExperienceScreen is a STANDALONE screen
// - No app shell (no bottom nav, no drawer, no app bar)
// - Full screen, immersive mode
// - Works without authentication
// - Self-contained: loads its own audio engine, color config, timer
// - On completion: shows afterglow screen with paths to main app

// State configuration model
class FrequencyState {
  final String id;              // 'sleep', 'focus', etc.
  final Map<String, String> names;  // {'en': 'Deep Sleep', 'es': 'Sueño Profundo', ...}
  final double leftFrequency;   // Hz for left ear
  final double rightFrequency;  // Hz for right ear (difference = binaural beat)
  final double binauralBeat;    // computed: right - left
  final Duration duration;
  final Color screenColor;
  final double pulseFrequency;  // Hz for screen strobe
  final List<FrequencyPhase> phases;  // timeline of frequency changes
  final bool requiresSpeakers;  // true for infrasound states
  final bool isPro;
}

// Phase model for states that change over time (e.g., sleep descends frequencies)
class FrequencyPhase {
  final Duration startAt;
  final Duration transitionDuration;  // fade between phases
  final double leftFrequency;
  final double rightFrequency;
  final Color screenColor;
  final double pulseFrequency;
}
```

### Universal Links / App Links configuration

```
// iOS: apple-app-site-association (serve from cyberneom.xyz/.well-known/)
{
  "applinks": {
    "apps": [],
    "details": [{
      "appID": "TEAM_ID.com.cyberneom.app",
      "paths": ["/x/*", "/room/*", "/r/*"]
    }]
  }
}

// Android: assetlinks.json (serve from cyberneom.xyz/.well-known/)
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.cyberneom.app",
    "sha256_cert_fingerprints": ["YOUR_SHA256"]
  }
}]

// Flutter: Handle incoming links
// GoRouter or GetX will parse /x/{stateId} identically on web and mobile
```

### Analytics per state link

```
Track for EACH state link:
  - unique_opens: how many people opened the link
  - source: ?ref= parameter (reddit-insomnia, twitter-organic, etc.)
  - language: browser locale or ?lang= param
  - platform: web-desktop, web-mobile, app-android, app-ios
  - started: tapped "Begin"
  - completed: reached end of experience
  - completion_rate: completed / started (TARGET: >60%)
  - emotion_response: distribution of 😌😊🤯😴 taps
  - shared: tapped "Share"
  - explored_more: tapped "Explore more states"
  - converted_pro: signed up for PRO from afterglow screen
  - returned_24h: came back within 24 hours
  - returned_7d: came back within 7 days

Key metrics to optimize:
  - open → start rate (is the landing compelling?)
  - start → complete rate (is the experience good?)
  - complete → share rate (was it share-worthy?)
  - complete → pro rate (is the upsell working?)
```

### Distribution strategy per state link

```
/x/sleep:
  - Reddit: r/insomnia, r/sleep, r/sleephacks
  - Search: "can't sleep", "natural sleep aid", "insomnia help"
  - YouTube: comments on sleep music videos
  - Languages: all 4 (universal problem)

/x/focus:
  - Reddit: r/productivity, r/ADHD, r/GetStudying, r/getdisciplined
  - Search: "study focus music", "concentration help", "ADHD focus"
  - Discord: student servers, dev servers
  - Languages: EN priority (largest student market)

/x/calm:
  - Reddit: r/anxiety, r/mentalhealth, r/stressed
  - Search: "anxiety relief", "calm down quickly", "stress relief"
  - Languages: all 4

/x/first-contact:
  - TikTok/Instagram: video of someone reacting to closed-eye visuals
  - Reddit: r/woahdude, r/interestingasfuck, r/neuroscience
  - Twitter: "try this and tell me what you saw"
  - YouTube: demo video with link in description
  - Languages: EN first (viral potential), then others

/x/432 and /x/528:
  - YouTube: massive existing audience searching "432Hz music"
  - Reddit: r/soundhealing, r/frequency, r/energy_work
  - Search: "432Hz meditation", "528Hz healing frequency"
  - Languages: EN and DE (big wellness markets)

/x/presence:
  - Reddit: r/paranormal, r/HighStrangeness, r/Glitch_in_the_Matrix
  - YouTube: paranormal/mystery channels
  - Framing: "scientists discovered 18.98Hz makes you feel a presence — try it"
  - Languages: EN (largest paranormal community)
```

---

## PHASE 5: IMPLEMENTATION ORDER

```
Priority 1 (Foundation + State Links — THE GROWTH ENGINE):
  → neom_frequency_engine (math/calculation core)
  → neom_audio_orchestrator (platform-adaptive audio)
  → State Links system:
    → FrequencyState model with all state configurations
    → StateExperienceScreen (standalone, full-screen, no-auth)
    → State link routing: /x/{stateId} working on web AND mobile
    → Landing step (headphones prompt + begin button)
    → Experience step (audio + screen pulse)
    → Afterglow step (emotion feedback + share + explore + PRO upsell)
    → 4-language support for all state names and UI text
  → Implement core states: first-contact, sleep, focus, calm
  → Universal Links config (iOS) + App Links config (Android)
  → Basic analytics tracking per state link
  → Share functionality (generate pre-formatted message with link)

Priority 2 (Extended States + Social):
  → Implement extended states: meditate, energy, create, relief, 432, 528
  → neom_rooms (models + presence + user count)
  → neom_sync (WebSocket for room presence)
  → Room browser screen (web + mobile)
  → Connect afterglow screen to rooms ("234 people in Focus room")
  → PRO paywall integration

Priority 3 (Devices):
  → neom_light_orchestrator (extend neom_ble)
  → Web Bluetooth integration
  → Device Manager screens
  → Chromatic Sync (experience #10)
  → /x/presence state (requires speakers — infrasound)

Priority 4 (Composer):
  → neom_ritual_composer
  → Ritual Player (web + mobile)
  → Ritual Composer (DAW-style for web)
  → Template rituals (#6-13)
  → Shareable ritual links: /r/{ritual_id}

Priority 5 (Advanced):
  → neom_sync (WebRTC for calls)
  → neom_biofeedback
  → Group experiences (#14-19)
  → Analytics dashboard
  → /x/lucid, /x/heart states
```

---

## EXECUTION RULES FOR CLAUDE CODE

1. **ALWAYS analyze existing code first** — never assume what exists
2. **Follow existing project patterns** — match state management, naming, architecture
3. **Create real implementations** — not stubs or TODOs
4. **Ensure web compatibility** — use conditional imports, check dart:html availability
5. **Each module must be independently testable** — abstract interfaces, dependency injection
6. **Generate ORCHESTRATION_ARCHITECTURE.md** — master document linking everything
7. **Ask before large changes** — confirm module structure before generating 50+ files
8. **One module at a time** — complete each before starting the next
9. **Web screens are DIFFERENT from mobile** — don't just make mobile screens responsive, design distinct layouts for web that leverage the larger screen
10. **The First Contact experience is the #1 priority** — it's the viral hook, it must work perfectly on both web and mobile with zero hardware requirements
11. **State links are the growth engine** — every /x/{stateId} URL must work as a STANDALONE experience: no auth, no app shell, no navigation chrome. Landing → Experience → Afterglow. That's it.
12. **State links must work on web AND mobile identically** — same route, same screen, different layout via LayoutBuilder. The URL cyberneom.xyz/x/sleep must work in any browser without installing anything.
13. **4 languages from day one** — all state names, UI strings in the state experience screens must support EN, ES, FR, DE. Use the project's existing i18n pattern (check if GetX translations, intl package, or ARB files).
14. **Analytics on every state link** — track opens, starts, completions, shares, and PRO conversions. Use the ?ref= parameter for source tracking.
15. **The afterglow screen is the ONLY place the paywall appears** — never interrupt the experience itself. The person must feel something FIRST, then see the upsell.
