local layerdelete=Class{}
layerdelete:include(gt_widget)

function layerdelete:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "delete this layer")
	self.weight=9
	self:add_button(editor, "layerdelete.png")
end

function layerdelete:mouse_pressed(editor)
	if(editor.mouse.holding<5) then
		table.remove(editor.sys.map.layers, editor.selected.layer)
		editor.selected.layer=editor.selected.layer-1
		self.button.active=true
		if(editor.selected.layer<1) then
			editor.selected.layer=#editor.sys.map.layers
		end
	end
return editor
end

function layerdelete:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return layerdelete