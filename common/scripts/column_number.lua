-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	
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
		if bReadOnly and not nohide and getValue() == 0 then
			bLocalShow = false;
		end
	end

	setReadOnly(bReadOnly);
	setVisible(bLocalShow);
	
	local sName = getName();
	if window[sName .. "_label"] then
		window[sName .. "_label"].setVisible(bLocalShow);
	elseif window[sName .. "_header"] then
		window[sName .. "_header"].setVisible(bLocalShow);
	end
	
	if self.onUpdate then
		self.onUpdate(bLocalShow);
	end
	
	return bLocalShow;
end

function onValueChanged()
	if isVisible() then
		if window.VisDataCleared then
			if getValue() == 0 then
				window.VisDataCleared();
			end
		end
	else
		if window.InvisDataAdded then
			if getValue() ~= 0 then
				window.InvisDataAdded();
			end
		end
	end
end
