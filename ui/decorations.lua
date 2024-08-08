---@diagnostic disable: undefined-global, unused-local

local awful = require 'awful'
local wibox = require 'wibox'
local gears = require 'gears'
local beautiful = require 'beautiful'

-- rounded corners
client.connect_signal('request::titlebars', function (c)
    if not c.fullscreen then
        c.shape = function(cr,w,h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end
    end
end)
