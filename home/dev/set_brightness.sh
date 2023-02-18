#!/bin/bash

sudo bash -c "echo $1 > /sys/class/backlight/amdgpu_bl0/brightness"
