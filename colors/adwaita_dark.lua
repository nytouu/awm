local gfs = require("gears.filesystem")
local assets_path = gfs.get_configuration_dir() .. "assets/"

local colors = {}

-- base colors
colors.black = "#1D1D1D"
colors.dimblack = "#242424"
colors.light_black = "#2a2a2a"
colors.grey = "#393939"
colors.red = "#F66151"
colors.orange = "#fa842f"
colors.yellow = "#F9F06B"
colors.magenta = "#DC8ADD"
colors.green = "#57E389"
colors.blue = "#62A0EA"
colors.dimblue = "#27405D"
colors.cyan = "#62A0EA"
colors.aqua = "#93DDC2"

colors.fg = "#FFFFFF"
colors.bg = "#1D1D1D"
colors.bg_alt = "#262626"

colors.normal = "#000000"
colors.focus = "#525252"
colors.marked = "#93DDC2"

colors.wallpaper = assets_path .. "wallpaper_dark.png"

return colors
