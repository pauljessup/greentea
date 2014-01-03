local tiledelete=Class{}
tiledelete:include(gt_widget)

function tiledelete:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "erase a tile")
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.working_layer=1
	self.weight=4
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
	self:add_button(editor, "tiledelete.png")
end

function tiledelete:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor:lose_focus() editor:gain_focus(self.id) end
	gt_widget.mouse_pressed(self, editor)
return editor
end

function tiledelete:map_pressed(editor)
	local mapx,mapy=editor.mouse.map.x, editor.mouse.map.y
	if(not editor.selected.tiles.use) then
		editor.sys.map:set_tile(0, editor.selected.layer, mapx, mapy)
	else
		local ox,oy=editor.selected.tiles.x, editor.selected.tiles.y
		local x, y=1,1
		local center=editor:get_center_screen()
		local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+editor.selected.modal.y)			
		
		while y<=editor.selected.tiles.h do
			while x<=editor.selected.tiles.w do
					if(grid.tile_map[y+oy][x+ox]~=nil) then 
						editor.sys.map:set_tile(grid.tile_map[y+oy][x+ox], editor.selected.layer, mapx+x, mapy+y) 
					else
						editor.sys.map:set_tile(0, editor.selected.layer, mapx+x, mapy+y)
					end
					x=x+1
			end
			x=1
			y=y+1
		end
	end
return editor
end

function tiledelete:draw(editor)
	if(self.tile.draw) then 
		self.hover.x=editor.mouse.hover.x
		self.hover.y=editor.mouse.hover.y
		self.hover.width=editor.sys.map.tileset.tile_width
		self.hover.height=editor.sys.map.tileset.tile_height
		self.hover:draw()
	end
	gt_widget.draw(self, editor)
end

return tiledelete