-- services/command_center.lua
-- Main entry point and menu system

local ui = require("modules.ui.base")
local widgets = require("modules.ui.widgets")
local logger = require("modules.system.logger")
local scheduler = require("modules.tasks.scheduler")
local launch = require("services.launch_manager")
local arsenal = require("services.arsenal_service")
local permissions = require("modules.system.permissions")

local running = true

local function menu()
    while running do
        ui.clear()
        print("WOPR COMMAND MENU")
        print("1) Launch Sequence")
        print("2) View Arsenal")
        print("3) Exit")
        write("Select option: ")
        local choice = read()
        if choice == "1" then
            if permissions.check("user","launch") then
                launch.start()
            else
                print("Permission denied")
                sleep(2)
            end
        elseif choice == "2" then
            arsenal.view()
        elseif choice == "3" then
            running = false
            logger.info("User exited program")
        else
            print("Invalid choice")
            sleep(2)
        end
    end
end

scheduler.add(menu)
scheduler.run()
