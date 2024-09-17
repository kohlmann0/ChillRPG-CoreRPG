-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	super.onInit();
	OptionsManager.registerCallback("SHPC", updateHealthDisplay);
	OptionsManager.registerCallback("SHNPC", updateHealthDisplay);
	self.updateHealthDisplay();
end
function onClose()
	super.onClose();
	OptionsManager.unregisterCallback("SHPC", updateHealthDisplay);
	OptionsManager.unregisterCallback("SHNPC", updateHealthDisplay);
end

function updateHealthDisplay()
	local sOptSHPC = OptionsManager.getOption("SHPC");
	local sOptSHNPC = OptionsManager.getOption("SHNPC");
	local bShowDetail = (sOptSHPC == "detailed") or (sOptSHNPC == "detailed");
	local bShowStatus = ((sOptSHPC == "status") or (sOptSHNPC == "status")) and not bShowDetail;
	
	-- General
	if label_hp then
		label_hp.setVisible(bShowDetail);
	end
	if label_temp then
		label_temp.setVisible(bShowDetail);
	end
	if label_wounds then
		label_wounds.setVisible(bShowDetail);
	end

	-- 3.5E
	if label_nonlethal then
		label_nonlethal.setVisible(bShowDetail);
	end

	-- 4E
	if label_surges then
		label_surges.setVisible(bShowDetail);
	end

	-- 13A
	if label_recoveries then
		label_recoveries.setVisible(bShowDetail);
	end

	label_status.setVisible(bShowStatus);

	for _,w in pairs(list.getWindows()) do
		w.updateHealthDisplay();
	end
end
