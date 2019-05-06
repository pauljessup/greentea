local chest=Class{}
chest:include(gt_object)

function chest:init(object_table)
	object_table.image="chest.png"
	gt_object.init(self, object_table)
	
	self.open=false
	self.width=16
	self.height=16
	self.closed_frame=love.graphics.newQuad(16, 0, 16, 16, self.image:getWidth(), self.image:getHeight())
	self.open_frame=love.graphics.newQuad(0, 0, 16, 16, self.image:getWidth(), self.image:getHeight())
end

function chest:draw(layer)
	local quad_use=self.closed_frame
	if(self.open) then quad_use=self.open_frame end
	gt_object.draw(self, layer, quad_use)
end

return chest