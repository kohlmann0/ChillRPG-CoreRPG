-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if initbyname then
		ToolbarManager.initButton(self, getName());
	end
end

local _sKey;
function getKey()
	return _sKey;
end
function setKey(s)
	_sKey = s;
end

function addDatabaseEvent(sEvent, fnEvent)
	local w = UtilityManager.getTopWindow(window);
	local node = w.getDatabaseNode();
	if node then
		DB.addHandler(node, sEvent, function () fnEvent(self) end);
	end
end

function onButtonPress()
	ToolbarManager.activateButtonAction(self);
end
function onDragStart(_, _, _, draginfo)
	return ToolbarManager.dragButtonAction(self, draginfo);
end
