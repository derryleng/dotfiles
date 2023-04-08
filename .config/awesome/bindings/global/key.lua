local awful = require'awful'
local hotkeys_popup = require'awful.hotkeys_popup'
require'awful.hotkeys_popup.keys'
local menubar = require'menubar'

local apps = require'config.apps'
local mod = require'bindings.mod'
local menu = require'modules.menu'

menubar.utils.terminal = apps.terminal

-- Awesome
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 's',
      description = 'show help',
      group       = '1. Awesome',
      on_press    = hotkeys_popup.show_help,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'w',
      description = 'show main menu',
      group       = '1. Awesome',
      on_press    = function() menu.mainmenu:show() end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'r',
      description = 'reload awesome',
      group       = '1. Awesome',
      on_press    = awesome.restart,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'q',
      description = 'quit awesome',
      group       = '1. Awesome',
      on_press    = awesome.quit,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'x',
      description = 'lua execute prompt',
      group       = '1. Awesome',
      on_press    = function()
         awful.prompt.run{
            prompt = 'Run Lua code: ',
            textbox = awful.screen.focused().promptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. '/history_eval'
         }
      end,
   },
}

-- Launch
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'Return',
      description = 'open a terminal',
      group       = '2. Launch',
      on_press    = function() awful.spawn(apps.terminal) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'r',
      description = 'run prompt',
      group       = '2. Launch',
      on_press    = function() awful.screen.focused().promptbox:run() end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'p',
      description = 'show the menubar',
      group       = '2. Launch',
      on_press    = function() menubar.show() end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'f',
      description = 'open a browser',
      group       = '2. Launch',
      on_press    = function() awful.spawn(apps.browser) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'a',
      description = 'launch rofi (drun)',
      group       = '2. Launch',
      on_press    = function()
         awful.spawn(string.format('rofi -show drun -theme styles/drun.rasi -terminal %s', apps.terminal))
      end,
   },
   awful.key{
      modifiers   = {mod.alt},
      key         = 'space',
      description = 'launch rofi (combi)',
      group       = '2. Launch',
      on_press    = function()
         awful.spawn(string.format('rofi -show combi -theme styles/combi.rasi -terminal %s', apps.terminal))
      end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'e',
      description = 'open file explorer',
      group       = '2. Launch',
      on_press    = function() awful.spawn('thunar') end,
   },
}

-- Focus
awful.keyboard.append_global_keybindings{
   awful.key{
      modifiers   = {mod.super},
      key         = 'j',
      description = 'focus next by index',
      group       = '4. Screen',
      on_press    = function() awful.client.focus.byidx(1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'k',
      description = 'focus previous by index',
      group       = '4. Screen',
      on_press    = function() awful.client.focus.byidx(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Tab',
      description = 'go back',
      group       = '4. Screen',
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
      group       = '4. Screen',
      on_press    = awful.client.urgent.jumpto,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'j',
      description = 'focus the next screen',
      group       = '4. Screen',
      on_press    = function() awful.screen.focus_relative(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'k',
      description = 'focus the previous screen',
      group       = '4. Screen',
      on_press    = function() awful.screen.focus_relative(-1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'n',
      description = 'restore minimized',
      group       = '3. Window',
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
      group       = '5. Layout',
      on_press    = function() awful.layout.inc(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'space',
      description = 'select previous',
      group       = '5. Layout',
      on_press    = function() awful.layout.inc(-1) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'l',
      description = 'increase master width factor',
      group       = '5. Layout',
      on_press    = function() awful.tag.incmwfact(0.05) end,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'h',
      description = 'decrease master width factor',
      group       = '5. Layout',
      on_press    = function() awful.tag.incmwfact(-0.05) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'h',
      description = 'increase the number of columns',
      group       = '5. Layout',
      on_press    = function() awful.tag.incncol(1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.ctrl},
      key         = 'l',
      description = 'decrease the number of columns',
      group       = '5. Layout',
      on_press    = function() awful.tag.incncol(-1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'j',
      description = 'swap with next client by index',
      group       = '5. Layout',
      on_press    = function() awful.client.swap.byidx(1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'k',
      description = 'swap with previous client by index',
      group       = '5. Layout',
      on_press    = function() awful.client.swap.byidx(-1) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'h',
      description = 'increase the number of master clients',
      group       = '5. Layout',
      on_press    = function() awful.tag.incnmaster(1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift},
      key         = 'l',
      description = 'decrease the number of master clients',
      group       = '5. Layout',
      on_press    = function() awful.tag.incnmaster(-1, nil, true) end,
   },
   awful.key{
      modifiers   = {mod.super, mod.shift, mod.ctrl, mod.alt},
      keygroup    = 'numrow',
      description = 'select layout directly',
      group       = '5. Layout',
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
      group       = '4. Screen',
      on_press    = awful.tag.viewprev,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Right',
      description = 'view next',
      group       = '4. Screen',
      on_press    = awful.tag.viewnext,
   },
   awful.key{
      modifiers   = {mod.super},
      key         = 'Escape',
      description = 'go back',
      group       = '4. Screen',
      on_press    = awful.tag.history.restore,
   },
   awful.key{
      modifiers   = {mod.super},
      keygroup    = 'numrow',
      description = 'only view tag',
      group       = '4. Screen',
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
      group       = '4. Screen',
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
      group       = '4. Screen',
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
      group       = '4. Screen',
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
