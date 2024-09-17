-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_TRANSFERITEM = "transferitem";
OOB_MSGTYPE_TRANSFERCURRENCY = "transfercurrency";
OOB_MSGTYPE_TRANSFERPARCEL = "transferparcel";
OOB_MSGTYPE_TRANSFERITEMSTRING = "transferitemstring";

--
-- INITIALIZATION
--

function onInit()
	ItemManager.addStandardItemActorInfo();
	ItemManager.addStandardItemTransferHandlers();
end
function addStandardItemActorInfo()
	local tData = {
		tInventoryPaths = ItemManager.getDefaultInventoryPaths(), 
		tEncumbranceFields = ItemManager.getDefaultEncumbranceFields(),
		tCurrencyPaths = ItemManager.getDefaultCurrencyPaths(),
		tCurrencyEncumbranceFields = ItemManager.getDefaultCurrencyEncumbranceFields(),
	};
	ItemManager.setActorTypeInfo("charsheet", tData);
end
function addStandardItemTransferHandlers()
	OOBManager.registerOOBMsgHandler(ItemManager.OOB_MSGTYPE_TRANSFERITEM, ItemManager.handleItemTransfer);
	OOBManager.registerOOBMsgHandler(ItemManager.OOB_MSGTYPE_TRANSFERCURRENCY, ItemManager.handleCurrencyTransfer);
	OOBManager.registerOOBMsgHandler(ItemManager.OOB_MSGTYPE_TRANSFERPARCEL, ItemManager.handleParcelTransfer);
	OOBManager.registerOOBMsgHandler(ItemManager.OOB_MSGTYPE_TRANSFERITEMSTRING, ItemManager.handleItemStringTransfer);
end

--
-- SETTINGS
--

local _tActorTypeInfo = {};
function getActorTypes()
	local tResults = {};
	for k,_ in pairs(_tActorTypeInfo) do
		table.insert(tResults, k);
	end
	return tResults;
end
function isActorType(sRecordType)
	if _tActorTypeInfo[sRecordType] then
		return true;
	end
	return false;
end
function setActorTypeInfo(sRecordType, tData)
	if ((sRecordType or "") ~= "") then
		_tActorTypeInfo[sRecordType] = tData;
	end
end
function getActorTypeInfo(sRecordType)
	if not sRecordType then
		return nil;
	end
	return _tActorTypeInfo[sRecordType];
end

local _tDefaultInventoryPaths = { "inventorylist" };
function getDefaultInventoryPaths()
	return _tDefaultInventoryPaths;
end
function setInventoryPaths(sRecordType, tPaths)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		if not tPaths then
			return;
		end
		ItemManager.setActorTypeInfo(sRecordType, { tInventoryPaths = tPaths });
		return;
	end
	tData.tInventoryPaths = tPaths;
end
function getInventoryPaths(sRecordType)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		return ItemManager.getDefaultInventoryPaths();
	end
	return tData.tInventoryPaths or ItemManager.getDefaultInventoryPaths();
end
function getBaseInventoryPath(sRecordType)
	local tPaths = ItemManager.getInventoryPaths(sRecordType);
	if tPaths then
		return tPaths[1];
	end
	return nil;
end

local _tDefaultEncumbranceFields = { "carried", "count", "weight" };
function getDefaultEncumbranceFields()
	return _tDefaultEncumbranceFields;
end
function setEncumbranceFields(sRecordType, tFields)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		if not tFields then
			return;
		end
		ItemManager.setActorTypeInfo(sRecordType, { tEncumbranceFields = tFields });
		return;
	end
	tData.tEncumbranceFields = tFields;
end
function getEncumbranceFields(sRecordType)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		return ItemManager.getDefaultEncumbranceFields();
	end
	return tData.tEncumbranceFields or ItemManager.getDefaultEncumbranceFields();
end

local _tDefaultCurrencyPaths = { "coins" };
function getDefaultCurrencyPaths()
	return _tDefaultCurrencyPaths;
end
function setCurrencyPaths(sRecordType, tPaths)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		if not tPaths then
			return;
		end
		ItemManager.setActorTypeInfo(sRecordType, { tCurrencyPaths = tPaths });
		return;
	end
	tData.tCurrencyPaths = tPaths;
end
function getCurrencyPaths(sRecordType)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		return nil;
	end
	return tData.tCurrencyPaths;
end

local _tDefaultCurrencyEncumbranceFields = { "amount", "name" };
function getDefaultCurrencyEncumbranceFields()
	return _tDefaultCurrencyEncumbranceFields;
end
function setCurrencyEncumbranceFields(sRecordType, tFields)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		if not tFields then
			return;
		end
		ItemManager.setActorTypeInfo(sRecordType, { tCurrencyEncumbranceFields = tFields });
		return;
	end
	tData.tCurrencyEncumbranceFields = tFields;
end
function getCurrencyEncumbranceFields(sRecordType)
	local tData = ItemManager.getActorTypeInfo(sRecordType);
	if not tData then
		return nil;
	end
	return tData.tCurrencyEncumbranceFields;
end

-- NOTE: Assumes field is a child of each item record, and is a string data type.
local _sDefaultCostField = "cost";
local _sCustomCostField = nil;
function setCostField(sField)
	_sCustomCostField = sField;
end
function getCostField()
	return _sCustomCostField or _sDefaultCostField;
end

function getTargetInventoryListPath(nodeTarget)
	local tPaths = ItemManager.helperGetAllRecordInventoryPaths(nodeTarget);
	if tPaths then
		return tPaths[1];
	end
	return nil;
end
function helperGetAllRecordInventoryPaths(nodeTarget)
	local sRecordType = ItemManager.getItemSourceType(nodeTarget);
	if ItemManager.isActorType(sRecordType) then
		if (sRecordType == "charsheet") and ItemManager2 and ItemManager2.getCharItemListPaths then
			return ItemManager2.getCharItemListPaths(nodeTarget);
		end
		return ItemManager.getInventoryPaths(sRecordType);
	elseif sRecordType == "treasureparcel" then
		return { "itemlist" };
	elseif sRecordType == "partysheet" then
		return { "treasureparcelitemlist" };
	elseif sRecordType == "item" then
		return { "" };
	end
	return nil;
end

--
-- HANDLERS
--

local _fnCustomCharAdd = nil;
function setCustomCharAdd(fCharAdd)
	_fnCustomCharAdd = fCharAdd;
end
function onCharAddEvent(nodeItem)
	if _fnCustomCharAdd then
		_fnCustomCharAdd(nodeItem);
	end
end

local _fnCustomCharRemove = nil;
function setCustomCharRemove(fCharRemove)
	_fnCustomCharRemove = fCharRemove;
end
function onCharRemoveEvent(nodeItem)
	if _fnCustomCharRemove then
		_fnCustomCharRemove(nodeItem);
	end
end

local _tDeleteCopyFields = { "count", "locked", "location", "carried", "showonminisheet", "assign" };
function addFieldToIgnore (sIgnore)
	if type(sIgnore) == "string" and sIgnore ~= "" then
		table.insert(_tDeleteCopyFields, sIgnore);
	end
end

local _sPackIncludedItemListPath = "subitems";
function setPackIncludedItemListPath(s)
	_sPackIncludedItemListPath = s;
end
function getPackIncludedItemListPath(s)
	return _sPackIncludedItemListPath;
end

local _tPreTransferHandler = {};
function registerPreTransferHandler(fn)
	UtilityManager.registerCallback(_tPreTransferHandler, fn);
end
function unregisterPreTransferHandler(fn)
	UtilityManager.unregisterCallback(_tPreTransferHandler, fn);
end
function callPreTransferHandlers(...)
	return UtilityManager.performCallbacks(_tPreTransferHandler, ...);
end

local _tCleanupTransferHandler = {};
function registerCleanupTransferHandler(fn)
	UtilityManager.registerCallback(_tCleanupTransferHandler, fn);
end
function unregisterCleanupTransferHandler(fn)
	UtilityManager.unregisterCallback(_tCleanupTransferHandler, fn);
end
function callCleanupTransferHandlers(...)
	return UtilityManager.performCallbacks(_tCleanupTransferHandler, ...);
end

local _tPostTransferHandler = {};
function registerPostTransferHandler(fn)
	UtilityManager.registerCallback(_tPostTransferHandler, fn);
end
function unregisterPostTransferHandler(fn)
	UtilityManager.unregisterCallback(_tPostTransferHandler, fn);
end
function callPostTransferHandlers(...)
	return UtilityManager.performCallbacks(_tPostTransferHandler, ...);
end

--
-- ACTIONS
--

function getIDState(nodeRecord, bIgnoreHost)
	if ItemManager2 and ItemManager2.getIDState then
		return ItemManager2.getIDState(nodeRecord, bIgnoreHost);
	end
	
	local bID = true;
	if (bIgnoreHost or not Session.IsHost) then
		bID = (DB.getValue(nodeRecord, "isidentified", 1) == 1);
	end
	
	return bID, true;
end
function getDisplayName(nodeItem, bIgnoreHost)
	local bID = ItemManager.getIDState(nodeItem, bIgnoreHost);
	if bID then
		return DB.getValue(nodeItem, "name", "");
	end
	
	local sName = DB.getValue(nodeItem, "nonid_name", "");
	if sName == "" then
		sName = Interface.getString("library_recordtype_empty_nonid_item");
	end
	return sName;
end
function getSortName(nodeItem)
	local sName = ItemManager.getDisplayName(nodeItem);
	return sName:lower();
end
function getItemSourceType(vNode)
	local sPath = nil;
	if type(vNode) == "databasenode" then
		sPath = DB.getPath(vNode);
	elseif type(vNode) == "string" then
		sPath = vNode;
	end
	if not sPath then
		return "";
	end

	for _,vMapping in ipairs(LibraryData.getMappings("item")) do
		if UtilityManager.doesDataBasePathStartWith(sPath, vMapping) then
			return "item";
		end
	end
	for _,vMapping in ipairs(LibraryData.getMappings("treasureparcel")) do
		if UtilityManager.doesDataBasePathStartWith(sPath, vMapping) then
			return "treasureparcel";
		end
	end

	if UtilityManager.doesDataBasePathStartWith(sPath, "partysheet") then
		return "partysheet";
	end
	if UtilityManager.doesDataBasePathStartWith(sPath, "temp") then
		return "temp";
	end

	for _,sRecordType in ipairs(ItemManager.getActorTypes()) do
		for _,vMapping in ipairs(LibraryData.getMappings(sRecordType)) do
			if UtilityManager.doesDataBasePathStartWith(sPath, vMapping) then
				return sRecordType;
			end
		end
	end

	local sRecordType = ActorManager.getRecordType(sPath);
	if ItemManager.isActorType(sRecordType) then
		return sRecordType;
	end

	return "";
end

function compareFields(node1, node2, bTop)
	if node1 == node2 then
		return false;
	end
	
	local tAllFields = {};
	local tChildren1 = DB.getChildren(node1);
	local tChildren2 = DB.getChildren(node2);
	for sName,_ in pairs(tChildren1) do
		if not bTop or not StringManager.contains(_tDeleteCopyFields, sName) then
			tAllFields[sName] = true;
		end
	end
	for sName,_ in pairs(tChildren2) do
		if not bTop or not StringManager.contains(_tDeleteCopyFields, sName) then
			tAllFields[sName] = true;
		end
	end

	for sName,_ in pairs(tAllFields) do
		local vChild1 = tChildren1[sName];
		local vChild2 = tChildren2[sName];

		if vChild1 and vChild2 then
			local sType = DB.getType(vChild1);
			if sType ~= DB.getType(vChild2) then
				return false;
			end

			if sType == "node" then
				if not ItemManager.compareFields(vChild1, vChild2, false) then
					return false;
				end
			elseif sType == "dice" then
				local diceChild1 = DB.getValue(vChild1) or {};
				local diceChild2 = DB.getValue(vChild2) or {};
				if #diceChild1 ~= #diceChild2 then
					return false;
				end
				table.sort(diceChild1, function(a,b) return a<b end);
				table.sort(diceChild2, function(a,b) return a<b end);
				for kDie,vDie in ipairs(diceChild1) do
					if (vDie ~= diceChild2[kDie]) then
						return false;
					end
				end
			else
				if DB.getValue(vChild1) ~= DB.getValue(vChild2) then
					return false;
				end
			end
		elseif vChild1 then
			local sType = DB.getType(vChild1);
			local bMatch = (StringManager.contains({"number", "string", "formattedtext", "dice"}, sType) and DB.isEmpty(vChild1));
			if not bMatch then
				return false;
			end
		elseif vChild2 then
			local sType = DB.getType(vChild2);
			local bMatch = (StringManager.contains({"number", "string", "formattedtext", "dice"}, sType) and DB.isEmpty(vChild2));
			if not bMatch then
				return false;
			end
		end
	end
	
	return true;
end

function isPack()
	return false;
end

--
-- HIGH-LEVEL ACTIONS
--

function addLinkToParcel(nodeParcel, sLinkClass, sLinkRecord, nCount)
	if sLinkClass == "treasureparcel" then
		for i = 1, (nCount or 1) do
			ItemManager.handleParcel(nodeParcel, sLinkRecord);
		end
	elseif LibraryData.isRecordDisplayClass("item", sLinkClass) then
		for i = 1, (nCount or 1) do
			ItemManager.handleItem(nodeParcel, nil, sLinkClass, sLinkRecord);
		end
	else
		return false;
	end
	
	return true;
end

function handleAnyDrop(vTarget, draginfo)
	local sDragType = draginfo.getType();
	
	if not Session.IsHost then
		local sTargetType = ItemManager.getItemSourceType(vTarget);
		if sTargetType == "item" then
			return false;
		elseif sTargetType == "treasureparcel" then
			return false;
		elseif sTargetType == "partysheet" then
			if sDragType ~= "shortcut" then
				return false;
			end
			local sClass, sRecord = draginfo.getShortcutData();
			if not LibraryData.isRecordDisplayClass("item", sClass) then
				return false;
			end
			if not ItemManager.isActorType(ItemManager.getItemSourceType(sRecord)) then
				return false;
			end
		elseif ItemManager.isActorType(sTargetType) then
			if not DB.isOwner(vTarget) then
				return false;
			end
		end
	end
	
	if sDragType == "number" then
		ItemManager.handleString(vTarget, draginfo.getDescription(), draginfo.getNumberData());
		return true;

	elseif sDragType == "string" then
		ItemManager.handleString(vTarget, draginfo.getStringData());
		return true;

	elseif sDragType == "shortcut" then
		local sClass,sRecord = draginfo.getShortcutData();
		if LibraryData.isRecordDisplayClass("item", sClass) then
			local sSourceType = ItemManager.getItemSourceType(sRecord);
			local sTargetType = ItemManager.getItemSourceType(vTarget);
			local bTransferAll = false;
			if (ItemManager.isActorType(sSourceType) or (sSourceType == "partysheet")) and 
					(ItemManager.isActorType(sTargetType) or (sTargetType == "partysheet")) then
				bTransferAll = Input.isShiftPressed();
			end
			
			ItemManager.handleItem(vTarget, nil, sClass, sRecord, bTransferAll);
			return true;
		elseif sClass == "treasureparcel" then
			ItemManager.handleParcel(vTarget, sRecord);
			return true;
		end
	end
	
	return false;
end
function handleItem(vTargetRecord, sTargetList, sClass, sRecord, bTransferAll)
	local nodeTargetRecord = nil;
	if type(vTargetRecord) == "databasenode" then
		nodeTargetRecord = vTargetRecord;
	elseif type(vTargetRecord) == "string" then
		nodeTargetRecord = DB.findNode(vTargetRecord);
	end
	if not nodeTargetRecord then
		return;
	end
	
	if not sTargetList then
		sTargetList = ItemManager.getTargetInventoryListPath(nodeTargetRecord, sClass);
		if not sTargetList then
			return;
		end
	end
	
	ItemManager.sendItemTransfer(DB.getPath(nodeTargetRecord), sTargetList, sClass, sRecord, bTransferAll);
end
function handleCurrency(vTargetRecord, sCurrency, nCurrency)
	local sTargetRecord = nil;
	if type(vTargetRecord) == "databasenode" then
		sTargetRecord = DB.getPath(vTargetRecord);
	elseif type(vTargetRecord) == "string" then
		sTargetRecord = vTargetRecord;
	end
	if not sTargetRecord then
		return;
	end

	ItemManager.sendCurrencyTransfer(sTargetRecord, sCurrency, nCurrency);
end
function handleParcel(vTargetRecord, sRecord)
	local sTargetRecord = nil;
	if type(vTargetRecord) == "databasenode" then
		sTargetRecord = DB.getPath(vTargetRecord);
	elseif type(vTargetRecord) == "string" then
		sTargetRecord = vTargetRecord;
	end
	if not sTargetRecord then
		return;
	end
	
	local sTargetRecordType = getItemSourceType(vTargetRecord);
	if sTargetRecordType == "item" then
		return;
	end

	ItemManager.sendParcelTransfer(sTargetRecord, sRecord);
end
function handleString(vTargetRecord, s, n)
	local sTargetRecord = nil;
	if type(vTargetRecord) == "databasenode" then
		sTargetRecord = DB.getPath(vTargetRecord);
	elseif type(vTargetRecord) == "string" then
		sTargetRecord = vTargetRecord;
	end
	if not sTargetRecord then
		return;
	end

	local sText = StringManager.trim(s);
	if sText == "" or sText == "-" then
		return;
	end
	
	local nCurrency = nil;
	local sCurrency = nil;
	local sTargetRecordType = ItemManager.getItemSourceType(sTargetRecord);
	if ItemManager.isActorType(sTargetRecordType) or StringManager.contains({"partysheet", "treasureparcel"}, sTargetRecordType) then
		if n then
			nCurrency = n;
			sCurrency = CurrencyManager.getCurrencyMatch(s);
		else
			nCurrency, sCurrency = CurrencyManager.parseCurrencyString(s, true);
		end
	end
		
	if sCurrency then
		ItemManager.sendCurrencyTransfer(sTargetRecord, sCurrency, nCurrency);
	else
		ItemManager.sendItemStringTransfer(sTargetRecord, sText, n);
	end
end
function handleAnyDropOnItemRecord(vTarget, draginfo)
	if not Session.IsHost and not DB.isOwner(vTarget) then
		return;
	end

	if ItemManager.isPack(vTarget) then
		local sDragType = draginfo.getType();
		if sDragType == "number" then
			local nCount = draginfo.getNumberData();
			local sItem = draginfo.getDescription();
			if ((sItem or "") ~= "") and (nCount > 0) then
				local node = DB.createChild(DB.getPath(vTarget, ItemManager.getPackIncludedItemListPath()));
				if node then
					DB.setValue(node, "name", "string", sItem);
					DB.setValue(node, "count", "number", nCount);
				end
			end
			return true;

		elseif sDragType == "string" then
			local sItem = draginfo.getDescription();
			if ((sItem or "") ~= "") then
				local node = DB.createChild(DB.getPath(vTarget, ItemManager.getPackIncludedItemListPath()));
				if node then
					DB.setValue(node, "name", "string", sItem);
					DB.setValue(node, "count", "number", 1);
				end
			end
			return true;

		elseif sDragType == "shortcut" then
			local sClass,sRecord = draginfo.getShortcutData();
			if LibraryData.isRecordDisplayClass("item", sClass) then
				local sItem = DB.getValue(DB.getPath(sRecord, "name"), "");
				local node = DB.createChild(DB.getPath(vTarget, ItemManager.getPackIncludedItemListPath()));
				if node then
					DB.setValue(node, "name", "string", sItem);
					DB.setValue(node, "count", "number", 1);
					DB.setValue(node, "link", "windowreference", sClass, sRecord);
				end
				return true;
			end
		end
	end

	return false;
end

--
-- ADD/TRANSFER ITEM
--

function sendItemTransfer(sTargetRecord, sTargetList, sClass, sRecord, bTransferAll)
	local msgOOB = {};
	msgOOB.type = ItemManager.OOB_MSGTYPE_TRANSFERITEM;
	
	msgOOB.sTarget = sTargetRecord;
	msgOOB.sTargetList = sTargetList;
	msgOOB.sClass = sClass;
	msgOOB.sRecord = sRecord;
	if bTransferAll then
		msgOOB.sTransferAll = "true";
	end

	-- If on client, go ahead and handle non-party transfers; since we're not guaranteed that GM has source open
	if not Session.IsHost then
		local sSourceRecordType = ItemManager.getItemSourceType(sRecord);
		local sTargetRecordType = ItemManager.getItemSourceType(sTargetRecord);
		if StringManager.contains({"item", "treasureparcel"}, sSourceRecordType) and ItemManager.isActorType(sTargetRecordType) then
			ItemManager.handleItemTransfer(msgOOB);
			return;
		end
	end

	Comm.deliverOOBMessage(msgOOB, "");
end
function handleItemTransfer(msgOOB)
	ItemManager.addItemToList(DB.getPath(msgOOB.sTarget, msgOOB.sTargetList), msgOOB.sClass, msgOOB.sRecord, ((msgOOB.sTransferAll or "") == "true"));
end

function onAddItemPackLoadCallback(tCustom)
	ItemManager.addItemToList(tCustom.nodeList, tCustom.sClass, tCustom.nodeSource, tCustom.bTransferAll, tCustom.nTransferCount);
end

-- TODO - Update this function to be more flexible and include actor node; imapcts extensions and rulesets
function addItemToList(vList, sClass, vSource, bTransferAll, nTransferCount)
	-- Resolve the source and target information, and make sure it's valid
	local rSourceItem = nil;
	if type(vSource) == "databasenode" then
		rSourceItem = { node = vSource };
	elseif type(vSource) == "string" then
		rSourceItem = { node = DB.findNode(vSource) };
	end
	local rTargetItem = nil;
	if type(vList) == "databasenode" then
		rTargetItem = { nodeList = vList };
	elseif type(vList) == "string" then
		rTargetItem = { nodeList = DB.createNode(vList) };
	end
	if not rSourceItem or not rTargetItem then
		return nil;
	end
	if not rSourceItem.node or not rTargetItem.nodeList then
		return nil;
	end

	rSourceItem.sClass = sClass;
	rSourceItem.bTransferAll = bTransferAll;
	rSourceItem.nTransferCount = nTransferCount;

	rSourceItem.sType = ItemManager.getItemSourceType(rSourceItem.node);
	if rSourceItem.sType == "" then
		rSourceItem.sType = ItemManager.getItemSourceType(DB.getChild(rSourceItem.node, "..."));
	end
	rTargetItem.sType = ItemManager.getItemSourceType(rTargetItem.nodeList);
	if rTargetItem.sType == "" then
		rTargetItem.sType = ItemManager.getItemSourceType(DB.getParent(rTargetItem.nodeList));
	end
	
	-- Call the main item add code
	return ItemManager.helperAddItemMain(rSourceItem, rTargetItem);
end
function addStringToList(vList, sItem, nCount)
	if ((sItem or "") == "") or (nCount <= 0) then
		return nil;
	end

	-- Resolve the target information, and make sure it's valid
	local rTargetItem = nil;
	if type(vList) == "databasenode" then
		rTargetItem = { nodeList = vList };
	elseif type(vList) == "string" then
		rTargetItem = { nodeList = DB.createNode(vList) };
	end
	if not rTargetItem then
		return nil;
	end
	if not rTargetItem.nodeList then
		return nil;
	end
	rTargetItem.sType = ItemManager.getItemSourceType(rTargetItem.nodeList);

	local rSourceItem = { sClass = "string", sValue = sItem, nTransferCount = nCount, sType = "string" };

	-- Call the main item add code
	return ItemManager.helperAddItemMain(rSourceItem, rTargetItem);
end

function helperAddItemMain(rSourceItem, rTargetItem)
	-- Block unwanted transfers
	if ItemManager.helperAddItemBlockTransfer(rSourceItem, rTargetItem) then
		return nil;
	end

	-- Handle packs
	if ItemManager.handleAddItemPackTransfer(rSourceItem, rTargetItem) then
		return nil;
	end

	-- Call pre-transfer handlers; and bail if handlers say they handled the event
	if ItemManager.callPreTransferHandlers(rSourceItem, rTargetItem) then
		return nil;
	end
	
	-- Use a temporary location to create an item copy for manipulation, if the item type is supported
	local rTempItem = ItemManager.helperAddItemCreateTempNode(rTargetItem);

	-- Perform the copy
	if ItemManager.helperAddItemCopyToTempNode(rSourceItem, rTempItem, rTargetItem) then
		-- Clean up unwanted transfer fields
		ItemManager.helperAddItemCleanTempNode(rTempItem);
		-- Call cleanup-transfer handlers
		ItemManager.callCleanupTransferHandlers(rSourceItem, rTempItem, rTargetItem);
		-- Find matching target node, or create a new node
		ItemManager.helperAddItemGetTransferTargetNode(rTempItem, rTargetItem);
		-- Update item count based on source, target, and parameters
		ItemManager.helperAddItemUpdateCount(rSourceItem, rTargetItem);
		-- Perform post transfer standard events
		ItemManager.helperAddItemPostEvents(rSourceItem, rTargetItem)
	end
	
	-- Clean up temporary location
	ItemManager.helperAddItemDeleteTempNode(rTempItem);

	-- Call post-transfer handlers
	if rTargetItem.node then
		ItemManager.callPostTransferHandlers(rSourceItem, rTargetItem);
	end
	
	return rTargetItem.node;
end
function helperAddItemBlockTransfer(rSourceItem, rTargetItem)
	-- Make sure that the source and target locations are not the same character
	if (rSourceItem.sType == rTargetItem.sType) and ItemManager.isActorType(rSourceItem.sType) then
		if DB.getPath(DB.getParent(rSourceItem.node)) == DB.getPath(rTargetItem.nodeList) then
			return true;
		end
	end
	return false;
end
function handleAddItemPackTransfer(rSourceItem, rTargetItem)
	if not ItemManager.isActorType(rTargetItem.sType) and (rTargetItem.sType ~= "partysheet") then
		return false;
	end
	if not ItemManager.isPack(rSourceItem.node) then
		return false;
	end
	local sSubPath = ItemManager.getPackIncludedItemListPath();
	if DB.getChildCount(rSourceItem.node, sSubPath) == 0 then
		return false;
	end

	local tRecordPaths = {};
	for _,v in ipairs(DB.getChildList(rSourceItem.node, sSubPath)) do
		local sSubClass,sSubRecord = DB.getValue(v, "link", "", "");
		if LibraryData.isRecordDisplayClass("item", sSubClass) then
			table.insert(tRecordPaths, sSubRecord);
		end
	end
	local tCallback = {};
	tCallback.nodeList = rTargetItem.nodeList;
	tCallback.sClass = rSourceItem.sClass;
	tCallback.nodeSource = rSourceItem.node;
	tCallback.bTransferAll = rSourceItem.bTransferAll;
	tCallback.nTransferCount = rSourceItem.nTransferCount;
	if ModuleManager.handleRecordModulesLoad(tRecordPaths, ItemManager.onAddItemPackLoadCallback, tCallback) then
		return true;
	end

	local nPackCount = ItemManager.helperAddItemGetFinalTransferCount(rSourceItem, rTargetItem);
	for _,v in ipairs(DB.getChildList(rSourceItem.node, sSubPath)) do
		local sSubClass, sSubRecord = DB.getValue(v, "link", "", "");
		local nSubCount = nPackCount * DB.getValue(v, "count", 0);
		if nSubCount > 0 then
			if LibraryData.isRecordDisplayClass("item", sSubClass) then
				ItemManager.addItemToList(rTargetItem.nodeList, sSubClass, sSubRecord, nil, nSubCount);
			else
				local sSubName = DB.getValue(v, "name", "");
				ItemManager.addStringToList(rTargetItem.nodeList, sSubName, nSubCount);
			end
		end
	end
	return true;
end
function helperAddItemCreateTempNode(rTargetItem)
	local sTempPath;
	if DB.getParent(rTargetItem.nodeList) then
		sTempPath = DB.getParent(rTargetItem.nodeList).getPath("temp.item");
	else
		sTempPath = "temp.item";
	end
	DB.deleteNode(sTempPath);
	return { node = DB.createNode(sTempPath), sPath = sTempPath };
end
function helperAddItemCopyToTempNode(rSourceItem, rTempItem, rTargetItem)
	if rSourceItem.sClass == "string" then
		DB.setValue(rTempItem.node, "name", "string", rSourceItem.sValue);
		DB.setValue(rTempItem.node, "count", "number", rSourceItem.nTransferCount);
		DB.setValue(rTempItem.node, "isidentified", "number", 1);
		return true;
	elseif rSourceItem.sClass == "item" then
		DB.copyNode(rSourceItem.node, rTempItem.node);
		return true;
	elseif ItemManager2 and ItemManager2.addItemToList2 then
		return ItemManager2.addItemToList2(rSourceItem.sClass, rSourceItem.node, rTempItem.node, rTargetItem.nodeList);
	elseif LibraryData.isRecordDisplayClass("item", rSourceItem.sClass) then
		DB.copyNode(rSourceItem.node, rTempItem.node);
		return true;
	end
	return false;
end
-- Remove fields that shouldn't be transferred
function helperAddItemCleanTempNode(rTempItem)
	for _,sField in ipairs(_tDeleteCopyFields) do
		DB.deleteChild(rTempItem.node, sField);
	end
end
-- Determine target node for source item data.  
-- If we already have an item with the same fields, then just append the item count.  
-- Otherwise, create a new item and copy from the source item.
function helperAddItemGetTransferTargetNode(rTempItem, rTargetItem)
	if rTargetItem.sType ~= "item" then
		for _,vItem in ipairs(DB.getChildList(rTargetItem.nodeList)) do
			if ItemManager.compareFields(vItem, rTempItem.node, true) then
				rTargetItem.node = vItem;
				rTargetItem.bAppend = true;
				break;
			end
		end
	end
	if not rTargetItem.node then
		rTargetItem.node = DB.createChildAndCopy(rTargetItem.nodeList, rTempItem.node);
	end
end
function helperAddItemGetFinalTransferCount(rSourceItem, rTargetItem)
	if rTargetItem.sType == "item" then
		return 1;
	end

	local bCountN = false;
	if rSourceItem.sType == "treasureparcel" then
		if ItemManager.isActorType(rTargetItem.sType) or StringManager.contains({"partysheet", "treasureparcel"}, rTargetItem.sType) then
			bCountN = true;
		end
	elseif rSourceItem.sType == "partysheet" then
		if (rTargetItem.sType == "treasureparcel") then
			bCountN = true;
		elseif ItemManager.isActorType(rTargetItem.sType) then
			if rSourceItem.bTransferAll then
				bCountN = true;
			end
		end
	elseif rSourceItem.sType == "temp" then
		if ItemManager.isActorType(rTargetItem.sType) or StringManager.contains({"partysheet", "treasureparcel"}, rTargetItem.sType) then
			bCountN = true;
		end
	elseif ItemManager.isActorType(rSourceItem.sType) then
		if ItemManager.isActorType(rTargetItem.sType) or (rTargetItem.sType == "partysheet") then
			if rSourceItem.bTransferAll then
				bCountN = true;
			end
		end
	end
	local nCount;
	if bCountN then
		nCount = DB.getValue(rSourceItem.node, "count", 0);
	elseif rSourceItem.nTransferCount then
		nCount = rSourceItem.nTransferCount;
	end
	return nCount or 1;
end
-- Determine whether to copy all items at once or just one item at a time (based on source and target)
function helperAddItemUpdateCount(rSourceItem, rTargetItem)
	rSourceItem.nFinalTransferCount = ItemManager.helperAddItemGetFinalTransferCount(rSourceItem, rTargetItem);
	if rSourceItem.nFinalTransferCount > 0 then
		DB.setValue(rTargetItem.node, "count", "number", rSourceItem.nFinalTransferCount + DB.getValue(rTargetItem.node, "count", 0));
	end
end
function helperAddItemPostEvents(rSourceItem, rTargetItem)
	if not rTargetItem.bAppend then
		DB.setValue(rTargetItem.node, "locked", "number", 1);
		if ItemManager.isActorType(rTargetItem.sType) then
			ItemManager.onCharAddEvent(rTargetItem.node);
		end
	end

	-- Handle adding suffix to campaign item list copies
	if (rSourceItem.sType == "item") and (rTargetItem.sType == "item") then
		local sName = DB.getValue(rSourceItem.node, "name", "");
		if (sName ~= "") and (DB.getCategory(rSourceItem.node) == DB.getCategory(rTargetItem.node)) then
			DB.setValue(rTargetItem.node, "name", "string", sName .. " " .. Interface.getString("masterindex_suffix_duplicate"));
		end
	end

	-- Generate output message if transferring between actors or between party sheet and actor
	if ItemManager.isActorType(rSourceItem.sType) and (ItemManager.isActorType(rTargetItem.sType) or (rTargetItem.sType == "partysheet")) then
		local sSrcName = DB.getValue(rSourceItem.node, "...name", "");
		local sTrgtName;
		if rTargetItem.sType == "partysheet" then
			sTrgtName = "PARTY";
		else
			sTrgtName = DB.getValue(rTargetItem.node, "...name", "");
		end
		local msg = {font = "msgfont", icon = "coins"};
		msg.text = string.format("[%s] -> [%s] : %s", sSrcName, sTrgtName, ItemManager.getDisplayName(rTargetItem.node, true));
		if rSourceItem.nFinalTransferCount > 1 then
			msg.text = msg.text .. " (" .. rSourceItem.nFinalTransferCount .. "x)";
		end
		Comm.deliverChatMessage(msg);

		local nCharCount = DB.getValue(rSourceItem.node, "count", 0);
		if nCharCount <= rSourceItem.nFinalTransferCount then
			ItemManager.onCharRemoveEvent(rSourceItem.node);
			DB.deleteNode(rSourceItem.node);
		else
			DB.setValue(rSourceItem.node, "count", "number", nCharCount - rSourceItem.nFinalTransferCount);
		end
	elseif rSourceItem.sType == "partysheet" and ItemManager.isActorType(rTargetItem.sType) then
		local sSrcName = "PARTY";
		local sTrgtName = DB.getValue(rTargetItem.node, "...name", "");
		local msg = {font = "msgfont", icon = "coins"};
		msg.text = string.format("[%s] -> [%s] : %s", sSrcName, sTrgtName, ItemManager.getDisplayName(rTargetItem.node, true));
		if rSourceItem.nFinalTransferCount > 1 then
			msg.text = msg.text .. " (" .. rSourceItem.nFinalTransferCount .. "x)";
		end
		Comm.deliverChatMessage(msg);

		local nPartyCount = DB.getValue(rSourceItem.node, "count", 0);
		if nPartyCount <= rSourceItem.nFinalTransferCount then
			DB.deleteNode(rSourceItem.node);
		else
			DB.setValue(rSourceItem.node, "count", "number", nPartyCount - rSourceItem.nFinalTransferCount);
		end
	end
end
function helperAddItemDeleteTempNode(rTempItem)
	DB.deleteNode(rTempItem.sPath);
end

--
-- ADD/TRANSFER CURRENCY
--

function sendCurrencyTransfer(sTargetRecord, sCurrency, nCurrency)
	local msgOOB = {};
	msgOOB.type = ItemManager.OOB_MSGTYPE_TRANSFERCURRENCY;
	
	msgOOB.sTarget = sTargetRecord;
	msgOOB.sCurrency = sCurrency;
	msgOOB.nCurrency = nCurrency;

	Comm.deliverOOBMessage(msgOOB, "");
end
-- NOTE: Assume that we are running on host
function handleCurrencyTransfer(msgOOB)
	local nodeTargetRecord = DB.findNode(msgOOB.sTarget);
	if not nodeTargetRecord then
		return;
	end
	
	local nCurrency = tonumber(msgOOB.nCurrency) or 0;
	local sCurrency = msgOOB.sCurrency;
	
	local sTargetRecordType = ItemManager.getItemSourceType(nodeTargetRecord);
	if ItemManager.isActorType(sTargetRecordType) then
		CurrencyManager.addActorCurrency(nodeTargetRecord, sCurrency, nCurrency);
	elseif sTargetRecordType == "treasureparcel" then
		local nodeTargetCoin = nil;
		local sCurrencyLower = sCurrency:lower();
		for _,vParcelCoin in ipairs(DB.getChildList(nodeTargetRecord, "coinlist")) do
			if DB.getValue(vParcelCoin, "description", ""):lower() == sCurrencyLower then
				nodeTargetCoin = vParcelCoin;
			end
		end
		if not nodeTargetCoin  then
			nodeTargetCoin = DB.createChild(DB.createChild(nodeTargetRecord, "coinlist"));
			DB.setValue(nodeTargetCoin, "description", "string", sCurrency);
		end
		DB.setValue(nodeTargetCoin, "amount", "number", nCurrency + DB.getValue(nodeTargetCoin, "amount", 0));
	elseif sTargetRecordType == "partysheet" then
		local nodeCurrency = nil;
		local sCurrencyLower = sCurrency:lower();
		for _,vPSCurrency in ipairs(DB.getChildList("partysheet.treasureparcelcoinlist")) do
			if DB.getValue(vPSCurrency, "description", ""):lower() == sCurrencyLower then
				nodeCurrency = vPSCurrency;
				break;
			end
		end
		
		if nodeCurrency then
			DB.setValue(nodeCurrency, "amount", "number",  DB.getValue(nodeCurrency, "amount", 0) + nCurrency);
		else
			nodeCurrency = DB.createChild("partysheet.treasureparcelcoinlist");
			DB.setValue(nodeCurrency, "description", "string", sCurrency);
			DB.setValue(nodeCurrency, "amount", "number", nCurrency);
		end
	end
end

--
-- ADD/TRANSFER PARCEL
--

function sendParcelTransfer(sTargetRecord, sSource)
	local msgOOB = {};
	msgOOB.type = ItemManager.OOB_MSGTYPE_TRANSFERPARCEL;
	
	msgOOB.sTarget = sTargetRecord;
	msgOOB.sSource = sSource;

	Comm.deliverOOBMessage(msgOOB, "");
end
-- NOTE: Assume that we are running on host
function handleParcelTransfer(msgOOB)
	local nodeTargetRecord = DB.findNode(msgOOB.sTarget);
	if not nodeTargetRecord then
		return;
	end
	
	local nodeParcel = DB.findNode(msgOOB.sSource);
	if not nodeParcel then
		return;
	end
	
	for _,vParcelItem in ipairs(DB.getChildList(nodeParcel, "itemlist")) do
		ItemManager.handleItem(nodeTargetRecord, nil, "item", DB.getPath(vParcelItem), true);
	end
								
	for _,vParcelCoin in ipairs(DB.getChildList(nodeParcel, "coinlist")) do
		local sCurrency = DB.getValue(vParcelCoin, "description", "");
		local nCurrency = DB.getValue(vParcelCoin, "amount", 0);
		ItemManager.handleCurrency(nodeTargetRecord, sCurrency, nCurrency);
	end

	local sTargetRecordType = ItemManager.getItemSourceType(nodeTargetRecord);
	if ItemManager.isActorType(sTargetRecordType) then
		local msg = {font = "msgfont", icon = "coins"};
		msg.text = "Parcel [" .. DB.getValue(DB.getPath(nodeParcel, "name"), "") .. "] -> [" .. DB.getValue(DB.getPath(nodeTargetRecord, "name"), "") .. "]";
		Comm.deliverChatMessage(msg);
	end
end

--
-- ADD/TRANSFER STRING
--

function sendItemStringTransfer(sTargetRecord, sItemName, nItemCount)
	local msgOOB = {};
	msgOOB.type = ItemManager.OOB_MSGTYPE_TRANSFERITEMSTRING;
	
	msgOOB.sTarget = sTargetRecord;
	msgOOB.sName = sItemName;
	msgOOB.nCount = nItemCount;

	Comm.deliverOOBMessage(msgOOB, "");
end
-- NOTE: Assume that we are running on host
function handleItemStringTransfer(msgOOB)
	local nodeTargetRecord = DB.findNode(msgOOB.sTarget);
	if not nodeTargetRecord then
		return;
	end
	local sTargetList = ItemManager.getTargetInventoryListPath(nodeTargetRecord);
	if not sTargetList then
		return;
	end
	
	local sItem = StringManager.trim(msgOOB.sName);
	if sItem == "" or sItem == "-" then
		return;
	end
	
	local nCount = tonumber(msgOOB.nCount) or 1;
	
	ItemManager.addStringToList(DB.getPath(nodeTargetRecord, sTargetList), sItem, nCount);
end

--
-- INVENTORY SORTING
--

function onInventorySortCompare(w1, w2)
	-- Sort by containment first; empty container to bottom
	if w1.hidden_locationpath and w2.hidden_locationpath then
		local sLoc1 = w1.hidden_locationpath.getValue();
		local sLoc2 = w2.hidden_locationpath.getValue();
		if sLoc1 ~= sLoc2 then
			if sLoc1 == "" then
				if sLoc2 == "" then
					return nil;
				end
				return true;
			elseif sLoc2 == "" then
				return false;
			else
				return sLoc1 > sLoc2;
			end
		end
	end

	-- If same container, then sort by name; empty name to bottom
	local sName1 = ItemManager.getSortName(w1.getDatabaseNode());
	local sName2 = ItemManager.getSortName(w2.getDatabaseNode());
	if sName1 == "" then
		if sName2 == "" then
			return nil;
		end
		return true;
	elseif sName2 == "" then
		return false;
	elseif sName1 ~= sName2 then
		return sName1 > sName2;
	end
	
	-- Return nothing to sort by internal node name
end
function getInventorySortPath(cList, w)
	if not w.name or not w.location then
		return {}, false;
	end
	
	local sName = ItemManager.getSortName(w.getDatabaseNode());
	local sLocation = StringManager.trim(w.location.getValue()):lower();
	if (sLocation == "") or (sName == sLocation) then
		return { sName }, false;
	end
	
	for _,wList in ipairs(cList.getWindows()) do
		local sListName = ItemManager.getSortName(wList.getDatabaseNode());
		if sListName == sLocation then
			local aSortPath = ItemManager.getInventorySortPath(cList, wList);
			table.insert(aSortPath, sName);
			return aSortPath, true;
		end
	end
	return { sLocation, sName }, false;
end
function onInventorySortUpdate(cList)
	for _,w in ipairs(cList.getWindows()) do
		if not w.hidden_locationpath then
			w.createControl("hsc", "hidden_locationpath");
		end
		local aSortPath, bContained = ItemManager.getInventorySortPath(cList, w);
		w.hidden_locationpath.setValue(table.concat(aSortPath, "\a"));
		if w.name then
			if bContained then
				w.name.setAnchor("left", nil, "left", "absolute", 35 + (10 * (#aSortPath - 1)));
			else
				w.name.setAnchor("left", nil, "left", "absolute", 35);
			end
		end
		if w.nonid_name then
			if bContained then
				w.nonid_name.setAnchor("left", nil, "left", "absolute", 35 + (10 * (#aSortPath - 1)));
			else
				w.nonid_name.setAnchor("left", nil, "left", "absolute", 35);
			end
		end
	end
	
	cList.applySort();
end

--
--	DEPRECATION
--

function getAllInventoryListPaths(nodeTarget)
	Debug.console("ItemManager.getAllInventoryListPaths - DEPRECATED - 2024-06-11 - Use ItemManager.getInventoryPaths(sRecordType)");
	return ItemManager.helperGetAllRecordInventoryPaths(nodeTarget);
end
function getTransferClass(nodeItem)
	Debug.console("ItemManager.getTransferClass - DEPRECATED - 2024-06-11 - Just returns 'item', no longer needed");
	return "item";
end
