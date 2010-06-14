--Inspired by Author Tekkub and his mod PicoEXP

local start, max, starttime, startlevel

local f = CreateFrame("frame","XanEXP",UIParent)
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

----------------------
--      Enable      --
----------------------

function f:PLAYER_LOGIN()

	if not XanEXP_DB then XanEXP_DB = {} end
	if XanEXP_DB.bgShown == nil then XanEXP_DB.bgShown = 1 end
	if XanEXP_DB.scale == nil then XanEXP_DB.scale = 1 end
	
	self:CreateEXPFrame()
	self:RestoreLayout("XanEXP")

	start, max, starttime = UnitXP("player"), UnitXPMax("player"), GetTime()
	startlevel = UnitLevel("player") + start/max

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	self:PLAYER_XP_UPDATE()

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
	
	SLASH_XANEXP1 = "/xanexp";
	SlashCmdList["XANEXP"] = XANEXP_SlashCommand;
	
	local ver = GetAddOnMetadata("XanEXP","Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFFDF2B2B%s|r] Loaded", "XanEXP", ver or "1.0"))
end

function XANEXP_SlashCommand(cmd)

	local a,b,c=strfind(cmd, "(%S+)"); --contiguous string of non-space characters
	
	if a then
		if c and c:lower() == "bg" then
			XanEXP:BackgroundToggle()
			return true
		elseif c and c:lower() == "reset" then
			DEFAULT_CHAT_FRAME:AddMessage("XanEXP: Frame position has been reset!");
			XanEXP:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
			return true
		elseif c and c:lower() == "scale" then
			if b then
				local scalenum = strsub(cmd, b+2)
				if scalenum and scalenum ~= "" and tonumber(scalenum) then
					XanEXP_DB.scale = tonumber(scalenum)
					XanEXP:SetScale(tonumber(scalenum))
					DEFAULT_CHAT_FRAME:AddMessage("XanEXP: scale has been set to ["..tonumber(scalenum).."]")
					return true
				end
			end
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage("XanEXP");
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp reset - resets the frame position");
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp bg - toggles the background on/off");
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp scale # - Set the scale of the XanEXP frame")
end

function f:CreateEXPFrame()

	f:SetWidth(61)
	f:SetHeight(27)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	
	f:SetScale(XanEXP_DB.scale)
	
	if XanEXP_DB.bgShown == 1 then
		f:SetBackdrop( {
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground";
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border";
			tile = true; tileSize = 32; edgeSize = 16;
			insets = { left = 5; right = 5; top = 5; bottom = 5; };
		} );
		f:SetBackdropBorderColor(0.5, 0.5, 0.5);
		f:SetBackdropColor(0.5, 0.5, 0.5, 0.6)
	else
		f:SetBackdrop(nil)
	end
	
	f:EnableMouse(true);
	
	local t = f:CreateTexture("$parentIcon", "ARTWORK")
	t:SetTexture("Interface\\AddOns\\XanEXP\\icon")
	t:SetWidth(16)
	t:SetHeight(16)
	t:SetPoint("TOPLEFT",5,-6)

	local g = f:CreateFontString("$parentText", "ARTWORK", "GameFontNormalSmall")
	g:SetJustifyH("LEFT")
	g:SetPoint("CENTER",8,0)
	g:SetText("lala")

	f:SetScript("OnMouseDown",function()
		if (IsShiftKeyDown()) then
			self.isMoving = true
			self:StartMoving();
	 	end
	end)
	f:SetScript("OnMouseUp",function()
		if( self.isMoving ) then

			self.isMoving = nil
			self:StopMovingOrSizing()

			f:SaveLayout(self:GetName());

		end
	end)
	f:SetScript("OnLeave",function()
		GameTooltip:Hide()
	end)

	f:SetScript("OnEnter",function()
	
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(self:GetTipAnchor(self))
		GameTooltip:ClearLines()

		GameTooltip:AddLine("XanEXP")

		local cur = UnitXP("player")
		local maxXP = UnitXPMax("player")
		local restXP = GetXPExhaustion() or 0
		local remainXP = maxXP - (cur + restXP)
		local toLevelXPPercent = math.floor((maxXP - cur) / maxXP * 100)
		
		GameTooltip:AddDoubleLine("EXP:", cur.."/"..max, nil,nil,nil, 1,1,1)
		GameTooltip:AddDoubleLine("Rest:", string.format("%d%%", (GetXPExhaustion() or 0)/max*100), nil,nil,nil, 1,1,1)
		GameTooltip:AddDoubleLine("TNL:", maxXP-cur..(" ("..toLevelXPPercent.."%)"), nil,nil,nil, 1,1,1)
		GameTooltip:AddLine(string.format("%.1f hours played this session", (GetTime()-starttime)/3600), 1,1,1)
		GameTooltip:AddLine((cur - start).." EXP gained this session", 1,1,1)
		GameTooltip:AddLine(string.format("%.1f levels gained this session", UnitLevel("player") + cur/max - startlevel), 1,1,1)

		GameTooltip:Show()
	end)
	
	
	f:Show();
end

function f:SaveLayout(frame)

	if not XanEXP_DB then XanEXP_DB = {} end

	local opt = XanEXP_DB[frame] or nil;

	if opt == nil then
		XanEXP_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = XanEXP_DB[frame];
	end

	local f = getglobal(frame);
	local scale = f:GetEffectiveScale();
	opt.PosX = f:GetLeft() * scale;
	opt.PosY = f:GetTop() * scale;
	--opt.Width = f:GetWidth();
	--opt.Height = f:GetHeight();

end

function f:RestoreLayout(frame)

	if not XanEXP_DB then XanEXP_DB = {} end	

	local f = getglobal(frame);
	local opt = XanEXP_DB[frame] or nil;

	if opt == nil then
		XanEXP_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = XanEXP_DB[frame];
	end

	local x = opt.PosX;
	local y = opt.PosY;
	local s = f:GetEffectiveScale();

	    if not x or not y then
		f:ClearAllPoints();
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
		return 
	    end

	--calculate the scale
	x,y = x/s,y/s;

	--set the location
	f:ClearAllPoints();
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y);

end

function f:BackgroundToggle()
	if not XanEXP_DB then XanEXP_DB = {} end
	if XanEXP_DB.bgShown == nil then XanEXP_DB.bgShown = 1 end
	
	if XanEXP_DB.bgShown == 0 then
		XanEXP_DB.bgShown = 1;
		DEFAULT_CHAT_FRAME:AddMessage("XanEXP: Background Shown");
	elseif XanEXP_DB.bgShown == 1 then
		XanEXP_DB.bgShown = 0;
		DEFAULT_CHAT_FRAME:AddMessage("XanEXP: Background Hidden");
	else
		XanEXP_DB.bgShown = 1
		DEFAULT_CHAT_FRAME:AddMessage("XanEXP: Background Shown");
	end

	--now change background
	if XanEXP_DB.bgShown == 1 then
		f:SetBackdrop( {
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground";
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border";
			tile = true; tileSize = 32; edgeSize = 16;
			insets = { left = 5; right = 5; top = 5; bottom = 5; };
		} );
		f:SetBackdropBorderColor(0.5, 0.5, 0.5);
		f:SetBackdropColor(0.5, 0.5, 0.5, 0.6)
	else
		f:SetBackdrop(nil)
	end
	
end

------------------------------
--      Event Handlers      --
------------------------------

function f:PLAYER_XP_UPDATE()
	local currentXP = UnitXP("player")
	local maxXP = UnitXPMax("player")
	local restXP = GetXPExhaustion() or 0
	local remainXP = maxXP - (currentXP + restXP)
	local toLevelXPPercent = math.floor((maxXP - currentXP) / maxXP * 100)
	
	--getglobal("XanEXPText"):SetText(string.format("%d%%", currentXP/maxXP*100).." TNL: "..toLevelXPPercent.."%")
	getglobal("XanEXPText"):SetText(string.format("%d%%", currentXP/maxXP*100))
end

function f:PLAYER_LEVEL_UP()
	start = start - max
	max = UnitXPMax("player")
end

------------------------
--      Tooltip!      --
------------------------

function f:GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end

if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
