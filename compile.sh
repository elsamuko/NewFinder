#!/usr/bin/env bash

replace_icon() {
    DROPLET=$1
    ICON=$2
	echo "read 'icns' (-16455) \"$ICON\";" | Rez -o $(printf "$DROPLET/Icon\r")
	SetFile -a "C" "$DROPLET"
}

if [ $# -lt 1 ]
then
  echo "Usage: $0 applescript.scpt"
  exit 1
fi

ORIGINAL="$1"
NAME="${ORIGINAL%.scpt}"
APP="$NAME.app"
PKG="$NAME.pkg"
VERSION=0.2.0
KEY_CODESIGN="3rd Party Mac Developer Application: FD Imaging UG (haftungsbeschraenkt) (H63858HN93)"
KEY_PACKAGE="3rd Party Mac Developer Installer: FD Imaging UG (haftungsbeschraenkt) (H63858HN93)"

# cleanup old run
rm -rf tmp
rm -rf "$APP"
rm -rf "$PKG"
mkdir tmp
find . -name ".DS_Store" -delete

osacompile -o "$APP" "$ORIGINAL"

cp Icon.icns "$APP"/Contents/Resources/applet.icns

plutil -insert  CFBundleIdentifier -string "com.fd-imaging.${NAME,,}" "$APP"/Contents/Info.plist
plutil -insert  CFBundleShortVersionString -string "$VERSION" "$APP"/Contents/Info.plist
plutil -insert  LSApplicationCategoryType -string "public.app-category.productivity" "$APP"/Contents/Info.plist
plutil -insert  LSMinimumSystemVersion -string "10.10.0" "$APP"/Contents/Info.plist
plutil -replace CFBundleIconFile -string "applet.icns" "$APP"/Contents/Info.plist

# sign
echo
codesign \
	--force --verify --verbose \
	--sign "$KEY_CODESIGN" \
	"$APP"
# check
echo
codesign -vvv -d "$APP"
echo
codesign --display --entitlements - "$APP"
echo

productbuild \
    --component "$APP" /Applications \
    --sign "$KEY_PACKAGE" \
    --product "$APP/Contents/Info.plist" \
    "$PKG"

# delete app, else installer will relocate
rm -rf "$APP"

echo
echo "Test with"
echo "    sudo installer -pkg $PKG -target /"
echo
