#!/bin/bash

DRESSCODE_PATH="${FCITX_DRESSCODE_PATH:-$HOME/.local/share/fcitx-dresscode}"
FCITX_PATH="${FCITX_ROOT:-$HOME/.local/share/fcitx5}/themes"
BIN_PATH="$HOME/.local/bin"
THEME_SETTER="$OMARCHY_PATH/bin/omarchy-theme-set"

# Unlink the control scripts
if [[ -f "$BIN_PATH/dresscode-theme-set" ]]; then
  unlink "$BIN_PATH/dresscode-theme-set"
fi

# Unpatch omarchy-theme-set
cd "$OMARCHY_PATH"
git checkout "bin/omarchy-theme-set" >/dev/null 2>&1
cd - >/dev/null

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
