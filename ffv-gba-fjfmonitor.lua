-- FJF Auto HUD
-- by Trysdyn Black, 2016

-- Monitors the memory state of a running Final Fantasy V ROM
-- and dumps job, ability, level, and job level data to a save file
-- to be picked up by another tool for display/tabulation/whatever

-- Requires a fairly "2016" vintage of Bizhawk and FFVA


-- Where to save the output. This defaults to your desktop. You can change it
-- to whatever you want.
filename = os.getenv("HOMEDRIVE") ..
           os.getenv("HOMEPATH") ..
           "\\desktop\\fjfmon.txt"

-- Addresses we check each frame
-- These are the job, ability, level, and job level of each of the 4 party slots, in order
addrs = {0x200DABD, 0x200DADE, 0x200DABE, 0x200DB01, 0x200DB21, 0x200DB42,
         0x200DB22, 0x200DB65, 0x200DB85, 0x200DBA6, 0x200DB86, 0x200DBC9,
         0x200DBE9, 0x200DC0A, 0x200DBEA, 0x200DC2D}

-- The state of the above addresses last frame
old_data = {}

local function check_data()
    data = {}
    diff = false

    -- Each frame, check if any of the 16 addr values changed
    -- There's an event for this (event.onmemorywrite) but...
    -- for some reason Bizhawk's Higan imp doesn't play well with it
    for i=1, 16 do
        b = memory.readbyte(addrs[i])
        data[i] = b

        -- If any of the values changed, we set diff which causes
        -- this function to return true when it's done
        if b ~= old_data[i] then
            diff = true
        end
    end

    -- Save the values for next frame's comparison
    old_data = data
    return diff
end

local function write_data()
    -- Write the 16 values to a temp file to be caught by another script
    -- This write one value per line, in the order indicated for addrs above
    local f = io.open(filename, 'w')

    -- Start the file with "GBA" to note that this dump comes from an GBA
    -- copy of the game. This may be important for some scripts.    
    f:write("GBA\n")
    for i = 1, 16 do
        f:write(string.format("%02x\n", old_data[i]))
    end
    f:close()
end

memory.usememorydomain("System Bus")
while true do
    -- Every frame, check if any of our watched values changed and write them
    -- out if so. Simple
    if check_data() then
        write_data()
    end
    emu.frameadvance()
end
