---@diagnostic disable: undefined-global
local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local music = require("ui.powermenu.modules.music")
local bat = require("ui.powermenu.modules.bat")
local top = require("ui.powermenu.modules.topbar")

awful.screen.connect_for_each_screen(function()
	local exit = wibox({
		screen = screen.primary,
		width = screen.primary.geometry.width,
		height = screen.primary.geometry.height,
		bg = beautiful.bg_normal .. "00",
		ontop = true,
		visible = false,
		type = "utility",
	})

	local back = wibox.widget({
		id = "bg",
		image = beautiful.wallpaper,
		widget = wibox.widget.imagebox,
		forced_height = 1080,
		horizontal_fit_policy = "fit",
		vertical_fit_policy = "fit",
		forced_width = 1920,
	})

	local big = wibox.widget({
		{
			{
				id = "text",
				markup = helpers.colorize_text("HELLO", beautiful.fg_normal .. "33"),
				font = beautiful.font_name .. " Bold 250",
				align = "center",
				widget = wibox.widget.textbox,
			},
			widget = wibox.container.background,
			halign = "center",
			valign = "center",
		},
		widget = wibox.container.margin,
		top = 0,
	})

	local overlay = wibox.widget({
		widget = wibox.container.background,
		forced_height = 1080,
		forced_width = 1920,
		bg = beautiful.bg_normal .. "d1",
	})
	local makeImage = function()
		local cmd = "convert " .. beautiful.wallpaper .. " -filter Gaussian -blur 0x8 ~/.cache/awesome/exit.jpg"
		awful.spawn.easy_async_with_shell(cmd, function()
			local blurwall = gears.filesystem.get_cache_dir() .. "exit.jpg"
			back.image = blurwall
		end)
	end

	makeImage()

	local createButton = function(icon, name, cmd, color)
		local widget = wibox.widget({
			{
				{
					{
						id = "icon",
						markup = helpers.colorize_text(icon, color),
						font = beautiful.nerd_font .. " 38",
						align = "center",
						widget = wibox.widget.textbox,
					},
					widget = wibox.container.margin,
					margins = 50,
				},
				shape = helpers.mkroundedrect(15),
				widget = wibox.container.background,
				bg = beautiful.bg_normal,
				id = "bg",
				shape_border_color = color,
				shape_border_width = 2,
			},
			buttons = {
				awful.button({}, 1, function()
					awesome.emit_signal("toggle::exit")
					awful.spawn.with_shell(cmd)
				end),
			},
			spacing = 15,
			layout = wibox.layout.fixed.vertical,
		})
		widget:connect_signal("mouse::enter", function()
			helpers.gc(widget, "bg").bg = beautiful.dimblack
		end)
		widget:connect_signal("mouse::leave", function()
			helpers.gc(widget, "bg").bg = beautiful.bg_normal
		end)
		return widget
	end

	local time = wibox.widget({
		{
			{
				markup = helpers.colorize_text("󰀠 ", beautiful.blue),
				font = beautiful.nerd_font .. " 28",
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			{
				font = beautiful.font_name .. " 16",
				format = "%H:%M",
				align = "center",
				valign = "center",
				widget = wibox.widget.textclock,
			},
			spacing = 10,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.place,
		valign = "center",
	})

	local down = wibox.widget({
		{
			{
				music,
				time,
				bat,
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
			},
			widget = wibox.container.place,
			valign = "bottom",
			halign = "center",
		},
		widget = wibox.container.margin,
		bottom = 40,
	})

	local buttons = wibox.widget({

		{
			createButton("󰐥 ", "Power", "poweroff", beautiful.red),
			createButton("󰦛 ", "Reboot", "reboot", beautiful.green),
			createButton("󰌾 ", "Lock", "lock", beautiful.blue),
			createButton("󰖔 ", "Sleep", "lock && sleep 0.2 && systemctl suspend", beautiful.yellow),
			createButton("󰈆 ", "Log Out", "loginctl kill-user $USER", beautiful.magenta),
			layout = wibox.layout.fixed.horizontal,
			spacing = 20,
		},
		widget = wibox.container.place,
		halign = "center",
		valign = "center",
	})

	exit:setup({
		back,

		overlay,
		top,
		buttons,
		down,
		widget = wibox.layout.stack,
	})
	awful.placement.centered(exit)
	awesome.connect_signal("toggle::exit", function()
		exit.visible = not exit.visible
	end)
end)
