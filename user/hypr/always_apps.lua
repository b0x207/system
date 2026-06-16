local ensure_cmd = function (cmd)
    hl.exec_cmd('if [ -z "$(pidof ' .. cmd .. ')" ]; then ' .. cmd .. '; fi')
end

local always_apps = function ()
    ensure_cmd("quickshell")
    ensure_cmd("nm-applet")
    ensure_cmd("blueman-applet")
    ensure_cmd("awww-daemon")
    hl.exec_cmd("awww img ~/config/wallpapers/earth-behind-moon.jpg")
end

hl.on("hyprland.start", always_apps)
hl.on("config.reloaded", always_apps)
