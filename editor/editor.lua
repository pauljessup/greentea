gt_editor=Class{}

function gt_editor:init(sys)
	self.plugin_directory=sys.plugin_directory .. "/editor"
	self.asset_directory=sys.plugin_directory .. "/assets"
	self.sys=sys
	self.tools={}
	self.focus=gt_focus()	
	--load the toolbars from the plugins--
	local files = love.filesystem.getDirectoryItems(self.plugin_directory .. "/tools/")
	local id=0
	for num, name in pairs(files) do
		if(love.filesystem.isFile(self.plugin_directory .. "/tools/" .. name)) then
			id=id+1
			local cls=love.filesystem.load(self.plugin_directory .. "/tools/" .. name)()
			if(cls~=nil) then 
				table.insert(self.tools, cls(self, id))
				if(name=="tile.lua") then self.focus:gain(id) end --default is the tile tool. 
			end
		end
	end
end

function gt_editor:update(dt, sys)
	self.sys=sys
	local mouse=self:check_mouse()
	
	if(not self:update_tools(mouse)) then
		local focus=self.focus:get()
		if(focus) then
			if(mouse.pressed~=nil) then self=self.tools[focus]:map_pressed(self, self:map_mouse()) end
			self=self.tools[focus]:map_hover(self, self:map_mouse())
		end
	end
	
	return self.sys
end

function gt_editor:draw()
	for i,v in ipairs(self.tools) do
		v:draw(self)
	end
end

function gt_editor:check_mouse()
		local mouse={}
		mouse.x, mouse.y=love.mouse.getPosition()
		-- make cords relative to scale--
		mouse.x, mouse.y=mouse.x/self.sys.scale.x, mouse.y/self.sys.scale.y
		if(mouse.x<0) then mouse.x=1 end
		if(mouse.y<0) then mouse.y=1 end
		mouse.width, mouse.height=self.sys.map.tileset.tile_width*self.sys.scale.x, self.sys.map.tileset.tile_height*self.sys.scale.y
		if(love.mouse.isDown("r")) then mouse.pressed="r" end
		if(love.mouse.isDown("l")) then	mouse.pressed="l" end	
		return mouse
end

function gt_editor:map_mouse()
		local mouse={}
		mouse.x, mouse.y=love.mouse.getPosition()
		-- make cords relative to scale--
		mouse.x, mouse.y=mouse.x/self.sys.scale.x, mouse.y/self.sys.scale.y
		
		--make coords relative to tile--
		mouse.mapx=mouse.x+self.sys.map.camera.x
		mouse.mapy=mouse.y+self.sys.map.camera.y
		
		mouse.mapx, mouse.mapy=math.floor(mouse.mapx/self.sys.map.tileset.tile_width), math.floor(mouse.mapy/self.sys.map.tileset.tile_height)
		mouse.x, mouse.y=(mouse.mapx*self.sys.map.tileset.tile_width)-self.sys.map.camera.x, (mouse.mapy*self.sys.map.tileset.tile_height)-self.sys.map.camera.y
		
		if(mouse.x<0) then mouse.x=1 end
		if(mouse.y<0) then mouse.y=1 end
		mouse.width, mouse.height=self.sys.map.tileset.tile_width, self.sys.map.tileset.tile_height
		if(love.mouse.isDown("r")) then mouse.pressed="r" end
		if(love.mouse.isDown("l")) then	mouse.pressed="l" end	
		return mouse
end

function gt_editor:check_hover(mouse, widget)
 return mouse.x < widget.x+widget.width and
         widget.x < mouse.x+mouse.width and
         mouse.y < widget.y+widget.height and
         widget.y < mouse.y+mouse.height	
end

function gt_editor:update_tools()
	local has_focus=false
	for i,v in ipairs(self.tools) do
			local mouse=self:check_mouse()
			if(self:check_hover(mouse, v)) then 
				if(mouse.pressed~=nil) then self=v:mouse_pressed(self, mouse.pressed) end
				self=self:mouse_hover(self)
				has_focus=true
			end
			self=v:update(dt, self, mouse)
	end
	return has_focus
end