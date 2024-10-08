local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")

local wifi = wibox.widget({
	font = beautiful.nerd_font .. " 14",
	markup = helpers.colorize_text("󰤨 ", beautiful.fg_normal),
	widget = wibox.widget.textbox,
	valign = "center",
	align = "center",
})

awesome.connect_signal("signal::network", function(value)
	if value then
		wifi.markup = "󰤨 "
	else
		wifi.markup = helpers.colorize_text("󰤮 ", beautiful.grey .. "99")
	end
end)

return wifi
