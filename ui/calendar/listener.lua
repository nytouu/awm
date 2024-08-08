---@diagnostic disable: undefined-global
local awful = require 'awful'

local function _()
    return awful.screen.focused().calendar
end

awesome.connect_signal('toggle::calendar', function ()
    _().toggle()
end)

awesome.connect_signal('visibility::calendar', function (v)
    if v then
        _().open()
    else
        _().hide()
    end
end)
