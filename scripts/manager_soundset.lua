--
--	Please see the license.html file included with this distribution for
--	attribution and copyright information.
--

function onInit()
	SoundsetManager.initStandardSettings();
	-- SoundsetManager.initRulesetSettings();
end
function onTabletopInit()
	if Session.IsHost then
		-- Update current contexts (in case other scripts open windows)
		SoundsetManager.updateStoryContext();
		SoundsetManager.updateImageContext();
		SoundsetManager.updateNPCContext();

		-- Window and Database Event Registrations
		Interface.addKeyedEventHandler("onWindowOpened", "", SoundsetManager.onWindowOpened);
		Interface.addKeyedEventHandler("onWindowClosed", "", SoundsetManager.onWindowClosed);
		CombatManager.addCombatantFieldChangeHandler("name", "onUpdate", SoundsetManager.onUpdateCTName);
		CombatManager.setCustomPostDeleteCombatantHandler(SoundsetManager.onDeleteCTEntry);

		-- Chat Event Registration
		ChatManager.registerReceiveMessageCallback(SoundsetManager.handleChatMessage);
	end
end

--
--	STANDARD SETTINGS
--

function initStandardSettings()
	SoundsetManager.setRecordTypeDropCallback("soundset", SoundsetManager.handleSoundsetDrop);
	SoundsetManager.setRecordTypeDropCallback("story", SoundsetManager.handleStoryDrop);
	SoundsetManager.setRecordTypeDropCallback("referencemanualpage", SoundsetManager.handleStoryDrop);
	SoundsetManager.setRecordTypeDropCallback("image", SoundsetManager.handleImageDrop);
	SoundsetManager.setRecordTypeDropCallback("npc", SoundsetManager.handleNPCDrop);
	SoundsetManager.setRecordTypeDropCallback("item", SoundsetManager.handleItemDrop);
end

--
--	RULESET SETTINGS
--

-- local _tStandardCastAndAttackRulesets = 
-- {
-- 	"SFRPG",
-- };
-- local _tStandardAttackRulesets = 
-- {
-- 	"DCC RPG",
-- };

-- local _tStandardSpellRulesets = 
-- {
-- 	"SFRPG",
-- };

-- function initRulesetSettings()
-- 	if StringManager.contains(_tStandardCastAndAttackRulesets, Session.RulesetName) then
-- 		SoundsetManager.registerStandardSettingsCastAndAttack();
-- 	elseif StringManager.contains(_tStandardAttackRulesets, Session.RulesetName) then
-- 		SoundsetManager.registerStandardSettingsAttack();
-- 	end
-- 	if StringManager.contains(_tStandardSpellRulesets, Session.RulesetName) then
-- 		SoundsetManager.setRecordTypeDropCallback("spell", SoundsetManager.handleStandardSpellDrop);
-- 	end	
-- end
function registerStandardSettingsCastAndAttack()
	SoundsetManager.registerTriggerSubtype("cast", { "^%[CAST ?#?%d?%]" });
	SoundsetManager.registerTriggerSubtype("attackhit", { "^Attack", "%[HIT%]" });
	SoundsetManager.registerTriggerSubtype("attackmiss", { "^Attack", "%[MISS%]" });
	SoundsetManager.registerTriggerSubtype("attackcrit", { "^Attack", "%[CRITICAL HIT%]" });
	SoundsetManager.registerTriggerSubtype("attackfumble", { "^Attack", "%[AUTOMATIC MISS%]" });
end
function registerStandardSettingsAttack()
	SoundsetManager.registerTriggerSubtype("attackhit", { "^Attack", "%[HIT%]" });
	SoundsetManager.registerTriggerSubtype("attackmiss", { "^Attack", "%[MISS%]" });
	SoundsetManager.registerTriggerSubtype("attackcrit", { "^Attack", "%[CRITICAL HIT%]" });
	SoundsetManager.registerTriggerSubtype("attackfumble", { "^Attack", "%[AUTOMATIC MISS%]" });
end
function registerSimpleSettingsAttack()
	SoundsetManager.registerTriggerSubtype("attackhit", { "^Attack", "%[HIT%]" });
	SoundsetManager.registerTriggerSubtype("attackmiss", { "^Attack", "%[MISS%]" });
end

--
--	CUSTOM TRIGGER SUBTYPES
--

local _tCustomSubtypes = {};
function registerTriggerSubtype(sKey, tPatterns)
	_tCustomSubtypes[sKey] = { tPatterns = tPatterns };
end
function getTriggerSubtype(sKey)
	return _tCustomSubtypes[sKey];
end
function getAllTriggerSubtypes()
	return _tCustomSubtypes;
end

--
--	DROP HANDLERS
--

local _tDropHandlers = {};
function setRecordTypeDropCallback(sRecordType, fn)
	UtilityManager.setKeySingleCallback(_tDropHandlers, sRecordType, fn);
end
function getRecordTypeDropCallback(sRecordType)
	return UtilityManager.getKeySingleCallback(_tDropHandlers, sRecordType);
end
function hasRecordTypeDropCallback(sRecordType)
	return UtilityManager.hasKeySingleCallback(_tDropHandlers, sRecordType);
end
function onRecordTypeDropEvent(sRecordType, nodeSoundset, sClass, sRecord)
	return UtilityManager.performKeySingleCallback(_tDropHandlers, sRecordType, nodeSoundset, sClass, sRecord);
end

--
--	WINDOW AND DATABASE EVENT TRACKING AND ROUTING
--

function onWindowOpened(w)
	local sClass = w.getClass();
	local sRecordType = LibraryData.getRecordTypeFromDisplayClass(sClass);
	if (sClass == "combattracker_host") or (sRecordType == "npc") then
		SoundsetManager.updateNPCContext();
	elseif (sRecordType == "story") then
		SoundsetManager.updateStoryContext();
	elseif (sRecordType == "image") then
		SoundsetManager.updateImageContext();
	end
end
function onWindowClosed(sClass)
	local sRecordType = LibraryData.getRecordTypeFromDisplayClass(sClass);
	if sRecordType == "npc" then
		SoundsetManager.updateNPCContext();
	elseif (sClass == "reference_manual") or (sRecordType == "story") then
		SoundsetManager.updateStoryContext();
	elseif (sRecordType == "image") then
		SoundsetManager.updateImageContext();
	end
end

function onUpdateCTName(nodeName)
	SoundsetManager.updateNPCContext();
end
function onDeleteCTEntry()
	SoundsetManager.updateNPCContext();
end

--
--	CHAT EVENT HANDLING
--

local _bProcessingChatMessage = false;
function handleChatMessage(msg)
	-- Use semaphore variable to prevent messages generated by this code from causing endless loop
	if _bProcessingChatMessage then
		return;
	end
	_bProcessingChatMessage = true;

	if not SoundManager.isEnabled() then
		return;
	end

	local tMatch = { sCheck = msg.text };
	RecordManager.callForEachRecord("soundset", SoundsetManager.helperHandleChatMessageCheckSoundset, tMatch);
	if #tMatch > 0 then
		table.sort(tMatch, function(a, b) return a.nWeight > b.nWeight end)
		SoundsetManager.helperHandleChatMessagePlay(tMatch[1].node);
	end
	_bProcessingChatMessage = false;
end
function helperHandleChatMessageCheckSoundset(v, tMatch)
	-- Exit if disabled, or not a trigger
	if DB.getValue(v, "disabled", 0) == 1 then
		return;
	end
	if DB.getValue(v, "type", "") ~= "trigger" then
		return;
	end

	-- Exit if no explicit patterns to match
	if DB.getChildCount(v, "subpatterns") == 0 then
		return;
	end

	-- If registered custom sub type, check registered patterns first
	local tCustomSubtype = SoundsetManager.getTriggerSubtype(DB.getValue(v, "subtype", ""));
	if tCustomSubtype then
		for _,sPattern in ipairs(tCustomSubtype.tPatterns) do
			if not tMatch.sCheck:match(sPattern) then
				return;
			end
		end
	end

	-- Track number of patterns matched
	local nMatchWeight = 0;

	-- Handle explicit sound set pattern matches
	local tWords = nil;
	for _,nodePattern in ipairs(DB.getChildList(v, "subpatterns")) do
		local sPattern = StringManager.trim(DB.getValue(nodePattern, "value", ""));
		if sPattern ~= "" then
			if DB.getValue(nodePattern, "regex", 0) == 1 then
				if not tMatch.sCheck:match(sPattern) then
					return;
				end
				nMatchWeight = nMatchWeight + 1;
			else
				--word match
				if not tWords then
					tWords = StringManager.parseWords(tMatch.sCheck);
				end

				local tPatternWords = StringManager.parseWords(sPattern);
				local bMatch = false;
				if #tPatternWords > 0 then
					for i=1, #tWords-(#tPatternWords-1) do
						if tWords[i] == tPatternWords[1] then
							bMatch = true;

							for j=2, #tPatternWords do
								if not tWords[i+j-1] then
									bMatch = false;
									break;
								end

								if tWords[i+j-1] ~= tPatternWords[j] then
									bMatch = false;
									break;
								end
							end
							if bMatch then
								nMatchWeight = nMatchWeight + 1;
								break;
							end
						end
					end
				end
				if not bMatch then
					return;
				end
			end
		end
	end

	table.insert(tMatch, { node = v, nWeight = nMatchWeight } );
end
function helperHandleChatMessagePlay(nodeSoundset)
	-- Play random one of sound set
	local tSounds = DB.getChildList(nodeSoundset, "subsounds");
	if #tSounds > 0 then
		local nRandom = math.random(1, #tSounds);
		SoundManager.playSound(DB.getValue(tSounds[nRandom], "soundid", ""));
		if Session.DebugMode then
			local sMsg = string.format("%s (%s)", Interface.getString("sound_debug_match"), DB.getValue(nodeSoundset, "name", ""));
			ChatManager.SystemMessage(sMsg);
		end
	else
		local sMsg = string.format("%s (%s)", Interface.getString("sound_error_match_no_subsounds"), DB.getValue(nodeSoundset, "name", ""));
		ChatManager.SystemMessage(sMsg);
	end
end

--
--	STORY WINDOW TRACKING
--

local _tStorySoundsets = {};
local _tStoryIncludedSoundsets = {};
function getStorySoundsets()
	return _tStorySoundsets;
end
function getStoryIncludedSoundsets()
	return _tStoryIncludedSoundsets;
end
function updateStoryContext()
	local tDataPaths = SoundsetManager.helperUpdateStoryContextGetDataPaths();

	local tSoundsetMatch = {};
	local tIncludedMatch = {};
	if #tDataPaths > 0 then
		RecordManager.callForEachRecord(
			"soundset", 
			SoundsetManager.helperUpdateStoryContextGetSoundset,
			tDataPaths, 
			tSoundsetMatch);

		tIncludedMatch = SoundsetManager.helperUpdateStoryContextGetIncludedSoundsets(tSoundsetMatch);
	end

	SoundsetManager.helperUpdateStoryContextMatches(tSoundsetMatch, tIncludedMatch);
end
function helperUpdateStoryContextGetDataPaths()
	local tDataPaths = {};
	for _,w in ipairs(Interface.getWindows("encounter")) do
		local sPath = w.getDatabasePath();
		if ((sPath or "") ~= "") and not StringManager.contains(tDataPaths, sPath) then
			table.insert(tDataPaths, sPath);
		end
	end
	for _,w in ipairs(Interface.getWindows("referencemanualpage")) do
		local sPath = w.getDatabasePath();
		if ((sPath or "") ~= "") and not StringManager.contains(tDataPaths, sPath) then
			table.insert(tDataPaths, sPath);
		end
	end
	for _,w in ipairs(Interface.getWindows("reference_manual")) do
		if w.content.subwindow then
			local _,sRecord = w.content.getValue();
			if ((sRecord or "") ~= "") and not StringManager.contains(tDataPaths, sRecord) then
				table.insert(tDataPaths, sRecord);
			end
		end
	end
	return tDataPaths;
end
function helperUpdateStoryContextGetSoundset(v, tDataPaths, tSoundsetMatch)
	if DB.getValue(v, "type", "") ~= "content" then
		return;
	end
	if DB.getValue(v, "subtype", "") ~= "story" then
		return;
	end

	local bMatch = false;
	for _,nodeTarget in ipairs(DB.getChildList(v, "targets")) do
		local _,sRecord = DB.getValue(nodeTarget, "shortcut", "", "");
		if StringManager.contains(tDataPaths, sRecord) then
			bMatch = true;
			break;
		end
	end
	if not bMatch then
		return;
	end

	local sPath = DB.getPath(v);
	if not StringManager.contains(tSoundsetMatch, sPath) then
		table.insert(tSoundsetMatch, sPath);
	end
end
function helperUpdateStoryContextGetIncludedSoundsets(tSoundsetMatch)
	local tIncludedMatch = {};
	for _,v in ipairs(tSoundsetMatch) do
		for _,nodeChild in ipairs(DB.getChildList(DB.getPath(v, "links"))) do
			local _,sRecord = DB.getValue(nodeChild, "shortcut", "", "");
			if not StringManager.contains(tSoundsetMatch, sRecord) then
				if not StringManager.contains(tIncludedMatch, sRecord) then
					table.insert(tIncludedMatch, sRecord);
				end
			end
		end
	end
	return tIncludedMatch;
end
function helperUpdateStoryContextMatches(tSoundsetMatch, tIncludedMatch)
	for _,v in ipairs(tSoundsetMatch) do
		if not StringManager.contains(_tStorySoundsets, v) then
			SoundsetManager.addContext(v, "story");
		end
	end
	for _,v in ipairs(tIncludedMatch) do
		if not StringManager.contains(_tStoryIncludedSoundsets, v) then
			SoundsetManager.addContext(v, "addon");
		end
	end

	for _,v in ipairs(_tStorySoundsets) do
		if not StringManager.contains(tSoundsetMatch, v) then
			SoundsetManager.removeContext(v);
		end
	end
	for _,v in ipairs(_tStoryIncludedSoundsets) do
		if not StringManager.contains(tIncludedMatch, v) then
			SoundsetManager.removeContext(v);
		end
	end

	_tStorySoundsets = tSoundsetMatch;
	_tStoryIncludedSoundsets = tIncludedMatch;
end

--
--	IMAGE WINDOW TRACKING
--

local _tImageSoundsets = {};
local _tImageIncludedSoundsets = {};
function getImageSoundsets()
	return _tImageSoundsets;
end
function getImageIncludedSoundsets()
	return _tImageIncludedSoundsets;
end
function updateImageContext()
	local tDataPaths = SoundsetManager.helperUpdateImageContextGetDataPaths();

	local tSoundsetMatch = {};
	local tIncludedMatch = {};
	if #tDataPaths > 0 then
		RecordManager.callForEachRecord(
			"soundset", 
			SoundsetManager.helperUpdateImageContextGetSoundset,
			tDataPaths, 
			tSoundsetMatch);

		tIncludedMatch = SoundsetManager.helperUpdateImageContextGetIncludedSoundsets(tSoundsetMatch);
	end

	SoundsetManager.helperUpdateImageContextMatches(tSoundsetMatch, tIncludedMatch);
end
function helperUpdateImageContextGetDataPaths()
	local tDataPaths = {};
	local sClass = LibraryData.getRecordDisplayClass("image");
	for _,w in ipairs(Interface.getWindows(sClass)) do
		local sPath = w.getDatabasePath();
		if ((sPath or "") ~= "") and not StringManager.contains(tDataPaths, sPath) then
			table.insert(tDataPaths, sPath);
		end
	end
	local sBackPanelRecord = ImageManager.getPanelDataValue(ImageManager.getBackPanel());
	if ((sBackPanelRecord or "") ~= "") and not StringManager.contains(tDataPaths, sBackPanelRecord) then
		table.insert(tDataPaths, sBackPanelRecord);
	end
	local sMaxPanelRecord = ImageManager.getPanelDataValue(ImageManager.getMaxPanel());
	if ((sMaxPanelRecord or "") ~= "") and not StringManager.contains(tDataPaths, sMaxPanelRecord) then
		table.insert(tDataPaths, sMaxPanelRecord);
	end
	local sFullPanelRecord = ImageManager.getPanelDataValue(ImageManager.getFullPanel());
	if ((sFullPanelRecord or "") ~= "") and not StringManager.contains(tDataPaths, sFullPanelRecord) then
		table.insert(tDataPaths, sFullPanelRecord);
	end
	return tDataPaths;
end
function helperUpdateImageContextGetSoundset(v, tDataPaths, tSoundsetMatch)
	if DB.getValue(v, "type", "") ~= "content" then
		return;
	end
	if DB.getValue(v, "subtype", "") ~= "image" then
		return;
	end

	local bMatch = false;
	for _,nodeTarget in ipairs(DB.getChildList(v, "targets")) do
		local _,sRecord = DB.getValue(nodeTarget, "shortcut", "", "");
		if StringManager.contains(tDataPaths, sRecord) then
			bMatch = true;
			break;
		end
	end
	if not bMatch then
		return;
	end

	local sPath = DB.getPath(v);
	if not StringManager.contains(tSoundsetMatch, sPath) then
		table.insert(tSoundsetMatch, sPath);
	end
end
function helperUpdateImageContextGetIncludedSoundsets(tSoundsetMatch)
	local tIncludedMatch = {};
	for _,v in ipairs(tSoundsetMatch) do
		for _,nodeChild in ipairs(DB.getChildList(DB.getPath(v, "links"))) do
			local _,sRecord = DB.getValue(nodeChild, "shortcut", "", "");
			if not StringManager.contains(tSoundsetMatch, sRecord) then
				if not StringManager.contains(tIncludedMatch, sRecord) then
					table.insert(tIncludedMatch, sRecord);
				end
			end
		end
	end
	return tIncludedMatch;
end
function helperUpdateImageContextMatches(tSoundsetMatch, tIncludedMatch)
	for _,v in ipairs(tSoundsetMatch) do
		if not StringManager.contains(_tImageSoundsets, v) then
			SoundsetManager.addContext(v, "image");
		end
	end
	for _,v in ipairs(tIncludedMatch) do
		if not StringManager.contains(_tImageIncludedSoundsets, v) then
			SoundsetManager.addContext(v, "addon");
		end
	end

	for _,v in ipairs(_tImageSoundsets) do
		if not StringManager.contains(tSoundsetMatch, v) then
			SoundsetManager.removeContext(v);
		end
	end
	for _,v in ipairs(_tImageIncludedSoundsets) do
		if not StringManager.contains(tIncludedMatch, v) then
			SoundsetManager.removeContext(v);
		end
	end

	_tImageSoundsets = tSoundsetMatch;
	_tImageIncludedSoundsets = tIncludedMatch;
end

--
--	NPC WINDOW TRACKING
--

local _tNPCSoundsets = {};
function getNPCSoundsets()
	return _tNPCSoundsets;
end
function updateNPCContext()
	local tNames = SoundsetManager.helperUpdateNPCContextGetNames();

	local tSoundsetMatch = {};
	if #tNames > 0 then
		RecordManager.callForEachRecord(
				"soundset", SoundsetManager.helperUpdateNPCContextCheckSoundset,
				tNames, tSoundsetMatch);
	end

	SoundsetManager.helperUpdateNPCContextPaths(tSoundsetMatch);
end
function helperUpdateNPCContextGetNames()
	local tNames = {};
	for _,w in ipairs(Interface.getWindows("npc")) do
		local sName = StringManager.sanitize(DB.getValue(w.getDatabaseNode(), "name", ""));
		if (sName ~= "") and not StringManager.contains(tNames, sName) then
			table.insert(tNames, sName);
		end
	end
	for _,v in ipairs(CombatManager.getAllCombatantNodes()) do
		if not CombatManager.isPlayerCT(v) then
			local sName = CombatManager.stripCreatureNumber(StringManager.sanitize(DB.getValue(v, "name", "")));
			if (sName ~= "") and not StringManager.contains(tNames, sName) then
				table.insert(tNames, sName);
			end
		end
	end
	return tNames;
end
function helperUpdateNPCContextCheckSoundset(v, tNames, tSoundsetMatch)
	if DB.getValue(v, "type", "") ~= "content" then
		return;
	end
	if DB.getValue(v, "subtype", "") ~= "npc" then
		return;
	end

	local sName = StringManager.trim(DB.getValue(v, "value", ""));
	if (sName == "") or not StringManager.contains(tNames, sName) then
		return;
	end

	local sPath = DB.getPath(v);
	if not StringManager.contains(tSoundsetMatch, sPath) then
		table.insert(tSoundsetMatch, sPath);
	end
end
function helperUpdateNPCContextPaths(tSoundsetMatch)
	for _,v in ipairs(tSoundsetMatch) do
		if not StringManager.contains(_tNPCSoundsets, v) then
			SoundsetManager.addContext(v, "npc");
		end
	end

	for _,v in ipairs(_tNPCSoundsets) do
		if not StringManager.contains(tSoundsetMatch, v) then
			SoundsetManager.removeContext(v);
		end
	end

	_tNPCSoundsets = tSoundsetMatch;
end

--
--	UI - CONTEXT WINDOW
--

function populateContextWindow(w)
	for _,v in ipairs(SoundsetManager.getStorySoundsets()) do
		SoundsetManager.addContext(v, "story", w);
	end
	for _,v in ipairs(SoundsetManager.getImageSoundsets()) do
		SoundsetManager.addContext(v, "image", w);
	end
	for _,v in ipairs(SoundsetManager.getStoryIncludedSoundsets()) do
		SoundsetManager.addContext(v, "addon", w);
	end
	for _,v in ipairs(SoundsetManager.getImageIncludedSoundsets()) do
		SoundsetManager.addContext(v, "addon", w);
	end
	for _,v in ipairs(SoundsetManager.getNPCSoundsets()) do
		SoundsetManager.addContext(v, "npc", w);
	end
end
function addContext(sPath, sContextType, w)
	if not w then
		w = SoundManager.getContextWindow();
	end
	if not w then
		return;
	end

	local nodeSoundset = DB.findNode(sPath);
	if not nodeSoundset then
		return;
	end

	local wContext = SoundsetManager.helperFindContext(w, nodeSoundset);
	if wContext then
		return;
	end

	wContext = w.sub_content.subwindow.list.createWindow(nodeSoundset);

	if sContextType == "story" then
		wContext.groupid.setValue(1);
	elseif sContextType == "image" then
		wContext.groupid.setValue(2);
	elseif sContextType == "addon" then
		wContext.groupid.setValue(3);
	elseif sContextType == "npc" then
		wContext.groupid.setValue(4);
	else
		wContext.groupid.setValue(5);
	end
end
function removeContext(sPath)
	local w = SoundManager.getContextWindow();
	if not w then
		return;
	end

	local nodeSoundset = DB.findNode(sPath);
	if not nodeSoundset then
		return;
	end

	local wContext = SoundsetManager.helperFindContext(w, nodeSoundset);
	if wContext then
		wContext.close();
	end
end
function helperFindContext(w, node)
	for _,v in ipairs(w.sub_content.subwindow.list.getWindows()) do
		if v.getDatabaseNode() == node then
			return v;
		end
	end
	return nil;
end

--
--	UI - SOUNDSET RECORD
--

function handleAnyDrop(draginfo, nodeSoundset)
	if not Session.IsHost then
		return;
	end
	if not draginfo.isType("shortcut") then
		return;
	end
	local bReadOnly = WindowManager.getReadOnlyState(nodeSoundset);
	if bReadOnly then
		return;
	end

	local sClass, sRecord = draginfo.getShortcutData();
	if (sClass == "soundplay") or (sClass == "soundstop") then
		return SoundsetManager.helperHandleSoundDrop(nodeSoundset, sClass, sRecord);
	else
		return SoundsetManager.helperHandleRecordTypeDrop(nodeSoundset, sClass, sRecord);
	end
end
function helperHandleSoundDrop(nodeSoundset, sClass, sRecord)
	local nodeEntry = DB.createChild(DB.getPath(nodeSoundset, "subsounds"));
	if nodeEntry then
		DB.setValue(nodeEntry, "soundid", "string", sRecord);
	end
	return true;
end
function helperHandleRecordTypeDrop(nodeSoundset, sClass, sRecord)
	local sRecordType = LibraryData.getRecordTypeFromDisplayClass(sClass);
	if (sRecordType or "") == "" then
		return nil;
	end
	return SoundsetManager.onRecordTypeDropEvent(sRecordType, nodeSoundset, sClass, sRecord);
end

--
-- UI - SOUNDSET RECORD TYPE DROP HANDLERS
--

-- "soundset": If content-story sound set, then add to soundset links
function handleSoundsetDrop(nodeSoundset, sClass, sRecord)
	if DB.getValue(DB.getPath(nodeSoundset, "type"), "") ~= "content" then
		return;
	end
	local sSubtype = DB.getValue(DB.getPath(nodeSoundset, "subtype"), "");
	if sSubtype ~= "story" and sSubtype ~= "image" then
		return;
	end

	local nodeLinks = DB.createChild(nodeSoundset, "links");
	local nodeEntry = DB.createChild(nodeLinks);
	DB.setValue(nodeEntry, "name", "string", StringManager.trim(DB.getValue(DB.getPath(sRecord, "name"), "")));
	DB.setValue(nodeEntry, "shortcut", "windowreference", sClass, sRecord);
	return true;
end
-- "story"/"referencemanualpage": If empty type, then set to content-story; if content-story, then set record name and add to story links
function handleStoryDrop(nodeSoundset, sClass, sRecord)
	local sType = DB.getValue(nodeSoundset, "type", "");
	local sSubtype = DB.getValue(nodeSoundset, "subtype", "");
	if (sType == "") or ((sType == "content") and (sSubtype == "")) then
		DB.setValue(nodeSoundset, "type", "string", "content");
		DB.setValue(nodeSoundset, "subtype", "string", "story");
		SoundsetManager.helperSetRecordName(nodeSoundset, "story", sRecord);
	end

	if DB.getValue(DB.getPath(nodeSoundset, "type"), "") ~= "content" then
		return;
	end
	if DB.getValue(DB.getPath(nodeSoundset, "subtype"), "") ~= "story" then
		return;
	end

	local nodeTargets = DB.createChild(nodeSoundset, "targets");
	local nodeEntry = DB.createChild(nodeTargets);
	DB.setValue(nodeEntry, "name", "string", StringManager.trim(DB.getValue(DB.getPath(sRecord, "name"), "")));
	DB.setValue(nodeEntry, "shortcut", "windowreference", sClass, sRecord);
	return true;
end
-- "image": If empty type, then set to content-image; if content-image, then set record name and add to image links
function handleImageDrop(nodeSoundset, sClass, sRecord)
	local sType = DB.getValue(nodeSoundset, "type", "");
	local sSubtype = DB.getValue(nodeSoundset, "subtype", "");
	if (sType == "") or ((sType == "content") and (sSubtype == "")) then
		DB.setValue(nodeSoundset, "type", "string", "content");
		DB.setValue(nodeSoundset, "subtype", "string", "image");
		SoundsetManager.helperSetRecordName(nodeSoundset, "image", sRecord);
	end

	if DB.getValue(DB.getPath(nodeSoundset, "type"), "") ~= "content" then
		return;
	end
	if DB.getValue(DB.getPath(nodeSoundset, "subtype"), "") ~= "image" then
		return;
	end

	local nodeTargets = DB.createChild(nodeSoundset, "targets");
	local nodeEntry = DB.createChild(nodeTargets);
	DB.setValue(nodeEntry, "name", "string", StringManager.trim(DB.getValue(DB.getPath(sRecord, "name"), "")));
	DB.setValue(nodeEntry, "shortcut", "windowreference", sClass, sRecord);
	return true;
end
-- "npc": If empty type, then set to content-npc; if content-npc, then set record name and NPC name to check
function handleNPCDrop(nodeSoundset, sClass, sRecord)
	local sType = DB.getValue(nodeSoundset, "type", "");
	if sType ~= "" then
		return;
	end
	DB.setValue(nodeSoundset, "type", "string", "content");

	local sSubtype = DB.getValue(nodeSoundset, "subtype", "");
	if sType ~= "" then
		return;
	end
	DB.setValue(nodeSoundset, "subtype", "string", "npc");

	local sName = SoundsetManager.helperSetRecordName(nodeSoundset, "npc", sRecord);

	DB.setValue(nodeSoundset, "value", "string", sName);
	return true;
end
-- "item": If empty type, then set to trigger-chat and set record name
function handleItemDrop(nodeSoundset, sClass, sRecord)
	local sType = DB.getValue(nodeSoundset, "type", "");
	if sType ~= "" then
		return;
	end
	DB.setValue(nodeSoundset, "type", "string", "trigger");
	DB.setValue(nodeSoundset, "subtype", "string", "");

	local sName = SoundsetManager.helperSetRecordName(nodeSoundset, "item", sRecord);

	local nodePatterns = DB.createChild(nodeSoundset, "subpatterns");
	local nodeEntry = DB.createChild(nodePatterns);
	DB.setValue(nodeEntry, "value", "string", sName);
	DB.setValue(nodeEntry, "regex", "number", 0);

	return true;
end

-- "spell": Custom ruleset type; If empty type, then set to trigger-chat and set record name
-- Standard Ruleset Custom 
function handleStandardSpellDrop(nodeSoundset, sClass, sRecord)
	local sType = DB.getValue(nodeSoundset, "type", "");
	if sType ~= "" then
		return;
	end
	DB.setValue(nodeSoundset, "type", "string", "trigger");

	local tCustomSubtype = SoundsetManager.getTriggerSubtype("cast");
	if not tCustomSubtype then
		return;
	end
	DB.setValue(nodeSoundset, "subtype", "string", "cast");

	local sName = SoundsetManager.helperSetRecordName(nodeSoundset, "spell", sRecord);

	local nodePatterns = DB.createChild(nodeSoundset, "subpatterns");
	local nodeEntry = DB.createChild(nodePatterns);
	DB.setValue(nodeEntry, "value", "string", sName);
	DB.setValue(nodeEntry, "regex", "number", 0);
	return true;
end

-- If record name empty, set to dropped record name with record type prefix
function helperSetRecordName(nodeSoundset, sRecordType, sRecord)
	local sName = DB.getValue(DB.getPath(sRecord, "name"), "");
	if sRecordType == "npc" then
		sName = StringManager.sanitize(sName);
	elseif sRecordType == "item" or sRecordType == "spell" then
		sName = StringManager.capitalizeAll(sName);
	else
		sName = StringManager.trim(sName);
	end
	if DB.getValue(nodeSoundset, "name", "") == "" then
		local sNewName = string.format("%s - %s", LibraryData.getSingleDisplayText(sRecordType), sName);
		DB.setValue(nodeSoundset, "name", "string", sNewName);
	end
	return sName;
end
