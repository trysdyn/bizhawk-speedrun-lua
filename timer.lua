i-- timer.lua
-- by Trysdyn Black

-- WARNING WARNING WARNING --
-- DO NOT USE THIS FOR TIMING REAL RUNS
-- IT IS NOT THAT ACCURATE :)

-- Super basic low-precision timing within a game
-- NumPad 0 = Reset timer
-- NumPad +/- = Show/hide timer

-- Timer will adjust when a save state is loaded, allowing you to 
-- "Go back in time" when TASing or practicing

-- In a nutshell all this does is turns the Bizhawk frame counter into a more
-- human-friendly time. It also assumes ~60fps so if you use a console or
-- ROM from a region that uses 50fps displays it'll be horribly wrong :D


--- bool Show the timer
show = true

--- int Which frame since emu reset the timer was started on
frames = 0


function frames_to_time(frames)
    --- Takes frames, calculates hh:mm:ss from that
    --- Then displays hh:mm:ss in the top-left of the screen
    hour = math.floor(frames / 216000)
    frames = math.fmod(frames, 216000)

    minute = math.floor(frames / 3600)
    frames = math.fmod(frames, 3600)

    second = math.floor(frames / 60)

    gui.text(0, 0, string.format("%02d:%02d:%02d",
                                     hour,minute,second),
                 "black", "yellow")
end

function track_clock()
    if input.get()["NumberPad0"] then
        frames = emu.framecount()
    end

    if input.get()["NumberPadPlus"] then
        show = true
    end

    if input.get()["NumberPadMinus"] then
        show = false
    end

    if show then
        frames_to_time(emu.framecount() - frames)
    end
end

while true do
    track_clock()
    emu.frameadvance()
end

