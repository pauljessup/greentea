gt_filesys=Class{}

function gt_filesys:init(plugin_directory)
	--get all the possible file formats--
	self.formats={}
	--1. get the main default (gtmap) format--
	table.insert(self.formats, gt_file_format())
	--2. get all of the formats in plugins/formats
	local files = love.filesystem.enumerate(plugin_directory .. "/formats/")
	for num, name in pairs(files) do
		if(love.filesystem.isFile(plugin_directory .. "/formats/" .. name)) then
			local cls=love.filesystem.load(plugin_directory .. "/formats/" .. name)()
			if(cls~=nil) then table.insert(self.formats, cls()) end
		end
	end	
end

function gt_filesys:get_format(file)
	for i, v in pairs(self.formats) do
		if(v:check(file)) then return v end
	end
	error("This file extension is not registered with a file format.")
end

function gt_filesys:load(file)
	local fformat=self:get_format(file)
	return fformat:load(file)
end

function gt_filesys:save(map, file)
	local fformat=self:get_format(file)
	fformat:save(map, love.filesystem.getWorkingDirectory() .. "/" .. file)
end