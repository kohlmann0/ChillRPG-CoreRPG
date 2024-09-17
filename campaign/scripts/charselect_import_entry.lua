-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local node = getDatabaseNode();
	
	portrait.setFile(User.getLocalIdentityPortrait(node));
	name.setValue(DB.getValue(node, "name", ""));
	details.setValue(GameSystem.getCharSelectDetailHost(node));
end

local _bRequested = false;
function importCharacter()
	if Session.IsHost then
		local nodeTarget = CampaignDataManager.addPregenChar(getDatabaseNode());
		if (portrait.getFile() or "") ~= "" then
		 	portrait.activate(nodeTarget);
		end
	else
		if not self._bRequested then
			User.requestIdentity("", "charsheet", "name", getDatabaseNode(), self.requestResponse);
			self._bRequested = true;
		end
	end
end

function requestResponse(result, identity)
	if result and identity then
		windowlist.window.close();
	else
		error.setVisible(true);
	end
end

function exportCharacter()
	CampaignDataManager.exportChar(getDatabaseNode());
end

