SMELTERY = "back"
LAMP = "top"
LEVER = "right"
MONITOR = "monitor_0"

local sm = peripheral.wrap(SMELTERY)
local m = peripheral.wrap(MONITOR)

local function lamp(state)
    rs.setAnalogOutput(LAMP, state)
end

local function isRunning()
    return rs.getAnalogInput(LEVER)
end

local function writeStatus()
    m.setCursorPos(2,5)
    m.clearLine()
    if (isRunning) then
        m.setTextColor(colors.lime)
        m.write("active")
    else
        m.setTextColor(colors.red)
        m.write("inactive")
    end
end

local function writeSmeltery(status)
    m.setCursorPos(2,8)
    m.clearLine()
    if (status == 1) then
        m.setTextColor(colors.lime)
        m.write("operating")
    else
        m.setTextColor(colors.gray)
        m.write("not operating")
    end
end

local function writeContent()
    m.setCursorPos(2,11)
    m.clearLine()

    local info = sm.getInfo()

    if (info.contents) then
        m.setTextColor(colors.lightGray)
        m.write(info.contents.rawName)
    else
        m.setTextColor(colors.gray)
        m.write("empty")
    end
end

local function mainLoop()

end


local function main()
    m.setCursorPos(2,2)
    m.setTextColor(colors.cyan)
    m.write("Smeltery System")

    m.setCursorPos(2,4)
    m.setTextColor(colors.orange)
    m.write("Status:")

    writeStatus()

    m.setCursorPos(2,7)
    m.setTextColor(colors.orange)
    m.write("Smeltery:")

    writeSmeltery(0)

    m.setCursorPos(2,10)
    m.setTextColor(colors.orange)
    m.write("Content:")

    writeContent()

    while true do
        mainLoop()
        sleep(1)
    end
end

main()