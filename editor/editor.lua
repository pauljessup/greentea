gt_editor=Class{}

function gt_editor:init(sys)
	self.plugin_directory=sys.plugin_directory .. "/editor"
	self.asset_directory=self.plugin_directory .. "/assets"
	if(love.filesystem.exists(self.asset_directory .. "/logo.png")) then 
		self.logo={}
		self.logo.image=love.graphics.newImage(self.asset_directory .. "/logo.png")
		self.logo.fade=false
		self.logo.fade_in=true
		self.logo.fade_value=0
		self.logo.hold_value=0
	end
	if(love.filesystem.exists(self.asset_directory .. "/mouse.png")) then
		self.cursor = love.graphics.newImage(self.asset_directory .. "/mouse.png")
		self.show_mouse=love.mouse.isVisible()
		self.edit_show_mouse=false
		love.mouse.setVisible(false)
	end
	if(love.filesystem.exists(self.asset_directory .. "/font.png")) then
		--default font.
		 self.font={}
		 self.font.old=love.graphics.getFont()
		 self.font.glyphs=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'abcdefghijklmnopqrstuvwxyz{}"	
		 self.font.image = love.graphics.newImage(self.asset_directory .. "/font.png")
		 self.font.image:setFilter("nearest", "nearest")
		 self.font.font=love.graphics.newImageFont(self.font.image, self.font.glyphs)
	end	
	
	self.sys=sys
	self.tools={}
	self.focus=gt_focus()	
	self.window_color={r=0, g=0, b=0}
	self.frame_color={r=200, g=200, b=200}
	--load the toolbars from the plugins--
	--this is going to have to change.--
	--[[
	local files = love.filesystem.getDirectoryItems(self.plugin_directory .. "/tools/")
	local id=0
	for num, name in pairs(files) do
		if(love.filesystem.isFile(self.plugin_directory .. "/tools/" .. name)) then
			id=id+1
			local cls=love.filesystem.load(self.plugin_directory .. "/tools/" .. name)()
			if(cls~=nil) then 
				table.insert(self.tools, cls(self, 100, 100, id))
				if(name=="tile.lua") then self.focus:gain(id) end --default is the tile tool. 
			end
		end
	end
	--]]
	self.tile_tools=gt_toolbar("tiletools", "slideleft", 5, 30, "vertical", 4, self)
end

function gt_editor:run()
		love.mouse.setVisible(self.edit_show_mouse)
		self.logo.fade=true 
		self.logo.fade_in=true 
		self.tile_tools:open()
		if(self.font~=nil) then love.graphics.setFont(self.font.font) end
end

function gt_editor:close()
		love.mouse.setVisible(self.show_mouse)
		self.logo.fade=false 
		self.logo.fade_in=false 
		self.tile_tools:close()
		if(self.font~=nil) then love.graphics.setFont(self.font.old) end
end

function gt_editor:update(dt, sys)
	self.sys=sys
	local mouse=self:check_mouse()
	
	if(not self:update_tools(mouse)) then
		local focus=self.focus:get()
		if(focus) then
			if(mouse.pressed~=nil) then self=self.tools[focus]:map_pressed(self) end
			self=self.tools[focus]:map_hover(self)
		end
	end
	self.tile_tools:update(dt, self)
	return self.sys
end

function gt_editor:draw()
	self.tile_tools:draw(self)
	if(self.cursor~=nil) then
		local mouse=self:check_mouse()
		love.graphics.draw(self.cursor, mouse.x, mouse.y)
	end	
	if(self.logo.fade) then
		if(self.logo.fade_in) then 
			self.logo.fade_value=self.logo.fade_value+25
			if(self.logo.fade_value>255) then
				self.logo.fade_in=false
				self.logo.fade_value=255
				self.logo.hold_value=20
			end
		else
			if(self.logo.hold_value==0) then
					self.logo.fade_value=self.logo.fade_value-25
					if(self.logo.fade_value<0) then
						self.logo.fade_in=true
						self.logo.fade=false
						self.logo.fade_value=0
					end
			else
				self.logo.hold_value=self.logo.hold_value-1
			end
		end
		love.graphics.setColor(255, 255, 255, self.logo.fade_value)
		center=self:get_center_screen()
		center.x, center.y=center.x-(self.logo.image:getWidth()/2), center.y-self.logo.image:getHeight()
		love.graphics.draw(self.logo.image, center.x, center.y)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function gt_editor:get_center_screen()
	return {x=(love.window.getWidth()/self.sys.scale.x)/2, y=(love.window.getHeight()/self.sys.scale.y)/2}
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

function gt_editor:map_mouse(layer)
		local mouse={}
		mouse.x, mouse.y=love.mouse.getPosition()
		
		-- make cords relative to scale--
		mouse.x, mouse.y=math.floor(mouse.x/self.sys.scale.x), math.floor(mouse.y/self.sys.scale.y)
		
		mouse.map=self.sys.map:screen_to_map(layer, mouse.x, mouse.y)
		mouse.hover=self.sys.map:map_to_screen(layer, mouse.map.x, mouse.map.y)

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
				if(mouse.pressed~=nil) then self=v:mouse_pressed(self) end
				self=v:mouse_hover(self)
				has_focus=true
			end
			self=v:update(dt, self)
	end
	return has_focus
end