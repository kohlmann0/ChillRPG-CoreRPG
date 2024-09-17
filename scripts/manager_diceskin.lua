-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

DEFAULT_DICESKIN_GROUP = "DEFAULT";

WIDGET_PADDING = 2;
WIDGET_SIZE = 16;
WIDGET_HALF_SIZE = 10;

local _tDiceSkinGroups = {
	"DEFAULT",
	"SWKELEMENTALBASICSDICE",
	"SWKMETALDICE",
	"SWKAURADICE",
	"SWKMAGICALDICE",
	"SWKRINGOFELEMENTSDICE",
	"SWKMAGICALTRAILDICE",
	"SWKFORCEFIELDDICE",
	"SWKWIZARDWROUGHTDICE",
	"SWKARTIFICERDICE",
	"SWKANNULUSOFFOCUSDICE",
	"SWKANNULUSOFFOCUSDICEFX",
	"SWKKNOTSOFFATEDICE",
	"SWKKNOTSOFFATEDICEFX",
	"SWKBLOODDICE",
	"SWKSTARSANDCLOVERS",
	"SWKHEARTSANDSKULLS",
};

local _tDiceSkinGroupStoreID = {
	["SWKMETALDICE"] = "SWKMETALDICE",
	["SWKAURADICE"] = "SWKAURADICE",
	["SWKMAGICALDICE"] = "SWKMAGICALDICE",
	["SWKRINGOFELEMENTSDICE"] = "SWKRINGOFELEMENTSDICE",
	["SWKMAGICALTRAILDICE"] = "SWKMAGICALTRAILDICE",
	["SWKFORCEFIELDDICE"] = "SWKFORCEFIELDDICE",
	["SWKWIZARDWROUGHTDICE"] = "SWKWIZARDWROUGHTDICE",
	["SWKARTIFICERDICE"] = "SWKARTIFICERDICE",
	["SWKANNULUSOFFOCUSDICE"] = "SWKANNULUSOFFOCUSDICE",
	["SWKANNULUSOFFOCUSDICEFX"] = "SWKANNULUSOFFOCUSDICE",
	["SWKKNOTSOFFATEDICE"] = "SWKKNOTSOFFATEDICE",
	["SWKKNOTSOFFATEDICEFX"] = "SWKKNOTSOFFATEDICE",
	["SWKBLOODDICE"] = "SWKBLOODDICE",
	["SWKSTARSANDCLOVERS"] = "SWKSTARSANDCLOVERS",
	["SWKHEARTSANDSKULLS"] = "SWKHEARTSANDSKULLS",
};

local _tDiceSkinToGroupMap = {
	[0] = "DEFAULT",
	[1] = "DEFAULT", [2] = "SWKMETALDICE", [3] = "SWKMETALDICE", [4] = "SWKMETALDICE", [5] = "SWKMETALDICE",
	[6] = "SWKMETALDICE", [7] = "SWKMETALDICE", [8] = "SWKMETALDICE", [9] = "SWKMETALDICE", 
	[10] = "SWKAURADICE", [11] = "SWKAURADICE", [12] = "SWKAURADICE", [13] = "SWKAURADICE", [14] = "SWKAURADICE", 
	[15] = "SWKAURADICE", [16] = "SWKAURADICE", [17] = "SWKAURADICE", [18] = "SWKAURADICE", [19] = "SWKAURADICE", 
	[20] = "SWKAURADICE", [21] = "SWKAURADICE", [22] = "SWKAURADICE", [23] = "SWKAURADICE", [24] = "SWKAURADICE", 
	[25] = "SWKAURADICE", [26] = "SWKAURADICE", [27] = "SWKAURADICE", [28] = "SWKAURADICE", [29] = "SWKAURADICE", 
	[30] = "SWKMAGICALDICE", [31] = "SWKMAGICALDICE", [32] = "SWKMAGICALDICE", [33] = "SWKMAGICALDICE", [34] = "SWKMAGICALDICE", 
	[35] = "SWKMAGICALDICE", [36] = "SWKMAGICALDICE", [37] = "SWKMAGICALDICE", [38] = "SWKMAGICALDICE", [39] = "SWKMAGICALDICE", 
	[40] = "SWKRINGOFELEMENTSDICE", [41] = "SWKRINGOFELEMENTSDICE", [42] = "SWKRINGOFELEMENTSDICE", [43] = "SWKRINGOFELEMENTSDICE", [44] = "SWKRINGOFELEMENTSDICE", 
	[45] = "SWKRINGOFELEMENTSDICE", [46] = "SWKRINGOFELEMENTSDICE", [47] = "SWKRINGOFELEMENTSDICE", [48] = "SWKRINGOFELEMENTSDICE", [49] = "SWKRINGOFELEMENTSDICE", 
	[50] = "SWKRINGOFELEMENTSDICE", [51] = "SWKRINGOFELEMENTSDICE", [52] = "SWKRINGOFELEMENTSDICE", [53] = "SWKRINGOFELEMENTSDICE", [54] = "SWKRINGOFELEMENTSDICE", 
	[55] = "SWKRINGOFELEMENTSDICE", [56] = "SWKRINGOFELEMENTSDICE", [57] = "SWKRINGOFELEMENTSDICE", [58] = "SWKRINGOFELEMENTSDICE", [59] = "SWKRINGOFELEMENTSDICE", 
	[60] = "SWKMAGICALTRAILDICE", [61] = "SWKMAGICALTRAILDICE", [62] = "SWKMAGICALTRAILDICE", [63] = "SWKMAGICALTRAILDICE", [64] = "SWKMAGICALTRAILDICE", 
	[65] = "SWKMAGICALTRAILDICE", [66] = "SWKMAGICALTRAILDICE", [67] = "SWKMAGICALTRAILDICE", [68] = "SWKMAGICALTRAILDICE", [69] = "SWKMAGICALTRAILDICE", 
	[70] = "SWKMAGICALTRAILDICE", [71] = "SWKMAGICALTRAILDICE", [72] = "SWKMAGICALTRAILDICE", [73] = "SWKMAGICALTRAILDICE", [74] = "SWKMAGICALTRAILDICE", 
	[75] = "SWKMAGICALTRAILDICE", [76] = "SWKMAGICALTRAILDICE", [77] = "SWKMAGICALTRAILDICE", [78] = "SWKMAGICALTRAILDICE", [79] = "SWKMAGICALTRAILDICE", 
	[80] = "SWKFORCEFIELDDICE", [81] = "SWKFORCEFIELDDICE", [82] = "SWKFORCEFIELDDICE", [83] = "SWKFORCEFIELDDICE", [84] = "SWKFORCEFIELDDICE", 
	[85] = "SWKFORCEFIELDDICE", [86] = "SWKFORCEFIELDDICE", [87] = "SWKFORCEFIELDDICE", [88] = "SWKFORCEFIELDDICE", [89] = "SWKFORCEFIELDDICE", 
	[90] = "DEFAULT", [91] = "SWKFORCEFIELDDICE", [92] = "SWKMETALDICE", [93] = "SWKMETALDICE",
	[94] = "SWKELEMENTALBASICSDICE", [95] = "SWKELEMENTALBASICSDICE", [96] = "SWKELEMENTALBASICSDICE", [97] = "SWKELEMENTALBASICSDICE", [98] = "SWKELEMENTALBASICSDICE", 
	[99] = "SWKELEMENTALBASICSDICE", [100] = "SWKELEMENTALBASICSDICE", [101] = "SWKELEMENTALBASICSDICE", [102] = "SWKELEMENTALBASICSDICE", [103] = "SWKELEMENTALBASICSDICE", 
	[110] = "SWKWIZARDWROUGHTDICE", [111] = "SWKWIZARDWROUGHTDICE", [112] = "SWKWIZARDWROUGHTDICE", [113] = "SWKWIZARDWROUGHTDICE", [114] = "SWKWIZARDWROUGHTDICE", 
	[115] = "SWKWIZARDWROUGHTDICE", [116] = "SWKWIZARDWROUGHTDICE", [117] = "SWKWIZARDWROUGHTDICE", [118] = "SWKWIZARDWROUGHTDICE", [119] = "SWKWIZARDWROUGHTDICE", 
	[120] = "SWKWIZARDWROUGHTDICE", [121] = "SWKWIZARDWROUGHTDICE", [122] = "SWKWIZARDWROUGHTDICE", [123] = "SWKWIZARDWROUGHTDICE", [124] = "SWKWIZARDWROUGHTDICE", 
	[125] = "SWKWIZARDWROUGHTDICE", 
	[130] = "SWKARTIFICERDICE", [131] = "SWKARTIFICERDICE", [132] = "SWKARTIFICERDICE", [133] = "SWKARTIFICERDICE", [134] = "SWKARTIFICERDICE", 
	[135] = "SWKARTIFICERDICE", [136] = "SWKARTIFICERDICE", [137] = "SWKARTIFICERDICE", [138] = "SWKARTIFICERDICE", [139] = "SWKARTIFICERDICE", 
	[140] = "SWKARTIFICERDICE", [141] = "SWKARTIFICERDICE",
	[150] = "SWKANNULUSOFFOCUSDICE", [151] = "SWKANNULUSOFFOCUSDICE", [152] = "SWKANNULUSOFFOCUSDICE", [153] = "SWKANNULUSOFFOCUSDICE", [154] = "SWKANNULUSOFFOCUSDICE", 
	[155] = "SWKANNULUSOFFOCUSDICE", [156] = "SWKANNULUSOFFOCUSDICE", [157] = "SWKANNULUSOFFOCUSDICE", [158] = "SWKANNULUSOFFOCUSDICE", [159] = "SWKANNULUSOFFOCUSDICE", 
	[160] = "SWKANNULUSOFFOCUSDICEFX", [161] = "SWKANNULUSOFFOCUSDICEFX", [162] = "SWKANNULUSOFFOCUSDICEFX", [163] = "SWKANNULUSOFFOCUSDICEFX", [164] = "SWKANNULUSOFFOCUSDICEFX", 
	[165] = "SWKANNULUSOFFOCUSDICEFX", [166] = "SWKANNULUSOFFOCUSDICEFX", [167] = "SWKANNULUSOFFOCUSDICEFX", [168] = "SWKANNULUSOFFOCUSDICEFX", [169] = "SWKANNULUSOFFOCUSDICEFX", 
	[170] = "SWKANNULUSOFFOCUSDICE", [171] = "SWKANNULUSOFFOCUSDICE", [172] = "SWKANNULUSOFFOCUSDICE", [173] = "SWKANNULUSOFFOCUSDICE", [174] = "SWKANNULUSOFFOCUSDICE", 
	[175] = "SWKANNULUSOFFOCUSDICE", [177] = "SWKANNULUSOFFOCUSDICE", [178] = "SWKANNULUSOFFOCUSDICE", [179] = "SWKANNULUSOFFOCUSDICE", 
	[180] = "SWKANNULUSOFFOCUSDICEFX", [181] = "SWKANNULUSOFFOCUSDICEFX", [182] = "SWKANNULUSOFFOCUSDICEFX", [183] = "SWKANNULUSOFFOCUSDICEFX", [184] = "SWKANNULUSOFFOCUSDICEFX", 
	[185] = "SWKANNULUSOFFOCUSDICEFX", [187] = "SWKANNULUSOFFOCUSDICEFX", [188] = "SWKANNULUSOFFOCUSDICEFX", [189] = "SWKANNULUSOFFOCUSDICEFX", 
	[190] = "SWKKNOTSOFFATEDICE", [191] = "SWKKNOTSOFFATEDICE", [192] = "SWKKNOTSOFFATEDICE", [193] = "SWKKNOTSOFFATEDICE", [194] = "SWKKNOTSOFFATEDICE", 
	[195] = "SWKKNOTSOFFATEDICE", [196] = "SWKKNOTSOFFATEDICE", [197] = "SWKKNOTSOFFATEDICE", [198] = "SWKKNOTSOFFATEDICE", [199] = "SWKKNOTSOFFATEDICE", 
	[200] = "SWKKNOTSOFFATEDICEFX", [201] = "SWKKNOTSOFFATEDICEFX", [202] = "SWKKNOTSOFFATEDICEFX", [203] = "SWKKNOTSOFFATEDICEFX", [204] = "SWKKNOTSOFFATEDICEFX", 
	[205] = "SWKKNOTSOFFATEDICEFX", [206] = "SWKKNOTSOFFATEDICEFX", [207] = "SWKKNOTSOFFATEDICEFX", [208] = "SWKKNOTSOFFATEDICEFX", [209] = "SWKKNOTSOFFATEDICEFX", 
	[210] = "SWKKNOTSOFFATEDICE", [211] = "SWKKNOTSOFFATEDICE", [212] = "SWKKNOTSOFFATEDICE", [213] = "SWKKNOTSOFFATEDICE", [214] = "SWKKNOTSOFFATEDICE", 
	[215] = "SWKKNOTSOFFATEDICE", [216] = "SWKKNOTSOFFATEDICE", [217] = "SWKKNOTSOFFATEDICE", [218] = "SWKKNOTSOFFATEDICE", [219] = "SWKKNOTSOFFATEDICE", 
	[220] = "SWKKNOTSOFFATEDICEFX", [221] = "SWKKNOTSOFFATEDICEFX", [222] = "SWKKNOTSOFFATEDICEFX", [223] = "SWKKNOTSOFFATEDICEFX", [224] = "SWKKNOTSOFFATEDICEFX", 
	[225] = "SWKKNOTSOFFATEDICEFX", [226] = "SWKKNOTSOFFATEDICEFX", [227] = "SWKKNOTSOFFATEDICEFX", [228] = "SWKKNOTSOFFATEDICEFX", [229] = "SWKKNOTSOFFATEDICEFX", 
	[230] = "SWKBLOODDICE", [231] = "SWKBLOODDICE", [232] = "SWKBLOODDICE", [233] = "SWKBLOODDICE", [234] = "SWKBLOODDICE", 
	[235] = "SWKBLOODDICE", [236] = "SWKBLOODDICE", [237] = "SWKBLOODDICE", [238] = "SWKBLOODDICE", [239] = "SWKBLOODDICE", 
	[240] = "SWKSTARSANDCLOVERS", [241] = "SWKSTARSANDCLOVERS", [242] = "SWKSTARSANDCLOVERS", [243] = "SWKSTARSANDCLOVERS", [244] = "SWKSTARSANDCLOVERS", 
	[245] = "SWKSTARSANDCLOVERS", [246] = "SWKSTARSANDCLOVERS", [247] = "SWKSTARSANDCLOVERS", [248] = "SWKSTARSANDCLOVERS", [249] = "SWKSTARSANDCLOVERS", 
	[250] = "SWKHEARTSANDSKULLS", [251] = "SWKHEARTSANDSKULLS", [252] = "SWKHEARTSANDSKULLS", [253] = "SWKHEARTSANDSKULLS", [254] = "SWKHEARTSANDSKULLS", 
	[255] = "SWKHEARTSANDSKULLS", [256] = "SWKHEARTSANDSKULLS", [257] = "SWKHEARTSANDSKULLS", [258] = "SWKHEARTSANDSKULLS", [259] = "SWKHEARTSANDSKULLS", 
};

local _tDiceSkinAttributeInfo = {
	[0] = {bTintable = true},
	[1] = {bDisabled = true, bTrail = true, sElement = "frost", sIcon = "frost"},
	[2] = {sIcon = "metal_gold"},
	[3] = {sIcon = "metal_darkgold"},
	[4] = {sIcon = "metal_steel"},
	[5] = {sIcon = "metal_pitted", bTintable = true},
	[6] = {sIcon = "metal_polishedsilver", bTintable = true},
	[7] = {sIcon = "metal_rustediron"},
	[8] = {sIcon = "metal_stainedcopper"},
	[9] = {sIcon = "metal_polishedsilver", bTintable = true},
	[10] = {sElement = "arcane", bAuraCast = true},
	[11] = {sElement = "earth", bAuraCast = true},
	[12] = {sElement = "fire",  bAuraCast = true},
	[13] = {sElement = "frost", bAuraCast = true},
	[14] = {sElement = "life", bAuraCast = true},
	[15] = {sElement = "light", bAuraCast = true},
	[16] = {sElement = "lightning", bAuraCast = true},
	[17] = {sElement = "shadow", bAuraCast = true},
	[18] = {sElement = "storm", bAuraCast = true},
	[19] = {sElement = "water", bAuraCast = true},
	[20] = {sElement = "arcane",  bAura = true},
	[21] = {sElement = "earth", bAura = true},
	[22] = {sElement = "fire", bAura = true},
	[23] = {sElement = "frost", bAura = true},
	[24] = {sElement = "life", bAura = true},
	[25] = {sElement = "light", bAura = true},
	[26] = {sElement = "lightning", bAura = true},
	[27] = {sElement = "shadow", bAura = true},
	[28] = {sElement = "storm", bAura = true},
	[29] = {sElement = "water", bAura = true},
	[30] = {sElement = "arcane", bAura = true, bTrail = true},
	[31] = {sElement = "earth", bAura = true, bTrail = true},
	[32] = {sElement = "fire", bAura = true, bTrail = true},
	[33] = {sElement = "frost", bAura = true, bTrail = true},
	[34] = {sElement = "life", bAura = true, bTrail = true},
	[35] = {sElement = "light", bAura = true, bTrail = true},
	[36] = {sElement = "lightning", bAura = true, bTrail = true},
	[37] = {sElement = "shadow", bAura = true, bTrail = true},
	[38] = {sElement = "storm", bAura = true, bTrail = true},
	[39] = {sElement = "water", bAura = true, bTrail = true},
	[40] = {sElement = "arcane", bAura = true},
	[41] = {sElement = "earth", bAura = true},
	[42] = {sElement = "fire", bAura = true},
	[43] = {sElement = "frost", bAura = true},
	[44] = {sElement = "life", bAura = true},
	[45] = {sElement = "light", bAura = true},
	[46] = {sElement = "lightning", bAura = true},
	[47] = {sElement = "shadow", bAura = true},
	[48] = {sElement = "storm", bAura = true},
	[49] = {sElement = "water", bAura = true},
	[50] = {sElement = "arcane",  bAuraCast = true},
	[51] = {sElement = "earth", bAuraCast = true},
	[52] = {sElement = "fire", bAuraCast = true},
	[53] = {sElement = "frost", bAuraCast = true},
	[54] = {sElement = "life", bAuraCast = true},
	[55] = {sElement = "light", bAuraCast = true},
	[56] = {sElement = "lightning", bAuraCast = true},
	[57] = {sElement = "shadow", bAuraCast = true},
	[58] = {sElement = "storm", bAuraCast = true},
	[59] = {sElement = "water", bAuraCast = true},
	[60] = {sElement = "arcane",  bTrail = true},
	[61] = {sElement = "earth", bTrail = true},
	[62] = {sElement = "fire",  bTrail = true},
	[63] = {sElement = "frost", bTrail = true},
	[64] = {sElement = "life", bTrail = true},
	[65] = {sElement = "light", bTrail = true},
	[66] = {sElement = "lightning", bTrail = true},
	[67] = {sElement = "shadow", bTrail = true},
	[68] = {sElement = "storm", bTrail = true},
	[69] = {sElement = "water", bTrail = true},
	[70] = {sElement = "arcane",  bTrail = true},
	[71] = {sElement = "earth", bTrail = true},
	[72] = {sElement = "fire",  bTrail = true},
	[73] = {sElement = "frost", bTrail = true},
	[74] = {sElement = "life", bTrail = true},
	[75] = {sElement = "light", bTrail = true},
	[76] = {sElement = "lightning", bTrail = true},
	[77] = {sElement = "shadow", bTrail = true},
	[78] = {sElement = "storm", bTrail = true},
	[79] = {sElement = "water", bTrail = true},
	[80] = {sElement = "arcane",  bForceField = true},
	[81] = {sElement = "earth", bForceField = true},
	[82] = {sElement = "fire", bForceField = true},
	[83] = {sElement = "frost", bForceField = true},
	[84] = {sElement = "life", bForceField = true},
	[85] = {sElement = "light", bForceField = true},
	[86] = {sElement = "lightning", bForceField = true},
	[87] = {sElement = "shadow", bForceField = true},
	[88] = {sElement = "storm", bForceField = true},
	[89] = {sElement = "water", bForceField = true},
	[90] = {bDisabled = true, sElement = "earth", bTrail = true},
	[91] = {bForceField = true, bTintable = true},
	[92] = {sIcon = "metal_rustediron", bTintable = true},
	[93] = {sIcon = "metal_stainedcopper", bTintable = true},
	[94] = {sElement = "arcane"},
	[95] = {sElement = "earth"},
	[96] = {sElement = "fire"},
	[97] = {sElement = "frost"},
	[98] = {sElement = "life"},
	[99] = {sElement = "light"},
	[100] = {sElement = "lightning"},
	[101] = {sElement = "shadow"},
	[102] = {sElement = "storm"},
	[103] = {sElement = "water"},
	[110] = {sIcon = "decorative_base", sBadge = "decorative", bTintable = true},
	[111] = {sIcon = "decorative_base_inverted", sBadge = "decorative", bTintable = true},
	[112] = {sIcon = "decorative_storm", sBadge = "decorative", sElement = "storm"},
	[113] = {sIcon = "decorative_storm_inverted", sBadge = "decorative", sElement = "storm"},
	[114] = {sIcon = "decorative_water", sBadge = "decorative", sElement = "water"},
	[115] = {sIcon = "decorative_water_inverted", sBadge = "decorative", sElement = "water"},
	[116] = {sIcon = "decorative_iron", sBadge = "decorative"},
	[117] = {sIcon = "decorative_iron_inverted", sBadge = "decorative"},
	[118] = {sIcon = "decorative_bark", sBadge = "decorative"},
	[119] = {sIcon = "decorative_bark_inverted", sBadge = "decorative"},
	[120] = {sIcon = "decorative_gold_white", sBadge = "decorative"},
	[121] = {sIcon = "decorative_gold_white_inverted", sBadge = "decorative"},
	[122] = {sIcon = "decorative_gold_antique", sBadge = "decorative"},
	[123] = {sIcon = "decorative_gold_antique_inverted", sBadge = "decorative"},
	[124] = {sIcon = "decorative_gold_green", sBadge = "decorative"},
	[125] = {sIcon = "decorative_gold_green_inverted", sBadge = "decorative"},
	[130] = {sIcon = "artificer_base", sBadge = "artificer", bTintable = true},
	[131] = {sIcon = "artificer_nightshade", sBadge = "artificer"},
	[132] = {sIcon = "artificer_bark", sBadge = "artificer"},
	[133] = {sIcon = "artificer_darkgold", sBadge = "artificer"},
	[134] = {sIcon = "artificer_gold", sBadge = "artificer"},
	[135] = {sIcon = "artificer_whitegold", sBadge = "artificer"},
	[136] = {sIcon = "artificer_rustediron", sBadge = "artificer"},
	[137] = {sIcon = "artificer_greeniron", sBadge = "artificer"},
	[138] = {sIcon = "artificer_stainedcopper", sBadge = "artificer"},
	[139] = {sIcon = "artificer_storm", sBadge = "artificer"},
	[140] = {sIcon = "artificer_greengilt", sBadge = "artificer"},
	[141] = {sIcon = "artificer_liquiddream", sBadge = "artificer"},
	[150] = {sIcon = "annulusoffocus", bTintable = true},
	[151] = {sIcon = "annulusoffocus_hotoil"},
	[152] = {sIcon = "annulusoffocus_frostboil"},
	[153] = {sIcon = "annulusoffocus_boghollow"},
	[154] = {sIcon = "annulusoffocus_sunlitcatalyst"},
	[155] = {sIcon = "annulusoffocus_scorchedsunset"},
	[156] = {sIcon = "annulusoffocus_timestop"},
	[157] = {sIcon = "annulusoffocus_verdantportal"},
	[158] = {sIcon = "annulusoffocus_mosswillow"},
	[159] = {sIcon = "annulusoffocus_floodvine"},
	[160] = {sIcon = "annulusoffocus", bTrail = true, bTintable = true},
	[161] = {sIcon = "annulusoffocus_hotoil", bTrail = true},
	[162] = {sIcon = "annulusoffocus_frostboil", bTrail = true},
	[163] = {sIcon = "annulusoffocus_boghollow", bTrail = true},
	[164] = {sIcon = "annulusoffocus_sunlitcatalyst", bTrail = true},
	[165] = {sIcon = "annulusoffocus_scorchedsunset", bTrail = true},
	[166] = {sIcon = "annulusoffocus_timestop", bTrail = true},
	[167] = {sIcon = "annulusoffocus_verdantportal", bTrail = true},
	[168] = {sIcon = "annulusoffocus_mosswillow", bTrail = true},
	[169] = {sIcon = "annulusoffocus_floodvine", bTrail = true},
	[170] = {sIcon = "annulusoffocus_gnarlwood"},
	[171] = {sIcon = "annulusoffocus_sandycerulean"},
	[172] = {sIcon = "annulusoffocus_tranquilcoral"},
	[173] = {sIcon = "annulusoffocus_steelthicket"},
	[174] = {sIcon = "annulusoffocus_gold"},
	[175] = {sIcon = "annulusoffocus_stainedcopper", bTintable = true},
	[177] = {sIcon = "annulusoffocus_midtone", bTintable = true},
	[178] = {sIcon = "annulusoffocus_light", bTintable = true},
	[179] = {sIcon = "annulusoffocus_dark", bTintable = true},
	[180] = {sIcon = "annulusoffocus_gnarlwood", bTrail = true},
	[181] = {sIcon = "annulusoffocus_sandycerulean", bTrail = true},
	[182] = {sIcon = "annulusoffocus_tranquilcoral", bTrail = true},
	[183] = {sIcon = "annulusoffocus_steelthicket", bTrail = true},
	[184] = {sIcon = "annulusoffocus_gold", bTrail = true},
	[185] = {sIcon = "annulusoffocus_stainedcopper", bTrail = true, bTintable = true},
	[187] = {sIcon = "annulusoffocus_midtone", bTrail = true, bTintable = true},
	[188] = {sIcon = "annulusoffocus_light", bTrail = true, bTintable = true},
	[189] = {sIcon = "annulusoffocus_dark", bTrail = true, bTintable = true},
	[190] = {sIcon = "knotsoffate", bTintable = true},
	[191] = {sIcon = "knotsoffate_frostboil"},
	[192] = {sIcon = "knotsoffate_sizzlingamber"},
	[193] = {sIcon = "knotsoffate_aquaticmirage"},
	[194] = {sIcon = "knotsoffate_mysticchroma", bTintable = true},
	[195] = {sIcon = "knotsoffate_vividspring"},
	[196] = {sIcon = "knotsoffate_radiantcoral"},
	[197] = {sIcon = "knotsoffate_sandstoneswirl"},
	[198] = {sIcon = "knotsoffate_luminouslavender"},
	[199] = {sIcon = "knotsoffate_enigmaticseaweed"},
	[200] = {sIcon = "knotsoffate", bTrail = true, bTintable = true},
	[201] = {sIcon = "knotsoffate_frostboil", bTrail = true},
	[202] = {sIcon = "knotsoffate_sizzlingamber", bTrail = true},
	[203] = {sIcon = "knotsoffate_aquaticmirage", bTrail = true},
	[204] = {sIcon = "knotsoffate_mysticchroma", bTrail = true, bTintable = true},
	[205] = {sIcon = "knotsoffate_vividspring", bTrail = true},
	[206] = {sIcon = "knotsoffate_radiantcoral", bTrail = true},
	[207] = {sIcon = "knotsoffate_sandstoneswirl", bTrail = true},
	[208] = {sIcon = "knotsoffate_luminouslavender", bTrail = true},
	[209] = {sIcon = "knotsoffate_enigmaticseaweed", bTrail = true},
	[210] = {sIcon = "knotsoffate_flamingtapestry"},
	[211] = {sIcon = "knotsoffate_burnishedspice"},
	[212] = {sIcon = "knotsoffate_autumnentwined"},
	[213] = {sIcon = "knotsoffate_harmoniclilac"},
	[214] = {sIcon = "knotsoffate_gildedmint"},
	[215] = {sIcon = "knotsoffate_stainedcopper"},
	[216] = {sIcon = "knotsoffate_crimsonjadevortex"},
	[217] = {sIcon = "knotsoffate_citrusinfusion"},
	[218] = {sIcon = "knotsoffate_gold"},
	[219] = {sIcon = "knotsoffate_rustediron", bTintable = true},
	[220] = {sIcon = "knotsoffate_flamingtapestry", bTrail = true},
	[221] = {sIcon = "knotsoffate_burnishedspice", bTrail = true},
	[222] = {sIcon = "knotsoffate_autumnentwined", bTrail = true},
	[223] = {sIcon = "knotsoffate_harmoniclilac", bTrail = true},
	[224] = {sIcon = "knotsoffate_gildedmint", bTrail = true},
	[225] = {sIcon = "knotsoffate_stainedcopper", bTrail = true},
	[226] = {sIcon = "knotsoffate_crimsonjadevortex", bTrail = true},
	[227] = {sIcon = "knotsoffate_citrusinfusion", bTrail = true},
	[228] = {sIcon = "knotsoffate_gold", bTrail = true},
	[229] = {sIcon = "knotsoffate_rustediron", bTrail = true, bTintable = true},
	[230] = {sIcon = "blood", bTrail = true},
	[231] = {sIcon = "blood", bTrail = true},
	[232] = {sIcon = "blood", bTrail = true},
	[233] = {sIcon = "blood", bTrail = true},
	[234] = {sIcon = "blood", bTrail = true},
	[235] = {sIcon = "blood_tintable", bTrail = true, bTintable = true},
	[236] = {sIcon = "blood_tintable", bTrail = true, bTintable = true},
	[237] = {sIcon = "blood_tintable", bTrail = true, bTintable = true},
	[238] = {sIcon = "blood_tintable", bTrail = true, bTintable = true},
	[239] = {sIcon = "blood_tintable", bTrail = true, bTintable = true},
	[240] = {sIcon = "clover", sBadge = "clover"},
	[241] = {sIcon = "clover", sBadge = "clover", bTrail = true},
	[242] = {sIcon = "clover", sBadge = "clover", bTrail = true},
	[243] = {sIcon = "clover", sBadge = "clover", bTrail = true},
	[244] = {sIcon = "clover_red", sBadge = "clover"},
	[245] = {sIcon = "star", sBadge = "star"},
	[246] = {sIcon = "star", sBadge = "star", bTrail = true},
	[247] = {sIcon = "star", sBadge = "star", bTrail = true},
	[248] = {sIcon = "star", sBadge = "star", bTrail = true},
	[249] = {sIcon = "star_orange", sBadge = "star"},
	[250] = {sIcon = "heart", sBadge = "heart"},
	[251] = {sIcon = "heart", sBadge = "heart", bTrail = true},
	[252] = {sIcon = "heart", sBadge = "heart", bTrail = true},
	[253] = {sIcon = "heart", sBadge = "heart", bTrail = true},
	[254] = {sIcon = "heart_purple", sBadge = "heart", bTrail = true},
	[255] = {sIcon = "skull", sBadge = "skull", bTrail = true},
	[256] = {sIcon = "skull", sBadge = "skull", bTrail = true},
	[257] = {sIcon = "skull", sBadge = "skull", bTrail = true},
	[258] = {sIcon = "skull", sBadge = "skull", bTrail = true},
	[259] = {sIcon = "skull", sBadge = "skull", bTrail = true},
};

local _tDiceSkinInfo = {};

function onInit()
	local tDiceSkins = Interface.getDiceSkins();
	for _,v in pairs(tDiceSkins) do
		local tData = _tDiceSkinAttributeInfo[v];
		if not tData or not tData.bDisabled then
			local tInfo = Interface.getDiceSkinInfo(v);
			if tData then
				for k,v in pairs(tData) do
					tInfo[k] = v;
				end
			end
			_tDiceSkinInfo[v] = tInfo;
		end
	end
end

function getAllDiceSkins()
	return _tDiceSkinInfo;
end
function isDiceSkinOwned(nID)
	if nID == 0 then
		return true;
	end
	if _tDiceSkinInfo[nID] then
		return _tDiceSkinInfo[nID].owned or false;
	end
	return false;
end
function isDiceSkinTintable(nID)
	if nID == 0 then
		return true;
	end
	if _tDiceSkinInfo[nID] then
		return _tDiceSkinInfo[nID].bTintable or false;
	end
	return true;
end

function getDiceSkinGroups()
	return _tDiceSkinGroups;
end
function getDiceSkinGroup(nID)
	return _tDiceSkinToGroupMap[nID] or DiceSkinManager.DEFAULT_DICESKIN_GROUP;
end

function getDiceSkinGroupName(nID)
	return Interface.getString("diceskin_group_" .. DiceSkinManager.getDiceSkinGroup(nID));
end
function getDiceSkinName(nID)
	local sName = Interface.getString("diceskin_" .. nID);
	if (sName or "") == "" then
		sName = string.format("%s (%d)", Interface.getString("diceskin_unknown"), nID);
	end
	return sName;
end

function getDiceSkinIcon(nID)
	if nID > 0 then
		local tInfo = _tDiceSkinInfo[nID];
		if tInfo and tInfo.sIcon then
			return "diceskin_icon_" .. tInfo.sIcon;
		elseif tInfo and tInfo.sElement then
			return "diceskin_icon_element_" .. tInfo.sElement;
		end
	end
	return "diceskin_icon_default";
end

--
--	COLOR WINDOW HANDLING
--

function populateDiceSelectWindow(w)
	local tDiceSkinGroupWindows = {};

	-- Create dice skin group windows
	local tDiceSkinGroups = DiceSkinManager.getDiceSkinGroups();
	for k,v in ipairs(tDiceSkinGroups) do
		local wDiceSkinGroup = w.sub_groups.subwindow.list.createWindow();
		wDiceSkinGroup.setData(k, v);
		tDiceSkinGroupWindows[v] = wDiceSkinGroup;
	end

	for nID, tInfo in pairs(DiceSkinManager.getAllDiceSkins()) do
		-- Get correct dice skin group window
		local sDiceSkinGroup = DiceSkinManager.getDiceSkinGroup(nID);
		local wDiceSkinGroup = tDiceSkinGroupWindows[sDiceSkinGroup];
		if not wDiceSkinGroup then
			wDiceSkinGroup = tDiceSkinGroupWindows[DiceSkinManager.DEFAULT_DICESKIN_GROUP];
		end

		-- Add dice skin list entry
		local wDiceSkin = wDiceSkinGroup.list.createWindow();
		wDiceSkin.setData(nID, tInfo);
		if wDiceSkin.isOwned() then
			wDiceSkinGroup.setOwned();
		end
	end

	local tDeleteSkinGroups = {};
	for _,wDiceSkinGroup in ipairs(w.sub_groups.subwindow.list.getWindows()) do
		if wDiceSkinGroup.list.isEmpty() then
			table.insert(tDeleteSkinGroups, wDiceSkinGroup);
		end
	end
	for _,wDiceSkinGroup in ipairs(tDeleteSkinGroups) do
		wDiceSkinGroup.close();
	end
end

function setupDiceSelectButton(cButton, nID)
	cButton.setIcons(DiceSkinManager.getDiceSkinIcon(nID));
	cButton.setTooltipText(DiceSkinManager.getDiceSkinName(nID));

	DiceSkinManager.setupButtonTintableWidget(cButton, nID);
	DiceSkinManager.setupButtonGeneralWidgets(cButton, nID)
end
function setupCustomButton(cButton, tColor)
	cButton.setIcons(DiceSkinManager.getDiceSkinIcon(tColor.diceskin));
	cButton.setTooltipText(DiceSkinManager.getDiceSkinName(tColor.diceskin));

	DiceSkinManager.setupButtonColorWidgets(cButton, tColor);
	DiceSkinManager.setupButtonGeneralWidgets(cButton, tColor.diceskin)
end

function setupButtonTintableWidget(cButton, nID)
	local tInfo = _tDiceSkinInfo[nID];

	-- Tintable
	if tInfo and tInfo.bTintable then
		cButton.addBitmapWidget({
			icon = "diceskin_attribute_tintable", position="topright",
			x = -(DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			y = (DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			w = DiceSkinManager.WIDGET_SIZE,
			h = DiceSkinManager.WIDGET_SIZE,
		});
	end
end
function setupButtonColorWidgets(cButton, tColor)
	local tInfo = _tDiceSkinInfo[tColor.diceskin];

	-- Tintable
	if tInfo and tInfo.bTintable then
		local tWidget = {
			icon = "colorgizmo_bigbtn_base", position="topright",
			x = -(DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			y = (DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			w = DiceSkinManager.WIDGET_SIZE,
			h = DiceSkinManager.WIDGET_SIZE,
		};

		tWidget.icon = "colorgizmo_bigbtn_base";
		cButton.addBitmapWidget(tWidget);

		tWidget.icon = "colorgizmo_bigbtn_color";
		tWidget.color = tColor.dicebodycolor;
		cButton.addBitmapWidget(tWidget);
		
		tWidget.icon = "colorgizmo_bigbtn_effects";
		tWidget.color = nil;
		cButton.addBitmapWidget(tWidget);

		tWidget.y = (DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE + DiceSkinManager.WIDGET_HALF_SIZE);

		tWidget.icon = "colorgizmo_bigbtn_base";
		cButton.addBitmapWidget(tWidget);

		tWidget.icon = "colorgizmo_bigbtn_color";
		tWidget.color = tColor.dicetextcolor;
		cButton.addBitmapWidget(tWidget);
		
		tWidget.icon = "colorgizmo_bigbtn_effects";
		tWidget.color = nil;
		cButton.addBitmapWidget(tWidget);
	end
end
function setupButtonGeneralWidgets(cButton, nID)
	local tInfo = _tDiceSkinInfo[nID];

	-- Element
	if tInfo and tInfo.sElement then
		cButton.addBitmapWidget({
			icon = "diceskin_element_" .. tInfo.sElement, position="bottomright",
			x = -(DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			y = -(DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE),
			w = DiceSkinManager.WIDGET_SIZE,
			h = DiceSkinManager.WIDGET_SIZE,
		});
	end
	
	-- Attributes
	if tInfo then
		local tWidget = {
			position="topleft", 
			x = DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE,
			y = DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_HALF_SIZE,
			w = DiceSkinManager.WIDGET_SIZE,
			h = DiceSkinManager.WIDGET_SIZE,
		};

		if tInfo.sBadge then
			tWidget.icon = "diceskin_badge_" .. tInfo.sBadge;
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end

		if tInfo.bAura then
			tWidget.icon = "diceskin_attribute_aura";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
		if tInfo.bAuraCast then
			tWidget.icon = "diceskin_attribute_auracast";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
		if tInfo.bForceField then
			tWidget.icon = "diceskin_attribute_forcefield";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
		if tInfo.bImpact then
			tWidget.icon = "diceskin_attribute_impact";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
		if tInfo.bTrail then
			tWidget.icon = "diceskin_attribute_trail";
			cButton.addBitmapWidget(tWidget);
			tWidget.y = tWidget.y + DiceSkinManager.WIDGET_PADDING + DiceSkinManager.WIDGET_SIZE;
		end
	end
end

function getDiceSkinGroupStoreID(sGroupID)
	return _tDiceSkinGroupStoreID[sGroupID] or sGroupID;
end
function onDiceSelectButtonActivate(nID)
	if DiceSkinManager.isDiceSkinOwned(nID) then
		UserManager.setDiceSkin(nID);
	else
		UtilityManager.sendToStoreDLC(DiceSkinManager.getDiceSkinGroupStoreID(DiceSkinManager.getDiceSkinGroup(nID)));
	end
end
function onDiceSelectButtonDrag(draginfo, nID)
	draginfo.setType("diceskin");
	draginfo.setIcon(DiceSkinManager.getDiceSkinIcon(nID));
	draginfo.setDescription(DiceSkinManager.getDiceSkinName(nID));

	local tDiceSkinData = { nID, UserManager.getDiceBodyColor(), UserManager.getDiceTextColor() };
	draginfo.setStringData(table.concat(tDiceSkinData, "|"));

	return true;
end
