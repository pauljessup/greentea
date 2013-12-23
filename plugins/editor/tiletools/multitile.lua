local multi_tile=Class{}
multi_tile:include(gt_widget)

function multi_tile:init(editor, x, y, id)
	editor.window_color.alpha=150
	editor.frame_color.alpha=190			
	gt_widget.init(self, editor, x, y, id, "pick a group of tiles")
	self.modal=gt_transition("slideleft", 0, 0, editor.sys.map.tileset.image:getWidth()+(editor.sys.map.tileset.tile_width*4), editor.sys.map.tileset.image:getHeight()+(editor.sys.map.tileset.tile_height*4), editor.window_color, editor.frame_color, editor)
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.weight=3
	self.working_layer=editor.selected.layer
	self:add_button(editor, "tilemultipick.png")
	self.select={}
	self.old_mouse=nil
	self.select.selected={}
	self.select.start=false
end

function multi_tile:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor.focus:gain(self.id) end
	gt_widget.mouse_pressed(self, editor)
	local center=editor:get_center_screen()
	local w, h=editor.sys.map.tileset.image:getWidth()+(editor.sys.map.tileset.tile_width*4), editor.sys.map.tileset.image:getHeight()+(editor.sys.map.tileset.tile_height*4)
	local x, y=center.x-(w/2), center.y-(h/2)
	self.modal=gt_transition("slidedown", x, y, w, h, editor.window_color, editor.frame_color, editor)	
	self.modal:open()
return editor
end

function multi_tile:update(dt, editor)
	self.modal:update(dt)
	return editor
end

function multi_tile:get_multiple_tiles(editor)
	local tile_height, tile_width=editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height	
	local center=editor:get_center_screen()
	local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+self.modal.y)	editor.selected.tiles={}

	editor.selected.tiles={x=math.floor((self.hover.x-grid.x)/tile_width), y=math.floor((self.hover.y-grid.y)/tile_height), w=math.floor(self.hover.width/tile_width), h=math.floor(self.hover.height/tile_height), use=true}
	return editor
end

function multi_tile:map_pressed(editor)
	if(self.select.start) then
		self.select.start=false
		self:get_multiple_tiles(editor)
		self.old_mouse=nil
		self.hover.width=editor.sys.map.tileset.tile_width
		self.hover.height=editor.sys.map.tileset.tile_height
		editor.focus:lose() 
		self.button.active=false	
		self.modal:close()
	elseif(not self.select.start and editor.mouse.holding>2) then
			self.select.start=true
			local hx, hy=0,0
			local mouse=editor.mouse
			mouse.x=editor.mouse.x-(editor.sys.map.tileset.tile_width*2)
			editor.mouse.y=editor.mouse.y-(editor.sys.map.tileset.tile_height*2)
			local center=editor:get_center_screen()
			local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+self.modal.y)	
			editor.selected.modal=self.modal
			for i, v in ipairs(grid.hover_check) do
						if(editor:check_hover(mouse, v)) then
							self.hover.x=v.x
							self.hover.y=v.y
							self.old_mouse={x=v.x, y=v.y}
						end
			end
	end
return editor
end

function multi_tile:map_hover(editor)
	local hx, hy=0,0
	local mouse=editor.mouse	
	mouse.x=editor.mouse.x-(editor.sys.map.tileset.tile_width*2)
	mouse.y=editor.mouse.y-(editor.sys.map.tileset.tile_height*2)	
	local center=editor:get_center_screen()
	local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+self.modal.y)
	for i, v in ipairs(grid.hover_check) do
				if(editor:check_hover(mouse, v)) then
					self.hover.x=v.x
					self.hover.y=v.y
					if(self.old_mouse~=nil) then
						self.hover.x=self.old_mouse.x
						self.hover.y=self.old_mouse.y
						self.hover.width=v.x-self.old_mouse.x
						self.hover.height=v.y-self.old_mouse.y
					end
				end
	end		
return editor
end

function multi_tile:draw(editor)
	local center=editor:get_center_screen()
	self.modal:draw()
	if(self.modal.opened or self.modal.opening or self.modal.closing) then 
		editor.sys.map.tileset:select_grid(center.x, center.y+self.modal.y) 	
		if(self.modal.opened) then self.hover:draw() end
	end
	gt_widget.draw(self, editor)
end

return multi_tile