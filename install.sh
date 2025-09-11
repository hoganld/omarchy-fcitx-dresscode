#!/bin/bash

DRESSCODE_PATH="${FCITX_DRESSCODE_PATH:-$HOME/.local/share/fcitx-dresscode}"
FCITX_PATH="${FCITX_ROOT:-$HOME/.local/share/fcitx5}/themes"
BIN_PATH="$HOME/.local/bin"
THEME_SETTER="$OMARCHY_PATH/bin/omarchy-theme-set"

# Set up the paths
mkdir -p "$DRESSCODE_PATH"
mkdir -p "$FCITX_PATH"
mkdir -p "$BIN_PATH"

# Copy over the themes and control script
cp -r "bin" "$DRESSCODE_PATH"
cp -r "themes" "$DRESSCODE_PATH"

# Link up the control scripts in ~/.local/bin
ln -nsf "$DRESSCODE_PATH/bin/dresscode-theme-set" "$BIN_PATH/dresscode-theme-set"

# Link the themes where Fcitx will look for them
cd "$DRESSCODE_PATH/themes"
for file in *; do
  ln -nsf "$DRESSCODE_PATH/themes/$file" "$FCITX_PATH/$file"
done
cd -

# Patch omarchy-theme-set script in an idempotent manner
UPDATE_COMMENT='# Update Fcitx theme'
UPDATE_COMMAND="${BIN_PATH}/dresscode-theme-set \"\$THEME_NAME\""
if ! grep -qF "$UPDATE_COMMAND" "$THEME_SETTER"; then
  sed -i "/Restart components/i\\$UPDATE_COMMENT\n$UPDATE_COMMAND\n" "$THEME_SETTER"
fi

echo "Successfully installed the Fcitx Dress Code."

if gum confirm "Do you want to automatically update your Fcitx config?"; then
  ./configure.sh
fi
