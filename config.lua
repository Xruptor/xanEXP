local ADDON_NAME, addon = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent)
end
addon = _G[ADDON_NAME]

addon.configEvent = CreateFrame("frame", ADDON_NAME.."_config_eventFrame",UIParent)
local configEvent = addon.configEvent
configEvent:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

local L = LibStub("AceLocale-3.0"):GetLocale("xanEXP")
local chkBoxIndex = 1

function createCheckbutton(parentFrame, displayText)
	chkBoxIndex = chkBoxIndex + 1
	
	local checkbutton = CreateFrame("CheckButton", ADDON_NAME.."_config_chkbtn_" .. chkBoxIndex, parentFrame, "ChatConfigCheckButtonTemplate")
	getglobal(checkbutton:GetName() .. 'Text'):SetText(" "..displayText)
	
	return checkbutton
end

local yModifer = 30
local startY = -150
local currY = 0

local function addConfigEntry(objEntry)

	if currY == 0 then
		currY = startY
	else
		currY = currY - yModifer
	end
	
	objEntry:SetPoint("TOPLEFT", 20, currY)
end

local function LoadAboutFrame()

	--Code inspired from tekKonfigAboutPanel
	local about = CreateFrame("Frame", ADDON_NAME.."AboutPanel", InterfaceOptionsFramePanelContainer)
	about.name = ADDON_NAME
	about:Hide()
	
    local fields = {"Version", "Author"}
	local notes = GetAddOnMetadata(ADDON_NAME, "Notes")

    local title = about:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")

	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(ADDON_NAME)

	local subtitle = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetHeight(32)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("RIGHT", about, -32, 0)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(notes)

	local anchor
	for _,field in pairs(fields) do
		local val = GetAddOnMetadata(ADDON_NAME, field)
		if val then
			local title = about:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			title:SetWidth(75)
			if not anchor then title:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -8)
			else title:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6) end
			title:SetJustifyH("RIGHT")
			title:SetText(field:gsub("X%-", ""))

			local detail = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			detail:SetPoint("LEFT", title, "RIGHT", 4, 0)
			detail:SetPoint("RIGHT", -16, 0)
			detail:SetJustifyH("LEFT")
			detail:SetText(val)

			anchor = title
		end
	end
	
	InterfaceOptions_AddCategory(about)

	return about
end

function configEvent:PLAYER_LOGIN()
	
	addon.aboutPanel = LoadAboutFrame()
	
	addon.aboutPanel.btnBG = createCheckbutton(addon.aboutPanel, L.SlashBGInfo)
	addon.aboutPanel.btnBG:SetScript("OnShow", function() addon.aboutPanel.btnBG:SetChecked(XanEXP_DB.bgShown) end)
	addon.aboutPanel.btnBG.func = function()
		local value = addon.aboutPanel.btnBG:GetChecked()
		
		if not value then
			XanEXP_DB.bgShown = false
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashBGOff)
		else
			XanEXP_DB.bgShown = true
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashBGOn)
		end
		
		xanEXP:BackgroundToggle()
	end
	addon.aboutPanel.btnBG:SetScript("OnClick", addon.aboutPanel.btnBG.func)
	addConfigEntry(addon.aboutPanel.btnBG)


	configEvent:UnregisterEvent("PLAYER_LOGIN")
end

if IsLoggedIn() then configEvent:PLAYER_LOGIN() else configEvent:RegisterEvent("PLAYER_LOGIN") end