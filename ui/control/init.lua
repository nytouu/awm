local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local buttons = require("ui.control.modules.buttons")
local sliders = require("ui.control.modules.slider")

awful.screen.connect_for_each_screen(function(s)
  local control = wibox({
    shape = helpers.mkroundedrect(8),
    screen = s,
    width = 520,
    height = 340,
    bg = beautiful.bg_normal .. "ff",
    ontop = true,
    visible = false,
  })

  control:setup {
    {
      {
        {
          {
            widget = wibox.container.margin,
            top = 10,
          },
          sliders,
          buttons,
          layout = wibox.layout.fixed.vertical,
          spacing = 12,
        },
        widget = wibox.container.margin,
        left = 20,
        right = 20,
      },
      widget = wibox.container.background,
      bg = beautiful.bg_normal,
      shape = helpers.mkroundedrect(12),
	  bottom = 10,
    },
    layout = wibox.layout.align.vertical,
  }
  awful.placement.top_right(control, { honor_workarea = true, margins = 12 })
  awesome.connect_signal("toggle::control", function()
    control.visible = not control.visible
  end)
end)
