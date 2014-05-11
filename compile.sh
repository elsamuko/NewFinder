#!/usr/bin/env bash

if [ $# -lt 1 ]
then
  echo "Usage: $0 applescript.scpt"
  exit 1
fi

ORIGINAL="$1"
APP="${ORIGINAL%.scpt}.app"

osacompile -o "$APP" "$ORIGINAL"
