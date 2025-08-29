# Omarchy Fcitx Dress Code

I love [Omarchy](https://omarchy.org). And I need [Fcitx](https://fcitx-im.org) every time I want to type in Japanese.

I wish they would play nicely together.

## What is the problem here?

Out of the box, Omarchy works great and *looks like a million bucks*. 

Fcitx works better than it looks. Left to its own devices, its appearance is not suitable for mixed company.

This project is my attempt to dress up Fcitx to the point that it can be invited to the Omarchy party.

## What's in the box?

The project is only a few days old, still in initial development. Here's what is coming:

1. A set of color themes for Fcitx to coordinate with each of the default themes that ship with Omarchy.

2. Control scripts and a small patch to integrate with `omarchy-theme-set`, so that updating the theme from Omarchy's native utilities also updates Fcitx.

3. A script to install the themes and wire up the Omarchy integration.

4. A script to uninstall everything.

5. A generator script and a set of templates to facilitate the creation of new Fcitx themes, so you can add your own themes, and so I can keep up as DHH accepts new themes into Omarchy.

## Installation

Simply run "install.sh".

By default, the theme files and scripts will be installed to `$HOME/.local/share/fcitx-dresscode`. To specify a different location, set the `DRESSCODE_PATH` environment variable.

The themes and scripts are then symlinked to the locations where Omarchy and Fcitx expect them. For Omarchy, this is under `$OMARCHY_PATH/bin`, but you shouldn't need to modify this.

For Fcitx, it reads theme files from `$HOME/.local/share/fcitx5/themes`. If you have somehow configured Fcitx to look in a different directory (I do not know how to make it do so), you will need to set the `$FCITX_PATH` environment variable before running `install.sh`.

## Configuration

Fcitx needs to know the name of the theme to use. It reads this from the `classicui.conf` file, which by default lives at `$HOME/.config/fcitx5/conf/classicui.conf`. For Dress Code to work correctly, this file needs to contain the following directive:

`Theme=current`

The installer will offer to set this value for you automatically. If you decline (or if the script fails), you will need to edit the file manually.

### "current"?
Like Omarchy itself, Dress Code works by changing the `current` symlink to point to the desired theme files. Thus, Dress Code does not need to touch your config each time you change themes. You just set the config once and forget it.

## Usage

After installation, you shouldn't need to do anything. Fcitx should update right along with the rest of Omarchy whenever you change themes.

## Generating new themes

Have hex codes handy for six different colors:
- primary text color
- primary highlight color
- background color
- secondary text color (text color against the primary highlight)
- secondary highlight color
- icon color

Have a look at the existing themes to get a feel for the palette scheme. I came up withe palette color names by studying the (beautiful) themes I found in the [Catppuccin Fcitx Themes](https://github.com/catppuccin/fcitx5) project, as well as the various theme files shipped with Omarchy.

Once you've picked your colors, run `generator.sh`. It will prompt you for the name of your theme and the color palette. If it can't find your template or themes directories, it will ask you for those as well.

By default, the generator will install the themes into the `themes` subdirectory of the current directory, because the assumption is that you are running the script from the root of this project and that you want to save it in Git. (In other words, I wrote the generator for myself, for the purpose of updating this project as DHH adds new themes to Omarchy). If you want to generate a new theme directly into your local Dress Code installation, set the `THEMES_DIR` environment variable.

Similarly, you can set the `TEMPLATE_PATH` environment variable if you are running the script from outside the root of this project.

## Dependencies

To *run* Dress Code, all you need is a working Omarchy box with Fcitx installed and configured. (Dress Code will not install or configure Fcitx for you.)

To *install* Dress Code, you also need [gum](https://github.com/charmbracelet/gum), but you should have this already, since Omarchy uses it.

To *generate new Fcitx themes* you will also need ImageMagick.

## Attributions

The Fcitx theme files in this project are based on the excellent collection provided by [Catppuccin Fcitx](https://github.com/catppuccin/fcitx5).

And of course, a big thank-you to David Heinemeier Hansson for Omarchy.

## License

MIT. Do what you want.
