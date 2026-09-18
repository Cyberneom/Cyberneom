# Cyberneom: production web redeployment

- Requested operation: deploy the current local Cyberneom web version to production.
- Published: 2026-09-09 16:41:11 UTC.
- Destination: https://cyberneom.xyz; Firebase project/site `cyberneom-edd2d`, live channel.
- Hosting version: `bc0d2793674dcd2f`.
- Previous Hosting version: `43e144a933f8127e` (2026-09-08 18:46:21 UTC).
- Scope: Hosting only. No Firestore/Storage rules, indexes, Functions, billing, Auth configuration, user data or other apps changed.

## Build and verification

- Flutter 3.44.8 stable / Dart 3.12.2.
- Built with `flutter build web --release --no-tree-shake-icons --no-wasm-dry-run --no-pub`, using the existing local module overrides.
- All 26 synthetic PDF branding tests passed.
- Deployment completed successfully with `firebase deploy --only hosting --project cyberneom-edd2d --non-interactive`.
- Both checked assets on the custom domain returned HTTP 200, revalidation cache headers, and exact local SHA-256 matches:
  - `main.dart.js`: `9c68f9e4dc3ac14081329132d60ca1701326bec37642e434185acea9ebf510e6`.
  - `pdf_reader.html`: `c75848ee62f200cb5801ec67c63fff03e7752d44c41446210d949fca11ce851d`.
- These two hashes are unchanged from the previous deployment: this republishes the existing code, not the proposed navigation or image-retry corrections.
- The known service-account asset remains excluded by Hosting configuration. A HEAD request to its public path returned the HTML fallback content type, not JSON. No credential contents were read.

## Pending issues, not fixed by this deployment

- Earlier read-only diagnostics confirmed HTTP 402 for sampled public media in `cyberneom-edd2d.appspot.com`: the owning project's billing account is disabled/closed. This deployment does not reactivate billing or restore Storage access.
- Books remains enabled for Cyberneom in the current capability flags and catalog routes; restricting it to `AppInUse.e` is still pending.
- Levitation remains registered in release; restricting both navigation and routes to debug is still pending.
- Web image retry/cache/interaction defects identified in `neom_commons` remain pending.
- Firebase repeated the existing warning that the `stateOgMeta` Hosting rewrite has no valid function endpoint. No function was deployed.
- No new browser end-to-end, mobile, authenticated-account, upload or payment-flow validation was performed for this redeployment.

## Follow-up: navigation corrections deployed

- Published: 2026-09-09 16:51:29 UTC, Hosting version `429ce1e4ffe2784c`.
- Previous version: `bc0d2793674dcd2f`.
- `neom_commons`: Books capability now requires `AppInUse.e`; Levitation requires Cyberneom and `kDebugMode`; the command palette also respects the Books capability.
- `neom_home`: featured Books and top-bar Books use the same capability. Original tab callback indices are preserved. The existing left sidebar already uses the corrected capability flags.
- Cyberneom now mounts only generic PDF reader routes from `neom_books`, not library/top-books/book-detail routes. EMXI retains its existing catalogue and reader. The PDF preview's title does not link to the EMXI catalogue outside EMXI.
- All eight Levitation routes are registered only inside `if (kDebugMode)`. Other experiences and audio/meditation/podcast routes are unchanged.
- Seven Flutter navigation regression tests passed, including all app flags, Cyberneom route scope, preserved EMXI routes, and Cyberneom audio navigation. All 26 synthetic PDF branding tests also passed.
- The three shared menu files passed targeted Dart analysis with no issues. App route analysis reported existing unused/transitive import warnings; no compilation errors. A test import lint introduced during development was corrected.
- Flutter release compilation succeeded. `main.dart.js` now has a different SHA-256: `08003565aec3ec6dc997afb52155d034351c40d33d9316c7525100db5fcdeeb4`.
- Production `main.dart.js` and `pdf_reader.html` both returned HTTP 200 and matched their local artifacts. Chrome visual verification confirmed Books and Levitation are absent while Camera Neom and the other experiences remain visible.
- Read-only media recheck: Firestore HTTP 200; sampled Storage media HTTP 402 with owning billing account closed/disabled. This remains a separate blocker; no billing or rules changes were made.
- Image Retry and the subsequently reported Camera Neom stop-button issue are NOT fixed in this deployment. No original PDF/media files, user data, or other applications were changed/deployed.
