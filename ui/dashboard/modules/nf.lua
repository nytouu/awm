local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")


local widget = wibox.widget {
  {
    {
      {
        {
          {
            {
              {
                font = beautiful.mono_font .. " Medium 11",
                markup = helpers.colorize_text('>', beautiful.bg_normal),
                widget = wibox.widget.textbox,
              },
              widget = wibox.container.margin,
              top = 5,
              bottom = 5,
              left = 10,
              right = 10,
            },
            widget = wibox.container.background,
            bg = beautiful.blue
          },
          {
            {
              font = beautiful.mono_font .. " Medium 11",
              markup = helpers.colorize_text('fetch.sh', beautiful.fg_normal),
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.place,
            valign = "center",
          },
          spacing = 15,
          layout = wibox.layout.fixed.horizontal,
        },
        nil,
        nil,
        layout = wibox.layout.align.horizontal,
      },
      {
        {
          widget = wibox.widget.imagebox,
          image = beautiful.nixos,
          forced_height = 40,
          forced_width = 40,
          resize = true,
		  valign = "center",
        },
        {
          {
            font = beautiful.mono_font .. " Medium 11",
            markup = helpers.colorize_text('OS  : NixOS 24.05', beautiful.fg_normal),
            widget = wibox.widget.textbox,
          },
          {
            font = beautiful.mono_font .. " Medium 11",
            markup = helpers.colorize_text('WM  : Awesome', beautiful.fg_normal),
            widget = wibox.widget.textbox,
          },
          {
            font = beautiful.mono_font .. " Medium 11",
            markup = helpers.colorize_text('USER: ' .. beautiful.user, beautiful.fg_normal),
            widget = wibox.widget.textbox,
          },
          {
            font = beautiful.mono_font .. " Medium 11",
            markup = helpers.colorize_text('SH  : ZSH', beautiful.fg_normal),
            widget = wibox.widget.textbox,
          },
          spacing = 8,
          layout = wibox.layout.fixed.vertical,
        },
        spacing = 20,
        layout = wibox.layout.fixed.horizontal,
      },
      {
        {
          {
            widget = wibox.container.background,
            bg = beautiful.bg_darker,
            forced_height = 20,
            shape = helpers.mkroundedrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.red,
            forced_height = 20,
            shape = helpers.mkroundedrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.green,
            forced_height = 20,
            shape = helpers.mkroundedrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.yellow,
            forced_height = 20,
            shape = helpers.mkroundedrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.blue,
            forced_height = 20,
            shape = helpers.mkroundedrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.magenta,
            forced_height = 20,
            shape = helpers.mkroundedrect(5),
            forced_width = 20,
          },
          spacing = 14,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.place,
        halign = "center"
      },
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = 40
  },
  widget = wibox.container.background,
  bg = beautiful.dimblack,
  shape = helpers.mkroundedrect(12)
}

return widget
