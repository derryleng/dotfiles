#!/usr/bin/env bash
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar bspwm-1 2>&1 | tee -a /tmp/polybar1.log & disown
polybar bspwm-6 2>&1 | tee -a /tmp/polybar2.log & disown

