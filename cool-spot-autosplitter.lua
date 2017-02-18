-- Cool Spot (SNES) autosplitter for LiveSplit
-- Trysdyn Black, 2017 https://github.com/trysdyn/bizhawk-speedrun-lua
-- Requires LiveSplit. LiveSplit server, and LuaSocket

-- This is only tested for Easy difficulty level on the [U] rom
-- TODO: autosplit the run's final split


last_cool = 0
started = false


-- This function checks how many cool points we have
-- If it's zero, we just finished a stage so we split
function check_cool()
    -- Cool points address
    local this_cool = memory.readbyte(0x00D2)

    -- If cool points hasn't changed, return and do nothing
    if this_cool == last_cool then
        return
    end

    -- Save the cool points as globals for comparison purposes above
    last_cool = this_cool

    -- Once cool hits 0, split
    if this_cool == 0 then
        s:send("split\r\n")
    end
end


-- This function checks the small byte of the 2 byte game clock
-- The first level starts at 6 minutes, which is 104 on the small byte
-- The first time since reset we see 6:00, we know to start the timer
function check_start()
    -- One byte of the game clock. This should be a 2 byte address
    -- but we don't need the large byte for this comparison
    local this_time = memory.readbyte(0x00CE)

    -- The first time in a run this byte is 104, we start the timer
    if this_time == 104 then
        return true
    end

    return false
end


-- Giving myself props. Feel free to remove this if it bothers you.
console.log("Autosplitter for LiveSplit.")
console.log("Trysdyn Black, 2017")
console.log()

local socket = require("socket.core")

-- Set up our TCP socket to LiveSplit and send a reset to be sure
s = socket:tcp()
if s:connect("127.0.0.1", 16834) == nil then
    console.log("ERR: Failed to connect to LiveSplit")
    console.log("Make sure LiveSplit's server component is running and Restart")
else
    console.log("Connected to LiveSplit, ready to go")
end

-- Unset started flag and reset splits
started = false
s:send("reset\r\n")

-- Set our memory domain for memory grabs in next_stage()
-- "System Bus" exposes the entire memory map: VRAM, WRAM, ROM, etc.
memory.usememorydomain("System Bus")

-- Bizhawk has events for this, but they don't work right with SNES :(
-- So we call our check function every frame
while true do
    -- If we haven't started, look for clock to be 6:00 to indicate start
    if not started then
        -- Once we start, set started flag and start timer
        if check_start() then
            started = true
            s:send("starttimer\r\n")
        end
    end
    -- Check cool points, see check_cool() above
    check_cool()
    emu.frameadvance()
end

