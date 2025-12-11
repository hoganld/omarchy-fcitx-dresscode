#!/bin/bash

DRESSCODE_PATH="${FCITX_DRESSCODE_PATH:-$HOME/.local/share/fcitx-dresscode}"
FCITX_PATH="${FCITX_ROOT:-$HOME/.local/share/fcitx5}/themes"
BIN_PATH="$HOME/.local/bin"
THEME_HOOK="$HOME/.config/omarchy/hooks/theme-set"

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

# Set the current theme
CURRENT_THEME=$(basename $(readlink -f $HOME/.config/omarchy/current/theme))
if [[ -d $FCITX_PATH/$CURRENT_THEME ]]; then
  ln -nsf $FCITX_PATH/$CURRENT_THEME $FCITX_PATH/current
else
  ln -nsf $FCITX_PATH/fallback $FCITX_PATH/current
fi

# Call dresscode-theme-set from the omarchy theme-set hook
UPDATE_COMMAND="$BIN_PATH/dresscode-theme-set \$1"
if ! grep -qF "$UPDATE_COMMAND" $THEME_HOOK; then
  echo "$UPDATE_COMMAND" >> $THEME_HOOK
fi

# Stub out dresscode-set.sample hook script
if [[ -d "$HOME/.config/omarchy/hooks" ]]; then
  tee "$HOME/.config/omarchy/hooks/dresscode-set.sample" > /dev/null <<EOF
#!/bin/bash
# This hook is called with the snake-cased name of the theme that has just been set,
# exactly like the `theme-set` hook. But this hook runs after Dresscode updates the
# Fcitx5 theme, immediately after the call to `omarchy-restart-xcompose`.
# To put it into use, remove .sample from the name.
EOF
fi

echo "Successfully installed the Fcitx Dress Code."

if gum confirm "Do you want to automatically update your Fcitx config?"; then
  ./configure.sh
fi

omarchy-restart-xcompose
