#!/bin/bash

BINDIR="$OMARCHY_PATH/bin"

echo "Installing Fcitx theme controll scripts"

cp bin/omarchy-fcitx-theme-set "$BINDIR"
cp bin/omarchy-restart-fcitx "$BINDIR"
