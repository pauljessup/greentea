gt_tile=Class{}

function gt_tile:init(tile_table)
	self.id=tile_table.id
	self.values=tile_table.values
	if(tile_table.opacity==nil) then self.opacity=255 else self.opacity=tile_table.opacity end
end

function gt_tile:save_table()
	local l={}
	l.id=self.id
	l.values=self.values
	l.opacity=self.opacity
	return l
end

function gt_tile:draw(gt_tileset, x, y, opacity)
	if(opacity>=self.opacity) then
		love.graphics.setColor(255, 255, 255, self.opacity)
	else
		love.graphics.setColor(255, 255, 255, opacity)
	end
	love.graphics.draw(gt_tileset.image, gt_tileset.quads[self.id], x, y)	
	love.graphics.setColor(255, 255, 255, 255)
end

function gt_tile:get_value(value)
	return self.values[value]
end

function gt_tile:set_value(value, set)
	self.values[value]=set
end

