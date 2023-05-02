local awful = require'awful'

tag.connect_signal('request::default_layouts', function()
    awful.layout.append_default_layouts(vars.layouts)
end)
