local soldup=Class{}
soldup:include(gt_widget)

function soldup:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "delete object")
	self.weight=10
	self:add_button(editor, "delobject.png")
end

function soldup:mouse_pressed(editor)
		table.remove(editor.sys.map.objects, editor.selected.edit_object)
		editor=editor.toolset[6]:close(editor)
		editor.selected.edit_object=nil
return editor
end

function soldup:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return soldup