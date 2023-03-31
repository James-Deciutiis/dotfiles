local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local mywidgets = RC.mywidgets
local colors = RC.colors

local middlebar = {}
middlebar.init = function(s)
    s.middlebar = awful.popup {
        screen = s,
        placement = function(c)
            return awful.placement.top(c, {margins = 7})
        end,
        minimum_height = 15,
        maximum_height = 15,
        widget = {
            {mywidgets.tasklist(s), layout = wibox.layout.align.horizontal},
            left = 3,
            right = 3,
            top = 1.5,
            bottom = 1.5,
            margins = 2,
            widget = wibox.container.margin
        },

        bg = colors['color0'],
        fg = colors['color4'],
        shape = gears.shape.rounded_bar,
        border_color = colors['color0'],
        border_width = 4
    }
    s.middlebar:struts({top = 10})

    local function update_tasklist()
        local client_count = 0
        for _, c in ipairs(client.get()) do
            if awful.widget.tasklist.filter.currenttags(c, s) then
                client_count = client_count + 1
            end
        end

        if client_count == 0 then
            s.middlebar.visible = false
        else
            s.middlebar.visible = true
        end
    end

    tag.connect_signal("property::selected", update_tasklist)
    tag.connect_signal("property::activated", update_tasklist)
    client.connect_signal("list", update_tasklist)
    client.connect_signal("property::sticky", update_tasklist)
    client.connect_signal("property::skip_taskbar", update_tasklist)
    client.connect_signal("property::hidden", update_tasklist)
    client.connect_signal("tagged", update_tasklist)
    client.connect_signal("untagged", update_tasklist)
    client.connect_signal("list", update_tasklist)
end

return middlebar
