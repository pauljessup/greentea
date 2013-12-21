local tile_tool=Class{}
tile_tool:include(gt_widget)

function tile_tool:init(editor, id)
	gt_widget.init(self, id)
	self.x, self.y=10,10
	self.width, self.height=editor.sys.map.tileset.tile_width,editor.sys.map.tileset.tile_height
	self.hover=gt_frame(self.x, self.y, self.width, self.height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.selected={} -- a possible 2d mini map for multiple tile placing.
	self.working_layer=1
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
end

function tile_tool:map_pressed(editor)
	self.working_layer=2
	local mouse=editor:map_mouse(self.working_layer)	
	editor.sys.map:set_tile(9, 2, mouse.map.x, mouse.map.y)
return editor
end

function tile_tool:map_hover(editor)
	self.tile.draw=true
return editor
end

function tile_tool:draw(editor)
	if(self.tile.draw) then 
		local mouse=editor:map_mouse(self.working_layer)
--		love.graphics.setColor(255, 0, 0, 100)
		self.hover.x=mouse.hover.x
		self.hover.y=mouse.hover.y
		self.hover:draw()
--		love.graphics.rectangle("fill", mouse.hover.x, mouse.hover.y, self.tile.width, self.tile.height)
--		love.graphics.setColor(255, 255, 255, 255)	
	end
end

return tile_tool