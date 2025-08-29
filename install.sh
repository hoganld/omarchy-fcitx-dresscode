#!/bin/bash

DRESSCODE_PATH="${FCITX_DRESSCODE_PATH:-$HOME/.local/share/fcitx-dresscode}"
FCITX_PATH="${FCITX_ROOT:-$HOME/.local/share/fcitx5}/themes"
# FCITX_CONFIG="${FCITX_CONF:-$HOME/.config/fcitx5/conf}/classicui.conf"
THEME_SETTER="$OMARCHY_PATH/bin/omarchy-theme-set"

# Set up the paths
mkdir -p "$DRESSCODE_PATH"
mkdir -p "$FCITX_PATH"

# Copy over the themes and control files
cp -r "bin" "$DRESSCODE_PATH"
cp -r "themes" "$DRESSCODE_PATH"

# Link up the control scripts next to their Omarchy counterparts
ln -nsf "$DRESSCODE_PATH/bin/omarchy-fcitx-theme-set" "$OMARCHY_PATH/bin/omarchy-fcitx-theme-set"
ln -nsf "$DRESSCODE_PATH/bin/omarchy-restart-fcitx" "$OMARCHY_PATH/bin/omarchy-restart-fcitx"

# Link the themes where Fcitx will look for them
cd "$DRESSCODE_PATH/themes"
for file in *; do
	ln -nsf "$DRESSCODE_PATH/themes/$file" "$FCITX_PATH/$file"
done
cd -

# Patch omarchy-theme-set script in an idempotent manner
UPDATE_COMMENT='# Update Fcitx symlinks'
UPDATE_COMMAND="omarchy-fcitx-theme-set \"\$THEME_NAME\""
if ! grep -qF "$UPDATE_COMMAND" "$THEME_SETTER"; then
	sed -i "/Change gnome modes/i\\$UPDATE_COMMENT\n$UPDATE_COMMAND\n" "$THEME_SETTER"
fi

RESTART_COMMAND="omarchy-restart-fcitx"
if ! grep -qF "$RESTART_COMMAND" "$THEME_SETTER"; then
	sed -i "/makoctl reload/i\\$RESTART_COMMAND" "$THEME_SETTER"
fi

echo "Successfully installed the Fcitx dress code."

if gum confirm "Do you want to automatically update your Fcitx config?"; then
	./configure.sh
fi
