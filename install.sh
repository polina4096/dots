#!/bin/bash

if [[ "$EUID" != 0 ]]; then
  echo "ERROR: ${0##*/} needs root privileges to run. Exiting gracefully."
  exit 1
fi

if [ $1 -eq 0 ]; then
    echo "Please specify a username: ${0##*/} username"
    exit 1
fi

# Install packages
xbps-install --yes zsh rsync wget git sway Waybar wob pipewire wireplumber pavucontrol elogind dbus-elogind polkit-elogind rtkit eudev chrony xorg-minimal mpv imv foot font-iosevka font-awesome6 micro vscode rustup firefox neofetch libvirt qemu virt-manager xtools fzf light slop ImageMagick ffmpeg yt-dlp grim wl-clipboard slurp pcmanfm

rustup-init -y --default-toolchain nightly
cargo install exa

usermod -a -G users,wheel,audio,video,cdrom,optical,storage,scanner,kvm,input,plugdev,usbmon,kmem,libvirt "$1"

# Services
ln -s /etc/sv/chronyd /var/service/

ln -s /etc/sv/libvirtd /var/service/
ln -s /etc/sv/virtlockd /var/service/
ln -s /etc/sv/virtlogd /var/service/

ln -s /etc/sv/pipewire /var/service/
ln -s /etc/sv/pipewire-pulse /var/service/
ln -s /etc/sv/wireplumber /var/service/

ln -s /etc/sv/dbus /var/service/
ln -s /etc/sv/polkitd /var/service/
ln -s /etc/sv/rtkit /var/service/

# Fix font rendering
bash voidlinux-fix-font-rendering.sh

# Copy dots
rsync -a ./home/ "/home/$1"

# Reconfigure
xbps-reconfigure -fa

# Sudoers
echo "
%wheel ALL=(ALL:ALL) ALL
$1 ALL = (root) NOPASSWD: /home/$1/dev/connect.sh
$1 ALL = (root) NOPASSWD: /home/$1/dev/set_brightness.sh
$1 ALL = (root) N
OPASSWD: /bin/reboot
" >> /etc/sudoers

# Install from git
mkdir "/home/$1/git" &&
cd "/home/$1/git" &&
git clone https://github.com/lbonn/rofi.git &&
# TODO: install deps them, build and install rofi