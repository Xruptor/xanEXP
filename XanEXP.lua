--Inspired by Author Tekkub and his mod PicoEXP

local ADDON_NAME, addon = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BackdropTemplateMixin and "BackdropTemplate")
end
addon = _G[ADDON_NAME]

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

local start, max, starttime, startlevel

local debugf = tekDebug and tekDebug:GetFrame(ADDON_NAME)
local function Debug(...)
    if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end
end

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" or event == "PLAYER_LOGIN" then
		if event == "ADDON_LOADED" then
			local arg1 = ...
			if arg1 and arg1 == ADDON_NAME then
				self:UnregisterEvent("ADDON_LOADED")
				self:RegisterEvent("PLAYER_LOGIN")
			end
			return
		end
		if IsLoggedIn() then
			self:EnableAddon(event, ...)
			self:UnregisterEvent("PLAYER_LOGIN")
		end
		return
	end
	if self[event] then
		return self[event](self, event, ...)
	end
end)

local xanEXPTooltip = CreateFrame("GameTooltip", "xanEXPTooltip", UIParent, "GameTooltipTemplate")

----------------------
--      Enable      --
----------------------

function addon:EnableAddon()

	if not XanEXP_DB then XanEXP_DB = {} end
	if XanEXP_DB.bgShown == nil then XanEXP_DB.bgShown = true end
	if XanEXP_DB.scale == nil then XanEXP_DB.scale = 1 end

	--don'ty load the addon if we are at max level
	if UnitLevel("player") >= GetMaxPlayerLevel() then return end

	self:CreateEXP_Frame()
	self:RestoreLayout(ADDON_NAME)

	start, max, starttime = UnitXP("player"), UnitXPMax("player"), GetTime()
	startlevel = UnitLevel("player") + start/max

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	self:PLAYER_XP_UPDATE()

	SLASH_XANEXP1 = "/xanexp";
	SlashCmdList["XANEXP"] = xanEXP_SlashCommand;

	if addon.configFrame then addon.configFrame:EnableConfig() end

	local ver = GetAddOnMetadata(ADDON_NAME,"Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFF20ff20%s|r] loaded:   /xanexp", ADDON_NAME, ver or "1.0"))

end

function xanEXP_SlashCommand(cmd)

	local a,b,c=strfind(cmd, "(%S+)"); --contiguous string of non-space characters

	if a then
		if c and c:lower() == L.SlashBG then
			addon.aboutPanel.btnBG.func(true)
			return true
		elseif c and c:lower() == L.SlashReset then
			addon.aboutPanel.btnReset.func()
			return true
		elseif c and c:lower() == L.SlashScale then
			if b then
				local scalenum = strsub(cmd, b+2)
				if scalenum and scalenum ~= "" and tonumber(scalenum) and tonumber(scalenum) >= 0.5 and tonumber(scalenum) <= 5 then
					addon:SetAddonScale(tonumber(scalenum))
				else
					DEFAULT_CHAT_FRAME:AddMessage(L.SlashScaleSetInvalid)
				end
				return true
			end
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME, 64/255, 224/255, 208/255)
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp "..L.SlashReset.." - "..L.SlashResetInfo);
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp "..L.SlashBG.." - "..L.SlashBGInfo);
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp "..L.SlashScale.." # - "..L.SlashScaleInfo)
end

local function FormatTime(sTime)
	if type(sTime) == "number" and sTime > 0 then
        local day = floor(sTime / 86400)
		local hour = floor((sTime - (day * 86400)) / 3600)
		local minute = floor((sTime - (day * 86400) - (hour * 3600)) / 60)
		local second = floor(mod(sTime, 60))

		if day < 0 then
			return L.Waiting
		else
            local sString = ""
            if day > 0 then
               sString = day..L.FormatDay.." "
            end
            if hour > 0 or sString ~= "" then
               sString = sString..hour..L.FormatHour.." "
            end
            if minute > 0 or sString ~= "" then
               sString = sString..minute..L.FormatMinute.." "
            end
            if second > 0 or sString ~= "" then
               sString = sString..second..L.FormatSecond
            end
            return sString
		end
	else
		return L.Waiting
	end
end

function addon:CreateEXP_Frame()

	addon:SetWidth(61)
	addon:SetHeight(27)
	addon:SetMovable(true)
	addon:SetClampedToScreen(true)

	addon:SetAddonScale(XanEXP_DB.scale, true)

	if XanEXP_DB.bgShown then
		addon:SetBackdrop( {
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground";
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border";
			tile = true; tileSize = 32; edgeSize = 16;
			insets = { left = 5; right = 5; top = 5; bottom = 5; };
		} );
		addon:SetBackdropBorderColor(0.5, 0.5, 0.5);
		addon:SetBackdropColor(0.5, 0.5, 0.5, 0.6)
	else
		addon:SetBackdrop(nil)
	end

	addon:EnableMouse(true);

	local t = addon:CreateTexture("$parentIcon", "ARTWORK")
	t:SetTexture(894556)
	t:SetWidth(16)
	t:SetHeight(16)
	t:SetPoint("TOPLEFT",5,-6)

	local g = addon:CreateFontString("xanEXPText", "ARTWORK", "GameFontNormalSmall")
	g:SetJustifyH("LEFT")
	g:SetPoint("CENTER",8,0)
	g:SetText("?")

	addon:SetScript("OnMouseDown",function()
		if (IsShiftKeyDown()) then
			self.isMoving = true
			self:StartMoving();
	 	end
	end)
	addon:SetScript("OnMouseUp",function()
		if( self.isMoving ) then

			self.isMoving = nil
			self:StopMovingOrSizing()

			addon:SaveLayout(ADDON_NAME)

		end
	end)
	addon:SetScript("OnLeave",function()
		xanEXPTooltip:Hide()
	end)

	addon:SetScript("OnEnter",function()

		xanEXPTooltip:SetOwner(self, "ANCHOR_TOP")
		xanEXPTooltip:SetPoint(self:GetTipAnchor(addon))
		xanEXPTooltip:ClearLines()

		xanEXPTooltip:AddLine(ADDON_NAME)
		xanEXPTooltip:AddLine(L.TooltipDragInfo, 64/255, 224/255, 208/255)
		xanEXPTooltip:AddLine(" ")

		local cur = UnitXP("player")
		local maxXP = UnitXPMax("player")
		local restXP = GetXPExhaustion() or 0
		local remainXP = maxXP - (cur + restXP)
		local toLevelXPPercent = math.floor((maxXP - cur) / maxXP * 100)

        local sessionTime = GetTime() - starttime
		local xpGainedSession = (cur - start)
        local xpPerSecond = ceil(xpGainedSession / sessionTime)
		local xpPerMinute = ceil(xpPerSecond * 60)
        local xpPerHour = ceil(xpPerSecond * 3600)
        local timeToLevel
		if xpPerSecond <= 0 then
			timeToLevel = L.TooltipTimeToLevelNone
		else
			timeToLevel = (maxXP - cur) / xpPerSecond
		end
		xanEXPTooltip:AddDoubleLine(L.TooltipEXP, cur.."/"..max, nil,nil,nil, 1,1,1)
		xanEXPTooltip:AddDoubleLine(L.TooltipRest, string.format("%d%%", (GetXPExhaustion() or 0)/max*100), nil,nil,nil, 1,1,1)
		xanEXPTooltip:AddDoubleLine(L.TooltipToNextLevel, maxXP-cur..(" ("..toLevelXPPercent.."%)"), nil,nil,nil, 1,1,1)
		xanEXPTooltip:AddDoubleLine(L.TooltipXPPerSec, xpPerSecond, nil,nil,nil, 1,1,1)
		xanEXPTooltip:AddDoubleLine(L.TooltipXPPerMinute, xpPerMinute, nil,nil,nil, 1,1,1)
		xanEXPTooltip:AddDoubleLine(L.TooltipXPPerHour, xpPerHour, nil,nil,nil, 1,1,1)
		xanEXPTooltip:AddDoubleLine(L.TooltipTimeToLevel, FormatTime(timeToLevel), nil,nil,nil, 1,1,1)
		xanEXPTooltip:AddLine(string.format(L.TooltipSessionHoursPlayed, ceil(sessionTime/3600)), 1,1,1)
		xanEXPTooltip:AddLine(xpGainedSession..L.TooltipSessionExpGained, 1,1,1)
		xanEXPTooltip:AddLine(string.format(L.TooltipSessionLevelsGained, ceil(UnitLevel("player") + cur/max - startlevel)), 1,1,1)

		xanEXPTooltip:Show()
	end)


	addon:Show();
end

function addon:SetAddonScale(value, bypass)
	--fix this in case it's ever smaller than  
	if value < 0.5 then value = 0.5 end --anything smaller and it would vanish 
	if value > 5 then value = 5 end --WAY too big 

	XanEXP_DB.scale = value

	if not bypass then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(L.SlashScaleSet, value))
	end
	addon:SetScale(XanEXP_DB.scale)
end

function addon:SaveLayout(frame)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	if not XanEXP_DB then XanEXP_DB = {} end

	local opt = XanEXP_DB[frame] or nil

	if not opt then
		XanEXP_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = XanEXP_DB[frame]
		return
	end

	local point, relativeTo, relativePoint, xOfs, yOfs = _G[frame]:GetPoint()
	opt.point = point
	opt.relativePoint = relativePoint
	opt.xOfs = xOfs
	opt.yOfs = yOfs
end

function addon:RestoreLayout(frame)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	if not XanEXP_DB then XanEXP_DB = {} end

	local opt = XanEXP_DB[frame] or nil

	if not opt then
		XanEXP_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = XanEXP_DB[frame]
	end

	_G[frame]:ClearAllPoints()
	_G[frame]:SetPoint(opt.point, UIParent, opt.relativePoint, opt.xOfs, opt.yOfs)
end

function addon:BackgroundToggle()
	if XanEXP_DB.bgShown then
		addon:SetBackdrop( {
			bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground";
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border";
			tile = true; tileSize = 32; edgeSize = 16;
			insets = { left = 5; right = 5; top = 5; bottom = 5; };
		} );
		addon:SetBackdropBorderColor(0.5, 0.5, 0.5);
		addon:SetBackdropColor(0.5, 0.5, 0.5, 0.6)
	else
		addon:SetBackdrop(nil)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function addon:PLAYER_XP_UPDATE()
	local currentXP = UnitXP("player")
	local maxXP = UnitXPMax("player")
	local restXP = GetXPExhaustion() or 0
	local remainXP = maxXP - (currentXP + restXP)
	local toLevelXPPercent = math.floor((maxXP - currentXP) / maxXP * 100)

	--getglobal("xanEXPText"):SetText(string.format("%d%%", currentXP/maxXP*100).." TNL: "..toLevelXPPercent.."%")
	getglobal("xanEXPText"):SetText(string.format("%d%%", currentXP/maxXP*100))
end

function addon:PLAYER_LEVEL_UP()
	start = start - max
	max = UnitXPMax("player")
end

------------------------
--      Tooltip!      --
------------------------

function addon:GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end
