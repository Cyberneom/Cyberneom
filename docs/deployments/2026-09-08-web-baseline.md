# Cyberneom: web baseline before rules migration

- Published: 2026-09-08 17:58:37 UTC.
- Destination: https://cyberneom.xyz (Firebase project/site `cyberneom-edd2d`).
- Scope: Hosting only. No Firestore/Storage rules, indexes, Functions, Auth configuration or database migrations deployed.
- App version: 3.0.1+28; source HEAD before local deployment adjustments: `22aa5cd2`.
- Previous Hosting version: `1a52ca91f172c036` (2026-08-31).
- New Hosting version: `420bfde8ae01e123`.
- Build: Flutter 3.44.8 stable, Dart 3.12.2; release JavaScript with `--no-tree-shake-icons`, using local `pubspec_overrides.yaml` modules.
- Public `main.dart.js` SHA-256 matches the local artifact: `b1c376b224615ace2d054a63af2d54e1da1758278836e1b053be976d49d1d7b3`.

## Deployment adjustments

1. Call `initNeomCommons()` after `AppFlavour()` so catalog navigation callbacks are initialized.
2. Require revalidation of mutable web assets instead of year-long immutable JavaScript caching.
3. Exclude source maps, service-account files, private-key files and environment files from Hosting. A service-account asset was present in build output; its contents were not opened. The deployed URL returned the HTML fallback, not a JSON credential file.
4. Dependency resolution updated `pubspec.lock` and the generated iOS Swift package manifest. No shared-module source edits or mobile distribution performed.

## Verification and limitations

- Release compilation succeeded. Wasm compatibility diagnostics do not apply to this JavaScript build.
- Local Chrome: onboarding can be skipped; guest home retrieves existing content; Events requests an account.
- Production Chrome: home renders and shows existing content and suggestions. HTTP checks confirm the new JavaScript and cache headers on the custom domain.
- Some publication covers and gallery images still fail to load. Their cause was not established during this deployment; rules were not changed.
- Hosting warned that the existing `stateOgMeta` rewrite has no valid function endpoint. No function was modified or deployed.
- Shared synthetic catalog tests could not load with their existing package configuration because it referenced a different Flutter SDK; zero assertions ran. Do not treat that attempt as a passing regression suite.
- Existing-user login, uploads, financial operations and full audio playback were not validated. No account creation or intentional data writes were performed.
- The next rules migration must be a separate, explicitly scoped operation after baseline validation. Existing backend rules were preserved, not certified as open or safe by this check.

## Subsequent Hosting deployment: dynamic PDF branding

- Published: 2026-09-08 18:46:21 UTC, version `43e144a933f8127e`.
- Previous version: `420bfde8ae01e123`; app version remains 3.0.1+28.
- Includes the shared PDF wrapper sending `AppProperties.getAppName()` and the Cyberneom HTML reader using that name for its title and canvas watermark. Missing names fall back to a neutral PDF title without a branded watermark.
- The same wrapper covers PDF upload previews. No changes to the original PDF files.
- All 26 synthetic branding tests passed; Flutter release web build succeeded.
- Verified on `https://cyberneom.xyz`: both deployed files exactly match the compiled artifacts, with revalidation cache headers.
  - `main.dart.js`: `9c68f9e4dc3ac14081329132d60ca1701326bec37642e434185acea9ebf510e6`.
  - `pdf_reader.html`: `c75848ee62f200cb5801ec67c63fff03e7752d44c41446210d949fca11ce851d`.
- Hosting only; no rules, Functions, indexes, account operations or data migrations deployed. Other applications were not deployed.
- The preexisting `stateOgMeta` endpoint warning remains. This deployment does not resolve the previously observed image-loading issues or certify all authenticated workflows.
