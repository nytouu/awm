-- autostart, just runs `autostart.sh`

local awful = require("awful")

awful.spawn.single_instance("picom", false)
awful.spawn("xsettingsd", false)

awful.spawn("xset b off", false)
awful.spawn("setxkbmap fr", false)

awful.spawn.once("pipewire", false)
awful.spawn.once("lxpolkit", false)
awful.spawn.once("skippy-xd --start-daemon", false)
-- awful.spawn.single_instance("pipewire-pulse", false)
awful.spawn.once("zsh -c 'DOTNET_ROOT=/home/nytou/.dotnet otd-daemon'", false)
awful.spawn.once(
	"xidlehook --not-when-fullscreen --not-when-audio --timer 120 'brightnessctl -s && brightnessctl s 0' 'brightnessctl -r' --timer 160 'lock' 'brightnessctl -r' --timer 180 'xset dpms force off' ''",
	false
)

-- awful.spawn.with_shell("sleep 3 && /nix/store/$(ls -la /nix/store | grep polkit | grep gnome | awk '{print $8}' | sed -n '$p')/libexec/polkit-gnome-authentication-agent-1 &")
