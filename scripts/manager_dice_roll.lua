-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
--	NOTES
--
--	Format for tColor data:
--		diceskin = int
--		dicebodycolor = string [hex color]
--		dicetextcolor = string [hex color]
--
--	Format for _tDiceSkinDefaults data:
--		table (string, tColor)
--
--	Format for _tDiceSkinKeys data:
--		bSkipDefault = bool
--		sDefaultKey = string [name of default key to use]
--		tModesAllowed = table (numerical index, string)
--		tModesCustom = table (string, tColor) ["" as key is default mode]
--

function onTabletopInit()
	if DiceRollManager.hasDiceSkinKeys() then
		DiceRollManager.loadDiceSkinKeyCustomSettings();
	end
end
function onTabletopClose()
	if DiceRollManager.hasDiceSkinKeys() then
		DiceRollManager.saveDiceSkinKeyCustomSettings();
	end
end

--
--	DICE TABLE ADDITIONS
--		(WITH FG UNITY DICE DATA MAPPINGS)
--

function helperAddDice(tTargetDice, tSourceDice, tData, tDiceSkin)
	for kDie,sDie in ipairs(tSourceDice) do
		local tDie = { type = sDie };
		if tData and tData.iconcolor then
			if tData.iconcolor == "FF00FF" then
				if sDie:sub(1,1) == "-" then
					tDie.type = "-p" .. sDie:sub(3);
				else
					tDie.type = "p" .. sDie:sub(2);
				end
			elseif tData.iconcolor == "00FF00" then
				if sDie:sub(1,1) == "-" then
					tDie.type = "-g" .. sDie:sub(3);
				else
					tDie.type = "g" .. sDie:sub(2);
				end
			else
				tDie.iconcolor = tData.iconcolor;
			end
		end
		if tDiceSkin then
			tDie.diceskin = tDiceSkin.diceskin;
			tDie.dicebodycolor = tDiceSkin.dicebodycolor;
			tDie.dicetextcolor = tDiceSkin.dicetextcolor;
		end
		if tData and tData.index then
			table.insert(tTargetDice, tData.index + kDie - 1, tDie);
		else
			table.insert(tTargetDice, tDie);
		end
	end
end

--
--	DAMAGE DICE TABLE ADDITIONS 
--

local _tDamageModes = {};
function registerDamageTypeMode(sMode)
	if not StringManager.contains(_tDamageModes) then
		table.insert(_tDamageModes, sMode);
	end
end

function registerDamageKey(sDefaultKey)
	DiceRollManager.setDiceSkinKey("damage", { sDefaultKey = sDefaultKey, tModesAllowed = _tDamageModes });
end
function registerDamageTypeKey(sDamageType, sDefaultKey)
	if (sDamageType or "") == "" then
		return;
	end
	DiceRollManager.setDiceSkinKey("damage-type-" .. sDamageType:gsub("%s", "-"), { sDefaultKey = sDefaultKey, tModesAllowed = _tDamageModes });
end

function addDamageDice(tTargetDice, tSourceDice, tData)
	local tDiceSkin = DiceRollManager.getDamageDiceSkin(tData);
	DiceRollManager.helperAddDice(tTargetDice, tSourceDice, tData, tDiceSkin);
end
function getDamageDiceSkin(tData)
	local tDiceSkin;
	local sMode;
	if tData and tData.dmgtype then
		local tDamageTypes = StringManager.split(tData.dmgtype, ",", true);
		for _,s in ipairs(tDamageTypes) do
			if StringManager.contains(_tDamageModes, s) then
				sMode = s;
				break;
			end
		end
		for _,s in ipairs(tDamageTypes) do
			tDiceSkin = DiceRollManager.resolveDiceSkinKey("damage-type-" .. s:gsub("%s", "-"), sMode);
			if tDiceSkin then
				break;
			end
		end
		if tDiceSkin then
		end
	end
	if not tDiceSkin then
		tDiceSkin = DiceRollManager.resolveDiceSkinKey("damage", sMode);
	end
	return tDiceSkin;
end

--
--	HEAL DICE TABLE ADDITIONS 
--

function registerHealKey(sDefaultKey)
	DiceRollManager.setDiceSkinKey("heal", { sDefaultKey = sDefaultKey });
end
function registerHealTypeKey(sHealType, sDefaultKey)
	if (sHealType or "") == "" then
		return;
	end
	DiceRollManager.setDiceSkinKey("heal-type-" .. sHealType:gsub("%s", "-"), { sDefaultKey = sDefaultKey });
end

function addHealDice(tTargetDice, tSourceDice, tData)
	local tDiceSkin = DiceRollManager.getHealDiceSkin(tData);
	DiceRollManager.helperAddDice(tTargetDice, tSourceDice, tData, tDiceSkin);
end
function getHealDiceSkin(tData)
	local tDiceSkin;
	if tData and tData.healtype then
		tDiceSkin = DiceRollManager.resolveDiceSkinKey("heal-type-" .. tData.healtype:gsub("%s", "-"));
	end
	if not tDiceSkin then
		tDiceSkin = DiceRollManager.resolveDiceSkinKey("heal");
	end
	return tDiceSkin;
end

--
--	DICE SKIN KEY DEFAULTS
--

local _tDiceSkinDefaults = {
	["arcane"] = {
		{ diceskin = 60 }, { diceskin = 70 }, { diceskin = 30 }, { diceskin = 40 }, 
		{ diceskin = 50 }, { diceskin = 10 }, { diceskin = 20 }, { diceskin = 80 }, 
		{ diceskin = 94 },
		{ diceskin = 0, dicebodycolor="FF00FF", dicetextcolor="FFFFFF" },
	},
	["earth"] = {
		{ diceskin = 61 }, { diceskin = 71 }, { diceskin = 31 }, { diceskin = 41 }, 
		{ diceskin = 51 }, { diceskin = 11 }, { diceskin = 21 }, { diceskin = 81 }, 
		{ diceskin = 95 },
		{ diceskin = 0, dicebodycolor="8B4513", dicetextcolor="FFFFFF" },
	},
	["fire"] = {
		{ diceskin = 62 }, { diceskin = 72 }, { diceskin = 32 }, { diceskin = 42 }, 
		{ diceskin = 52 }, { diceskin = 12 }, { diceskin = 22 }, { diceskin = 82 }, 
		{ diceskin = 96 },
		{ diceskin = 0, dicebodycolor="FF0000", dicetextcolor="FFFFFF" },
	},
	["frost"] = {
		{ diceskin = 63 }, { diceskin = 73 }, { diceskin = 33 }, { diceskin = 43 }, 
		{ diceskin = 53 }, { diceskin = 13 }, { diceskin = 23 }, { diceskin = 83 }, 
		{ diceskin = 97 },
		{ diceskin = 0, dicebodycolor="00BFFF", dicetextcolor="000000" },
	},
	["life"] = {
		{ diceskin = 64 }, { diceskin = 74 }, { diceskin = 34 }, { diceskin = 44 }, 
		{ diceskin = 54 }, { diceskin = 14 }, { diceskin = 24 }, { diceskin = 84 }, 
		{ diceskin = 98 },
		{ diceskin = 0, dicebodycolor="00FF00", dicetextcolor="000000" },
	},
	["light"] = {
		{ diceskin = 65 }, { diceskin = 75 }, { diceskin = 35 }, { diceskin = 45 }, 
		{ diceskin = 55 }, { diceskin = 15 }, { diceskin = 25 }, { diceskin = 85 }, 
		{ diceskin = 99 },
		{ diceskin = 0, dicebodycolor="FFFF00", dicetextcolor="0000FF" },
	},
	["lightning"] = {
		{ diceskin = 66 }, { diceskin = 76 }, { diceskin = 36 }, { diceskin = 46 }, 
		{ diceskin = 56 }, { diceskin = 16 }, { diceskin = 26 }, { diceskin = 86 }, 
		{ diceskin = 100 },
		{ diceskin = 0, dicebodycolor="FFFF00", dicetextcolor="000000" },
	},
	["shadow"] = {
		{ diceskin = 67 }, { diceskin = 77 }, { diceskin = 37 }, { diceskin = 47 }, 
		{ diceskin = 57 }, { diceskin = 17 }, { diceskin = 27 }, { diceskin = 87 }, 
		{ diceskin = 101 },
		{ diceskin = 0, dicebodycolor="4B0082", dicetextcolor="000000" },
	},
	["storm"] = {
		{ diceskin = 68 }, { diceskin = 78 }, { diceskin = 38 }, { diceskin = 48 }, 
		{ diceskin = 58 }, { diceskin = 18 }, { diceskin = 28 }, { diceskin = 88 }, 
		{ diceskin = 102 },
		{ diceskin = 0, dicebodycolor="B0C4DE", dicetextcolor="000000" },
	},
	["water"] = {
		{ diceskin = 69 }, { diceskin = 79 }, { diceskin = 39 }, { diceskin = 49 }, 
		{ diceskin = 59 }, { diceskin = 19 }, { diceskin = 29 }, { diceskin = 89 }, 
		{ diceskin = 103 },
		{ diceskin = 0, dicebodycolor="0000FF", dicetextcolor="000000" },
	},
};

function getDiceSkinDefaults(sKey)
	if not sKey then
		return nil;
	end
	return _tDiceSkinDefaults[sKey];
end
function setDiceSkinDefaults(sKey, tDefaults)
	if not sKey then
		return;
	end
	_tDiceSkinDefaults[sKey] = tDefaults;
end

--
--	DICE SKIN KEY MANAGEMENT
--

local _tDiceSkinKeys = {};

function loadDiceSkinKeyCustomSettings()
	-- Load original registry color location
	if GlobalRegistry.color then
		local tCustomColors = GlobalRegistry.color[Session.RulesetName];
		if tCustomColors then
			for k,v in pairs(tCustomColors) do
				DiceRollManager.setDiceSkinKeyCustom(k, v);
			end
		end
	end
	if GlobalRegistry.colorskipdefault then
		local tCustomSkip = GlobalRegistry.colorskipdefault[Session.RulesetName];
		if tCustomSkip then
			for k,v in pairs(tCustomSkip) do
				DiceRollManager.setDiceSkinKeySkipDefault(k, v);
			end
		end
	end

	-- Load custom color information
	if GlobalRegistry.colordicerolls and GlobalRegistry.colordicerolls[Session.RulesetName] then
		local tCustomRolls = GlobalRegistry.colordicerolls[Session.RulesetName];

		if tCustomRolls.custombymode then
			for k,tModes in pairs(tCustomRolls.custombymode) do
				for sMode,v in pairs(tModes) do
					DiceRollManager.setDiceSkinKeyModeCustom(k, sMode, v);
				end
			end
		end

		if tCustomRolls.skipdefault then
			for k,v in pairs(tCustomRolls.skipdefault) do
				DiceRollManager.setDiceSkinKeySkipDefault(k, v);
			end
		end
	end
end
function saveDiceSkinKeyCustomSettings()
	-- Cleanup legacy registry color location
	if GlobalRegistry.color then
		GlobalRegistry.color[Session.RulesetName] = nil;
		if next(GlobalRegistry.color) == nil then
			GlobalRegistry.color = nil;
		end
	end
	if GlobalRegistry.colorskipdefault then
		GlobalRegistry.colorskipdefault[Session.RulesetName] = nil;
		if next(GlobalRegistry.colorskipdefault) == nil then
			GlobalRegistry.colorskipdefault = nil;
		end
	end

	-- Save custom color information
	local tColorDiceRolls = {};

	local tCustomModeColors = {};
	for k,v in pairs(_tDiceSkinKeys) do
		if v.tModesCustom then
			for sMode,v2 in pairs(v.tModesCustom) do
				tCustomModeColors[k] = tCustomModeColors[k] or {};
				tCustomModeColors[k][sMode] = v2;
			end
		end
	end
	tColorDiceRolls.custombymode = tCustomModeColors;

	local tCustomSkip = {};
	for k,v in pairs(_tDiceSkinKeys) do
		if v.bSkipDefault then
			tCustomSkip[k] = true;
		end
	end
	tColorDiceRolls.skipdefault = tCustomSkip;

	GlobalRegistry.colordicerolls = GlobalRegistry.colordicerolls or {};
	GlobalRegistry.colordicerolls[Session.RulesetName] = tColorDiceRolls;
end

function resolveDiceSkinKey(sKey, sMode)
	if not sKey then
		return nil;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if tDiceSkinKey then
		local tCustom = tDiceSkinKey.tModesCustom;
		if tCustom then
			if sMode and tCustom[sMode] then
				return tCustom[sMode];
			end
			if tCustom[""] then
				return tCustom[""];
			end
		end
		if not tDiceSkinKey.bSkipDefault and tDiceSkinKey.sDefaultKey then
			local tDefaults = _tDiceSkinDefaults[tDiceSkinKey.sDefaultKey];
			if tDefaults then
				for _,v in ipairs(tDefaults) do
					if DiceSkinManager.isDiceSkinOwned(v.diceskin or 0) then
						return v;
					end
				end
			end
		end
	end
	return nil;
end
function resolveDiceSkinKeyDefault(sKey)
	if not sKey then
		return nil;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if tDiceSkinKey then
		if tDiceSkinKey.sDefaultKey then
			local tDefaults = _tDiceSkinDefaults[tDiceSkinKey.sDefaultKey];
			if tDefaults then
				for _,v in ipairs(tDefaults) do
					if DiceSkinManager.isDiceSkinOwned(v.diceskin or 0) then
						return v;
					end
				end
			end
		end
	end
	return nil;
end

function hasDiceSkinKeys()
	for _,_ in pairs(_tDiceSkinKeys) do
		return true;
	end
	return false;
end
function getDiceSkinKeys()
	return _tDiceSkinKeys;
end

function getDiceSkinKey(sKey)
	if not sKey then
		return nil;
	end
	return _tDiceSkinKeys[sKey];
end
function setDiceSkinKey(sKey, tData)
	if not sKey then
		return;
	end
	_tDiceSkinKeys[sKey] = tData;
end

function getDiceSkinKeyDefaultKey(sKey)
	if not sKey then
		return nil;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if not tDiceSkinKey then
		return nil;
	end
	return tDiceSkinKey.sDefaultKey
end
function setDiceSkinKeyDefaultKey(sKey, sDefaultKey)
	if not sKey then
		return;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if not tDiceSkinKey then
		return;
	end
	tDiceSkinKey.sDefaultKey = sDefaultKey;
end

function getDiceSkinKeySkipDefault(sKey)
	if not sKey then
		return false;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if not tDiceSkinKey then
		return false;
	end
	return tDiceSkinKey.bSkipDefault;
end
function setDiceSkinKeySkipDefault(sKey, bSkipDefault)
	if not sKey then
		return;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if not tDiceSkinKey then
		return;
	end
	tDiceSkinKey.bSkipDefault = bSkipDefault;
end

function getDiceSkinKeyCustom(sKey)
	return DiceRollManager.getDiceSkinKeyModeCustom(sKey, "");
end
function setDiceSkinKeyCustom(sKey, tCustom)
	DiceRollManager.setDiceSkinKeyModeCustom(sKey, "", tCustom);
end
function getDiceSkinKeyModeCustom(sKey, sMode)
	if not sKey or not sMode then
		return nil;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if not tDiceSkinKey or not tDiceSkinKey.tModesCustom then
		return nil;
	end
	return tDiceSkinKey.tModesCustom[sMode];
end
function setDiceSkinKeyModeCustom(sKey, sMode, tCustom)
	if not sKey or not sMode then
		return;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if not tDiceSkinKey then
		return;
	end
	if (sMode ~= "") and not StringManager.contains(tDiceSkinKey.tModesAllowed, sMode) then
		return;
	end
	tDiceSkinKey.tModesCustom = tDiceSkinKey.tModesCustom or {};
	tDiceSkinKey.tModesCustom[sMode] = tCustom;
end
function getDiceSkinKeyAllowedModes(sKey)
	if not sKey then
		return nil;
	end
	local tDiceSkinKey = _tDiceSkinKeys[sKey];
	if not tDiceSkinKey then
		return nil;
	end
	return tDiceSkinKey.tModesAllowed;
end
