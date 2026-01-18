#!/bin/bash

source ./include.sh

# Set up the paths
mkdir -p "$FCITX_THEMES_PATH"
mkdir -p "$BIN_PATH"

# Copy over the themes and control script
cp "bin/mekashiya-set" "$BIN_PATH"
cp -r themes/* "$FCITX_THEMES_PATH/"

# Make sure the theme-set hook file exists
if [[ ! -f "$THEME_HOOK" ]]; then
  mkdir -p "$(dirname $THEME_HOOK)"
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

