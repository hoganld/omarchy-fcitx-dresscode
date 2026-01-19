#!/bin/bash

source ./include.sh

# Undo the configuration
./bin/omarchy-theme-set-fcitx5 "default" > /dev/null 2>&1

# Remove the control script
rm "$BIN_PATH/omarchy-theme-set-fcitx5" > /dev/null 2>&1

# Remove the theme files
for themepath in themes/*; do
  themename="$(basename $themepath)"
  rm -rf "$FCITX_THEMES_PATH/$themename"
done

# Clean up the hooks
UPDATE_COMMAND="$BIN_PATH/omarchy-theme-set-fcitx5 \"\$1\""
LINE=$(grep -n "$UPDATE_COMMAND" "$THEME_HOOK" 2> /dev/null | cut -d: -f1)
if [[ ! -z $LINE ]]; then
  sed -i "${LINE}d" "$THEME_HOOK"
fi

echo "Successfully uninstalled the Omarchy Fcitx themes."
