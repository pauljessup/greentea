--[[ This is the main class, that pulls in everything from the map to the editor --]]
--[[ If desired, you can actually inherit from this class using include(green_tea and --]]
--[[ over-ride what you want. --]]
local dir=...
require(dir .. ".map")
local green_tea=Class{}

function green_tea:init(dir)
	self.editing=false
	self.has_editor=false
	self.has_map=false -- whether or not a map is loaded.
	self.lib_directory=dir
	self.plugin_directory=dir .. "/plugins"
	self.file_dir=dir .. "/assets"
	self:set_scale(1, 1)
end

function green_tea:get_tile(layer, x, y)
	return self.map:get_tile(layer, x, y)
end

function green_tea:set_tile(tile, layer, x, y)
	self.map:set_tile(tile, layer, x, y)
end

function green_tea:set_file_directory(dir)
	self.file_dir=dir
end

function green_tea:update(dt)
	if(self.has_editor) and (self.editing) then
		self=self.editor:update(dt, self)
	else
		self.map:update(dt)
	end
end

function green_tea:load(filename)
	local fsys=gt_filesys(self.plugin_directory)
	self:load_map(fsys:load(self.file_dir .. "/" .. filename))	

	if(self.has_editor) then
		if(editor~=nil) and (love.filesystem.exists(self.plugin_directory .. "/editors/" .. editor .. ".lua")) then
				local editor_class=love.filesystem.load(self.plugin_directory .. "/editors/" .. editor .. ".lua")()
				self.editor=editor_class(self)
		else
				self.editor=gt_editor(self)
		end
	end
end

function green_tea:save(filename)
	local fsys=gt_filesys(self.plugin_directory)
	fsys:save(self.map, self.file_dir .. "/" .. filename)
end

function green_tea:using_editor(editor)
	self.has_editor=true
	require(self.lib_directory .. ".editor")
end

function green_tea:run_editor()
	if(self.has_editor) then
		self.editing=true
	end
end

function green_tea:stop_editor()
	if(self.has_editor) then
		self.editing=false
	end
end

function green_tea:toggle_editor()
	if(self.has_editor) then
		self.editing=not self.editing
	end
end

function green_tea:set_scale(x, y)
	self.scale={x=x, y=y}
end

function green_tea:draw()
	if(self.scale~=nil) then love.graphics.scale(self.scale.x, self.scale.y) end
	self.map:draw()
	if(self.scale~=nil) then love.graphics.scale(1, 1) end
	if(self.has_editor) and (self.editing) then
		self.editor:draw()
	end
	if(self.scale~=nil) then love.graphics.scale(1, 1) end
end

function green_tea:new_map(map)
	self:load_map(map)
end

function green_tea:load_camera(camera)
			if(camera.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/cameras/" .. camera.type .. ".lua")) then
				local camera_class=love.filesystem.load(self.plugin_directory .. "/cameras/" .. camera.type .. ".lua")()
				return camera_class(camera)
			else
				return gt_camera(camera)
			end	
end

function green_tea:load_layer(layer)
			if(layer.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/layers/" .. layer.type .. ".lua")) then
				local layer_class=love.filesystem.load(self.plugin_directory .. "/layers/" .. layer.type .. ".lua")()
				return layer_class(layer)
			else
				return gt_layer(layer)
			end
end

function green_tea:load_tileset(tileset)
			if(tileset.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/tilesets/" .. tileset.type .. ".lua")) then
				local tileset_class=love.filesystem.load(self.plugin_directory .. "/tilesets/" .. tileset.type .. ".lua")()
				return tileset_class(tileset)
			else
				return gt_tileset(tileset)
			end	
end

function green_tea:load_objects(objects)
	if(objects~=nil) then
		for i, v in ipairs(objects) do
			self:add_object(v)
		end
	end
end

function green_tea:load_layers(layers)
		if(layers~=nil) then
			for i, v in ipairs(layers) do
				self:add_layer(v)
			end
		end
end

function green_tea:load_map(map)
			map.plugin_directory=self.plugin_directory
			map.camera=self:load_camera(map.camera)
			map.tileset=self:load_tileset(map.tileset)
			
			local layers, objects=map.layers, map.objects
			if(map.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/maps/" .. map.type .. ".lua")) then
				local map_class=love.filesystem.load(self.plugin_directory .. "/maps/" .. map.type .. ".lua")()
				self.map=map_class(map)
				self:load_layers(layers)
				self:load_objects(objects)
			else
				self.map=gt_map(map)
				self:load_layers(layers)
				self:load_objects(objects)				
			end	
end

function green_tea:move(x, y)
	self.map:move(x, y)
end

function green_tea:scroll(x, y)
	self.map:scroll(x, y)
end

function green_tea:add_layer(layer)
	if(layer.default_tile==nil) then layer.default_tile=1 end
	if(layer.camera==nil) then 
		layer.camera=self.map.camera 
	else
		layer.camera=self:load_camera(layer.camera)
	end
	if(layer.tileset==nil) then 
		layer.tileset=self.map.tileset
	else
		layer.tileset=self:load_tileset(layer.tileset)
	end
	if(layer.hidden==nil) then layer.hidden=false end
	
	layer.width=self.map.width
	layer.height=self.map.height
	self.map:add_layer(layer)
end

function green_tea:add_object(object) 
	if(object.hidden~=nil) then object.hidden=false end
	self.map:add_object(object)
end

function green_tea:get_layers()
	self.map:get_layers()
end

function green_tea:set_layers(layers)
	self.map:set_layers(layers)
end

function green_tea:get_map()
	return self.map
end

function green_tea:set_map(map)
	self.map=map
end

function green_tea:get_objects()
	return self.map:get_objects()
end

function green_tea:set_objects(objects)
	self.map:set_objects(objects)
end

return green_tea(dir)