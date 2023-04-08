local _M = {}

local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
local beautiful = require'beautiful'
local xresources = require'beautiful.xresources'
local wibox = require'wibox'
local dpi = xresources.apply_dpi

local mod = require'bindings.mod'

local volume_widget = require'awesome-wm-widgets.volume-widget.volume'
local spotify_widget = require'awesome-wm-widgets.spotify-widget.spotify'

_M.sep = wibox.widget.separator{
   orientation  = 'vertical',
   color        = '#888888',
   forced_width = dpi(8),
   thickness    = 1,
}

_M.keyboardlayout = awful.widget.keyboardlayout:new()

_M.textclock = wibox.widget.textclock('%a %d %b %H:%M ')
_M.calendar = awful.widget.calendar_popup.year()
_M.calendar:attach(_M.textclock, 'tr')

_M.volume = volume_widget{
   step        = 1,
   widget_type = 'custom',
}

_M.spotify = spotify_widget{
   play_icon  = '/usr/share/icons/Arc/actions/24/media-playback-start.png',
   pause_icon =  '/usr/share/icons/Arc/actions/24/media-playback-pause.png',
   font       = 'Terminus 9',
   max_length = -1,
   sp_bin     = os.getenv('HOME') .. '/.config/awesome/scripts/sp'
}

function _M.create_promptbox() return awful.widget.prompt() end

function _M.create_layoutbox(s)
   return awful.widget.layoutbox{
      screen = s,
      buttons = {
         awful.button{
            button    = 1,
            modifiers = {},
            on_press  = function() awful.layout.inc(1) end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function() awful.layout.inc(-1) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function() awful.layout.inc(1) end,
         },
      }
   }
end

function _M.create_taglist(s)
   return awful.widget.taglist{
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function(t) t:view_only() end,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 1,
            on_press  = function(t)
               if client.focus then
                  client.focus:move_to_tag(t)
               end
            end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = awful.tag.viewtoggle,
         },
         awful.button{
            modifiers = {mod.super},
            button    = 3,
            on_press  = function(t)
               if client.focus then
                  client.focus:toggle_tag(t)
               end
            end
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function(t) awful.tag.viewprev(t.screen) end,
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function(t) awful.tag.viewnext(t.screen) end,
         },
      }
   }
end

function _M.create_tasklist(s)
   return awful.widget.tasklist{
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = {
         awful.button{
            modifiers = {},
            button    = 1,
            on_press  = function(c)
               c:activate{context = 'tasklist', action = 'toggle_minimization'}
            end,
         },
         awful.button{
            modifiers = {},
            button    = 3,
            on_press  = function() awful.menu.client_list{theme = {width = 500}} end
         },
         awful.button{
            modifiers = {},
            button    = 4,
            on_press  = function() awful.client.focus.byidx(-1) end
         },
         awful.button{
            modifiers = {},
            button    = 5,
            on_press  = function() awful.client.focus.byidx(1) end
         },
      }
   }
end

function _M.create_wibox(s)
   return awful.wibar{
      screen = s,
      position = 'top',
      opacity = 0.9,
      widget = {
         layout = wibox.layout.align.horizontal,
         -- left widgets
         {
            layout = wibox.layout.fixed.horizontal,
            -- _M.launcher,
            s.taglist,
            s.promptbox,
         },
         -- middle widgets
         s.tasklist,
         -- right widgets
         {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            _M.spotify,
            _M.sep,
            _M.volume,
            _M.sep,
            _M.keyboardlayout,
            _M.sep,
            _M.textclock,
            s.layoutbox,
         }
      }
   }
end

return _M
