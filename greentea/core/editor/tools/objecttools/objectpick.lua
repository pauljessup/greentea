local object_pick=Class{}
object_pick:include(gt_widget)

function object_pick:init(editor, x, y, id)
	editor.window_color.alpha=150
	editor.frame_color.alpha=190
	gt_widget.init(self, editor, x, y, id, "choose an object to place")
	self.name="obectpick"
	self.modal=gt_transition("slideleft", 0, 0, editor.sys.map.tileset.image:getWidth()+(editor.sys.map.tileset.tile_width*4), editor.sys.map.tileset.image:getHeight(), editor.window_color, editor.frame_color, editor)
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=50}, {r=133, g=120, b=57, alpha=75})
	self.weight=3
	self.working_layer=editor.selected.layer
	self:add_button(editor, "tilepick.png")
	self.select={}
	self.old_mouse=nil
	self.select.selected={}
	self.select.start=false
end

function object_pick:mouse_pressed(editor, msg)
	self.msg=msg
	if(editor.focus:get()~=self.id) then editor.focus:gain(self.id) end
	gt_widget.mouse_pressed(self, editor)
	local center=editor:get_center_screen()
	local w, h=editor.object_grid.width, editor.object_grid.height
	local x, y=editor.object_grid.x, editor.object_grid.y
	self.modal=gt_transition("open", x, y, w, h, editor.window_color, editor.frame_color, editor)	
	self.modal:open()
return editor
end

function object_pick:update(dt, editor)
	self.modal:update(dt)
	return editor
end



function object_pick:map_pressed(editor)
	hit, object=editor:hover_object_grid()
	self.use_hover=nil
	if(hit) then
		editor.selected.object=object.type
	end
	
	self.modal:close()
	self.button.active=false
	editor.focus:lose()
return editor
end

function object_pick:map_hover(editor)
	hit, object=editor:hover_object_grid()
	self.use_hover=nil
	if(hit) then
		self.hover.x=object.x
		self.hover.y=object.y
		self.use_hover=true
		self.hover.text=string.gsub(object.type, ".lua", "")
	end
return editor
end

function object_pick:draw(editor)
	local center=editor:get_center_screen()
	self.modal:draw()
	if(self.modal.opened) then editor:draw_object_grid() end
	gt_widget.draw(self, editor)
	if(self.use_hover) and (self.button.active) then 
		self.hover:draw()
		love.graphics.print(self.hover.text, self.hover.x, self.hover.y)
	end
end

return object_pick