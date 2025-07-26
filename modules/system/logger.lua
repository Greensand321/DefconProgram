-- modules/system/logger.lua
-- Simple logger with log level support

local fs = fs
local config = require("config.default")
local env = require("config.environment")
for k,v in pairs(env) do config[k]=v end

local logger = {}

local function ensureLogDir()
    if not fs.exists(config.log_dir) then
        fs.makeDir(config.log_dir)
    end
end

function logger.log(level, message)
    ensureLogDir()
    local file = fs.open(config.log_file, "a")
    if file then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        file.writeLine(string.format("[%s] %s - %s", level, timestamp, message))
        file.close()
    end
end

function logger.info(msg)
    logger.log("INFO", msg)
end

function logger.warn(msg)
    logger.log("WARN", msg)
end

return logger
