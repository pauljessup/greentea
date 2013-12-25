gt_tileset=Class{}

function gt_tileset:init(tileset_table)
	self.id=tileset_tableid
	self.type=tileset_table.type
	self.tile_height=tileset_table.tile_height
	self.tile_width=tileset_table.tile_width
	self.anims=tileset_table.anims
--------------------------------------------
	if(tileset_table.tiles==nil) then self.tiles={} else self.tiles=tileset_table.tiles end
	self.quads={}
	self.image_name=tileset_table.image
	self.image=love.graphics.newImage(tileset_table.image)
	local spx, spy=0,0
	local id=0
	--create the quads--
	while spy<self.image:getHeight() do
			while not (spx>self.image:getWidth()) do
				id=id+1
				table.insert(self.quads, love.graphics.newQuad(
											spx, spy, self.tile_width, self.tile_height, 
											self.image:getWidth(), self.image:getHeight()))
				table.insert(self.tiles, gt_tile({id=id, opacity=255, values={}}))
				spx=spx+self.tile_width
			end
			spx=0
			spy=spy+self.tile_height
	end
end

-- Example Anims table:
-- an array of tables, each array is indexed by the primary tilenumber.
-- so, anims[100]= that would be for tile 100.
-- anims.frames= tile frames. The int number for the frame ID. Also an array. like: {100, 1, 12, 133}
-- anims.speed = speed in drawing the frames
function gt_tileset:set_animation(starting_tile_number, anims)
	self.anims[starting_tile_number]=anims
end

function gt_tileset:select_grid(x, y)
	local x,y=x-(self.image:getWidth()/2), y+(self.tile_height)
	local width=self.image:getWidth()
	local imagex=0
	local ox=x
	local grid_select={}
	for i,v in ipairs(self.tiles) do		
		x=imagex+ox
		self:draw(i, x, y, 255)
		
		table.insert(grid_select, {x=x,y=y,i,height=self.tile_height,width=self.tile_width})
		if(imagex==width) then 
			imagex=0
			y=y+self.tile_height
		else 
			imagex=imagex+self.tile_width 
		end
	end
	return grid_select
end

function gt_tileset:select_grid_layout(x, y)

	local x,y=x-(self.image:getWidth()/2), y+(self.tile_height)
	local width=self.image:getWidth()
	local imagex=0
	local ox=x
	local grid_select={}
	grid_select.x=x
	grid_select.y=y
	grid_select.hover_check={}
	grid_select.tile_map={}
	local mapx, mapy=1,1
	grid_select.tile_map[mapy]={}
	
	for i,v in ipairs(self.tiles) do		
		x=imagex+ox
		table.insert(grid_select.hover_check, {x=x,y=y,id=i, height=self.tile_height, width=self.tile_width})
		grid_select.tile_map[mapy][mapx]=i
		
		if(imagex==width) then 
			imagex=0
			y=y+self.tile_height
			mapy=mapy+1
			mapx=0
			grid_select.tile_map[mapy]={}
		else 
			imagex=imagex+self.tile_width
			mapx=mapx+1
		end
	end
	return grid_select
end


function gt_tileset:save_table()
	local l={}
	l.id=self.id
	l.type=self.type
	l.image=self.image_name
	l.tile_height=self.tile_height
	l.tile_width=self.tile_width
	l.anims=self.anims
	l.tiles={}
	for i, v in ipairs(self.tiles) do
		l.tiles=v:save_table()
	end
	return l
end

function gt_tileset:draw(id, x, y, opacity)
	id=self:get_anim_frame(id)
	self.tiles[id]:draw(self, x, y, opacity)
end

function gt_tileset:get(id)
	id=self:get_anim_frame(id)
	return id
end

function gt_tileset:set(id, opacity, values)
	self.tiles[id].opacity=opacity
	self.tiles[id].values=values
end

function gt_tileset:set_value(id, value, set)
	self.tiles[id]:set_value(vale, set)
end

function gt_tileset:get_value(id, value)
	return self.tiles[id]:get_value(value)
end

function gt_tileset:set_image(image)
	self.image=image
end

function gt_tileset:get_image(image)
	return self.image
end

function gt_tileset:get_anim_frame(tilenumber)
	if(self.anims~=nil) then
			if(self.anims[tilenumber]~=nil) then
				local anims=self.anims[tilenumber]
				return anims.frames[anims.current]
			end
	end
	return tilenumber
end

function gt_tileset:update(dt)
	if(self.anims~=nil) then
			for i, v in pairs(self.anims) do
					if(v.speed~=nil) then
						if(v.counter>v.speed) then
							local last_tile=v.current
							v.counter=0
							v.current=v.current+(1*dt)
							if(v.current==#v.frames) then v.current=i end
						else
							v.counter=v.counter+1
						end
					end
			end
	end
end