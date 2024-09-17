-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function getRecordType(w)
	return LibraryData.getRecordTypeFromWindow(UtilityManager.getTopWindow(w));
end
function updateTooltip(w)
	local sRecordType = WindowManager.getRecordType(w);
	if sRecordType == "" then
		return;
	end
	local nodeRecord = w.getDatabaseNode();
	if not nodeRecord then
		return;
	end

	local sTooltip;
	if LibraryData.getIDState(sRecordType, nodeRecord) then
		sTooltip = DB.getValue(nodeRecord, "name", "");
		if sTooltip == "" then
			sTooltip = Interface.getString("library_recordtype_empty_" .. sRecordType);
		end
	else
		sTooltip = DB.getValue(nodeRecord, "nonid_name", "");
		if sTooltip == "" then
			sTooltip = Interface.getString("library_recordtype_empty_nonid_" .. sRecordType);
		end
	end
	local sDisplayTitle = LibraryData.getSingleDisplayText(sRecordType);
	if (sDisplayTitle or "") ~= "" then
		sTooltip = sDisplayTitle .. ": " .. sTooltip;
	end
	
	UtilityManager.getTopWindow(w).setTooltipText(sTooltip);
end

function getWindowReadOnlyState(w)
	if not w then
		return true;
	end
	return WindowManager.getReadOnlyState(UtilityManager.getTopWindow(w).getDatabaseNode());
end
function getReadOnlyState(vNode)
	if not DB.isOwner(vNode) then
		return true;
	end
	if DB.isReadOnly(vNode) then
		return true;
	end
	return WindowManager.getLockedState(vNode);
end
function getLockedState(vNode)
	local nDefault = 0;
	if (DB.getModule(vNode) or "") ~= "" then
		nDefault = 1;
	end
	local bLocked = (DB.getValue(DB.getPath(vNode, "locked"), nDefault) ~= 0);
	return bLocked;
end

function getEditMode(v, s)
	return (WindowManager.getOuterControlValue(v, s) == 1);
end
function onEditModeChanged(v)
	WindowManager.callInnerFunction(v, "onEditModeChanged");
end

--
--  GENERAL GET/CALL FUNCTIONS ACROSS UI OBJECTS
--

function getOuterControlValue(v, s)
	if not v or not s then
		return nil;
	end

	if type(v) == "windowinstance" then
		if v[s] then
			return v[s].getValue();
		elseif v.parentcontrol then
			return WindowManager.getOuterControlValue(v.parentcontrol.window, s);
		elseif v.windowlist then
			return WindowManager.getOuterControlValue(v.windowlist.window, s);
		end
		return nil;
	end
	return WindowManager.getOuterControlValue(v.window, s);
end
function getInnerControlValue(v, s)
	if not v or not s then
		return nil;
	end

	local sType = type(v);
	if sType == "windowinstance" then
		if v[s] then
			return v[s].getValue();
		end
		for _,c in pairs(v.getControls()) do
			local vResult = WindowManager.getInnerControlValue(c, s);
			if vResult then
				return vResult;
			end
		end
	elseif sType == "windowlist" then
		for _,wChild in ipairs(v.getWindows()) do
			local vResult = WindowManager.getInnerControlValue(wChild, s);
			if vResult then
				return vResult;
			end
		end
	elseif sType == "subwindow" then
		if v.subwindow then
			local vResult = WindowManager.getInnerControlValue(v.subwindow, s);
			if vResult then
				return vResult;
			end
		end
	end

	return nil;
end

-- NOTE: UI cascade function calls should not return early, 
--		as all UI children up/down need to be have the option to react to function event.
function callInnerFunction(v, sFunc, ...)
	if not v or not sFunc then
		return;
	end

	if v[sFunc] then
		v[sFunc](...);
	end
	local sType = type(v);
	if sType == "windowinstance" then
		for _,c in pairs(v.getControls()) do
			WindowManager.callInnerFunction(c, sFunc, ...);
		end
	elseif sType == "windowlist" then
		for _,wChild in ipairs(v.getWindows()) do
			WindowManager.callInnerFunction(wChild, sFunc, ...);
		end
	elseif sType == "subwindow" then
		if v.subwindow then
			WindowManager.callInnerFunction(v.subwindow, sFunc, ...);
		end
	end
end
function callInnerWindowFunction(v, sFunc, ...)
	if not v or not sFunc then
		return;
	end

	local sType = type(v);
	if sType == "windowinstance" then
		if v[sFunc] then
			v[sFunc](...);
		end
		for _,c in pairs(v.getControls()) do
			WindowManager.callInnerWindowFunction(c, sFunc, ...);
		end
	elseif sType == "windowlist" then
		for _,wChild in ipairs(v.getWindows()) do
			WindowManager.callInnerWindowFunction(wChild, sFunc, ...);
		end
	elseif sType == "subwindow" then
		if v.subwindow then
			WindowManager.callInnerWindowFunction(v.subwindow, sFunc, ...);
		end
	end
end

function hasOuterWindowFunction(v, sFunc)
	if not v or not sFunc then
		return false;
	end

	if type(v) == "windowinstance" then
		if v[sFunc] then
			return true;
		elseif v.parentcontrol then
			return WindowManager.hasOuterWindowFunction(v.parentcontrol.window, sFunc);
		elseif v.windowlist then
			return WindowManager.hasOuterWindowFunction(v.windowlist.window, sFunc);
		end
	else
		return WindowManager.hasOuterWindowFunction(v.window, sFunc);
	end
end
function callOuterWindowFunction(v, sFunc, ...)
	if not v or not sFunc then
		return;
	end

	if type(v) == "windowinstance" then
		if v[sFunc] then
			return v[sFunc](...);
		elseif v.parentcontrol then
			return WindowManager.callOuterWindowFunction(v.parentcontrol.window, sFunc, ...);
		elseif v.windowlist then
			return WindowManager.callOuterWindowFunction(v.windowlist.window, sFunc, ...);
		end
	else
		return WindowManager.callOuterWindowFunction(v.window, sFunc, ...);
	end
end

function callSafeControlUpdate(w, sControl, bReadOnly, bForceHide)
	if not w or not sControl then
		return false;
	end
	local c = w[sControl];
	if not c or type(c) == "function" then
		return false;
	end

	if c.update then
		return c.update(bReadOnly, bForceHide);
	end
	c.setReadOnly(bReadOnly);
	return true;
end
function setControlVisibleWithLabel(w, sControl, bVisible)
	if not w or not sControl then
		return;
	end

	local c = w[sControl];
	local cLabel = w[sControl .. "_label"];
	if c then
		c.setVisible(bVisible);
		if cLabel then
			cLabel.setVisible(bVisible);
		end
	elseif cLabel then
		cLabel.setVisible(false);
	end
end
function getAnyControlVisible(w, tControls)
	if not w or not tControls then
		return false;
	end

	for _,sControl in ipairs(tControls) do
		local c = w[sControl];
		if c and c.isVisible() then
			return true;
		end
	end
	return false;
end

--
--	REORDER HANDLING
--		NOTE: Assumes child records use numerical "order" field
--

function setInitialOrder(w)
	if not w or not w.windowlist then
		return;
	end

	local node = w.getDatabaseNode();
	if not node or (DB.getValue(node, "order", 0) ~= 0) or not DB.isOwner(node) then
		return;
	end

	local tOrder = {};
	for _,v in ipairs(DB.getChildList(w.windowlist.getDatabaseNode(), "")) do
		tOrder[DB.getValue(v, "order", 0)] = true;
	end
	local i = 1;
	while tOrder[i] do
		i = i + 1;
	end
	DB.setValue(node, "order", "number", i);
end
function handleDropReorder(w, draginfo)
	if not w or not w.windowlist then
		return;
	end

	if draginfo.isType("reorder") then
		local nodeTarget = w.getDatabaseNode();
		local nodeDrag = draginfo.getDatabaseNode();
		if DB.getParent(nodeTarget) == DB.getParent(nodeDrag) then
			WindowManager.onDropReorder(w.windowlist.getDatabaseNode(), nodeTarget, nodeDrag);
		end
		return true;
	end
end

function onDropReorder(nodeList, nodeTarget, nodeDrag)
	if not DB.isOwner(nodeList) then
		return;
	end

	local tOrder = WindowManager.getNodesByOrder(nodeList);
	local nOrderTarget = tOrder[nodeTarget];
	local nOrderDrag = tOrder[nodeDrag];
	if not nOrderTarget or not nOrderDrag then
		return;
	end
	if nOrderTarget == nOrderDrag then
		return;
	end

	-- Find out if target window is above/below drag window
	-- Determine new order (with drag window above/below target window)
	if nOrderTarget > nOrderDrag then
		for node,nOrder in pairs(tOrder) do
			if nOrder > nOrderDrag and nOrder <= nOrderTarget then
				tOrder[node] = nOrder - 1;
			end
		end
		tOrder[nodeDrag] = nOrderTarget;
	else -- elseif nOrderTarget < nOrderDrag then
		for node,nOrder in pairs(tOrder) do
			if nOrder >= nOrderTarget and nOrder < nOrderDrag then
				tOrder[node] = nOrder + 1;
			end
		end
		tOrder[nodeDrag] = nOrderTarget;
	end

	-- Update all order in list
	for node,nOrder in pairs(tOrder) do
		DB.setValue(node, "order", "number", nOrder);
	end
end
function getNodesByOrder(nodeList)
	local tOrder = {};
	for k,v in ipairs(WindowManager.getSortedNodesByOrder(nodeList)) do
		tOrder[v] = k;
	end
	return tOrder;
end
function getSortedNodesByOrder(nodeList)
	local t = {};
	for _,v in ipairs(DB.getChildList(nodeList, "")) do
		table.insert(t, v);
	end
	table.sort(t, WindowManager.sortfuncNodeByOrder);
	return t;
end
function sortfuncNodeByOrder(a, b)
	local nOrderA = DB.getValue(a, "order", 0);
	local nOrderB = DB.getValue(b, "order", 0);
	if nOrderA ~= nOrderB then
		return nOrderA < nOrderB;
	end
	return DB.getPath(a) < DB.getPath(b);
end
