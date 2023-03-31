-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
require("error-handling")

local current_theme = "everforest"

RC = {}
RC.colors = require("theme/" .. current_theme .. "/colors")
RC.vars = require("variables")
RC.mywidgets = require("wibar/mywidgets")
RC.leftbar = require("wibar/leftbar")
RC.middlebar = require("wibar/middlebar")
RC.rightbar = require("wibar/rightbar")
menu = require("menu")
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Variable definitions
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap = 3
beautiful.gap_single_client = true
modkey = RC.vars.modkey
awful.layout.layouts = RC.vars.layouts
terminal = RC.vars.terminal
-- }}}

-- {{{ Menu
RC.mainmenu = awful.menu({items = menu()})
mymainmenu = awful.menu({
    items = {
        {"awesome", myawesomemenu, beautiful.awesome_icon},
        {"open terminal", terminal}
    }
})
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = RC.mymainmenu
})
menubar.utils.terminal = RC.vars.terminal
-- }}}

-- {{{ Wibar
beautiful.bg_systray = RC.colors['color0']
beautiful.systray_icon_spacing = 3

require("wibar.wibar")
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(awful.button({}, 3,
                                           function() mymainmenu:toggle() end),
                              awful.button({}, 4, awful.tag.viewnext),
                              awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings
RC.bindings = require("bindings")
globalkeys = RC.bindings.globalkeys
clientkeys = RC.bindings.clientkeys
clientbuttons = RC.bindings.clientbuttons
root.keys(globalkeys)
-- }}}

-- {{{ Rules
RC.rules = require("rules")
awful.rules.rules = RC.rules
client.connect_signal("manage", function(c)
    c.shape = gears.shape.rectangle
    awful.spawn.with_shell("feh --bg-fill ~/pictures/nerv-wallpaper-blue.png")
    awful.spawn.with_shell("picom")
end)
-- }}}

-- {{{ Signals
require("signals")
-- }}}
--
-- {{{ Notifications

naughty.config.presets.normal.bg = RC.colors['color0']
naughty.config.presets.normal.border_color = RC.colors['color4']
naughty.config.presets.normal.shape = gears.shape.rounded_rect

-- for testing naughty.notify({title = "Achtung!", message = "You're idling", timeout = 0})
-- }}}
