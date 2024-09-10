local gfs = require("gears.filesystem")
local assets_path = gfs.get_configuration_dir() .. "assets/"

local colors = {}

-- base colors
colors.black = "#0d0e0f"
colors.dimblack = "#171a1a"
colors.light_black = "#32302f"
colors.grey = "#665c54"
colors.red = "#cc241d"
colors.orange = "#fa842f"
colors.yellow = "#fabd2f"
colors.magenta = "#b16286"
colors.green = "#689d6a"
colors.blue = "#458588"
colors.dimblue = "#27405D"
colors.cyan = "#458588"
colors.aqua = "#458588"

colors.fg = "#ebdbb2"
colors.bg = "#000000"
colors.bg_alt = "#292522"

colors.normal = "#000000"
colors.focus = "#444444"
colors.marked = "#458588"

colors.wallpaper = assets_path .. "wallpaper_dark.png"

return colors
