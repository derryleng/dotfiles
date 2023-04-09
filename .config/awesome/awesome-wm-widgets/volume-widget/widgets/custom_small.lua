local wibox = require("wibox")
local beautiful = require('beautiful')
local gears = require("gears")

-- local xresources = require"beautiful.xresources"
-- local dpi = xresources.apply_dpi

local icon_dir = os.getenv("HOME") .. '/.config/awesome/awesome-wm-widgets/volume-widget/icons/'
local font = "Terminus 9"--args.font or beautiful.font

local widget = {}

function widget.get_widget(widgets_args)
    local args = widgets_args or {}

    local margins = args.margins or 18

    local bar = wibox.widget {
        {
            {
                id = "icon",
                resize = true,
                widget = wibox.widget.imagebox,
            },
            valign = 'center',
            visible = true,
            margins = { top = margins, bottom = margins },
            layout = wibox.container.place,
        },
        {
            id = 'txt',
            font = font,
            widget = wibox.widget.textbox
        },
        spacing = 10,
        layout = wibox.layout.fixed.horizontal,
        set_volume_level = function(self, new_value)
            local volume_icon_name
            if self.is_muted then
                volume_icon_name = 'audio-volume-muted-symbolic'
            else
                local new_value_num = tonumber(new_value)
                if (new_value_num >= 0 and new_value_num < 33) then
                    volume_icon_name="audio-volume-low-symbolic"
                elseif (new_value_num < 66) then
                    volume_icon_name="audio-volume-medium-symbolic"
                else
                    volume_icon_name="audio-volume-high-symbolic"
                end
            end
            self:get_children_by_id('icon')[1]:set_image(icon_dir .. volume_icon_name .. '.svg')
            self:get_children_by_id('txt')[1]:set_text(new_value)
        end,
        mute = function(self)
            self.is_muted = true
            self:get_children_by_id('icon')[1]:set_image(icon_dir .. 'audio-volume-muted-symbolic.svg')
        end,
        unmute = function(self)
            self.is_muted = false
        end
    }

    return bar
end

return widget
