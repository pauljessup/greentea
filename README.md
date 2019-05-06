### Greentea: The Map Engine. Evolved
Are you a LÖVE programmer? Have you always wanted to add a map editor or level editor to your game, but ended up just using Tiled instead? Have you ever wanted to call the map editor or level editor inside of your game with a push of a button or a click of the mouse? Well, Greentea can do all of that and much, much, more. 

Greentea:
- Is Built from the ground up in Lua and LÖVE
- Has complete Object Oriented Architecture, based around a format you already know (each object has an object and draw function, for starters)
- Has a Plugin based architecture to make it easy to extend and share these plugins with the community
- Everything is extendable. Maps, Layers, Objects, the Toolbars, the Mapeditor, the tools in the mapeditor. Everything.
- Can be called with a few simple commands
- Has a map editor that can be called inside of your game.
- Has it's own file format, but also has a file format plugin architecture, for future support of other map editor files.
- Leaves no footprint on your game when it uses it's own fonts or mouse icons.
- Has it's own object classes for dropping in game objects on the map and representing them in Lua and LÖVE. These can be used to a very powerful affect, or discarded entirely.

What Greentea is not:
Greentea is not a stand alone map editor. There may be one added in the future, but right now it's mostly meant to be scripted to work. The scripting is very simple. You can take a look at the demo code:
<a href="https://dl.dropboxusercontent.com/u/635941/greentea.love">https://dl.dropboxusercontent.com/u/635941/greentea.love</a>

It's fully commented.

### Greentea: The Library
The git hub is the folder for the main library. This can be placed within your project, and then loaded with a simple:
greantea=require("greentea")

Right now the mapengine uses TSerial for saving/loading maps and HUMP's Class system for allowing OOP in the way I think makes sense for the project. These files are included in the requisite directory, but I did not program either of these.

### A Basic Example
Here is a basic example for main.lua:

		--you need to require greentea, and it returns a greentea object.
		greentea=require("greentea")

		love.graphics.setDefaultImageFilter("nearest", "nearest")
		
		function love.load()
			greentea:set_file_directory("game/maps")
			greentea:set_scale(2, 2)
			greentea:load("test.gtmap")
		end
		
		function love.update(dt)
			--always need this--
			greentea:update(dt)
		end
		
		function love.draw()
			greentea:draw()
		end



