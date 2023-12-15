local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local widget = wibox.widget {
  {
    {
      {
        {
          font = beautiful.font_name .. " Bold 42",
          format = helpers.colorize_text("%H : %M", beautiful.fg_normal),
          align = "center",
          valign = "center",
          widget = wibox.widget.textclock
        },
        {
          font = beautiful.font_name .. " 16",
          format = helpers.colorize_text("%A, %d %B", beautiful.grey .. '99'),
          align = "center",
          valign = "center",
          widget = wibox.widget.textclock
        },
        spacing = 8,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.place,
      halign = "center",
      valign = "center"
    },
    widget = wibox.container.margin,
    margin = 30,
  },
  shape = helpers.mkroundedrect(20),
  forced_height = 230,
  widget = wibox.container.background,
  bg = beautiful.dimblack
}

return widget
