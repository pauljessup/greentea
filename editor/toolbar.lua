gt_toolbar=Class{}
gt_toolbar:include(gt_transition)

function gt_toolbar:weight_sort(a,b) return a.weight < b.weight end

function gt_toolbar:init(name, transition, x, y, orientation, padding, editor, col, outline)
	self.name=name
	--load all the tool plugins based on name.
	self.tools={}
	
	self.folder=editor.plugin_directory .. "/" .. name .. "/"
	local files = love.filesystem.getDirectoryItems(self.folder)
	local id=#editor.tools
	for num, name in pairs(files) do
		if(love.filesystem.isFile(self.folder .. name)) then
			id=id+1
			local cls=love.filesystem.load(self.folder .. name)()
			if(cls~=nil) then 
				local widget=cls(editor, 0, 0, id)
				table.insert(editor.tools, widget) --for focus purposes. mostly.
				table.insert(self.tools, {id=id, weight=widget.weight}) -- creates a reference.
				table.sort(self.tools, function (a,b) return a.weight < b.weight end)
			end
		end
	end	
	local tx, ty, tw, th=x+padding, y+padding, padding*2, padding*2	
	for i,v in ipairs(self.tools) do
		local widget=editor.tools[v.id]
				editor.tools[v.id].x, editor.tools[v.id].y=tx, ty
				editor.tools[v.id]:set_tooltip(editor, editor.tools[v.id].tooltip)		
				if(orientation=="vertical") then
					ty=ty+widget.height+padding+(padding/2)
					th=th+widget.height+padding+(padding/2)
					if(tw<widget.width+padding) then tw=widget.width+(padding*2) end
				else
					tx=tx+widget.width+padding+(padding/2)
					tw=tw+widget.height+padding+(padding/2)	
					if(th<widget.height+padding) then th=widget.height+(padding*2) end					
				end
	end
	
	editor.window_color.alpha=175
	editor.frame_color.alpha=200
	if(col==nil) then col=editor.window_color end
	if(outline==nil) then outline=editor.window_color end
	gt_transition.init(self, transition, x, y, tw, th, col, outline, editor)
end

function gt_toolbar:open(editor)
	gt_transition.open(self, editor)
	for i,v in ipairs(self.tools) do
		editor.tools[v.id].hidden=false
	end
	return editor
end

function gt_toolbar:close(editor)
	gt_transition.close(self, editor)
	for i,v in ipairs(self.tools) do
		editor.tools[v.id].hidden=true
	end
	return editor
end

function gt_toolbar:update(dt, editor)
	for i,v in ipairs(self.tools) do
		if(self.opened) then  editor=editor.tools[v.id]:update(dt, editor) end
	end
	gt_transition.update(self, dt)
	return editor
end

function gt_toolbar:draw(editor)
	gt_frame.draw(self)
	for i,v in ipairs(self.tools) do
		if(self.opened) then editor.tools[v.id]:draw(editor) end
	end
end