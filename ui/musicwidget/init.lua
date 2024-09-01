local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local bling     = require("modules.bling")
local helpers   = require("helpers")
local playerctl = bling.signal.playerctl.lib{
    ignore = "firefox",
    player = {"mpd", "%any"}
}
local art       = wibox.widget {
    image = helpers.cropSurface(1.71, gears.surface.load_uncached(beautiful.fallback_music)),
    opacity = 0.3,
    resize = true,
    clip_shape = helpers.mkroundedrect(12),
    widget = wibox.widget.imagebox
}
local next      = wibox.widget {
    align = 'center',
    font = beautiful.nerd_font .. " 22",
    text = '󰒭',
    widget = wibox.widget.textbox,
    buttons = {
        awful.button({}, 1, function()
            playerctl:next()
        end)
    },
}

local prev      = wibox.widget {
    align = 'center',
    font = beautiful.nerd_font .. " 22",
    text = '󰒮',
    widget = wibox.widget.textbox,
    buttons = {
        awful.button({}, 1, function()
            playerctl:previous()
        end)
    },
}
local play      = wibox.widget {
    align = 'center',
    font = beautiful.nerd_font .. " 22",
    markup = helpers.colorize_text('󰐍 ', beautiful.fg_normal),
    widget = wibox.widget.textbox,
    buttons = {
        awful.button({}, 1, function()
            playerctl:play_pause()
        end)
    },
}
playerctl:connect_signal("playback_status", function(_, playing, player_name)
    play.markup = playing and helpers.colorize_text("󰏦 ", beautiful.fg_normal) or helpers.colorize_text("󰐍 ", beautiful.fg_normal)
end)


awful.screen.connect_for_each_screen(function(s)
    local music = wibox({
        shape = helpers.mkroundedrect(8),
        screen = screen.primary,
        width = 400,
        height = 200,
        bg = beautiful.bg_normal,
        ontop = true,
        visible = false,
		type = "utility",
		border_width = beautiful.border_widget,
		border_color = beautiful.grey,
    })

    music:setup {
        {
            nil,
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
                        stops = { { 0, beautiful.bg_normal .. "ff" }, { 1, beautiful.dimblack .. '55' } }
                    },
                    shape = helpers.mkroundedrect(12),
                    widget = wibox.container.background,
					border_width = beautiful.border_widget,
					border_color = beautiful.light_black,
                },
                {
                    {
                        {
                            {
                                id = "songname",
                                font = beautiful.font_name .. " 14",
                                markup = helpers.colorize_text('Song Name', beautiful.fg_normal),
                                widget = wibox.widget.textbox,
                            },
                            {
                                id = "artist",
                                font = beautiful.font_name .. " 12",
                                markup = helpers.colorize_text('Artist Name', beautiful.fg_normal),
                                widget = wibox.widget.textbox,
                            },
                            spacing = 8,
                            layout = wibox.layout.fixed.vertical,
                        },
                        nil,
                        {
                            id = "player",
                            font = beautiful.font_name .. " 12",
                            markup = helpers.colorize_text('Playing Via Spotify', beautiful.fg_normal),
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.align.vertical
                    },
                    widget = wibox.container.margin,
                    margins = 20
                },
                layout = wibox.layout.stack,
            },
            {
                {
                    {
                        {
                            prev,
                            play,
                            next,
                            layout = wibox.layout.align.vertical,
                        },
                        widget = wibox.container.margin,
                        top = 25,
                        bottom = 25,
                        left = 20,
                        right = 20,
                    },
                    shape = helpers.mkroundedrect(12),
                    widget = wibox.container.background,
                    bg = beautiful.dimblack,
					border_width = beautiful.border_widget,
					border_color = beautiful.light_black,
                },
                widget = wibox.container.margin,
                left = 20,
            },
            layout = wibox.layout.align.horizontal,
        },
        widget = wibox.container.margin,
        margins = 20,
    }
    awful.placement.top_right(music, { honor_workarea = true, margins = 12 })
    awesome.connect_signal("toggle::music", function()
        music.visible = not music.visible
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
        art.image = helpers.cropSurface(1.71, gears.surface.load_uncached(album_path))
        helpers.gc(music, "songname"):set_markup_silently(helpers.colorize_text(title or "NO", beautiful.fg_normal))
        helpers.gc(music, "artist"):set_markup_silently(helpers.colorize_text(artist or "HM", beautiful.fg_normal))
        helpers.gc(music, "player"):set_markup_silently(helpers.colorize_text("Playing Via: " .. player_name or "",
            beautiful.fg_normal))
    end)
end)


