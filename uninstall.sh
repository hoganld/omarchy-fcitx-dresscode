#!/bin/bash

source ./include.sh

# Undo the configuration
./bin/mekashiya-set "default" > /dev/null 2>&1

# Remove the control script
rm "$BIN_PATH/mekashiya-set" > /dev/null 2>&1

# Remove the theme files
for themepath in themes/*; do
  themename="$(basename $themepath)"
  rm -rf "$FCITX_THEMES_PATH/$themename"
done

# Clean up the hooks
UPDATE_COMMAND="$BIN_PATH/mekashiya-set \"\$1\""
LINE=$(grep -n "$UPDATE_COMMAND" "$THEME_HOOK" 2> /dev/null | cut -d: -f1)
if [[ ! -z $LINE ]]; then
  sed -i "${LINE}d" "$THEME_HOOK"
fi

# Unlink the theme files
# if [[ -d "$MEKASHIYA_PATH/themes" ]]; then
#   cd "$MEKASHIYA_PATH/themes"
#   for file in *; do
#     unlink "$FCITX_THEMES_PATH/$file"
#   done
#   cd - >/dev/null
# fi

echo "Successfully uninstalled the Omarchy Fcitx themes."
