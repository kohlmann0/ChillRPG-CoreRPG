-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local bLocked = false;
local sLink = nil;

function onInit()
	if super and super.onInit then
		super.onInit();
	end

	if self.update then
		self.update();
	end
end

function onClose()
	if sLink then
		DB.removeHandler(sLink, "onUpdate", onLinkUpdated);
	end
end

function onDrop(x, y, draginfo)
	if Session.IsHost then
		if draginfo.getType() ~= "number" then
			return false;
		end

		if self.handleDrop then
			self.handleDrop(draginfo);
			return true;
		end
	end
end

function onValueChanged()
	if sLink then
		if not bLocked then
			bLocked = true;

			if sLink and not isReadOnly() then
				DB.setValue(sLink, "number", getValue());
			end

			if self.update then
				self.update();
			end

			bLocked = false;
		end
	else
		if self.update then
			self.update();
		end
	end
end

function onLinkUpdated()
	if sLink and not bLocked then
		bLocked = true;

		setValue(DB.getValue(sLink, 0));
		
		if self.update then
			self.update();
		end

		bLocked = false;
	end
end

function setLink(dbnode, bLock)
	if sLink then
		DB.removeHandler(sLink, "onUpdate", onLinkUpdated);
		sLink = nil;
	end
		
	if dbnode then
		sLink = DB.getPath(dbnode);

		if bLock == true then
			setReadOnly(true);
		end

		DB.addHandler(sLink, "onUpdate", onLinkUpdated);
		onLinkUpdated();
	end
end

