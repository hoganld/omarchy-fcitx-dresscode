#!/bin/bash

FCITX_BASE_DIR="$HOME/.config/fcitx5"

if [[ ! -d "$FCITX_BASE_DIR" ]]; then
  FCITX_BASE_DIR=$(gum input --prompt "Where is your Fcitx configuration directory? " --placeholder "$FCITX_BASE_DIR")
fi

FCITX_CONF_DIR="$FCITX_BASE_DIR/conf"

if [[ ! -d "$FCITX_CONF_DIR" ]]; then
  mkdir -p "$FCITX_CONF_DIR"
fi

FCITX_THEME_FILE="$FCITX_CONF_DIR/classicui.conf"

if grep -qF "Theme=" "$FCITX_THEME_FILE" 2>/dev/null; then
  sed -i "s/^Theme=.*$/Theme=current/" "$FCITX_THEME_FILE"
  echo "Updated Fcitx config to use the current Dress Code theme."
else
  echo "Theme=current" >>"$FCITX_THEME_FILE"
  echo "Added Fcitx config to use the current Dress Code theme."
fi
