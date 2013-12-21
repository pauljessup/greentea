local tile_tool=Class{}
tile_tool:include(gt_widget)

function tile_tool:init(editor, id)
	gt_widget.init(self, id)
	self.x, self.y=10,10
	self.width, self.height=16,16
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
end

function tile_tool:map_pressed(editor, mouse)
	editor.sys.map:set_tile(9, 2, mouse.mapx, mouse.mapy)
return editor
end

function tile_tool:map_hover(editor, mouse)
	self.tile.draw=true
return editor
end

function tile_tool:draw(editor)
	if(self.tile.draw) then 
		local mouse=editor:map_mouse()
		love.graphics.setColor(255, 0, 0, 100)
		love.graphics.rectangle("fill", mouse.x, mouse.y, self.tile.width, self.tile.height)
		love.graphics.setColor(255, 255, 255, 255)	
	end
end

return tile_tool