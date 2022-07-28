local gears = require("gears")
local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local centerPadding = 1000
local outterPadding = 10
local mywidgets = RC.mywidgets
local leftbar = RC.leftbar
local middlebar = RC.middlebar
local rightbar = RC.rightbar
local colors = RC.colors

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

local function spacingWidget(width)
    return wibox.widget {
        forced_width = width,
        color = '#ffff100',
        shape = gears.shape.rectangle,
        widget = wibox.widget.separator
    }
end

screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    s.leftbar = leftbar.makeLeftbar(s)
    middlebar.init(s)
    s.rightbar = rightbar.makeRightbar(s)

    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = beautiful.bg_normal .. "0",
        border_width = 5,
        height = 30
    })

    s.mywibox:setup{
        {
            layout = wibox.layout.align.horizontal,
            {s.leftbar, layout = wibox.layout.align.horizontal},
            spacingWidget(centerPadding),
            {s.rightbar, layout = wibox.layout.align.horizontal}
        },
        margins = 1.5,
        widget = wibox.container.margin
    }
end)
