local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local widget = wibox.widget({
	{
		{
			{
				date = os.date("*t"),
				font = beautiful.font_name .. " 9",
				spacing = 2,
				widget = wibox.widget.calendar.month,
				fn_embed = function(widget, flag, date)
					local focus_widget = wibox.widget({
						text = date.day,
						align = "center",
						widget = wibox.widget.textbox,
					})

					local torender = flag == "focus" and focus_widget or widget

					local colors = {
						header = beautiful.blue,
						focus = beautiful.blue,
						weekday = beautiful.blue,
					}

					local color = colors[flag] or beautiful.fg_normal

					return wibox.widget({
						{
							torender,
							margins = 7,
							widget = wibox.container.margin,
						},
						bg = flag == "focus" and beautiful.black or beautiful.bg_normal,
						fg = color,
						widget = wibox.container.background,
						shape = flag == "focus" and gears.shape.circle or nil,
					})
				end,
			},
			spacing = beautiful.useless_gap * 2,
			layout = wibox.layout.fixed.vertical,
		},
		margins = beautiful.useless_gap * 2,
		widget = wibox.container.margin,
	},
	bg = beautiful.bg_normal,
	fg = beautiful.fg_normal,
	widget = wibox.container.background,
})

return widget
