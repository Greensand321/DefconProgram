-- services/defcon_control.lua
-- Interactive DEFCON level controller for a ComputerCraft monitor

local levelColors = {
    [1] = colors.red,
    [2] = colors.orange,
    [3] = colors.yellow,
    [4] = colors.green,
    [5] = colors.blue,
}

local currentLevel = 5
local monitor

local function findMonitor()
    while not monitor do
        for _, name in ipairs(peripheral.getNames()) do
            if peripheral.getType(name) == "monitor" then
                monitor = peripheral.wrap(name)
                monitor.setTextScale(1)
                break
            end
        end
        if not monitor then
            term.clear()
            print("Waiting for monitor...")
            sleep(2)
        end
    end
end

local function headerText()
    return string.format("DEFCON %d", currentLevel)
end

local function drawButtons()
    local y = 3
    for i = 1, 5 do
        monitor.setBackgroundColor(levelColors[i])
        monitor.setTextColor(colors.black)
        monitor.setCursorPos(2, y)
        monitor.write(" " .. i .. " ")
        y = y + 2
    end
end

local function drawScreen()
    local w, _ = monitor.getSize()
    monitor.setBackgroundColor(levelColors[currentLevel])
    monitor.clear()
    monitor.setTextColor(colors.white)
    local text = headerText()
    monitor.setCursorPos(math.floor((w - #text) / 2) + 1, 1)
    monitor.write(text)
    drawButtons()
    monitor.setBackgroundColor(levelColors[currentLevel])
end

local function blinkDefcon1()
    for i = 1, 4 do
        drawScreen()
        sleep(0.5)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        sleep(0.5)
    end
    drawScreen()
end

local function handleTouch(x, y)
    local posY = 3
    for i = 1, 5 do
        if y == posY and x >= 2 and x <= 4 then
            if i == currentLevel then
                return
            end
            if i < currentLevel and i ~= currentLevel - 1 then
                return
            end
            currentLevel = i
            if currentLevel == 1 then
                blinkDefcon1()
            else
                drawScreen()
            end
            return
        end
        posY = posY + 2
    end
end

findMonitor()
drawScreen()

while true do
    local _, _, x, y = os.pullEvent("monitor_touch")
    handleTouch(x, y)
end

