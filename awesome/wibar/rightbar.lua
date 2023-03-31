local gears = require("gears")
local wibox = require("wibox")
local colors = RC.colors
local mywidgets = RC.mywidgets

local rightbar = {}
rightbar.makeRightbar = function(s)
    local tbox_seperator = mywidgets.tbox_seperator()
    local mytextclock = mywidgets.mytextclock()
    local mylayoutbox = mywidgets.mylayoutbox(s)
    local volume_widget = mywidgets.myvolumewidget()
    return {
        {
            {
                {
                    layout = wibox.layout.fixed.horizontal,
                    mykeyboardlayout,
                    tbox_seperator,
                    mytextclock,
                    tbox_seperator,
                    mylayoutbox,
                    tbox_seperator,
                    volume_widget,
                    layout = wibox.layout.fixed.horizontal
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

return rightbar
