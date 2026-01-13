#!/bin/bash

MEKASHIYA_PATH="${MEKASHIYA_ROOT:-$HOME/.local/share/mekashiya}"
FCITX_THEMES_PATH="${FCITX_THEMES_ROOT:-$HOME/.local/share/fcitx5/themes}"
BIN_PATH="${LOCAL_BIN:-$HOME/.local/bin}"
THEME_HOOK="$HOME/.config/omarchy/hooks/theme-set"

# Set up the paths
mkdir -p "$MEKASHIYA_PATH"
mkdir -p "$FCITX_THEMES_PATH"
mkdir -p "$BIN_PATH"

# Copy over the themes and control script
cp -r "bin" "$MEKASHIYA_PATH"
cp -r "themes" "$MEKASHIYA_PATH"

# Link up the control scripts in ~/.local/bin
ln -nsf "$MEKASHIYA_PATH/bin/mekashiya-set" "$BIN_PATH/mekashiya-set"

# Link the themes where Fcitx will look for them
cd "$MEKASHIYA_PATH/themes"
for file in *; do
  ln -nsf "$MEKASHIYA_PATH/themes/$file" "$FCITX_THEMES_PATH/$file"
done
cd - > /dev/null

# Make sure the theme-set hook file exists
if [[ ! -f "$THEME_HOOK" ]]; then
  echo "#!/bin/bash" >> "$THEME_HOOK"
fi

# Call mekashiya-set from the omarchy theme-set hook
UPDATE_COMMAND="$BIN_PATH/mekashiya-set \"\$1\""
if ! grep -qF "$UPDATE_COMMAND" "$THEME_HOOK"; then
  echo "$UPDATE_COMMAND" >> "$THEME_HOOK"
fi

echo "Successfully installed the Omarchy Fcitx themes."

if gum confirm "Do you want to automatically set the Fcitx theme now?"; then
  # Set the current theme  
  CURRENT_THEME=$(basename $(readlink -f $HOME/.config/omarchy/current/theme))
  ./bin/mekashiya-set "$CURRENT_THEME"
  echo "Fcitx theme is set to $CURRENT_THEME, and will update with the Omarchy theme."
else
  echo "Your Fcitx theme will update with the Omarchy theme."
fi

