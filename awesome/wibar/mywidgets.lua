local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local mywidgets = {}
local colors = RC.colors

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

mywidgets.default_taglist = function(s)
    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
end

mywidgets.default_tasklist = function(s)
    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }
end

mywidgets.mywidget_container = function(widget, bgcolor, fgcolor)
    return {
        {
            {
                {layout = wibox.layout.fixed.horizontal, widget},
                left = 10,
                right = 10,
                widget = wibox.container.margin
            },
            shape = gears.shape.rounded_rect,
            bg = bgcolor,
            fg = fgcolor,
            shape_border_color = colors['color0'],
            shape_border_width = 1,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal
    }
end

mywidgets.mytaglist = function(s)
    awful.tag({"HOME", "WEB", "EDIT", "READ", "CHAT", "MISC"}, s,
              awful.layout.layouts[1])

    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {id = 'text_role', widget = wibox.widget.textbox},
                    layout = wibox.layout.fixed.horizontal
                },
                left = 10,
                right = 10,
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            create_callback = function(self, c3)
                self.shape = gears.shape.rectangle
                self.shape_border_width = 4
                self.shape_border_color =
                    c3.selected and colors['color2'] or colors['color0']

                self.bg = c3.selected and colors['color2'] or colors['color0']
                self.bg = c3.urgent and colors['color1'] or self.bg
                self.fg = c3.selected and colors['color0'] or colors['color2']

                self:connect_signal('mouse::enter',
                                    function()
                    self.bg = colors['color2']
                end)
                self.shape_border_color =
                    c3.selected and colors['color2'] or colors['color0']
                self.fg = c3.selected and colors['color0'] or colors['color2']

                self:connect_signal('mouse::leave', function()
                    self.bg = c3.selected and colors['color2'] or
                                  colors['color0']
                    self.shape_border_color =
                        c3.selected and colors['color2'] or colors['color0']
                    self.fg = c3.selected and colors['color0'] or
                                  colors['color2']
                end)
            end,

            update_callback = function(self, c3)
                self.bg = c3.selected and colors['color2'] or colors['color0']
                self.bg = c3.urgent and colors['color1'] or self.bg
                self.shape_border_color =
                    c3.selected and colors['color2'] or colors['color0']
                self.fg = c3.selected and colors['color0'] or colors['color2']
            end
        },
        layout = wibox.layout.fixed.horizontal
    }
end

mywidgets.tbox_seperator = function(string)
    return wibox.widget.textbox(string and string or "  ")
end

mywidgets.my_systray = function()
    return {
        {
            {
                tbox_seperator,
                wibox.widget {
                    wibox.widget.systray(),
                    left = 10,
                    top = 2,
                    bottom = 2,
                    right = 10,
                    widget = wibox.container.margin
                },

                layout = wibox.layout.fixed.horizontal
            },
            bg = colors["color0"],
            shape = gears.shape.rectangle,
            shape_clip = true,
            widget = wibox.container.background
        },
        layout = wibox.layout.fixed.horizontal
    }
end

mywidgets.mytextclock = function()
    local clock = wibox.widget.textclock()
    local cal = calendar_widget({
        theme = 'nord',
        placement = 'top_right',
        start_sunday = true,
        radius = 8,
        previous_month_button = 1,
        next_month_button = 3
    })
    clock:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then cal.toggle() end
    end)

    return clock
end

mywidgets.mylayoutbox = function(s)
    local layoutbox = awful.widget.layoutbox(s)
    layoutbox:buttons(gears.table.join(awful.button({}, 1, function()
        awful.layout.inc(1)
    end), awful.button({}, 3, function() awful.layout.inc(-1) end),
                                       awful.button({}, 4, function()
        awful.layout.inc(1)
    end), awful.button({}, 5, function() awful.layout.inc(-1) end)))

    return layoutbox
end

mywidgets.myvolumewidget =
    function() return volume_widget {widget_type = "arc"} end

mywidgets.tasklist = function(s)
    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            bg_normal = colors['color0'],
            bg_focus = colors['color2'],
            bg_urgent = colors['color1'],
            shape = gears.shape.rounded_rect
        },
        layout = {layout = wibox.layout.grid.horizontal, spacing = 15},
        widget_template = {
            {
                {id = "clienticon", widget = awful.widget.clienticon},
                id = "clienticon_margin_role",
                left = 4.5,
                widget = wibox.container.margin
            },
            id = "background_role",
            forced_width = 20,
            widget = wibox.container.background,
            create_callback = function(self, c)
                self:get_children_by_id("clienticon")[1].client = c
            end
        }
    }
end

return mywidgets
