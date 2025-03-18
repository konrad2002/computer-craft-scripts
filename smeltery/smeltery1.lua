SMELTERY = "back"
LAMP = "top"
LEVER = "right"
MONITOR = "monitor_0"
BUS = "bottom"

OUTPUTS = {
    colors.pink,
    colors.red,
    colors.orange,
    colors.yellow,
    colors.lime,
    colors.green,
    colors.cyan,
    colors.blue,
    colors.lightBlue,
}

local sm = peripheral.wrap(SMELTERY)
local m = peripheral.wrap(MONITOR)

local function lamp(state)
    rs.setAnalogOutput(LAMP, state)
end

local function isRunning()
    return rs.getAnalogInput(LEVER) > 0
end

local function isOperating()
    if sm.getInfo().contents then
        return true
    end

    local stacks = sm.getAllStacks()
    for _, t in pairs(stacks) do
        if t.all().display_name then
            return true
        end
    end
    return false
end

local function writeStatus()
    m.setCursorPos(2,5)
    m.clearLine()
    if (isRunning()) then
        m.setTextColor(colors.lime)
        m.write("active")
    else
        m.setTextColor(colors.red)
        m.write("inactive")
    end
end

local function writeSmeltery()
    m.setCursorPos(2,8)
    m.clearLine()
    if (State == 1) then
        m.setTextColor(colors.yellow)
        m.write("waiting")
    elseif (State == 2) then
        m.setTextColor(colors.lime)
        m.write("operating")
    else
        m.setTextColor(colors.gray)
        m.write("not operating")
    end
end

local function writeContent()
    local info = sm.getInfo()
    local stacks = sm.getAllStacks()

    m.setCursorPos(2,11)
    m.clearLine()

    if info.contents then
        m.setTextColor(colors.lightGray)
        m.write(info.contents.rawName)
    else
        local name = ""

        for _, t in pairs(stacks) do
            if t.all().display_name then
                name = t.all().display_name
                break
            end
        end

        if name ~= "" then
            m.setTextColor(colors.lightGray)
            m.write("*" .. name)
        else
            m.setTextColor(colors.gray)
            m.write("empty")
        end
    end
end

State = 0   -- state 0: emtpy, 1: waiting, 2: operating
Latest = 0  -- latest ore: 0 - length

local function mainLoop()
    writeStatus()
    writeSmeltery()
    writeContent()

    if isOperating() then
        lamp(15)
    else
        lamp(0)
    end
    if (isRunning()) then
        if State == 0 then
            Latest = ((Latest + 1) % #OUTPUTS)
            rs.setBundledOutput(BUS, OUTPUTS[Latest + 1])
            State = 1
        elseif State == 1 then
            if isOperating() then
                State = 2
            end
        elseif State == 2 then
            if ~isOperating() then
                rs.setBundledOutput(BUS, 0)
                State = 0
            end
        end
    else
        rs.setBundledOutput(BUS, 0)
    end
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

    writeSmeltery()

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