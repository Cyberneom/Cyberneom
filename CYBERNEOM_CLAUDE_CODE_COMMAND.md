# CYBERNEOM — Frequency Orchestration System: Planning & Implementation

## COMMAND FOR CLAUDE CODE TERMINAL

Copy and paste the following command in your Claude Code terminal. It is a single `claude` command with a multi-line prompt using heredoc:

---

```bash
claude "
## CONTEXT

Cyberneom is a Flutter ecosystem (app + web at www.cyberneom.xyz) focused on neurotechnology, meditation, and cybernetic experiences. It is evolving into a FREQUENCY ORCHESTRATION PLATFORM that controls multiple devices (sound, light, haptics) to create coordinated frequency-based experiences. The web version uses Flutter Web and must have a different screen organization than mobile.

The project uses a modular multirepo architecture with modules inside neom_modules/. One existing module is neom_ble for Bluetooth Low Energy.

---

## PHASE 1: ANALYSIS (Do this FIRST before creating anything)

### 1.1 — Scan existing modules
- List ALL directories inside neom_modules/
- For each module, read its pubspec.yaml and main export file
- Identify: module name, purpose, dependencies, exported classes
- Map relationships between modules (which depends on which)
- Pay special attention to neom_ble: analyze its full structure, services, controllers, and BLE communication patterns already implemented
- Check if there are existing audio, frequency, room, or WebRTC related modules
- Check for existing WebSocket or real-time communication implementations
- Output a COMPLETE inventory of what exists before suggesting anything new

### 1.2 — Identify what can be reused vs what needs to be created
- Which existing modules can be extended?
- Which new modules are absolutely necessary?
- Are there shared utilities or base classes that should be in a common module?

---

## PHASE 2: ARCHITECTURE PLANNING

### 2.1 — New modules needed (suggest after analysis)

Based on the conversation history, Cyberneom needs these capabilities. Map them to new or existing modules:

#### A) neom_frequency_engine (Core frequency calculation engine)
- WaveformGenerator: sine, square, triangle, sawtooth, Bessel patterns
- HarmonicCalculator: octave relationships, fifths, thirds, sacred frequencies (432Hz, 528Hz, etc.)
- PhaseController: millisecond-precision phase synchronization across devices
- GeometryMapper: spatial positioning of devices for interference pattern calculation
- FrequencyPresets: theta (4-8Hz), alpha (8-13Hz), beta (13-30Hz), gamma (30-100Hz), delta (0.5-4Hz)
- BinauralBeatGenerator: left/right ear frequency differential calculation

#### B) neom_audio_orchestrator (Sound layer)
- Platform-adaptive: Web Audio API (OscillatorNode, AudioContext) for web, existing surround_frequency_generator patterns for mobile
- Multi-speaker coordination with individual frequency/phase/amplitude per device
- Binaural beat generation with spatial audio
- Infrasound generation (18-19Hz range) for physical sensation effects
- Frequency sweep/scan capabilities (for object resonance detection)
- Audio analysis via microphone (FFT for resonance feedback)

#### C) neom_light_orchestrator (Light layer via BLE)
- Extends neom_ble for LED device discovery and control
- GATT protocol handlers for common BLE LED brands (Govee, generic Chinese, Philips Hue BLE)
- Color-to-frequency mapping (light frequency THz to visible color)
- Strobe/pulse patterns synchronized with audio frequencies
- Web Bluetooth API integration for Flutter web
- Brainwave entrainment light patterns (alpha, theta, gamma pulsing)

#### D) neom_rooms (Social frequency spaces)
- FrequencyRoom model: frequency_id, active_users, user_count, ritual_state, room_config
- Presence system: WebSocket/Firebase Realtime for join/leave/broadcast count
- Room discovery: list active rooms, trending rooms, nearby rooms (geolocation)
- Connection layer: send/accept/decline call requests between users in same room
- Three interaction modes: silent_presence, resonant_text (messages that pulse and fade), synchronized_call
- Room states: idle, active, group_ceremony
- Shareable room links: cyberneom.xyz/room/{frequency_id}

#### E) neom_ritual_composer (Experience builder)
- Timeline sequencer: time-based events for frequency changes, light patterns, audio transitions
- Ritual templates: meditation, concentration, healing, sleep, group_ceremony, first_contact
- Sacred geometry patterns: spatial configurations for device placement
- Multi-layer composition: audio + light + haptics synchronized on timeline
- Export/import rituals as shareable configurations
- Community ritual library

#### F) neom_sync (Real-time synchronization)
- WebRTC for peer-to-peer audio/data in calls
- WebSocket for room presence and state broadcasting
- Device synchronization protocol: ensure all devices (speakers, lights) fire at correct phase offset
- Multi-user ritual sync: coordinate frequency changes across all participants
- Heartbeat sync visualization (if wearable data available)

#### G) neom_biofeedback (Optional sensor layer)
- Wearable integration: smartwatch heart rate, HRV
- Microphone-based: breathing detection, voice frequency analysis
- Accelerometer: movement/stillness detection for meditation states
- Adaptive rituals: modify frequencies in real-time based on biometric input

### 2.2 — Web vs Mobile screen organization

#### MOBILE (app) screens:
- Home: Frequency spectrum visualization (horizontal scroll) showing active rooms with user counts
- Room View: Full-screen frequency visualization + user count + interaction mode selector
- Ritual Player: Full-screen immersive experience (frequency viz + timer + controls)
- Ritual Composer: Vertical timeline editor (simplified for mobile)
- Device Manager: List of connected BLE devices with status
- Profile: User stats, favorite frequencies, ritual history
- First Contact: Onboarding ritual experience (full-screen, no distractions)

#### WEB (www.cyberneom.xyz) screens:
- Landing/Home: Split layout — left side: frequency spectrum map (large, interactive), right side: trending rooms + user activity
- Room View: Wide layout — center: large frequency visualization, left panel: user list + presence count, right panel: chat/interaction modes
- Ritual Composer: Professional DAW-like interface — top: device spatial map (drag & drop), center: multi-track timeline (audio, light, haptics as separate lanes), bottom: property editor
- Ritual Player: Full-screen immersive (same concept as mobile but uses larger screen for more intense light effects)
- Device Dashboard: Grid layout showing all connected devices with real-time status, spatial position map
- Analytics/Research: Data visualization of community frequency usage, personal session history
- First Contact: Full-screen experience optimized for large screens (bigger light field for closed-eye effects)
- Shareable ritual pages: cyberneom.xyz/r/{ritual_id} — standalone pages that work without login

### 2.3 — Suggested user experiences to implement

#### LEVEL 1 — Solo, phone only (FREE)
1. **First Contact Ritual**: Binaural beats (200Hz left, 210Hz right = 10Hz alpha) + screen pulsing warm light at 10Hz through closed eyelids. Duration: 5 minutes. User sees geometric patterns, mandalas, fractals. Zero hardware needed.
2. **Frequency Explorer**: Simple frequency generator with visualization. User picks a frequency, hears it, sees the waveform. Educational and interactive.
3. **Brainwave Selector**: Presets for theta/alpha/beta/gamma with explanation of each state. User picks desired mental state, app generates appropriate binaural beat.
4. **Object Resonance Scanner**: Uses phone speaker to sweep frequencies while microphone detects resonance peaks. User points phone at a glass of water and finds its resonance frequency. Water visibly vibrates.
5. **Breathing Sync**: Generates a frequency that rises and falls with suggested breathing pattern. Visual + audio guidance.

#### LEVEL 2 — With BLE speakers (PRO)
6. **Body Frequency Bath**: Multiple speakers create standing waves. User feels frequencies physically in different body parts depending on position.
7. **Spatial Audio Mapping**: User maps speaker positions in room. App calculates interference patterns and creates focused sound at specific points.
8. **Infrasound Presence**: 18.98Hz through subwoofer creates sensation of invisible presence. Controlled, safe, fascinating.
9. **Chladni Patterns**: Speaker under a plate with sand/salt creates visible geometric patterns at different frequencies. App guides user through frequencies.

#### LEVEL 3 — With BLE lights (PRO)
10. **Chromatic Frequency Sync**: Room lights pulse in sync with audio frequencies. Color mapped to frequency band.
11. **Aurora Mode**: Slow-moving color waves through multiple lights synchronized with deep theta audio.
12. **Gamma Focus Chamber**: 40Hz light flicker + 40Hz audio = intense concentration enhancement (researched for Alzheimer's therapy).
13. **Circadian Reset**: Graduated light color temperature shifts synced with specific frequency progressions.

#### LEVEL 4 — With wearables (PRO)
14. **Heart Coherence Trainer**: Reads heart rate, generates frequency to guide heart into coherent rhythm.
15. **Stress Dissolve**: Monitors HRV, adaptively adjusts frequencies to shift from beta to alpha to theta.

#### LEVEL 5 — Multi-user via neom_rooms (PRO)
16. **Group Meditation Sync**: Multiple users in same room, heartbeats visualized, frequencies synchronized.
17. **Resonance Matchmaking**: Two strangers in same frequency room start synchronized experience before speaking.
18. **Distributed Ceremony**: Scheduled group rituals (e.g., full moon 432Hz ceremony) with real-time participant count and shared visualization.
19. **Frequency DJ**: One user hosts and controls the frequency mix for all participants in a room.

---

## PHASE 3: IMPLEMENTATION PLAN

### 3.1 — Create module structure
For each new module:
- Create directory in neom_modules/
- Generate pubspec.yaml with proper dependencies
- Create lib/ structure with models, services, controllers
- Create abstract interfaces so modules can be tested independently
- Ensure web compatibility where needed (conditional imports for dart:html vs dart:io)

### 3.2 — Priority order
1. neom_frequency_engine (foundation for everything)
2. neom_audio_orchestrator (core experience)
3. neom_rooms (social layer)
4. neom_sync (real-time communication)
5. neom_light_orchestrator (extends neom_ble)
6. neom_ritual_composer (experience builder)
7. neom_biofeedback (enhancement layer)

### 3.3 — Web-specific considerations
- Use conditional imports: import 'audio_service_stub.dart' if (dart.library.html) 'audio_service_web.dart' if (dart.library.io) 'audio_service_mobile.dart'
- Web Audio API access via dart:js_interop or js package
- Web Bluetooth API access via dart:js_interop
- Responsive layouts: use LayoutBuilder to detect web vs mobile and render different screen organizations
- Web routes must be clean URLs for shareability: /room/432hz, /r/theta-healing, /first-contact

### 3.4 — For each module, generate:
- README.md with purpose and API overview
- Models (data classes with freezed/json_serializable if pattern exists in project)
- Services (business logic)
- Controllers (state management matching project pattern — check if GetX, Riverpod, Bloc, etc.)
- Platform-specific implementations where needed
- Example usage

---

## INSTRUCTIONS FOR CLAUDE CODE

1. START by analyzing neom_modules/ completely. Do NOT skip this step.
2. Present findings: what exists, what's reusable, what's missing.
3. Propose adjusted module plan based on what you found (maybe some modules already partially exist).
4. Ask for confirmation before generating code.
5. Generate modules in priority order, one at a time.
6. For each module, create the full structure with real implementation code, not just stubs.
7. Ensure every file has proper imports and exports.
8. Create a master ORCHESTRATION_ARCHITECTURE.md document summarizing everything.
9. Pay attention to the state management pattern already used in the project and follow it.
10. Check if the project uses specific linting rules (analysis_options.yaml) and follow them.
"
```

---

## ALTERNATIVE: If your prompt is too long for a single command

You can also save this as a file and reference it:

```bash
# Save the plan first, then reference it
claude "Read the file CYBERNEOM_PLAN.md in the project root and execute the plan described there. Start with Phase 1: analyzing all existing modules in neom_modules/ before creating anything new. The plan includes state links (/x/{stateId}) as the primary growth engine — these are standalone experience URLs that work without auth on both web and mobile. Pay special attention to Phase 4B."
```

---

## TIPS FOR EXECUTION

- **If Claude Code hits context limits**: Break into phases. Run Phase 1 first, save output, then start Phase 2 in a new session referencing the Phase 1 output.
- **For very long tasks**: Use `claude --continue` to resume if the session breaks.
- **To keep Claude Code focused**: Add `--verbose` flag to see what it's doing at each step.
- **If modules are in a different path**: Adjust `neom_modules/` to the actual path in your project structure.
