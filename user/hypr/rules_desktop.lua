for i=1,8 do
    hl.workspace_rule({ workspace = i, monitor = "DP-2" })
end

hl.workspace_rule({ workspace = 9, monitor = "HDMI-A-4" })
hl.workspace_rule({ workspace = 10, monitor = "HDMI-A-4", default = true })
