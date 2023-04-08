local awful = require'awful'

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("sleep 5 && pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({
    --"xrandr --output DP-2 --mode 3840x2160 --pos 0x720 --dpi 163 --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate left --dpi 96 --scale 1.5x1.5",
    "picom",
})
