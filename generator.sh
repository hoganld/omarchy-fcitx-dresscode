#!/bin/bash

prompt_for_color() {
  local REGHEX='^#[[:xdigit:]]{6}$'
  local ERR_BAD_COLOR="Error: invalid color. Please use hex color format."
  local COLOR=""

  while [[ ! "$COLOR" =~ $REGHEX ]]; do
    COLOR=$(gum input --prompt "$1" --placeholder "$2")
    if [[ ! "$COLOR" =~ $REGHEX ]]; then
      echo "$ERR_BAD_COLOR"
    fi
  done
  echo "$COLOR"
}

THEME_NAME=$1

if [[ -z "$THEME_NAME" ]]; then
  THEME_NAME=$(gum input --prompt "Theme name > " --placeholder "tokyo-night")
fi

TEMPLATE_PATH="templates"
if [[ ! -d "$TEMPLATE_PATH" ]]; then
  cho "Where is your template directory?"
  TEMPLATE_PATH=$(gum input --prompt "Your template directory > " --placeholder "~/path/to/templates")
fi

# check for templates, abort if not found
if [[ ! -f "$TEMPLATE_PATH/theme.conf" ]] || [[ ! -f "$TEMPLATE_PATH/arrow.svg" ]] || [[ ! -f "$TEMPLATE_PATH/radio.svg" ]]; then
  echo "Error: template files not found. Aborting."
  exit 1
fi

THEMES_DIR="themes"
if [[ ! -d "$THEMES_DIR" ]]; then
  THEMES_DIR=$(gum input --prompt "Your Fcitx themes directory > " --placeholder "~/path/to/fcitx/themes")
fi

THEME_PATH="$THEMES_DIR/$THEME_NAME"

# check for pre-existing theme files, prompt for decision if found
if [[ -f "$THEME_PATH/theme.conf" ]] || [[ -f "$THEME_PATH/arrow.png" ]] || [[ -f "$THEME_PATH/radio.png" ]]; then
  echo "Warning: $THEME_NAME files already exist."
  gum confirm "Overwrite?" && rm "$THEME_PATH/theme.conf" "$THEME_PATH/arrow.png" "$THEME_PATH/radio.png" || exit 0
fi

# Prompt for palette colors, validating format each time
COLOR_TEXT_PRIMARY=$(prompt_for_color "Primary text color > " "#d4d4d4")
COLOR_TEXT_SECONDARY=$(prompt_for_color "Secondary text color > " "#323232")
COLOR_HIGHLIGHT_PRIMARY=$(prompt_for_color "Primary highlight color > " "#60a5fa")
COLOR_HIGHLIGHT_SECONDARY=$(prompt_for_color "Secondary highlight color > " "#f87171")
COLOR_BACKGROUND=$(prompt_for_color "Background color > " "#525252")
COLOR_ICON=$(prompt_for_color "Icon color > " "#a3a3a3")

echo "Generating theme ${THEME_NAME}"

# create theme dir if needed
if [[ ! -d "$THEME_PATH" ]]; then
  mkdir -p "$THEME_PATH"
fi

# copy templates into theme dir
cp "$TEMPLATE_PATH/theme.conf" "$THEME_PATH/theme.conf"
cp "$TEMPLATE_PATH/preview.html" "$THEME_PATH/preview.html"
cp "$TEMPLATE_PATH/arrow.svg" "$THEME_PATH/arrow.svg"
cp "$TEMPLATE_PATH/radio.svg" "$THEME_PATH/radio.svg"

# insert theme colors into theme.conf
sed -i "s/COLOR_TEXT_PRIMARY/${COLOR_TEXT_PRIMARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_TEXT_SECONDARY/${COLOR_TEXT_SECONDARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_HIGHLIGHT_PRIMARY/${COLOR_HIGHLIGHT_PRIMARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_HIGHLIGHT_SECONDARY/${COLOR_HIGHLIGHT_SECONDARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_BACKGROUND/${COLOR_BACKGROUND}/g" "$THEME_PATH/theme.conf"

## insert theme colors into preview.html
sed -i "s/THEME_NAME/${THEME_NAME}/g" "$THEME_PATH/preview.html"
sed -i "s/COLOR_TEXT_PRIMARY/${COLOR_TEXT_PRIMARY}/g" "$THEME_PATH/preview.html"
sed -i "s/COLOR_TEXT_SECONDARY/${COLOR_TEXT_SECONDARY}/g" "$THEME_PATH/preview.html"
sed -i "s/COLOR_HIGHLIGHT_PRIMARY/${COLOR_HIGHLIGHT_PRIMARY}/g" "$THEME_PATH/preview.html"
sed -i "s/COLOR_HIGHLIGHT_SECONDARY/${COLOR_HIGHLIGHT_SECONDARY}/g" "$THEME_PATH/preview.html"
sed -i "s/COLOR_BACKGROUND/${COLOR_BACKGROUND}/g" "$THEME_PATH/preview.html"
sed -i "s/COLOR_ICON/${COLOR_ICON}/g" "$THEME_PATH/preview.html"

# insert theme colors into SVGs
sed -i "s/COLOR_ICON/${COLOR_ICON}/g" "$THEME_PATH/arrow.svg"
sed -i "s/COLOR_ICON/${COLOR_ICON}/g" "$THEME_PATH/radio.svg"

# convert SVGs to PNGs and clean up
if command -v magick &>/dev/null; then
  magick "$THEME_PATH/arrow.svg" "$THEME_PATH/arrow.png"
  magick "$THEME_PATH/radio.svg" "$THEME_PATH/radio.png"
  rm "$THEME_PATH/arrow.svg"
  rm "$THEME_PATH/radio.svg"
  exit 0
else
  echo "ImageMagick is not installed; PNG files not generated."
  exit 1
fi
