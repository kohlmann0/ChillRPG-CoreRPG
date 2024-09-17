-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _bDelayedChildrenChanged = false;
local _bDelayedRebuild = false;

function onInit()
	ListManager.initCustomList(self);

	local node = getDatabaseNode();
	if node then
		local sRecordType = LibraryData.getRecordTypeFromPath(DB.getPath(node));
		if (sRecordType or "") ~= "" then
			self.setRecordType(sRecordType);
		end
	end

	self.loadViewState();

	Module.addEventHandler("onModuleLoad", onModuleLoadAndUnload);
	Module.addEventHandler("onModuleUnload", onModuleLoadAndUnload);
end
function onClose()
	self.saveViewState();
	
	ListManager.onCloseWindow(self);
	
	self.removeHandlers();
end

function loadViewState(s)
	local sRecord = getDatabasePath();
	if (sRecord or "") == "" then
		return;
	end

	local sClass = getClass();
	local tState = CampaignRegistry and CampaignRegistry.windowstate and CampaignRegistry.windowstate[sClass] and CampaignRegistry.windowstate[sClass][sRecord];
	if not tState then
		return;
	end

	self.handleCategorySelect(tState.category or "");
end
function saveViewState()
	if not CampaignRegistry then
		return;
	end
	local sRecord = getDatabasePath();
	if (sRecord or "") == "" then
		return;
	end
	local sClass = getClass();

	local sCategory = self.getCategoryFilter();
	if sCategory ~= "*" then
		CampaignRegistry.windowstate = CampaignRegistry.windowstate or {};
		CampaignRegistry.windowstate[sClass] = CampaignRegistry.windowstate[sClass] or {};
		CampaignRegistry.windowstate[sClass][sRecord] = { category = self.getCategoryFilter(), };
	else
		local tState = CampaignRegistry and CampaignRegistry.windowstate and CampaignRegistry.windowstate[sClass] and CampaignRegistry.windowstate[sClass][sRecord];
		if tState then
			CampaignRegistry.windowstate[sClass][sRecord] = nil;
		end
	end
end

function onModuleLoadAndUnload(sModule)
	local nodeRoot = DB.getRoot(sModule);
	if nodeRoot then
		local vNodes = LibraryData.getMappings(self.getRecordType());
		for i = 1, #vNodes do
			if DB.getChild(nodeRoot, vNodes[i]) then
				_bDelayedRebuild = true;
				self.onListRecordsChanged(true);
				break;
			end
		end
	end
end
function addHandlers()
	function addHandlerHelper(node, bIDMode, bCategoryMode)
		local sPath = DB.getPath(node);
		local sChildPath = sPath .. ".*@*";
		DB.addHandler(sChildPath, "onAdd", onChildAdded);
		DB.addHandler(sChildPath, "onDelete", onChildDeleted);
		DB.addHandler(sChildPath, "onObserverUpdate", onChildObserverUpdate);
		DB.addHandler(DB.getPath(sChildPath, "name"), "onUpdate", onChildNameChange);
		if bIDMode then
			DB.addHandler(DB.getPath(sChildPath, "nonid_name"), "onUpdate", onChildUnidentifiedNameChange);
			DB.addHandler(DB.getPath(sChildPath, "isidentified"), "onUpdate", onChildIdentifiedChange);
		end
		if bCategoryMode then
			DB.addHandler(sChildPath, "onCategoryChange", onChildCategoryChange);
			DB.addHandler(sPath, "onChildCategoriesChange", onChildCategoriesChanged);
		end
		for _,tCustomFilter in pairs(self.getAllCustomFilters()) do
			DB.addHandler(DB.getPath(sChildPath, tCustomFilter.sField), "onUpdate", onChildCustomFilterValueChange);
		end
	end
	
	local sRecordType = self.getRecordType();
	local bIDMode = LibraryData.getIDMode(sRecordType);
	local bCategoryMode = LibraryData.getCategoryMode(sRecordType);
	local vNodes = LibraryData.getMappings(sRecordType);
	for i = 1, #vNodes do
		addHandlerHelper(vNodes[i], bIDMode, bCategoryMode);
	end
end
function removeHandlers()
	function removeHandlerHelper(node, bIDMode, bCategoryMode)
		local sPath = DB.getPath(node);
		local sChildPath = sPath .. ".*@*";
		DB.removeHandler(sChildPath, "onAdd", onChildAdded);
		DB.removeHandler(sChildPath, "onDelete", onChildDeleted);
		DB.removeHandler(sChildPath, "onObserverUpdate", onChildObserverUpdate);
		DB.removeHandler(DB.getPath(sChildPath, "name"), "onUpdate", onChildNameChange);
		if bIDMode then
			DB.removeHandler(DB.getPath(sChildPath, "nonid_name"), "onUpdate", onChildUnidentifiedNameChange);
			DB.removeHandler(DB.getPath(sChildPath, "isidentified"), "onUpdate", onChildIdentifiedChange);
		end
		if bCategoryMode then
			DB.removeHandler(sChildPath, "onCategoryChange", onChildCategoryChange);
			DB.removeHandler(sPath, "onChildCategoriesChange", onChildCategoriesChanged);
		end
		for _,tCustomFilter in pairs(self.getAllCustomFilters()) do
			DB.removeHandler(DB.getPath(sChildPath, tCustomFilter.sField), "onUpdate", onChildCustomFilterValueChange);
		end
	end
	
	local sRecordType = self.getRecordType();
	local bIDMode = LibraryData.getIDMode(sRecordType);
	local bCategoryMode = LibraryData.getCategoryMode(sRecordType);
	local vNodes = LibraryData.getMappings(sRecordType);
	for i = 1, #vNodes do
		removeHandlerHelper(vNodes[i], bIDMode, bCategoryMode);
	end
end

local _sRecordType = "";
function getRecordType()
	return _sRecordType;
end
function setRecordType(sRecordType)
	if sRecordType == self.getRecordType() then
		return;
	end
	
	self.removeHandlers();
	self.clearButtons();
	self.clearCustomFilters();

	_sRecordType = sRecordType;

	local sDisplayTitle = LibraryData.getDisplayText(sRecordType);
	title.setValue(sDisplayTitle);
	setTooltipText(sDisplayTitle);
	
	self.setupEditTools();
	self.setupCategories();
	self.setupButtons();
	self.setupCustomFilters();

	self.rebuildList();
	self.addHandlers();
end

local _tRecords = {};
function getAllRecords()
	return _tRecords;
end
function clearRecords()
	_tRecords = {};
end

function onListChanged()
	if _bDelayedChildrenChanged then
		self.onListRecordsChanged(false);
	end
end
function onSortCompare(w1, w2)
	local tRecords = self.getAllRecords();
	return not ListManager.defaultSortFunc(tRecords[w1.getDatabaseNode()], tRecords[w2.getDatabaseNode()]);
end

function setupEditTools()
	list_iadd.setRecordType(LibraryData.getRecordDisplayClass(self.getRecordType()));
	local bAllowEdit = LibraryData.allowEdit(self.getRecordType());
	list_iedit.setVisible(bAllowEdit);
	list_iadd.setVisible(bAllowEdit);

	list.setReadOnly(not bAllowEdit);
	list.resetMenuItems();
	if not list.isReadOnly() and bAllowEdit then
		list.registerMenuItem(Interface.getString("list_menu_createitem"), "insert", 5);
	end
end

local _tEditControls = {};
function clearButtons()
	sub_buttons.setValue("", "");
	
	for _,v in ipairs(_tEditControls) do
		v.destroy();
	end
	_tEditControls = {};
end
function setupButtons()
	local aIndexButtons = LibraryData.getIndexButtons(self.getRecordType());
	if #aIndexButtons > 0 then
		sub_buttons.setValue("masterindex_buttons", "");
		for k,v in ipairs(aIndexButtons) do
			sub_buttons.subwindow.createControl(v, "button_custom" .. k);
		end
	end

	local aEditButtons = LibraryData.getEditButtons(self.getRecordType());
	if #aEditButtons > 0 then
		for k,v in ipairs(aEditButtons) do
			local c = createControl(v, "button_edit" .. k);
			if c then
				c.setVisible(true);
				table.insert(_tEditControls, c);
			end
		end
	end
end

function rebuildList(bSkipRefresh)
	local sListDisplayClass = LibraryData.getIndexDisplayClass(self.getRecordType());
	if sListDisplayClass ~= "" then
		list.setChildClass(sListDisplayClass);
	end
	
	self.clearRecords();
	RecordManager.callForEachRecord(self.getRecordType(), self.addListRecord);

	ListManager.setDisplayOffset(self, 0, true);
	if not bSkipRefresh then
		self.onListRecordsChanged();
	end
end

function onChildAdded(node)
	self.addListRecord(node);
	self.onListRecordsChanged(true);
end
function onChildDeleted(node)
	local tRecords = self.getAllRecords();
	if tRecords[node] then
		tRecords[node] = nil;
		self.onListRecordsChanged(true);
	end
end
function onChildCategoriesChanged()
	self.onListRecordsChanged(true);
end
function onListRecordsChanged(bAllowDelay)
	if bAllowDelay then
		ListManager.helperSaveScrollPosition(self);
		_bDelayedChildrenChanged = true;
		list.setDatabaseNode(nil);
	else
		_bDelayedChildrenChanged = false;
		if _bDelayedRebuild then
			_bDelayedRebuild = false;
			self.rebuildList(true);
		end
		self.rebuildCategories();
		self.rebuildCustomFilterValues();
		self.refreshDisplayList();
	end
end
function addListRecord(node)
	local rRecord = {};
	rRecord.node = node;
	rRecord.sCategory = DB.getCategory(node);
	rRecord.nAccess = UtilityManager.getNodeAccessLevel(node);
	
	rRecord.bIdentifiable = LibraryData.isIdentifiable(self.getRecordType(), node);
	if rRecord.bIdentifiable and not self.getRecordIDState(rRecord) then
		rRecord.sDisplayName = DB.getValue(node, "nonid_name", "");
	else
		rRecord.sDisplayName = DB.getValue(node, "name", "");
	end
	rRecord.sDisplayNameLower = Utility.convertStringToLower(rRecord.sDisplayName);

	rRecord.aCustomValues = {};
	for sKey,tCustomFilter in pairs(self.getAllCustomFilters()) do
		rRecord.aCustomValues[sKey] = DB.getValue(node, tCustomFilter.sField, "");
	end

	self.getAllRecords()[node] = rRecord;
end

function getRecordIDState(vRecord)
	return LibraryData.getIDState(self.getRecordType(), vRecord.node);
end
function onIDChanged()
	for _,w in ipairs(list.getWindows()) do
		w.onIDChanged();
	end
	self.refreshDisplayList();
end

function onChildCategoryChange(node)
	local tRecords = self.getAllRecords();
	if tRecords[node] then
		tRecords[node].sCategory = DB.getCategory(node);
		if self.getCategoryFilter() ~= "*" then
			self.refreshDisplayList();
		else
			for _,w in ipairs(list.getWindows()) do
				if node == w.getDatabaseNode() then
					w.onCategoryChange();
					break;
				end
			end
		end
	end
end
function onChildObserverUpdate(node)
	local tRecords = self.getAllRecords();
	if tRecords[node] then
		tRecords[node].nAccess = UtilityManager.getNodeAccessLevel(node);
		if self.getSharedOnlyFilter() then
			self.refreshDisplayList();
		end
	end
end
function onChildCustomFilterValueChange(node)
	local sNodeName = DB.getName(node);
	for sKey,tCustomFilter in pairs(self.getAllCustomFilters()) do
		if tCustomFilter.sField == sNodeName then
			self.rebuildCustomFilterValueHelper(sKey);
			if self.getCustomFilterValue(sKey) ~= "" then
				self.refreshDisplayList();
			end
			break;
		end
	end
end
function onChildNameChange(vNameNode)
	local node = DB.getParent(vNameNode);
	local rRecord = self.getAllRecords()[node];
	if not rRecord.bIdentifiable or self.getRecordIDState(rRecord) then
		rRecord.sDisplayName = DB.getValue(node, "name", "");
		rRecord.sDisplayNameLower = Utility.convertStringToLower(rRecord.sDisplayName);
		self.refreshDisplayList();
	end
end
function onChildUnidentifiedNameChange(vNameNode)
	local node = DB.getParent(vNameNode);
	local rRecord = self.getAllRecords()[node];
	if rRecord.bIdentifiable and not self.getRecordIDState(rRecord) then
		rRecord.sDisplayName = DB.getValue(node, "nonid_name", "");
		rRecord.sDisplayNameLower = Utility.convertStringToLower(rRecord.sDisplayName);
		self.refreshDisplayList();
	end
end
function onChildIdentifiedChange(vIDNode)
	local node = DB.getParent(vIDNode);
	local rRecord = self.getAllRecords()[node];
	if rRecord.bIdentifiable and not Session.IsHost then
		if self.getRecordIDState(rRecord) then
			rRecord.sDisplayName = DB.getValue(node, "name", "");
		else
			rRecord.sDisplayName = DB.getValue(node, "nonid_name", "");
		end
		rRecord.sDisplayNameLower = Utility.convertStringToLower(rRecord.sDisplayName);
		self.refreshDisplayList();
	end
end

local _bAllowCategories = true;
local _sFilterCategory = "";
local _sDelayedCategoryFocus = nil;
function setupCategories()
	_bAllowCategories = LibraryData.getCategoryMode(self.getRecordType());
	if _bAllowCategories then
		sub_category.setValue("masterindex_categories", "");
	else
		sub_category.setValue("", "");
	end
	self.handleCategorySelect("*");
end
function areCategoriesAllowed()
	return _bAllowCategories;
end
function getCategoryFilter()
	return _sFilterCategory;
end
function handleCategorySelect(sCategory)
	if not self.areCategoriesAllowed() then
		return;
	end
	
	_sFilterCategory = sCategory;

	if _sFilterCategory == "*" then
		sub_category.subwindow.filter_category_label.setValue(Interface.getString("masterindex_label_category_all"));
	elseif _sFilterCategory == "" then
		sub_category.subwindow.filter_category_label.setValue(Interface.getString("masterindex_label_category_empty"));
	else
		sub_category.subwindow.filter_category_label.setValue(_sFilterCategory);
	end
	
	for _,w in ipairs(sub_category.subwindow.list_category.getWindows()) do
		w.setActiveByKey(_sFilterCategory);
	end
	
	sub_category.subwindow.button_category_detail.setValue(0);
	
	local sDefaultCategory = sCategory;
	if sDefaultCategory == "*" then
		sDefaultCategory = "";
	end
	for _,vMapping in ipairs(LibraryData.getMappings(self.getRecordType())) do
		DB.setDefaultChildCategory(vMapping, sDefaultCategory);
	end

	ListManager.setDisplayOffset(self, 0, true);
	self.refreshDisplayList(true);
end
function handleCategoryNameChange(sOriginal, sNew)
	if sOriginal == sNew then
		return;
	end
	for _,vMapping in ipairs(LibraryData.getMappings(self.getRecordType())) do
		DB.updateChildCategory(vMapping, sOriginal, sNew, true);
	end
end
function handleCategoryDelete(sName)
	for _,vMapping in ipairs(LibraryData.getMappings(self.getRecordType())) do
		DB.removeChildCategory(vMapping, sName, true);
	end
end
function handleCategoryAdd()
	local aMappings = LibraryData.getMappings(self.getRecordType());
	_sDelayedCategoryFocus = DB.addChildCategory(aMappings[1]);
end
function rebuildCategories()
	if not self.areCategoriesAllowed() then
		return;
	end
	
	local aCategories = {};
	for _,vMapping in ipairs(LibraryData.getMappings(self.getRecordType())) do
		for _,vCategory in ipairs(DB.getChildCategories(vMapping, true)) do
			if type(vCategory) == "string" then
				aCategories[vCategory] = vCategory;
			else
				aCategories[vCategory.name] = vCategory.name;
			end
		end
	end
	aCategories["*"] = Interface.getString("masterindex_label_category_all");
	aCategories[""] = Interface.getString("masterindex_label_category_empty");

	local sFilterCategory = self.getCategoryFilter();
	sub_category.subwindow.list_category.closeAll();
	for kCategory,vCategory in pairs(aCategories) do
		local w = sub_category.subwindow.list_category.createWindow();
		w.setData(kCategory, vCategory, (sFilterCategory == kCategory));
	end
	sub_category.subwindow.list_category.applySort();
	
	if not aCategories[sFilterCategory] then
		self.handleCategorySelect("*");
	end
	
	if sub_category.subwindow.button_category_iedit.getValue() == 1 then
		sub_category.subwindow.button_category_iedit.setValue(0);
		sub_category.subwindow.button_category_iedit.setValue(1);
	end

	if _sDelayedCategoryFocus then
		for _,w in ipairs(sub_category.subwindow.list_category.getWindows()) do
			if w.getCategory() == _sDelayedCategoryFocus then
				w.category_label.setFocus();
				break;
			end
		end
		_sDelayedCategoryFocus = nil;
	end
end

local _sFilterName = "";
function onNameFilterChanged()
	_sFilterName = Utility.convertStringToLower(filter_name.getValue());
	self.refreshDisplayList(true);
end
function getNameFilter()
	return _sFilterName;
end
function clearNameFilter()
	if self.getNameFilter() ~= "" then
		filter_name.setValue();
	end
end

local _bFilterSharedOnly = false;
function onSharedOnlyFilterChanged()
	_bFilterSharedOnly = (filter_sharedonly.getValue() == 1);
	self.refreshDisplayList(true);
end
function getSharedOnlyFilter()
	return _bFilterSharedOnly;
end
function clearSharedOnlyFilter()
	if self.getSharedOnlyFilter() then
		filter_sharedonly.setValue(0);
	end
end

local _tCustomFilters = {};
function getAllCustomFilters()
	return _tCustomFilters;
end
function getCustomFilter(sKey)
	return _tCustomFilters[sKey];
end
function clearCustomFilters()
	self.clearCustomFilterControls();
	_tCustomFilters = {};
end
function setupCustomFilters()
	_tCustomFilters = LibraryData.getCustomFilters(self.getRecordType());
	
	local tSortedFilters = {};
	for sKey,_ in pairs(_tCustomFilters) do
		table.insert(tSortedFilters, sKey);
	end
	if #tSortedFilters == 0 then
		return;
	end

	table.sort(tSortedFilters);
	for i = #tSortedFilters, 1, -1 do
		self.addCustomFilterControl(tSortedFilters[i]);
		self.setCustomFilterValue(tSortedFilters[i], "");
	end
	createControl("masterindex_filter_custom_spacer");
end

local _tCustomFilterValues = {};
function onCustomFilterValueChanged(sKey, cFilterValue)
	self.setCustomFilterValue(sKey, cFilterValue.getValue());
	self.refreshDisplayList(true);
end
function getAllCustomFilterValues()
	return _tCustomFilterValues;
end
function getCustomFilterValue(sKey)
	return _tCustomFilterValues[sKey] or "";
end
function setCustomFilterValue(sKey, s)
	_tCustomFilterValues[sKey] = s:lower();
end

local _tCustomFilterControls = {};
local _tCustomFilterValueControls = {};
function clearCustomFilterControls()
	for _,c in pairs(_tCustomFilterValueControls) do
		c.onDestroy();
		c.destroy();
	end
	_tCustomFilterValueControls = {};
	for _,c in pairs(_tCustomFilterControls) do
		c.destroy();
	end
	_tCustomFilterControls = {};
end
function addCustomFilterControl(sKey)
	local c = createControl("masterindex_filter_custom", "filter_custom_" .. sKey);
	c.setValue(sKey);
	_tCustomFilterControls[sKey] = c;

	local c2 = createControl("masterindex_filter_custom_value",  "filter_custom_value_" .. sKey);
	c2.setFilterType(sKey);
	_tCustomFilterValueControls[sKey] = c2;
end
function getCustomFilterValueControl(sKey)
	return _tCustomFilterValueControls[sKey];
end
function clearCustomFilterValueControl(sKey)
	if _tCustomFilterValueControls[sKey] then
		_tCustomFilterValueControls[sKey].setValue("");
	end
end

function rebuildCustomFilterValues()
	for sKey,_ in pairs(self.getAllCustomFilters()) do
		self.rebuildCustomFilterValueHelper(sKey);
	end
end
function rebuildCustomFilterValueHelper(sKey)
	local cFilter = self.getCustomFilterValueControl(sKey);
	if not cFilter then
		return;
	end

	local tFilterValues = {};
	local tRecords = self.getAllRecords();
	for _,vRecord in pairs(tRecords) do
		if cFilter then
			local vValues = self.getFilterValues(sKey, vRecord.node);
			for _,v in ipairs(vValues) do
				if (v or "") ~= "" then
					tFilterValues[v] = true;
				end
			end
		end
	end

	cFilter.clear();
	if not tFilterValues[cFilter.getValue()] then
		cFilter.setValue("");
	end

	local tSortedFilterValues = {};
	for k,_ in pairs(tFilterValues) do
		table.insert(tSortedFilterValues, k);
	end
	local tCustomFilter = self.getCustomFilter(sKey);
	if tCustomFilter.fSort then
		tSortedFilterValues = tCustomFilter.fSort(tSortedFilterValues);
	elseif tCustomFilter.sType == "number" then
		table.sort(tSortedFilterValues, function(a,b) return (tonumber(a) or 0) < (tonumber(b) or 0); end);
	else
		table.sort(tSortedFilterValues);
	end
	table.insert(tSortedFilterValues, 1, "");
	cFilter.addItems(tSortedFilterValues);
end
function getFilterValues(sKey, node)
	local vValues = {};
	
	local tCustomFilter = self.getCustomFilter(sKey);
	if tCustomFilter then
		if tCustomFilter.fGetValue then
			vValues = tCustomFilter.fGetValue(node);
			if type(vValues) ~= "table" then
				vValues = { vValues };
			end
		elseif tCustomFilter.sType == "boolean" then
			if DB.getValue(node, tCustomFilter.sField, 0) ~= 0 then
				vValues = { LibraryData.sFilterValueYes };
			else
				vValues = { LibraryData.sFilterValueNo };
			end
		else
			local vValue = DB.getValue(node, tCustomFilter.sField);
			if tCustomFilter.sType == "number" then
				vValues = { tostring(vValue or 0) };
			else
				local sValue;
				if vValue then
					sValue = tostring(vValue) or "";
				else
					sValue = "";
				end
				if sValue == "" then
					vValues = { LibraryData.sFilterValueEmpty };
				else
					vValues = { sValue };
				end
			end
		end
	end
	
	return vValues;
end

function clearFilterValues()
	self.clearSharedOnlyFilter();
	self.clearNameFilter();
	for sKey,_ in pairs(self.getAllCustomFilters()) do
		self.clearCustomFilterValueControl(sKey);
	end
end

--
--	LIST HANDLING
--

function addEntry()
	list_iadd.onButtonPress();
end

function refreshDisplayList(bResetScroll)
	ListManager.refreshDisplayList(self, bResetScroll);
end
function addDisplayListItem(v)
	local wItem = list.createWindow(v.node);
	if wItem.category and (self.getCategoryFilter() ~= "*") then
		wItem.category.setVisible(false);
	end
	wItem.setRecordType(self.getRecordType());
end

function isFilteredRecord(v)
	if self.areCategoriesAllowed() then
		local sFilterCategory = self.getCategoryFilter();
		if (sFilterCategory ~= "*") and (v.sCategory ~= sFilterCategory) then
			return false;
		end
	end
	if self.getSharedOnlyFilter() then
		if v.nAccess == 0 then
			return false;
		end
	end
	for sKey,sFilter in pairs(self.getAllCustomFilterValues()) do
		if sFilter ~= "" then
			local vValues = self.getFilterValues(sKey, v.node);
			local bMatch = false;
			for _,v in ipairs(vValues) do
				if v:lower() == sFilter then
					bMatch = true;
					break;
				end
			end
			if not bMatch then
				return false;
			end
		end
	end
	local sNameFilter = self.getNameFilter();
	if sNameFilter ~= "" then
		if not string.find(v.sDisplayNameLower, sNameFilter, 0, true) then
			return false;
		end
	end
	return true;
end
