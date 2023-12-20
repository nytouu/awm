local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helpers = require 'helpers'

local bluetooth = require 'ui.bar.modules.bluetooth'
local wifi = require 'ui.bar.modules.wifi'


local control      = wibox.widget {
	{
		{
			{
				wifi,
				bluetooth,
				spacing = 8,
				layout = wibox.layout.fixed.horizontal,
			},
			left = 8,
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		shape = helpers.mkroundedrect(),
		bg = beautiful.dimblack,
	},
    top = 5,
    bottom = 5,
    widget = wibox.container.margin,
}

control:add_button(awful.button({}, 1, function ()
	awesome.emit_signal("toggle::control")
end))

return control
