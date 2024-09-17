--
--  Please see the license.html file included with this distribution for
--  attribution and copyright information.
--

function onInit()
	self.initColor();
end

function initColor()
	tint_colorpick.setValue(tint.getValue());
	self.updateDisplay();
end
function onColorChanged(sColor)
	tint.setValue(tint_colorpick.getValue());
	self.updateDisplay();
end
function updateDisplay()
	for _,w in ipairs(list.getWindows()) do
		w.refreshAssetDisplay();
	end
end

function onListDrop(draginfo)
	if not Session.IsHost or not draginfo.isType("image") then
		return false;
	end
	local w = list.createWindow();
	w.value.setValue(draginfo.getTokenData());
end
