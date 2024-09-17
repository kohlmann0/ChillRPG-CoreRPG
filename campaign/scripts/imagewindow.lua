-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local MIN_WIDTH = 200;
local MIN_HEIGHT = 200;
local SMALL_WIDTH = 500;
local SMALL_HEIGHT = 500;

local _bLastHasTokens = nil;

function onInit()
	self.updateImageDataDisplay();

	if self.isImagePanel() then
		registerMenuItem(Interface.getString("windowshare"), "windowshare", 7, 7);
	end

	self.onImageTokenCountChanged();

	ImageManager.registerImage(self.getImage());

	WindowManager.updateTooltip(self);
end
function onClose()
	ImageManager.unregisterImage(self.getImage());
end

function getImage()
	return image;
end
function isImagePanel()
	return UtilityManager.getTopWindow(self).isPanel();
end

function onLockChanged()
	if header and header.subwindow then
		header.subwindow.update();
	end
	self.updateImageDataDisplay();
end
function onIDChanged()
	WindowManager.updateTooltip(self);
	if header and header.subwindow then
		header.subwindow.update();
	end
end
function onNameUpdated()
	WindowManager.updateTooltip(self);
end

function onImageTokenCountChanged()
	if self.isImagePanel() then
		return;
	end

	local bHasTokens = image.hasTokens();
	if _bLastHasTokens ~= bHasTokens then
		if header and header.subwindow and header.subwindow.image_toolbar then
			header.subwindow.image_toolbar.setValue(bHasTokens and 1 or 0);
			_bLastHasTokens = bHasTokens;
		end
	end
end

function updateImageDataDisplay()
	imagedata.setVisible(Session.IsHost and not WindowManager.getLockedState(getDatabaseNode()));
end

local tButtonDown = {};
function onStartCameraDirection(sKey)
	tButtonDown[sKey] = true;
	self.refreshCameraDirection();
end
function onEndCameraDirection(sKey)
	tButtonDown[sKey] = nil;
	self.refreshCameraDirection();
end
function refreshCameraDirection()
	local cImage = self.getImage();
	local bFlatView = (cImage.getViewMode() == "");

	local nRotation = 0;
	if tButtonDown["rotateleft"] then
		nRotation = nRotation - 1;
	end
	if tButtonDown["rotateright"] then
		nRotation = nRotation + 1;
	end

	local tDirection = {0, 0, 0};
	if tButtonDown["right"] then
		tDirection[1] = tDirection[1] + 1;
	end
	if tButtonDown["left"] then
		tDirection[1] = tDirection[1] - 1;
	end
	if tButtonDown["forward"] then
		tDirection[2] = tDirection[2] + 1;
	end
	if tButtonDown["back"] then
		tDirection[2] = tDirection[2] - 1;
	end
	if tButtonDown["up"] then
		tDirection[3] = tDirection[3] + 1;
	end
	if tButtonDown["down"] then
		tDirection[3] = tDirection[3] - 1;
	end

	cImage.setCameraMovement(tDirection, nRotation);
end
