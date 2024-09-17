-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local DEFAULT_SIZE_WIDGET = 25;
local DEFAULT_SIZE_PADDING = 5;

function onInit()
	if widgetsize then
		self.setWidgetSize(tonumber(widgetsize[1]) or DEFAULT_SIZE_WIDGET);
	end

	self.updateDisplay();

	local nodeActor = window.getDatabaseNode();
	DB.addHandler(DB.getPath(nodeActor, "token"), "onUpdate", self.updateDisplay);
	DB.addHandler(DB.getPath(nodeActor, "token3Dflat"), "onUpdate", self.updateDisplay);
end
function onClose()
	local nodeActor = window.getDatabaseNode();
	DB.removeHandler(DB.getPath(nodeActor, "token"), "onUpdate", self.updateDisplay);
	DB.removeHandler(DB.getPath(nodeActor, "token3Dflat"), "onUpdate", self.updateDisplay);
end

local _nWidgetSize = DEFAULT_SIZE_WIDGET;
function setWidgetSize(n)
	_nWidgetSize = n;
end
function getWidgetSize()
	return _nWidgetSize;
end

local _nPadding = DEFAULT_SIZE_PADDING;
function getPadding()
	return _nPadding;
end

function updateDisplay()
	local nWidgetSize = self.getWidgetSize();
	local nHalfWidget = ((nWidgetSize / 2) + (nWidgetSize % 2));
	local nPadding = self.getPadding();

	local nodeActor = window.getDatabaseNode();

	local widgetToken = findWidget("token");
	local sToken = DB.getValue(nodeActor, "token", "");
	if (sToken or "") ~= "" then
		if not widgetToken then
			widgetToken = addBitmapWidget({
				name = "token", 
				asset = sToken, 
				position = "topleft", x = nHalfWidget, y = nHalfWidget, 
				w = nWidgetSize, h = nWidgetSize,
			});
		else
			widgetToken.setAsset(sToken);
		end
	else
		if widgetToken then
			widgetToken.destroy();
			widgetToken = nil;
		end
	end

	local widgetToken3DFlat = findWidget("token3dflat");
	local s3DToken = DB.getValue(nodeActor, "token3Dflat", "");
	if ((s3DToken or "") ~= "") then
		if not widgetToken3DFlat then
			widgetToken3DFlat = addBitmapWidget({
				name = "token3dflat", 
				asset = s3DToken, 
				position = "topleft", x = nWidgetSize + nPadding + nHalfWidget, y = nHalfWidget, 
				w = nWidgetSize, h = nWidgetSize,
			});
		else
			widgetToken3DFlat.setAsset(s3DToken);
		end
	else
		if widgetToken3DFlat then
			widgetToken3DFlat.destroy();
			widgetToken3DFlat = nil;
		end
	end

	if widgetToken and widgetToken3DFlat then
		setAnchoredWidth(nWidgetSize + nPadding + nWidgetSize);
	else
		setAnchoredWidth(nWidgetSize);
	end

	local widgetEmpty = findWidget("empty");
	if not widgetToken and not widgetToken3DFlat then
		if not widgetEmpty then
			addBitmapWidget({ 
				name = "empty", 
				icon = "token_empty", 
				position = "topleft", x = nHalfWidget, y = nHalfWidget, 
				w = nWidgetSize, h = nWidgetSize,
				});
		end
	else
		if widgetEmpty then
			widgetEmpty.destroy();
			widgetEmpty = nil;
		end
	end
end

function onClickDown(button, x, y)
	return true;
end
function onClickRelease(button, x, y)
	return RecordAssetManager.handlePicturePressed(window.getDatabaseNode());
end
function onDragStart(button, x, y, draginfo)
	return RecordAssetManager.handlePictureDragStart(window.getDatabaseNode(), draginfo);
end
function onDrop(x, y, draginfo)
	return RecordAssetManager.handlePictureDrop(window.getDatabaseNode(), draginfo);
end
