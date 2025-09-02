#!/bin/bash

write-color-file() {
  COLOR_FILE="$THEME_PATH/colors.sh"
  echo "COLOR_HIGHLIGHT_PRIMARY=${COLOR_HIGHLIGHT_PRIMARY}" >"$COLOR_FILE"
  echo "COLOR_HIGHLIGHT_MENU=${COLOR_HIGHLIGHT_MENU}" >>"$COLOR_FILE"
  echo "COLOR_BACKGROUND=${COLOR_BACKGROUND}" >>"$COLOR_FILE"
  echo "COLOR_TEXT_SELECTED=${COLOR_TEXT_SELECTED}" >>"$COLOR_FILE"
  echo "COLOR_TEXT_PRIMARY=${COLOR_TEXT_PRIMARY}" >>"$COLOR_FILE"
  echo "COLOR_ICON=${COLOR_ICON}" >>"$COLOR_FILE"
}

valid-color() {
  local REGHEX='^#[[:xdigit:]]{6}$'
  if [[ "$1" =~ $REGHEX ]]; then
    true
  else
    false
  fi
}

get-color() {
  local COLOR="$1"
  local PROMPT="$2"

  if valid-color "$COLOR" && gum confirm "Use $COLOR as $PROMPT?"; then
    echo "$COLOR"
  else
    prompt-for-color "$PROMPT"
  fi
}

prompt-for-color() {
  local ERR_BAD_COLOR="Error: invalid color. Please use hex color format."
  local COLOR=""
  local PROMPT="$1"

  while ! valid-color "$COLOR"; do
    COLOR="#$(gum input --prompt "$PROMPT: #" --placeholder "7ab4fb" || exit 1)"
    if ! valid-color "$COLOR"; then
      echo "$ERR_BAD_COLOR" >&2
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
  warning="Warning: $THEME_NAME files already exist. Overwrite?"
  gum confirm "$warning" && rm "$THEME_PATH/theme.conf" "$THEME_PATH/arrow.png" "$THEME_PATH/radio.png" || exit 0
fi

# Reuse colors if available
source "$THEME_PATH/colors.sh" >/dev/null 2>&1

# Prompt for palette colors, validating format each time
COLOR_HIGHLIGHT_PRIMARY=$(get-color "$COLOR_HIGHLIGHT_PRIMARY" "Primary Highlight Color")
COLOR_HIGHLIGHT_MENU=$(get-color "$COLOR_HIGHLIGHT_MENU" "Menu Highlight Color")
COLOR_BACKGROUND=$(get-color "$COLOR_BACKGROUND" "Background Color")
COLOR_TEXT_SELECTED=$(get-color "$COLOR_TEXT_SELECTED" "Selected Text Color")
COLOR_TEXT_PRIMARY=$(get-color "$COLOR_TEXT_PRIMARY" "Primary Text Color")
COLOR_ICON=$(get-color "$COLOR_ICON" "Icon Color")

echo "Generating theme ${THEME_NAME}"

# create theme dir if needed
mkdir -p "$THEME_PATH"

write-color-file

# copy templates into theme dir
cp "$TEMPLATE_PATH/theme.conf" "$THEME_PATH/theme.conf"
cp "$TEMPLATE_PATH/arrow.svg" "$THEME_PATH/arrow.svg"
cp "$TEMPLATE_PATH/radio.svg" "$THEME_PATH/radio.svg"

# insert theme colors into theme.conf
sed -i "s/COLOR_TEXT_PRIMARY/${COLOR_TEXT_PRIMARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_TEXT_SELECTED/${COLOR_TEXT_SELECTED}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_HIGHLIGHT_PRIMARY/${COLOR_HIGHLIGHT_PRIMARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_HIGHLIGHT_MENU/${COLOR_HIGHLIGHT_MENU}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_BACKGROUND/${COLOR_BACKGROUND}/g" "$THEME_PATH/theme.conf"

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
