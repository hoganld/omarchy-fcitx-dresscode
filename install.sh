#!/bin/bash

source ./include.sh

# Set up the paths
mkdir -p "$BIN_PATH"
mkdir -p "$FCITX_THEMES_PATH"
mkdir -p "$(dirname $THEME_HOOK)"

# Copy over the control script
cp "bin/omarchy-theme-set-fcitx5" "$BIN_PATH"

# Install the themes
for themepath in themes/*; do
  ./install-theme.sh $(basename $themepath)
done

# Make sure the theme-set hook file exists
if [[ ! -f "$THEME_HOOK" ]]; then
  echo "#!/bin/bash" >> "$THEME_HOOK"
fi

# Call omarchy-theme-set-fcitx5 from the omarchy theme-set hook
UPDATE_COMMAND="$BIN_PATH/omarchy-theme-set-fcitx5 \"\$1\""
if ! grep -qF "$UPDATE_COMMAND" "$THEME_HOOK"; then
  echo "$UPDATE_COMMAND" >> "$THEME_HOOK"
fi

echo "Successfully installed the Omarchy Fcitx themes."

if gum confirm "Do you want to automatically set the Fcitx theme now?"; then
  # Set the current theme  
  CURRENT_THEME=$(basename $(readlink -f $HOME/.config/omarchy/current/theme))
  ./bin/omarchy-theme-set-fcitx5 "$CURRENT_THEME"
  echo "Fcitx theme is set to $CURRENT_THEME, and will update with the Omarchy theme."
else
  echo "Your Fcitx theme will update with the Omarchy theme."
fi

