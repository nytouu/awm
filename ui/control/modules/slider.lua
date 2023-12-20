local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local gears        = require("gears")
local helpers      = require("helpers")

local createHandle = function()
  return function(cr)
    gears.shape.rounded_rect(cr, 20, 20, 15)
  end
end

local createSlider = function(icon, signal, command)
  local slidSlider = wibox.widget {
    bar_shape           = helpers.mkroundedrect(15),
    bar_height          = 1,
    handle_color        = beautiful.bg_normal,
    bar_color           = beautiful.bg_normal .. '00',
    bar_active_color    = beautiful.blue,
    handle_shape        = createHandle(),
    handle_border_width = 2,
    handle_width        = dpi(20),
    handle_margins      = { top = 5.9, right = -3, left = 1 },
    handle_border_color = beautiful.fg_normal,
    value               = 25,
    forced_height       = 35,
    maximum             = 100,
    widget              = wibox.widget.slider
  }

  local slidLabel  = wibox.widget {

    font = beautiful.font_name .. " Bold 12",
    markup = "86" .. "%",
    valign = "center",
    widget = wibox.widget.textbox,
  }


  local slidLabelBox = wibox.widget {
    slidLabel,
    widget = wibox.container.margin,
    margins = {
      left = dpi(16),
    }
  }

  local slidIcon = wibox.widget {
    {
      font = beautiful.nerd_font .. " 15",
      markup = helpers.colorize_text(icon, beautiful.fg_normal),
      valign = "center",
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.margin,
  }

  local slidScale = wibox.widget {
    nil,
    {
      {
        slidIcon,
        widget = wibox.container.place,
        valign = "center",
        halign = "left"
      },
      {
        {
          {
            widget = wibox.container.background,
            forced_height = 2,
            shape = helpers.mkroundedrect(10),
            bg = beautiful.dimblack
          },
          widget = wibox.container.place,
          content_fill_horizontal = true,
          valign = "center",
        },
        slidSlider,
        layout = wibox.layout.stack,
      },
      layout = wibox.layout.fixed.horizontal,
      spacing = 20
    },
    nil,
    layout = wibox.layout.align.horizontal,
  }

  awesome.connect_signal('signal::' .. signal, function(value)
    slidSlider.value = value
  end)
  slidSlider:connect_signal("property::value", function(_, new_value)
    awful.spawn.with_shell(string.format(command, new_value))
  end)
  return slidScale
end

local widget       = wibox.widget {
  createSlider("󰃟 ", "brightness", "brightnessctl s %d%%"),
  createSlider(" ", "volume", "pamixer --set-volume %d"),
  layout = wibox.layout.fixed.vertical,
  spacing = 25,
}

return widget
