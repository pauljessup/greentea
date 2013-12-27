local layernew=Class{}
layernew:include(gt_widget)

function layernew:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "add layer")
	self.weight=0
	self:add_button(editor, "newlayer.png")
end

function layernew:mouse_pressed(editor)
	if(not self.button.active) then
		for i,v in ipairs(editor.tools) do
			if(v.name=="tilepick") then
				self.tilepick=i
				v:mouse_pressed(editor, "select default tile for layer")
				self.button.active=true
			end
		end
	--[[
		editor.sys:add_layer(
		{
			id=#editor.sys.map.layers,
			opacity=255,
			speed=1,
			default_tile=0,
		})
		self.button.active=true
		editor.selected.layer=#editor.sys.map.layers
	--]]
	end
return editor
end

function layernew:update(dt, editor)
	if(self.button.active) and (not editor.tools[self.tilepick].button.active) then
		editor.sys:add_layer(
		{
			id=#editor.sys.map.layers,
			opacity=255,
			speed=1,
			default_tile=editor.selected.tile,
		})
		self.button.active=false
		editor.selected.layer=#editor.sys.map.layers		
	end
	editor=gt_widget:update(dt, editor)
return editor
end

function layernew:draw(editor)
--[[
	if(editor.mouse.holding==0) then
		self.button.active=false
	end
--]]
	gt_widget.draw(self, editor)
end

return layernew