local plax=Class{}
plax:include(gt_layer)

function plax:init(layer_info)
	gt_layer.init(self, layer_info)
end

function plax:update(dt)
	gt_layer.update(self, dt)
	self:scroll(self.values.scroll_x*self.camera.speed, self.values.scroll_y*self.camera.speed)
end

return plax