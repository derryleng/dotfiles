local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
require'awful.hotkeys_popup.keys'
local menubar = require'menubar'

local menu = require'widgets.menu'

-- awesome
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 's',
      description = 'show help',
      group       = 'Awesome',
      on_press    = hotkeys_popup.show_help,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'w',
      description = 'show main menu',
      group       = 'Awesome',
      on_press    = function() menu.mainmenu:show() end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'r',
      description = 'reload awesome',
      group       = 'Awesome',
      on_press    = awesome.restart,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'q',
      description = 'quit awesome',
      group       = 'Awesome',
      on_press    = awesome.quit,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'x',
      description = 'lua execute prompt',
      group       = 'Awesome',
      on_press    = function()
         awful.prompt.run{
            prompt = 'run lua code: ',
            textbox = awful.screen.focused().promptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. '/history_eval'
         }
      end,
   },
}

-- launch
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'Return',
      description = 'open a terminal',
      group       = 'launch',
      on_press    = function() awful.spawn(vars.terminal) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'r',
      description = 'run prompt',
      group       = 'launch',
      on_press    = function() awful.screen.focused().promptbox:run() end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'p',
      description = 'show the menubar',
      group       = 'launch',
      on_press    = function() menubar.show() end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'a',
      description = 'launch rofi (drun)',
      group       = 'launch',
      on_press    = function()
         awful.spawn(string.format('rofi -show drun -theme styles/drun.rasi -terminal %s', vars.terminal))
      end,
   },
   awful.key{
      modifiers   = {mod.alt},
      key         = 'space',
      description = 'launch rofi (combi)',
      group       = 'launch',
      on_press    = function()
         awful.spawn(string.format('rofi -show combi -theme styles/combi.rasi -terminal %s', vars.terminal))
      end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'e',
      description = 'open file explorer',
      group       = 'launch',
      on_press    = function() awful.spawn(vars.explorer) end,
   },
}

-- Focus
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'j',
      description = 'focus next by index',
      group       = 'screen',
      on_press    = function() awful.client.focus.byidx(1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'k',
      description = 'focus previous by index',
      group       = 'screen',
      on_press    = function() awful.client.focus.byidx(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Tab',
      description = 'go back',
      group       = 'screen',
      on_press    = function()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'u',
      description = 'jump to urgent client',
      group       = 'screen',
      on_press    = awful.client.urgent.jumpto,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'j',
      description = 'focus the next screen',
      group       = 'screen',
      on_press    = function() awful.screen.focus_relative(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'k',
      description = 'focus the previous screen',
      group       = 'screen',
      on_press    = function() awful.screen.focus_relative(-1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'n',
      description = 'restore minimized',
      group       = 'screen',
      on_press    = function()
         local c = awful.client.restore()
         if c then
            c:active{raise = true, context = 'key.unminimize'}
         end
      end,
   },
}

-- Layout
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'space',
      description = 'select next',
      group       = 'layout',
      on_press    = function() awful.layout.inc(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'space',
      description = 'select previous',
      group       = 'layout',
      on_press    = function() awful.layout.inc(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'l',
      description = 'increase master width factor',
      group       = 'layout',
      on_press    = function() awful.tag.incmwfact(0.05) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'h',
      description = 'decrease master width factor',
      group       = 'layout',
      on_press    = function() awful.tag.incmwfact(-0.05) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'h',
      description = 'increase the number of columns',
      group       = 'layout',
      on_press    = function() awful.tag.incncol(1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'l',
      description = 'decrease the number of columns',
      group       = 'layout',
      on_press    = function() awful.tag.incncol(-1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'j',
      description = 'swap with next client by index',
      group       = 'layout',
      on_press    = function() awful.client.swap.byidx(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'k',
      description = 'swap with previous client by index',
      group       = 'layout',
      on_press    = function() awful.client.swap.byidx(-1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'h',
      description = 'increase the number of master clients',
      group       = 'layout',
      on_press    = function() awful.tag.incnmaster(1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'l',
      description = 'decrease the number of master clients',
      group       = 'layout',
      on_press    = function() awful.tag.incnmaster(-1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift, mod.ctrl, mod.alt},
      keygroup    = 'numrow',
      description = 'select layout directly',
      group       = 'layout',
      on_press    = function(index)
         local tag = awful.screen.focused().selected_tag
         if tag then
            tag.layout = tag.layouts[index] or tag.layout
         end
      end
   },
}

-- Tags
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'Left',
      description = 'view previous',
      group       = 'screen',
      on_press    = awful.tag.viewprev,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Right',
      description = 'view next',
      group       = 'screen',
      on_press    = awful.tag.viewnext,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Escape',
      description = 'go back',
      group       = 'screen',
      on_press    = awful.tag.history.restore,
   },
   awful.key{
      modifiers   = {mod.super},
      keygroup    = 'numrow',
      description = 'only view tag',
      group       = 'screen',
      on_press    = function(index)
         local screen = awful.screen.focused()
         local tag = screen.tags[index]
         if tag then
            tag:view_only()
         end
      end
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      keygroup    = 'numrow',
      description = 'toggle tag',
      group       = 'screen',
      on_press    = function(index)
         local screen = awful.screen.focused()
         local tag = screen.tags[index]
         if tag then
            awful.tag.viewtoggle(tag)
         end
      end
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      keygroup    = 'numrow',
      description = 'move focused client to tag',
      group       = 'screen',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then
               client.focus:move_to_tag(tag)
            end
         end
      end
   },
   awful.key {
      modifiers   = {mod.super, mod.ctrl, mod.shift},
      keygroup    = 'numrow',
      description = 'toggle focused client on tag',
      group       = 'screen',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then
               client.focus:toggle_tag(tag)
            end
         end
      end,
   },
}


-- Keyboard function keys
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {},
      key         = 'XF86MonBrightnessDown',
      description = 'brightness down',
      group       = 'keyboard function',
      on_press    = function() os.execute("xbacklight -dec 5") end,
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86MonBrightnessUp',
      description = 'brightness up',
      group       = 'keyboard function',
      on_press    = function() os.execute("xbacklight -inc 5") end,
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioMute',
      description = 'toggle mute',
      group       = 'keyboard function',
      on_press    = function() os.execute("amixer -q set Master toggle") end,
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioLowerVolume',
      description = 'volume down',
      group       = 'keyboard function',
      on_press    = function() os.execute("amixer set Master 5%-") end,
   },
   awful.key{
      modifiers   = {},
      key         = 'XF86AudioRaiseVolume',
      description = 'volume up',
      group       = 'keyboard function',
      on_press    = function() os.execute("amixer set Master 5%+") end,
   },
}
