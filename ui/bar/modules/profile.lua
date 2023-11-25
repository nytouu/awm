---@diagnostic disable: undefined-global
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local profile = wibox.widget {
	widget = wibox.widget.imagebox,
	image = beautiful.pfp,
	forced_height = 28,
	forced_width = 28,
    valign = 'center',
	clip_shape = helpers.mkroundedrect(40),
	resize = true,
}

profile:add_button(awful.button({}, 1, function()
	awesome.emit_signal('dashboard::toggle')
end))

return profile
