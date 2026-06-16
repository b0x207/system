-- TODO: remote duplicate
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

if primary_monitor.name == "DP-1" then
    hl.monitor({
        output = "DP-1",
        mode = "preferred",
        position = "0x0",
        scale = "1",
    })
    hl.monitor({
        output = "HDMI-A-1",
        mode = "preferred",
        position = "-1920x0",
        scale = "1",
    })
elseif primary_monitor.name == "HDMI-A-1" then
    hl.monitor({
        output = "HDMI-A-1",
        mode = "preferred",
        position = "0x0",
        scale = "1",
    })
end

hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "-1920x0",
    scale = "1",
})
