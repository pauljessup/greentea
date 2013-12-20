--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2013 Kenny Shields --
--]]------------------------------------------------

-- tooltip clas
local newobject = loveframes.NewObject("tooltip", "loveframes_object_tooltip", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize(object, text)
	
	self.type = "tooltip"
	self.parent = loveframes.base
	self.object = object or nil
	self.width = 0
	self.height = 0
	self.padding = 5
	self.xoffset = 10
	self.yoffset = -10
	self.internal = true
	self.show = false
	self.followcursor = true
	self.followobject = false
	self.alwaysupdate = true
	self.internals = {}
	
	-- create the object's text
	local textobject = loveframes.Create("text")
	textobject:Remove()
	textobject.parent = self
	textobject:SetText(text or "")
	textobject:SetPos(0, 0)
	table.insert(self.internals, textobject)
	
	-- apply template properties to the object
	loveframes.templates.ApplyToObject(self)
	table.insert(loveframes.base.internals, self)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function newobject:update(dt)

	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	local internals = self.internals
	local textobject = internals[1]
	local padding = self.padding
	local object = self.object
	local draworder = self.draworder
	local update = self.Update
	
	self.width = textobject.width + padding * 2
	self.height = textobject.height + padding * 2
	
	if object then
		if object == loveframes.base then
			self:Remove()
			return
		end
		local ovisible = object.visible
		local ohover = object.hover
		local ostate = object.state
		if ostate ~= state then
			self.show = false
			self.visible = false
			return
		end
		self.show = ohover
		self.visible = ovisible
		if ohover and ovisible then
			local top = self:IsTopInternal()
			local followcursor = self.followcursor
			local followobject = self.followobject
			local xoffset = self.xoffset
			local yoffset = self.yoffset
			if followcursor then
				local height = self.height
				local mx, my = love.mouse.getPosition()
				self.x = mx + xoffset
				self.y = my - height + yoffset
			elseif followobject then
				local ox = object.x
				local oy = object.y
				self.x = ox + xoffset
				self.y = oy + yoffset
			end
			if not top then
				self:MoveToTop()
			end
			textobject:SetPos(padding, padding)
		end
	end
	
	textobject:SetVisible(self.show)
	textobject:SetState(selfstate)
	textobject:update(dt)
	
	if update then
		update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function newobject:draw()
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local internals = self.internals
	local textobject = internals[1]
	local show = self.show
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawToolTip or skins[defaultskin].DrawToolTip
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
	
	if show then
		if draw then
			draw(self)
		else
			drawfunc(self)
		end
		textobject:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: SetFollowCursor(bool)
	- desc: sets whether or not the tooltip should follow the
			cursor
--]]---------------------------------------------------------
function newobject:SetFollowCursor(bool)

	self.followcursor = bool
	
end

--[[---------------------------------------------------------
	- func: SetObject(object)
	- desc: sets the tooltip's object
--]]---------------------------------------------------------
function newobject:SetObject(object)

	self.object = object
	self.x = object.x
	self.y = object.y
	
end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the tooltip's text
--]]---------------------------------------------------------
function newobject:SetText(text)

	local internals = self.internals
	local textobject = internals[1]
	
	textobject:SetText(text)
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the tooltip's text
--]]---------------------------------------------------------
function newobject:GetText()

	local internals = self.internals
	local textobject = internals[1]
	local text = textobject:GetText()
	
	return text
	
end

--[[---------------------------------------------------------
	- func: SetTextMaxWidth(text)
	- desc: sets the tooltip's text max width
--]]---------------------------------------------------------
function newobject:SetTextMaxWidth(width)

	local internals = self.internals
	local textobject = internals[1]
	
	textobject:SetMaxWidth(width)
	
end

--[[---------------------------------------------------------
	- func: SetOffsetX(xoffset)
	- desc: sets the tooltip's x offset
--]]---------------------------------------------------------
function newobject:SetOffsetX(xoffset)

	self.xoffset = xoffset
	
end

--[[---------------------------------------------------------
	- func: SetOffsetY(yoffset)
	- desc: sets the tooltip's y offset
--]]---------------------------------------------------------
function newobject:SetOffsetY(yoffset)

	self.yoffset = yoffset
	
end

--[[---------------------------------------------------------
	- func: SetOffsets(xoffset, yoffset)
	- desc: sets the tooltip's x and y offset
--]]---------------------------------------------------------
function newobject:SetOffsets(xoffset, yoffset)

	self.xoffset = xoffset
	self.yoffset = yoffset
	
end

--[[---------------------------------------------------------
	- func: SetPadding(padding)
	- desc: sets the tooltip's padding
--]]---------------------------------------------------------
function newobject:SetPadding(padding)

	self.padding = padding
	
end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the tooltip's font
--]]---------------------------------------------------------
function newobject:SetFont(font)

	local internals = self.internals
	local textobject = internals[1]
	
	textobject:SetFont(font)
	
end

--[[---------------------------------------------------------
	- func: SetFollowObject(bool)
	- desc: sets whether or not the tooltip should follow
			its assigned object
--]]---------------------------------------------------------
function newobject:SetFollowObject(bool)

	self.followobject = bool
	
end