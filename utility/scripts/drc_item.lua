--
--  Please see the license.html file included with this distribution for
--  attribution and copyright information.
--

local _sDiceSkinKey;
local _tDefaultColor = nil;

local _bInitialized = false;
local _cCustom = nil;
local _cDefault = nil;

local _bColorDialogShown = false;

function onClose()
	self.closeColorDialog();
end
function closeColorDialog()
	if _bColorDialogShown then
		Interface.dialogColorClose();
	end
end

function setData(sDiceSkinKey, tDiceSkinKey)
	_sDiceSkinKey = sDiceSkinKey;
	_tDefaultColor = DiceRollManager.resolveDiceSkinKeyDefault(_sDiceSkinKey);

	local sName = Interface.getString("drc_label_type_" .. _sDiceSkinKey);
	if (sName or "") == "" then
		local sTypeRef, sSubtypeRef = _sDiceSkinKey:match("^(%w+)%-type%-(.+)$");
		if sTypeRef and sSubtypeRef then
			local sType = Interface.getString("drc_label_type_" .. sTypeRef);
			local sSubtype = Interface.getString("drc_label_subtype_" .. sSubtypeRef);
			if (sSubtype or "") == "" then
				sSubtype = StringManager.capitalize(sSubtypeRef);
			end
			sName = string.format("%s: %s", sType, sSubtype);
		end
	end
	if (sName or "") == "" then
		sName = _sDiceSkinKey;
	end
	name.setValue(sName);
	if tDiceSkinKey.bSkipDefault then
		button_usedefault.setValue(0);
	else
		button_usedefault.setValue(1);
	end

	self.updateCustomDisplay();
	self.updateDefaultDisplay();
	self.updateModesDisplay();

	_bInitialized = true;
end

function updateCustomDisplay()
	local tCustomColor = DiceRollManager.getDiceSkinKeyCustom(_sDiceSkinKey);
	if tCustomColor then
		if _cCustom then
			_cCustom.destroy();
			_cCustom = nil;
		end
		_cCustom = createControl("button_drc_diceskin_custom", "custom_button");
		DiceSkinManager.setupCustomButton(_cCustom, tCustomColor);
		button_custom_clear.setVisible(true);
	else
		if _cCustom then
			_cCustom.destroy();
			_cCustom = nil;
		end
		button_custom_clear.setVisible(false);
		self.closeColorDialog();
	end
end
function updateDefaultDisplay()
	if _tDefaultColor then
		default.setVisible(true);
		button_usedefault.setVisible(true);

		if not _cDefault then
			_cDefault = createControl("button_drc_diceskin_default", "default_button");
			DiceSkinManager.setupCustomButton(_cDefault, _tDefaultColor);
		end 

		local sShadeColor;
		if DiceRollManager.getDiceSkinKeySkipDefault(_sDiceSkinKey) then
			sShadeColor = "E62B2B2B";
		else
			sShadeColor = "";
		end
		if _cDefault then
			_cDefault.setColor(sShadeColor);
		end
	else
		default.setVisible(false);
		button_usedefault.setVisible(false);
	end
end
function updateModesDisplay()
	list_modes.closeAll();

	local tAllowedModes = DiceRollManager.getDiceSkinKeyAllowedModes(_sDiceSkinKey);
	
	local bAvailable = (#(tAllowedModes or {}) > 0);
	button_modes_toggle.setVisible(bAvailable);

	local bShow = false;
	if bAvailable then
		bShow = (button_modes_toggle.getValue() == 1);
		if bShow then
			for _,sMode in ipairs(tAllowedModes) do
				local wMode = list_modes.createWindow();
				wMode.setData(_sDiceSkinKey, sMode);
			end
		end
	end

	list_modes.setVisible(bShow);
end

function onCustomClickDown(button, x, y)
	return true;
end
function onCustomClickRelease(button, x, y)
	local tCustomColor = DiceRollManager.getDiceSkinKeyCustom(_sDiceSkinKey);
	if not tCustomColor or not DiceSkinManager.isDiceSkinTintable(tCustomColor.diceskin) then
		return;
	end

	local nWidgetSize = DiceSkinManager.WIDGET_SIZE;
	local nWidgetPadding = DiceSkinManager.WIDGET_PADDING;
	local nWidgetClick = nWidgetSize + nWidgetPadding;
	if x >= 60 - nWidgetClick then
		if y <= nWidgetClick then
			self.closeColorDialog();
			_bColorDialogShown = Interface.dialogColor(self.onBodyColorDialogCallback, tCustomColor.dicebodycolor);
		elseif y <= (nWidgetClick + nWidgetSize) then
			self.closeColorDialog();
			_bColorDialogShown = Interface.dialogColor(self.onTextColorDialogCallback, tCustomColor.dicetextcolor);
		end
	end
end
function onBodyColorDialogCallback(sResult, sColor)
	if #sColor > 6 then
		sColor = sColor:sub(-6);
	end
	local tCustomColor = DiceRollManager.getDiceSkinKeyCustom(_sDiceSkinKey);
	if tCustomColor then
		tCustomColor.dicebodycolor = sColor;
		self.updateCustomDisplay();
	end
	if sResult == "ok" or sResult == "cancel" then
		_bColorDialogShown = false;
	end
end
function onTextColorDialogCallback(sResult, sColor)
	if #sColor > 6 then
		sColor = sColor:sub(-6);
	end
	local tCustomColor = DiceRollManager.getDiceSkinKeyCustom(_sDiceSkinKey);
	if tCustomColor then
		tCustomColor.dicetextcolor = sColor;
		self.updateCustomDisplay();
	end
	if sResult == "ok" or sResult == "cancel" then
		_bColorDialogShown = false;
	end
end

function onCustomDrop(draginfo)
	if not _bInitialized then
		return false;
	end
	if not draginfo.isType("diceskin") then
		return false;
	end

	local tDiceSkin = UserManager.convertDiceSkinStringToTable(draginfo.getStringData());
	DiceRollManager.setDiceSkinKeyCustom(_sDiceSkinKey, tDiceSkin);
	self.updateCustomDisplay();
	return true;
end
function onCustomClear()
	if not _bInitialized then
		return;
	end

	DiceRollManager.setDiceSkinKeyCustom(_sDiceSkinKey, nil);
	self.updateCustomDisplay();
end
function onUseDefaultChanged()
	if not _bInitialized then
		return;
	end
	
	DiceRollManager.setDiceSkinKeySkipDefault(_sDiceSkinKey, (button_usedefault.getValue() == 0));
	self.updateDefaultDisplay();
end

