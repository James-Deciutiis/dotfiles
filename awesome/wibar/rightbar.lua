local gears = require("gears")
local wibox = require("wibox")
local colors = RC.colors
local mywidgets = RC.mywidgets

local rightbar = {}
rightbar.makeRightbar = function(s)
    local mytextclock = mywidgets.mywidget_container(mywidgets.mytextclock(),
                                                     colors['color2'],
                                                     colors['color0'])
    local mylayoutbox = mywidgets.mylayoutbox(s)
    local volume_widget = mywidgets.myvolumewidget()
    return {
        {
            {
                {
                    layout = wibox.layout.fixed.horizontal,
                    mykeyboardlayout,
                    mywidgets.tbox_seperator(" "),
                    mytextclock,
                    mywidgets.tbox_seperator("  |  "),
                    mylayoutbox,
                    mywidgets.tbox_seperator("   "),
                    volume_widget,
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
            fg = colors['color2'],
            shape_border_color = colors['color0'],
            shape_border_width = 4,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal
    }
end

return rightbar
