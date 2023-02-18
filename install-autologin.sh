if [[ "$EUID" != 0 ]]; then
  echo "ERROR: ${0##*/} needs root privileges to run. Exiting gracefully."
  exit 1
fi

if [ $1 -eq 0 ]; then
    echo "Please specify a username: ${0##*/} username"
    exit 1
fi

if [[ "$(tty)" != *"/dev/tty2"* ]]; then
    echo "You must run this from tty2";
    exit 1
fi

# Autologin
cp -R /etc/sv/agetty-tty1 /etc/sv/agetty-autologin-tty1
rm /etc/sv/agetty-autologin-tty1/conf

echo '
GETTY_ARGS="--autologin polina --noclear"
BAUD_RATE=38400
TERM_NAME=linux
' >> /etc/sv/agetty-autologin-tty1/conf

rm /var/service/agetty-tty1
ln -s /etc/sv/agetty-autologin-tty1 /var/service