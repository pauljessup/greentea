gt_object=Class{}

function gt_object:init(object_table)
	self.id=object_table.id
	self.type=object_table.type
	if(object_table.opacity==nil) then object_table.opacity=255 end
	self.hidden=object_table.hidden
	self.x=object_table.x
	self.y=object_table.y
	self.init=false
	if(object_table.image~=nil) then 
		self.image=love.graphics.newImage(object_table.image) 
		self.width=self.image:getWidth()
		self.height=self.image:getHeight()
		self.filename=object_table.image
	end
	if(object_table.editor_image==nil) then
		self.editor_image="placeholder.png"
	end
	self.speed=object_table.speed
	self.opacity=object_table.opacity
	self.layer=object_table.layer
	self.values=object_table.values
end

-- where object has a h/w/x/y and layer properties
function gt_object:check_collision(object)
 if(self.width==nil) then self.width=self.image:getWidth() end
 if(self.height==nil) then self.height=self.image:getHeight() end
 
 if(object.layer~=self.layer) then return false end
 
 return object.x < self.x+self.width and
         self.x < object.x+object.width and
         object.y < self.y+self.height and
         self.y < object.y+object.height	
end

function gt_object:collide(map, object)
	
	return map, object
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
	l.values=self.values
	return l
end

function gt_object:update(map, dt)
	-- I am just the default.
	return map
end

function gt_object:draw(layer)
	if(self.filename~=nil) then
		local x, y=self.x-layer.camera.x, self.y-layer.camera.y
		love.graphics.setColor(255, 255, 255, self.opacity)
		love.graphics.draw(self.image, x, y)
		love.graphics.setColor(255, 255, 255, 255)	
	end
end

function gt_object:editor_init(editor)
	if(not self.init) then
			if(self.editor_image~=nil) then
				self.editor_image=editor.asset_directory .. "/" .. self.editor_image 
			end
			self.init=true
	end
		if(self.image==nil) and self.id~="unique" then
			self.filename=self.editor_image
			self.image=love.graphics.newImage(self.filename) 
			self.width=self.image:getWidth()
			self.height=self.image:getHeight()	
		end
		self.edit_image=love.graphics.newImage(self.editor_image)	
end

function gt_object:editor_draw(layer)
	if(self.editor_image~=nil) then
		local x, y=self.x-layer.camera.x, self.y-layer.camera.y
		love.graphics.setColor(255, 255, 255, self.opacity)
		love.graphics.draw(self.edit_image, x, y)
		love.graphics.setColor(255, 255, 255, 255)	
	end
end

function gt_object:editor_select_draw()
		love.graphics.draw(self.edit_image, self.x, self.y)
end