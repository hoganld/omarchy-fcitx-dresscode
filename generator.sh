#!/bin/bash

THEME_NAME=$1

if [[ -z "$THEME_NAME" ]]; then
	THEME_NAME=$(gum input --placeholder "Theme name?")
fi

THEME_PATH="themes/${THEME_NAME}"

# check for templates, abort if not found
if [[ ! -f "templates/theme.conf" ]] || [[ ! -f "templates/arrow.svg" ]] || [[ ! -f "templates/radio.svg" ]]; then
	echo "Error: template files not found. Aborting."
	exit 1
fi

# check for pre-existing theme files, abort if found
if [[ -f "$THEME_PATH/theme.conf" ]] || [[ -f "$THEME_PATH/arrow.png" ]] || [[ -f "$THEME_PATH/radio.png" ]]; then
	echo "Error: $THEME_NAME files already exist. Aborting."
	exit 1 
fi

# check for colors in environment, prompting for those not found, and validating format:
if [[ -f "$THEME_PATH/colors.sh" ]]; then
	source "$THEME_PATH/colors.sh"
fi

REGHEX='^#[[:xdigit:]]{6}$'

while [[ ! "$COLOR_TEXT_PRIMARY" =~ $REGHEX ]]; do
	echo "Primary text color?"
	COLOR_TEXT_PRIMARY=$(gum input --placeholder "#d4d4d4")
done

while [[ ! "$COLOR_TEXT_SECONDARY" =~ $REGHEX ]]; do
	echo "Secondary text color?"
	COLOR_TEXT_SECONDARY=$(gum input --placeholder "#323232")
done

while [[ ! "$COLOR_HIGHLIGHT_PRIMARY" =~ $REGHEX ]]; do
	echo "Primary highlight color?"
	COLOR_HIGHLIGHT_PRIMARY=$(gum input --placeholder "#60a5fa")
done

while [[ ! "$COLOR_HIGHLIGHT_SECONDARY" =~ $REGHEX ]]; do
	echo "Secondaryhighlight color?"
	COLOR_HIGHLIGHT_SECONDARY=$(gum input --placeholder "#f87171")
done

while [[ ! "$COLOR_BACKGROUND" =~ $REGHEX ]]; do
	echo "Background color?"
	COLOR_BACKGROUND=$(gum input --placeholder "#525252")
done

while [[ ! "$COLOR_ICON" =~ $REGHEX ]]; do
	echo "Icon color?"
	COLOR_ICON=$(gum input --placeholder "#a3a3a3")
done

# create theme dir if needed (it can already exist, so long as it's empty)
echo "Generating theme ${THEME_NAME}"
if [[ ! -d "$THEME_PATH" ]]; then
	mkdir -p "$THEME_PATH"
fi

# substitute theme colors into templates and copy into theme dir
# copy templates into theme dir
cp "templates/theme.conf" "$THEME_PATH/theme.conf"
cp "templates/arrow.svg" "$THEME_PATH/arrow.svg"
cp "templates/radio.svg" "$THEME_PATH/radio.svg"

# insert theme colors into theme.conf
sed -i "s/COLOR_TEXT_PRIMARY/${COLOR_TEXT_PRIMARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_TEXT_SECONDARY/${COLOR_TEXT_SECONDARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_HIGHLIGHT_PRIMARY/${COLOR_HIGHLIGHT_PRIMARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_HIGHLIGHT_SECONDARY/${COLOR_HIGHLIGHT_SECONDARY}/g" "$THEME_PATH/theme.conf"
sed -i "s/COLOR_BACKGROUND/${COLOR_BACKGROUND}/g" "$THEME_PATH/theme.conf"

# insert theme colors into SVGs
sed -i "s/COLOR_ICON/${COLOR_ICON}/g" "$THEME_PATH/arrow.svg"
sed -i "s/COLOR_ICON/${COLOR_ICON}/g" "$THEME_PATH/radio.svg"

# convert SVGs to PNGs and clean up
if command -v magick &> /dev/null; then
	magick "$THEME_PATH/arrow.svg" "$THEME_PATH/arrow.png"
	magick "$THEME_PATH/radio.svg" "$THEME_PATH/radio.png"
	rm "$THEME_PATH/arrow.svg"
	rm "$THEME_PATH/radio.svg"
	exit 0
else
	echo "ImageMagick is not installed; PNG files not generated."
	exit 1
fi
