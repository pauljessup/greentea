local dir=...
Class=require(dir .. ".class")
require(dir .. ".map")
require(dir .. ".editor")
return love.filesystem.load(dir .. "/greentea.lua")(dir)