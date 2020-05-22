#!/usr/bin/env bash

set -eo pipefail

APP_NAME="$1"
ICON_PATH="$2"
ICON_TMP_DIR="`mktemp -d`/Icon.iconset"

if [[ -z "$APP_NAME" || -z "$ICON_PATH" || "${ICON_PATH##*.}" -ne "png" ]]
then
  echo ""
  echo "USAGE: ./`basename "$0"` APP_NAME ICON_PATH"
  echo ""
  echo "    APP_NAME     Generally a single word, like \"Chat\""
  echo "    ICON_PATH    Path to be a `tput bold`.png`tput sgr0` image"
  echo ""
  exit 1
fi

if [[ -e "$APP_NAME.app" ]]
then
  echo "ERROR: ./$APP_NAME.app already exists! Remove it before re-running this script."
  exit 2
fi

swift build
cp -r "{{TEMPLATE}}.app" "$APP_NAME.app"
cp .build/x86*/debug/Multi "$APP_NAME.app"
sed -i '' "s/{{TEMPLATE}}/$APP_NAME/g" "$APP_NAME.app/Contents/Info.plist"

mkdir $ICON_TMP_DIR
sips -z 16 16     "$ICON_PATH" --out "$ICON_TMP_DIR/icon_16x16.png"      > /dev/null
sips -z 32 32     "$ICON_PATH" --out "$ICON_TMP_DIR/icon_16x16@2x.png"   > /dev/null
sips -z 32 32     "$ICON_PATH" --out "$ICON_TMP_DIR/icon_32x32.png"      > /dev/null
sips -z 64 64     "$ICON_PATH" --out "$ICON_TMP_DIR/icon_32x32@2x.png"   > /dev/null
sips -z 128 128   "$ICON_PATH" --out "$ICON_TMP_DIR/icon_128x128.png"    > /dev/null
sips -z 256 256   "$ICON_PATH" --out "$ICON_TMP_DIR/icon_128x128@2x.png" > /dev/null
sips -z 256 256   "$ICON_PATH" --out "$ICON_TMP_DIR/icon_256x256.png"    > /dev/null
sips -z 512 512   "$ICON_PATH" --out "$ICON_TMP_DIR/icon_256x256@2x.png" > /dev/null
sips -z 512 512   "$ICON_PATH" --out "$ICON_TMP_DIR/icon_512x512.png"    > /dev/null
sips -z 1024 1024 "$ICON_PATH" --out "$ICON_TMP_DIR/icon_512x512@2x.png" > /dev/null
iconutil -c icns --output "$APP_NAME.app/Contents/Resources/Icon.icns" "$ICON_TMP_DIR"
