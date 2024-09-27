local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local bell = wibox.widget({
	{
		id = "text",
		markup = "   ",
		widget = wibox.widget.textbox,
	},
	widget = wibox.container.background,
	shape = helpers.mkroundedrect(8),
	bg = beautiful.dimblack,
	border_width = beautiful.border_widget,
	border_color = beautiful.light_black,
	buttons = {
		awful.button({}, 1, function()
			require("naughty").toggle()
		end),
	},
})

helpers.hover_widget(bell)

awesome.connect_signal("signal::dnd", function (status)
	if status then
		bell:get_children_by_id("text")[1].markup = "   "
	else
		bell:get_children_by_id("text")[1].markup = "   "
	end
end)

return bell
