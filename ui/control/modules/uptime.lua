local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local widget = wibox.widget({
	font = beautiful.font_name .. " 10",
	id = "uptime",
	markup = helpers.colorize_text("", beautiful.fg_normal),
	valign = "center",
	widget = wibox.widget.textbox,
})

awesome.connect_signal("signal::uptime", function(v)
	helpers.gc(widget, "uptime").markup = "  " .. v
end)

return widget
