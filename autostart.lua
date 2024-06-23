-- autostart, just runs `autostart.sh`

local awful = require("awful")

awful.spawn("picom", false)
awful.spawn("xset b off", false)
-- awful.spawn.with_shell("sleep 3 && /nix/store/$(ls -la /nix/store | grep polkit | grep gnome | awk '{print $8}' | sed -n '$p')/libexec/polkit-gnome-authentication-agent-1 &")
