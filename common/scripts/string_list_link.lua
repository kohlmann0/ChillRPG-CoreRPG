-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function getLinkControl()
	return linktarget and window[linktarget[1]] or window.link;
end

function onHover(oncontrol)
	setUnderline(oncontrol);
end
function onClickDown(button, x, y)
	return true;
end
function onClickRelease(button, x, y)
	if self.activate then
		self.activate();
	else
		local cLink = self.getLinkControl();
		if cLink then
			cLink.activate();
		end
	end
	return true;
end
function onDragStart(button, x, y, draginfo)
	local cLink = self.getLinkControl();
	if cLink then
		if cLink.onDragStart then
			return cLink.onDragStart(button, x, y, draginfo);
		end
		
		draginfo.setType("shortcut");
		local sClass, sRecord = cLink.getValue();
		draginfo.setShortcutData(sClass, sRecord);
		draginfo.setDescription(getValue());
		return true;
	end
end
					