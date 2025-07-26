-- modules/net/protocol.lua
-- Message transmission utilities built on crypto

local config = require("config.default")
local env = require("config.environment")
local crypto = require("modules.net.crypto")

for k,v in pairs(env) do
    config[k] = v
end

local protocol = {}

function protocol.send(modem, message)
    local key = crypto.enhancedHash(message)
    local encrypted = crypto.encrypt(message, key)
    modem.transmit(config.modem_frequency, config.modem_frequency, encrypted .. key)
end

function protocol.receive(modem)
    while true do
        local evt, side, freq, reply, msg = os.pullEvent("modem_message")
        if freq == config.modem_frequency then
            local key = string.sub(msg, -4)
            local enc = string.sub(msg, 1, -5)
            local text = crypto.decrypt(enc, key)
            return text
        end
    end
end

return protocol
