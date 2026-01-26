# Modular Multirepo Architecture: Why I Chose Independent Repos Over Monorepos for My Flutter Ecosystem

*A pragmatic approach to sharing code across multiple apps without the overhead of monorepo tooling*

---

After years of building and maintaining multiple Flutter applications—Cyberneom (neurotechnology), Gigmeout (musicians platform), EMXI (writers community), and VRlizate (VR experiences)—I've developed an architecture that challenges the conventional wisdom around monorepos. Instead of tools like Melos, I use what I call **Modular Multirepo Architecture**: independent Git repositories for each module, connected through `pubspec_overrides.yaml` during development.

This isn't a theoretical exercise. It's born from the real constraints of being a solo founder building an ecosystem of apps that share significant functionality.

---

## The Problem: Code Duplication Kills Solo Developers

When you're building multiple apps, you face a fundamental choice: duplicate code or share it.

**Duplication seems easier at first:**

```
Cyberneom/
  └── lib/auth/         ← auth implementation
  └── lib/commerce/     ← commerce implementation
  └── lib/booking/      ← booking implementation

Gigmeout/
  └── lib/auth/         ← COPY of auth
  └── lib/commerce/     ← COPY of commerce
  └── lib/booking/      ← COPY of booking
```

But then reality hits. You fix a bug in Cyberneom's auth module. Now you need to remember to propagate it to Gigmeout. And EMXI. Six months later, the three implementations have diverged so much that sharing code becomes impossible.

Large companies solve this by having dedicated teams per app. Three auth teams. Three commerce teams. They can afford the redundancy.

**Solo developers and small teams cannot.**

---

## The Conventional Solution: Monorepos with Melos

The Flutter community's answer is usually Melos—a tool that manages multiple packages in a single repository:

```
monorepo/
  └── packages/
      ├── neom_auth/
      ├── neom_commerce/
      ├── neom_booking/
      └── ... all 38 modules
```

Melos works. But it comes with trade-offs that don't fit every workflow:

- **Single massive repository** with interleaved git history
- **All-or-nothing access**—you can't give a contributor access to just one module
- **Complex CI/CD** since any change potentially affects everything
- **Heavyweight tooling** that adds another layer of abstraction

For teams that are fully committed to the monorepo philosophy, Melos is excellent. But I wanted something different.

---

## Modular Multirepo Architecture

My approach keeps each module as an independent Git repository:

```
github.com/serzen/neom_auth        ← independent repo
github.com/serzen/neom_commerce    ← independent repo
github.com/serzen/neom_booking     ← independent repo
github.com/serzen/neom_generator   ← independent repo
... 38 modules total
```

Each app's `pubspec.yaml` references these modules via Git:

```yaml
# pubspec.yaml (production)
dependencies:
  neom_auth:
    git:
      url: https://github.com/serzen/neom_auth.git
      ref: v2.1.0
  neom_commerce:
    git:
      url: https://github.com/serzen/neom_commerce.git
      ref: v1.8.0
```

For local development, `pubspec_overrides.yaml` points to local paths:

```yaml
# pubspec_overrides.yaml (development)
dependency_overrides:
  neom_auth:
    path: ../neom_auth
  neom_commerce:
    path: ../neom_commerce
```

The magic: **Flutter automatically uses overrides when present, Git references when not.**

---

## Why This Works Better (For Me)

### 1. Clean Git History Per Module

Each module has its own focused commit history. When I look at `neom_auth`'s git log, I see only auth-related changes. No noise from unrelated commerce updates or UI tweaks.

```bash
git log --oneline neom_auth/
# a1b2c3d Add biometric authentication
# d4e5f6g Fix token refresh race condition
# g7h8i9j Implement OAuth2 PKCE flow
```

### 2. Granular Access Control

I can make `neom_commons` public while keeping `neom_generator` (my core IP) private. With a monorepo, it's all or nothing.

In the future, I could open specific modules for community contributions without exposing the entire ecosystem.

### 3. Independent Versioning

`neom_auth` can be at v2.1.0 while `neom_commerce` is at v1.8.0. Each module evolves at its own pace. Apps can pin specific versions:

```yaml
neom_auth:
  git:
    url: https://github.com/serzen/neom_auth.git
    ref: v2.1.0  # Stable version
neom_experimental_feature:
  git:
    url: https://github.com/serzen/neom_experimental.git
    ref: main  # Living on the edge
```

### 4. Selective Local Development

Here's the key insight: **developers only clone the modules they're actively working on.**

A UI developer working on the home screen:
```bash
git clone github.com/serzen/cyberneom
git clone github.com/serzen/neom_home
git clone github.com/serzen/neom_commons
```

Their `pubspec_overrides.yaml`:
```yaml
dependency_overrides:
  neom_home:
    path: ../neom_home
  neom_commons:
    path: ../neom_commons
  # Everything else uses Git references automatically
```

They don't need 38 repos on their machine. Just the 2-3 they're touching.

### 5. Simpler CI/CD

Each module has its own CI pipeline. When `neom_auth` changes, only `neom_auth`'s tests run. No need to figure out which subset of a monorepo was affected.

Apps have their own pipelines that pull tagged versions of dependencies. Clean separation.

---

## The Onboarding Story

New developer joins the team. Here's their setup:

```bash
# 1. Clone the app
git clone github.com/serzen/cyberneom
cd cyberneom

# 2. Clone modules they'll work on
cd ..
git clone github.com/serzen/neom_generator
git clone github.com/serzen/neom_frequencies

# 3. Copy the overrides template
cd cyberneom
cp pubspec_overrides.yaml.example pubspec_overrides.yaml

# 4. Uncomment only what they need
# Edit pubspec_overrides.yaml, uncomment neom_generator and neom_frequencies

# 5. Run
flutter pub get
flutter run
```

**One-time setup.** After this, they edit modules locally, see changes instantly in the app, and commit to the appropriate repos when ready.

---

## Comparison: Multirepo vs Melos

| Aspect | Modular Multirepo | Melos Monorepo |
|--------|-------------------|----------------|
| Git history | Separate per module | Interleaved |
| Access control | Per-repo permissions | All-or-nothing |
| Versioning | Independent per module | Coordinated |
| Local setup | Clone only what you need | Clone everything |
| CI/CD | Simple, per-module | Complex, needs filtering |
| Tooling overhead | Minimal (just Git + pubspec) | Melos commands to learn |
| Cross-module refactoring | Manual coordination | Easier with Melos |
| Suited for | Solo/small teams, open source mix | Larger teams, unified codebase |

---

## The Trade-offs (Being Honest)

This approach isn't perfect:

**Cross-module breaking changes require coordination.** If I change an interface in `neom_core`, I need to update all modules that depend on it. Melos makes this easier with workspace-wide commands.

**No single `pub get` for everything.** Each module is a separate pub workspace. Though in practice, you're usually only working in 2-3 at a time.

**Version coordination is manual.** When releasing, I need to ensure compatible versions across modules. A simple script helps, but it's not automatic.

**The overrides file can get long.** With 38 modules, `pubspec_overrides.yaml.example` is substantial. But developers only uncomment what they need.

---

## When to Use This Architecture

**Good fit:**
- Solo developers or small teams
- Multiple apps sharing significant code
- Mix of open-source and private modules
- Gradual open-sourcing strategy
- Developers with different areas of focus

**Not ideal:**
- Large teams doing frequent cross-module refactoring
- Need for atomic commits across multiple modules
- Strict coordinated versioning requirements
- Teams already comfortable with monorepo tooling

---

## The 38-Module Ecosystem

For context, here's what I'm managing with this approach:

**Core:**
`neom_core`, `neom_commons`, `neom_auth`

**Domain-specific (Cyberneom):**
`neom_frequencies`, `neom_generator`, `neom_instruments`

**Audio & Media:**
`neom_audio_player`, `neom_media_player`, `neom_media_upload`

**Social:**
`neom_timeline`, `neom_posts`, `neom_inbox`, `neom_mates`

**Commerce:**
`neom_commerce`, `neom_stripe`, `neom_woo`, `neom_bank`

**Business:**
`neom_events`, `neom_booking`, `neom_calendar`, `neom_directory`

All of these are shared across Cyberneom, Gigmeout, EMXI, and VRlizate in various combinations. A booking improvement benefits all apps. An auth fix propagates everywhere.

---

## Conclusion

Modular Multirepo Architecture isn't revolutionary. It's just Git repositories + Flutter's dependency override system, used deliberately.

The insight is that **you don't need monorepo tooling to share code effectively.** What you need is:

1. Clear module boundaries
2. A convention for local development (overrides)
3. Discipline in versioning

For solo developers and small teams building ecosystems of related apps, this approach offers the benefits of code sharing without the overhead of monorepo tooling.

The best architecture is the one you'll actually maintain. For me, that's 38 independent repos, connected by a simple YAML file.

---

*Emmanuel Montoya Esquer is the founder of Open Neom, building conscious technology through open-source neurotechnology tools. Previously: [neom_core: The Open Kernel Behind Conscious, Human-Centered Apps](link), [Open Neom: The First Step for the Modular Ecosystem of Conscious Technology](link).*

---

**Tags:** Flutter, Architecture, Monorepo, Dart, Mobile Development, Software Architecture, Open Source
