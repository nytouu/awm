local menubar = require("menubar")

terminal = "tabbed -c -k -b -r 2 st -w ''"
explorer = "thunar"
browser = "zen"
launcher = "rofi -show drun"
music_client = "youtube-music"
editor = os.getenv("EDITOR") or "nvim"
visual_editor = "code" -- vscode
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4" -- super, the windows key

-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
