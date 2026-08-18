local terminal = "ghostty --working-directory=home"
local file_manager = "dolphin"
local menu = "rofi -show drun"
local browser = "firefox"
local calculator = "rofi -show calc -modi calc -no-show-match -no-sort"
local shutdown = "hyprshutdown -t 'Exiting hyprland...'"
local screenlocker = "hyprlock"

local modKey = "SUPER"

-- BASIC ENVIRONMENT MANIPULATION

hl.bind(modKey .. " + SHIFT + E", hl.dsp.exec_cmd(shutdown))
hl.bind(modKey .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(
    modKey .. " + F",
    hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })
)
hl.bind(modKey .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(modKey .. " + mouse:272", hl.dsp.window.drag())
hl.bind(modKey .. " + mouse:273", hl.dsp.window.resize())
hl.bind("F9", hl.dsp.exec_cmd(screenlocker))

-- WINDOW MANAGEMENT

hl.bind(modKey .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(modKey .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(modKey .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(modKey .. " + K", hl.dsp.focus({ direction = "u" }))

hl.bind(modKey .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(modKey .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(modKey .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(modKey .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))

hl.bind(modKey .. " + G", hl.dsp.group.toggle())
hl.bind(modKey .. " + right", hl.dsp.group.next())
hl.bind(modKey .. " + left", hl.dsp.group.prev())

-- IMPORTANT PROGRAMS

hl.bind(modKey .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(modKey .. " + P", hl.dsp.exec_cmd(browser))
hl.bind(modKey .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(modKey .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(modKey .. " + C", hl.dsp.exec_cmd(calculator))

-- WORKSPACES

for i=1,9 do
    hl.bind(modKey .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(modKey .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(modKey .. " + 0", hl.dsp.focus({ workspace = 10, follow = false }))
hl.bind(modKey .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind(modKey .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(modKey .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(modKey .. " + SHIFT + Prior", hl.dsp.workspace.move({ monitor = "HDMI-A-1" }))
hl.bind(modKey .. " + SHIFT + Next", hl.dsp.workspace.move({ monitor = "eDP-1" }))

-- SCREEN BRIGHTNESS

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))

-- SCREENSHOTS

hl.bind(modKey .. " + S", hl.dsp.exec_cmd("hyprquickframe"))
hl.bind(modKey .. " + SHIFT + S", hl.dsp.exec_cmd("env HYPRQUICKFRAME_EDITOR=1 hyprquickframe"))

-- AUDIO

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind(modKey .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"))
hl.bind(modKey .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"))

-- NOTIFICATIONS

hl.bind(modKey .. " + N", hl.dsp.exec_cmd("swaync-client --toggle-panel --skip-wait"))
