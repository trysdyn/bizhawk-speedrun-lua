-- FJF Auto HUD
-- by Trysdyn Black, 2016

-- Monitors the memory state of a running Final Fantasy V ROM
-- and dumps job, ability, level, and job level data to a save file
-- to be picked up by another tool for display/tabulation/whatever

-- Requires a fairly "2016" vintage of Bizhawk and
-- may require FFV RPGe translation 1.1, untested on anything else


-- Where to save the output. This defaults to your desktop. You can change it
-- to whatever you want.
filename = os.getenv("HOMEDRIVE") ..
           os.getenv("HOMEPATH") ..
           "\\desktop\\fjfmon.txt"

-- Addresses we check each frame
-- These are the job, ability, level, and job level of each of the
-- 4 party slots, in order
addrs = {0x501, 0x518, 0x502, 0x53A, 0x551, 0x568, 0x552, 0x58A,
         0x5A1, 0x5B8, 0x5A2, 0x5DA, 0x5F1, 0x608, 0x5F2, 0x62A}

-- The state of the above addresses last frame
old_data = {}

local function check_data()
    data = {}
    diff = false

    -- Each frame, check if any of the 16 addr values changed
    -- There's an event for this (event.onmemorywrite) but...
    -- for some reason Bizhawk's Higan imp doesn't play well with it
    for i=1, 16 do
        b = mainmemory.readbyte(addrs[i])
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

    -- Start the file with "SFC" to note that this dump comes from an SFC
    -- copy of the game. This may be important for some scripts.
    f:write("SFC\n")
    for i = 1, 16 do
        f:write(string.format("%02x\n", old_data[i]))
    end
    f:close()
end

while true do
    -- Every frame, check if any of our watched values changed and write them
    -- out if so. Simple
    if check_data() then
        write_data()
    end
    emu.frameadvance()
end
