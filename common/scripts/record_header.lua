-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.initRecordTypeControls();
	self.update();
end
function initRecordTypeControls()
	if link then
		link.setValue(UtilityManager.getTopWindow(self).getClass());
	end

	local sRecordType = WindowManager.getRecordType(self);
	if name then
		if sRecordType ~= "" then
			name.setEmptyText(LibraryData.getEmptyNameText(sRecordType));
		elseif name_emptyres then
			name.setEmptyText(Interface.getString(name_emptyres[1]));
		end
	end
	if nonid_name then
		if sRecordType ~= "" then
			nonid_name.setEmptyText(LibraryData.getEmptyUnidentifiedNameText(sRecordType));
		elseif nonid_name_emptyres then
			nonid_name.setEmptyText(Interface.getString(nonid_name_emptyres[1]));
		end
	end
	if nonid_name_edit then
		if sRecordType ~= "" then
			nonid_name_edit.setEmptyText(LibraryData.getEmptyUnidentifiedNameText(sRecordType));
		elseif nonid_name_emptyres then
			nonid_name_edit.setEmptyText(Interface.getString(nonid_name_emptyres[1]));
		end
	end
end

function onIDChanged()
	self.update();
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);

	name.setReadOnly(bReadOnly);
	if nonid_name then
		local sRecordType = WindowManager.getRecordType(self);
		local bID = LibraryData.getIDState(sRecordType, nodeRecord);
		nonid_name.setReadOnly(bReadOnly);
		name.setVisible(bID);
		nonid_name.setVisible(not bID);
	end
	if Session.IsHost and sub_nonid_edit then
		local bEmpty = (DB.getValue(nodeRecord, "nonid_name", "") == "");
		sub_nonid_edit.setVisible(not bReadOnly or not bEmpty);
		WindowManager.callSafeControlUpdate(self, "sub_nonid_edit", bReadOnly);		
	end
	if token then
		token.setReadOnly(bReadOnly);
	end
end
