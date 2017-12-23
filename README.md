# bizhawk-speedrun-lua
A collection of scripts I use for speedrunning and routing games in Bizhawk

The scripts within are intended to be utilized with the Bizhawk emulator and will provide various tools and features that will be helpful for speedrunning and routing speedruns for retro games that can be emulated by Bizhawk.

Comments in the top of each script will explain what the script does. Explaining how to set up and use Lua scripts with Bizhawk is slightly beyond the scope of this readme, but you can find necessary information [here](http://tasvideos.org/LuaScripting.html). These scripts may work with other emulators with minimal/no modification, but only Bizhawk is supported.

What we have here in short form:
- **timer.lua:** A very simple low-precision timer that turns the emu frame count into human-readable times.
- **ffv-sfc-fjfmonitor.lua:** A script that monitors RAM for the RPGe 1.1 Final Fantasy V ROM and writes party levels, jobs, and abilities to a file
- **ffv-gba-fjfmonitor.lua:** A script that monitors RAM for the GBA Final Fantasy V Advance ROM and writes party levels, jobs, and abilities to a file
- **cool-spot-autosplitter.lua:** A script that splits for you during SNES Cool Spot runs, though you have to do the final split yourself currently
- **hachiemon-autosplitter.lua:** A script that splits for you during Hachiemon runs, though you have to do the final split yourself currently
- **hopapbout-autosplitter.lua:** A script that splits for you during Monster Rancher Hop-A-Bout runs though you have to do the starting and final splits yourself currently
- **super-mario-land-autosplitter.lua:** A script that splits for you during Super Mario Land (GB) runs
- **neugier-info.lua:** Small info display script for Neugier (SNES)

## Autosplitters, Bizhawk, and LiveSplit
My autosplitters used to use LuaSocket and LiveSplit Server. Current versions no longer require this but do require LiveSplit version 1.7. If these scripts refuse to talk to LiveSplit, please make sure your version is up to date.

Most of my autosplitters have some missing feature I need to add in the future like the final split (which is usually different logic than other splits). They work for me, though, and I probably won't bother unless someone really really wants me to.

It is recommended that you reset with "Reboot Core" in Bizhawk to make sure these autosplitters reset their state properly between attempts, but they have all been tested to work with Soft Reset as well; just make sure you're careful not to save a set of splits the autosplitter has interfered with in a way you don't want.
