--[[
Namespacing:
All classes that are used have the gt_ prefix in front of it.
gt_widget=widgets
gt_tileset=tileset
gt_tile=tile
gt_map=map
gt_layer=layer
gt_camera=camera
etc, etc.

A quick note on the directory structure of the GreenTea map library.

The Core folder contains all the core routines/functions/tables/etc. It's probably best not
to edit these (as we say in the biz- NEVER HACK CORE!).  

The Plugins folder:
This folder (and sub folders) contain plugins that can be used
to extend the functionality of greentea. These are not core per se, though
the files in the editor directory (plugins/editor, etc) are pretty much core.

Sub folder of Plugins:
Editor: 
This contains folders that are basically the toolbars that appear. Each file inside of the folder is a diferent Widget, or tool. You can add to these by creating a file in
the folder, and in it extend from the gt_widget class. The assets directory are all the basic editor assets, including buttons and the mouse graphic.

Formats:
This will contain files for each file format that can be used. Each file has a class in it that extends the gt_file_format class

Layers:
This contains files that are layer types. To use this when creating a new layer, specify as it's type as the filename without the .lua ext. An example
is in this directory, the parallax plugin. This is a constantly scrolling layer, always moving a direction for X amount.

Objects:
In game/In Map objects. These inherit from the gt_object type. There is an example in here.

Templates:
These are map templates that can be used to structure your game map in a certain way, so that
they all use similar layers/etc.  This can be speed up game editing. You can have a lot of
different templates that can be very handy. Ones for caves, for overworld, etc.

There is an example template in the directory.

The basic layout for a plugin is:
a file, put inside of the directory you want to use it in.
A class object that is local to the file.
This class object must inherit from the object you wish to use the plugin for.
For example, a template plugin would:

local example_template=Class{}
example_template:include(gt_template)

This is how a HUMP class extends/inherits a base class.

Then, you can over-ride all the function you want to/need to. Any time you don't specify a function, it uses
the base class's function. This allows you to only specify what you want or need to change.

then, at the end of the file you need to return the local class you created (return example_template)


Anyone that has used Symfony 2 framework can see it's influence in the plugin framework.
--]]



--you need to require greentea, and it returns a greentea object.
--greentea is the name of the folder where the library is.
--But, it does use relative directories
--So you can rename it, or place it in a sub folder like libraries
--or something. Just make sure you "require" it using the right directory.
greentea=require("greentea")

--This is for the scaling. I like a retro look.
love.graphics.setDefaultFilter("nearest", "nearest")

--this is for the FPS capping. Hacky, hacky.
next_time=0

function love.load()
-- The green tea Example --  
	love.window.setMode(640, 480) 			 	-- set the resolution.
	
	greentea:set_file_directory({
								-- set the directory where our maps and objects will be stored.
								maps="game/maps",
								objects="game/objects"
								}) 	

	greentea:using_editor()					 	-- This is set if we're using the in game editor. If this is set to false, you can use the lite version of the library.
	greentea:editor_theme("ffclassic")			--found in greentea/plugins/themes as ffclassic.lua.
	greentea:set_scale(2, 2)				 	-- We're scaling by two for a retro look, daddy-o. This needs to be called for scaling the map...otherwise the mouse coords for
												-- the map editor won't work correctly.
	
	--if we wanted to  load a map-  
	greentea:load("test.gtmap")
	--where test.gtmap is the name of your map.

	--[[
	-- let's create a new map.
	-- This layout for new maps/etc was inspired by
	-- the Drupal 7 Form API. It's very easy to follow,
	-- and to cut and paste into your own code making the
	-- changes you need. You pass a table with the correct
	-- information and it knows what to do.

	--uncomment out the below to create a new map.
	--]]
	
	--[[
	greentea:new_map({	name="test",			--this is the name it will use to save the map.
						template="example", 	--this map is using a template. This template is in greentea/plugins/templates as example.lua. Look there for more information.
						height=200, width=200, 	--height and width of this map in tiles.
						tileset={			id="main", 					--this is our base tileset. Start off with the ID
											image="game/maps/ground.png", 	--the image we plan on using.
											tile_height=16, 				--our tile height
											tile_width=16,					--our tile width.			
											--another thing of note- the base tileset can be over-ridden per layer.
											--the example template, every single layer has it's own tileset
											--so the map one will probably not be used. It needs to be put in though
											--as  a failsafe to fall back on if a layer does not have a specified tileset.
								}
					})
	--]]

	greentea:move(100*16, 100*16)
	--and let's add a player object. This can be found in
	--greentea/plugins/objects/player.lua
	greentea:add_object({	id=0,
							type="player.lua",
							x=154+(100*16),
							y=120+(100*16),
							opacity=255,
							speed=1,
							layer=2
						})
						
	greentea:follow_object(0) --makes the map follow the character object
end

function love.update(dt)
		--this is just how I'm doing FPS capping
		--use whatever method you feel more appropriate.
		next_time = next_time + 1/30
	    cur_time = love.timer.getTime()

	   --This is called to update greentea.
	   --This must be in love.update for it to work.
		greentea:update(dt)
		if(greentea.editing) then	
					--this is to move the map by keyboard input
					--when in editing mode. Outside of editing mode,
					--the map follows the object we set up earlier.
				if(love.keyboard.isDown("up")) then greentea:scroll(0, -2) end
				if(love.keyboard.isDown("down")) then greentea:scroll(0, 2) end
				if(love.keyboard.isDown("left")) then greentea:scroll(-2, 0) end
				if(love.keyboard.isDown("right")) then greentea:scroll(2, 0) end
		elseif(love.keyboard.isDown("escape")) then
		--this let's us run the editor when we press escape.
			greentea:run_editor()
		end		
end

function love.draw()
		--more FPS capping.
	   if next_time <= cur_time then
		  next_time = cur_time
	   end
	   love.timer.sleep(next_time - cur_time)
	   ----------------------
	   
	--greentea.draw() needs to be in love.draw for this to work.
	greentea:draw()
	if(not greentea.editing) then love.graphics.print("Press escape to open level editor.", 10, 10) end
end