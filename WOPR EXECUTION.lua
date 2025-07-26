--wopr execution debug
-- Require the Net module
local Net = require("net_module")

-- Function to clear the terminal screen
local function clearScreen()
    term.clear()               -- Clear the entire terminal
    term.setCursorPos(1, 1)   -- Reset cursor position to the top-left corner
end

-- Function to input launch code
local function inputLaunchCode()
    term.setCursorPos(1, 10)
    term.write("LAUNCH CODE: _ _ _ _ _ _ _ _ _ _")
    term.setCursorPos(13, 10)
    return read()  -- Get launch code input from the user
end

-- Countdown timer function
local function countdown(seconds)
    for i = seconds, 1, -1 do
        term.setCursorPos(1, 22)  -- Set cursor to the line for countdown display
        term.clearLine()  -- Clear the countdown line
        term.write("Countdown: " .. i .. " seconds remaining")
        sleep(1)  -- Wait for 1 second
    end
    term.setCursorPos(1, 22)  -- Move cursor to countdown line
    term.clearLine()  -- Clear the countdown line
    term.write("Countdown complete!        ")  -- Final message
end

-- Function to print three lines of blinking text simultaneously
local function blinkTextSimultaneous(text1, text2, text3, y)
    while true do  -- Run indefinitely
        -- Show all three lines
        term.setCursorPos(1, y)
        term.clearLine()
        term.write(text1)

        term.setCursorPos(1, y + 1)
        term.clearLine()
        term.write(text2)

        term.setCursorPos(1, y + 2)
        term.clearLine()
        term.write(text3)

        sleep(0.5)  -- Pause to show the text for 0.5 seconds

        -- Clear all three lines (hide text)
        term.setCursorPos(1, y)
        term.clearLine()

        term.setCursorPos(1, y + 1)
        term.clearLine()

        term.setCursorPos(1, y + 2)
        term.clearLine()

        sleep(0.5)  -- Pause to hide the text for 0.5 seconds
    end
end

-- Main program logic in a loop
while true do
    clearScreen()  -- Clear the screen at the start of each loop iteration
    term.setCursorPos(1, 1)
    term.write("WOPR EXECUTION ORDER")
    term.setCursorPos(1, 2)
    term.write("IRON FIST")
    term.setCursorPos(1, 4)
    term.write("PART ONE: ")
    local partOne = read()

    term.setCursorPos(1, 6)
    term.write("PART TWO: ")
    local partTwo = read()

    -- Send the user inputs for Part One and Part Two
    local messageToSend = partOne .. " " .. partTwo
    local messageHash = Net.enhancedHash(messageToSend)  -- Compute the hash of the message
    local encryptedMessage = Net.encryptMessage(messageToSend, messageHash)  -- Encrypt the message

    -- Transmit the encrypted message with the hash
    local modem = peripheral.wrap("top")  -- Wrap the modem
    modem.transmit(1, 1, encryptedMessage .. messageHash)  -- Send the message

    -- Wait for the confirmation message "4321"
    local confirmationReceived = false
    while not confirmationReceived do
        -- Listen for incoming messages
        local event, side, freq, replyChannel, message, distance = os.pullEvent("modem_message")
        if freq == 1 then  -- Check if the received message is on the correct channel
            local receivedHash = string.sub(message, -4)  -- Extract the hash
            local encryptedMessageReceived = string.sub(message, 1, -5)  -- Get the encrypted message
            local originalMessage = Net.decryptMessage(encryptedMessageReceived, receivedHash)  -- Decrypt the message

            if originalMessage == "4321" then  -- Check if the received message is "4321"
                confirmationReceived = true  -- Set the flag to true if received message is correct
                print("Confirmation message received: " .. originalMessage)
            else
                print("Unexpected message received: " .. originalMessage)  -- Handle unexpected messages
            end
        end
    end

    if partOne == "1" and partTwo == "2" then
        local launchCode = inputLaunchCode()  -- Call inputLaunchCode function to get launch code

            if launchCode == "123456789" then
        coroutine.wrap(function()
            blinkTextSimultaneous(
                "==============================",
                "NUCLEAR ATTACK PROTOCOL ACTIVE",
                "==============================",
                12
            )
        end)()

        sleep(1)
        term.setCursorPos(1, 16)
        term.write("LAUNCH ORDER CONFIRMED")

        term.setCursorPos(1, 17)
        term.write("TARGET SELECTION:        _")
        term.setCursorPos(1, 18)
        term.write("TIME ON TARGET:          _")
        term.setCursorPos(1, 19)
        term.write("YIELD SELECTION:         _")

        term.setCursorPos(20, 17)
        local target = read()
        term.setCursorPos(20, 18)
        local time = read()
        term.setCursorPos(20, 19)
        local yield = read()

        coroutine.wrap(function()
            blinkTextSimultaneous(
                "========================",
                "MISSILES READY TO LAUNCH",
                "========================",
                21
            )
        end)()

        sleep(1)
        term.setCursorPos(1, 25)
        term.write("PLEASE CONFIRM (Y/N) PRESS N TO ABORT")
        local confirm = read()

        if confirm == "Y" or confirm == "y" then
            term.setCursorPos(1, 27)
            term.write("LAUNCH TIME: BEGIN COUNTDOWN")
            sleep(2)

            -- Updated countdown function with adjustable position
            local function startCountdown(x, y, startValue)
                local count = startValue
                while count >= 0 do
                    term.setCursorPos(x, y)
                    term.clearLine()
                    term.write("Countdown: " .. count .. " seconds remaining")
                    sleep(1)
                    count = count - 1
                end
                term.setCursorPos(x, y)
                term.clearLine()
                term.write("Countdown complete!")
            end

            -- Start countdown from 10 at position (1, 28)
            startCountdown(1, 28, 10)

            local message = "LAUNCH MISSILES"
            local messageHash = Net.enhancedHash(message)
            local encryptedMessage = Net.encryptMessage(message, messageHash)

            local modem = peripheral.wrap("top")
            modem.transmit(1, 1, encryptedMessage .. messageHash)

            term.setCursorPos(1, 36)
            coroutine.wrap(function()
                blinkTextSimultaneous(
                    "===================",
                    "MISSILES LAUNCHED",
                    "===================",
                    30
                )
            end)()

        elseif confirm == "N" or confirm == "n" then
            term.setCursorPos(1, 37)
            term.write("LAUNCH ABORTED.")
        else
            term.setCursorPos(1, 37)
            term.write("INVALID INPUT")
            sleep(5)
            term.setCursorPos(1, 32)
            term.clearLine()
        end
    else
        term.setCursorPos(1, 10)
        term.write("Invalid launch code.")
        sleep(2)
        term.setCursorPos(1, 10)
        term.clearLine()
    end

        -- Invalid input for PART ONE or PART TWO
        term.setCursorPos(1, 10)
        term.write("Invalid input.")
        sleep(5)  -- Pause for 5 seconds
        term.setCursorPos(1, 10)
        term.clearLine()  -- Clear the invalid input message
    end

    -- Optionally, you can ask the user if they want to restart the program
    term.setCursorPos(1, 37)
    term.write("Would you like to restart? (Y/N): ")
    local restartConfirm = read()
    if restartConfirm ~= "Y" and restartConfirm ~= "y" then
        break  -- Exit the loop and end the program
    end
end
