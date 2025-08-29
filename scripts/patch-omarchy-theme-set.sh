#!/bin/bash

echo "Patching omarchy-theme-set"

THEME_SETTER="$OMARCHY_PATH/bin/omarchy-theme-set"

sed -i '/Change gnome modes/i\\# Update Fcitx theme symlinks\nomarchy-fcitx-theme-set "$THEME_NAME"\n' "$THEME_SETTER"

sed -i '/makoctl reload/i\omarchy-restart-fcitx' "$THEME_SETTER"
