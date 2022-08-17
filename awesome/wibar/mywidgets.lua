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

mywidgets.tasklist = function(s)
    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            bg_normal = colors['color0'],
            bg_focus = colors['color5'],
            bg_urgent = colors['color3'],
            shape_border_color_focus = colors['color4'],
            shape_border_color = colors['color0'],
            shape_border_width = 2,
            shape = gears.shape.rounded_rect
        },
        layout = {layout = wibox.layout.grid.horizontal, spacing = 15},
        widget_template = {
            {
                {id = "clienticon", widget = awful.widget.clienticon},
                id = "clienticon_margin_role",
                top = 2,
                left = 7.5,
                bottom = 2,
                widget = wibox.container.margin
            },
            id = "background_role",
            forced_width = 30,
            widget = wibox.container.background,
            create_callback = function(self, c)
                self:get_children_by_id("clienticon")[1].client = c
            end
        }
    }
end

mywidgets.mytaglist = function(s)
    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            {id = 'index_role', widget = wibox.widget.textbox},
                            right = 6,
                            left = 1,
                            margins = 2,
                            widget = wibox.container.margin
                        },
                        bg = colors['color0'],
                        shape = gears.shape.circle,
                        widget = wibox.container.background
                    },
                    {id = 'icon_role', widget = wibox.widget.imagebox},
                    {id = 'text_role', widget = wibox.widget.textbox},
                    layout = wibox.layout.fixed.horizontal
                },
                left = 7,
                right = 7,
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            create_callback = function(self, c3, index)
                self:get_children_by_id('index_role')[1].markup = '<b> ' ..
                                                                      index ..
                                                                      ' </b>'
                self.shape = gears.shape.rounded_bar
                self.shape_border_width = 2

                self.bg = c3.selected and colors['color5'] or colors['color0']
                self.shape_border_color =
                    c3.selected and colors['color4'] or colors['color0']
                self.bg = c3.urgent and colors['color3'] or self.bg

                self:connect_signal('mouse::enter', function()
                    self.shape_border_color = colors['color4']
                    self.bg = colors['color13']
                end)

                self:connect_signal('mouse::leave', function()
                    self.bg = c3.selected and colors['color5'] or
                                  colors['color0']
                    self.shape_border_color =
                        c3.selected and colors['color4'] or colors['color0']
                end)
            end,

            update_callback = function(self, c3, index)
                self:get_children_by_id('index_role')[1].markup = '<b> ' ..
                                                                      index ..
                                                                      ' </b>'

                self.bg = c3.selected and colors['color5'] or colors['color0']
                self.shape_border_color =
                    c3.selected and colors['color4'] or colors['color0']
                self.bg = c3.urgent and colors['color3'] or self.bg
                self.shape_border_color =
                    c3.urgent and colors['color4'] or self.shape_border_color

            end
        },
        layout = wibox.layout.fixed.horizontal
    }
end

return mywidgets
