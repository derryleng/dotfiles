#!/usr/bin/env bash
killall polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar-bspwm-main.log /tmp/polyba-bspwm-vert2.log
polybar bspwm-main 2>&1 | tee -a /tmp/polybar-bspwm-main.log & disown
polybar bspwm-vert 2>&1 | tee -a /tmp/polyba-bspwm-vert2.log & disown
