local gears = require("gears")
local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local colors = RC.colors

local cw = calendar_widget({
    theme = 'light',
    placement = 'top_right',
    start_sunday = true,
    radius = 8,
    previous_month_button = 1,
    next_month_button = 3
})

local tbox_seperator = wibox.widget.textbox("  |  ")
local mytextclock = wibox.widget.textclock()
mytextclock:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then cw.toggle() end
end)

local rightbar = {}
rightbar.makeRightbar = function(s)
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                              awful.button({}, 1,
                                           function() awful.layout.inc(1) end),
                              awful.button({}, 3,
                                           function()
            awful.layout.inc(-1)
        end), awful.button({}, 4, function() awful.layout.inc(1) end),
                              awful.button({}, 5,
                                           function()
            awful.layout.inc(-1)
        end)))

    return {
        {
            {
                {
                    ---awful.widget.watch(
                    ---'bash -c "sensors | grep junction | tr -s [:space:]"',
                    ---15),
                    cpu_widget({
                        width = 70,
                        step_width = 2,
                        step_spacing = 0,
                        color = colors['color4']
                    }),
                    tbox_seperator,
                    mytextclock,
                    tbox_seperator,
                    s.mylayoutbox,
                    tbox_seperator,
                    volume_widget {widget_type = "arc"},
                    layout = wibox.layout.fixed.horizontal
                },
                left = 10,
                right = 10,
                top = 3,
                bottom = 3,
                widget = wibox.container.margin
            },
            shape = gears.shape.rounded_rect,
            bg = colors['color0'],
            fg = colors['color4'],
            shape_border_color = colors['color4'],
            shape_border_width = 5,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal
    }
end
return rightbar
