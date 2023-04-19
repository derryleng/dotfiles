#!/usr/bin/env bash
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar bar-bspwm1 2>&1 | tee -a /tmp/polybar1.log & disown
polybar bar-bspwm2 2>&1 | tee -a /tmp/polybar2.log & disown

xdo below -t $(xdo id -a DP-2) $(xdo id -a polybar-bar-bspwm1_DP-2)
xdo below -t $(xdo id -a HDMI-0) $(xdo id -a polybar-bar-bspwm2_HDMI-0)
