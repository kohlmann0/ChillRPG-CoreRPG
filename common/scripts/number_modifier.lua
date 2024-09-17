-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local emptymodifierWidget = nil;
local modifierWidget = nil;

function onInit()
	self.initWidgets();
	self.initModField();

	if super and super.onInit then
		super.onInit();
	end
end
function initWidgets()
	if modifiersize and (modifiersize[1] == "mini") then
		modifierWidget = addTextWidget({
			font = "sheettext", text = "0", position="topright", x = 3, y = 1, 
			frame = "tempmodmini", frameoffset = "3,1,6,3",
		});
		modifierWidget.setVisible(false);
	else
		modifierWidget = addTextWidget({ 
			font = "sheettext", text = "0", position="topright", 
			frame = "tempmodsmall", frameoffset = "6,3,8,5",
		});
		modifierWidget.setVisible(false);
	end
	
	emptymodifierWidget = addBitmapWidget({ icon = "tempmod", position = "topright" });
end
function initModField()
	if modifierfield then
		-- Use a <modifierfield> override
		self.setModifierFieldName(modifierfield[1]);
	else
		-- By default, the modifier is in a field named based on the parent control.
		self.setModifierFieldName(getName() .. "modifier");
	end
end

local _sModFieldName = nil;
function getModifierFieldName()
	return _sModFieldName;
end
-- NOTE: Only meant to be called a single time
function setModifierFieldName(s)
	if _sModFieldName then
		return;
	end

	_sModFieldName = s;
	if _sModFieldName then
		self.addSourceWithOp(_sModFieldName, "+");
		self.updateDisplay();
	end
end

function getModifier()
	local sModFieldName = self.getModifierFieldName();
	if not sModFieldName then
		return 0;
	end
	return DB.getValue(window.getDatabaseNode(), sModFieldName, 0);
end
function setModifier(nValue)
	local sModFieldName = self.getModifierFieldName();
	if sModFieldName then
		DB.setValue(window.getDatabaseNode(), sModFieldName, "number", nValue);
		self.updateDisplay();
	end
end

function onSourceValueUpdate(sSourceName)
	if sSourceName == self.getModifierFieldName() then
		self.updateDisplay();
	end
end

function updateDisplay()
	local nValue = self.getModifier();

	local sModFieldName = self.getModifierFieldName();

	modifierWidget.setText(string.format("%+d", nValue));
	
	if nValue == 0 then
		modifierWidget.setVisible(false);
		if showemptywidget then
			emptymodifierWidget.setVisible(true);
		else
			emptymodifierWidget.setVisible(false);
		end
	else
		modifierWidget.setVisible(true);
		emptymodifierWidget.setVisible(false);
	end
end

function onWheel(notches)
	if not Input.isControlPressed() then
		return false;
	end

	self.setModifier(self.getModifier() + notches);
	return true;
end
