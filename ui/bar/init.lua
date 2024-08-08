---@diagnostic disable: undefined-global
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local awful = require 'awful'

-- local launchers = require 'ui.bar.modules.launchers'
local gettaglist = require 'ui.bar.modules.tags'
local systray_toggler = require 'ui.bar.modules.systray_toggler'
local clock = require 'ui.bar.modules.date'
local control = require 'ui.bar.modules.control'
local clientinfo = require 'ui.bar.modules.client'
local getlayoutbox = require 'ui.bar.modules.layoutbox'
local battery = require 'ui.bar.modules.battery'
local profile = require 'ui.bar.modules.profile'
local music = require 'ui.bar.modules.music'
local helpers = require 'helpers'

screen.connect_signal('request::desktop_decoration', function(s)
	awful.tag(
		{ '1', '2', '3', '4', '5', '6', '7' },
		s, awful.layout.layouts[1]
	)

	local search = wibox.widget {
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
	}
	helpers.hover_widget(search)

	local systray = wibox.widget {
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
	}
	helpers.hover_widget(systray)

	local bar_content = wibox.widget {
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
				{
					search,
					left = 6,
					top = 4,
					bottom = 4,
					right = 4,
					widget = wibox.container.margin,
				},
				{
					{
						{
							getlayoutbox(s),
							widget = wibox.container.place,
							halign = 'center',
							valign = 'center',
						},
						widget = wibox.container.background,
						shape = helpers.mkroundedrect(8),
						bg = beautiful.bg_normal,
						-- TODO: change here
					},
					right = 2,
					widget = wibox.container.margin,
				},
				{
					{
						{
							gettaglist(s),
							widget = wibox.container.place,
							halign = 'center',
							valign = 'center',
						},
						border_width = beautiful.border_widget,
						border_color = beautiful.light_black,
						widget = wibox.container.background,
						forced_height = 24,
						forced_width = s.geometry.width / 7,
						shape = helpers.mkroundedrect(8),
						bg = beautiful.dimblack,
						fg = beautiful.dimblack,
					},
					widget = wibox.container.place,
				},
				-- {
				-- 	clientinfo,
				-- 	widget = wibox.container.margin,
				-- 	left = 6,
				-- },
			},
			nil,
			{
				{
					{
						systray,
						top = 4,
						bottom = 4,
						widget = wibox.container.margin,
					},
					{
						{
							{
								music,
								widget = wibox.container.place,
							},
							widget = wibox.container.background,
							shape = helpers.mkroundedrect(8),
							border_width = beautiful.border_widget,
							border_color = beautiful.light_black,
						},
						widget = wibox.container.place,
						forced_width = 210,
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
					clock,
					widget = wibox.container.margin,
				},
				widget = wibox.container.background,
				shape = helpers.mkroundedrect(8),
				border_width = beautiful.border_widget,
				border_color = beautiful.light_black,

			},
			widget = wibox.container.place,
		},
	}

	local bar = awful.popup {
		visible = true,
		ontop = false,
		minimum_width = s.geometry.width,
		minimum_height = beautiful.bar_height,
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		type = "dock",
		widget = bar_content,
		screen = s,
	}

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

	bar:struts {
		top = beautiful.bar_height,
		-- top = beautiful.bar_height + beautiful.useless_gap * 2,
		-- left = beautiful.useless_gap * 2,
		-- right = beautiful.useless_gap * 2,
		-- bottom = beautiful.useless_gap * 2,
	}
end)
