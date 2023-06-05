local _M = {}

local awful = require'awful'
local beautiful = require'beautiful'

local hotkeys_popup = require'awful.hotkeys_popup'
require'awful.hotkeys_popup.keys'

_M.awesomemenu = {
    {'hotkeys', function() awful.hotkeys_popup.show_help(nil, awful.screen.focused()) end},
    {'manual', vars.terminal .. ' -e man awesome'},
    {'edit config', vars.terminal .. ' -e ' .. vars.editor .. ' ' .. awesome.conffile},
    {'restart', awesome.restart},
    {'quit', function() awesome.quit() end},
}

if pcall(require, 'archmenu') then

    local archmenu = require'archmenu'

    table.insert(xdgmenu, {'Settings', _M.awesomemenu, beautiful.awesome_icon})
    table.insert(xdgmenu, {'Terminal', vars.terminal})

    _M.mainmenu = awful.menu{
        items = xdgmenu
    }

else

    _M.mainmenu = awful.menu{
        items = _M.awesomemenu
    }

end

_M.launcher = awful.widget.launcher{
    image = beautiful.awesome_icon,
    menu = _M.mainmenu
}

return _M
