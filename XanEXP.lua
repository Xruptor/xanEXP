--Inspired by Author Tekkub and his mod PicoEXP

local ADDON_NAME, private = ...
if type(private) ~= "table" then
	private = {}
end

local BACKDROP_TEMPLATE = BackdropTemplateMixin and "BackdropTemplate"
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BACKDROP_TEMPLATE)
end
local addon = _G[ADDON_NAME]

addon.private = private
addon.L = (private and private.L) or addon.L or {}
local L = addon.L

local floor, ceil, fmod = math.floor, math.ceil, math.fmod
local format = string.format
local strlower = string.lower
local strmatch = string.match

local UnitXP = _G.UnitXP
local UnitXPMax = _G.UnitXPMax
local UnitLevel = _G.UnitLevel
local GetXPExhaustion = _G.GetXPExhaustion
local GetTime = _G.GetTime
local IsLoggedIn = _G.IsLoggedIn
local GetMaxPlayerLevel = _G.GetMaxPlayerLevel
local UIParent = _G.UIParent
local DEFAULT_CHAT_FRAME = _G.DEFAULT_CHAT_FRAME

local C_AddOns = _G.C_AddOns
local GetAddOnMetadata = _G.GetAddOnMetadata

local function GetAddonMetadata(field)
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		return C_AddOns.GetAddOnMetadata(ADDON_NAME, field)
	end
	if GetAddOnMetadata then
		return GetAddOnMetadata(ADDON_NAME, field)
	end
	return nil
end
addon.GetAddonMetadata = GetAddonMetadata

local BACKDROP = {
	bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 16,
	insets = { left = 5, right = 5, top = 5, bottom = 5 },
}

local function ApplyBackdrop(frame, enabled)
	if not frame or not frame.SetBackdrop then return end
	if enabled then
		frame:SetBackdrop(BACKDROP)
		frame:SetBackdropBorderColor(0.5, 0.5, 0.5)
		frame:SetBackdropColor(0.5, 0.5, 0.5, 0.6)
	else
		frame:SetBackdrop(nil)
	end
end

local function GetDB()
	if not XanEXP_DB then XanEXP_DB = {} end
	return XanEXP_DB
end

local function ApplyDefaults(db)
	if db.bgShown == nil then db.bgShown = true end
	if db.scale == nil then db.scale = 1 end
end

local function ClampScale(value)
	value = tonumber(value) or 1
	if value < 0.5 then return 0.5 end
	if value > 5 then return 5 end
	return value
end
addon.ClampScale = ClampScale

local function FormatTime(sTime)
	if type(sTime) ~= "number" or sTime <= 0 then
		return L.Waiting
	end

	local day = floor(sTime / 86400)
	local hour = floor((sTime - (day * 86400)) / 3600)
	local minute = floor((sTime - (day * 86400) - (hour * 3600)) / 60)
	local second = floor(fmod(sTime, 60))

	if day < 0 then
		return L.Waiting
	end

	local parts = {}
	if day > 0 then
		parts[#parts + 1] = day .. L.FormatDay
	end
	if hour > 0 or #parts > 0 then
		parts[#parts + 1] = hour .. L.FormatHour
	end
	if minute > 0 or #parts > 0 then
		parts[#parts + 1] = minute .. L.FormatMinute
	end
	if second > 0 or #parts > 0 then
		parts[#parts + 1] = second .. L.FormatSecond
	end
	return table.concat(parts, " ")
end

local session = {
	startXP = 0,
	maxXP = 0,
	startTime = 0,
	startLevel = 0,
}

local function InitSession()
	session.startXP = UnitXP("player")
	session.maxXP = UnitXPMax("player")
	session.startTime = GetTime()
	if session.maxXP > 0 then
		session.startLevel = UnitLevel("player") + (session.startXP / session.maxXP)
	else
		session.startLevel = UnitLevel("player")
	end
end

local function EnsureLayout(db, frame)
	db[frame] = db[frame] or {
		point = "CENTER",
		relativePoint = "CENTER",
		xOfs = 0,
		yOfs = 0,
	}
	return db[frame]
end

local function HandleSlashCommand(msg)
	local cmd, rest = strmatch(msg or "", "^(%S+)%s*(.-)$")
	if cmd then
		cmd = strlower(cmd)
		if cmd == strlower(L.SlashBG) then
			if addon.aboutPanel and addon.aboutPanel.btnBG then
				addon.aboutPanel.btnBG.func(true)
			end
			return
		elseif cmd == strlower(L.SlashReset) then
			if addon.aboutPanel and addon.aboutPanel.btnReset then
				addon.aboutPanel.btnReset.func()
			end
			return
		elseif cmd == strlower(L.SlashScale) then
			local value = tonumber(rest)
			if value and value >= 0.5 and value <= 5 then
				addon:SetAddonScale(value)
			else
				DEFAULT_CHAT_FRAME:AddMessage(L.SlashScaleSetInvalid)
			end
			return
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME, 64 / 255, 224 / 255, 208 / 255)
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp " .. L.SlashReset .. " - " .. L.SlashResetInfo)
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp " .. L.SlashBG .. " - " .. L.SlashBGInfo)
	DEFAULT_CHAT_FRAME:AddMessage("/xanexp " .. L.SlashScale .. " # - " .. L.SlashScaleInfo)
end

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local arg1 = ...
		if arg1 and arg1 == ADDON_NAME then
			self:UnregisterEvent("ADDON_LOADED")
			self:RegisterEvent("PLAYER_LOGIN")
		end
		return
	end
	if event == "PLAYER_LOGIN" then
		if IsLoggedIn() then
			self:EnableAddon(event, ...)
			self:UnregisterEvent("PLAYER_LOGIN")
		end
		return
	end
	local handler = self[event]
	if handler then
		return handler(self, event, ...)
	end
end)

local xanEXPTooltip = CreateFrame("GameTooltip", "xanEXPTooltip", UIParent, "GameTooltipTemplate")

----------------------
--      Enable      --
----------------------

function addon:EnableAddon()
	local db = GetDB()
	ApplyDefaults(db)
	self.db = db

	-- don't load the addon if we are at max level
	if GetMaxPlayerLevel and UnitLevel("player") >= GetMaxPlayerLevel() then return end

	self:CreateEXP_Frame()
	self:RestoreLayout(ADDON_NAME)

	InitSession()

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	self:PLAYER_XP_UPDATE()

	SLASH_XANEXP1 = "/xanexp"
	SlashCmdList["XANEXP"] = HandleSlashCommand

	if addon.configFrame then addon.configFrame:EnableConfig() end

	local ver = GetAddonMetadata("Version") or "1.0"
	DEFAULT_CHAT_FRAME:AddMessage(format("|cFF99CC33%s|r [v|cFF20ff20%s|r] loaded:   /xanexp", ADDON_NAME, ver))
end

function addon:CreateEXP_Frame()
	self:SetSize(61, 27)
	self:SetMovable(true)
	self:SetClampedToScreen(true)

	self:SetAddonScale(self.db and self.db.scale or 1, true)
	ApplyBackdrop(self, self.db and self.db.bgShown)

	self:EnableMouse(true)

	local t = self:CreateTexture("$parentIcon", "ARTWORK")
	t:SetTexture(894556)
	t:SetSize(16, 16)
	t:SetPoint("TOPLEFT", 5, -6)

	local g = self:CreateFontString("xanEXPText", "ARTWORK", "GameFontNormalSmall")
	g:SetJustifyH("LEFT")
	g:SetPoint("CENTER", 8, 0)
	g:SetText("?")
	self.text = g

	self:SetScript("OnMouseDown", function(frame)
		if IsShiftKeyDown() then
			frame.isMoving = true
			frame:StartMoving()
		end
	end)
	self:SetScript("OnMouseUp", function(frame)
		if frame.isMoving then
			frame.isMoving = nil
			frame:StopMovingOrSizing()
			self:SaveLayout(ADDON_NAME)
		end
	end)
	self:SetScript("OnLeave", function()
		xanEXPTooltip:Hide()
	end)

	self:SetScript("OnEnter", function(frame)
		xanEXPTooltip:SetOwner(frame, "ANCHOR_TOP")
		xanEXPTooltip:SetPoint(self:GetTipAnchor(frame))
		xanEXPTooltip:ClearLines()

		xanEXPTooltip:AddLine(ADDON_NAME)
		xanEXPTooltip:AddLine(L.TooltipDragInfo, 64 / 255, 224 / 255, 208 / 255)
		xanEXPTooltip:AddLine(" ")

		local cur = UnitXP("player")
		local maxXP = UnitXPMax("player")
		if maxXP <= 0 then
			xanEXPTooltip:Show()
			return
		end

		local restXP = GetXPExhaustion() or 0
		local toLevelXPPercent = floor((maxXP - cur) / maxXP * 100)

		local sessionTime = GetTime() - session.startTime
		local xpGainedSession = cur - session.startXP
		local xpPerSecond = sessionTime > 0 and ceil(xpGainedSession / sessionTime) or 0
		local xpPerMinute = xpPerSecond * 60
		local xpPerHour = xpPerSecond * 3600
		local timeToLevel = xpPerSecond > 0 and FormatTime((maxXP - cur) / xpPerSecond) or L.TooltipTimeToLevelNone

		xanEXPTooltip:AddDoubleLine(L.TooltipEXP, cur .. "/" .. maxXP, nil, nil, nil, 1, 1, 1)
		xanEXPTooltip:AddDoubleLine(L.TooltipRest, format("%d%%", (restXP / maxXP) * 100), nil, nil, nil, 1, 1, 1)
		xanEXPTooltip:AddDoubleLine(L.TooltipToNextLevel, (maxXP - cur) .. (" (" .. toLevelXPPercent .. "%)"), nil, nil, nil, 1, 1, 1)
		xanEXPTooltip:AddDoubleLine(L.TooltipXPPerSec, xpPerSecond, nil, nil, nil, 1, 1, 1)
		xanEXPTooltip:AddDoubleLine(L.TooltipXPPerMinute, xpPerMinute, nil, nil, nil, 1, 1, 1)
		xanEXPTooltip:AddDoubleLine(L.TooltipXPPerHour, xpPerHour, nil, nil, nil, 1, 1, 1)
		xanEXPTooltip:AddDoubleLine(L.TooltipTimeToLevel, timeToLevel, nil, nil, nil, 1, 1, 1)
		xanEXPTooltip:AddLine(format(L.TooltipSessionHoursPlayed, ceil(sessionTime / 3600)), 1, 1, 1)
		xanEXPTooltip:AddLine(xpGainedSession .. L.TooltipSessionExpGained, 1, 1, 1)
		local levelsGained = ceil(UnitLevel("player") + cur / maxXP - session.startLevel)
		xanEXPTooltip:AddLine(format(L.TooltipSessionLevelsGained, levelsGained), 1, 1, 1)

		xanEXPTooltip:Show()
	end)

	self:Show()
end

function addon:SetAddonScale(value, bypass)
	local db = self.db or GetDB()
	self.db = db

	value = ClampScale(value)
	db.scale = value

	if not bypass then
		DEFAULT_CHAT_FRAME:AddMessage(format(L.SlashScaleSet, value))
	end

	if self:GetScale() ~= value then
		self:SetScale(value)
	end
end

function addon:SaveLayout(frame)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	local db = self.db or GetDB()
	self.db = db

	local opt = EnsureLayout(db, frame)
	local point, _, relativePoint, xOfs, yOfs = _G[frame]:GetPoint()
	opt.point = point
	opt.relativePoint = relativePoint
	opt.xOfs = xOfs
	opt.yOfs = yOfs
end

function addon:RestoreLayout(frame)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	local db = self.db or GetDB()
	self.db = db

	local opt = EnsureLayout(db, frame)
	_G[frame]:ClearAllPoints()
	_G[frame]:SetPoint(opt.point, UIParent, opt.relativePoint, opt.xOfs, opt.yOfs)
end

function addon:BackgroundToggle()
	local db = self.db or GetDB()
	self.db = db
	ApplyBackdrop(self, db.bgShown)
end

------------------------------
--      Event Handlers      --
------------------------------

function addon:PLAYER_XP_UPDATE()
	local currentXP = UnitXP("player")
	local maxXP = UnitXPMax("player")
	if not self.text then return end
	if maxXP <= 0 then
		self.text:SetText("0%")
		return
	end
	self.text:SetText(format("%d%%", floor(currentXP / maxXP * 100)))
end

function addon:PLAYER_LEVEL_UP()
	session.startXP = session.startXP - session.maxXP
	session.maxXP = UnitXPMax("player")
end

------------------------
--      Tooltip!      --
------------------------

function addon:GetTipAnchor(frame)
	local x, y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local uiWidth = UIParent:GetWidth()
	local uiHeight = UIParent:GetHeight()
	local hhalf = (x > uiWidth * 2 / 3) and "RIGHT" or (x < uiWidth / 3) and "LEFT" or ""
	local vhalf = (y > uiHeight / 2) and "TOP" or "BOTTOM"
	return vhalf .. hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf
end
