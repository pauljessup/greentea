local soldup=Class{}
soldup:include(gt_widget)

function soldup:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "make object more solid")
	self.weight=4
	self:add_button(editor, "soldup.png")
end

function soldup:mouse_pressed(editor)
		editor.sys.map.objects[editor.selected.edit_object].opacity=editor.sys.map.objects[editor.selected.edit_object].opacity+10
		self.button.active=true
		if(editor.sys.map.objects[editor.selected.edit_object].opacity>255) then
			editor.sys.map.objects[editor.selected.edit_object].opacity=255
		end
return editor
end

function soldup:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return soldup