gt_widget=Class{}

function gt_widget:init(editor, x, y, id, tooltip)
	self.id=id
	self.x, self.y=x,y
	self.width, self.height=0,0
	self.tooltip=tooltip
	self.is_hover=false
	self.hover_tip=gt_frame(x+3, y-7, editor.font.font:getWidth(tooltip)+5, editor.font.font:getHeight()+5, {r=0, g=0, b=0, alpha=100}, {r=0, g=0, b=0, alpha=255}) 
	self.focus=false
end

function gt_widget:add_button(editor,filename)
	self.button={}
	self.button.active=false
	self.button.hidden=false
	self.button.image=love.graphics.newImage(editor.asset_directory .. "/" .. filename)
	self.height=self.button.image:getHeight()
	self.width=self.button.image:getWidth()
end

function gt_widget:gain_focus(editor)
	self.focus=true
	editor.focus:gain(self.id)
	return editor
end

function gt_widget:lose_focus(editor)
	self.focus=false
	editor.focus:lose()
	return editor
end


function gt_widget:update(dt, editor)

return editor
end

function gt_widget:mouse_pressed(editor)
	if(self.button~=nil) then self.button.active=true end
return editor
end

function gt_widget:mouse_hover(editor)
	self.is_hover=true
return editor
end

function gt_widget:map_pressed(editor)

return editor
end

function gt_widget:map_hover(editor)

return editor
end

function gt_widget:draw(editor)
	if(self.button~=nil) and (not self.button.hidden) then
			love.graphics.draw(self.button.image, self.x, self.y)
			if(self.button.active) then
					love.graphics.setColor(87, 187, 87, 100)		   
					love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
					love.graphics.setColor(255, 255, 255, 255)		   
			end
	end
	if(self.is_hover) then 
		self.hover_tip:draw()
		love.graphics.print(self.tooltip, self.x+5, self.y-5) self.is_hover=false 
	end
end