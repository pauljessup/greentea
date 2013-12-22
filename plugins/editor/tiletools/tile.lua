local tile_tool=Class{}
tile_tool:include(gt_widget)

function tile_tool:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "place a tile")
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.working_layer=1
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
	self:add_button(editor, "paintbrush.png")
end

function tile_tool:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor.focus:gain(self.id) end
	gt_widget.mouse_pressed(self, editor)
return editor
end

function tile_tool:map_pressed(editor)
	self.working_layer=2
	local mouse=editor:map_mouse(self.working_layer)	
	editor.sys.map:set_tile(9, 2, mouse.map.x, mouse.map.y)
return editor
end

function tile_tool:map_hover(editor)
	self.tile.draw=true
return editor
end

function tile_tool:draw(editor)
	if(self.tile.draw) then 
		local mouse=editor:map_mouse(self.working_layer)
		self.hover.x=mouse.hover.x
		self.hover.y=mouse.hover.y
		self.hover:draw()
	end
	gt_widget.draw(self)
end

return tile_tool