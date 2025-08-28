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

2. A script to update the running Fcitx theme.

3. A patch for Omarchy's `bin/omarchy-theme-set` script to call this new Fcitx theme update script, so that updating the theme from Omarchy's native utilities also updates Fcitx.

4. Scripts to install the themes and patch the Omarchy update script.

5. A script and a set of templates to facilitate the creation of new Fcitx themes, so you can add your own themes, and so I can keep up as DHH accepts new themes into Omarchy.

## Attributions
The Fcitx theme files in this project are based on the excellent collection provided by [Catppuccin Fcitx](https://github.com/catppuccin/fcitx5).

## License

MIT. Do what you want.
