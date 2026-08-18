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

-- Make the Bitwarden browser extension popups float rather than tile
-- Naturally, nothing is ever easy and we have to do some extra work because Firefox changes the
-- extension window title after it is spawned.
hl.on("window.title", function (w)
    local pattern = "Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox"
    if string.find(w.title, pattern, nil, true) then
        hl.dispatch(
            hl.dsp.window.float({
                action = "enable",
                window = w
            })
        )

        -- For some reason, centering and then resizing forces the window to follow the centering
        -- dispatch. If the order is reversed, however, then this fails completely.
        hl.dispatch(hl.dsp.window.center({ window = w }))
        hl.dispatch(hl.dsp.window.resize({ x = 1300, y = 950, window = w }))
    end
end)
