#!/bin/bash

FCITX_CONF_DIR="$HOME/.config/fcitx5/conf"

if [[ ! -d "$FCITX_CONF_DIR" ]]; then
  FCITX_CONF_DIR=$(gum input --prompt "Where is your Fcitx config directory? " --placeholder "/absolute/path/to/fcitx5/conf")
fi

if [[ ! -d "$FCITX_CONF_DIR" ]]; then
  echo "Error: $FCITX_CONF_DIR not found."
  exit 1
fi

FCITX_CONF_FILE="$FCITX_CONF_DIR/classicui.conf"

if grep -qF "Theme=" "$FCITX_CONF_FILE" 2>/dev/null; then
  sed -i "s/^Theme=.*$/Theme=current/" "$FCITX_CONF_FILE"
  echo "Updated Fcitx config to use the current Dress Code theme."
else
  echo "Theme=current" >>"$FCITX_CONF_FILE"
  echo "Added Fcitx config to use the current Dress Code theme."
fi
