gt_widget=Class{}

function gt_widget:init(editor, id)
	self.id=id
	self.x, self.y=0,0
	self.width, self.height=0,0
	self.focus=false
end

function gt_widget:gain_focus(editor)
	self.focus=true
	editor.focus:gain(self.id)
	return editor
end

function gt_widget:lose_focus(editor)
	self.focus=false
	editor.focus:lose()
	return editor
end


function gt_widget:update(dt, editor, mouse)

return editor
end

function gt_widget:mouse_pressed(editor, mouse)

return editor
end

function gt_widget:mouse_hover(editor, mouse)

return editor
end

function gt_widget:map_pressed(editor, mouse)

return editor
end

function gt_widget:map_hover(editor, mouse)

return editor
end

function gt_widget:draw()

end