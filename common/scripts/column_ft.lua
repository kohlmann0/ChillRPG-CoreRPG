-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if isReadOnly() then
		self.update(true);
	else
		local node = getDatabaseNode();
		if not node or DB.isReadOnly(node) then
			self.update(true);
		end
	end
end

function update(bReadOnly, bForceHide)
	local bLocalShow;
	if bForceHide then
		bLocalShow = false;
	else
		bLocalShow = true;
		if bReadOnly and not nohide and isEmpty() then
			bLocalShow = false;
		end
	end
	
	setVisible(bLocalShow);
	setReadOnly(bReadOnly);
	
	local sName = getName();
	if window[sName .. "_label"] then
		window[sName .. "_label"].setVisible(bLocalShow);
	elseif window[sName .. "_header"] then
		window[sName .. "_header"].setVisible(bLocalShow);
	end
	if separator then
		if window[separator[1]] then
			window[separator[1]].setVisible(bLocalShow);
		end
	end
	
	return bLocalShow;
end

function onValueChanged()
	if isVisible() then
		if window.VisDataCleared then
			if isEmpty() then
				window.VisDataCleared();
			end
		end
	else
		if window.InvisDataAdded then
			if not isEmpty() then
				window.InvisDataAdded();
			end
		end
	end
end
