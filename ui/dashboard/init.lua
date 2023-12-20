local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local profile = require("ui.dashboard.modules.profile")
local pomodoro = require("ui.dashboard.modules.pomodoro")
-- local quote = require("ui.dashboard.modules.quote")

local song = require("ui.dashboard.modules.song")
local todo = require("ui.dashboard.modules.todo")

local time = require("ui.dashboard.modules.time")
local nf = require("ui.dashboard.modules.nf")
-- local weather = require("ui.dashboard.modules.weather")

awful.screen.connect_for_each_screen(function(s)
  local dashboard = wibox({
    shape = helpers.mkroundedrect(8),
    screen = s,
    width = 1000,
    height = 590,
    bg = beautiful.bg_normal,
    ontop = true,
    visible = false,
	type = "utility",
  })

  dashboard:setup {
    {
      {
        profile,
        pomodoro,
        -- quote,
        layout = wibox.layout.align.vertical,
      },
      {
        nil,
        todo,
        song,
        layout = wibox.layout.align.vertical,
      },
      {
        time,
        nf,
        -- weather,
        spacing = 20,
        layout = wibox.layout.fixed.vertical,
      },
      spacing = 20,
      layout = wibox.layout.flex.horizontal,
    },
    widget = wibox.container.margin,
    margins = 20,
  }
  awful.placement.top(dashboard, { honor_workarea = true, margins = 12 })
  awesome.connect_signal("toggle::dashboard", function()
    dashboard.visible = not dashboard.visible
  end)
end)
