gt_toolbar=Class{}
gt_toolbar:include(gt_transition)

function gt_toolbar:init(name, transition, x, y, orientation, padding, editor)
	self.name=name
	--load all the tool plugins based on name.
	self.tools={}
	
	self.folder=editor.plugin_directory .. "/" .. name .. "/"
	local files = love.filesystem.getDirectoryItems(self.folder)
	local id=#editor.tools
	local tx, ty, tw, th=x+padding, y+padding, padding*2, padding*2
	for num, name in pairs(files) do
		if(love.filesystem.isFile(self.folder .. name)) then
			id=id+1
			local cls=love.filesystem.load(self.folder .. name)()
			if(cls~=nil) then 
				local widget=cls(editor, tx, ty, id)
				if(orientation=="vertical") then
					ty=ty+widget.height+padding
					th=th+widget.height+padding
					if(tw<widget.width+padding) then tw=widget.width+(padding*2) end
				else
					tx=tx+widget.width+padding
					tw=tw+widget.height+padding					
					if(th<widget.height+padding) then th=widget.height+(padding*2) end					
				end
				table.insert(editor.tools, widget) --for focus purposes. mostly.
				table.insert(self.tools, id) -- creates a reference.
			end
		end
	end	
	editor.window_color.alpha=100
	editor.frame_color.alpha=190
	gt_transition.init(self, transition, x, y, tw, th, editor.window_color, editor.frame_color, editor)
end

function gt_toolbar:update(dt, editor)
	for i,v in ipairs(self.tools) do
		editor=editor.tools[v]:update(dt, editor)
	end
	gt_transition.update(self, dt)
	return editor
end

function gt_toolbar:draw(editor)
	gt_frame.draw(self)
	for i,v in ipairs(self.tools) do
		if(self.opened) then editor.tools[v]:draw(editor) end
	end
end