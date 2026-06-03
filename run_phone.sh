#!/usr/bin/env bash
# Build, re-sign, install and launch the debug app on a connected Android phone.
#
# Why this exists: some OEM ROMs (e.g. Tecno/Infinix HiOS) reject the v2-only
# APK that Gradle/`flutter run` produces with
#   INSTALL_PARSE_FAILED_NO_CERTIFICATES: SHA-256 digest of contents did not verify
# Re-signing the built APK with `apksigner` produces a signature the device
# accepts. This script automates: build (with the backend IP baked in) ->
# re-sign with the debug key -> adb install -> launch.
#
# Usage:  ./run_phone.sh [MAC_LAN_IP]
#   e.g.  ./run_phone.sh 192.168.1.6
# Find your IP with:  ipconfig getifaddr en0
set -euo pipefail

IP="${1:-192.168.1.6}"
PKG="com.fluttermap.flutter_test_22"
SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
ADB="$SDK/platform-tools/adb"
# Pick the highest installed build-tools version (for apksigner).
BT_DIR="$(ls -d "$SDK"/build-tools/* | sort -V | tail -1)"
APKSIGNER="$BT_DIR/apksigner"

APK="build/app/outputs/flutter-apk/app-debug.apk"
SIGNED="build/app/outputs/flutter-apk/app-debug-signed.apk"

echo "==> Backend host baked in: $IP   (make sure the backend runs with --host 0.0.0.0)"
flutter build apk --debug --target-platform android-arm64 --dart-define=API_HOST="$IP"

echo "==> Re-signing APK (v1+v2) so strict OEM verifiers accept it"
cp "$APK" "$SIGNED"
"$APKSIGNER" sign \
  --ks "$HOME/.android/debug.keystore" \
  --ks-pass pass:android --key-pass pass:android --ks-key-alias androiddebugkey \
  --v1-signing-enabled true --v2-signing-enabled true \
  "$SIGNED"

echo "==> Installing on device"
"$ADB" install -r "$SIGNED"

echo "==> Launching"
"$ADB" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null

echo "==> Done. App is running on the phone, pointing at http://$IP:8000"
