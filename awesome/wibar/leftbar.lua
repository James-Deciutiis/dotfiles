local wibox = require("wibox")
local gears = require("gears")
local mywidgets = RC.mywidgets
local colors = RC.colors

local leftbar = {}
leftbar.makeLeftbar = function(s)
    return {
        {
            {
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    mywidgets.mytaglist(s),
                    layout = wibox.layout.align.horizontal
                },
                left = 10,
                right = 10,
                top = 3,
                bottom = 3,
                widget = wibox.container.margin
            },
            shape = gears.shape.rectangle,
            bg = colors['color0'],
            fg = colors['color2'],
            shape_border_color = colors['color0'],
            shape_border_width = 4,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal
    }
end

return leftbar
