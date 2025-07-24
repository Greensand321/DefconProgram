
-- logger.lua
-- Simple file-based logger for recording events.

local Logger = {}

local logFileName = "launch_log.txt"

function Logger.logEvent(message)
    local file = fs.open(logFileName, "a")
    if file then
        local timeStamp = os.date("%Y-%m-%d %H:%M:%S")
        file.writeLine(timeStamp .. " - " .. message)
        file.close()
    else
        print("Warning: Could not open log file.")
    end
end

return Logger
