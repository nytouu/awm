---@diagnostic disable: undefined-global
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local helpers = require("helpers")

local gettaglist = require("ui.bar.modules.tags")
local systray_toggler = require("ui.bar.modules.systray_toggler")
local clock = require("ui.bar.modules.date")
local control = require("ui.bar.modules.control")
local getlayoutbox = require("ui.bar.modules.layoutbox")
local battery = require("ui.bar.modules.battery")
local profile = require("ui.bar.modules.profile")
local bell = require("ui.bar.modules.bell")

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	local search = wibox.widget({
		{
			profile,
			right = 4,
			left = 4,
			top = 2,
			bottom = 2,
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		shape = helpers.mkroundedrect(8),
		border_width = beautiful.border_widget,
		border_color = beautiful.light_black,
		forced_width = 94,
		bg = beautiful.dimblack,
	})
	helpers.hover_widget(search)

	local systray = wibox.widget({
		{
			systray_toggler,
			right = 5,
			left = 5,
			top = 8,
			bottom = 8,
			widget = wibox.container.margin,
		},
		border_width = beautiful.border_widget,
		border_color = beautiful.light_black,
		shape = helpers.mkroundedrect(8),
		bg = beautiful.dimblack,
		widget = wibox.container.background,
		forced_width = 32,
	})
	helpers.hover_widget(systray)

	local bar_content = wibox.widget({
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		type = "dock",
		widget = wibox.container.background,
		layout = wibox.layout.stack,
		{
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				widget = wibox.container.place,
				spacing = 6,
				{
					search,
					left = 6,
					top = 4,
					bottom = 4,
					right = 4,
					widget = wibox.container.margin,
				},
				{
					gettaglist(s),
					widget = wibox.container.place,
					halign = "center",
					valign = "center",
				},
			},
			nil,
			{
				{
					{
						systray,
						top = 4,
						bottom = 4,
						right = 4,
						widget = wibox.container.margin,
					},
					{
						{
							{
								control,
								widget = wibox.container.place,
								border_width = beautiful.border_widget,
								border_color = beautiful.light_black,
							},
							widget = wibox.container.background,
							shape = helpers.mkroundedrect(8),
							border_width = beautiful.border_widget,
							border_color = beautiful.light_black,
						},
						widget = wibox.container.place,
						forced_width = 76,
					},
					{
						{
							battery,
							layout = wibox.container.place,
						},
						spacing = 2,
						widget = wibox.container.margin,
						forced_width = 40,
					},
					{
						getlayoutbox(s),
						widget = wibox.container.place,
						border_width = beautiful.border_widget,
						border_color = beautiful.light_black,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 4,
				right = 12,

				widget = wibox.container.margin,
				border_width = beautiful.border_widget,
				border_color = beautiful.light_black,
			},
		},
		{
			{
				{
					{
						clock,
						widget = wibox.container.margin,
					},
					widget = wibox.container.background,
					shape = helpers.mkroundedrect(8),
					border_width = beautiful.border_widget,
					border_color = beautiful.light_black,
				},
				{
					bell,
					left = 8,
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			widget = wibox.container.place,
		},
	})

	local bar = awful.popup({
		visible = true,
		ontop = false,
		minimum_width = s.geometry.width,
		minimum_height = beautiful.bar_height,
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		type = "dock",
		widget = bar_content,
		screen = s,
	})

	local function toggle_ontop(c)
		if c.fullscreen then
			bar.ontop = false
		else
			bar.ontop = true
		end
	end

	client.connect_signal("manage", toggle_ontop)
	client.connect_signal("focus", toggle_ontop)
	client.connect_signal("property::floating", toggle_ontop)
	client.connect_signal("property::fullscreen", toggle_ontop)

	bar:struts({
		top = beautiful.bar_height,
	})
end)
