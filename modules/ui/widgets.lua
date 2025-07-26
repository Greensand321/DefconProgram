-- modules/ui/widgets.lua
-- Higher level UI helpers

local base = require("modules.ui.base")
local widgets = {}

function widgets.blinkThreeLines(t1, t2, t3, y, flag)
    while flag[1] do
        for i,t in ipairs({t1,t2,t3}) do
            term.setCursorPos(1, y+i-1)
            term.clearLine()
            term.write(t)
        end
        sleep(0.5)
        for i=0,2 do
            term.setCursorPos(1, y+i)
            term.clearLine()
        end
        sleep(0.5)
    end
end

function widgets.countdown(startValue, x, y)
    for i=startValue,0,-1 do
        term.setCursorPos(x,y)
        term.clearLine()
        term.write("Countdown: "..i.." seconds remaining")
        sleep(1)
    end
    term.setCursorPos(x,y)
    term.clearLine()
    term.write("Countdown complete!")
end

return widgets
