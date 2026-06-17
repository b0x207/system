local function get_hostname()
    local handle = io.popen("hostname")
    if not handle then return "" end
    
    local hostname = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return hostname
end

if get_hostname() == "desktop" then
    hl.monitor({
        output = "DP-2",
        mode = "preferred",
        position = "0x0",
        scale = "1",
    })
    hl.monitor({
        output = "HDMI-A-4",
        mode = "preferred",
        position = "-1920x0",
        scale = "1",
    })
else
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
