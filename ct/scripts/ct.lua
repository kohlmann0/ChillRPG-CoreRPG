-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.onVisibilityToggle();

	local node = getDatabaseNode();
	DB.addHandler(DB.getPath(node, "*.name"), "onUpdate", onNameOrTokenUpdated);
	DB.addHandler(DB.getPath(node, "*.nonid_name"), "onUpdate", onNameOrTokenUpdated);
	DB.addHandler(DB.getPath(node, "*.isidentified"), "onUpdate", onNameOrTokenUpdated);
	DB.addHandler(DB.getPath(node, "*.token"), "onUpdate", onNameOrTokenUpdated);
end

function onClose()
	local node = getDatabaseNode();
	DB.removeHandler(DB.getPath(node, "*.name"), "onUpdate", onNameOrTokenUpdated);
	DB.removeHandler(DB.getPath(node, "*.nonid_name"), "onUpdate", onNameOrTokenUpdated);
	DB.removeHandler(DB.getPath(node, "*.isidentified"), "onUpdate", onNameOrTokenUpdated);
	DB.removeHandler(DB.getPath(node, "*.token"), "onUpdate", onNameOrTokenUpdated);
end

function onNameOrTokenUpdated(vNode)
	for _,w in pairs(getWindows()) do
		w.summary_targets.onTargetsChanged();
		
		if w.sub_targets.subwindow then
			for _,wTarget in pairs(w.sub_targets.subwindow.targets.getWindows()) do
				wTarget.onRefChanged();
			end
		end
		
		if w.sub_effects and w.sub_effects.subwindow then
			for _,wEffect in pairs(w.sub_effects.subwindow.effects.getWindows()) do
				wEffect.target_summary.onTargetsChanged();
			end
		end
	end
end

function onListChanged()
	self.onVisibilityToggle()
end
function onSortCompare(w1, w2)
	return CombatManager.onSortCompare(w1.getDatabaseNode(), w2.getDatabaseNode());
end

local _bEnableVisibilityToggle = true;
function toggleVisibility()
	if not _bEnableVisibilityToggle then
		return;
	end
	
	local visibilityon = window.button_global_visibility.getValue();
	for _,v in pairs(getWindows()) do
		if v.friendfoe.getStringValue() ~= "friend" then
			if visibilityon ~= v.tokenvis.getValue() then
				v.tokenvis.setValue(visibilityon);
			end
		end
	end
end
function onVisibilityToggle()
	local anyVisible = 0;
	for _,v in pairs(getWindows()) do
		if (v.friendfoe.getStringValue() ~= "friend") and (v.tokenvis.getValue() == 1) then
			anyVisible = 1;
		end
	end
	
	_bEnableVisibilityToggle = false;
	window.button_global_visibility.setValue(anyVisible);
	_bEnableVisibilityToggle = true;
end

function onDrop(x, y, draginfo)
	local sCTNode = UtilityManager.getWindowDatabasePath(getWindowAt(x,y));
	return CombatDropManager.handleAnyDrop(draginfo, sCTNode);
end
