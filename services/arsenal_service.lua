-- services/arsenal_service.lua
-- Displays available missile inventory (stubbed data)

local ui = require("modules.ui.base")
local logger = require("modules.system.logger")

local missiles = {
    {id="MX-01", status="Ready"},
    {id="MX-02", status="Ready"},
    {id="MX-03", status="Maintenance"}
}

local arsenal = {}

function arsenal.view()
    ui.clear()
    print("=== MISSILE ARSENAL ===")
    for i,m in ipairs(missiles) do
        print(string.format("%s - %s", m.id, m.status))
    end
    print("\nPress Enter to return")
    read()
end

return arsenal
