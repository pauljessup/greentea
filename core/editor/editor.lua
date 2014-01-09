gt_editor=Class{}

function gt_editor:lose_focus()
	if(self.focus:get()) then
		self.tools[self.focus:get()].button.active=false
		self.focus:lose()
	end
end


function gt_editor:gain_focus(id)
	self.focus:gain(id)
	self.tools[self.focus:get()].button.active=true	
end

function gt_editor:init(sys)
	self.plugin_directory=sys.plugin_directory .. "/editor"
	self.asset_directory=self.plugin_directory .. "/assets"
	self.selected={}
	self.selected.tile=1
	self.selected.tiles={}
	self.selected.tiles.use=false
	self.selected.layer=1
	self.focus_tool=1
	self.undo={}
	
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
	self.window_color=sys.theme.window_color
	self.frame_color=sys.theme.outline_color

	self.toolset={}
	local x, y=self:calculate_location("right", 128, 0)
	table.insert(self.toolset, gt_transition("slidedown", -5, -5, (love.window.getWidth()/self.sys.scale.x)+50, 35,  self.window_color, self.frame_color, self))	
	table.insert(self.toolset, gt_toolbar("maptools", "slidedown", x, y, "horizontal", 6, self, {r=0, g=0, b=0, alpha=0}, {r=0, g=0, b=0, alpha=0}))	
	table.insert(self.toolset, gt_toolbar("tiletools", "slideleft", 5, 50, "vertical", 6, self))	
	local x, y=self:calculate_location("right", 40, 0)	
	table.insert(self.toolset, gt_toolbar("layertools", "slideright", x, 50, "vertical", 6, self))
	table.insert(self.toolset, gt_toolbar("objecttools", "slideleft", 5, 50, "vertical", 6, self))	
	table.insert(self.toolset, gt_toolbar("objectedit", "open", 100, 100, "vertical", 6, self))	
end

function gt_editor:calculate_location(location, x, y)
	if(location=="top") then y=5 end
	if(location=="bottom") then y=(love.window.getHeight()/self.scale.y)-y end
	if(location=="left") then x=5 end
	if(location=="right") then x=(love.window.getWidth()/self.sys.scale.x)-x end
	return x, y
end

function gt_editor:get_objects(sys, folder)
	local files = love.filesystem.getDirectoryItems(folder)	
	for num, name in pairs(files) do
		if(love.filesystem.isFile(folder .. name)) then	
			local object={id=name, type=name, x=0, y=0, opacity=255, speed=1, 0 }
			local object_class=love.filesystem.load(folder .. name)()
			table.insert(self.objects, object_class(object))		
		end
	end
	self:set_object_grid()
end

function gt_editor:set_object_grid()
	self.object_grid.width=(love.window.getWidth()/self.sys.scale.x)-100
	if(self.object_grid.tallest==nil) then self.object_grid.tallest=0 end
	local tallest, height, ox, oy=self.object_grid.tallest, 0, self.object_grid.x, self.object_grid.y
	local x, y=ox, oy
	for i,v in ipairs(self.objects) do
		v:editor_init(self)
		if(v.height>tallest) then tallest=v.height end
		v.x=x
		v.y=y+5
		x=x+v.width+5
		if(x>self.object_grid.width) then
			y=y+tallest
			x=ox
			tallest=0
		end
	end
	if(y==nil) then y=tallest end
	self.object_grid.height=y+10
	self.object_grid.y=y
end

function gt_editor:draw_object_grid()
	for i,v in ipairs(self.objects) do
		v:editor_select_draw()
	end
end

function gt_editor:hover_object_grid()
	for i,v in ipairs(self.objects) do
		if(self:check_hover(self.mouse, v)) then return true, v end
	end	
	return false
end

function gt_editor:run(sys)
		love.mouse.setVisible(self.edit_show_mouse)
		self.logo.fade=true 
		self.logo.fade_in=true 
		self.toolset[1]:open(self)
		self.toolset[2]:open(self)
		self.toolset[4]:open(self)

		for i,v in ipairs(self.tools) do
			if(v.tooltip=="place tiles") then v:mouse_pressed(self) end
		end
		if(self.font~=nil) then love.graphics.setFont(self.font.font) end
		self.sys.map:using_editor(true, self)
		local obj_folder=self.sys.plugin_directory .. "/objects/"
		local map_folder=obj_folder .. "/" .. self.sys.map.name .. "/"
		
		self.objects={}
		self.object_grid={}
		self.object_grid.x, self.object_grid.y=0, 0
		 
		self:get_objects(sys, obj_folder)
		self:get_objects(sys, map_folder)

		local center=self:get_center_screen()
		local w, h=self.object_grid.width, self.object_grid.height
		self.object_grid.x, self.object_grid.y=center.x-(w/2), center.y-(h/2)				
		self:set_object_grid()
		w, h=self.object_grid.width, self.object_grid.height
		self.object_grid.x, self.object_grid.y=center.x-(w/2), center.y-(h/2)
		self:set_object_grid()
end

function gt_editor:close(sys)
		love.mouse.setVisible(self.show_mouse)
		self.logo.fade=false 
		self.logo.fade_in=false 
		for i,v in ipairs(self.toolset) do v:close(self) end
		if(self.font~=nil) then love.graphics.setFont(self.font.old) end
		self.sys.map:using_editor(false, self)		
end

function gt_editor:update(dt, sys)
	self.sys=sys
	self:check_mouse()
	for i,v in ipairs(self.toolset) do v:update(dt, self) end
	for i,v in self.sys.map:get_layers() do v:update(dt, true) end
	
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
		love.graphics.print("editing " .. self.sys.map.name .. "  map      size: " .. self.sys.map.width .. "x" .. self.sys.map.height, 5, 2)
		percentage=math.floor((self.sys.map.layers[self.selected.layer].opacity/255)*(100/1))
		love.graphics.print("layer: " .. self.sys.map.layers[self.selected.layer].id .. " x:" .. self.mouse.map.x .. " y:" .. self.mouse.map.y, 5, 12)
	for i,v in ipairs(self.tools) do if(not v.hidden) then v:tool_tip_draw(self) end end
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
		
		if(self.mouse.x<1) then 
			self.mouse.x=1 
			if(math.floor(self.sys.map.camera.x)>=self.sys.map.tileset.tile_width) then			
				self.sys.map:scroll(-.2, 0)
			end			
		end
		if(self.mouse.y<=1) then
			self.mouse.y=1
			if(math.floor(self.sys.map.camera.y)>=self.sys.map.tileset.tile_height) then			
				self.sys.map:scroll(0, -.2)
			end
		end
		if(self.mouse.x>((love.window.getWidth()/self.sys.scale.x)-8)) then
			if(self.sys.map.camera.x<=((self.sys.map.width)*(self.sys.map.tileset.tile_width)-(love.window.getWidth()/self.sys.scale.x))) then		
				self.sys.map:scroll(.2, 0)
			end
		end
		if(self.mouse.y>((love.window.getHeight()/self.sys.scale.y)-8)) then
			if(self.sys.map.camera.y<=((self.sys.map.height)*(self.sys.map.tileset.tile_height)-(love.window.getHeight()/self.sys.scale.y))) then
				self.sys.map:scroll(0, .2)
			end
		end		
		self.mouse.width, self.mouse.height=self.sys.map.tileset.tile_width*self.sys.scale.x, self.sys.map.tileset.tile_height*self.sys.scale.y
		self.mouse.widget={}
		self.mouse.widget.x, self.mouse.widget.y=self.mouse.x, self.mouse.y
		self.mouse.widget.width, self.mouse.widget.height=8,8
		self:check_button()
end

function gt_editor:do_undo()
	local l=table.remove(self.undo)
	--error(#self.undo)
	self.sys.map:undo(l)
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
			if(self:check_hover(self.mouse.widget, v)) and (not has_focus) and (not v.hidden) then 
				if(self.mouse.pressed~=nil) then self=v:mouse_pressed(self) end
				self=v:mouse_hover(self)
				has_focus=true
			end
			self=v:update(dt, self)
	end
	return has_focus
end