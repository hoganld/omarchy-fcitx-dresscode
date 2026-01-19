#!/bin/bash

THEME_NAME=$1

mkdir -p "$FCITX_THEMES_PATH/$THEME_NAME"
cp "themes/$THEME_NAME/theme.conf" "$FCITX_THEMES_PATH/$THEME_NAME/"
cp "themes/$THEME_NAME"/*.png "$FCITX_THEMES_PATH/$THEME_NAME/"
