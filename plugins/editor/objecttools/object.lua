local object_tool=Class{}
object_tool:include(gt_widget)

function object_tool:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "place an object")
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.working_layer=1
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
	self:add_button(editor, "objectdrop.png")
end

function object_tool:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor:lose_focus() editor:gain_focus(self.id) self.button.active=true end
	gt_widget.mouse_pressed(self, editor)
	editor.selected.object="placeholder"
return editor
end

function object_tool:map_pressed(editor)
	local mapx,mapy=editor.mouse.map.x, editor.mouse.map.y
	editor.sys:add_object({id=editor.selected.object,
						x=mapx*editor.sys.map.tileset.tile_width,
						y=mapy*editor.sys.map.tileset.tile_width,
						opacity=255,
						speed=1,
						layer=editor.selected.layer
						})
	
	for i,v in ipairs(editor.sys.map.objects) do
		v:editor_init(editor)
	end
	return editor
end

function object_tool:map_hover(editor)
	if(editor.focus:get()==self.id) then  self.tile.draw=true else self.tile.draw=false end
return editor
end

function object_tool:draw(editor)
	if(self.tile.draw) then 
		self.hover.x=editor.mouse.hover.x
		self.hover.y=editor.mouse.hover.y
		self.hover:draw()	
	end
	gt_widget.draw(self, editor)
end

return object_tool