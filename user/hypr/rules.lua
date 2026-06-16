-- Default the primary workspaces to any external monitor
for i=1,8 do
    hl.workspace_rule({ workspace = i, monitor = "HDMI-A-1" })
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
