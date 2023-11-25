---@diagnostic disable: undefined-global
local awful = require "awful"

local function set_layouts()
    tag.connect_signal("request::default_layouts", function ()
        awful.layout.append_default_layouts {
            awful.layout.suit.tile,
            awful.layout.suit.spiral,
			awful.layout.suit.max,
            awful.layout.suit.floating,
        }
    end)
end

set_layouts()
