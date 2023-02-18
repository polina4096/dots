#!/bin/bash

sudo kill $(pidof dhcpcd)
sudo kill $(pidof wpa_supplicant)
sudo kill $(pidof wpa_cli)
sudo rm /var/run/wpa_supplicant/wlp2s0
sudo wpa_supplicant -B -i wlp2s0 -c /etc/wpa_supplicant/wpa_supplicant.conf -D wext
sudo dhcpcd wlp2s0
