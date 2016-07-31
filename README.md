# bizhawk-speedrun-lua
A collection of scripts I use for speedrunning and routing games in Bizhawk

The scripts within are intended to be utilized with the Bizhawk emulator and will provide various tools and features that will be helpful for speedrunning and routing speedruns for retro games that can be emulated by Bizhawk.

Comments in the top of each script will explain what the script does. Explaining how to set up and use Lua scripts with Bizhawk is slightly beyond the scope of this readme, but you can find necessary information [here](http://tasvideos.org/LuaScripting.html). These scripts may work with other emulators with minimal/no modification, but only Bizhawk is supported.

What we have here in short form:
- *timer.lua:* A very simple low-precision timer that turns the emu frame count into human-readable times.
- *ffv-sfc-fjfmonitor.lua:* A script that monitors RAM for the RPGe 1.1 Final Fantasy V ROM and writes party levels, jobs, and abilities to a file
- *ffv-gba-fjfmonitor.lua:* A script that monitors RAM for the GBA Final Fantasy V Advance ROM and writes party levels, jobs, and abilities to a file
- *super-mario-land-autosplitter.lua:* A script that splits for you during Super Mario Land (GB) runs. Requires modifying Bizhawk's Lua
