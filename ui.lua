-- ui.lua
-- Provides various user interface helpers for terminal output.

local UI = {}

----------------------------------------
-- Clear screen and reset cursor
----------------------------------------
function UI.clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

----------------------------------------
-- Blink three lines of text simultaneously 
-- at positions (y), (y+1), (y+2).
-- Accepts a "blinkFlagRef" table whose [1]
-- can be set to false to stop blinking.
----------------------------------------
function UI.blinkTextSimultaneous(text1, text2, text3, y, blinkFlagRef, showTime, hideTime)
    while blinkFlagRef[1] do
        -- Show lines
        for i, t in ipairs({text1, text2, text3}) do
            term.setCursorPos(1, y + (i - 1))
            term.clearLine()
            term.write(t)
        end
        sleep(showTime)

        -- Hide lines
        for i = 0, 2 do
            term.setCursorPos(1, y + i)
            term.clearLine()
        end
        sleep(hideTime)
    end
end

----------------------------------------
-- Countdown function with optional color changes
----------------------------------------
function UI.startCountdown(startValue, x, y)
    local isColor = term.isColor and term.isColor()
    for i = startValue, 0, -1 do
        term.setCursorPos(x, y)
        term.clearLine()

        -- If advanced terminal, color for final 3 seconds
        if isColor and i <= 3 then
            term.setTextColor(colors.red)
        end
        
        term.write("Countdown: " .. i .. " seconds remaining")

        if isColor then
            term.setTextColor(colors.white)
        end

        sleep(1)
    end
    term.setCursorPos(x, y)
    term.clearLine()
    term.write("Countdown complete!")
end

----------------------------------------
-- Prompt user with a question and read input
----------------------------------------
function UI.prompt(promptText)
    term.clearLine()
    term.write(promptText)
    return read()
end

return UI
