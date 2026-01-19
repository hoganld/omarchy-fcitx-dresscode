# Omarchy Fcitx Theme Generator

I love [Omarchy](https://omarchy.org). And I need [Fcitx](https://fcitx-im.org) every time I want to type in Japanese.

I wish they would play nicely together.


## What is the problem here?

Out of the box, Omarchy works great and *looks like a million bucks*. 

Fcitx works better than it looks. Left to its own devices, its appearance is not suitable for mixed company.

This project is my attempt to dress up Fcitx to the point that it can be invited to the Omarchy party.


## What's in the box?

1. A generator script and set of templates to easily create new Fcitx5 themes

2. A set of Fcitx5 color themes that match the default themes that ship with Omarchy

3. A control script to integrate with Omarchy's `theme-set` hook

4. Scripts to install the themes, wire up the Omarchy hook integration

5. A script to uninstall everthing


## Installation

If you just want to install all the themes and plug into Omarchy's `theme-set` hook, simply run "install.sh".


### Installation Details

By default, the themes are installed into `~/.local/share/fcitx5/themes`, which is where Fcitx expects them by default. If you have somehow configured a different Fcitx theme directory (I do not know how to do it, but it may well be possible), you will need to set the `FCITX_THEMES_PATH` environment variable before running `install.sh`.


### Hook Integration Details

The Fcitx theme is hotswapped by the `omarchy-theme-set-fcitx5` script, which is called from Omarchy's `theme-set` hook (`~/.config/omarchy/hooks/theme-set`). The installer will attempt to patch the hook automatically, but if it fails, you will need to patch it manually. Inspect `install.sh` for the code to patch in `~/.config/omarchy/hooks/theme-set`. It's a one-liner. The `omarchy-theme-set-fcitx5` script will be installed to `~/.local/bin` by default. To put it elsewhere, set the `LOCAL_BIN` environment variable before running `install.sh`.


## Usage

After installation, you shouldn't need to do anything. Fcitx should update right along with the rest of Omarchy whenever you change themes.

## Generating new themes

Have hex codes handy for just three colors:
- background color
- highlight color
- text color

Have a look at the existing themes to get a feel for the palette scheme. I came up withe palette color names by studying the (beautiful) themes I found in the [Catppuccin Fcitx Themes](https://github.com/catppuccin/fcitx5) project, as well as the various theme files shipped with Omarchy.

Once you've picked your colors, run `generator.sh`. It will prompt you for the name of your theme and the color palette. If it can't find your template or themes directories, it will ask you for those as well.

The generator will install the themes into the `themes` subdirectory of the current directory, because the assumption is that you are running the script from the root of this project and that you want to save it in Git. (In other words, I wrote the generator for myself, for the purpose of updating this project as DHH adds new themes to Omarchy). If you want to install the new theme directly into your local Fcitx installation, set the `THEMES_DIR` environment variable, or preferably, run `install-theme.sh <theme-name>` after generating the theme.

Similarly, you can set the `TEMPLATE_PATH` environment variable if you are running the script from outside the root of this project.

## Dependencies

To use these themes, all you need is a working Omarchy box with Fcitx installed and configured. (`install.sh` will not install or configure Fcitx for you. It should be installed by Omarchy already.)

`bin/omarchy-theme-set-fcitx5` uses `gdbus` to dynamically update the theme, but you should not have to worry about this, since Omarchy installs `gdbus` by default.

To run the installer, you also need [gum](https://github.com/charmbracelet/gum), but you should have this already, since Omarchy uses it.

To *generate new Fcitx themes* you will also need ImageMagick.

## Attributions

The Fcitx theme files in this project are based on the excellent collection provided by [Catppuccin Fcitx](https://github.com/catppuccin/fcitx5).

The colors come from:

- [Catppuccin](https://catppuccin.com)
- [Everforest](https://github.com/neanias/everforest-nvim)
- [Gruvbox](https://github.com/ellisonleao/gruvbox.nvim)
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [Matte Black](https://github.com/tahayvr/matteblack.nvim)
- [Nord](https://www.nordtheme.com)
- [Osaka Jade](https://github.com/Justikun/omarchy-osaka-jade-theme)
- [Ristretto (Monokai)](https://github.com/loctvl842/monokai-pro.nvim)
- [Rose Pine](https://rosepinetheme.com)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim)

And of course, a big thank-you to David Heinemeier Hansson for Omarchy.
