-- services/launch_manager.lua
-- Handles the launch sequence logic

local ui = require("modules.ui.base")
local widgets = require("modules.ui.widgets")
local logger = require("modules.system.logger")
local crypto = require("modules.net.crypto")
local protocol = require("modules.net.protocol")
local config = require("config.default")
local env = require("config.environment")
for k,v in pairs(env) do config[k]=v end

local launch = {}

local modem

local function detectModem()
    if modem then return end
    for _, side in ipairs(peripheral.getNames()) do
        if peripheral.getType(side) == "modem" then
            modem = peripheral.wrap(side)
            break
        end
    end
    if not modem then error("No modem found") end
    modem.open(config.modem_frequency)
end

local function verifyLaunchCode()
    for attempt=1,3 do
        ui.clear()
        print(string.format("ENTER LAUNCH CODE (%d/3):", attempt))
        local code = read()
        if crypto.enhancedHash(code) == config.launch_code_hash then
            return true
        else
            print("Invalid code")
            logger.warn("Invalid launch code attempt")
            sleep(2)
        end
    end
    return false
end

function launch.start()
    detectModem()
    ui.clear()
    print("WOPR EXECUTION ORDER")
    write("PART ONE: ")
    local partOne = read()
    write("PART TWO: ")
    local partTwo = read()

    local msg = partOne .. " " .. partTwo
    protocol.send(modem, msg)
    logger.info("Sent message: "..msg)

    local resp = protocol.receive(modem)
    logger.info("Received response: "..resp)

    if resp == "4321" and partOne == "1" and partTwo == "2" then
        if not verifyLaunchCode() then
            print("Too many invalid attempts")
            logger.warn("Launch code attempts exceeded")
            sleep(2)
            return
        end
        local flag = {true}
        coroutine.wrap(function()
            widgets.blinkThreeLines("==============================",
                "NUCLEAR ATTACK PROTOCOL ACTIVE",
                "==============================",6, flag)
        end)()

        widgets.countdown(10,1,12)
        flag[1]=false
        protocol.send(modem, "LAUNCH MISSILES")
        logger.info("Launch command sent")
        print("Missiles launched!")
        sleep(3)
    else
        print("Launch aborted or invalid parts")
        sleep(2)
    end
end

return launch
