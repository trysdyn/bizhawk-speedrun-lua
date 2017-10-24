-- Hachiemon autosplitter for LiveSplit
-- Trysdyn Black, 2017 https://github.com/trysdyn/bizhawk-speedrun-lua
-- Requires LiveSplit 1.7+

last_time = 0.0
total_time = 0.0

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
    -- Keep total_time equal to a sum of all IL times
    total_time = total_time + last_time

    -- Set in-game time to sum of ILs so each IL is accurate
    -- Then split and flush the handle so it's timed accurately
    pipe_handle:write(string.format("setgametime %f\r\n", total_time))
    pipe_handle:write("split\r\n")
    pipe_handle:flush()
end

local function get_time_str()
    minutes = memory.readbyte(0xb8)
    seconds = memory.readbyte(0xb9)
    centi = memory.readbyte(0xba) * 1.66666

    -- Writes a total to last_time, which is the last non-zero time
    -- Used for IL splitting
    this_time = (minutes * 60) + seconds + (centi / 100.0)

    -- Keep last_time up to date unless the clock is zeroed by a cutscene
    if this_time ~= 0 then
        last_time = this_time
    end

    -- 00:00.00 mimutes, seconds, centiseconds
    return string.format("%d - %02d:%02d.%02d", this_level + 1, minutes, seconds, centi)
end

memory.usememorydomain("IWRAM")
last_level = 0
pipe_handle = init_livesplit()

while true do
    this_level = memory.readbyte(0xac)
    if this_level ~= last_level then
        next_level()
        last_level = this_level
    end
    gui.text(0, 0, "IL: " .. get_time_str())
    emu.frameadvance()
end
