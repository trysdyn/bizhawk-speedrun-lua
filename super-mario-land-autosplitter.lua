-- Super Mario Land autosplitter for LiveSplit
-- Trysdyn Black, 2016 https://github.com/trysdyn/bizhawk-speedrun-lua
-- Requires LiveSplit. LiveSplit server, and LuaSocket


world = -1
stage = -1
boss = false

function next_stage()
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
        s:send("reset\r\n")
    -- 1-1 is the start so start timer here
    elseif stage == 1 and world == 1 then
        s:send("starttimer\r\n")
    -- 44-44 is an "Interim" stage. Discard it
    elseif stage == 44 then

    -- In any other case, split
    else
        s:send("split\r\n")
    end
end

function final_split()
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
        s:send("split\r\n")
        boss = false
    end
end

-- Giving myself props. Feel free to remove this if it bothers you.
console.log("Autosplitter for LiveSplit.")
console.log("Trysdyn Black, 2016")
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

s:send("reset\r\n")

-- Set our memory domain for memory grabs in next_stage()
-- "System Bus" exposes the entire memory map: VRAM, WRAM, ROM, etc.
memory.usememorydomain("System Bus")

-- Catch when the stage number changes and handle splits
-- What these two addresses do is further explained in next_stage() and
-- final_split()
event.onmemorywrite(next_stage, 0x982E)
event.onmemorywrite(final_split, 0xD10C)

-- Bizhawk Lua requires the script to busy-loop or it'll exit and the handlers
-- will de-register. This is dumb :(
while true do
    emu.frameadvance()
end

