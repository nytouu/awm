local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local ruled = require("ruled")
local bling = require("modules.bling")
local helpers = require("helpers")
local playerctl = bling.signal.playerctl.lib({
	ignore = "firefox",
	player = { "mpd" },
})
local dpi = beautiful.xresources.apply_dpi

local art = wibox.widget({
	image = beautiful.fallback_music,
	clip_shape = helpers.mkroundedrect(beautiful.border_radius),
	opacity = 0.75,
	resize = true,
	forced_height = dpi(60),
	forced_width = dpi(60),
	valign = "center",
	widget = wibox.widget.imagebox,
})
local leftart = wibox.widget({
	image = beautiful.fallback_music,
	clip_shape = helpers.mkroundedrect(beautiful.border_radius),
	opacity = 0.75,
	resize = true,
	forced_height = dpi(250),
	forced_width = dpi(250),
	valign = "center",
	widget = wibox.widget.imagebox,
})
local prev = wibox.widget({
	align = "center",
	font = beautiful.nerd_font .. " 24",
	markup = helpers.colorize_text("󰒮", beautiful.fg_normal),
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:previous()
		end),
	},
})
local next = wibox.widget({
	align = "center",
	font = beautiful.nerd_font .. " 24",
	markup = helpers.colorize_text("󰒭", beautiful.fg_normal),
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:next()
		end),
	},
})

local play = wibox.widget({
	align = "center",
	font = beautiful.nerd_font .. " 24",
	markup = helpers.colorize_text(" 󰐊 ", beautiful.blue),
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:play_pause()
		end),
	},
})
local shufflebtn = wibox.widget({
	align = "center",
	font = beautiful.nerd_font .. " 13",
	markup = helpers.colorize_text("󰒝 ", beautiful.fg_normal),
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:cycle_shuffle()
		end),
	},
})
playerctl:connect_signal("shuffle", function(_, shuffle)
	shufflebtn.markup = shuffle and helpers.colorize_text("󰒝 ", beautiful.blue)
		or helpers.colorize_text("󰒝 ", beautiful.fg_normal)
end)
local repeatt = wibox.widget({
	align = "center",
	font = beautiful.nerd_font .. " 13",
	markup = helpers.colorize_text("󰑖 ", beautiful.fg_normal),
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			playerctl:cycle_loop_status()
		end),
	},
})
playerctl:connect_signal("loop_status", function(_, loop_status)
	if loop_status:match("none") then
		repeatt.markup = helpers.colorize_text("󰑖 ", beautiful.fg_normal)
	elseif loop_status:match("track") then
		repeatt.markup = helpers.colorize_text("󰑘 ", beautiful.grey)
	else
		repeatt.markup = helpers.colorize_text("󰑖 ", beautiful.grey)
	end
end)

local createHandle = function(width, height, tl, tr, br, bl, radius)
	return function(cr)
		gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
	end
end
local slider = wibox.widget({
	bar_shape = helpers.mkroundedrect(0),
	bar_height = 3,
	handle_color = beautiful.blue,
	bar_color = beautiful.blue .. "33",
	bar_active_color = beautiful.blue,
	handle_shape = createHandle(18, 3, false, false, false, false, 0),
	handle_margins = { top = 3 },
	handle_width = 18,
	forced_height = 10,
	maximum = 100,
	widget = wibox.widget.slider,
})

local songname = wibox.widget({
	markup = helpers.colorize_text("Nothing Playing", beautiful.fg_normal),
	align = "left",
	valign = "center",
	forced_width = dpi(40),
	font = beautiful.font_name .. " 12",
	widget = wibox.widget.textbox,
})
local leftname = wibox.widget({
	markup = helpers.colorize_text("Nothing Playing", beautiful.fg_normal),
	valign = "center",
	align = "center",
	font = beautiful.font_name .. " 16",
	widget = wibox.widget.textbox,
})
local artistname = wibox.widget({
	markup = helpers.colorize_text("None", beautiful.fg_normal),
	align = "left",
	valign = "center",
	forced_height = dpi(20),
	font = beautiful.font_name .. " 11",
	widget = wibox.widget.textbox,
})
local leftartist = wibox.widget({
	markup = helpers.colorize_text("None", beautiful.fg_normal),
	align = "center",
	valign = "center",
	forced_height = dpi(20),
	font = beautiful.font_name .. " 11",
	widget = wibox.widget.textbox,
})
local is_prog_hovered = false
slider:connect_signal("mouse::enter", function()
	is_prog_hovered = true
end)
slider:connect_signal("mouse::leave", function()
	is_prog_hovered = false
end)
slider:connect_signal("property::value", function(_, value)
	if is_prog_hovered then
		playerctl:set_position(value)
	end
end)
playerctl:connect_signal("position", function(_, interval_sec, length_sec)
	slider.maximum = length_sec or 100
	slider.value = interval_sec or 0
end)

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	if album_path == "" then
		album_path = beautiful.fallback_music
	end
	if string.len(title) > 30 then
		title = string.sub(title, 0, 30) .. "..."
	end
	if string.len(artist) > 22 then
		artist = string.sub(artist, 0, 22) .. "..."
	end
	songname:set_markup_silently(helpers.colorize_text(title or "NO", beautiful.fg_normal))
	leftname:set_markup_silently(helpers.colorize_text(title or "NO", beautiful.fg_normal))
	leftartist:set_markup_silently(helpers.colorize_text(" " .. artist or "WT" .. " ", beautiful.fg_normal))
	artistname:set_markup_silently(helpers.colorize_text(artist or "HM", beautiful.fg_normal))
	art:set_image(gears.surface.load_uncached(album_path))
	leftart:set_image(gears.surface.load_uncached(album_path))
end)

playerctl:connect_signal("playback_status", function(_, playing)
	play.markup = playing and helpers.colorize_text(" 󰏤 ", beautiful.blue)
		or helpers.colorize_text(" 󰐊 ", beautiful.blue)
end)
local createTopButton = function(c, icon, click, color)
	local widget = wibox.widget({
		{
			{
				markup = helpers.colorize_text(icon, color),
				valign = "center",
				forced_height = dpi(20),
				font = beautiful.nerd_font .. " 18",
				widget = wibox.widget.textbox,
			},
			margins = {
				left = 8,
				right = 8,
			},
			widget = wibox.container.margin,
		},
		buttons = awful.button({}, 1, function()
			helpers.click_key(c, click)
		end),
		bg = beautiful.dimblack,
		widget = wibox.container.background,
	})
	return widget
end

local bottom = function(c)
	local playtab = createTopButton(c, "󰲸 ", "shift+1", beautiful.blue)
	local vistab = createTopButton(c, "󰐰 ", "shift+8", beautiful.blue)
	vistab:add_button(awful.button({}, 3, function()
		helpers.click_key(c, "8")
	end))
	awful.titlebar(c, { position = "bottom", size = dpi(100), bg = beautiful.dimblack }):setup({
		slider,
		{
			{
				{
					art,
					{
						{
							songname,
							artistname,
							forced_width = 400,
							layout = wibox.layout.fixed.vertical,
						},
						align = "center",
						widget = wibox.container.place,
					},
					spacing = 13,
					layout = wibox.layout.fixed.horizontal,
				},
				margins = {
					top = 15,
					bottom = 15,
					left = 10,
					right = 10,
				},
				widget = wibox.container.margin,
			},
			{
				{
					shufflebtn,
					prev,
					{
						{
							play,
							margins = 4,
							widget = wibox.container.margin,
						},
						shape = helpers.mkroundedrect(beautiful.border_radius),
						bg = beautiful.blue .. "11",
						widget = wibox.container.background,
					},
					next,
					repeatt,
					spacing = 15,
					layout = wibox.layout.fixed.horizontal,
				},
				align = "center",
				widget = wibox.container.place,
			},
			{
				playtab,
				vistab,
				spacing = 10,
				layout = wibox.layout.fixed.horizontal,
			},
			expand = "none",
			layout = wibox.layout.align.horizontal,
		},
		layout = wibox.layout.fixed.vertical,
	})
end

local left = function(c)
	awful.titlebar(c, { position = "left", size = dpi(320), bg = beautiful.dimblack }):setup({
		{
			leftart,
			widget = wibox.container.place,
			halign = "center",
			valign = "center",
		},
		bg = beautiful.dimblack .. "cc",
		widget = wibox.container.background,
	})
end

local final = function(c)
	bottom(c)
	-- left(c)
end

ruled.client.connect_signal("request::rules", function()
	ruled.client.append_rule({
		id = "music",
		rule_any = {
			class = { "ncmpcpp" },
		},
		callback = final,
	})
end)
