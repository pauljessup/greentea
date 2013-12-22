gt_transition=Class{}
gt_transition:include(gt_frame)

function gt_transition:init(transition, x, y, w, h, col, outline, editor)
	self.transition=transition
	self.original={x=x, y=y, w=w, h=h}
	self.camera_width=editor.sys.map.camera.width	
	self.camera_height=editor.sys.map.camera.height
	
	self.opened=false
	self.closed=false
	self.opening=false
	self.closing=false
	gt_frame.init(self, x, y, w, h, col, outline)
	self:get_starting()
end

function gt_transition:open()
	self.closed=false
	self.opening=true
	self:get_starting()
end

function gt_transition:close()
	self.opened=false
	self.closing=true
	self:get_ending()
end

function gt_transition:get_starting()
	self.targetx=self.original.x
	self.targety=self.original.y
	self.targeth=self.original.h

	if(self.transition=="slideup") then
		self.y=self.camera_height+self.height
	elseif(self.transition=="slidedown") then
		self.y=0-self.height		
	elseif(self.transition=="slideleft") then
		self.x=0-self.width
	elseif(self.transition=="slideright") then
		self.x=self.camera.width+self.width
	elseif(self.transition=="open") then
		self.height=0
	end
end

function gt_transition:get_ending()
	if(self.transition=="slideup") then
		self.targety=self.camera_height+self.height
	elseif(self.transition=="slidedown") then
		self.targety=0-self.height		
	elseif(self.transition=="slideleft") then
		self.targetx=0-self.width
	elseif(self.transition=="slideright") then
		self.targetx=self.camera.width+self.width
	elseif(self.transition=="open") then
		self.height=0
	end
end

function gt_transition:check_open()
	if(self.transition=="slideup") then
		if(self.y<=self.targety) then
			self.y=self.targety
			self.opening=false
			self.opened=true
		end
	elseif(self.transition=="slidedown") then
		if(self.y>=self.targety) then
			self.y=self.targety
			self.opening=false
			self.opened=true
		end
	elseif(self.transition=="slideleft") then
		if(self.x>=self.targetx) then
			self.x=self.targetx
			self.opening=false
			self.opened=true
		end
	elseif(self.transition=="slideright") then
		if(self.x<=self.targetx) then
			self.x=self.targetx
			self.opening=false
			self.opened=true
		end	
	elseif(self.transition=="open") then
		if(self.x>=self.targeth) then
			self.x=self.targeth
			self.opening=false
			self.opened=true
		end
	end	
end

function gt_transition:check_closed()
	if(self.transition=="slideup") then
		if(self.y>=self.targety) then
			self.y=self.targety
			self.closing=false
			self.closed=true
		end
	elseif(self.transition=="slidedown") then
		if(self.y<=self.targety) then
			self.y=self.targety
			self.closing=false
			self.closed=true
		end
	elseif(self.transition=="slideleft") then
		if(self.x<=self.targetx) then
			self.x=self.targetx
			self.closing=false
			self.closed=true
		end
	elseif(self.transition=="slideright") then
		if(self.x>=self.targetx) then
			self.x=self.targetx
			self.closing=false
			self.closed=true
		end	
	elseif(self.transition=="open") then
		if(self.x<=self.targeth) then
			self.x=self.targeth
			self.closing=false
			self.closed=true
		end
	end	
end


function gt_transition:update(dt)
	if(self.opening) then
			if(self.transition=="slideup") then
				self.y=self.y-4
			elseif(self.transition=="slidedown") then
				self.y=self.y+4		
			elseif(self.transition=="slideleft") then
				self.x=self.x+4
			elseif(self.transition=="slideright") then
				self.x=self.x-4
			elseif(self.transition=="open") then
				self.height=self.height+4
			end
			self:check_open()
	elseif(self.closing) then
			if(self.transition=="slideup") then
				self.y=self.y+4
			elseif(self.transition=="slidedown") then
				self.y=self.y-4		
			elseif(self.transition=="slideleft") then
				self.x=self.x-4
			elseif(self.transition=="slideright") then
				self.x=self.x+4
			elseif(self.transition=="open") then
				self.height=self.height-4
			end	
			self:check_closed()
	end
end
