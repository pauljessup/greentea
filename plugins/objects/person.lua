local test=Class{}
test:include(gt_object)

function test:init(object_table)
	gt_object.init(self, object_table)
end

return test