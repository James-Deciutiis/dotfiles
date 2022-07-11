local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local colors = RC.colors

-- Create a textclock widget
mytextclock = wibox.widget.textclock()
-- Create a wibox for each screen and add it
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

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- " ❶ HOME ", " ❷ WEB ", " ❸ EDIT ", " ❹ READ ", " ❺ CHAT ", " ❻ MISC "

    -- Each screen has its own tag table.
    awful.tag({" HOME ", "  WEB ", "  EDIT ", "  READ ", "  CHAT ", "  MISC "},
              s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
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

    tbox_seperator = wibox.widget.textbox("  |  ")

    -- Create a taglist widget
    s.mytaglist = {
        widget = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons,
            style = {bg_urgent = colors['color1']},
            widget_template = {
                {
                    {
                        {
                            {
                                {
                                    id = 'index_role',
                                    widget = wibox.widget.textbox
                                },
                                margins = 2,
                                widget = wibox.container.margin
                            },
                            bg = colors['color0'],
                            shape = gears.shape.hexagon,
                            widget = wibox.container.background
                        },
                        {
                            {id = 'icon_role', widget = wibox.widget.imagebox},
                            margins = 1,
                            widget = wibox.container.margin
                        },
                        {id = 'text_role', widget = wibox.widget.textbox},
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = 7,
                    right = 7,
                    widget = wibox.container.margin
                },
                widget = wibox.container.background,
                -- Add support for hover colors and an index label
                create_callback = function(self, c3, index, objects) -- luacheck: no unused args
                    self:get_children_by_id('index_role')[1].markup = '<b> ' ..
                                                                          index ..
                                                                          ' </b>'
                    self.shape = gears.shape.rounded_rect
                    self.shape_border_width = 3
                    self.bg = c3.selected and colors['color5'] or
                                  colors['color0']
                    self.shape_border_color =
                        c3.selected and colors['color4'] or colors['color0']

                    self:connect_signal('mouse::enter', function()
                        if self.bg ~= colors['color5'] then
                            self.backup = self.bg
                            self.has_backup = true
                        end

                        self.shape_border_color = c3.selected and
                                                      colors['color5'] or
                                                      colors['color0']
                        self.bg = colors['color5']
                    end)
                    self:connect_signal('mouse::leave', function()
                        if self.has_backup then
                            self.bg = c3.selected and colors['color5'] or
                                          colors['color0']
                            self.shape_border_color = c3.selected and
                                                          colors['color4'] or
                                                          colors['color0']
                        end
                    end)
                end,
                update_callback = function(self, c3, index, objects) -- luacheck: no unused args
                    self:get_children_by_id('index_role')[1].markup = '<b> ' ..
                                                                          index ..
                                                                          ' </b>'
                    self.bg = c3.selected and colors['color5'] or
                                  colors['color0']
                    self.shape_border_color =
                        c3.selected and colors['color4'] or colors['color0']
                end
            },
            layout = wibox.layout.fixed.horizontal
        }
    }

    -- Create a tasklist widget
    s.mytasklist = {
        {
            {
                awful.widget.tasklist {
                    screen = s,
                    filter = awful.widget.tasklist.filter.currenttags,
                    buttons = tasklist_buttons,
                    style = {
                        bg_normal = colors['color0'],
                        bg_focus = colors['color5'],
                        bg_urgent = colors['color3'],
                        shape = gears.shape.circle
                    },
                    layout = {layout = wibox.layout.grid.horizontal},
                    widget_template = {
                        {
                            {
                                id = "clienticon",
                                widget = awful.widget.clienticon
                            },
                            id = "clienticon_margin_role",
                            left = 14.5,
                            widget = wibox.container.margin
                        },
                        id = "background_role",
                        forced_width = 50,
                        forced_height = 75,
                        widget = wibox.container.background,

                        create_callback = function(self, c, index, objects) -- luacheck: no unused
                            self:get_children_by_id("clienticon")[1].client = c
                        end
                    }
                },
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
    }

    -- hide our middle wibox if tasklist empty
    local update_middlebar = function()
        local client_count = 0
        for _, c in ipairs(client.get()) do
            if awful.widget.tasklist.filter.currenttags(c, s) then
                client_count = client_count + 1
            end
        end

        if client_count == 0 then
            s.mytasklist.visible = false
        else
            s.mytasklist.visible = true
        end
    end

    tag.connect_signal("property::selected", update_middlebar)
    tag.connect_signal("property::activated", update_middlebar)
    client.connect_signal("list", update_middlebar)
    client.connect_signal("property::sticky", update_middlebar)
    client.connect_signal("property::skip_taskbar", update_middlebar)
    client.connect_signal("property::hidden", update_middlebar)
    client.connect_signal("tagged", update_middlebar)
    client.connect_signal("untagged", update_middlebar)
    client.connect_signal("list", update_middlebar)
    -- widget = wibox.container.background,
    -- bg = colors['color0'],
    -- shape = gears.shape.rounded_rect
    --        {
    --            {s.mytasklist, layout = wibox.layout.fixed.horizontal},

    --            left = 10,
    --            right = 10,
    --            top = 3,
    --            bottom = 3,
    --            widget = wibox.container.margin
    --        },
    --        shape = gears.shape.rounded_rect,
    --        bg = colors['color0'],
    --        fg = colors['color4'],
    --        shape_border_color = colors['color4'],
    --        shape_border_width = 5,
    --        widget = wibox.container.background

    local forcedWidth = 300
    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        bg = beautiful.bg_normal .. "0",
        border_width = 5,
        height = 30
    })

    -- Add widgets to the wibox
    s.mywibox:setup{
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                {
                    wibox.widget {
                        forced_width = 10,
                        color = "#fffff100",
                        widget = wibox.widget.separator
                    },
                    {
                        {
                            {
                                s.mytaglist,
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
                    wibox.widget {
                        forced_width = forcedWidth,
                        color = '#fffff100',
                        shape = gears.shape.rectangle,
                        widget = wibox.widget.separator
                    },
                    shape_clip = true,
                    shape = gears.shape.rectangle,
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.horizontal
            },
            s.mytasklist,
            { -- Right widgets
                wibox.widget {
                    forced_width = forcedWidth,
                    color = '#fffff100',
                    shape = gears.shape.rectangle,
                    widget = wibox.widget.separator
                },
                {
                    {
                        {
                            mykeyboardlayout,
                            tbox_seperator,
                            mytextclock,
                            tbox_seperator,
                            awful.widget.watch(
                                'bash -c "sensors | grep junction | tr -s [:space:]"',
                                15),
                            tbox_seperator,
                            s.mylayoutbox,
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
                wibox.widget {
                    forced_width = 10,
                    color = '#fffff100',
                    shape = gears.shape.rectangle,
                    widget = wibox.widget.separator
                },
                layout = wibox.layout.fixed.horizontal
            }
        },
        margins = 1.75,
        widget = wibox.container.margin
    }
end)
