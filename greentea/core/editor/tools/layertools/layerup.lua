local layerup=Class{}
layerup:include(gt_widget)

function layerup:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "move up a layer")
	self.weight=-1
	self:add_button(editor, "layerup.png")
end

function layerup:mouse_pressed(editor)
	if(editor.mouse.holding<10) then
		editor.selected.layer=editor.selected.layer+1
		self.button.active=true
		if(editor.selected.layer>#editor.sys.map.layers) then
			editor.selected.layer=1
		end
		editor.selected.tile=1
		editor.selected.tiles.use=false
	end
return editor
end

function layerup:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return layerup