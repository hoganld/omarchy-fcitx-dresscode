#!/bin/bash

THEME_NAME=$1

if [[ -z "$THEME_NAME" ]]; then
	THEME_NAME=$(gum input --prompt "Theme name > " --placeholder "tokyo-night")
fi

TEMPLATE_PATH="templates"
if [[ ! -d "$TEMPLATE_PATH" ]]; then
	echo "Where is your template directory?"
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
REGHEX='^#[[:xdigit:]]{6}$'
ERR_BAD_COLOR="Error: invalid color. Please use hex color format."

while [[ ! "$COLOR_TEXT_PRIMARY" =~ $REGHEX ]]; do
	COLOR_TEXT_PRIMARY=$(gum input --prompt "Primary text color > " --placeholder "#d4d4d4")
	if [[ ! "$COLOR_TEXT_PRIMARY" =~ $REGHEX ]]; then
		echo "$ERR_BAD_COLOR"
	fi
done

while [[ ! "$COLOR_TEXT_SECONDARY" =~ $REGHEX ]]; do
	COLOR_TEXT_SECONDARY=$(gum input --prompt "Secondary text color > " --placeholder "#323232")
	if [[ ! "$COLOR_TEXT_SECONDARY" =~ $REGHEX ]]; then
		echo "$ERR_BAD_COLOR"
	fi
done

while [[ ! "$COLOR_HIGHLIGHT_PRIMARY" =~ $REGHEX ]]; do
	COLOR_HIGHLIGHT_PRIMARY=$(gum input --prompt "Primary highlight color > " --placeholder "#60a5fa")
	if [[ ! "$COLOR_HIGHLIGHT_PRIMARY" =~ $REGHEX ]]; then
		echo "$ERR_BAD_COLOR"
	fi
done

while [[ ! "$COLOR_HIGHLIGHT_SECONDARY" =~ $REGHEX ]]; do
	COLOR_HIGHLIGHT_SECONDARY=$(gum input --prompt "Secondary highlight color > " --placeholder "#f87171")
	if [[ ! "$COLOR_HIGHLIGHT_SECONDARY" =~ $REGHEX ]]; then
		echo "$ERR_BAD_COLOR"
	fi
done

while [[ ! "$COLOR_BACKGROUND" =~ $REGHEX ]]; do
	COLOR_BACKGROUND=$(gum input --prompt "Background color > " --placeholder "#525252")
	if [[ ! "$COLOR_BACKGROUND" =~ $REGHEX ]]; then
		echo "$ERR_BAD_COLOR"
	fi
done

while [[ ! "$COLOR_ICON" =~ $REGHEX ]]; do
	COLOR_ICON=$(gum input --prompt "Icon color > " --placeholder "#a3a3a3")
	if [[ ! "$COLOR_ICON" =~ $REGHEX ]]; then
		echo "$ERR_BAD_COLOR"
	fi
done

# create theme dir if needed
echo "Generating theme ${THEME_NAME}"
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
