---@diagnostic disable: undefined-global
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local profile = wibox.widget {
	widget = wibox.widget.imagebox,
	image = beautiful.pfp,
	forced_height = 24,
	forced_width = 24,
    valign = 'center',
    halign = 'center',
	clip_shape = helpers.mkroundedrect(40),
	resize = true,
}

profile:add_button(awful.button({}, 1, function()
	-- awesome.emit_signal('toggle::dashboard')
	awful.spawn("rofi -show drun")
end))

return profile
