-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local m_vNode = nil;
local m_sRecordType = "";
local m_bShared = false;
local m_bDirty = false;
local m_bIdentifiable = false;

function onInit()
	m_vNode = getDatabaseNode();
	if not m_vNode then
		return;
	end
	local sPath = DB.getPath(m_vNode);
	
	if modified then
		local sModule = DB.getModule(m_vNode);
		if (sModule or "") ~= "" then
			modified.setVisible(true);
			modified.setTooltipText(sModule);
			if not DB.isReadOnly(m_vNode) then
				DB.addHandler(sPath, "onIntegrityChange", onIntegrityChange);
				onIntegrityChange(m_vNode);
			end
		end
	end

	DB.addHandler(sPath, "onObserverUpdate", onObserverUpdate);
	onObserverUpdate(m_vNode);
	
	onCategoryChange(m_vNode);
end
function onClose()
	local sPath = DB.getPath(m_vNode);
	if modified then
		local sModule = DB.getModule(m_vNode);
		if (sModule or "") ~= "" then
			if not DB.isReadOnly(m_vNode) then
				DB.removeHandler(sPath, "onIntegrityChange", onIntegrityChange);
			end
		end
	end
	DB.removeHandler(sPath, "onObserverUpdate", onObserverUpdate);
end

function setRecordType(sNewRecordType)
	if m_sRecordType == sNewRecordType then
		return;
	end
		
	m_sRecordType = sNewRecordType
	
	local sRecordDisplayClass = LibraryData.getRecordDisplayClass(m_sRecordType, m_vNode);
	local sPath = "";
	if m_vNode then
		sPath = DB.getPath(m_vNode);
	end
	link.setValue(sRecordDisplayClass, sPath);
	
	local sEmptyNameText = LibraryData.getEmptyNameText(m_sRecordType);
	name.setEmptyText(sEmptyNameText);
	
	if isidentified and nonid_name then
		m_bIdentifiable = LibraryData.isIdentifiable(m_sRecordType, m_vNode);
		
		if m_bIdentifiable then
			local sEmptyUnidentifiedNameText = LibraryData.getEmptyUnidentifiedNameText(m_sRecordType);
			nonid_name.setEmptyText(sEmptyUnidentifiedNameText);

			self.onIDChanged();
		end
	end
end

function buildMenu()
	resetMenuItems();
	
	if modified and m_bDirty then
		registerMenuItem(Interface.getString("menu_revert"), "shuffle", 8);
	end
	if m_bShared then
		registerMenuItem(Interface.getString("windowunshare"), "windowunshare", 7);
	else
		registerMenuItem(Interface.getString("windowshare"), "windowshare", 7);
	end
end
function onMenuSelection(selection)
	if selection == 7 then
		self.toggleRecordSharing();
	elseif selection == 8 then
		RecordManager.performRevertByWindow(self);
	end
end

function onIDChanged()
	local bID = LibraryData.getIDState(m_sRecordType, m_vNode);
	name.setVisible(bID);
	nonid_name.setVisible(not bID);
end
function onIntegrityChange()
	m_bDirty = not DB.isIntact(m_vNode);
	
	if m_bDirty then
		modified.setIcon("record_dirty");
	else
		modified.setIcon("record_intact");
	end

	self.buildMenu();
end
function onObserverUpdate()
	if owner then
		owner.setValue(DB.getOwner(m_vNode));
	end
	
	local nAccess, aHolderNames = UtilityManager.getNodeAccessLevel(m_vNode);
	access.setValue(nAccess);
	if Session.IsHost then
		if nAccess == 2 then
			m_bShared = true;
		elseif nAccess == 1 then
			local sShared = Interface.getString("tooltip_shared") .. " " .. table.concat(aHolderNames, ", ");
			access.setStateTooltipText(1, sShared);
			m_bShared = true;
		else
			m_bShared = false;
		end
		self.buildMenu();
	end
end
function onCategoryChange()
	if category then
		local sCategory = DB.getCategory(m_vNode);
		category.setValue(sCategory);
		category.setTooltipText(sCategory);
	end
end

function toggleRecordSharing()
	if m_bShared then
		self.unshareRecord();
	else
		self.shareRecord();
	end
end
function unshareRecord()
	if not Session.IsHost then return; end
	
	if DB.isPublic(m_vNode) then
		DB.setPublic(m_vNode, false);
	else
		DB.removeAllHolders(m_vNode, true);
	end
end
function shareRecord()
	if not Session.IsHost then return; end

	DB.setPublic(m_vNode, true);
end
