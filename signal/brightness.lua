---@diagnostic disable: undefined-global
local gears = require 'gears'
local awful = require 'awful'

local script = 'light -G | sed -s "s/\\./ /g" | awk "{print \\$1}"'

gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(script, function (out)
            awesome.emit_signal('brightness::value', tonumber(out))
        end)
    end
}

local function set(val)
    awful.spawn('doas /nix/store/w5bgd3r6khdmr3cpsp5xq2zs175jm76y-light-1.2.2/bin/light -S ' .. tonumber(val))
end

return { set = set }
