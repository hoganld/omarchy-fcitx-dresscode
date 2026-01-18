# Mekashiya

> めかし屋; 粧し屋
>
> *Noun:* fashionable person; dandy; flashy dresser; fop
>
> -- [*Jim Breen's WWWJDIC*](https://www.edrdg.org/cgi-bin/wwwjdic/wwwjdic)

I love [Omarchy](https://omarchy.org). And I need [Fcitx](https://fcitx-im.org) every time I want to type in Japanese.

I wish they would play nicely together.

## What is the problem here?

Out of the box, Omarchy works great and *looks like a million bucks*. 

Fcitx works better than it looks. Left to its own devices, its appearance is not suitable for mixed company.

This project is my attempt to dress up Fcitx to the point that it can be invited to the Omarchy party.

## What's in the box?

1. A set of color themes for Fcitx to coordinate with each of the default themes that ship with Omarchy.

2. One control script to update the Fcitx theme, integrated into the Omarchy theme switching machinery via the `theme-set` hook.

3. A script to install the themes and wire up the Omarchy integration.

4. A script to uninstall everything.

5. A generator script and a set of templates to facilitate the creation of new Fcitx themes, so you can add your own themes, and so I can keep up as DHH accepts new themes into Omarchy.

## Installation

Simply run "install.sh".

By default, the themes are installed into `$HOME/.local/share/fcitx5/themes`, which is where Fcitx expects them by default. If you have somehow configured a different Fcitx theme directory (I do not know how to do it, but it may well be possible), you will need to set the `FCITX_THEMES_ROOT` environment variable before running `install.sh`.

Mekashiya works by calling the `mekashiya-set` script from Omarchy's `theme-set` hook (`$HOME/.config/omarchy/hooks/theme-set`). The installer will attempt to patch the hook automatically, but if it fails, you will need to patch it manually. Inspect `install.sh` for the code to patch in `theme-set`. It's a one-liner. The `mekashiya-set` script will be installed to `$HOME/.local/bin` by default. To put it elsewhere, set the `LOCAL_BIN` environment variable before running `install.sh`.

## Usage

After installation, you shouldn't need to do anything. Fcitx should update right along with the rest of Omarchy whenever you change themes.

## Generating new themes

Have hex codes handy for just three colors:
- background color
- highlight color
- text color

Have a look at the existing themes to get a feel for the palette scheme. I came up withe palette color names by studying the (beautiful) themes I found in the [Catppuccin Fcitx Themes](https://github.com/catppuccin/fcitx5) project, as well as the various theme files shipped with Omarchy.

Once you've picked your colors, run `generator.sh`. It will prompt you for the name of your theme and the color palette. If it can't find your template or themes directories, it will ask you for those as well.

By default, the generator will install the themes into the `themes` subdirectory of the current directory, because the assumption is that you are running the script from the root of this project and that you want to save it in Git. (In other words, I wrote the generator for myself, for the purpose of updating this project as DHH adds new themes to Omarchy). If you want to generate a new theme directly into your local Mekashiya installation, set the `THEMES_DIR` environment variable.

Similarly, you can set the `TEMPLATE_PATH` environment variable if you are running the script from outside the root of this project.

## Dependencies

To *run* Mekashiya, all you need is a working Omarchy box with Fcitx installed and configured. (Mekashiya will not install or configure Fcitx for you. It should be installed by Omarchy already.)

Mekashiya uses `gdbus` to dynamically update the theme, but you should not have to worry about this, since Omarchy installs `gdbus` by default.

To *install* Mekashiya, you also need [gum](https://github.com/charmbracelet/gum), but you should have this already, since Omarchy uses it.

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
