#!/bin/sh

# Enable Firefox experimental wayland support:
export MOZ_ENABLE_WAYLAND=1
# If qt apps are using Xorg, try:
export QT_QPA_PLATFORM=wayland-egl
# Cursor size fix
export XCURSOR_THEME=Adwaita
export XCURSOR_SIZE=64

WLR_DRM_DEVICES=/dev/dri/card0 dbus-run-session sway --unsupported-gpu
