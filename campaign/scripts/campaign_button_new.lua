-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sRecordType = "";

function onInit()
	if class then
		setRecordType(class[1]);
	end
end

function setRecordType(sNewRecordType)
	sRecordType = sNewRecordType;
end

function onButtonPress()
	if Session.IsHost then
		if window.clearFilterValues then
			window.clearFilterValues();
		end
		local node = DB.createChild(window.getDatabaseNode());
		if node then
			local w = Interface.openWindow(sRecordType, DB.getPath(node));
			if w and w.name then
				w.name.setFocus();
			elseif w.header and w.header.subwindow and w.header.subwindow.name then
				w.header.subwindow.name.setFocus();
			end
		end
	else
		local nodeWin = window.getDatabaseNode();
		if nodeWin then
			Interface.requestNewClientWindow(sRecordType, DB.getPath(nodeWin));
		end
	end
	
	window.list_iedit.setValue(0);
end
