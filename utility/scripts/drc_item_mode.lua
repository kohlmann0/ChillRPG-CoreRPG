--
--  Please see the license.html file included with this distribution for
--  attribution and copyright information.
--

local _sDiceSkinKey
local _sMode;

local _bInitialized = false;
local _cCustom = nil;

local _bColorDialogShown = false;

function onClose()
	self.closeColorDialog();
end
function closeColorDialog()
	if _bColorDialogShown then
		Interface.dialogColorClose();
	end
end

function setData(sKey, sMode)
	_sDiceSkinKey = sKey;
	_sMode = sMode;

	local sName = Interface.getString("drc_label_mode_" .. _sMode);
	if (sName or "") == "" then
		sName = _sMode;
	end
	name.setValue(sName);

	self.updateCustomDisplay();

	_bInitialized = true;
end

function updateCustomDisplay()
	local tCustomColor = DiceRollManager.getDiceSkinKeyModeCustom(_sDiceSkinKey, _sMode);
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

function onCustomClickDown(button, x, y)
	return true;
end
function onCustomClickRelease(button, x, y)
	local tCustomColor = DiceRollManager.getDiceSkinKeyModeCustom(_sDiceSkinKey, _sMode);
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
	local tCustomColor = DiceRollManager.getDiceSkinKeyModeCustom(_sDiceSkinKey, _sMode);
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
	local tCustomColor = DiceRollManager.getDiceSkinKeyModeCustom(_sDiceSkinKey, _sMode);
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
	DiceRollManager.setDiceSkinKeyModeCustom(_sDiceSkinKey, _sMode, tDiceSkin);
	self.updateCustomDisplay();
	return true;
end
function onCustomClear()
	if not _bInitialized then
		return;
	end

	DiceRollManager.setDiceSkinKeyModeCustom(_sDiceSkinKey, _sMode, nil);
	self.updateCustomDisplay();
end
