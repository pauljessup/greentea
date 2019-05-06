local solidown=Class{}
solidown:include(gt_widget)

function solidown:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "make a layer more transparent")
	self.weight=5
	self:add_button(editor, "solidown.png")
end

function solidown:mouse_pressed(editor)

		editor.sys.map.layers[editor.selected.layer].opacity=editor.sys.map.layers[editor.selected.layer].opacity-10
		self.button.active=true
		if(editor.sys.map.layers[editor.selected.layer].opacity<1) then
			editor.sys.map.layers[editor.selected.layer].opacity=0
		end
return editor
end

function solidown:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return solidown