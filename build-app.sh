#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="Open in Zed"
APP_DIR="$ROOT/$APP_NAME.app"
STUB="/System/Library/CoreServices/Automator Application Stub.app"
ZED_ICON="/Applications/Zed.app/Contents/Resources/Zed.icns"

rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"

cp "$STUB/Contents/MacOS/Automator Application Stub" "$APP_DIR/Contents/MacOS/"
cp "$STUB/Contents/PkgInfo" "$APP_DIR/Contents/"
cp "$STUB/Contents/Info.plist" "$APP_DIR/Contents/"
cp "$ROOT/document.wflow" "$APP_DIR/Contents/document.wflow"

/usr/libexec/PlistBuddy -c "Set :CFBundleName '$APP_NAME'" "$APP_DIR/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.openfolderinzed.app" "$APP_DIR/Contents/Info.plist"

if [[ -f "$ZED_ICON" ]]; then
  cp "$ZED_ICON" "$APP_DIR/Contents/Resources/ApplicationStub.icns"
else
  cp "$STUB/Contents/Resources/ApplicationStub.icns" "$APP_DIR/Contents/Resources/ApplicationStub.icns"
fi

chmod +x "$APP_DIR/Contents/MacOS/Automator Application Stub"
xattr -cr "$APP_DIR" 2>/dev/null || true

echo "Built $APP_DIR"
