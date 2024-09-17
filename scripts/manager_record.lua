-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
--	INDEX HANDLING
--

function openRecordIndex(sRecordType)
	if ((sRecordType or "") == "") then
		return;
	end

	local w = Interface.findWindow("masterindex", sRecordType);
	if w then
		w.bringToFront();
		return w, true;
	end
	w = Interface.openWindow("masterindex", sRecordType);
	return w, false;
end

function getRecordWindows(sRecordType)
	if ((sRecordType or "") == "") then
		return {};
	end

	local t = {};
	for _,w in ipairs(Interface.getWindows()) do
		local sWinRecordType = LibraryData.getRecordTypeFromDisplayClass(w.getClass());
		if sWinRecordType == sRecordType then
			table.insert(t, w);
		end
	end
	return t;
end

--
--  FIND RECORD HELPERS
--

function findRecordByString(sRecordType, sField, sValue)
	if not sRecordType then
		return nil;
	end
	if ((sField or "") == "") or ((sValue or "") == "") then
		return nil;
	end

	local sFind = StringManager.trim(sValue);
	
	local tMappings = LibraryData.getMappings(sRecordType);
	for _,sMapping in ipairs(tMappings) do
		for _,v in ipairs(DB.getChildrenGlobal(sMapping)) do
			local sMatch = StringManager.trim(DB.getValue(v, sField, ""));
			if sMatch == sFind then
				return v;
			end
		end
	end
	
	return nil;
end
function findRecordByStringI(sRecordType, sField, sValue)
	if not sRecordType then
		return nil;
	end
	if ((sField or "") == "") or ((sValue or "") == "") then
		return nil;
	end
	
	local sFind = StringManager.trim(sValue):lower();
	
	local tMappings = LibraryData.getMappings(sRecordType);
	for _,sMapping in ipairs(tMappings) do
		for _,v in ipairs(DB.getChildrenGlobal(sMapping)) do
			local sMatch = StringManager.trim(DB.getValue(v, sField, "")):lower();
			if sMatch == sFind then
				return v;
			end
		end
	end
	
	return nil;
end

--
--  CALL FOR ALL RECORDS HELPERS
--

function callForEachRecord(sRecordType, fn, ...)
	if not sRecordType or not fn then
		return;
	end

	local tMappings = LibraryData.getMappings(sRecordType);
	for _,sMapping in ipairs(tMappings) do
		for _,v in ipairs(DB.getChildrenGlobal(sMapping)) do
			fn(v, ...);
		end
	end
end

function callForEachCampaignRecord(sRecordType, fn, ...)
	RecordManager.callForEachModuleRecord(sRecordType, "", fn, ...);
end
function callForEachModuleRecord(sRecordType, sModule, fn, ...)
	if not sRecordType or not fn then
		return;
	end

	local tMappings = LibraryData.getMappings(sRecordType);
	for _,sMapping in ipairs(tMappings) do
		sMapping = string.format("%s@%s", sMapping, sModule or "");
		for _,v in ipairs(DB.getChildList(sMapping)) do
			fn(v, ...);
		end
	end
end

function callForEachRecordByString(sRecordType, sField, sValue, fn, ...)
	if not sRecordType or not fn then
		return;
	end
	if ((sField or "") == "") or ((sValue or "") == "") then
		return;
	end

	local sFind = StringManager.trim(sValue);

	local tMappings = LibraryData.getMappings(sRecordType);
	for _,sMapping in ipairs(tMappings) do
		for _,v in ipairs(DB.getChildrenGlobal(sMapping)) do
			local sMatch = StringManager.trim(DB.getValue(v, sField, ""));
			if sMatch == sFind then
				fn(v, ...);
			end
		end
	end
end
function callForEachRecordByStringI(sRecordType, sField, sValue, fn, ...)
	if not sRecordType or not fn then
		return;
	end
	if ((sField or "") == "") or ((sValue or "") == "") then
		return;
	end

	local sFind = StringManager.trim(sValue):lower();

	local tMappings = LibraryData.getMappings(sRecordType);
	for _,sMapping in ipairs(tMappings) do
		for _,v in ipairs(DB.getChildrenGlobal(sMapping)) do
			local sMatch = StringManager.trim(DB.getValue(v, sField, "")):lower();
			if sMatch == sFind then
				fn(v, ...);
			end
		end
	end
end

--
--	ACTIONS
--

function performRevertByWindow(w)
	if not w then
		return;
	end
	RecordManager.performRevert(LibraryData.getRecordTypeFromWindow(w), w.getDatabaseNode());
end
function performRevert(sRecordType, node)
	if not node then
		return;
	end
	if DB.isIntact(node) then
		return;
	end

	local tData = {
		sTitleRes = "revert_dialog_title",
		sPath = DB.getPath(node),
		fnCallback = RecordManager.handleRevertDialog,
	};
	local sDisplayText = Interface.getString("revert_dialog_text");
	local sDisplayType = LibraryData.getSingleDisplayText(sRecordType or LibraryData.getRecordTypeFromPath(tData.sPath));
	local sDisplayName = DB.getValue(node, "name", "");
	tData.sText = string.format("%s\r\r%s: %s", sDisplayText, sDisplayType, sDisplayName);

	DialogManager.openDialog("dialog_okcancel", tData);
end
function handleRevertDialog(sResult, tData)
	if sResult == "ok" then
		DB.revert(tData.sPath);
	end
end
