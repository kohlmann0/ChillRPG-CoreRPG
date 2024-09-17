--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

OOB_MSGTYPE_PICTURE_CREATE = "picture_create";
OOB_MSGTYPE_PICTURE_SHARE = "picture_share";

function onTabletopInit()
	OOBManager.registerOOBMsgHandler(PictureManager.OOB_MSGTYPE_PICTURE_CREATE, PictureManager.handlePictureCreate);
	OOBManager.registerOOBMsgHandler(PictureManager.OOB_MSGTYPE_PICTURE_SHARE, PictureManager.handlePictureShare);
end

function sendPictureCreate(sAsset, sName)
	if (sAsset or "") == "" then
		return;
	end

	local msgOOB = {};
	msgOOB.type = PictureManager.OOB_MSGTYPE_PICTURE_CREATE;
	msgOOB.sAsset = sAsset;
	msgOOB.sName = sName;

	Comm.deliverOOBMessage(msgOOB, "");
end
function handlePictureCreate(msgOOB)
	if not Session.IsHost then
		return;
	end
	PictureManager.createPictureItem(msgOOB.sAsset or "", msgOOB.sName);
end

function sendPictureShare(nodePicture)
	if not Session.IsHost or not nodePicture then
		return;
	end

	local msgOOB = {};
	msgOOB.type = PictureManager.OOB_MSGTYPE_PICTURE_SHARE;
	msgOOB.sRecordNode = DB.getPath(nodePicture);

	Comm.deliverOOBMessage(msgOOB);
end
function handlePictureShare(msgOOB)
	if Session.IsHost then
		return;
	end
	local sRecord = msgOOB.sRecordNode or "";
	if sRecord == "" then
		return;
	end

	Interface.openWindow("picture", sRecord);
end

function shareRecordPicture(nodeRecord)
	local sAsset = DB.getValue(nodeRecord, "picture", "");
	if sAsset == "" then
		return false;
	end
	local sName;
	if Session.IsHost then
		local sRecordType = LibraryData.getRecordTypeFromClassAndPath(sClass, DB.getPath(nodeRecord));
		if ((sRecordType or "") ~= "") and DB.isReadOnly(nodeRecord) and LibraryData.isIdentifiable(sRecordType, nodeRecord) then
			sName = DB.getValue(nodeRecord, "nonid_name", "");
			if sName == "" then
				sName = Interface.getString("library_recordtype_empty_nonid_" .. sRecordType);
			end
		end
	end
	if (sName or "") == "" then
		sName = CampaignDataManager.getRecordDisplayName(nodeRecord);
	end

	PictureManager.sendPictureCreate(sAsset, sName);
	return true;
end
function createPictureItem(sAsset, sName)
	if (sAsset or "") == "" then
		return false;
	end
	if not sName then
		sName = UtilityManager.getAssetBaseFileName(sAsset);
	end

	local nodePicture = nil;
	local sNameFind = StringManager.trim(sName);
	local tMappings = LibraryData.getMappings("picture");
	for _,sMapping in ipairs(tMappings) do
		for _,v in ipairs(DB.getChildrenGlobal(sMapping)) do
			if (StringManager.trim(DB.getValue(v, "name", "")) == sNameFind) and (DB.getValue(v, "picture", "") == sAsset) then
				nodePicture = v;
				break;
			end
		end
		if nodePicture then
			break;
		end
	end
	if not nodePicture then
		nodePicture = DB.createChild("picture");
		DB.setValue(nodePicture, "name", "string", sName);
		DB.setValue(nodePicture, "picture", "token", sAsset);
	end

	if Session.IsHost then
		local w = Interface.openWindow("picturelist", "picture");
		if w then
			w.clearFilter();
		end
		
		PictureManager.sendPictureShare(nodePicture);
	end
	return true;
end
