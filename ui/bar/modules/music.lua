local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local bling		= require("modules.bling")
local helpers   = require("helpers")
local playerctl = bling.signal.playerctl.lib{
	-- ignore = "firefox",
	-- player = {"mpd", "%any"}
}
local art       = wibox.widget {
	image = helpers.cropSurface(5.8, gears.surface.load_uncached(beautiful.fallback_music)),
	opacity = 0.3,
	forced_height = 20,
	shape = helpers.mkroundedrect(10),
	forced_width = dpi(200),
	widget = wibox.widget.imagebox
}
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	-- Set art widget
	art.image = helpers.cropSurface(5.8, gears.surface.load_uncached(album_path))
end)
local next = wibox.widget {
	align = 'center',
	font = beautiful.nerd_font .. " 14",
	text = '󰒭',
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:next()
		end)
	},
}

local prev = wibox.widget {
	align = 'center',
	font = beautiful.nerd_font .. " 14",
	text = '󰒮',
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:previous()
		end)
	},
}
local play = wibox.widget {
	align = 'center',
	font = beautiful.nerd_font .. " 20",
	markup = helpers.colorize_text('󰐊', beautiful.fg_normal),
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:play_pause()
		end)
	},
}
playerctl:connect_signal("playback_status", function(_, playing, player_name)
	play.markup = playing and
		helpers.colorize_text("󰏤", beautiful.fg_normal)
		or helpers.colorize_text("󰐊", beautiful.fg_normal)
end)

local headset = wibox.widget {
	align = 'center',
	font = beautiful.nerd_font .. " 13",
	markup = helpers.colorize_text('󰋎 ', beautiful.grey),
	widget = wibox.widget.textbox,
}

local finalwidget = wibox.widget {
	{
		art,
		{
			{
				widget = wibox.widget.textbox,
			},
			bg = {
				type = "linear",
				from = { 0, 0 },
				to = { 250, 0 },
				stops = { { 0, beautiful.bg_normal .. "00" }, { 1, beautiful.dimblack } }
			},
			widget = wibox.container.background,
		},
		{
			{
				headset,
				nil,
				{ prev, play, next, spacing = 8, layout = wibox.layout.fixed.horizontal },
				layout = wibox.layout.align.horizontal,
			},
			widget = wibox.container.margin,
			left = 6,
			right = 6,
		},
		layout = wibox.layout.stack,
	},
	widget = wibox.container.background,
	shape = helpers.mkroundedrect(5),
}

finalwidget:add_button(awful.button({}, 3, function ()
    awful.spawn(terminal .. " -c ncmpcpp -n ncmpcpp ncmpcpp")
end))

finalwidget:add_button(awful.button({}, 4, function ()
    awful.spawn("playerctl volume 0.02+")
end))

finalwidget:add_button(awful.button({}, 5, function ()
    awful.spawn("playerctl volume 0.02-")
end))

headset:add_button(awful.button({}, 1, function ()
	awesome.emit_signal("toggle::music")
end))

return finalwidget
