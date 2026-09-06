#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#  Cyberneom — Web deploy script
# ─────────────────────────────────────────────────────────────────
#  Builds the Flutter web app and deploys it to Firebase Hosting.
#
#  Modes:
#    preview  →  deploys to a temporary preview channel (default).
#                Firebase generates a unique, sharable URL that
#                auto-expires in 7 days. No toca producción.
#    prod     →  deploys to the live channel (cyberneom-edd2d.web.app).
#                Prompts for confirmation.
#
#  Usage:
#    scripts/deploy_web.sh                      # preview channel 'test'
#    scripts/deploy_web.sh preview mychannel    # preview channel 'mychannel'
#    scripts/deploy_web.sh preview mychannel 3d # channel expires in 3 days
#    scripts/deploy_web.sh prod                 # live deploy (pide confirmación)
# ─────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_DIR"

# ── Config ───────────────────────────────────────────────────────
FIREBASE_PROJECT="cyberneom-edd2d"
APP_NAME="Cyberneom"
BUILD_DIR="build/web"
DEFAULT_CHANNEL="test"
DEFAULT_EXPIRES="7d"
FLUTTER_BUILD_FLAGS=(
  "--release"
  "--source-maps"
)

# ── Colors ───────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  C_RED="$(printf '\033[0;31m')"
  C_GREEN="$(printf '\033[0;32m')"
  C_YELLOW="$(printf '\033[0;33m')"
  C_BLUE="$(printf '\033[0;34m')"
  C_RESET="$(printf '\033[0m')"
else
  C_RED="" ; C_GREEN="" ; C_YELLOW="" ; C_BLUE="" ; C_RESET=""
fi

log()   { printf "%s▶%s %s\n" "$C_BLUE"   "$C_RESET" "$*"; }
ok()    { printf "%s✓%s %s\n" "$C_GREEN"  "$C_RESET" "$*"; }
warn()  { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
fail()  { printf "%s✗%s %s\n" "$C_RED"    "$C_RESET" "$*" >&2; exit 1; }

# ── Pre-flight checks ────────────────────────────────────────────
check_tools() {
  command -v flutter  >/dev/null 2>&1 || fail "flutter no está en PATH"
  command -v firebase >/dev/null 2>&1 || fail "firebase-tools no instalado (npm i -g firebase-tools)"
}

check_login() {
  if ! firebase projects:list >/dev/null 2>&1; then
    fail "No estás logueado en Firebase. Ejecuta: firebase login"
  fi
}

ensure_project() {
  if [[ ! -f ".firebaserc" ]]; then
    fail ".firebaserc no encontrado — este script debe ejecutarse desde $APP_NAME/"
  fi
  firebase use "$FIREBASE_PROJECT" >/dev/null
  ok "Proyecto Firebase: $FIREBASE_PROJECT"
}

# ── Build ────────────────────────────────────────────────────────
build_web() {
  log "Limpiando build previo…"
  rm -rf "$BUILD_DIR"

  log "flutter pub get"
  flutter pub get >/dev/null

  log "flutter build web ${FLUTTER_BUILD_FLAGS[*]}"
  flutter build web "${FLUTTER_BUILD_FLAGS[@]}"

  if [[ ! -f "$BUILD_DIR/index.html" ]]; then
    fail "Build falló: $BUILD_DIR/index.html no existe"
  fi

  local size
  size="$(du -sh "$BUILD_DIR" | awk '{print $1}')"
  ok "Build listo ($size en $BUILD_DIR)"
}

# ── Deploy: preview channel ──────────────────────────────────────
deploy_preview() {
  local channel="${1:-$DEFAULT_CHANNEL}"
  local expires="${2:-$DEFAULT_EXPIRES}"
  log "Deploy a canal preview '$channel' (expira en $expires)…"
  firebase hosting:channel:deploy "$channel" \
    --project "$FIREBASE_PROJECT" \
    --expires "$expires"
  ok "Preview desplegado"
  echo
  echo "  URL del canal ↑ (copia desde la salida de Firebase)"
  echo "  Listar canales:  firebase hosting:channel:list --project $FIREBASE_PROJECT"
  echo "  Borrar canal:    firebase hosting:channel:delete $channel --project $FIREBASE_PROJECT"
}

# ── Deploy: producción ───────────────────────────────────────────
deploy_prod() {
  warn "ESTÁS POR DESPLEGAR $APP_NAME A PRODUCCIÓN (https://$FIREBASE_PROJECT.web.app)"
  read -r -p "¿Continuar? [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    fail "Abortado por el usuario"
  fi
  log "Deploy a canal live…"
  firebase deploy --only hosting --project "$FIREBASE_PROJECT"
  ok "Producción actualizada"
}

# ── Main ─────────────────────────────────────────────────────────
main() {
  local mode="${1:-preview}"
  check_tools
  check_login
  ensure_project
  build_web

  case "$mode" in
    preview)
      deploy_preview "${2:-$DEFAULT_CHANNEL}" "${3:-$DEFAULT_EXPIRES}"
      ;;
    prod|production|live)
      deploy_prod
      ;;
    *)
      fail "Modo desconocido: $mode (usa 'preview' o 'prod')"
      ;;
  esac
}

main "$@"
