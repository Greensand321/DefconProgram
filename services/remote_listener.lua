-- services/remote_listener.lua
-- Listens for launch commands and responds

local logger = require("modules.system.logger")
local protocol = require("modules.net.protocol")
local config = require("config.default")
local env = require("config.environment")
for k,v in pairs(env) do config[k]=v end

local modem
for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "modem" then
        modem = peripheral.wrap(side)
        break
    end
end
if not modem then error("No modem found") end
modem.open(config.modem_frequency)

logger.info("Listener started on frequency "..config.modem_frequency)
print("Listening on frequency "..config.modem_frequency)

while true do
    local msg = protocol.receive(modem)
    logger.info("Received: "..msg)
    if msg == "LAUNCH MISSILES" then
        print("Launch order received")
    end
    protocol.send(modem, "4321")
end
