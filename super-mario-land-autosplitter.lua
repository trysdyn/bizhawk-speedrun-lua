-- Super Mario Land autosplitter for LiveSplit
-- Trysdyn Black, 2016 https://github.com/trysdyn/bizhawk-speedrun-lua
-- Requires LiveSplit 1.7+

world = -1
stage = -1
boss = false

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

local function next_stage()
    -- When the stage changes, we want to check if it's time to split.
    -- This function checks what stage we just moved into, and does the
    -- needful based on that.

    -- The stage number as displayed at the start of a new stage
    local this_world = memory.readbyte(0x982C)
    local this_stage = memory.readbyte(0x982E)

    -- In some cases the stage bytes are written without changing
    -- In those cases, just return, we don't want to do anything
    if world == this_world and stage == this_stage then
        return
    end

    -- Save the world/stage as globals for comparison purposes above
    world = this_world
    stage = this_stage


    -- Title screen is "0-0". Reset on this
    if stage == 0 then
        pipe_handle:write("reset\r\n")
        pipe_handle:flush()
    -- 1-1 is the start so start timer here
    elseif stage == 1 and world == 1 then
        pipe_handle:write("starttimer\r\n")
        pipe_handle:flush()
    -- 44-44 is an "Interim" stage. Discard it
    elseif stage == 44 then

    -- In any other case, split
    else
        pipe_handle:write("split\r\n")
        pipe_handle:flush()
    end
end

local function final_split()
    -- d10c is the boss HP but it's used by a ton of other stuff
    -- 216 is the boss initial HP, and seems to never show up otherwise
    -- So if d10c is 216, we start considering it boss HP and split when
    -- it hits 0.

    -- Grab 0xD10C and if it's 216, turn on the flag that says we're at the boss
    local d10c = memory.readbyte(0xD10C)
    if d10c == 216 then
        boss = true
    end

    -- If the boss flag is on and 0xD10C becomes 0, we just finished the game
    -- so split :)
    if d10c == 0 and boss == true then
        pipe_handle:write("split\r\n")
        pipe_handle:flush()
        boss = false
    end
end

-- Set up our TCP socket to LiveSplit and send a reset to be sure
pipe_handle = init_livesplit()

-- Set our memory domain for memory grabs in next_stage()
-- "System Bus" exposes the entire memory map: VRAM, WRAM, ROM, etc.
memory.usememorydomain("System Bus")

-- Catch when the stage number changes and handle splits
-- What these two addresses do is further explained in next_stage() and
-- final_split()
event.onmemorywrite(next_stage, 0x982E)
event.onmemorywrite(final_split, 0xD10C)

-- Bizhawk Lua requires the script to busy-loop or it'll exit
while true do
    emu.frameadvance()
end

