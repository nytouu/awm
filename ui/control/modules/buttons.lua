local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")

local createButton = function(cmd, icon, name, labelConnected, labelDisconnected, signal)
	local widget = wibox.widget({
		{
			{
				{
					{
						markup = icon,
						id = "icon",
						font = beautiful.nerd_font .. " 14",
						widget = wibox.widget.textbox,
					},
					{
						{
							markup = name,
							id = "name",
							font = beautiful.font_name .. " 11",
							widget = wibox.widget.textbox,
						},
						{
							markup = labelConnected,
							id = "label",
							font = beautiful.font_name .. " 9",
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.vertical,
						spacing = 0,
					},
					layout = wibox.layout.fixed.horizontal,
					spacing = 6,
				},
				nil,
				{
					markup = "",
					font = beautiful.nerd_font .. " 14",
					id = "arr",
					widget = wibox.widget.textbox,
				},
				layout = wibox.layout.align.horizontal,
			},
			widget = wibox.container.margin,
			top = 10,
			bottom = 10,
			left = 12,
			right = 12,
		},
		widget = wibox.container.background,
		id = "back",
		shape = helpers.mkroundedrect(10),
		bg = beautiful.dimblack,
		border_width = beautiful.border_widget,
		border_color = beautiful.light_black,
		buttons = { awful.button({}, 1, function()
			awful.spawn.with_shell(cmd)
		end) },
	})

	awesome.connect_signal("signal::" .. signal, function(status)
		if status then
			widget:get_children_by_id("back")[1].bg = beautiful.blue
			widget:get_children_by_id("arr")[1].markup = helpers.colorize_text("", beautiful.dimblack)
			widget:get_children_by_id("name")[1].markup = helpers.colorize_text(name, beautiful.dimblack)
			widget:get_children_by_id("icon")[1].markup = helpers.colorize_text(icon, beautiful.dimblack)
			widget:get_children_by_id("label")[1].markup = helpers.colorize_text(labelConnected, beautiful.dimblack)
		else
			widget:get_children_by_id("back")[1].bg = beautiful.dimblack .. "aa"
			widget:get_children_by_id("arr")[1].markup = helpers.colorize_text("", beautiful.fg_normal .. "cc")
			widget:get_children_by_id("name")[1].markup = helpers.colorize_text(name, beautiful.fg_normal .. "cc")
			widget:get_children_by_id("icon")[1].markup = helpers.colorize_text(icon, beautiful.fg_normal .. "cc")
			widget:get_children_by_id("label")[1].markup =
				helpers.colorize_text(labelDisconnected, beautiful.fg_normal .. "cc")
		end
	end)
	return widget
end

local widget = wibox.widget({
	{
		createButton(
			"~/.config/awesome/scripts/wifi --toggle",
			"󰤨 ",
			"<b>Network</b>",
			"Connected",
			"Disconnected",
			"network"
		),
		createButton(
			"~/.config/awesome/scripts/bluetooth --toggle",
			"󰂯 ",
			"<b>Bluetooth</b>",
			"Connected",
			"Disconnected",
			"bluetooth"
		),
		spacing = 20,
		layout = wibox.layout.flex.horizontal,
	},
	{
		createButton(
			"~/.config/awesome/scripts/airplane --toggle",
			"󰀝 ",
			"<b>Airplane Mode</b>",
			"Now In Flight Mode",
			"Turned Off",
			"airplane"
		),
		createButton(
			"awesome-client 'naughty = require(\"naughty\") naughty.toggle()'",
			"󰍶 ",
			"<b>Do Not Disturb</b>",
			"Turned On",
			"Turned Off",
			"dnd"
		),
		spacing = 20,
		layout = wibox.layout.flex.horizontal,
	},
	{
		createButton(
			"sh -c '[ ! $(pgrep picom) ] && picom || pkill picom'",
			"󰘷 ",
			"<b>Compositor</b>",
			"Enabled",
			"Disabled",
			"compositor"
		),
		createButton("pamixer --source 0 -t", "󰍬 ", "<b>Microphone</b>", "Microphone Muted", "Microphone On", "mic"),
		spacing = 20,
		layout = wibox.layout.flex.horizontal,
	},
	layout = wibox.layout.fixed.vertical,
	spacing = 16,
})

return widget
