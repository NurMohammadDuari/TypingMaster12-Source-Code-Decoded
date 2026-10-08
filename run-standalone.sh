#!/bin/sh
# Standalone run: everything comes from THIS folder. No Flatpak needed.
# - Wine binaries : runtime/app-files/bin
# - System libs  : runtime/platform-files + runtime/app-files/
# - Program files: app/  (synced into prefix, hash-verified)
# - Wine prefix  : prefix/ (created on first run)
set -eu
HERE="$(dirname "$(readlink -f "$0")")"
RT="$HERE/runtime"

export PATH="$RT/app-files/bin:$PATH"
export LD_LIBRARY_PATH="$RT/app-files/lib:$RT/app-files/lib64:$RT/app-files/lib/i386-linux-gnu:$RT/platform-files/lib:$RT/platform-files/lib64:$RT/platform-files/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

export TYPINGMASTER_PACKAGED_DIR="$HERE/app"
export TYPINGMASTER_SHARE_DIR="$RT/app-files/share/typingmaster"
export TYPINGMASTER_WINEPREFIX="$HERE/prefix"

echo "[standalone] wine: $(command -v wine)"
echo "[standalone] prefix: $TYPINGMASTER_WINEPREFIX"
exec sh "$HERE/launcher.sh"
