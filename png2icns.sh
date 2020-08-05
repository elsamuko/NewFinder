#!/usr/bin/env bash

if [ $# -lt 1 ]
then
  echo "Usage: $0 icon.png"
  exit 1
fi

ICONSET=/tmp/MyIcon.iconset
ORIGINAL="$1"
ICON="${ORIGINAL%.png}.icns"

 WIDTH=$(sips -g pixelWidth  "$ORIGINAL" | ggrep -Po "(?<=pixelWidth: ).*")
HEIGHT=$(sips -g pixelHeight "$ORIGINAL" | ggrep -Po "(?<=pixelHeight: ).*")

if [ $WIDTH -ne 1024 ] || [ $HEIGHT -ne 1024 ]
then
  echo "Wrong image dimensions, expected 1024 x 1024, but found $WIDTH x $HEIGHT"
  exit 1
fi

rm -R "$ICONSET"
mkdir "$ICONSET"

for SIZE in 16 32 128 256 512
do
	echo "Creating $SIZE x $SIZE"
	SQUARE=$[SIZE*2]
	sips -z $SIZE $SIZE     "$ORIGINAL" --out "$ICONSET/icon_${SIZE}x${SIZE}.png" > /dev/null
	sips -z $SQUARE $SQUARE "$ORIGINAL" --out "$ICONSET/icon_${SIZE}x${SIZE}@2x.png" > /dev/null
done

iconutil -c icns "$ICONSET" -o "$ICON"

