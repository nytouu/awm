local awful = require("awful")

awful.spawn("xset b off", false)
awful.spawn.single_instance("picom", false)
awful.spawn("xsettingsd", false)
