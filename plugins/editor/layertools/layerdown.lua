local layerdown=Class{}
layerdown:include(gt_widget)

function layerdown:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "mover down a layer")
	self.weight=1
	self:add_button(editor, "layerdown.png")
end

function layerdown:mouse_pressed(editor)
	if(editor.mouse.holding<5) then
		editor.selected.layer=editor.selected.layer-1
		self.button.active=true
		if(editor.selected.layer<1) then
			editor.selected.layer=#editor.sys.map.layers
		end
	end
return editor
end

function layerdown:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return layerdown