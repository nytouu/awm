---@diagnostic disable: undefined-global
local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local helpers = require 'helpers'
local hotkeys_popup = require 'awful.hotkeys_popup'

local menu = {}

menu.mainmenu = awful.menu {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    -- { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}

-- apply rounded corners to menus when picom isn't available, thanks to u/signalsourcesexy
-- also applies antialiasing! - By me.
menu.mainmenu.wibox.shape = helpers.mkroundedrect()
menu.mainmenu.wibox.bg = beautiful.bg_normal .. '00'
menu.mainmenu.wibox:set_widget(wibox.widget({
    menu.mainmenu.wibox.widget,
    bg = beautiful.bg_normal,
    shape = helpers.mkroundedrect(),
    widget = wibox.container.background,
	border_width = beautiful.border_widget,
	border_color = beautiful.grey,
}))

-- apply rounded corners to submenus, thanks to u/signalsourcesexy
-- also applies antialiasing! - By me.
awful.menu.original_new = awful.menu.new

function awful.menu.new(...)
    local ret = awful.menu.original_new(...)

    ret.wibox.shape = helpers.mkroundedrect()
    ret.wibox.bg = beautiful.bg_normal .. '00'
    ret.wibox:set_widget(wibox.widget {
        ret.wibox.widget,
        widget = wibox.container.background,
		border_width = beautiful.border_widget,
		border_color = beautiful.grey,
        bg = beautiful.bg_normal,
        shape = helpers.mkroundedrect(),
    })

    return ret
end

return menu
