-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onTabletopInit()
	for s,_ in pairs(DialogManager.getDialogClassMap()) do
		Interface.addKeyedEventHandler("onWindowClosed", s, DialogManager.onWindowClosed);
	end
end

local _tDialogClasses = { 
	["dialog_okcancel"] = true,
};
function getDialogClassMap()
	return _tDialogClasses;
end
function addDialogClass(s)
	_tDialogClasses[s] = true;
end
function removeDialogClass(s)
	_tDialogClasses[s] = nil;
end
function isDialogClass(s)
	return _tDialogClasses[s];
end

local _tPending = {};
function addPendingDialog(sDialogClass, tData)
	_tPending[sDialogClass] = _tPending[sDialogClass] or {};
	table.insert(_tPending[sDialogClass], tData);
end
function getPendingDialog(sDialogClass)
	if not _tPending[sDialogClass] then
		return nil;
	end
	if #(_tPending[sDialogClass]) == 0 then
		return nil;
	end
	local t = _tPending[sDialogClass][1];
	table.remove(_tPending[sDialogClass], 1);
	return t;
end
function openPendingDialog(sDialogClass)
	local w = Interface.findWindow(sDialogClass, "");
	if w then
		w.bringToFront();
	else
		local tData = DialogManager.getPendingDialog(sDialogClass);
		if tData then
			w = Interface.openWindow(sDialogClass, "");
			w.setData(tData);
		end
	end
end

function openDialog(sDialogClass, tData)
	DialogManager.addPendingDialog(sDialogClass, tData);
	DialogManager.openPendingDialog(sDialogClass);
end
function onDialogClose(sResult, tData)
	if tData and tData.fnCallback then
		tData.fnCallback(sResult, tData);
	end
end
function onWindowClosed(sClass)
	DialogManager.openPendingDialog(sClass);
end
