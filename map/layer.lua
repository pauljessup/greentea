gt_layer=Class{}

function gt_layer:init(layer_table)
	self.id=layer_table.id
	self.type=layer_table.type
	self.values=layer_table.values
	local camera=gt_camera(layer_table.camera)
	if(layer_table.speed~=nil) then camera.speed=layer_table.speed end
	self.camera=camera
	self.height=layer_table.height
	self.width=layer_table.width
	self.tileset=layer_table.tileset
	self.anims=layer_table.anims
	self.hidden=layer_table.hidden
	self.opacity=layer_table.opacity
	self.map={}
	if(layer_table.map==nil) then
			--starter map. all 0's
			local mx, my=0,0
			while my<self.height do
					self.map[my]={}
					while mx<self.width do
						self.map[my][mx]=layer_table.default_tile
						mx=mx+1
					end
					mx=0
					my=my+1
			end
	else
		self.map=layer_table.map
	end
end

function gt_layer:save_table()
	local l={}
	l.values=self.values
	l.id=self.id
	l.type=self.type
	l.height=self.height
	l.width=self.width
	l.opacity=self.opacity
	l.tileset=self.tileset:save_table()
	l.map=self.map
	return l
end

function gt_layer:set_value(value, set)
	self.values[value]=set
end

function gt_layer:get_value(value)
	return self.values[value]
end

function gt_layer:do_flood_fill(value, x, y, tochange, ox, oy)
			if(ox==nil) then ox=x end if(oy==nil) then oy=y end
			if(x<1) then return end if(y<1) then return end
			--if(x>=self.width-2) then return end
			--if(y>=self.height-2) then return end
			if(x>ox+50) then return end
			if(y>ox+50) then return end
			if(x>=self.width) then return end
			if(y>=self.height) then return end			
			
			if self:get_tile(x,y) == value then return  end
			if self:get_tile(x,y) ~= tochange then return end
			
			self:set_tile(value, x, y)
			self:do_flood_fill(value, x-1,y,tochange, ox, oy)
			self:do_flood_fill(value, x+1,y,tochange, ox, oy)
			self:do_flood_fill(value, x,y+1,tochange, ox, oy)			
			self:do_flood_fill(value, x,y-1,tochange, ox, oy)
end

function gt_layer:flood_fill(value, x, y)
	tochange = self:get_tile(x,y) 
	self:do_flood_fill(value, x, y, tochange)
end

function gt_layer:set_all(original_tile, new_tile)
	local mx, my=0,0
	while my<height do
			while mx<width do
				if(self:get_tile(mx, my)==original_tile) then self:set_tile(new_tile) end
				mx=mx+1
			end
			mx=0
			my=my+1
	end	
end

function gt_layer:set_tile(tile_number, x, y)
	self.map[y][x]=tile_number
end


function gt_layer:get_tile(x, y)
	if(self.map[y]~=nil) then  return self.tileset:get(self.map[y][x]) else return 0 end
	if(self.map[y][x]~=nil) then  return self.tileset:get(self.map[y][x]) else return 0 end
end

function gt_layer:change_tile_values(id, opacity, values)
	self.tileset:set(id, opacity, values)
end

function gt_layer:scroll(x, y)
	self.camera:scroll(x, y)
	self:check_edges()
end

function gt_layer:move(x, y)
	self.camera:move(x, y)
	self:check_edges()
end

function gt_layer:get_camera()
	return self.camera
end

function gt_layer:set_camera(camera)
	self.camera=camera
end


function gt_layer:update(dt)
	self.tileset:update(dt)
	self.camera:update(dt)
end

function gt_layer:hide()
	self.hidden=true
end

function gt_layer:show()
	self.hidden=false
end

function gt_layer:is_hidden()
	return self.hidden
end

function gt_layer:check_edges()
	local edge_bot=self.tileset.tile_height
	local edge_top=(self.height*self.tileset.tile_height)-self.camera.height
	local edge_left=self.tileset.tile_width
	local edge_right=(self.width*self.tileset.tile_width)-self.camera.width
	if(self.camera.x<=edge_left) then self.camera.x=edge_left 
	elseif(self.camera.x>=edge_right) then self.camera.x=edge_right
	elseif(self.camera.y<=edge_bot) then self.camera.y=edge_bot
	elseif(self.camera.y>=edge_top) then self.camera.y=edge_top end
end

function gt_layer:draw()
		if(not self.hidden) then
			local c_width, c_height=math.floor(self.camera.width/self.tileset.tile_width), math.floor(self.camera.height/self.tileset.tile_height)
			local x, y=math.floor(self.camera.x/self.tileset.tile_width), math.floor(self.camera.y/self.tileset.tile_height)
			local ox, oy, ex, ey=x, y, (x+c_width)+4, (y+c_height)+4
			local offsetx, offsety=self.camera.x%self.tileset.tile_width, self.camera.y%self.tileset.tile_height			
			while(y<ey) do
				while(x<ex) do
					local tile=self:get_tile(x, y)
						self.tileset:draw(tile, ((x-ox)*self.tileset.tile_width)-offsetx, ((y-oy)*self.tileset.tile_height)-offsety, self.opacity)
					x=x+1
				end
				x=ox
				y=y+1
			end	
		end
end
