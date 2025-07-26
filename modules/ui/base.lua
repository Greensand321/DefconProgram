-- modules/ui/base.lua
-- Base terminal utilities

local ui = {}

function ui.clear()
    term.clear()
    term.setCursorPos(1,1)
end

function ui.prompt(text)
    term.clearLine()
    term.write(text)
    return read()
end

return ui
