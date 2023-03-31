local gears = require("gears")
local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local centerPadding = 1000
local outterPadding = 10
-- local mywidgets = RC.mywidgets
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

local taglist_buttons = gears.table.join(
                            awful.button({}, 1, function(t) t:view_only() end),
                            awful.button({modkey}, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end), awful.button({}, 3, awful.tag.viewtoggle),
                            awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
                            awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end))

local tasklist_buttons = gears.table.join(
                             awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end), awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                             awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

mytextclock = wibox.widget.textclock()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    s.leftbar = leftbar.makeLeftbar(s)
    middlebar.init(s)
    s.rightbar = rightbar.makeRightbar(s)

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = colors['color0'],
        border_width = 7,
        height = 25
    })

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            s.leftbar,
            layout = wibox.layout.align.horizontal
        },
        s.mytasklist, -- Middle widget
        --- { ---- Right widgets 
        {s.rightbar, layout = wibox.layout.fixed.horizontal}
    }
end)
