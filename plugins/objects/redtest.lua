local test=Class{}
test:include(gt_object)

function test:init(object_table)
	object_table.image="game/objects/test.png"
	object_table.id="unique"
	gt_object.init(self, object_table)
end

return test