-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

--
--	DEFAULTS AND VARIABLES
--

-- UI Sidebar colors
local DEFAULT_COLOR_SIDEBAR_CATEGORY_ICON = "FFF1CC";
local DEFAULT_COLOR_SIDEBAR_CATEGORY_TEXT = "E4C01B";
local DEFAULT_COLOR_SIDEBAR_RECORD_ICON = "002D4E";
local DEFAULT_COLOR_SIDEBAR_RECORD_TEXT = "FFF1CC";

local _cSidebarCategoryIconColor = DEFAULT_COLOR_SIDEBAR_CATEGORY_ICON;
local _cSidebarCategoryTextColor = DEFAULT_COLOR_SIDEBAR_CATEGORY_TEXT;
local _cSidebarRecordIconColor = DEFAULT_COLOR_SIDEBAR_RECORD_ICON;
local _cSidebarRecordTextColor = DEFAULT_COLOR_SIDEBAR_RECORD_TEXT;

-- UI General button colors
local DEFAULT_COLOR_BUTTON_CONTENT = "002D4E";
local DEFAULT_WINDOWMENU_ICON = "002D4E";

local _cUIButtonIconColor = DEFAULT_COLOR_BUTTON_CONTENT;
local _cUIButtonTextColor = nil;
local _cUIWindowMenuIconColor= DEFAULT_WINDOWMENU_ICON;

-- UI General usage colors
local DEFAULT_COLOR_FULL = "000000";
local DEFAULT_COLOR_THREE_QUARTER = "300000";
local DEFAULT_COLOR_HALF = "600000";
local DEFAULT_COLOR_QUARTER = "B00000";
local DEFAULT_COLOR_EMPTY = "C0C0C0";

local DEFAULT_COLOR_GRADIENT_TOP = { r = 0, g = 0, b = 0 };
local DEFAULT_COLOR_GRADIENT_MID = { r = 96, g = 0, b = 0 };
local DEFAULT_COLOR_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 };

COLOR_FULL = DEFAULT_COLOR_FULL;
COLOR_THREE_QUARTER = DEFAULT_COLOR_THREE_QUARTER;
COLOR_HALF = DEFAULT_COLOR_HALF;
COLOR_QUARTER = DEFAULT_COLOR_QUARTER;
COLOR_EMPTY = DEFAULT_COLOR_EMPTY;

COLOR_GRADIENT_TOP = DEFAULT_COLOR_GRADIENT_TOP;
COLOR_GRADIENT_MID = DEFAULT_COLOR_GRADIENT_MID;
COLOR_GRADIENT_BOTTOM = DEFAULT_COLOR_GRADIENT_BOTTOM;

-- UI Health specific colors
local DEFAULT_COLOR_HEALTH_UNWOUNDED = "008000";
local DEFAULT_COLOR_HEALTH_DYING_OR_DEAD = "404040";
local DEFAULT_COLOR_HEALTH_UNCONSCIOUS = "6C2DC7";

local DEFAULT_COLOR_HEALTH_SIMPLE_WOUNDED = "408000";
local DEFAULT_COLOR_HEALTH_SIMPLE_BLOODIED = "C11B17";

local DEFAULT_COLOR_HEALTH_LT_WOUNDS = "408000";
local DEFAULT_COLOR_HEALTH_MOD_WOUNDS = "AF7817";
local DEFAULT_COLOR_HEALTH_HVY_WOUNDS = "E56717";
local DEFAULT_COLOR_HEALTH_CRIT_WOUNDS = "C11B17";

local DEFAULT_COLOR_HEALTH_GRADIENT_TOP = { r = 0, g = 128, b = 0 };
local DEFAULT_COLOR_HEALTH_GRADIENT_MID = { r = 210, g = 112, b = 23 };
local DEFAULT_COLOR_HEALTH_GRADIENT_BOTTOM = { r = 192, g = 0, b = 0 };

COLOR_HEALTH_UNWOUNDED = DEFAULT_COLOR_HEALTH_UNWOUNDED;
COLOR_HEALTH_DYING_OR_DEAD = DEFAULT_COLOR_HEALTH_DYING_OR_DEAD;
COLOR_HEALTH_UNCONSCIOUS = DEFAULT_COLOR_HEALTH_UNCONSCIOUS;

COLOR_HEALTH_SIMPLE_WOUNDED = DEFAULT_COLOR_HEALTH_SIMPLE_WOUNDED;
COLOR_HEALTH_SIMPLE_BLOODIED = DEFAULT_COLOR_HEALTH_SIMPLE_BLOODIED;

COLOR_HEALTH_LT_WOUNDS = DEFAULT_COLOR_HEALTH_LT_WOUNDS;
COLOR_HEALTH_MOD_WOUNDS = DEFAULT_COLOR_HEALTH_MOD_WOUNDS;
COLOR_HEALTH_HVY_WOUNDS = DEFAULT_COLOR_HEALTH_HVY_WOUNDS;
COLOR_HEALTH_CRIT_WOUNDS = DEFAULT_COLOR_HEALTH_CRIT_WOUNDS;

COLOR_HEALTH_GRADIENT_TOP = DEFAULT_COLOR_HEALTH_GRADIENT_TOP;
COLOR_HEALTH_GRADIENT_MID = DEFAULT_COLOR_HEALTH_GRADIENT_MID;
COLOR_HEALTH_GRADIENT_BOTTOM = DEFAULT_COLOR_HEALTH_GRADIENT_BOTTOM;

-- Token Faction specific colors
local DEFAULT_COLOR_TOKEN_FACTION_FRIEND = "00FF00";
local DEFAULT_COLOR_TOKEN_FACTION_NEUTRAL = "FFFF00";
local DEFAULT_COLOR_TOKEN_FACTION_FOE = "FF0000";

COLOR_TOKEN_FACTION_FRIEND = DEFAULT_COLOR_TOKEN_FACTION_FRIEND;
COLOR_TOKEN_FACTION_NEUTRAL = DEFAULT_COLOR_TOKEN_FACTION_NEUTRAL;
COLOR_TOKEN_FACTION_FOE = DEFAULT_COLOR_TOKEN_FACTION_FOE;

-- Token Health specific colors
local DEFAULT_COLOR_TOKEN_HEALTH_UNWOUNDED = "00C000";
local DEFAULT_COLOR_TOKEN_HEALTH_DYING_OR_DEAD = "C0C0C0";
local DEFAULT_COLOR_TOKEN_HEALTH_UNCONSCIOUS = "8C3BFF";

local DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED = "80C000";
local DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED = "FF0000";

local DEFAULT_COLOR_TOKEN_HEALTH_LT_WOUNDS = "80C000";
local DEFAULT_COLOR_TOKEN_HEALTH_MOD_WOUNDS = "FFC000";
local DEFAULT_COLOR_TOKEN_HEALTH_HVY_WOUNDS = "FF6000";
local DEFAULT_COLOR_TOKEN_HEALTH_CRIT_WOUNDS = "FF0000";

local DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_TOP = { r = 0, g = 192, b = 0 };
local DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_MID = { r = 255, g = 192, b = 0 };
local DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 };

COLOR_TOKEN_HEALTH_UNWOUNDED = DEFAULT_COLOR_TOKEN_HEALTH_UNWOUNDED;
COLOR_TOKEN_HEALTH_DYING_OR_DEAD = DEFAULT_COLOR_TOKEN_HEALTH_DYING_OR_DEAD;
COLOR_TOKEN_HEALTH_UNCONSCIOUS = DEFAULT_COLOR_TOKEN_HEALTH_UNCONSCIOUS;

COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED = DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED;
COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED = DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED;

COLOR_TOKEN_HEALTH_LT_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_LT_WOUNDS;
COLOR_TOKEN_HEALTH_MOD_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_MOD_WOUNDS;
COLOR_TOKEN_HEALTH_HVY_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_HVY_WOUNDS;
COLOR_TOKEN_HEALTH_CRIT_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_CRIT_WOUNDS;

COLOR_TOKEN_HEALTH_GRADIENT_TOP = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_TOP;
COLOR_TOKEN_HEALTH_GRADIENT_MID = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_MID;
COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM;

--
--	RESET FUNCTIONS
--

function resetUIColors()
	ColorManager.resetUISidebarColors();
	ColorManager.resetUIWindowMenuColors();
	ColorManager.resetUIGeneralButtonColors();
	ColorManager.resetUIGeneralBarColors();
	ColorManager.resetUIHealthColors();
end
function resetUISidebarColors()
	_cSidebarCategoryIconColor = DEFAULT_COLOR_SIDEBAR_CATEGORY_ICON;
	_cSidebarCategoryTextColor = DEFAULT_COLOR_SIDEBAR_CATEGORY_TEXT;
	_cSidebarRecordIconColor = DEFAULT_COLOR_SIDEBAR_RECORD_ICON;
	_cSidebarRecordTextColor = DEFAULT_COLOR_SIDEBAR_RECORD_TEXT;
end
function resetUIWindowMenuColors()
	_cUIWindowMenuIconColor= DEFAULT_WINDOWMENU_ICON;
end
function resetUIGeneralButtonColors()
	_cUIButtonIconColor = DEFAULT_COLOR_BUTTON_CONTENT;
	_cUIButtonTextColor = nil;
end
function resetUIGeneralBarColors()
	ColorManager.COLOR_FULL = DEFAULT_COLOR_FULL;
	ColorManager.COLOR_THREE_QUARTER = DEFAULT_COLOR_THREE_QUARTER;
	ColorManager.COLOR_HALF = DEFAULT_COLOR_HALF;
	ColorManager.COLOR_QUARTER = DEFAULT_COLOR_QUARTER;
	ColorManager.COLOR_EMPTY = DEFAULT_COLOR_EMPTY;

	ColorManager.COLOR_GRADIENT_TOP = DEFAULT_COLOR_GRADIENT_TOP;
	ColorManager.COLOR_GRADIENT_MID = DEFAULT_COLOR_GRADIENT_MID;
	ColorManager.COLOR_GRADIENT_BOTTOM = DEFAULT_COLOR_GRADIENT_BOTTOM;
end
function resetUIHealthColors()
	ColorManager.COLOR_HEALTH_UNWOUNDED = DEFAULT_COLOR_HEALTH_UNWOUNDED;
	ColorManager.COLOR_HEALTH_DYING_OR_DEAD = DEFAULT_COLOR_HEALTH_DYING_OR_DEAD;
	ColorManager.COLOR_HEALTH_UNCONSCIOUS = DEFAULT_COLOR_HEALTH_UNCONSCIOUS;

	ColorManager.COLOR_HEALTH_SIMPLE_WOUNDED = DEFAULT_COLOR_HEALTH_SIMPLE_WOUNDED;
	ColorManager.COLOR_HEALTH_SIMPLE_BLOODIED = DEFAULT_COLOR_HEALTH_SIMPLE_BLOODIED;

	ColorManager.COLOR_HEALTH_LT_WOUNDS = DEFAULT_COLOR_HEALTH_LT_WOUNDS;
	ColorManager.COLOR_HEALTH_MOD_WOUNDS = DEFAULT_COLOR_HEALTH_MOD_WOUNDS;
	ColorManager.COLOR_HEALTH_HVY_WOUNDS = DEFAULT_COLOR_HEALTH_HVY_WOUNDS;
	ColorManager.COLOR_HEALTH_CRIT_WOUNDS = DEFAULT_COLOR_HEALTH_CRIT_WOUNDS;

	ColorManager.COLOR_HEALTH_GRADIENT_TOP = DEFAULT_COLOR_HEALTH_GRADIENT_TOP;
	ColorManager.COLOR_HEALTH_GRADIENT_MID = DEFAULT_COLOR_HEALTH_GRADIENT_MID;
	ColorManager.COLOR_HEALTH_GRADIENT_BOTTOM = DEFAULT_COLOR_HEALTH_GRADIENT_BOTTOM;
end

function resetTokenColors()
	ColorManager.resetTokenFactionColors();
	ColorManager.resetTokenHealthColors();
end
function resetTokenFactionColors()
	ColorManager.COLOR_TOKEN_FACTION_FRIEND = DEFAULT_COLOR_TOKEN_FACTION_FRIEND;
	ColorManager.COLOR_TOKEN_FACTION_NEUTRAL = DEFAULT_COLOR_TOKEN_FACTION_NEUTRAL;
	ColorManager.COLOR_TOKEN_FACTION_FOE = DEFAULT_COLOR_TOKEN_FACTION_FOE;
end
function resetTokenHealthColors()
	ColorManager.COLOR_TOKEN_HEALTH_UNWOUNDED = DEFAULT_COLOR_TOKEN_HEALTH_UNWOUNDED;
	ColorManager.COLOR_TOKEN_HEALTH_DYING_OR_DEAD = DEFAULT_COLOR_TOKEN_HEALTH_DYING_OR_DEAD;
	ColorManager.COLOR_TOKEN_HEALTH_UNCONSCIOUS = DEFAULT_COLOR_TOKEN_HEALTH_UNCONSCIOUS;

	ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED = DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED;
	ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED = DEFAULT_COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED;

	ColorManager.COLOR_TOKEN_HEALTH_LT_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_LT_WOUNDS;
	ColorManager.COLOR_TOKEN_HEALTH_MOD_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_MOD_WOUNDS;
	ColorManager.COLOR_TOKEN_HEALTH_HVY_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_HVY_WOUNDS;
	ColorManager.COLOR_TOKEN_HEALTH_CRIT_WOUNDS = DEFAULT_COLOR_TOKEN_HEALTH_CRIT_WOUNDS;

	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_TOP = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_TOP;
	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_MID;
	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM = DEFAULT_COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM;
end

--
--	SIDEBAR COLOR ACCESS FUNCTIONS
--

function getSidebarCategoryIconColor()
	return _cSidebarCategoryIconColor;
end
function getSidebarCategoryTextColor()
	return _cSidebarCategoryTextColor;
end
function getSidebarRecordIconColor()
	return _cSidebarRecordIconColor;
end
function getSidebarRecordTextColor()
	return _cSidebarRecordTextColor;
end
function setSidebarCategoryIconColor(s)
	_cSidebarCategoryIconColor = s;
end
function setSidebarCategoryTextColor(s)
	_cSidebarCategoryTextColor = s;
end
function setSidebarRecordIconColor(s)
	_cSidebarRecordIconColor = s;
end
function setSidebarRecordTextColor(s)
	_cSidebarRecordTextColor = s;
end

--
--	HEALTH/TOKEN/USAGE COLOR ACCESS FUNCTIONS
--

function getUsageColor(nPercentUsed, bBar)
	local sColor;
	if not bBar or OptionsManager.isOption("BARC", "tiered") then
		sColor = ColorManager.getTieredUsageColor(nPercentUsed);
	else
		sColor = ColorManager.getGradientUsageColor(nPercentUsed);
	end
	return sColor;
end

function getTieredUsageColor(nPercentUsed)
	local sColor;
	if nPercentUsed <= 0 then
		sColor = ColorManager.COLOR_FULL;
	elseif nPercentUsed <= .25 then
		sColor = ColorManager.COLOR_THREE_QUARTER;
	elseif nPercentUsed <= .5 then
		sColor = ColorManager.COLOR_HALF;
	elseif nPercentUsed <= .75 then
		sColor = ColorManager.COLOR_QUARTER;
	else
		sColor = ColorManager.COLOR_EMPTY;
	end
	return sColor;
end

function getGradientUsageColor(nPercentUsed)
	local sColor;
	if nPercentUsed >= 1 then
		sColor = ColorManager.COLOR_EMPTY;
	elseif nPercentUsed <= 0 then
		sColor = ColorManager.COLOR_FULL;
	else
		local nBarR, nBarG, nBarB;
		if nPercentUsed >= 0.5 then
			local nPercentGrade = (nPercentUsed - 0.5) * 2;
			nBarR = math.floor((ColorManager.COLOR_GRADIENT_BOTTOM.r * nPercentGrade) + (ColorManager.COLOR_GRADIENT_MID.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((ColorManager.COLOR_GRADIENT_BOTTOM.g * nPercentGrade) + (ColorManager.COLOR_GRADIENT_MID.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((ColorManager.COLOR_GRADIENT_BOTTOM.b * nPercentGrade) + (ColorManager.COLOR_GRADIENT_MID.b * (1.0 - nPercentGrade)) + 0.5);
		else
			local nPercentGrade = nPercentUsed * 2;
			nBarR = math.floor((ColorManager.COLOR_GRADIENT_MID.r * nPercentGrade) + (ColorManager.COLOR_GRADIENT_TOP.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((ColorManager.COLOR_GRADIENT_MID.g * nPercentGrade) + (ColorManager.COLOR_GRADIENT_TOP.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((ColorManager.COLOR_GRADIENT_MID.b * nPercentGrade) + (ColorManager.COLOR_GRADIENT_TOP.b * (1.0 - nPercentGrade)) + 0.5);
		end
		sColor = string.format("%02X%02X%02X", nBarR, nBarG, nBarB);
	end
	return sColor;
end

function getHealthColor(nPercentWounded, bBar)
	local sColor;
	if not bBar or OptionsManager.isOption("BARC", "tiered") then
		sColor = ColorManager.getTieredHealthColor(nPercentWounded);
	else
		sColor = ColorManager.getGradientHealthColor(nPercentWounded);
	end
	return sColor;
end

function getTieredHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.COLOR_HEALTH_DYING_OR_DEAD;
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.COLOR_HEALTH_UNWOUNDED;
	elseif OptionsManager.isOption("WNDC", "detailed") then
		if nPercentWounded >= 0.75 then
			sColor = ColorManager.COLOR_HEALTH_CRIT_WOUNDS;
		elseif nPercentWounded >= 0.5 then
			sColor = ColorManager.COLOR_HEALTH_HVY_WOUNDS;
		elseif nPercentWounded >= 0.25 then
			sColor = ColorManager.COLOR_HEALTH_MOD_WOUNDS;
		else
			sColor = ColorManager.COLOR_HEALTH_LT_WOUNDS;
		end
	else
		if nPercentWounded >= 0.5 then
			sColor = ColorManager.COLOR_HEALTH_SIMPLE_BLOODIED;
		else
			sColor = ColorManager.COLOR_HEALTH_SIMPLE_WOUNDED;
		end
	end
	return sColor;
end

function getGradientHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.COLOR_HEALTH_DYING_OR_DEAD;
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.COLOR_HEALTH_UNWOUNDED;
	else
		local nBarR, nBarG, nBarB;
		if nPercentWounded >= 0.5 then
			local nPercentGrade = (nPercentWounded - 0.5) * 2;
			nBarR = math.floor((ColorManager.COLOR_HEALTH_GRADIENT_BOTTOM.r * nPercentGrade) + (ColorManager.COLOR_HEALTH_GRADIENT_MID.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((ColorManager.COLOR_HEALTH_GRADIENT_BOTTOM.g * nPercentGrade) + (ColorManager.COLOR_HEALTH_GRADIENT_MID.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((ColorManager.COLOR_HEALTH_GRADIENT_BOTTOM.b * nPercentGrade) + (ColorManager.COLOR_HEALTH_GRADIENT_MID.b * (1.0 - nPercentGrade)) + 0.5);
		else
			local nPercentGrade = nPercentWounded * 2;
			nBarR = math.floor((ColorManager.COLOR_HEALTH_GRADIENT_MID.r * nPercentGrade) + (ColorManager.COLOR_HEALTH_GRADIENT_TOP.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((ColorManager.COLOR_HEALTH_GRADIENT_MID.g * nPercentGrade) + (ColorManager.COLOR_HEALTH_GRADIENT_TOP.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((ColorManager.COLOR_HEALTH_GRADIENT_MID.b * nPercentGrade) + (ColorManager.COLOR_HEALTH_GRADIENT_TOP.b * (1.0 - nPercentGrade)) + 0.5);
		end
		sColor = string.format("%02X%02X%02X", nBarR, nBarG, nBarB);
	end
	return sColor;
end

function getTokenHealthColor(nPercentWounded, bBar)
	local sColor;
	if not bBar or OptionsManager.isOption("BARC", "tiered") then
		sColor = ColorManager.getTieredTokenHealthColor(nPercentWounded);
	else
		sColor = ColorManager.getGradientTokenHealthColor(nPercentWounded);
	end
	return sColor;
end

function getTieredTokenHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.COLOR_TOKEN_HEALTH_DYING_OR_DEAD;
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.COLOR_TOKEN_HEALTH_UNWOUNDED;
	elseif OptionsManager.isOption("WNDC", "detailed") then
		if nPercentWounded >= 0.75 then
			sColor = ColorManager.COLOR_TOKEN_HEALTH_CRIT_WOUNDS;
		elseif nPercentWounded >= 0.5 then
			sColor = ColorManager.COLOR_TOKEN_HEALTH_HVY_WOUNDS;
		elseif nPercentWounded >= 0.25 then
			sColor = ColorManager.COLOR_TOKEN_HEALTH_MOD_WOUNDS;
		else
			sColor = ColorManager.COLOR_TOKEN_HEALTH_LT_WOUNDS;
		end
	else
		if nPercentWounded >= 0.5 then
			sColor = ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED;
		else
			sColor = ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED;
		end
	end
	return sColor;
end

function getGradientTokenHealthColor(nPercentWounded)
	local sColor;
	if nPercentWounded >= 1 then
		sColor = ColorManager.COLOR_TOKEN_HEALTH_DYING_OR_DEAD;
	elseif nPercentWounded <= 0 then
		sColor = ColorManager.COLOR_TOKEN_HEALTH_UNWOUNDED;
	else
		local nBarR, nBarG, nBarB;
		if nPercentWounded >= 0.5 then
			local nPercentGrade = (nPercentWounded - 0.5) * 2;
			nBarR = math.floor((ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM.r * nPercentGrade) + (ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM.g * nPercentGrade) + (ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM.b * nPercentGrade) + (ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID.b * (1.0 - nPercentGrade)) + 0.5);
		else
			local nPercentGrade = nPercentWounded * 2;
			nBarR = math.floor((ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID.r * nPercentGrade) + (ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_TOP.r * (1.0 - nPercentGrade)) + 0.5);
			nBarG = math.floor((ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID.g * nPercentGrade) + (ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_TOP.g * (1.0 - nPercentGrade)) + 0.5);
			nBarB = math.floor((ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID.b * nPercentGrade) + (ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_TOP.b * (1.0 - nPercentGrade)) + 0.5);
		end
		sColor = string.format("%02X%02X%02X", nBarR, nBarG, nBarB);
	end
	return sColor;
end

--
--	OTHER UI COLORS
--

function setButtonContentColor(s)
	ColorManager.setButtonIconColor(s);
	ColorManager.setButtonTextColor(s);
end

function setButtonIconColor(s)
	_cUIButtonIconColor = s;
end
function getButtonIconColor()
	return _cUIButtonIconColor;
end
function setButtonTextColor(s)
	_cUIButtonTextColor = s;
end
function getButtonTextColor()
	return _cUIButtonTextColor;
end

function setWindowMenuIconColor(s)
	_cUIWindowMenuIconColor = s;
end
function getWindowMenuIconColor()
	return _cUIWindowMenuIconColor;
end
