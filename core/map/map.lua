gt_map=Class{}

function gt_map:using_editor(use, editor)
	self.editor=use
end

function gt_map:undo(touse)
	if(touse~=nil) then
		if(touse.tile~=nil) then
			self.layers[touse.layer].map[touse.y][touse.x]=touse.tile
		elseif(touse.object~=nil) then
			table.remove(self.objects)
		end
	end
end

function gt_map:get_layer_cameras()
	local layers={}
	for i,v in self:get_layers() do
		layers[i]={x=v.camera.x, y=v.camera.y}
	end
	return layers
end

function gt_map:set_layer_cameras(layers)
	for i, v in ipairs(layers) do
		self.layers[i]:move(v.x, v.y)
	end
end

function gt_map:set_tile(tilenumber, layer, x, y) -- map positions.
	self.layers[layer]:set_tile(tilenumber, x, y)
end

function gt_map:flood_fill(tilenumber, layer, x, y) -- map positions.
	local layer=self:get_layer(layer)
	layer:flood_fill(tilenumber, x, y)
end

function gt_map:copy_layer(layerid, newid)
	local layer=self:get_layer(layerid)
	local newlayer=self:get_layer(newid)
	if(newlayer==nil) then			
			self:add_layer({
								id=newid, 
								opacity=layer.opacity, 
								speed=layer.speed,
								camera=layer.camera,
								default_tile=0,
								tileset=layer.tileset,
								width=layer.width,
								height=layer.height,
								})
			newlayer=self.layers[#self.layers]
	end
	
	local x, y=1,1
	while y<=self.height do
		while x<=self.width do
			newlayer:set_tile(layer:get_tile(x, y), x, y)
			x=x+1
		end
		x=1
		y=y+1
	end
end

function gt_map:get_tile(layer, x, y) -- map positions.
	return self.layers[layer]:get_tile(x, y)
end

function gt_map:screen_to_map(layer, x, y) --convert screen pixel cords to map cords. Good for placing tiles
	local o=self:screen_to_pixel(layer, x, y)
	return self:pixel_to_map(o.x, o.y)	
end

function gt_map:pixel_to_map(x, y) --convert world pixel cords to world map coords
	return {x=math.floor(x/self.tileset.tile_width), y=math.floor(y/self.tileset.tile_height)}
end

function gt_map:map_to_screen(layer, x, y) --convert map (tile x, y) cords to screen cords.
	local camera=self.layers[layer].camera
	return {x=(x*self.tileset.tile_width)-camera.x, y=(y*self.tileset.tile_height)-camera.y}
end

function gt_map:screen_to_pixel(layer, x, y) -- Convert screen cord to offset map pixel coordination. Good for placing objects.
	local camera=self.layers[layer].camera
	x=x+camera.x
	y=y+camera.y
	return {x=x, y=y}
end


function gt_map:init(map_table)
	self.name=map_table.name
	self.camera=map_table.camera
	self.height=map_table.height
	self.width=map_table.width
	self.tileset=map_table.tileset
	self.plugin_directory=map_table.plugin_directory
	self.file_directory=map_table.file_directory
	self.lib_directory=map_table.lib_directory
	self.layers={}
	self.objects={}	
	self.old={}
	self.old.x=self.camera.x
	self.old.y=self.camera.y
	if(map_table.values==nil) then self.values={} else self.values=map_table.values end
end

function gt_map:save_table()
	local l={}
	l.name=self.name
	l.type=self.type
	l.x=self.x
	l.y=self.y
	l.camera=self.camera:save_table()
	l.tileset=self.tileset:save_table()	
	l.height=self.height
	l.width=self.width
	l.objects={}
	for i,v in ipairs(self.objects) do
		if(v:save_table()~=nil) then
			table.insert(l.objects, v:save_table())
		end
	end
	l.layers={}
	for i,v in ipairs(self.layers) do
		table.insert(l.layers, v:save_table())
	end	
	return l
end

function gt_map:set_value(value, set)
	self.values[value]=set
end

function gt_map:get_value(value, set)
	return self.values[value]
end

function gt_map:get_camera()
	return self.camera
end

function gt_map:set_camera(camera)
	self.camera=camera
end

function gt_map:get_layer(id)
	for i,v in self:get_layers() do
		if(v.id==id) then return v end
	end	
	return self.layers[id]
end


function gt_map:set_layer(id, layer)
	self.layers[id]=layer
end

function gt_map:move(x, y)
	self.camera:move(x, y)
	for i, v in self:get_layers() do
		v:move(x, y)
	end
end

function gt_map:displace()
	self:move(self.old.x, self.old.y)
end

function gt_map:scroll(x, y)
	self.old.x=self.camera.x
	self.old.y=self.camera.y
	self.camera:scroll(x, y)
	for i, v in self:get_layers() do
		v:scroll(x, y)
	end
end

function gt_map:add_layer(v)
			v.map_id=#self.layers+1
			if(v.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/layers/" .. v.type .. ".lua")) then
				local layer_class=love.filesystem.load(self.plugin_directory .. "/layers/" .. v.type .. ".lua")()
				table.insert(self.layers, layer_class(v, self))
			else
				table.insert(self.layers, gt_layer(v, self))			
			end
end

function gt_map:add_object(object)
			object.file_directory=self.file_directory
			object.plugin_directory=self.plugin_directory
			object.lib_directory=self.lib_directory
			if(object.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/objects/" .. object.type)) then
				local object_class=love.filesystem.load(self.plugin_directory .. "/objects/" .. object.type)()
				if(object.type~=nil) and (love.filesystem.exists(self.file_directory.objects .. "/" .. self.name ..  "/" .. object.id)) then
						local object_class_map=love.filesystem.load(self.file_directory.objects .. "/" .. self.name ..  "/" .. object.id)(object_class)
						table.insert(self.objects, object_class_map(object))
				else
					table.insert(self.objects, object_class(object))
				end
			else
				table.insert(self.objects, gt_object(object))			
			end	
end

function gt_map:raise_object(object)
	if(object.layer<#self.layers) then
		object.layer=object.layer+1
	end
end

function gt_map:lower_object(object)
	if(object.layer>1) then
		object.layer=object.layer-1
	end
end

function gt_map:raise_layer(layer)
	
end

function gt_map:lower_layer(layer)

end

function gt_map:get_objects()
	return ipairs(self.objects)
end

function gt_map:set_objects(objects)
	self.objects=objects
end

function gt_map:get_layers()
	return ipairs(self.layers)
end

function gt_map:get_object_table_id(id)
	for i,v in self:get_objects() do
		if(v.id==id) then return i end
	end
	return nil
end

function gt_map:get_object(id)
	local num=self:get_object_table_id(id)
	if(num~=nil) then return self.objects[num] end
	return nil
end

function gt_map:set_object(id, object)
	local num=self:get_object_table_id(id)	
	if(num~=nil) then self.objects[num]=object end
end

--checks to see if any objects collide with 
--supplied object. Object can be any table at all
--it just needs to have a height, width, x, y layer.
--if nothing hits, returns false.
--if something hits, returns true
--and then it returns the id of the collision hit
--so you can access it directly with map:get_object(i)
function gt_map:object_collide(object)
	for i, o in ipairs(self.objects) do
			if(o:check_collision(object)) then return i end
	end
	return false
end


function gt_map:tile_collide(object)
	for i,o in self:get_layers() do
		if(o.type=="collision") and (i>object.layer) then 
			if(o:get_tile_by_pixel(object.x, object.y)~=0) then return o:get_tile_by_pixel(object.x, object.y)  end
			if(o:get_tile_by_pixel(object.x+object.width, object.y+object.height)~=0) then return o:get_tile_by_pixel(object.x+object.width, object.y+object.height) end
			if(o:get_tile_by_pixel(object.x+object.width, object.y)~=0) then return o:get_tile_by_pixel(object.x+object.width, object.y) end
			if(o:get_tile_by_pixel(object.x, object.y+object.height)~=0)  then return o:get_tile_by_pixel(object.x, object.y+object.height) end
		end
	end
	return false
end

function gt_map:collide(object)
		if(self:tile_collide(object)) then return self:tile_collide(object) end
		if(self:object_collide(object)) then return self:object_collide(object) end
		return false
end
	
function gt_map:object_draw(layer)
	for i, o in ipairs(self.objects) do
		if(o.layer==layer) and (not o.hidden) then 
				o:draw(self:get_layer(layer))
		end 
	end
end

function gt_map:update(dt)
	local tmp_object={x=0, y=0}
	if(self.follow~=nil) then 
		tmp_object.x=self.objects[self.follow].x
		tmp_object.y=self.objects[self.follow].y		
	end
	
	for l, i in self:get_layers() do
		i:update(self, dt)
	end
	for l, i in self:get_objects() do
		self=i:update(self, dt)
	end
	if(not self.editor) then
		for l, i in self:get_objects() do
			obj=self:collide(i)
			if(obj) then i:collide(self, obj) end
		end		
	end	
	if(self.follow~=nil) then
		local use_object=self.objects[self.follow]
		self:scroll(use_object.x-tmp_object.x, use_object.y-tmp_object.y)
	end
end

function gt_map:draw()
	for l, i in self:get_layers() do
		i:draw(self.editor)
		self:object_draw(l)
	end
	if(self.editor) then
	for l, f in self:get_layers() do
			for i, o in ipairs(self.objects) do
				if(o.layer==l) then
					o:editor_name_draw(f)
				end
			end
		end
	end
end

function gt_map:follow_object(id)
	self.follow=self:get_object_table_id(id)
	self:move(self.objects[self.follow].x-self.camera.width, self.objects[self.follow].y-self.camera.height)
end