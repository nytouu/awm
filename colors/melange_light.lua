local gfs = require("gears.filesystem")
local assets_path = gfs.get_configuration_dir() .. "assets/"

local colors = {}

-- base colors
colors.black = "#f1f1f1"
colors.dimblack = "#D9D3CE"
colors.light_black = "#54433A"
colors.grey = "#7D6658"
colors.red = "#BF0021"
colors.orange = "#BC5C00"
colors.yellow = "#A06D00"
colors.magenta = "#904180"
colors.green = "#3A684A"
colors.blue = "#3D6568"
colors.dimblue = "#27405D"
colors.cyan = "#3D6568"
colors.aqua = "#3D6568"

colors.fg = "#54433A"
colors.bg = "#D9D3CE"
colors.bg_alt = "#f1f1f1"

colors.normal = "#D9D3CE"
colors.focus = "#444444"
colors.marked = "#458588"

colors.wallpaper = assets_path .. "wallpaper_light.png"

return colors
