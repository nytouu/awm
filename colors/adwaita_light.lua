local gfs = require("gears.filesystem")
local assets_path = gfs.get_configuration_dir() .. "assets/"

local colors = {}

-- base colors
colors.black = "#fcfcfc"
colors.dimblack = "#e5e5e5"
colors.light_black = "#cccccc"
colors.grey = "#aaaaaa"
colors.red = "#F66151"
colors.orange = "#fa842f"
colors.yellow = "#F9F06B"
colors.magenta = "#DC8ADD"
colors.green = "#57E389"
colors.blue = "#52A0DA"
colors.dimblue = "#92C0FF"
colors.cyan = "#62A0EA"
colors.aqua = "#93DDC2"

colors.fg = "#3d3846"
colors.bg = "#fcfcfc"
colors.bg_alt = "#bbbbbb"

colors.normal = "#555555"
colors.focus = "#cecece"
colors.marked = "#93DDC2"

colors.wallpaper = assets_path .. "wallpaper_light.png"

return colors
