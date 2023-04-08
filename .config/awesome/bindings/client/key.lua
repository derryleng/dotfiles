local awful = require'awful'

local mod = require'bindings.mod'

local titlebars_hidden = true

client.connect_signal('request::default_keybindings', function()
   awful.keyboard.append_client_keybindings{
      awful.key{
         modifiers   = {mod.super},
         key         = 'q',
         description = 'close',
         group       = '3. Window',
         on_press    = function(c) c:kill() end,
      },
      awful.key{
         modifiers   = {mod.super, mod.ctrl},
         key         = 'space',
         description = 'toggle floating',
         group       = '3. Window',
         on_press    = awful.client.floating.toggle,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 't',
         description = 'toggle keep on top',
         group       = '3. Window',
         on_press    = function(c) c.ontop = not c.ontop end,
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'y',
         description = 'toggle all titlebars',
         group       = '3. Window',
         on_press    = function()
            for _, c in ipairs(client.get()) do
               awful.titlebar.toggle(c)
            end
            titlebars_hidden = not titlebars_hidden
         end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 'y',
         description = 'toggle titlebar',
         group       = '3. Window',
         on_press    = function(c) awful.titlebar.toggle(c) end,
      },
      awful.key{
         modifiers   = {mod.super, mod.ctrl},
         key         = 'Return',
         description = 'move to master',
         group       = '3. Window',
         on_press    = function(c) c:swap(awful.client.getmaster()) end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 'd',
         description = 'move to screen',
         group       = '3. Window',
         on_press    = function(c) c:move_to_screen() end,
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'f',
         description = 'toggle fullscreen',
         group       = '3. Window',
         on_press    = function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
         end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 'n',
         description = 'minimize',
         group       = '3. Window',
         on_press    = function(c) c.minimized = true end,
      },
      awful.key{
         modifiers   = {mod.super},
         key         = 'm',
         description = '(un)maximize',
         group       = '3. Window',
         on_press    = function(c)
            c.maximized = not c.maximized
            c:raise()
         end,
      },
      awful.key{
         modifiers   = {mod.super, mod.ctrl},
         key         = 'm',
         description = '(un)maximize vertically',
         group       = '3. Window',
         on_press    = function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
         end,
      },
      awful.key{
         modifiers   = {mod.super, mod.shift},
         key         = 'm',
         description = '(un)maximize horizontally',
         group       = '3. Window',
         on_press    = function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
         end,
      },
   }
end)
