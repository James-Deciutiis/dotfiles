local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local centerPadding = 1000
local outterPadding = 10

local leftbar = RC.leftbar
local middlebar = RC.middlebar
local rightbar = RC.rightbar
local colors = RC.colors

awful.screen.connect_for_each_screen(function(s)
    s.leftbar = leftbar.makeLeftbar(s)
    middlebar.init(s)
    s.rightbar = rightbar.makeRightbar(s)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = colors['color0'],
        border_width = 5,
        border_color = colors['color0'],
        shape = gears.shape.rounded_rect,
        height = 20
    })

    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            s.leftbar,
            layout = wibox.layout.align.horizontal
        },
        s.mytasklist, -- Middle widget
        -- Right widgets 
        {s.rightbar, layout = wibox.layout.fixed.horizontal}
    }
end)
