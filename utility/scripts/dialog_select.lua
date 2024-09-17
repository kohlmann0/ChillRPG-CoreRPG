-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local _tQueue = {};
function getSelectionQueue()
	return _tQueue;
end

local _bUpdatingSelections = false;
local _bFinalizingSelection = false;
function isUpdatingSelection()
	return _bUpdatingSelections;
end
function setUpdatingSelection(v)
	_bUpdatingSelections = v;
end
function isFinalizingSelection()
	return _bFinalizingSelection;
end
function setFinalizingSelection(v)
	_bFinalizingSelection = v;
end

local _nMinSelections;
local _nMaxSelections;
function getMinSelections()
	return _nMinSelections or 1;
end
function setMinSelections(v)
	_nMinSelections = v;
end
function getMaxSelections()
	return _nMaxSelections or 0;
end
function setMaxSelections(v)
	_nMaxSelections = v;
end

function requestSelection(sTitle, sMsg, aSelections, fnCallback, vCustom, nMinimum, nMaximum, bFront)
	local tQueue = self.getSelectionQueue();
	local nCurrentStack = #tQueue;
	
	local rRequest = { title = sTitle, msg = sMsg, options = aSelections, min = nMinimum, max = nMaximum, callback = fnCallback, custom = vCustom };
	if bFront then
		if self.isFinalizingSelection() or (#tQueue == 0) then
			table.insert(tQueue, 1, rRequest);
		else
			table.insert(tQueue, 2, rRequest);
		end
	else
		table.insert(tQueue, rRequest);
	end

	if nCurrentStack == 0 then
		activateNextSelection();
	end
end
function activateNextSelection()
	local tQueue = self.getSelectionQueue();
	if #tQueue <= 0 then
		close();
		return;
	end

	self.setUpdatingSelection(false);
	
	title.setValue(tQueue[1].title);
	text.setValue(tQueue[1].msg);
	
	list.closeAll();
	for _,v in ipairs(tQueue[1].options) do
		if type(v) == "string" then
			local w = list.createWindow();
			w.text.setValue(v);
		elseif type(v) == "table" then
			local w = list.createWindow();
			w.text.setValue(v.text);
			if v.linkclass and v.linkrecord then
				w.shortcut.setValue(v.linkclass, v.linkrecord);
				w.shortcut.setVisible(true);
			end
			if v.selected then
				w.selected.setValue(1);
			end
		end
	end
	
	self.setMinSelections(tQueue[1].min);
	self.setMaxSelections(tQueue[1].max);

	self.setUpdatingSelection(true);
	self.onSelectionChanged();
end

function onSelectionChanged()
	if not self.isUpdatingSelection() then
		return;
	end
	
	local nSelections = 0;
	for _,w in pairs(list.getWindows()) do
		if w.selected.getValue() == 1 then
			nSelections = nSelections + 1;
		end
	end
	
	local nMin = self.getMinSelections();
	local nMax = self.getMaxSelections();
	if nSelections >= nMin and ((nMax <= 0) or (nSelections <= nMax)) then
		sub_buttons.subwindow.button_ok.setVisible(true);
	else
		sub_buttons.subwindow.button_ok.setVisible(false);
	end
end

function processOK()
	local tQueue = self.getSelectionQueue();
	if #tQueue > 0 then
		self.setFinalizingSelection(true);

		local rSelect = tQueue[1];
		table.remove(tQueue, 1);

		if rSelect.callback then
			local aSelections = {};
			local aSelectionLinks = {};
			for _,w in pairs(list.getWindows()) do
				if w.selected.getValue() == 1 then
					table.insert(aSelections, w.text.getValue());
					local tLink = {};
					tLink.linkclass, tLink.linkrecord = w.shortcut.getValue();
					table.insert(aSelectionLinks, tLink);
				end
			end

			rSelect.callback(aSelections, rSelect.custom, aSelectionLinks);
		end

		self.setFinalizingSelection(false);
	end
	
	self.activateNextSelection();
end

function processCancel()
	close();
end
