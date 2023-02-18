# dotfiles

Dotfiles and automated bash setup scripts that install programs I use and a nightly rust toolchain.

> Proceed with caution, don't run install scripts if unsure. It may not work for your configuration, or even break your system!

Should be fine on a fresh install of 64 bit Void Linux with glibc, but it's recomended to change the sway configuration as I use an overclocked 3200x2000@96hz screen with 200% scaling.

## How-to
Install Void Linux and run `sudo ./install.sh`, then switch to tty2 using <kbd>ctrl + alt + f2</kbd>, login into your user, navigate to the repository folder and run `sudo ./install-autologin.sh`, reboot.

There's also some custom firefox `userChrome.css` css in `manual` directory, no automated installation is provided.

Waybar may show a few errors as I use this on my laptop which has a backlight, battery and temperature sensors. Configure appropriately.