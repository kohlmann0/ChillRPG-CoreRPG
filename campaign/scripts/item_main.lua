-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.update();
end
function VisDataCleared()
	self.update();
end
function InvisDataAdded()
	self.update();
end

function onDrop(x, y, draginfo)
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	if bReadOnly then
		return false;
	end
	return ItemManager.handleAnyDropOnItemRecord(nodeRecord, draginfo);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState("item", nodeRecord);
	
	local bSection1 = false;
	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly) then bSection1 = true; end;
	else
		WindowManager.callSafeControlUpdate(self, "nonid_name", bReadOnly, true);
	end
	if (Session.IsHost or not bID) then
		if WindowManager.callSafeControlUpdate(self, "nonid_notes", bReadOnly) then bSection1 = true; end;
	else
		WindowManager.callSafeControlUpdate(self, "nonid_notes", bReadOnly, true);
	end
	
	local bSection2 = false;
	if WindowManager.callSafeControlUpdate(self, "cost", bReadOnly, not bID) then bSection2 = true; end
	if WindowManager.callSafeControlUpdate(self, "weight", bReadOnly, not bID) then bSection2 = true; end

	local bSection3 = bID;
	notes.setVisible(bID);
	notes.setReadOnly(bReadOnly);
		
	divider.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);

	if ItemManager.isPack(nodeRecord) then
		sub_subitems.setValue("item_main_subitems", nodeRecord);
	else
		sub_subitems.setValue("", "");
	end
	sub_subitems.update(bReadOnly);
end

-- Backward compatibility for Savage Worlds (remove once updated)
function updateControl(sControl, bReadOnly, bID)
	WindowManager.callSafeControlUpdate(self, sControl, bReadOnly, not bID);
end
