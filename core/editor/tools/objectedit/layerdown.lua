local layerdown=Class{}
layerdown:include(gt_widget)

function layerdown:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "move down a layer")
	self.weight=1
	self:add_button(editor, "layerdown.png")
end

function layerdown:mouse_pressed(editor)
	if(editor.mouse.holding<10) then
		editor.sys.map.objects[editor.selected.edit_object].layer=editor.sys.map.objects[editor.selected.edit_object].layer-1
		self.button.active=true
		if(editor.sys.map.objects[editor.selected.edit_object].layer<1) then
			editor.sys.map.objects[editor.selected.edit_object].layer=#editor.sys.map.layers
		end
	end
return editor
end

function layerdown:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return layerdown