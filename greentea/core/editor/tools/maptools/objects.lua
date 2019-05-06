local object=Class{}
object:include(gt_widget)

function object:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "place objects")
	self.working_layer=1
	self.weight=1
	self.object_do=false
	self:add_button(editor, "objectdrop.png")
end

function object:mouse_pressed(editor)	
	editor=editor.toolset[3]:close(editor)
	editor=editor.toolset[5]:open(editor)
	for i,v in ipairs(editor.tools) do
		if(v.tooltip=="place tiles") then
			v.button.active=false
		end
	end
	for i,v in ipairs(editor.tools) do
		if(v.tooltip=="place an object") then editor=v:mouse_pressed(editor) end
	end
	self.button.active=true
return editor
end

return object