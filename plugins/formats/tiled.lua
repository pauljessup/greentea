tiled=Class{}

function tiled:init()
	self.name="Tiled File Format"
	self.ext="lua"
end

--checks to see if the file uses the correct extention.
function tiled:check(filename)
	if(string.match(filename, self.ext)==nil) then return false else return true end
end


function tiled:load(filename)
	local tmap=love.filesystem.load('game/assets/maps/' .. name .. ".lua")()
	local map=({		name=name,
						height=tmap.height, width=tmap.width, 
						tileset={id="imported", 
											image=map.tilesets[1].image, 
											tile_height=map.tileheight, 
											tile_width=map.tilewidth
								}
					})
	
	return map
end

function tiled:save(map, filename)
	local file = io.open(filename, "w")
	file:write("return " .. TSerial.pack(map:save_table()) )
	file:close()
end