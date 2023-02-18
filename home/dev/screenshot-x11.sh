#!/bin/bash

slop=$(slop -p 4 -f "%g") || exit 1
read -r G < <(echo $slop)
import -window root -crop $G png:- |  xclip -selection clipboard -t image/png
