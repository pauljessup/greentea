local player=Class{}
player:include(gt_object)

function player:init(object_table)
	object_table.image="player.png"
	gt_object.init(self, object_table)
	
	self.open=false
	self.width=16
	self.height=16
	self.sprites={
					up={
								love.graphics.newQuad(0, 0, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(16, 0, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(32, 0, 16, 18, self.image:getWidth(), self.image:getHeight())
						},	
					right={
								love.graphics.newQuad(0, 18, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(16, 18, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(32, 18, 16, 18, self.image:getWidth(), self.image:getHeight())					
						},						
					down={
								love.graphics.newQuad(0, 36, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(16, 36, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(32, 36, 16, 18, self.image:getWidth(), self.image:getHeight())					
						},
					left={
								love.graphics.newQuad(0, 54, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(16, 54, 16, 18, self.image:getWidth(), self.image:getHeight()),
								love.graphics.newQuad(32, 54, 16, 18, self.image:getWidth(), self.image:getHeight())					
						}						
				}
	self.walk={}
	self.walk.dir=self.sprites.down
	self.walk.frame=1
	self.walk.counter=0
end

--this makes it so that the player
--is not saved when we save the 
--map using the map editor.
function player:save_table()
	return nil
end

function player:collide(map, object)
	self:displace()
	map:displace()
end

function player:update(map, dt)
	local walking=false
	
	if(love.keyboard.isDown("up")) then
			self.walk.dir=self.sprites.up
			self:scroll(0, -1)
			walking=true
	elseif(love.keyboard.isDown("down")) then
			self.walk.dir=self.sprites.down
			self:scroll(0, 1)
			walking=true
	elseif(love.keyboard.isDown("left")) then
			self.walk.dir=self.sprites.left
			self:scroll(-1, 0)
			walking=true
	elseif(love.keyboard.isDown("right")) then
			self.walk.dir=self.sprites.right
			self:scroll(1, 0)
			walking=true
	end
	
	if(walking) then
			self.walk.counter=self.walk.counter+1
			if(self.walk.counter>10) then 
				self.walk.frame=self.walk.frame+1 
				self.walk.counter=0
				if(self.walk.frame>3) then self.walk.frame=1 end
			end
	end
	
return map
end

function player:draw(layer)
	gt_object.draw(self, layer, self.walk.dir[self.walk.frame])
end


return player