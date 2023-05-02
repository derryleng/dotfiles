-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, 'luarocks.loader')

local awful = require'awful'
local beautiful = require'beautiful'
local gears = require'gears'

------------------------------------ Theme ------------------------------------

local theme_name = "custom1"

beautiful.init(os.getenv('HOME') .. string.format('/.config/awesome/themes/%s/theme.lua', theme_name))

---------------------------------- Variables ----------------------------------

vars = {
    terminal = os.getenv('TERMINAL') or 'alacritty',
    editor   = os.getenv('EDITOR')   or 'nvim',
    shell    = os.getenv('SHELL')    or '/bin/bash',
}

vars.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.fair,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.floating,
}

vars.tags = {'1', '2', '3', '4', '5', '6', '7', '8', '9'}

vars.tags_small = {'1', '2', '3', '4', '5'}

------------------------- Mouse and Keyboard Bindings -------------------------

mod = {
    alt   = 'Mod1',
    super = 'Mod4',
    shift = 'Shift',
    ctrl  = 'Control',
}

require'bindings'

------------------------------- Signal Handlers -------------------------------

require'signals'

----------------------------------- Widgets -----------------------------------

require'widgets'

------------------------------ Startup Commands -------------------------------

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("sleep 5 && pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({
    --"xrandr --output DP-2 --mode 3840x2160 --pos 0x720 --dpi 163 --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate left --dpi 96 --scale 1.5x1.5",
    "setxkbmap gb",
    "xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > ~/.config/awesome/archmenu.lua",
    "picom",
})
