#!/bin/bash

sudo /home/polina/dev/set_brightness.sh $(python -c "print($(cat /sys/class/backlight/amdgpu_bl0/brightness) - 5)")
