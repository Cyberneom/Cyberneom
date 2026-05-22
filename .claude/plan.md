# Cyberneom Development Plan

## Vision
Cyberneom is a multimodal consciousness technology platform — audio (binaural beats) + visual (generative experiences) + biofeedback (voice frequency detection). The user's vocal frequency is the seed that personalizes every session, making each experience unique and unrepeatable.

## Current State (March 2026)
- **Camara Neom**: Frequency generator with voice pitch detection, binaural beats, breathing sync, oscilloscope, coherence meter, Lissajous curves
- **13 Frequency States**: Binaural beat protocols mapped to EEG bands (Delta→Gamma) with photic driving
- **5 Neom Experiences**: NeuroFlocking, Neuro Breathing, Fractals, Neomatics (Chladni), NeuroMandala
- **Supporting modules**: neom_biofeedback, neom_historic_state, neom_par, neom_sound
- **Architecture**: Clean module separation via abstract interfaces in neom_core (NeuroStateService, NeuroStateSnapshot, NeomNeuroState)

---

## Phase 1: First Impression (Priority: NOW)
**Goal**: A new visitor understands and FEELS the product in 60 seconds.

### 1.1 Web Home Onboarding Overlay ← START HERE
- [ ] Full-screen overlay on first visit (Hive flag `cyberneom_onboarded`)
- [ ] 3-step flow:
  1. **"Descubre tu frecuencia"** — Mic permission → 5-second voice capture → show detected Hz with animation
  2. **"Siente el sonido"** — Auto-play binaural beat tuned to their frequency, visual experience (NeuroFlocking) reacting in real-time, 15 seconds
  3. **"Elige tu estado"** — Show 4 free states (First Contact, Sleep, Focus, Calm) as cards → tap to start full experience
- [ ] Skip button always visible ("Explorar primero")
- [ ] Mobile: same flow but adapted to portrait
- [ ] Store detected frequency in Hive for returning visitors

### 1.2 Camara Neom as Hero
- [ ] Left sidebar: Camara Neom button with Om icon, gradient accent, visually distinct from other menu items
- [ ] Home web: Camara Neom widget above the feed (compact mode — frequency display + "Iniciar" button)
- [ ] Quick-access bar on home showing 4-5 states as chips (already exists, verify it works)

### 1.3 Fix Critical Issues
- [ ] Fix Obx error in neom_generator_web_page.dart:557 (RxBool → .value)
- [ ] Fix detectedFrequency RxDouble → .value in controller:579
- [ ] Fix web pitch detection octave error (sample rate mismatch 48kHz vs 44.1kHz)
- [ ] Hide "Interfaz" sidebar item for non-admin (DONE)
- [ ] Hide ontological sidebar for non-admin (DONE)

---

## Phase 2: Visual States (Priority: HIGH)
**Goal**: States are no longer just pulsing colors — they become immersive visual experiences.

### 2.1 Experience Layer in States
- [ ] Add `visualExperience` optional parameter to `FrequencyState` model
- [ ] In `StateExperienceScreen`, offer visual mode toggle during experience
- [ ] Map states to default experiences:
  - Sleep → NeuroMandala (slow, contemplative geometry building)
  - Focus → Neomatics (Chladni patterns, sharp geometric precision)
  - Calm → Neuro Breathing (synchronized visual breathing)
  - First Contact → NeuroFlocking (organic, flowing, introductory)
  - Create → Fractals (infinite zoom, generative patterns)
  - Integration → NeuroMandala (sacred geometry, whole-brain coherence)
- [ ] User can switch experience during state (swipe gesture or menu)
- [ ] Experience receives NeuroStateSnapshot from state audio engine

### 2.2 State Catalog Redesign
- [ ] Cards show preview animation (3-second loop of the default experience)
- [ ] Pro states show blurred preview with lock icon
- [ ] Category grouping: Calm / Focus / Sleep / Advanced
- [ ] "Recommended for you" section based on time of day + history

### 2.3 Right Sidebar (Web)
- [ ] Experiences section: 5 experiences with route navigation (DONE for 3, add Neomatics + NeuroMandala)
- [ ] States section: Quick-start chips for all 13 states
- [ ] Active users count per state (real-time from StatePresenceService)

---

## Phase 3: Retention Loop (Priority: MEDIUM)
**Goal**: Users come back daily.

### 3.1 Daily Recommendation Engine
- [ ] Time-of-day mapping:
  - Morning (6-10): Focus/Energy states
  - Midday (10-14): Focus/Create states
  - Afternoon (14-18): Calm/Relief states
  - Evening (18-22): Calm/Meditate states
  - Night (22-6): Sleep/Lucid states
- [ ] "Estado recomendado" card on home, personalized by history
- [ ] Push notification (mobile) at user's preferred meditation time

### 3.2 Streaks & Gamification
- [ ] Streak counter visible on home (already in SessionHistoryService)
- [ ] Weekly summary: minutes meditated, states explored, consistency
- [ ] Achievement badges: First Session, 7-Day Streak, All States Explorer, 100 Sessions
- [ ] Integration with neom_learning: "Aprende por qué funciona" links in state descriptions

### 3.3 Session History Dashboard
- [ ] Calendar heatmap (like GitHub contributions) showing daily practice
- [ ] Emotion tracking over time (from afterglow feedback)
- [ ] Most used states, average session length, total hours
- [ ] Export/share session stats

---

## Phase 4: Social & Multiplayer (Priority: LOW)
**Goal**: Meditation is social.

### 4.1 Live Sessions
- [ ] StatePresenceService already tracks active users per state
- [ ] Show "X personas meditando ahora" on state cards
- [ ] Shared sessions: create a link, friends join same state simultaneously
- [ ] Real-time coherence comparison (if both have mic enabled)

### 4.2 Guided Content
- [ ] Integration with neom_releases for guided meditation audio (Album type)
- [ ] Instructor-led sessions: audio guide + binaural beat + visual experience
- [ ] Community-created state presets (custom frequencies + experience combos)

---

## Phase 5: B2B — PAR (Priority: FUTURE)
**Goal**: Corporate wellness product.

### 5.1 PAR Dashboard (neom_par)
- [ ] Already created: ReadinessAssessor, ConsistencyHeatmap, PercentileEngine
- [ ] Team admin dashboard: aggregate wellness metrics
- [ ] Daily 60-second readiness check (mic-based CV analysis)
- [ ] Tactical protocols: pre-meeting focus, post-meeting calm, deep work blocks

### 5.2 Enterprise Features
- [ ] SSO integration
- [ ] Usage analytics per team
- [ ] Custom state presets per organization
- [ ] Compliance reporting (HIPAA considerations for biometric data)

---

## Technical Debt
- [ ] Consolidate audio engines: neom_generator sine engine + neom_states audio service should share code
- [ ] Web audio: fix sample rate detection (use AudioContext.sampleRate)
- [ ] Performance: fractal experience needs optimization (currently slow on older devices)
- [ ] Testing: unit tests for pitch detection, binaural beat generation, state transitions
- [ ] Translations: complete DE/FR translations for neom_states, neom_experiences

---

## Module Dependency Map
```
neom_core (contracts)
├── NeomNeuroState enum + fromBinauralBeatHz()
├── NeuroStateService (abstract)
├── NeuroStateSnapshot (data class)
└── NeuroStateConsumer (mixin)

neom_generator (audio engine) ──implements──→ NeuroStateService
neom_experiences (visuals) ──consumes──→ Stream<NeuroStateSnapshot>
neom_states (protocols) ──creates──→ NeuroStateSnapshot.fromBinaural()
neom_biofeedback (sensors) ──feeds──→ NeuroStateSnapshot
neom_par (dashboard) ──reads──→ SessionHistoryService
```
No module imports another directly. All communication through neom_core abstractions.

---

## Metrics to Track
- **Activation**: % of new visitors who complete onboarding overlay
- **Retention**: D1/D7/D30 return rate
- **Session depth**: Average minutes per session
- **State diversity**: Unique states used per user per week
- **Conversion**: Free → Pro upgrade rate
- **NPS**: Post-session emotion feedback aggregation

---

Last updated: 2026-03-27
