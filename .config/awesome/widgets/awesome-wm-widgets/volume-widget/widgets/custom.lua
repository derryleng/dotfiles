local wibox = require("wibox")
local beautiful = require('beautiful')
local gears = require("gears")

-- local xresources = require"beautiful.xresources"
-- local dpi = xresources.apply_dpi

local icon_dir = os.getenv("HOME") .. '/.config/awesome/widgets/awesome-wm-widgets/volume-widget/icons/'
local font = "Terminus 9"--args.font or beautiful.font

local widget = {}

function widget.get_widget(widgets_args)
    local args = widgets_args or {}

    local main_color = args.main_color or beautiful.fg_normal
    local mute_color = args.mute_color or beautiful.fg_urgent
    local bg_color = args.bg_color or '#ffffff11'
    local width = args.width or 150
    local margins = args.margins or 18
    local shape = args.shape or 'bar'

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
            id = 'bar',
            max_value = 100,
            forced_width = width,
            color = main_color,
            margins = { top = margins, bottom = margins },
            background_color = bg_color,
            shape = gears.shape[shape],
            widget = wibox.widget.progressbar,
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
            self:get_children_by_id('bar')[1]:set_value(tonumber(new_value))
            self:get_children_by_id('txt')[1]:set_text(new_value)
        end,
        mute = function(self)
            self.is_muted = true
            self:get_children_by_id('icon')[1]:set_image(icon_dir .. 'audio-volume-muted-symbolic.svg')
            self:get_children_by_id('bar')[1]:set_color(mute_color)
        end,
        unmute = function(self)
            self.is_muted = false
            self:get_children_by_id('bar')[1]:set_color(main_color)
        end
    }

    return bar
end

return widget
