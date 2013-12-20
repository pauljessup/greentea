gt_file_format=Class{}

function gt_file_format:init()
	self.name="Green Tea File Format"
	self.ext="gtmap"
end

--checks to see if the file uses the correct extention.
function gt_file_format:check(filename)
	if(string.match(filename, self.ext)==nil) then return false else return true end
end


function gt_file_format:load(filename)
    --local file
    --file = io.open(filename, "r")
    --local map=gt_map(TSerial.unpack(file:read("*all")))
	map=love.filesystem.load(filename)()
    --file:close()
	return map
end

function gt_file_format:save(map, filename)
	local file = io.open(filename, "w")
	file:write("return " .. TSerial.pack(map:save_table()) )
	file:close()
end