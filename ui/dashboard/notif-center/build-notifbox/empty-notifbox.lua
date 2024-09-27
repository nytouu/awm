local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local separator_for_empty_msg = wibox.widget({
	orientation = "vertical",
	opacity = 0.0,
	widget = wibox.widget.separator,
})

return wibox.widget({
	separator_for_empty_msg,
	{
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("", beautiful.blue),
			font = beautiful.nerd_font .. " 32",
			valign = "center",
			align = "center",
		},
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("No Notifications", beautiful.fg_normal),
			font = beautiful.font_name .. " Bold 13",
			valign = "center",
			align = "center",
		},
		spacing = dpi(10),
		layout = wibox.layout.fixed.vertical,
	},
	separator_for_empty_msg,
	layout = wibox.layout.align.vertical,
	expand = "none",
})
