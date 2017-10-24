-- Monster Rancher Hop-A-Bout autosplitter for LiveSplit
-- Trysdyn Black, 2017 https://github.com/trysdyn/bizhawk-speedrun-lua
-- Requires LiveSplit 1.7+

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

local function next_level()
    -- Split and flush the handle so it's timed accurately
    pipe_handle:write("split\r\n")
    pipe_handle:flush()
end

memory.usememorydomain("MainRAM")
pipe_handle = init_livesplit()
last_level = 0

while true do
    local this_level = memory.readbyte(0x08AB39)
    if this_level ~= last_level then
        last_level = this_level
        -- Time starts at character select, so a split at level 1 is spurious
        if this_level ~= 1 then
            next_level()
        end
    end
    emu.frameadvance()
end
