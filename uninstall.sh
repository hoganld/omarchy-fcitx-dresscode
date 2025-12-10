#!/bin/bash

DRESSCODE_PATH="${FCITX_DRESSCODE_PATH:-$HOME/.local/share/fcitx-dresscode}"
FCITX_PATH="${FCITX_ROOT:-$HOME/.local/share/fcitx5}/themes"
BIN_PATH="$HOME/.local/bin"
THEME_HOOK="$HOME/.config/omarchy/hooks/theme-set"

# Unlink the control scripts
if [[ -f "$BIN_PATH/dresscode-theme-set" ]]; then
  unlink "$BIN_PATH/dresscode-theme-set"
fi

# Clean up the hook
UPDATE_COMMAND="$BIN_PATH/dresscode-theme-set \$1"
LINE=$(grep -n "$UPDATE_COMMAND" $THEME_HOOK 2> /dev/null | cut -d: -f1)
if [[ ! -z $LINE ]]; then
  sed -i "${LINE}d" $THEME_HOOK
fi

# Unlink the theme files
if [[ -d "$DRESSCODE_PATH/themes" ]]; then
  cd "$DRESSCODE_PATH/themes"
  for file in *; do
    unlink "$FCITX_PATH/$file"
  done
  unlink "$FCITX_PATH/current"
  cd - >/dev/null
fi

# Undo the configuration
FCITX_BASE_DIR="$HOME/.config/fcitx5"
if [[ ! -d $FCITX_BASE_DIR ]]; then
  FCITX_BASE_DIR=$(gum input --prompt "Where is your Fcitx configuration directory? " --placeholder "$FCITX_BASE_DIR")
fi

FCITX_THEME_FILE="$FCITX_BASE_DIR/conf/classicui.conf"

if [[ -f $FCITX_THEME_FILE ]]; then
  if [[ -f $DRESSCODE_PATH/.prior-theme ]]; then
    PRIOR_THEME=$(cat $DRESSCODE_PATH/.prior-theme)
  else
    PRIOR_THEME=""
  fi
  sed -i "s/^Theme=.*$/$PRIOR_THEME/" $FCITX_THEME_FILE
fi

# Destroy the evidence
rm -rf "$DRESSCODE_PATH"

omarchy-restart-app fcitx5

echo "Successfully uninstalled Fcitx Dress Code."
