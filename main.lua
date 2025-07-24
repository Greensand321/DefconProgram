-- main.lua
-- WOPR Execution Program with adjusted line positions to avoid large gaps or overlap.

----------------------------------------
-- Load dependencies
----------------------------------------
local statusNet, Net = pcall(require, "net_module")
if not statusNet or not Net then
    error("Error: Could not load 'net_module.lua'. Make sure it is in the same folder.")
end

local statusUI, UI = pcall(require, "ui")
if not statusUI or not UI then
    error("Error: Could not load 'ui.lua'. Make sure it is in the same folder.")
end

local statusLogger, Logger = pcall(require, "logger")
if not statusLogger or not Logger then
    error("Error: Could not load 'logger.lua'. Make sure it is in the same folder.")
end

----------------------------------------
-- Dynamic modem detection
----------------------------------------
local modem
for _, side in ipairs(peripheral.getNames()) do
    if peripheral.getType(side) == "modem" then
        modem = peripheral.wrap(side)
        break
    end
end

if not modem then
    error("No modem found. Please attach a modem peripheral.")
end

-- We must open channel 1 to receive "4321"
modem.open(1)

----------------------------------------
-- Configuration
-- Using Net's default hash for "123456789": "39c3"
----------------------------------------
local LAUNCH_CODE_HASH = "39c3"  -- Matches Net.enhancedHash("123456789")
local MAX_ATTEMPTS     = 3       -- How many tries for the launch code
local FREQ             = 1       -- Frequency for modem communications

----------------------------------------
-- Helper: Attempt to get user launch code
----------------------------------------
local function getVerifiedLaunchCode()
    for attempt = 1, MAX_ATTEMPTS do
        UI.clearScreen()
        term.setCursorPos(1, 1)
        term.write("ENTER LAUNCH CODE (" .. attempt .. "/" .. MAX_ATTEMPTS .. "):")
        local code = read()
        local codeHash = Net.enhancedHash(code)

        if codeHash == LAUNCH_CODE_HASH then
            return true
        else
            term.setCursorPos(1, 3)
            term.write("Invalid code.")
            Logger.logEvent("Invalid launch code attempt. Attempt #" .. attempt)
            sleep(2)
        end
    end
    return false
end

----------------------------------------
-- Transmit a message with its hash
----------------------------------------
local function transmitMessage(message)
    local messageHash = Net.enhancedHash(message)
    local encrypted   = Net.encryptMessage(message, messageHash)
    modem.transmit(FREQ, FREQ, encrypted .. messageHash)
    Logger.logEvent("Transmitted message: " .. message)
end

----------------------------------------
-- Wait for "4321" confirmation
----------------------------------------
local function waitForConfirmation()
    Logger.logEvent("Waiting for confirmation '4321' on freq " .. FREQ)
    while true do
        local event, side, freq, replyChannel, message, distance = os.pullEvent("modem_message")
        if freq == FREQ then
            local receivedHash = string.sub(message, -4)
            local encryptedMsg = string.sub(message, 1, -5)
            local originalMsg  = Net.decryptMessage(encryptedMsg, receivedHash)

            if originalMsg == "4321" then
                Logger.logEvent("Received confirmation: 4321")
                return true
            else
                print("Unexpected message: " .. originalMsg)
                Logger.logEvent("Unexpected message received: " .. originalMsg)
            end
        end
    end
end

----------------------------------------
-- The nuclear protocol sequence
----------------------------------------
local function startNuclearProtocol()
    Logger.logEvent("Starting NUCLEAR ATTACK PROTOCOL")
    
    -- Blink "NUCLEAR ATTACK PROTOCOL ACTIVE" near the top
    local blinkFlag = {true}
    coroutine.wrap(function()
        UI.blinkTextSimultaneous(
            "==============================",
            "NUCLEAR ATTACK PROTOCOL ACTIVE",
            "==============================",
            6,   -- Moved to lines 6,7,8 to reduce empty space
            blinkFlag,
            0.5,
            0.5
        )
    end)()

    sleep(1)
    -- Show "LAUNCH ORDER CONFIRMED" on line 10
    term.setCursorPos(1, 10)
    term.write("LAUNCH ORDER CONFIRMED")

    -- Prompt user for target, time, yield
    term.setCursorPos(1, 11)
    term.write("TARGET SELECTION:        _")
    term.setCursorPos(20, 11)
    local target = read()
    Logger.logEvent("Target: " .. target)

    term.setCursorPos(1, 12)
    term.write("TIME ON TARGET:          _")
    term.setCursorPos(20, 12)
    local time = read()
    Logger.logEvent("Time On Target: " .. time)

    term.setCursorPos(1, 13)
    term.write("YIELD SELECTION:         _")
    term.setCursorPos(20, 13)
    local yield = read()
    Logger.logEvent("Yield: " .. yield)

    -- Blink "MISSILES READY TO LAUNCH" at lines 15,16,17
    local blinkFlag2 = {true}
    coroutine.wrap(function()
        UI.blinkTextSimultaneous(
            "========================",
            "MISSILES READY TO LAUNCH",
            "========================",
            15,
            blinkFlag2,
            0.5,
            0.5
        )
    end)()

    -- Wait 1 second, then put the confirm prompt at line 19
    sleep(1)
    term.setCursorPos(1, 19)
    term.clearLine()
    term.write("PLEASE CONFIRM (Y/N) PRESS N TO ABORT")

    local confirm = read()

    -- Stop the second blinking text
    blinkFlag2[1] = false

    if confirm:lower() == "y" then
        Logger.logEvent("Launch confirmed by user.")
        term.setCursorPos(1, 21)
        term.clearLine()
        term.write("LAUNCH TIME: BEGIN COUNTDOWN")
        sleep(2)

        -- Start a countdown from 10
        UI.startCountdown(10, 1, 22)

        -- Send "LAUNCH MISSILES" message
        transmitMessage("LAUNCH MISSILES")

        -- Stop the first blinking text
        blinkFlag[1] = false

        sleep(0.2)
        UI.clearScreen()
        term.setCursorPos(1, 2)
        term.write("MISSILES LAUNCHED")
        Logger.logEvent("Missiles launched.")

        -- Blink final message
        local blinkFlag3 = {true}
        coroutine.wrap(function()
            UI.blinkTextSimultaneous(
                "===================",
                "MISSILES LAUNCHED",
                "===================",
                5,
                blinkFlag3,
                0.5,
                0.5
            )
        end)()

        -- Pause so user can see
        sleep(5)
        blinkFlag3[1] = false
        UI.clearScreen()

    elseif confirm:lower() == "n" then
        Logger.logEvent("Launch aborted by user.")
        blinkFlag[1] = false
        term.setCursorPos(1, 21)
        term.write("LAUNCH ABORTED.")
        sleep(3)
    else
        Logger.logEvent("Invalid final confirm input: '" .. confirm .. "'")
        term.setCursorPos(1, 21)
        term.write("INVALID INPUT")
        sleep(2)
    end
end

----------------------------------------
-- Main Launch Sequence
----------------------------------------
local function launchSequence()
    UI.clearScreen()
    term.setCursorPos(1,1)
    term.write("WOPR EXECUTION ORDER")
    term.setCursorPos(1,2)
    term.write("IRON FIST")

    -- PART ONE / PART TWO
    term.setCursorPos(1,4)
    term.write("PART ONE: ")
    local partOne = read()

    term.setCursorPos(1,6)
    term.write("PART TWO: ")
    local partTwo = read()

    -- Transmit the user inputs
    local messageToSend = partOne .. " " .. partTwo
    transmitMessage(messageToSend)

    -- Wait for confirmation "4321"
    if waitForConfirmation() then
        if partOne == "1" and partTwo == "2" then
            -- Verify launch code
            local verified = getVerifiedLaunchCode()
            if not verified then
                term.setCursorPos(1,10)
                term.clearLine()
                term.write("Too many invalid attempts. System locked.")
                Logger.logEvent("Launch code attempts exceeded.")
                sleep(3)
                return
            end
            -- If verified, proceed
            startNuclearProtocol()
        else
            UI.clearScreen()
            term.setCursorPos(1,10)
            term.write("Invalid input for PART ONE or PART TWO.")
            Logger.logEvent("Invalid PART ONE/PART TWO: " .. partOne .. " / " .. partTwo)
            sleep(3)
        end
    end
end

----------------------------------------
-- View Logs
----------------------------------------
local function viewLogs()
    UI.clearScreen()
    term.setCursorPos(1,1)
    term.write("=== LOG VIEWER ===")
    term.setCursorPos(1,3)
    
    if not fs.exists("launch_log.txt") then
        term.write("No log file found.")
    else
        local file = fs.open("launch_log.txt", "r")
        if file then
            local lineCount = 0
            for line in file.readLine do
                lineCount = lineCount + 1
                print(line)
                if lineCount % 18 == 0 then
                    term.write("\nPress Enter to continue...")
                    read()
                    UI.clearScreen()
                    term.setCursorPos(1,1)
                    term.write("=== LOG VIEWER ===")
                    term.setCursorPos(1,3)
                end
            end
            file.close()
        end
    end

    term.setCursorPos(1, 19)
    term.write("Press Enter to return to menu.")
    read()
end

----------------------------------------
-- Main Menu
----------------------------------------
local function mainMenu()
    while true do
        UI.clearScreen()
        term.setCursorPos(1,1)
        term.write("WOPR COMMAND MENU")
        term.setCursorPos(1,2)
        term.write("1) Launch Sequence")
        term.setCursorPos(1,3)
        term.write("2) View Logs")
        term.setCursorPos(1,4)
        term.write("3) Exit")

        term.setCursorPos(1,6)
        term.write("Select option: ")
        local choice = read()

        if choice == "1" then
            launchSequence()
        elseif choice == "2" then
            viewLogs()
        elseif choice == "3" then
            UI.clearScreen()
            term.setCursorPos(1,1)
            term.write("Exiting program. Goodbye.")
            Logger.logEvent("User exited the program.")
            sleep(2)
            break
        else
            term.setCursorPos(1,8)
            term.write("Invalid choice.")
            sleep(2)
        end
    end
end

----------------------------------------
-- Program Entry
----------------------------------------
mainMenu()
