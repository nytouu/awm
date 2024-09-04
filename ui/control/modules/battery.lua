local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")

local widget = wibox.widget({
	{
		{
			max_value = 100,
			value = 69,
			id = "prog",
			forced_height = 11,
			forced_width = 26,
			paddings = 3,
			border_color = beautiful.fg_normal .. "99",
			background_color = beautiful.dimblack,
			bar_shape = helpers.mkroundedrect(2),
			color = beautiful.blue,
			border_width = 1,
			shape = helpers.mkroundedrect(5),
			widget = wibox.widget.progressbar,
		},
		{
			{
				bg = beautiful.fg_normal .. "99",
				forced_height = 4,
				forced_width = 2,
				shape = helpers.mkroundedrect(10),
				widget = wibox.container.background,
			},
			widget = wibox.container.place,
			valign = "center",
		},
		spacing = 3,
		layout = wibox.layout.fixed.horizontal,
	},
	{
		font = beautiful.font_name .. " 10",
		markup = helpers.colorize_text("25%", beautiful.fg_normal),
		valign = "center",
		id = "batvalue",
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal,
	spacing = 5,
})

awesome.connect_signal("signal::battery", function(value)
	local b = widget:get_children_by_id("prog")[1]
	local v = widget:get_children_by_id("batvalue")[1]
	v.markup = helpers.colorize_text(value .. "%", beautiful.fg_normal)
	b.value = value
	if value > 80 then
		b.color = beautiful.green
	elseif value > 20 then
		b.color = beautiful.blue
	else
		b.color = beautiful.red
	end
end)

return widget
