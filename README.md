# bizhawk-speedrun-lua
A collection of scripts I use for speedrunning and routing games in Bizhawk

The scripts within are intended to be utilized with the Bizhawk emulator and will provide various tools and features that will be helpful for speedrunning and routing speedruns for retro games that can be emulated by Bizhawk.

Comments in the top of each script will explain what the script does. Explaining how to set up and use Lua scripts with Bizhawk is slightly beyond the scope of this readme, but you can find necessary information [here](http://tasvideos.org/LuaScripting.html). These scripts may work with other emulators with minimal/no modification, but only Bizhawk is supported.

What we have here in short form:
- **timer.lua:** A very simple low-precision timer that turns the emu frame count into human-readable times.
- **ffv-sfc-fjfmonitor.lua:** A script that monitors RAM for the RPGe 1.1 Final Fantasy V ROM and writes party levels, jobs, and abilities to a file
- **ffv-gba-fjfmonitor.lua:** A script that monitors RAM for the GBA Final Fantasy V Advance ROM and writes party levels, jobs, and abilities to a file
- **super-mario-land-autosplitter.lua:** A script that splits for you during Super Mario Land (GB) runs. Requires modifying Bizhawk's Lua

## A Note on Bizhawk's Lua and some scripts
Some of my scripts note requiring LuaSocket, or another Lua lib. Unfortunately installing support for this is non-trivial because of the way Bizhawk packages Lua. If you're looking for help on this I'll point you to [this StackOverflow response](http://stackoverflow.com/questions/33428382/add-luasocket-to-program-bizhawk-shipped-with-own-lua-environment/33472332#33472332) to get you started.

In short, you need to grab the LuaSockets windows distributable ZIP and extract it in the way that post lays out.

It is worth noting: This will fundamentally change the way Bizhawk handles Lua and may cause crashes. It's been fine for me but YMMV. Don't come running to me if you blow up Bizhawk doing this :)
