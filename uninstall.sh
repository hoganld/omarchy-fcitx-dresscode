#!/bin/bash

DRESSCODE_PATH="${FCITX_DRESSCODE_PATH:-$HOME/.local/share/fcitx-dresscode}"
FCITX_PATH="${FCITX_ROOT:-$HOME/.local/share/fcitx5}/themes"
BIN_PATH="$HOME/.local/bin"
THEME_HOOK="$HOME/.config/omarchy/hooks/theme-set"
DRESSCODE_HOOK="$HOME/.config/omarchy/hooks/dresscode-set.sample"

# Undo the configuration
./bin/dresscode-theme-set "default"

# Unlink the control scripts
if [[ -f "$BIN_PATH/dresscode-theme-set" ]]; then
  unlink "$BIN_PATH/dresscode-theme-set"
fi

# Clean up the hooks
UPDATE_COMMAND="$BIN_PATH/dresscode-theme-set \$1"
LINE=$(grep -n "$UPDATE_COMMAND" "$THEME_HOOK" 2> /dev/null | cut -d: -f1)
if [[ ! -z $LINE ]]; then
  sed -i "${LINE}d" "$THEME_HOOK"
fi
rm "$DRESSCODE_HOOK" 2> /dev/null

# Unlink the theme files
if [[ -d "$DRESSCODE_PATH/themes" ]]; then
  cd "$DRESSCODE_PATH/themes"
  for file in *; do
    unlink "$FCITX_PATH/$file"
  done
  cd - >/dev/null
fi

# Destroy the evidence
rm -rf "$DRESSCODE_PATH"

echo "Successfully uninstalled Fcitx Dress Code."
