#!/bin/bash

MEKASHIYA_PATH="${MEKASHIYA_ROOT:-$HOME/.local/share/mekashiya}"
FCITX_THEMES_PATH="${FCITX_THEMES_ROOT:-$HOME/.local/share/fcitx5/themes}"
BIN_PATH="${LOCAL_BIN:-$HOME/.local/bin}"
THEME_HOOK="$HOME/.config/omarchy/hooks/theme-set"

# Undo the configuration
./bin/mekashiya-set "default"

# Unlink the control scripts
if [[ -f "$BIN_PATH/mekashiya-set" ]]; then
  unlink "$BIN_PATH/mekashiya-set"
fi

# Clean up the hooks
UPDATE_COMMAND="$BIN_PATH/mekashiya-set \"\$1\""
LINE=$(grep -n "$UPDATE_COMMAND" "$THEME_HOOK" 2> /dev/null | cut -d: -f1)
if [[ ! -z $LINE ]]; then
  sed -i "${LINE}d" "$THEME_HOOK"
fi

# Unlink the theme files
if [[ -d "$MEKASHIYA_PATH/themes" ]]; then
  cd "$MEKASHIYA_PATH/themes"
  for file in *; do
    unlink "$FCITX_THEMES_PATH/$file"
  done
  cd - >/dev/null
fi

# Destroy the evidence
rm -rf "$MEKASHIYA_PATH"

echo "Successfully uninstalled the Omarchy Fcitx themes."
