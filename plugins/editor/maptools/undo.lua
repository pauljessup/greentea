local undo=Class{}
undo:include(gt_widget)

function undo:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "undo the map")
	self.working_layer=1
	self.weight=1
	self.undo_do=false
	self:add_button(editor, "undo.png")
end

function undo:mouse_pressed(editor)
	if(self.button.active==false) and (editor.mouse.holding<5) then
		self.undo_do=true
		editor:do_undo()
		self.button.active=true
	else
		self.button.active=false
	end
return editor
end


return undo