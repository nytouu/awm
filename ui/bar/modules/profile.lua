---@diagnostic disable: undefined-global
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local profile = wibox.widget({
	{
		widget = wibox.widget.imagebox,
		image = beautiful.logo,
		forced_height = 24,
		forced_width = 24,
		valign = "center",
		halign = "center",
		clip_shape = helpers.mkroundedrect(40),
		resize = true,
	},
	{
		font = beautiful.font_name .. " 11",
		markup = helpers.colorize_text("Search", beautiful.fg_normal),
		widget = wibox.widget.textbox,
		valign = "center",
		align = "center",
	},
	layout = wibox.layout.align.horizontal,
	widget = wibox.container.margin,
})

helpers.hover_widget(profile)

profile:add_button(awful.button({}, 1, function()
	awful.spawn("rofi -show drun")
end))

return profile
