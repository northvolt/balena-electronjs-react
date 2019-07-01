#!/usr/bin/env bash

# Rotate screen 180°
xrandr -o inverted
exec /usr/src/app/node_modules/electron/dist/electron /usr/src/app/ --enable-logging
