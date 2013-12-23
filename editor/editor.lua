gt_editor=Class{}

function gt_editor:init(sys)
	self.plugin_directory=sys.plugin_directory .. "/editor"
	self.asset_directory=self.plugin_directory .. "/assets"
	self.selected={}
	self.selected.tile=1
	self.selected.tiles={}
	self.selected.tiles.use=false
	self.selected.layer=2
	self.mouse={x=0, y=0, held=false, holding=0}
	
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

	self.toolset={}

	table.insert(self.toolset, gt_toolbar("tiletools", "slideleft", 5, 50, "vertical", 6, self))	
	table.insert(self.toolset, gt_transition("slidedown", -5, -5, (love.window.getWidth()/self.sys.scale.x)+50, 35,  self.window_color, self.frame_color, self))

	local x, y=self:calculate_location("right", 60, 0)
	table.insert(self.toolset, gt_toolbar("maptools", "slidedown", x, y, "horizontal", 6, self, {r=0, g=0, b=0, alpha=0}, {r=0, g=0, b=0, alpha=0}))
end

function gt_editor:calculate_location(location, x, y)
	if(location=="top") then y=5 end
	if(location=="bottom") then y=(love.window.getHeight()/self.scale.y)-y end
	if(location=="left") then x=5 end
	if(location=="right") then x=(love.window.getWidth()/self.sys.scale.x)-x end
	return x, y
end

function gt_editor:run()
		love.mouse.setVisible(self.edit_show_mouse)
		self.logo.fade=true 
		self.logo.fade_in=true 
		for i,v in ipairs(self.toolset) do v:open() end
		if(self.font~=nil) then love.graphics.setFont(self.font.font) end
end

function gt_editor:close()
		love.mouse.setVisible(self.show_mouse)
		self.logo.fade=false 
		self.logo.fade_in=false 
		for i,v in ipairs(self.toolset) do v:close() end
		if(self.font~=nil) then love.graphics.setFont(self.font.old) end
end

function gt_editor:update(dt, sys)
	self.sys=sys
	self:check_mouse()
	for i,v in ipairs(self.toolset) do v:update(dt, self) end

	if(not self:update_tools(self.mouse)) then
		local focus=self.focus:get()
		if(focus) then
			if(self.mouse.pressed~=nil) then self=self.tools[focus]:map_pressed(self) end
			self=self.tools[focus]:map_hover(self)
		end
	end
	return self.sys
end

function gt_editor:draw()
	for i,v in ipairs(self.toolset) do v:draw(self) end
	self:check_mouse()
	
	if(self.cursor~=nil) then
		love.graphics.draw(self.cursor, self.mouse.x, self.mouse.y)
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
		love.graphics.print("map: " .. self.sys.map.name .. " :: tile position  x:" .. self.mouse.map.x .. " y:" .. self.mouse.map.y .. " ", 5, 10)
	
end

function gt_editor:get_center_screen()
	return {x=(love.window.getWidth()/self.sys.scale.x)/2, y=(love.window.getHeight()/self.sys.scale.y)/2}
end

function gt_editor:check_mouse()
		self.mouse.x, self.mouse.y=love.mouse.getPosition()
		-- make cords relative to scale--
		self.mouse.x, self.mouse.y=math.floor(self.mouse.x/self.sys.scale.x), math.floor(self.mouse.y/self.sys.scale.y)
		self.mouse.map=self.sys.map:screen_to_map(self.selected.layer, self.mouse.x, self.mouse.y)
		self.mouse.hover=self.sys.map:map_to_screen(self.selected.layer, self.mouse.map.x, self.mouse.map.y)
		
		if(self.mouse.x<0) then self.mouse.x=1 end
		if(self.mouse.y<0) then self.mouse.y=1 end
		self.mouse.width, self.mouse.height=self.sys.map.tileset.tile_width*self.sys.scale.x, self.sys.map.tileset.tile_height*self.sys.scale.y
		self:check_button()
end


function gt_editor:check_button()
		local down, p=false, ""
		
		if(love.mouse.isDown("r")) then 
			down=true
			p="r"
		end
		
		if(love.mouse.isDown("l")) then 
			down=true
			p="l"
		end
		
		if(down) then
			if(not self.mouse.held) then
				self.mouse.pressed=p
				self.mouse.held=true
			else
				self.mouse.holding=self.mouse.holding+1
				self.mouse.held=nil
			end
		else
			self.mouse.pressed=nil
			self.mouse.holding=0
			self.mouse.held=nil
		end
end

function gt_editor:check_hover(mouse, widget)
 return mouse.x < widget.x+widget.width and
         widget.x < self.mouse.x+mouse.width and
         mouse.y < widget.y+widget.height and
         widget.y < mouse.y+mouse.height	
end

function gt_editor:update_tools()
	local has_focus=false
	for i,v in ipairs(self.tools) do
			self:check_mouse()
			if(self:check_hover(self.mouse, v)) and (not has_focus) then 
				if(self.mouse.pressed~=nil) then self=v:mouse_pressed(self) end
				self=v:mouse_hover(self)
				has_focus=true
			end
			self=v:update(dt, self)
	end
	return has_focus
end