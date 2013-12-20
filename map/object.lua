gt_object=Class{}

function gt_object:init(object_table)
	self.id=object_table.id
	self.type=object_table.type
	if(object_table.opacity==nil) then object_table.opacity=255 end
	self.hidden=object_table.hidden
	self.x=object_table.x
	self.y=object_table.y
	self.w=object_table.width
	self.h=object_table.height
	self.filename=object_table.image
	if(self.filename~=nil) then 
		self.image=love.graphics.newImage(self.filename) 
	end
	self.speed=object_table.speed
	self.opacity=object_table.opacity
	self.layer=object_table.layer
end

function gt_object:show()
	self.hidden=false
end

function gt_object:hide()
	self.hidden=true
end

function gt_object:is_hidden()
	return self.hidden
end

function gt_object:save_table()
	local l={}
	l.id=self.id
	l.x=self.x
	l.type=self.type
	l.y=self.y
	l.width=self.w
	l.height=self.h
	l.opacity=self.opacity
	l.layer=self.layer
	l.hidden=self.hidden
	l.image=self.filename
	return l
end

function gt_object:update(layer, dt)
	-- I am just the default.
end

function gt_object:draw(layer)
	if(self.filename~=nil) then
		local x, y=self.x-layer.camera.x, self.y-layer.camera.y
		love.graphics.setColor(255, 255, 255, self.opacity)
		love.graphics.draw(self.image, x, y)
		love.graphics.setColor(255, 255, 255, 255)	
	end
end