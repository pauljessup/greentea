local save=Class{}
save:include(gt_widget)

function save:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "save the map")
	local center=editor:get_center_screen()
	self.save=gt_transition("open", center.x-60, center.y-25, 60, 25,  editor.window_color, editor.frame_color, editor)
	self.working_layer=1
	self.weight=2
	self.save_do=false
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
	self:add_button(editor, "save.png")
end

function save:mouse_pressed(editor)
	self.save:open(editor)
return editor
end

function save:update(dt, editor)
	gt_widget.update(self, editor)
	self.save:update(dt)
	if(self.save_do) then
		editor.sys:save()
		self.save:close()
		self.save_do=false
	end
	return editor
end

function save:draw(editor)
	gt_widget.draw(self, editor)
	self.save:draw()
	if(self.save.opened) then
		self.save_do=true
		love.graphics.print("saving...", self.save.x+5, self.save.y+8)
	end
	return editor
end

return save