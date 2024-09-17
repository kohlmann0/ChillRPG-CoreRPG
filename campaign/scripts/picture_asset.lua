-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.onValueChanged();
end

function onLockChanged()
	self.onValueChanged();
end
function onValueChanged()
	local sName = getName();
	local cAdd = window[sName .. "_iadd"];
	local cDelete = window[sName .. "_idelete"];

	local sRecordType = LibraryData.getRecordTypeFromRecordPath(window.getDatabasePath());
	local bReadOnly = false;
	if LibraryData.getLockMode(sRecordType) then
		bReadOnly = WindowManager.getReadOnlyState(window.getDatabaseNode());
	end
	setReadOnly(bReadOnly);
	if bReadOnly then
		if cAdd then
			cAdd.setVisible(false);
		end
		if cDelete then
			cDelete.setVisible(false);
		end
	else
		local sValue = getValue();
		if cAdd then
			cAdd.setVisible(((sValue or "") == ""));
		end
		if cDelete then
			cDelete.setVisible(((sValue or "") ~= ""));
		end
	end
end

function onClickDown(button, x, y)
	return true;
end
function onClickRelease(button, x, y)
	if isReadOnly() then
		return false;
	end
	if (getValue() or "") ~= "" then
		return false;
	end
	RecordAssetManager.handleAssetAdd(getName());
	return true;
end
function onDrop(x, y, draginfo)
	if isReadOnly() then
		return;
	end
	if draginfo.isType("shortcut") then
		local sClass = draginfo.getShortcutData();
		if LibraryData.getRecordTypeFromDisplayClass(sClass) == "image" then
			local node = draginfo.getDatabaseNode();
			if node then
				local sAsset = DB.getText(node, "image", "");
				if sAsset ~= "" then
					setValue(sAsset);
				end
			end
		end
		return true;
	end
end
