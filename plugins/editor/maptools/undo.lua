local undo=Class{}
undo:include(gt_widget)

function undo:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "undo the map")
	self.working_layer=1
	self.weight=1
	self.undo_do=2
	self:add_button(editor, "undo.png")
end

function undo:mouse_pressed(editor)
	if(self.button.active==false) then
		if(self.undo_do<2) then
			self.undo_do=self.undo_do+1
		else
			editor:do_undo()
			self.undo_do=0
		end
		self.button.active=true
	end
return editor
end

function undo:update(dt, editor)
	gt_widget.update(self, editor)
	self.button.active=false
	return editor
end


return undo