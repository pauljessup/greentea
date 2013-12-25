local tile=Class{}
tile:include(gt_widget)

function tile:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "place tiles")
	self.working_layer=1
	self.weight=1
	self.tile_do=false
	self:add_button(editor, "tilepick.png")
end

function tile:mouse_pressed(editor)
	editor.toolset[3]:open()
	for i,v in ipairs(editor.toolset) do
		if(i~=3 and i~=1 and i~=2) then v.open() end
	end
	for i,v in ipairs(editor.tools) do
		if(v.tooltip=="place a tile") then editor=v:mouse_pressed(editor) end
	end
	self.button.active=true
return editor
end

return tile