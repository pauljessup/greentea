local dir=...
Class=require(dir .. ".class")
require(dir .. ".map")
return love.filesystem.load(dir .. "/greentea.lua")(dir)