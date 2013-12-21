gt_frame=Class{}

function gt_frame:init(x, y, w, h, col, outline)
	self.x=x
	self.y=y
	self.width=w
	self.height=h
	self.col=col
	self.outline=outline
end

function gt_frame:update(dt)

end

function gt_frame:draw()
		   love.graphics.setLineStyle("rough")

		   love.graphics.setColor(self.col.r, self.col.g, self.col.b, self.col.alpha)		   
		   love.graphics.rectangle("fill", self.x, self.y+1, self.width, self.height-1)
		   		   
		   love.graphics.setColor(self.outline.r, self.outline.g, self.outline.b, self.outline.alpha)

		   -- RIGHT HAND SIDE
		   love.graphics.line(self.x+self.width, self.y+1, self.x+self.width, self.y+self.height-1)
		   -- TOP
		   love.graphics.line(self.x+1, self.y, self.x+self.width-1, self.y)
		   --BOTTOM
		   love.graphics.line(self.x+1, self.y+self.height, self.x+self.width-1, self.y+self.height)
		   -- LEFT HAND SIDE
		   love.graphics.line(self.x, self.y+1, self.x, self.y+self.height-1)
	   
			love.graphics.setPointSize(3)
		   --pixel top left hand side
		   love.graphics.point(self.x+.5, self.y+.5)
		   --pixel top right hand side
		   love.graphics.point(self.x+((self.width)-.5), self.y+.5)
		   --pixel bottom right hand side
		   love.graphics.point(self.x+.5, self.y+(self.height)-0.5)
		   --pixel top bottom hand left side
		   love.graphics.point(self.x+((self.width)-.5), self.y+(self.height)-0.5)		   

		   love.graphics.setLineStyle("smooth")
		   love.graphics.setColor(255, 255, 255, 255)	
end