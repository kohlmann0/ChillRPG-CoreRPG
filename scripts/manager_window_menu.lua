-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onTabletopInit()
	WindowMenuManager.registerToolbarButtons();
end

function registerToolbarButtons()
	-- Window: General
	ToolbarManager.registerButton("link", 
		{
			sType = "action",
			sIcon = "button_toolbar_link",
			sTooltipRes = "button_toolbar_link",
			fnDrag = WindowMenuManager.onMenuLinkDrag,
			sHoverCursor = "hand",
		});
	ToolbarManager.registerButton("close", 
		{
			sType = "action",
			sIcon = "button_toolbar_window_close",
			sTooltipRes = "button_toolbar_window_close",
			fnActivate = WindowMenuManager.performMenuClose,
		});
	ToolbarManager.registerButton("help", 
		{
			sType = "action",
			sIcon = "button_toolbar_help",
			sTooltipRes = "button_toolbar_help",
			fnActivate = WindowMenuManager.performMenuHelp,
		});
	ToolbarManager.registerButton("minimize",
		{
			sType = "action",
			sIcon = "button_toolbar_window_minimize",
			sTooltipRes = "button_toolbar_window_minimize",
			fnActivate = WindowMenuManager.performMenuMinimize,
		});

	-- Record: General
	ToolbarManager.registerButton("static",
		{
			sType = "action",
			sIcon = "button_toolbar_readonly",
			sTooltipRes = "button_toolbar_readonly",
			bReadOnly = true,
		});
	ToolbarManager.registerButton("locked", 
		{ 
			sType = "field",
			{ icon="button_toolbar_locked_false", tooltipres="button_toolbar_locked_false" },
			{ icon="button_toolbar_locked_true", tooltipres="button_toolbar_locked_true" },
			fnOnInit = WindowMenuManager.onMenuLockInit,
			fnGetDefault = WindowMenuManager.onMenuLockGetDefault,
			sValueChangeEvent = "onLockChanged",
		});
	ToolbarManager.registerButton("isidentified", 
		{ 
			sType = "field",
			{ icon="button_toolbar_id_false", tooltipres="button_toolbar_id_false" },
			{ icon="button_toolbar_id_true", tooltipres="button_toolbar_id_true" },
			nDefault = 1,
			fnOnInit = WindowMenuManager.onMenuIdentifiedInit,
			sValueChangeEvent = "onIDChanged",
		});
	ToolbarManager.registerButton("module",
		{
			sType = "action",
			sIcon = "button_toolbar_module",
			sTooltipRes = "button_toolbar_module",
			fnOnInit = WindowMenuManager.onInitMenuModule,
			bReadOnly = true,
		});
	ToolbarManager.registerButton("revert",
		{
			sType = "action",
			sIcon = "button_toolbar_revert",
			sTooltipRes = "button_toolbar_revert",
			fnOnInit = WindowMenuManager.onInitMenuRevert,
			fnActivate = WindowMenuManager.performMenuRevert,
			sDatabaseEvent = "onIntegrityChange",
			fnOnDatabaseEvent = WindowMenuManager.onDatabaseEventMenuRevert,
			bHostOnly = true,
		});

	ToolbarManager.registerButton("share",
		{
			sType = "action",
			fnOnInit = WindowMenuManager.onInitMenuShare,
			fnActivate = WindowMenuManager.performMenuShare,
			sDatabaseEvent = "onObserverUpdate",
			fnOnDatabaseEvent = WindowMenuManager.onDatabaseEventMenuShare,
		});

	ToolbarManager.registerButton("chat_output",
		{
			sType = "action",
			sIcon = "button_toolbar_chat",
			sTooltipRes = "record_toolbar_chat",
			fnActivate = WindowMenuManager.performMenuChatOutput,
		});
	ToolbarManager.registerButton("chat_speak",
		{
			sType = "action",
			sIcon = "button_toolbar_speak",
			sTooltipRes = "record_toolbar_speak",
			fnActivate = WindowMenuManager.performMenuChatSpeak,
			bHostOnly = true,
		});

	-- Record: Parcel
	ToolbarManager.registerButton("id_all",
		{
			sType = "action",
			sIcon = "button_toolbar_id_true",
			sTooltipRes = "parcel_tooltip_id_all",
			fnActivate = WindowMenuManager.performMenuIDAll,
			bHostOnly = true,
		});

	-- Record: Image
	ToolbarManager.registerButton("size_up",
		{
			sType = "action",
			sIcon = "button_toolbar_size_up",
			sTooltipRes = "button_toolbar_size_up";
			fnActivate = WindowMenuManager.performMenuSizeUp,
		});
	ToolbarManager.registerButton("size_down",
		{
			sType = "action",
			sIcon = "button_toolbar_size_down",
			sTooltipRes = "button_toolbar_size_down";
			fnActivate = WindowMenuManager.performMenuSizeDown,
		});
end

--
--	MENU BAR
--

function populate(w)
	WindowMenuManager.buildToolbar(w);
end
function buildToolbar(w)
	local wTop = UtilityManager.getTopWindow(w);

	local sRecordType = LibraryData.getRecordTypeFromWindow(wTop);

	local tCustomRecordType;
	if (sRecordType or "") ~= "" then
		tCustomRecordType = LibraryData.getCustomData(sRecordType, "tWindowMenu") or {};
	else
		tCustomRecordType = WindowMenuManager.getCustomMenuData(wTop) or {};
	end
	tCustomRecordType["left"] = WindowMenuManager.checkButtons(tCustomRecordType["left"]);
	tCustomRecordType["right"] = WindowMenuManager.checkButtons(tCustomRecordType["right"]);

	local nodeWin = wTop.getDatabaseNode();
	local bReadOnly = false;
	local bOwner = false;
	if nodeWin then
		bReadOnly = DB.isReadOnly(nodeWin);
		bOwner = DB.isOwner(nodeWin);
	end

	-- LEFT MENU BUTTONS
	local tLeftButtons = {};
	if (sRecordType or "") ~= "" then
		table.insert(tLeftButtons, "link");

		if nodeWin then
			if Session.IsHost then
				if ((DB.getModule(nodeWin) or "") ~= "") then
					table.insert(tLeftButtons, "");
					table.insert(tLeftButtons, "module");
					if not bReadOnly then
						table.insert(tLeftButtons, "revert");
					end
				end
			end
		end
	else
		if not wTop.windowmenu or not wTop.windowmenu[1].nolink then
			table.insert(tLeftButtons, "link");
		end
	end
	if tCustomRecordType["left"] then
		if #tLeftButtons > 0 then
			table.insert(tLeftButtons, "");
		end
		for _,v in ipairs(tCustomRecordType["left"]) do
			table.insert(tLeftButtons, v);
		end
	end
	ToolbarManager.addList(w, tLeftButtons, "left");

	-- RIGHT MENU BUTTONS
	local tRightButtons = {};
	if wTop and not wTop.noclose then
		table.insert(tRightButtons, "close");
	end
	if (sRecordType or "") == "image" then
		table.insert(tRightButtons, "size_up");
	end
	if wTop and wTop.isMinimizeable() then
		table.insert(tRightButtons, "minimize");
	end
	if wTop and wTop.helplinkres or wTop.helplink or w.getWindowMenuHelpLink then
		table.insert(tRightButtons, "help");
	end
	local bShare = false;
	local bLock = false;
	local bID = false;
	if ((sRecordType or "") ~= "") then
		bShare = bOwner and LibraryData.getShareMode(sRecordType);
		bLock = bOwner and LibraryData.getLockMode(sRecordType);
		bID = LibraryData.isIdentifiable(sRecordType, nodeWin);
	else
		if (wTop.getFrame() == "recordsheet") and (not wTop.windowmenu or not wTop.windowmenu[1].nolock) then
			bLock = true;
		end
	end
	if bShare or bLock or bID then
		if #tRightButtons > 0 then
			table.insert(tRightButtons, "");
		end
		if bShare then
			table.insert(tRightButtons, "share");
		end
		if bLock then
			if bReadOnly then
				table.insert(tRightButtons, "static");
			else
				table.insert(tRightButtons, "locked");
			end
		end
		if bID then
			table.insert(tRightButtons, "isidentified");
		end
	end
	if tCustomRecordType["right"] then
		if #tRightButtons > 0 then
			table.insert(tRightButtons, "");
		end
		for _,v in ipairs(tCustomRecordType["right"]) do
			table.insert(tRightButtons, v);
		end
	end
	ToolbarManager.addList(w, tRightButtons, "right");
end
function getCustomMenuData(w)
	local tData = {};

	local tMenu = w.windowmenu and w.windowmenu[1];
	if tMenu then
		if tMenu.left then
			tData["left"] = {};
			for _,v in ipairs(tMenu.left) do
				table.insert(tData["left"], v);
			end
		end
		if tMenu.right then
			tData["right"] = {};
			for _,v in ipairs(tMenu.right) do
				table.insert(tData["right"], v);
			end
		end
	end
	return tData;
end
function checkButtons(t)
	if not t then
		return nil;
	end

	local tResults = {};
	for _,v in ipairs(t) do	
		if ToolbarManager.checkButton(v) then
			table.insert(tResults, v);
		end
	end
	return t;
end

--
--	MENU BUTTONS - STANDARD
--

function onMenuLinkDrag(c, draginfo)
	local wTop = UtilityManager.getTopWindow(c.window);
	if wTop.onMenuLinkDrag then
		return wTop.onMenuLinkDrag(draginfo);
	end

	local sClass = wTop.getClass();

	draginfo.setType("shortcut");
	draginfo.setIcon("button_link");
	draginfo.setShortcutData(sClass, wTop.getDatabasePath());
	
	local nodeWin = c.window.getDatabaseNode();
	
	local sDesc;
	local sRecordType = LibraryData.getRecordTypeFromDisplayClass(sClass);
	if (sRecordType or "") ~= "" then
		if LibraryData.getIDState(sRecordType, nodeWin, true) then
			sDesc = DB.getValue(nodeWin, "name", "");
			if sDesc == "" then
				sDesc = Interface.getString("library_recordtype_empty_" .. sRecordType);
			end
		else
			sDesc = DB.getValue(nodeWin, "nonid_name", "");
			if sDesc == "" then
				sDesc = Interface.getString("library_recordtype_empty_nonid_" .. sRecordType);
			end
		end

		local sDisplayTitle = LibraryData.getSingleDisplayText(sRecordType);
		if (sDisplayTitle or "") ~= "" then
			sDesc = sDisplayTitle .. ": " .. sDesc;
		end
	else
		if wTop.title then
			sDesc = wTop.title.getValue();
		elseif nodeWin then
			sDesc = DB.getValue(nodeWin, "name", "");
		end
	end

	draginfo.setDescription(sDesc);
	return true;
end

function onMenuLockInit(c)
	if c.initbyname then
		local nodeWin = c.window.getDatabaseNode();
		if nodeWin then
			c.setVisible(not DB.isReadOnly(nodeWin));
		end
	end
end
function onMenuLockGetDefault(c)
	if (DB.getModule(c.window.getDatabaseNode()) or "") ~= "" then
		return 1;
	end
	return 0;
end
function onMenuIdentifiedInit(c)
	if Session.IsHost then
		local bReadOnly = false;
		local nodeWin = UtilityManager.getTopWindow(c.window).getDatabaseNode();
		if nodeWin then
			bReadOnly = DB.isReadOnly(nodeWin);
		end
		c.setVisible(not bReadOnly);
	else
		c.setVisible(false);
	end
end

function performMenuClose(c)
	local w = UtilityManager.getTopWindow(c.window);
	local sClass = w.getClass();
	if StringManager.contains({ "imagebackpanel", "imagemaxpanel", "imagefullpanel", }, sClass) then
		ImageManager.closePanel();
	else
		w.close();
	end
end
function performMenuHelp(c)
	local w = UtilityManager.getTopWindow(c.window);
	if w.helplinkres then
		sURL = Interface.getString(w.helplinkres[1]);
	elseif w.helplink then
		sURL = w.helplink[1];
	elseif w.getWindowMenuHelpLink then
		sURL = w.getWindowMenuHelpLink();
	end
	UtilityManager.sendToHelpLink(sURL);
end
function performMenuMinimize(c)
	UtilityManager.getTopWindow(c.window).minimize();
end

function onInitMenuModule(c)
	local w = UtilityManager.getTopWindow(c.window);
	local node = w.getDatabaseNode();
	if node then
		local sModule = DB.getModule(node);
		if (sModule or "") ~= "" then
			local tModuleInfo = Module.getModuleInfo(sModule);
			local sDisplayName = tModuleInfo and tModuleInfo.displayname or sModule;
			c.setTooltipText(string.format("%s - %s", Interface.getString("button_toolbar_module"), sDisplayName));
		end
	end
end

function onInitMenuRevert(c)
	WindowMenuManager.updateMenuRevertDisplay(c);
end
function onDatabaseEventMenuRevert(c)
	WindowMenuManager.updateMenuRevertDisplay(c);
end
function performMenuRevert(c)
	RecordManager.performRevertByWindow(UtilityManager.getTopWindow(c.window));
end
function updateMenuRevertDisplay(c)
	local wTop = UtilityManager.getTopWindow(c.window);
	local node = wTop.getDatabaseNode();
	local bShow = false;
	if node then
		bShow = not DB.isIntact(node);
	end
	c.setVisible(bShow);
end

function onInitMenuShare(c)
	WindowMenuManager.updateMenuShareDisplay(c);
end
function onDatabaseEventMenuShare(c)
	WindowMenuManager.updateMenuShareDisplay(c);
end
function performMenuShare(c)
	local w = UtilityManager.getTopWindow(c.window);
	local node = w.getDatabaseNode();
	if node then
		local nAccess = UtilityManager.getNodeAccessLevel(node);
		if nAccess == 0 then
			DB.setPublic(node, true);
			w.share();
		else
			if DB.isPublic(node) then
				DB.setPublic(node, false);
			else
				DB.removeAllHolders(node, true);
			end
		end
	end
end
function updateMenuShareDisplay(c)
	local w = UtilityManager.getTopWindow(c.window);
	local node = w.getDatabaseNode();
	if node then
		local nAccess, tHolders = UtilityManager.getNodeAccessLevel(node);
		if nAccess == 2 then
			c.setFrame("windowmenubar_button_down", 2, 2, 2, 2);
			c.setStateFrame("pressed", "windowmenubar_button", 2, 2, 2, 2);
			c.setStateIcons(0, "button_toolbar_share_public", "button_toolbar_share_off");
			c.setTooltipText(Interface.getString("button_toolbar_share_public"));
		elseif nAccess == 1 then
			c.setFrame("windowmenubar_button_down", 2, 2, 2, 2);
			c.setStateFrame("pressed", "windowmenubar_button", 2, 2, 2, 2);
			c.setStateIcons(0, "button_toolbar_share_specific", "button_toolbar_share_off");
			local sShared = string.format("%s %s", Interface.getString("button_toolbar_share_specific"), table.concat(tHolders, ", "));
			c.setTooltipText(sShared);
		else
			c.setFrame("windowmenubar_button", 2, 2, 2, 2);
			c.setStateFrame("pressed", "windowmenubar_button_down", 2, 2, 2, 2);
			c.setStateIcons(0, "button_toolbar_share_off", "button_toolbar_share_public");
			c.setTooltipText(Interface.getString("button_toolbar_share_off"));
		end
	end
end

function performMenuChatOutput(c)
	RecordShareManager.onShareButtonPressed(c.window);
end

function performMenuChatSpeak(c)
	GmIdentityManager.addIdentity(ActorManager.getDisplayName(c.window.getDatabaseNode()));
end

function performMenuIDAll(c)
	for _,nodeItem in ipairs(DB.getChildList(c.window.getDatabaseNode(), "itemlist")) do
		DB.setValue(nodeItem, "isidentified", "number", 1);
	end
end

function performMenuSizeUp(c)
	if ImageManager.isImageWindow(c.window) then
		ImageManager.performSizeUp(c.window);
	end
end
function performMenuSizeDown(c)
	if ImageManager.isImageWindow(c.window) then
		ImageManager.performSizeDown(c.window);
	end
end
