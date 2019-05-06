local object_tool=Class{}
object_tool:include(gt_widget)

function object_tool:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "place an object")
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.working_layer=1
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
	self.hover_tip2=gt_frame(x+3, y-7, editor.font.font:getWidth("right click to move, click to edit")+5, editor.font.font:getHeight()+5, {r=0, g=0, b=0, alpha=100}, {r=0, g=0, b=0, alpha=255}) 
	self.showtip=false
	self:add_button(editor, "objectdrop.png")
	self.placing=false
end

function object_tool:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor:lose_focus() editor:gain_focus(self.id) self.button.active=true end
	gt_widget.mouse_pressed(self, editor)
	editor.selected.object="placeholder"
return editor
end

function object_tool:map_pressed(editor)	

	local mapx,mapy=editor.mouse.map.x*editor.sys.map.tileset.tile_width, editor.mouse.map.y*editor.sys.map.tileset.tile_height		
	local tocheck={layer=editor.selected.layer, x=mapx, y=mapy, width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height}
	local check_hover={x=editor.mouse.x, y=editor.mouse.y, height=editor.mouse.height+5, width=editor.mouse.width}
	hit=editor.sys.map:object_collide(tocheck)	

	if(editor.selected.edit_object~=nil) and not hit and not editor:check_hover(check_hover, editor.toolset[6]) then
			editor=editor.toolset[6]:close(editor)
			editor.selected.edit_object=nil
			self.placing=true
			editor.selected.editing=nil
	else
			if editor.mouse.pressed=="l" and not self.placing and editor.selected.editing==nil  then
				if(editor.selected.move_object==nil) and editor.selected.edit_object==nil and not hit then
					self.placing=true
					local mapx,mapy=editor.mouse.map.x, editor.mouse.map.y
					editor.sys:add_object({id=(#editor.sys.map.objects+1),
										type=editor.selected.object,
										x=mapx*editor.sys.map.tileset.tile_width,
										y=mapy*editor.sys.map.tileset.tile_width,
										opacity=255,
										speed=1,
										layer=editor.selected.layer
										})
					table.insert(editor.undo, {object=true}) 
					editor.selected.move_object=nil
				elseif editor.selected.move_object==nil and editor.selected.edit_object==nil and hit then
					editor.selected.edit_object=hit
				elseif editor.selected.move_object~=nil then
					self.placing=true
					editor.sys.map.objects[editor.selected.move_object].x=editor.mouse.map.x*editor.sys.map.tileset.tile_width
					editor.sys.map.objects[editor.selected.move_object].y=editor.mouse.map.y*editor.sys.map.tileset.tile_height
					editor.selected.move_object=nil
				end
			elseif(editor.mouse.pressed=="r") then
					if(hit) then editor.selected.move_object=hit end
			end
	end
	return editor
end

function object_tool:update(dt, editor)
	if(editor.mouse.holding==0) then
		self.placing=false
	end
		
	if(self.button.active) then self.hidden=false end

	if(editor.selected.edit_object~=nil) then
		if(editor.toolset[6].hidden) and (not editor.toolset[6].opening) then 
			local tx=editor.sys.map.objects[editor.selected.edit_object].x-editor.sys.map.camera.x+20
			local ty=(editor.sys.map.objects[editor.selected.edit_object].y-editor.sys.map.camera.y)-((editor.toolset[6].original.h/2)-10)
			editor=editor.toolset[6]:update_widgets(editor, {x=tx, y=ty})
			editor=editor.toolset[6]:open(editor) 
			editor.selected.editing=true
		end
	end
	if(editor.toolset[6].closed) and editor.mouse.holding==0 then
		editor.selected.editing=nil
	end
	return editor
end

function object_tool:map_hover(editor)
	if(editor.focus:get()==self.id) then  self.tile.draw=true else self.tile.draw=false end
	local mapx,mapy=editor.mouse.map.x*editor.sys.map.tileset.tile_width, editor.mouse.map.y*editor.sys.map.tileset.tile_height		
	local tocheck={layer=editor.selected.layer, x=mapx, y=mapy, width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height}
	hit, target=editor.sys.map:object_collide(tocheck)
	if(hit) then self.showtip=true self.hover_tip2.x=editor.mouse.x+10 self.hover_tip2.y=editor.mouse.y+10  end
	
	if(editor.selected.move_object~=nil) then
		local mapx,mapy=editor.mouse.map.x*editor.sys.map.tileset.tile_width, editor.mouse.map.y*editor.sys.map.tileset.tile_height		

		editor.sys.map.objects[editor.selected.move_object].x=mapx
		editor.sys.map.objects[editor.selected.move_object].y=mapy
	end
	
	
	return editor
end

function object_tool:draw(editor)
	if(editor.selected.edit_object==nil) then
		self.hover.x=editor.mouse.hover.x
		self.hover.y=editor.mouse.hover.y
	else
		self.hover.x=editor.sys.map.objects[editor.selected.edit_object].x-editor.sys.map.camera.x
		self.hover.y=editor.sys.map.objects[editor.selected.edit_object].y-editor.sys.map.camera.y
	end
		self.hover:draw()	
		gt_widget.draw(self, editor)
	
	if(self.showtip) and (not self.placing) and (not editor.selected.move_object) then
		self.hover_tip2:draw()
		love.graphics.print("right click to move, click to edit", self.hover_tip2.x+5, self.hover_tip2.y+5) 
		self.showtip=false 
	end
end

return object_tool