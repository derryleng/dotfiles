-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- load theme
local beautiful = require'beautiful'
local gears = require'gears'

local theme_name = "custom1"

beautiful.init(os.getenv('HOME') .. string.format('/.config/awesome/themes/%s/theme.lua', theme_name))

-- load key and mouse bindings
require'bindings'

-- load rules
require'rules'

-- load signals
require'signals'

-- load widgets
require'widgets'

-- load autostart
require'autostart'
