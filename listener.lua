-- listener.lua
-- Receives encrypted modem messages and sends back a confirmation
-- Intended to be run on another ComputerCraft computer

local statusNet, Net = pcall(require, "net_module")
if not statusNet or not Net then
    error("Could not load net_module.lua")
end

local statusLogger, Logger = pcall(require, "logger")
if not statusLogger or not Logger then
    -- Logging is optional, fall back to stub if not available
    Logger = {logEvent = function() end}
end

local FREQ = 1 -- same frequency as main.lua

-- detect modem
local modem
for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "modem" then
        modem = peripheral.wrap(side)
        break
    end
end
if not modem then
    error("No modem found. Attach a modem peripheral.")
end

modem.open(FREQ)
Logger.logEvent("Listener started on frequency " .. FREQ)
print("Listening on frequency " .. FREQ)

while true do
    local event, side, freq, replyChannel, message = os.pullEvent("modem_message")
    if freq == FREQ then
        -- decode incoming message
        local msgHash = string.sub(message, -4)
        local encMsg  = string.sub(message, 1, -5)
        local text    = Net.decryptMessage(encMsg, msgHash)
        Logger.logEvent("Received message: " .. text)
        print("Received: " .. text)

        -- send confirmation
        local response      = "4321"
        local responseHash  = Net.enhancedHash(response)
        local encResponse   = Net.encryptMessage(response, responseHash)
        modem.transmit(FREQ, FREQ, encResponse .. responseHash)
        Logger.logEvent("Sent confirmation: " .. response)
        print("Sent confirmation")
    end
end
