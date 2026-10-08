#!/bin/sh
# Run TypingMaster from THIS folder (TypingMaster-Source).
# 1. Syncs app/ program files into the Wine prefix (so the running
#    program is byte-identical to these files - see MANIFEST.txt).
# 2. Launches the app through the Flatpak's Wine.
set -eu
HERE="$(dirname "$(readlink -f "$0")")"
PREFIX="$HOME/.var/app/com.typingmaster.TypingMaster/data/wine/drive_c/Program Files (x86)/TypingMaster"

echo "[run] syncing $HERE/app -> Wine prefix..."
mkdir -p "$PREFIX"
cp -a "$HERE/app/." "$PREFIX"/
echo "[run] verifying TypingMaster.exe..."
if ! cmp -s "$HERE/app/TypingMaster.exe" "$PREFIX/TypingMaster.exe"; then
  echo "[run] ERROR: sync failed" >&2
  exit 1
fi
echo "[run] identical - launching..."
exec flatpak run com.typingmaster.TypingMaster
