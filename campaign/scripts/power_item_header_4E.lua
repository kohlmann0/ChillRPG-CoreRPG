-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	self.onRechargeChanged();
end

function onUsedChanged()
	parentcontrol.window.windowlist.onUsedChanged();
end
function onRechargeChanged()
	local sRecharge = DB.getValue(getDatabaseNode(), "recharge", ""):lower():sub(1,2);
	if sRecharge == "da" or sRecharge == "re" then -- 13A (re)
		name.setColor("FFFFFF");
		name.setFrame("headerpowerdaily", 8, 0, 8, 1)
	elseif sRecharge == "en" or sRecharge == "ba" or sRecharge == "ac" then  -- 4E (en/ac) / 13A (ba/ac)
		name.setColor("FFFFFF");
		name.setFrame("headerpowerenc", 8, 0, 8, 1)
	elseif sRecharge == "at" then
		name.setColor("FFFFFF");
		name.setFrame("headerpoweratwill", 8, 0, 8, 1)
	else
		name.setColor("000000");
		name.setFrame("tempmodsmall", 8, 1, 8, 2);
	end
end
