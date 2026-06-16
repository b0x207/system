hl.curve("basic", {
    type = "bezier",
    points = { { 0.25, 0 }, { 0.5, 1 } }
})


-- Disable everything
hl.animation({ leaf = "windows", enabled = false })
hl.animation({ leaf = "layers", enabled = false })
hl.animation({ leaf = "fade", enabled = false })
hl.animation({ leaf = "border", enabled = false })
hl.animation({ leaf = "borderangle", enabled = false })
hl.animation({ leaf = "workspaces", enabled = false })

-- Already high latency, thus fine
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 15, bezier = "basic" })
hl.animation({ leaf = "monitorAdded", enabled = true, speed = 15, bezier = "basic" })

-- Some things can have a little bit of *pizzazz*
local in_speed = 3
local out_speed = 5
local move_speed = 2
local generic_fade_speed = 1

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = in_speed,
    bezier = "basic",
    style = "popin 80%"
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = out_speed,
    bezier = "basic",
    style = "popin 80%"
})
hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = move_speed,
    bezier = "basic",
})

-- hl.animation({ leaf = "fadeLayers", enabled = true, speed = generic_fade_speed, bezier = "basic" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = in_speed, bezier = "basic" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = out_speed, bezier = "basic" })

-- hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "basic" })
