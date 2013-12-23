local tile_pick=Class{}
tile_pick:include(gt_widget)

function tile_pick:init(editor, x, y, id)
	editor.window_color.alpha=150
	editor.frame_color.alpha=190			
	gt_widget.init(self, editor, x, y, id, "pick a tile")
	self.weight=2	
	self.modal=gt_transition("slideleft", 0, 0, editor.sys.map.tileset.image:getWidth()+(editor.sys.map.tileset.tile_width*4), editor.sys.map.tileset.image:getHeight()+(editor.sys.map.tileset.tile_height*4), editor.window_color, editor.frame_color, editor)
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.working_layer=editor.selected.layer
	self:add_button(editor, "tilepick.png")
end

function tile_pick:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor.focus:gain(self.id) end
	gt_widget.mouse_pressed(self, editor)
	local center=editor:get_center_screen()
	local w, h=editor.sys.map.tileset.image:getWidth()+(editor.sys.map.tileset.tile_width*4), editor.sys.map.tileset.image:getHeight()+(editor.sys.map.tileset.tile_height*4)
	local x, y=center.x-(w/2), center.y-(h/2)
	self.modal=gt_transition("slidedown", x, y, w, h, editor.window_color, editor.frame_color, editor)	
	
	self.modal:open()
return editor
end

function tile_pick:update(dt, editor)
	self.modal:update(dt)
	return editor
end

function tile_pick:map_pressed(editor)
	local hx, hy=0,0
	mouse=editor.mouse
	mouse.x=editor.mouse.x-(editor.sys.map.tileset.tile_width*2)
	mouse.y=editor.mouse.y-(editor.sys.map.tileset.tile_height*2)
	local center=editor:get_center_screen()
	local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+self.modal.y)
	for i, v in ipairs(grid.hover_check) do
				if(editor:check_hover(mouse, v)) then
					editor.selected.tile=v.id
					editor.selected.tiles.use=false
					self.hover.x=v.x
					self.hover.y=v.y
				end
	end
	editor.focus:lose() 
	self.button.active=false	
	self.modal:close()
return editor
end

function tile_pick:map_hover(editor)
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
				end
	end		
return editor
end

function tile_pick:draw(editor)
	local center=editor:get_center_screen()
	self.modal:draw()
	if(self.modal.opened or self.modal.opening or self.modal.closing) then 
		editor.sys.map.tileset:select_grid(center.x, center.y+self.modal.y) 	
		if(self.modal.opened) then self.hover:draw() end
	end
	gt_widget.draw(self, editor)
end

return tile_pick