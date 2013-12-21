gt_frame=Class{}

function gt_frame:init(x, y, w, h, col, outline_col)
	self.x=x
	self.y=y
	self.w=w
	self.h=h
	self.col=col
	self.outline=outline
end

function gt_frame:update(dt)

end

function gt_frame:draw()
		   love.graphics.setLineStyle("rough")
		   love.graphics.setColor(self.outline.r, self.outline.g, self.outline.b, self.outline.alpha)

		   -- RIGHT HAND SIDE
		   love.graphics.line(self.x+self.width-1, self.y+2, self.x+self.width-1, self.y+self.height)
		   -- TOP
		   love.graphics.line(self.x+1, self.y+1, self.x+self.width-2, self.y+1)
		   --BOTTOM
		   love.graphics.line(self.x+1, self.y+self.height, self.x+self.width-2, self.y+self.height)
		   -- LEFT HAND SIDE
		   love.graphics.line(self.x+1, self.y+2, self.x+1, self.y+self.height)
	   
		   --pixel top right hand side
		   love.graphics.point(self.x+1.5, self.y+2.5)
		   --pixel top left hand side
		   love.graphics.point(self.x+((self.width-1)-1.5), self.y+2.5)
		   --pixel bottom right hand side
		   love.graphics.point(self.x+1.5, self.y+(self.height)-0.5)
		   --pixel top bottom hand left side
		   love.graphics.point(self.x+((self.width-1)-1.5), self.y+(self.height)-0.5)		   
		   
		   love.graphics.setLineStyle("smooth")
		   love.graphics.setColor(255, 255, 255, 255)	
end