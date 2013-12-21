gt_focus=Class{}

function gt_focus:init()
	self.stack={}
	self.current=0
end

function gt_focus:gain(widget)
	table.insert(self.stack, widget)
	self.current=self.current+1
end

function gt_focus:lose()
	table.remove(self.stack)
	self.curent=self.current-1
end

function gt_focus:get()
	if(self.current>0) then
		return self.stack[self.current]
	end
	return false
end