local close=Class{}
close:include(gt_widget)

function close:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "close the editor")
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.working_layer=1
	self.weight=3
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
	self:add_button(editor, "close.png")
end

function close:mouse_pressed(editor)
	editor.sys:toggle_editor()
return editor
end

function close:map_hover(editor)
	self.tile.draw=true
return editor
end

function close:draw(editor)
	gt_widget.draw(self, editor)
end

return close