#!/usr/bin/env bash

if [[ "$EUID" != 0 ]]; then
  echo "ERROR: ${0##*/} needs root privileges to run. Exiting gracefully."
  exit 1
fi

f=(10-hinting-slight.conf 10-scale-bitmap-fonts.conf 10-sub-pixel-rgb.conf 11-lcdfilter-default.conf 20-unhint-small-vera.conf 21-cantarell-hinting.conf 30-metric-aliases.conf 30-urw-aliases.conf 31-cantarell.conf 40-nonlatin.conf 42-luxi-mono.conf 45-latin.conf 49-sansserif.conf 50-user.conf 51-local.conf 57-dejavu-sans-mono.conf 57-dejavu-sans.conf 57-dejavu-serif.conf 60-latin.conf 65-fonts-persian.conf 65-nonlatin.conf 69-unifont.conf 70-no-bitmaps.conf 80-delicious.conf 90-synthetic.conf)
for i in "${f[@]}"; do ln -s /usr/share/fontconfig/conf.avail/"$i" /etc/fonts/conf.d; done
f=(10-hinting-slight.conf 10-sub-pixel-rgb.conf 50-user.conf 60-latin.conf 70-no-bitmaps.conf)
for i in "${f[@]}"; do ln -s /usr/share/fontconfig/conf.avail/"$i" /etc/fonts/conf.d; done

echo '
# Subpixel hinting mode can be chosen by setting the right TrueType interpreter
# version. The available settings are:
#
# truetype:interpreter-version=35 # Classic mode (default in 2.6)
# truetype:interpreter-version=38 # Infinality mode
# truetype:interpreter-version=40 # Minimal mode (default in 2.7)
#
# There are more properties that can be set, separated by whitespace. Please
# refer to the FreeType documentation for details.

# Uncomment and configure below

export FREETYPE_PROPERTIES="truetype:interpreter-version=38"
' >> /etc/profile.d/freetype2.sh


