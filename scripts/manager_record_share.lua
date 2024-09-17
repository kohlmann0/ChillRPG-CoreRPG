-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _tRecordTypeCallbacks = {};
function setRecordTypeCallback(sKey, fn)
	UtilityManager.setKeySingleCallback(_tRecordTypeCallbacks, sKey, fn);
end
function getRecordTypeCallback(sKey)
	return UtilityManager.getKeySingleCallback(_tRecordTypeCallbacks, sKey);
end

local _tWindowClassCallbacks = {};
function setWindowClassCallback(sKey, fn)
	UtilityManager.setKeySingleCallback(_tWindowClassCallbacks, sKey, fn);
end
function getWindowClassCallback(sKey)
	return UtilityManager.getKeySingleCallback(_tWindowClassCallbacks, sKey);
end

function onShareButtonPressed(w)
	local wTop = UtilityManager.getTopWindow(w);
	if not wTop then
		return;
	end
	
	local sClass = wTop.getClass();
	local node = wTop.getDatabaseNode();
	local tOutput = {};

	local fnCallback = RecordShareManager.getWindowClassCallback(sClass);
	if fnCallback then
		fnCallback(node, tOutput);
	else
		local sRecordType = LibraryData.getRecordTypeFromDisplayClass(sClass);
		fnCallback = RecordShareManager.getRecordTypeCallback(sRecordType);
		if fnCallback then
			fnCallback(node, tOutput);
		elseif sRecordType ~= "" then
			RecordShareManager.onShareRecordType(sRecordType, node, tOutput);
		end
	end

	if #tOutput > 0 then
		Comm.deliverChatMessage({ font = "chat_record_share", mode = "record_share", text = table.concat(tOutput, "\n") });
	else
		ChatManager.SystemMessage(string.format("%s (%s)", Interface.getString("message_record_share_unknown"), sClass));
	end
end

function onShareRecordType(sRecordType, node, tOutput)
	if LibraryData.getIDState(sRecordType, node, true) then
		RecordShareManager.onShareRecordBasic(LibraryData.getSingleDisplayText(sRecordType), node, tOutput);
	else
		RecordShareManager.onShareRecordTypeUnidentified(sRecordType, node, tOutput);
	end
end
function onShareRecordTypeUnidentified(sRecordType, node, tOutput)
	local sLabel = LibraryData.getSingleDisplayText(sRecordType);
	local sName = DB.getText(node, "nonid_name", "");
	if (sName or "") == "" then
		sName = LibraryData.getEmptyUnidentifiedNameText(sRecordType);
	end
	table.insert(tOutput, string.format("%s - %s", sLabel, sName));
	table.insert(tOutput, "");
	table.insert(tOutput, "");
end

function onShareRecordBasic(sLabel, node, tOutput)
	local sName = DB.getText(node, "name", "");
	if (sLabel or "") ~= "" then
		table.insert(tOutput, string.format("%s - %s", sLabel, sName));
	else
		table.insert(tOutput, sName);
	end
	table.insert(tOutput, "");
	table.insert(tOutput, DB.getText(node, "text", ""));
end
