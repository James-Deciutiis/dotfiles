local gears = require("gears")
local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local mywidgets = RC.mywidgets
local colors = RC.colors

local leftbar = {}
leftbar.makeLeftbar = function(s)
    awful.tag({" HOME ", "  WEB ", "  EDIT ", "  READ ", "  CHAT ", "  MISC "},
              s, awful.layout.layouts[1])

    return {
        {
            { -- taglist
                {
                    {
                        mywidgets.mytaglist(s),
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = 10,
                    right = 10,
                    top = 4.5,
                    bottom = 4.5,
                    widget = wibox.container.margin
                },
                shape = gears.shape.rounded_rect,
                bg = colors['color0'],
                fg = colors['color4'],
                shape_border_color = colors['color4'],
                shape_border_width = 2,
                widget = wibox.container.background
            },
            shape_clip = true,
            shape = gears.shape.rectangle,
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.fixed.horizontal
    }
end

return leftbar
