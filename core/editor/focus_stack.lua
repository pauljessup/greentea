gt_focus=Class{}

function gt_focus:init()
	self.stack={}
end

function gt_focus:gain(widget)
	table.insert(self.stack, widget)
end

function gt_focus:lose()
	table.remove(self.stack)
end

function gt_focus:get()
	if(#self.stack>0) then
		return self.stack[#self.stack]
	else
		return false
	end
end
