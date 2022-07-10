-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
require("error-handling")
RC = {}
current_theme = "gruvbox-light"
RC.colors = require("theme/" .. current_theme .. "/colors")
RC.vars = require("variables")
menu = require("menu")
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Variable definitions
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap = 3
beautiful.gap_single_client = true
beautiful.wallpaper = "~/Pictures/Dune-in-Wind-Wallpaper.png"
modkey = RC.vars.modkey
awful.layout.layouts = RC.vars.layouts
terminal = RC.vars.terminal
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
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
require("wibar")
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
    c.shape = gears.shape.rounded_rect
    awful.spawn.with_shell("compton")
    awful.spawn
        .with_shell("feh --bg-fill ~/Pictures/Dune-in-Wind-Wallpaper.png")
    awful.spawn.with_shell(
        "xrandr --output DisplayPort-1 --auto --output HDMI-A-0 --primary --left-of DisplayPort-1")
end)
-- }}}

-- {{{ Signals
require("signals")
-- }}}
