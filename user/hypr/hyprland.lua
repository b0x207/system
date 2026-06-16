local function get_hostname()
    local handle = io.popen("hostname")
    if not handle then return "" end
    
    local hostname = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return hostname
end

-- MODULES (ORDER MATTERS)

require("monitors")
require("env")
require("binds")
require("config")
require("theme")
require("animations")

require("rules")
if get_hostname() == "desktop" then
    require("rules_desktop")
else
    require("rules_laptop")
end

require("always_apps")
