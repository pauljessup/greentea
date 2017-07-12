gt_camera=Class{}

function gt_camera:init(camera_table)
	self.x=camera_table.x
	self.y=camera_table.y
	self.padding=camera_table.padding
	self.speed=camera_table.speed
	self.height=camera_table.height
	self.width=camera_table.width
end

function gt_camera:save_table()
	local l={}
	l.speed=self.speed
	l.x=self.x
	l.y=self.y
	l.padding=self.padding
	l.height=self.height
	l.width=self.width
	return l
end

function gt_camera:update(dt)

end

function gt_camera:expand(height, width)
	self.height=self.height+height
	self.width=self.width+width
end

function gt_camera:shrink(height, width)
	self.height=self.height-height
	self.width=self.width-width
end

function gt_camera:scroll(x, y)
	self.x=self.x+(x*self.speed)
	self.y=self.y+(y*self.speed)
end

function gt_camera:move(x, y)
	self.x=x
	self.y=y
end