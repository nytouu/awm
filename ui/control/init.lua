local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local buttons = require("ui.control.modules.buttons")
local header_buttons = require("ui.control.modules.header_buttons")
local sliders = require("ui.control.modules.slider")
local battery = require("ui.control.modules.battery")
local uptime = require("ui.control.modules.uptime")

awful.screen.connect_for_each_screen(function()
	local control = wibox({
		shape = helpers.mkroundedrect(beautiful.border_radius),
		screen = screen.primary,
		width = 440,
		height = 452,
		bg = beautiful.bg_normal .. "ff",
		ontop = true,
		visible = false,
		border_width = beautiful.border_widget,
		border_color = beautiful.grey,
		type = "utility",
	})

	control:setup({
		{
			{
				{
					{
						widget = wibox.container.margin,
						top = 10,
					},
					{
						{
							{
								widget = wibox.widget.imagebox,
								image = beautiful.pfp,
								forced_height = 58,
								opacity = 1,
								forced_width = 58,
								clip_shape = helpers.mkroundedrect(80),
								resize = true,
								top = 10,
								valign = "center",
								halign = "center",
							},
							forced_width = 86,
							widget = wibox.container.margin,
						},
						{
							{
								markup = "nytou@void",
								font = beautiful.font_name .. " Bold 14",
								widget = wibox.widget.textbox,
								valign = "center",
								halign = "left",
							},
							{
								uptime,
								widget = wibox.container.margin,
								valign = "center",
								halign = "left",
								top = 6,
								bottom = 4,
							},
							{
								battery,
								widget = wibox.container.place,
								valign = "center",
								halign = "left",
							},
							layout = wibox.layout.align.vertical,
							widget = wibox.container.margin,
						},
						{
							header_buttons,
							widget = wibox.container.margin,
							halign = "right",
						},
						layout = wibox.layout.align.horizontal,
						widget = wibox.container.margin,
					},
					{
						{
							sliders,
							top = 20,
							bottom = 20,
							left = 20,
							right = 20,
							widget = wibox.container.margin,
						},
						bg = beautiful.dimblack .. "aa",
						shape = helpers.mkroundedrect(beautiful.border_radius),
						widget = wibox.container.background,
						border_width = beautiful.border_widget,
						border_color = beautiful.light_black,
					},
					buttons,
					layout = wibox.layout.fixed.vertical,
					spacing = 16,
				},
				widget = wibox.container.margin,
				left = 20,
				right = 20,
			},
			widget = wibox.container.background,
			bg = beautiful.bg_normal,
			shape = helpers.mkroundedrect(beautiful.border_radius),
			bottom = 10,
		},
		layout = wibox.layout.align.vertical,
	})
	awful.placement.top_right(control, { honor_workarea = true, margins = 12 })

	awesome.connect_signal("toggle::control", function()
		control.visible = not control.visible
	end)
	awesome.connect_signal("close::control", function()
		control.visible = false
	end)
end)
