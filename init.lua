--loading in the library. using ... to get the relative directory path.
local dir=...
--using HUMP's class.lua
Class=require(dir .. ".class")
--This is the map system.
--This is the greentea system.
return love.filesystem.load(dir .. "/greentea.lua")(dir)