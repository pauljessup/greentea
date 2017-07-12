local pot=Class{}
pot:include(gt_object)

function pot:init(object_table)
	object_table.image="pot.png"
	gt_object.init(self, object_table)
	
	self.open=false
	self.width=16
	self.height=16
	self.open_frame=love.graphics.newQuad(16, 0, 16, 16, self.image:getWidth(), self.image:getHeight())
	self.closed_frame=love.graphics.newQuad(0, 0, 16, 16, self.image:getWidth(), self.image:getHeight())
end

function pot:draw(layer)
	local quad_use=self.closed_frame
	if(self.open) then quad_use=self.open_frame end
	gt_object.draw(self, layer, quad_use)
end

return pot