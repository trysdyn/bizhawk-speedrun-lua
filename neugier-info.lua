-- Neugier info viewer
-- by Trysdyn Black, 2017

-- Displays health, revive, and experience information possibly useful for
-- routing Neugier. Regardless, seeing your own and enemy HP and EXP is a
-- small quality of life improvement. :)


local function write_hp()
    -- Enemy HP and max HP
    local e_hp = mainmemory.readbyte(0x106)
    local e_max_hp = mainmemory.readbyte(0x107)
    
    -- Player HP and max HP
    local p_hp = mainmemory.readbyte(0x6A)
    local p_max_hp = mainmemory.readbyte(0x6B)

    -- Bitflags representing player status
    -- 7 = Throw Chain
    -- 6 = Green Potion (revive on death)
    -- 0 = Debug invincibility?
    local revive = bit.check(mainmemory.readbyte(0x88), 6)    

    -- Format player and enemy HP as cur/max
    local e_hp_str = string.format("%i/%i", e_hp, e_max_hp)
    local p_hp_str = string.format("%i/%i", p_hp, p_max_hp)

    -- Add a "+" to the end of player HP if we have a revive
    if revive then
        p_hp_str = p_hp_str .. "+"
    end

    -- Draw player and enemy HP over health bars on screen
    -- We use gui.drawText instead of gui.text because drawText x,y is based
    -- on game canvas instead of emulator window. This means the x,y coords
    -- will be on the health bars regardless of Bizhawk window size.
    if e_hp ~= 0 then
        gui.drawText(32, 64, e_hp_str, "white", "transparent", 12, null, "bold")
    end

    if p_hp ~= 0 then
        gui.drawText(32, 32, p_hp_str, "white", "transparent", 12, null, "bold")
    end    
end

local function write_experience()
    -- Experience values for Jump and Standing attacks, out of 256
    local jax = mainmemory.readbyte(0x68)
    local sax = mainmemory.readbyte(0x66)

    -- Draw these to the right of the Jump and Standing attack levels
    gui.drawText(480, 16, jax, "white", "transparent", 14, null, "bold")
    gui.drawText(480, 32, sax, "white", "transparent", 14, null, "bold")
end

while true do
    write_hp()
    write_experience()
    emu.frameadvance()
end
