local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local bling      = require("modules.bling")
local helpers   = require("helpers")
local playerctl = bling.signal.playerctl.lib{
	-- ignore = "firefox",
	--     player = {"mpd", "%any"}
}

local art       = wibox.widget {
  image = helpers.cropSurface(1.71, gears.surface.load_uncached(beautiful.fallback_music)),
  opacity = 0.3,
  resize = true,
  height = 300,
  clip_shape = helpers.mkroundedrect(12),
  widget = wibox.widget.imagebox
}

local widget    = wibox.widget {
  {
    art,
    {
      {
        widget = wibox.widget.textbox,
      },
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 200, 0 },
        stops = { { 0, beautiful.dimblack .. "88" }, { 1, beautiful.bg_normal .. '33' } }
      },
      shape = helpers.mkroundedrect(12),
      widget = wibox.container.background,
    },
    {
      {
        {
          {
            font = beautiful.font_name .. " 12",
            markup = helpers.colorize_text('Now Playing', beautiful.fg_normal),
            widget = wibox.widget.textbox,
          },
          {
            id = "songname",
            font = beautiful.font_name .. " SemiBold 16",
            markup = helpers.colorize_text('Song Name', beautiful.fg_normal),
            widget = wibox.widget.textbox,
          },
          {
            id = "artist",
            font = beautiful.font_name .. " 14",
            markup = helpers.colorize_text('Artist Name', beautiful.fg_normal),
            widget = wibox.widget.textbox,
          },
          spacing = 8,
          layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.place,
        halign = "left",
        valign = "top"
      },
      widget = wibox.container.margin,
      margins = 20,
    },
    layout = wibox.layout.stack,
  },
  widget = wibox.container.margin,
  top = 20,
}

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
  helpers.gc(widget, "songname"):set_markup_silently(helpers.colorize_text(title or "NO", beautiful.fg_normal))
  helpers.gc(widget, "artist"):set_markup_silently(helpers.colorize_text(artist or "HM", beautiful.fg_normal))
end)
return widget
