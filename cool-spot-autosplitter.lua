-- Cool Spot (SNES) autosplitter for LiveSplit
-- Trysdyn Black, 2017 https://github.com/trysdyn/bizhawk-speedrun-lua
-- Requires LiveSplit 1.7+

-- This is only tested for Easy difficulty level on the [U] rom
-- TODO: autosplit the run's final split

last_cool = 0
started = false

local function init_livesplit()
    pipe_handle = io.open("//./pipe/LiveSplit", 'a')

    if not pipe_handle then
        error("\nFailed to open LiveSplit named pipe!\n" ..
              "Please make sure LiveSplit is running and is at least 1.7, " ..
              "then load this script again")
    end

    pipe_handle:write("reset\r\n")
    pipe_handle:flush()

    return pipe_handle
end


-- This function checks how many cool points we have
-- If it's zero, we just finished a stage so we split
local function check_cool()
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
        pipe_handle:write("split\r\n")
        pipe_handle:flush()
    end
end


-- This function checks the small byte of the 2 byte game clock
-- The first level starts at 6 minutes, which is 104 on the small byte
-- The first time since reset we see 6:00, we know to start the timer
local function check_start()
    -- One byte of the game clock. This should be a 2 byte address
    -- but we don't need the large byte for this comparison
    local this_time = memory.readbyte(0x00CE)

    -- The first time in a run this byte is 104, we start the timer
    if this_time == 104 then
        return true
    end

    return false
end

-- Set up the livesplit pipe
pipe_handle = init_livesplit()

-- Set our memory domain for memory grabs in next_stage()
-- "System Bus" exposes the entire memory map: VRAM, WRAM, ROM, etc.
memory.usememorydomain("System Bus")

while true do
    -- Check for when to start the timer
    if check_start() then
        pipe_handle:write("starttimer\r\n")
        pipe_handle:flush()
    end

    -- Check cool points, which we use to judge when to split
    check_cool()
    emu.frameadvance()
end

