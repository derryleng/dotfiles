local awful = require'awful'
-- local beautiful = require'beautiful'
-- local wibox = require'wibox'

local widgets = require'widgets'

-- screen.connect_signal('request::wallpaper', function(s)
--    awful.wallpaper{
--       screen = s,
--       widget = {
--          {
--             image     = beautiful.wallpaper,
--             upscale   = true,
--             downscale = true,
--             widget    = wibox.widget.imagebox,
--          },
--          valign = 'center',
--          halign = 'center',
--          tiled = false,
--          widget = wibox.container.tile,
--       }
--    }
-- end)

screen.connect_signal('request::desktop_decoration', function(s)
   -- Horizontal screen
   if s.geometry.width > s.geometry.height then
      awful.tag(vars.tags, s, awful.layout.suit.tile)
   -- Vertical screen
   else
      awful.tag(vars.tags_small, s, awful.layout.suit.fair.horizontal)
   end
   s.promptbox = widgets.create_promptbox()
   s.layoutbox = widgets.create_layoutbox(s)
   s.taglist   = widgets.create_taglist(s)
   s.tasklist  = widgets.create_tasklist(s)
   s.wibox     = widgets.create_wibox(s)
end)
