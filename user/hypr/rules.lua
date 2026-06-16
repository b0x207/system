-- Default the primary workspaces to any external monitor
local function primary_monitor_select()
    -- It is safe to assume that there will always be at least one monitor
    local selected_monitor = hl.get_monitors()[1]

    for _, monitor in ipairs(hl.get_monitors()) do
        -- Wherever possible, prefer the full DP monitor but if it can't be
        -- found, then HDMI-A-1 is a fair substitute
        if monitor.name == "HDMI-A-1" and selected_monitor.name ~= "DP-1" then
            selected_monitor = monitor
        elseif monitor.name == "DP-1" then
            selected_monitor = monitor
        end
    end

    return selected_monitor
end

local primary_monitor = primary_monitor_select()
for i=1,8 do
    hl.workspace_rule({ workspace = i, monitor = primary_monitor.name })
end


-- Per Workspace Layouts
hl.workspace_rule({ workspace = 10, layout = "scrolling" })


-- Make dolphin look right in various situations
hl.window_rule({
    name = "dolphin-transfer",
    match = {
        class = "org.kde.dolphin",
    },
    float = true,
    center = true,
    size = { 700, 145 },
})

hl.window_rule({
    name = "dolphin-normal",
    match = {
        initial_class = "org.kde.dolphin",
        initial_title = [[^\/.+ — Dolphin$]],
    },
    float = false,
})

hl.window_rule({
    name = "dolphin-file-open",
    match = {
        class = "org.freedesktop.impl.portal.desktop.kde",
    },
    float = true,
    center = true,
    size = { 1300, 950 },
})
