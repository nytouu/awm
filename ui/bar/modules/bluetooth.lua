local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")

local blue = wibox.widget({
	font = beautiful.nerd_font .. " 16",
	markup = helpers.colorize_text("󰂯 ", beautiful.fg_normal),
	widget = wibox.widget.textbox,
	valign = "center",
	align = "center",
})

awesome.connect_signal("signal::bluetooth", function(value)
	if value then
		blue.markup = helpers.colorize_text("󰂯 ", beautiful.blue)
	else
		blue.markup = helpers.colorize_text("󰂲 ", beautiful.grey .. "99")
	end
end)

return blue
