for i=1,8 do
    hl.workspace_rule({ workspace = i, monitor = "HDMI-A-1" })
end

hl.workspace_rule({ workspace = 9, monitor = "eDP-1" })
hl.workspace_rule({ workspace = 10, monitor = "eDP-1", default = true })
