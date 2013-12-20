--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2013 Kenny Shields --
--]]------------------------------------------------

-- frame object
local newobject = loveframes.NewObject("frame", "loveframes_object_frame", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()
	
	self.type = "frame"
	self.name = "Frame"
	self.width = 300
	self.height = 150
	self.clickx = 0
	self.clicky = 0
	self.dockx = 0
	self.docky = 0
	self.dockzonesize = 10
	self.internal = false
	self.draggable = true
	self.screenlocked = false
	self.parentlocked = false
	self.dragging = false
	self.modal = false
	self.modalbackground = false
	self.showclose = true
	self.dockedtop = false
	self.dockedbottom = false
	self.dockedleft = false
	self.dockedright = false
	self.topdockobject = false
	self.bottomdockobject = false
	self.leftdockobject = false
	self.rightdockobject = false
	self.dockable = false
	self.internals = {}
	self.children = {}
	self.icon = nil
	self.OnClose = nil
	self.OnDock = nil
	
	-- create docking zones
	self.dockzones = 
	{
		top = {x = 0, y = 0, width = 0, height = 0},
		bottom = {x = 0, y = 0, width = 0, height = 0},
		left = {x = 0, y = 0, width = 0, height = 0},
		right = {x = 0, y = 0, width = 0, height = 0}
	}
	
	-- create the close button for the frame
	local close = loveframes.objects["closebutton"]:new()
	close.parent = self
	close.OnClick = function(x, y, object)
		local onclose = object.parent.OnClose
		object.parent:Remove()
		if onclose then
			onclose(object.parent)
		end
	end
	
	table.insert(self.internals, close)
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the element
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
	
	local mx, my = love.mouse.getPosition()
	local width = self.width
	local height = self.height
	local showclose = self.showclose
	local close = self.internals[1]
	local dragging = self.dragging
	local screenlocked = self.screenlocked
	local parentlocked = self.parentlocked
	local modal = self.modal
	local base = loveframes.base
	local basechildren = base.children
	local numbasechildren = #basechildren
	local draworder = self.draworder
	local dockedtop = self.dockedtop
	local dockedbottom = self.dockedbottom
	local dockedleft = self.dockedleft
	local dockedright = self.dockedright
	local dockable = self.dockable
	local dockzonesize = self.dockzonesize
	local children = self.children
	local internals = self.internals
	local parent = self.parent
	local update = self.Update
	
	self:CheckHover()
	
	-- update dockzones
	self.dockzones.top = {x = self.x, y = self.y - dockzonesize, width = self.width, height = dockzonesize}
	self.dockzones.bottom = {x = self.x, y = self.y + self.height, width = self.width, height = dockzonesize}
	self.dockzones.left = {x = self.x - dockzonesize, y = self.y, width = dockzonesize, height = self.height}
	self.dockzones.right = {x = self.x + self.width, y = self.y, width = dockzonesize, height = self.height}
	
	-- dragging check
	if dragging then
		if parent == base then
			if not dockedtop and not dockedbottom then
				self.y = my - self.clicky
			end
			if not dockedleft and not dockedright then
				self.x = mx - self.clickx
			end
			local basechildren = loveframes.base.children
			-- check for frames to dock with
			if dockable then
				local ondock = self.OnDock
				for k, v in ipairs(basechildren) do
					if v.type == "frame" then
						local topcol = loveframes.util.RectangleCollisionCheck(self.dockzones.bottom, v.dockzones.top)
						local botcol = loveframes.util.RectangleCollisionCheck(self.dockzones.top, v.dockzones.bottom)
						local leftcol = loveframes.util.RectangleCollisionCheck(self.dockzones.right, v.dockzones.left)
						local rightcol = loveframes.util.RectangleCollisionCheck(self.dockzones.left, v.dockzones.right)
						local candockobject = v.dockable
						if candockobject then
							if topcol and not dockedtop then
								self.y = v.y - self.height
								self.docky = my
								self.dockedtop = true
								self.topdockobject = v
								if ondock then
									ondock(object, v)
								end
							elseif botcol and not dockedbottom then
								self.y = v.y + v.height
								self.docky = my
								self.dockedbottom = true
								self.bottomdockobject = v
								if ondock then
									ondock(object, v)
								end
							elseif leftcol and not dockedleft then
								self.x = v.x - self.width
								self.dockx = mx
								self.dockedleft = true
								self.leftdockobject = v
								if ondock then
									ondock(object, v)
								end
							elseif rightcol and not dockedright then
								self.x = v.x + v.width
								self.dockx = mx
								self.dockedright = true
								self.rightdockobject = v
								if ondock then
									ondock(object, v)
								end
							end
						end
					end
				end
			end
			local dockx = self.dockx
			local docky = self.docky
			local x = self.x
			local y = self.y
			-- check to see if the frame should be undocked
			if dockedtop then
				local topdockobject = self.topdockobject
				local tdox = topdockobject.x
				local tdowidth = topdockobject.width
				if my > (docky + 20) or my < (docky - 20) or (x + width) < tdox or x > (tdox + tdowidth) then
					self.dockedtop = false
					self.docky = 0
				end
			end
			if dockedbottom then
				local bottomdockobject = self.bottomdockobject
				local bdox = bottomdockobject.x
				local bdowidth = bottomdockobject.width
				if my > (docky + 20) or my < (docky - 20) or (x + width) < bdox or x > (bdox + bdowidth) then
					self.dockedbottom = false
					self.docky = 0
				end
			end
			if dockedleft then
				local leftdockobject = self.leftdockobject
				local ldoy = leftdockobject.y
				local ldoheight = leftdockobject.height
				if mx > (dockx + 20) or mx < (dockx - 20) or (y + height) < ldoy or y > (ldoy + ldoheight) then
					self.dockedleft = false
					self.dockx = 0
				end
			end
			if dockedright then
				local rightdockobject = self.rightdockobject
				local rdoy = rightdockobject.y
				local rdoheight = rightdockobject.height
				if mx > (dockx + 20) or mx < (dockx - 20) or (y + height) < rdoy or y > (rdoy + rdoheight) then
					self.dockedright = false
					self.dockx = 0
				end
			end
		else
			self.staticx = mx - self.clickx
			self.staticy = my - self.clicky
		end
	end
	
	-- if screenlocked then keep within screen
	if screenlocked then
		local screenwidth = love.graphics.getWidth()
		local screenheight = love.graphics.getHeight()
		local x = self.x
		local y = self.y
		if x < 0 then
			self.x = 0
		end
		if x + width > screenwidth then
			self.x = screenwidth - width
		end
		if y < 0 then
			self.y = 0
		end
		if y + height > screenheight then
			self.y = screenheight - height
		end
	end
	
	-- keep the frame within its parent's boundaries if parentlocked
	if parentlocked then
		local parentwidth = self.parent.width
		local parentheight = self.parent.height
		local staticx = self.staticx
		local staticy = self.staticy
		if staticx < 0 then
			self.staticx = 0
		end
		if staticx + width > parentwidth then
			self.staticx = parentwidth - width
		end
		if staticy < 0 then
			self.staticy = 0
		end
		if staticy + height > parentheight then
			self.staticy = parentheight - height
		end
	end
	
	if modal then
		local tip = false
		local key = 0
		for k, v in ipairs(basechildren) do
			if v.type == "tooltip" and v.show then
				tip = v
				key = k
			end
		end
		if tip then
			self:Remove()
			self.modalbackground:Remove()
			table.insert(basechildren, key - 2, self.modalbackground)
			table.insert(basechildren, key - 1, self)
		end
		if self.modalbackground.draworder > self.draworder then
			self:MakeTop()
		end
	end
	
	if parent ~= base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	for k, v in ipairs(internals) do
		v:update(dt)
	end
	
	for k, v in ipairs(children) do
		v:update(dt)
	end
	
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
	
	local children = self.children
	local internals = self.internals
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawFrame or skins[defaultskin].DrawFrame
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
	for k, v in ipairs(internals) do
		v:draw()
	end
	
	-- loop through the object's children and draw them
	for k, v in ipairs(children) do
		v:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function newobject:mousepressed(x, y, button)
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local width = self.width
	local height = self.height
	local selfcol = loveframes.util.BoundingBox(x, self.x, y, self.y, 1, self.width, 1, self.height)
	local internals = self.internals
	local children = self.children
	local dragging = self.dragging
	local parent = self.parent
	local base = loveframes.base
	
	if selfcol then
		-- initiate dragging if not currently dragging
		if not dragging and self.hover and button == "l" then
			if y < self.y + 25 and self.draggable then
				if parent == base then
					self.clickx = x - self.x
					self.clicky = y - self.y
				else
					self.clickx = x - self.staticx
					self.clicky = y - self.staticy
				end
				self.dragging = true
			end
		end
		if self.hover and button == "l" then
			self:MakeTop()
		end
	end
	
	for k, v in ipairs(internals) do
		v:mousepressed(x, y, button)
	end
		
	for k, v in ipairs(children) do
		v:mousepressed(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function newobject:mousereleased(x, y, button)
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local dragging = self.dragging
	local children = self.children
	local internals = self.internals
	
	-- exit the dragging state
	if dragging then
		self.dragging = false
	end
	
	for k, v in ipairs(internals) do
		v:mousereleased(x, y, button)
	end
	
	for k, v in ipairs(children) do
		v:mousereleased(x, y, button)
	end
	
end

--[[---------------------------------------------------------
	- func: SetName(name)
	- desc: sets the object's name
--]]---------------------------------------------------------
function newobject:SetName(name)

	self.name = name
	
end

--[[---------------------------------------------------------
	- func: GetName()
	- desc: gets the object's name
--]]---------------------------------------------------------
function newobject:GetName()

	return self.name
	
end

--[[---------------------------------------------------------
	- func: SetDraggable(true/false)
	- desc: sets whether the object can be dragged or not
--]]---------------------------------------------------------
function newobject:SetDraggable(bool)

	self.draggable = bool
	
end

--[[---------------------------------------------------------
	- func: GetDraggable()
	- desc: gets whether the object can be dragged ot not
--]]---------------------------------------------------------
function newobject:GetDraggable()

	return self.draggable
	
end


--[[---------------------------------------------------------
	- func: SetScreenLocked(bool)
	- desc: sets whether the object can be moved passed the
			boundaries of the window or not
--]]---------------------------------------------------------
function newobject:SetScreenLocked(bool)

	self.screenlocked = bool
	
end

--[[---------------------------------------------------------
	- func: GetScreenLocked()
	- desc: gets whether the object can be moved passed the
			boundaries of window or not
--]]---------------------------------------------------------
function newobject:GetScreenLocked()

	return self.screenlocked
	
end

--[[---------------------------------------------------------
	- func: ShowCloseButton(bool)
	- desc: sets whether the object's close button should 
			be drawn
--]]---------------------------------------------------------
function newobject:ShowCloseButton(bool)

	local close = self.internals[1]

	close.visible = bool
	self.showclose = bool
	
end

--[[---------------------------------------------------------
	- func: MakeTop()
	- desc: makes the object the top object in the drawing
			order
--]]---------------------------------------------------------
function newobject:MakeTop()
	
	local x, y = love.mouse.getPosition()
	local key = 0
	local base = loveframes.base
	local basechildren = base.children
	local numbasechildren = #basechildren
	local parent = self.parent
	
	-- check to see if the object's parent is not the base object
	if parent ~= base then
		local baseparent = self:GetBaseParent()
		if baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		return
	end
	
	-- check to see if the object is the only child of the base object
	if numbasechildren == 1 then
		return
	end
	
	-- check to see if the object is already at the top
	if basechildren[numbasechildren] == self then
		return
	end
	
	-- make this the top object
	for k, v in ipairs(basechildren) do
		if v == self then
			table.remove(basechildren, k)
			table.insert(basechildren, self)
			key = k
			break
		end
	end
	
end

--[[---------------------------------------------------------
	- func: SetModal(bool)
	- desc: sets whether or not the object is in a modal
			state
--]]---------------------------------------------------------
function newobject:SetModal(bool)

	local modalobject = loveframes.modalobject
	local mbackground = self.modalbackground
	local parent = self.parent
	local base = loveframes.base
	
	if parent ~= base then
		return
	end
	
	self.modal = bool
	
	if bool then
		if modalobject then
			modalobject:SetModal(false)
		end
		loveframes.modalobject = self
		if not mbackground then
			self.modalbackground = loveframes.objects["modalbackground"]:new(self)
			self.modal = true
		end
	else
		if modalobject == self then
			loveframes.modalobject = false
			if mbackground then
				self.modalbackground:Remove()
				self.modalbackground = false
				self.modal = false
			end
		end
	end
	
end

--[[---------------------------------------------------------
	- func: GetModal()
	- desc: gets whether or not the object is in a modal
			state
--]]---------------------------------------------------------
function newobject:GetModal()

	return self.modal
	
end

--[[---------------------------------------------------------
	- func: SetVisible(bool)
	- desc: set's whether the object is visible or not
--]]---------------------------------------------------------
function newobject:SetVisible(bool)

	local children = self.children
	local internals = self.internals
	local closebutton = internals[1]
	
	self.visible = bool
	
	for k, v in ipairs(children) do
		v:SetVisible(bool)
	end

	if self.showclose then
		closebutton.visible = bool
	end
	
end

--[[---------------------------------------------------------
	- func: SetParentLocked(bool)
	- desc: sets whether the object can be moved passed the
			boundaries of its parent or not
--]]---------------------------------------------------------
function newobject:SetParentLocked(bool)

	self.parentlocked = bool
	
end

--[[---------------------------------------------------------
	- func: GetParentLocked(bool)
	- desc: gets whether the object can be moved passed the
			boundaries of its parent or not
--]]---------------------------------------------------------
function newobject:GetParentLocked()

	return self.parentlocked
	
end

--[[---------------------------------------------------------
	- func: SetIcon(icon)
	- desc: sets the object's icon
--]]---------------------------------------------------------
function newobject:SetIcon(icon)
	
	if type(icon) == "string" then
		self.icon = love.graphics.newImage(icon)
	else
		self.icon = icon
	end
	
end

--[[---------------------------------------------------------
	- func: GetIcon()
	- desc: gets the object's icon
--]]---------------------------------------------------------
function newobject:GetIcon()

	local icon = self.icon
	
	if icon then
		return icon
	end
	
	return false
	
end

--[[---------------------------------------------------------
	- func: SetDockable(dockable)
	- desc: sets whether or not the object can dock onto
			another object of its type or be docked 
			by another object of its type
--]]---------------------------------------------------------
function newobject:SetDockable(dockable)

	self.dockable = dockable

end

--[[---------------------------------------------------------
	- func: GetDockable()
	- desc: gets whether or not the object can dock onto
			another object of its type or be docked 
			by another object of its type
--]]---------------------------------------------------------
function newobject:GetDockable()

	return self.dockable
	
end

--[[---------------------------------------------------------
	- func: SetDockZoneSize(size)
	- desc: sets the size of the object's docking zone
--]]---------------------------------------------------------
function newobject:SetDockZoneSize(size)

	self.dockzonesize = size
	
end

--[[---------------------------------------------------------
	- func: GetDockZoneSize(size)
	- desc: gets the size of the object's docking zone
--]]---------------------------------------------------------
function newobject:GetDockZoneSize()

	return self.dockzonesize

end