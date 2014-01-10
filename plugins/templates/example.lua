local example_template=Class{}
example_template:include(gt_template)

function example_template:init(values)
	-- we can do whatevs.
	gt_template.init(self, values)
end

function example_template:create(greentea)
	--this example creates a ground, and then a second ground (for details).
	--above that, it adds a wall layer that is a collision layer. Everything on the wall
	--layer forces a collision when something runs into it.

		greentea:add_layer({id="ground", 
						opacity=255,  
						speed=1,
						default_tile=4,
						tileset={
								id="ground",
								tile_height=16,
								tile_width=16,
								image="game/maps/ground.png",
							}
						})
						
		greentea:add_layer({id="details", 
						opacity=255, 
						speed=1,
						default_tile=0,
						tileset={
								id="details",
								tile_height=16,
								tile_width=16,
								image="game/maps/details.png",
							}
						})
												
		greentea:add_layer({id="walls", 
						opacity=255, 
						speed=1,
						default_tile=0,
						type='collision',
						tileset={
								id="walls",
								tile_height=16,
								tile_width=16,
								image="game/maps/walls.png",
								anims={
											{ frames={19, 20}, speed=1}, -- frames to animate through, speed of animation. Lower is slower.
									  }										
							}
						})		
	return greentea
end

return example_template