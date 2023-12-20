local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local widget = wibox.widget {
  {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = beautiful.pfp,
            forced_height = 140,
            forced_width = 140,
            clip_shape = helpers.mkroundedrect(100),
            resize = true,
          },
          widget = wibox.container.place,
          halign = "center"
        },
        {
          markup = helpers.colorize_text("Welcome, " .. beautiful.user .. "!", beautiful.fg_normal),
          align  = 'center',
          font   = beautiful.font_name .. " 18",
          widget = wibox.widget.textbox
        },
        {
          id     = "uptime",
          markup = helpers.colorize_text("Running since ", beautiful.fg_normal),
          align  = 'center',
          font   = beautiful.font_name .. " 14",
          widget = wibox.widget.textbox
        },
        spacing = 10,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.margin,
      margins = 30,
    },
    shape = helpers.mkroundedrect(12),
    widget = wibox.container.background,
    bg = beautiful.dimblack,
  },
  widget = wibox.container.margin,
  bottom = 20
}
awesome.connect_signal("signal::uptime", function(v)
  helpers.gc(widget, "uptime").markup = helpers.colorize_text(v, beautiful.grey .. "99")
end)


return widget
