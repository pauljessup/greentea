local example_template=Class{}
example_template:include(gt_template)

function example_template:init(values)
	-- we can do whatevs.
	gt_template.init(self, values)
end

function example_template:create(greentea)
	--this example creates a ground, and then a second ground (for details).
	--above that, it adds a fog layer that constantly scrolls.

		greentea:add_layer({id="ground", 
						opacity=255,  
						speed=1,
						default_tile=13
						})
						
		greentea:add_layer({id="details", 
						opacity=255, 
						speed=1,
						default_tile=0,
						})
						
		greentea:add_layer({id="shadows", 
						opacity=150, 
						speed=1,
						default_tile=0,
						type='collision'
						})						
						
		greentea:add_layer({id="walls", 
						opacity=255, 
						speed=1,
						default_tile=0,
						type='collision'
						})		

		greentea:add_layer({id="wall details", 
						opacity=255, 
						speed=1,
						default_tile=0,
						})
						
--[[ here's an example
	if you want to use a parallax scrolling fog layer.
	just uncomment out below.
	
	greentea:add_layer({
					id=#greentea.map.layers,
					type="parallax",
					opacity=155,
					speed=2,
					default_tile=1,
					tileset={
								id="fogtiles",
								tile_height=16,
								tile_width=16,
								image="game/maps/fogtiles.png",
							},
					values={scroll_x=0, scroll_y=.2}
				})
--]]				
	return greentea
end

return example_template