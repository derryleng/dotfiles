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
    terminal = 'alacritty',
    editor   = 'nvim',
    shell    = '/bin/bash',
    browser  = 'firefox',
    explorer = 'thunar',
}

vars.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.fair,
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
    "xrandr --output HDMI-0 --scale 1.5x1.5",
    "setxkbmap gb",
    "xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu > ~/.config/awesome/archmenu.lua && sed -i 's/xterm/alacritty/g' ~/.config/awesome/archmenu.lua",
    "picom",
    "volumeicon",
    "nm-applet",
    "ibus-daemon -rxR",
    --"openrgb -d 0 -m direct -c 000000 -b 0",
})
