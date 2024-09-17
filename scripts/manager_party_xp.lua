-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	PartyXPManager.setActorTypeInfo("charsheet", { sField = "exp" });
	
	PartyXPManager.setRecordTypeInfo("battle", { sPath = "partysheet.encounters", sField = "exp" });
	PartyXPManager.setRecordTypeInfo("quest", { sPath = "partysheet.quests", sField = "xp" });
end

--
--	CONFIGURATION
--

local _tRecordTypeInfo = {};
function setRecordTypeInfo(sRecordType, tData)
	if ((sRecordType or "") ~= "") then
		if tData and ((tData.sPath or "") ~= "") and ((tData.sField or "") ~= "") then
			_tRecordTypeInfo[sRecordType] = tData;
		else
			_tRecordTypeInfo[sRecordType] = nil;
		end
	end
end
function setRecordTypeXPField(sRecordType, sField)
	if ((sField or "") ~= "") then
		return;
	end
	local tData = PartyXPManager.getRecordTypeInfo(sRecordType);
	if not tData then
		return;
	end
	tData.sField = sField;
end
function getRecordTypeInfo(sRecordType)
	if ((sRecordType or "") == "") then
		return nil;
	end
	return _tRecordTypeInfo[sRecordType];
end
function getRecordTypePath(sRecordType)
	local tData = PartyXPManager.getRecordTypeInfo(sRecordType);
	if not tData then
		return nil;
	end
	return tData.sPath;
end
function getRecordTypeXPField(sRecordType)
	local tData = PartyXPManager.getRecordTypeInfo(sRecordType);
	if not tData then
		return nil;
	end
	return tData.sField;
end

local _tActorTypeInfo = {};
function setActorTypeInfo(sRecordType, tData)
	if ((sRecordType or "") ~= "") then
		if tData and ((tData.sField or "") ~= "") then
			_tActorTypeInfo[sRecordType] = tData;
		else
			_tActorTypeInfo[sRecordType] = nil;
		end
	end
end
function getActorTypeInfo(sRecordType)
	if not sRecordType then
		return nil;
	end
	return _tActorTypeInfo[sRecordType];
end
function getActorTypeXPField(sRecordType)
	local tData = PartyXPManager.getActorTypeInfo(sRecordType);
	if not tData then
		return nil;
	end
	return tData.sField;
end

--
--	DROP HANDLING
--

function onDrop(draginfo)
	if Session.IsHost and draginfo.isType("shortcut") then
		local sClass = draginfo.getShortcutData();
		local nodeSrc = draginfo.getDatabaseNode();
		local sPath = PartyXPManager.getRecordTypePath(sClass);
		if nodeSrc and sPath then
			DB.createChildAndCopy(sPath, nodeSrc);
		end
		return true;
	end
end

--
--	DROP HANDLING
--

function awardRecordsToParty(sRecordType, nodeEntry)
	if not Session.IsHost or ((sRecordType or "") == "") then
		return;
	end

	local nXP = 0;
	local sField = PartyXPManager.getRecordTypeXPField(sRecordType);
	if nodeEntry then
		if DB.getValue(nodeEntry, "xpawarded", 0) == 0 then
			nXP = DB.getValue(nodeEntry, sField, 0);
			DB.setValue(nodeEntry, "xpawarded", "number", 1);
		end
	else
		for _,v in ipairs(DB.getChildList(PartyXPManager.getRecordTypePath(sRecordType))) do
			if DB.getValue(v, "xpawarded", 0) == 0 then
				nXP = nXP + DB.getValue(v, sField, 0);
				DB.setValue(v, "xpawarded", "number", 1);
			end
		end
	end
	if nXP ~= 0 then
		PartyXPManager.awardXP(nXP);
	end
end
function awardXP(nXP) 
	if not Session.IsHost then
		return;
	end

	-- Determine members of party
	local tParty = PartyManager.getPartyActors();
	local nParty = #tParty;

	-- Determine split
	local nAverageSplit;
	if nXP >= nParty then
		nAverageSplit = math.floor((nXP / nParty) + 0.5);
	else
		nAverageSplit = 0;
	end
	local nFinalSplit = math.max((nXP - ((nParty - 1) * nAverageSplit)), 0);
	
	-- Award XP
	for k,v in ipairs(tParty) do
		local nAmount;
		if k == nParty then
			nAmount = nFinalSplit;
		else
			nAmount = nAverageSplit;
		end
		if nAmount > 0 then
			PartyXPManager.awardXPtoPC(v, nAmount);
		end
	end
	
	local msg = { icon = "portrait_gm_token", font = "msgfont" };
	msg.text = string.format("%s (%d)", Interface.getString("ps_message_xpaward"), nXP);
	Comm.deliverChatMessage(msg);
end
function awardXPtoPC(rActor, nXP)
	if not Session.IsHost then
		return;
	end

	local sActorType = ActorManager.getRecordType(rActor);
	local sActorXPField = PartyXPManager.getActorTypeXPField(sActorType);
	if not sActorXPField then
		return;
	end

	local nodeActor = ActorManager.getCreatureNode(rActor);
	DB.setValue(nodeActor, sActorXPField, "number", DB.getValue(nodeActor, sActorXPField, 0) + nXP);
							
	local msg = { icon = "xp", font = "msgfont" };
	msg.text = string.format("[%d %s] -> %s", nXP, Interface.getString("xp"), ActorManager.getDisplayName(rActor));
	Comm.deliverChatMessage(msg, "");

	local sOwner = DB.getOwner(nodeActor);
	if (sOwner or "") ~= "" then
		Comm.deliverChatMessage(msg, sOwner);
	end
end
