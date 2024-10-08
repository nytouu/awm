---@diagnostic disable: undefined-global
local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")

local hour = wibox.widget({
	format = " %H",
	align = "center",
	font = beautiful.font_name .. " Bold 13",
	widget = wibox.widget.textclock,
})

local minutes = wibox.widget({
	format = ":%M ",
	align = "center",
	font = beautiful.font_name .. " Bold 13",
	widget = wibox.widget.textclock,
})

local day = wibox.widget({
	format = " %a %d %b ",
	align = "center",
	font = beautiful.font_name .. " 9",
	widget = wibox.widget.textclock,
})

local clock_container = wibox.widget({
	{
		{
			hour,
			minutes,
			day,
			spacing = 1,
			layout = wibox.layout.fixed.horizontal,
		},
		left = 5,
		right = 5,
		top = 3,
		bottom = 3,
		widget = wibox.container.margin,
	},
	shape = helpers.mkroundedrect(),
	widget = wibox.container.background,
	bg = beautiful.dimblack,
})

helpers.hover_widget(clock_container)

clock_container:add_button(awful.button({}, 1, function()
	awesome.emit_signal("toggle::dashboard")
end))

return clock_container
