local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local make_button = function (icon, size, cmd)
	local button = wibox.widget {
		{
			markup = icon,
			font = beautiful.nerd_font .. " 14",
			widget = wibox.widget.textbox,
			halign = "center",
			valign = "center",
		},
		widget = wibox.container.background,
		bg = beautiful.dimblack,
	}
	helpers.hover_widget(button)

	return wibox.widget {
		button,
		forced_height = size,
		forced_width = size,
		shape = helpers.mkroundedrect(),
		widget = wibox.container.background,
		border_width = beautiful.border_widget,
		border_color = beautiful.light_black,

		buttons = { awful.button({}, 1, function ()
			cmd()
			awesome.emit_signal('close::control')
		end) }
	}
end

local widget = wibox.widget {
	{
		{
			make_button("󰈆", 48, function ()
				awesome.emit_signal('toggle::exit')
			end),
			widget = wibox.container.place,
		},
		spacing = 12,
		widget = wibox.container.margin,
		layout = wibox.layout.fixed.horizontal,
	},
	widget = wibox.container.margin,
}

return widget
