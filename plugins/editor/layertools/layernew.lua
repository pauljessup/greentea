local layernew=Class{}
layernew:include(gt_widget)

function layernew:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "add layer")
	self.weight=0
	self:add_button(editor, "newlayer.png")
end

function layernew:mouse_pressed(editor)
	if(editor.mouse.holding<5) then
		editor.sys:add_layer(
		{
			id=#editor.sys.map.layers,
			opacity=255,
			speed=1,
			default_tile=0,
		})
		editor.selected.layer=#editor.sys.map.layers
	end
return editor
end

function layernew:draw(editor)
	gt_widget.draw(self, editor)
	self.button.active=false
end

return layernew