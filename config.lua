local ADDON_NAME, private = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BackdropTemplateMixin and "BackdropTemplate")
end
local addon = _G[ADDON_NAME]

addon.private = private
addon.L = (private and private.L) or addon.L or {}
local L = addon.L

addon.configFrame = CreateFrame("frame", ADDON_NAME .. "_config_eventFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
local configFrame = addon.configFrame

local lastObject
local function addConfigEntry(objEntry, adjustX, adjustY)
	objEntry:ClearAllPoints()

	if not lastObject then
		objEntry:SetPoint("TOPLEFT", 20, -150)
	else
		objEntry:SetPoint("LEFT", lastObject, "BOTTOMLEFT", adjustX or 0, adjustY or -30)
	end

	lastObject = objEntry
end

local chkBoxIndex = 0
local function createCheckbutton(parentFrame, displayText)
	chkBoxIndex = chkBoxIndex + 1

	local checkbutton = CreateFrame("CheckButton", ADDON_NAME .. "_config_chkbtn_" .. chkBoxIndex, parentFrame, "ChatConfigCheckButtonTemplate")
	local text = _G[checkbutton:GetName() .. "Text"]
	if text then
		text:SetText(" " .. displayText)
	end

	return checkbutton
end

local buttonIndex = 0
local function createButton(parentFrame, displayText)
	buttonIndex = buttonIndex + 1

	local button = CreateFrame("Button", ADDON_NAME .. "_config_button_" .. buttonIndex, parentFrame, "UIPanelButtonTemplate")
	button:SetText(displayText)
	button:SetHeight(30)
	button:SetWidth(button:GetTextWidth() + 30)

	return button
end

local sliderIndex = 0
local function createSlider(parentFrame, displayText, minVal, maxVal, setStep)
	sliderIndex = sliderIndex + 1

	local sliderBackdrop = {
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		tile = true,
		tileSize = 8,
		edgeSize = 8,
		insets = { left = 3, right = 3, top = 6, bottom = 6 },
	}

	local slider = CreateFrame("Slider", ADDON_NAME .. "_config_slider_" .. sliderIndex, parentFrame, BackdropTemplateMixin and "BackdropTemplate")
	slider:SetOrientation("HORIZONTAL")
	slider:SetHeight(15)
	slider:SetWidth(300)
	slider:SetHitRectInsets(0, 0, -10, 0)
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	slider:SetMinMaxValues(minVal or 0.5, maxVal or 5)
	slider:SetValue(minVal or 0.5)
	slider:SetBackdrop(sliderBackdrop)
	slider:SetValueStep(setStep or 1)

	local label = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("CENTER", slider, "CENTER", 0, 16)
	label:SetJustifyH("CENTER")
	label:SetHeight(15)
	label:SetText(displayText)

	local lowtext = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	lowtext:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 2, 3)
	lowtext:SetText(minVal)

	local hightext = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	hightext:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", -2, 3)
	hightext:SetText(maxVal)

	local currVal = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	currVal:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 45, 12)
	currVal:SetText("(?)")
	slider.currVal = currVal

	return slider
end

local function LoadAboutFrame()
	-- Code inspired from tekKonfigAboutPanel
	local parent = _G.InterfaceOptionsFramePanelContainer or _G.SettingsPanel or UIParent
	local about = CreateFrame("Frame", ADDON_NAME .. "AboutPanel", parent, BackdropTemplateMixin and "BackdropTemplate")
	about.name = ADDON_NAME
	about:Hide()

	local fields = { "Version", "Author" }
	local notes = (addon.GetAddonMetadata and addon.GetAddonMetadata("Notes")) or ""

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
	for _, field in pairs(fields) do
		local val = (addon.GetAddonMetadata and addon.GetAddonMetadata(field)) or nil
		if val then
			local titleField = about:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			titleField:SetWidth(75)
			if not anchor then
				titleField:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -8)
			else
				titleField:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6)
			end
			titleField:SetJustifyH("RIGHT")
			titleField:SetText(field:gsub("X%-", ""))

			local detail = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			detail:SetPoint("LEFT", titleField, "RIGHT", 4, 0)
			detail:SetPoint("RIGHT", -16, 0)
			detail:SetJustifyH("LEFT")
			detail:SetText(val)

			anchor = titleField
		end
	end

	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(about)
	else
		local category, layout = _G.Settings.RegisterCanvasLayoutCategory(about, about.name)
		_G.Settings.RegisterAddOnCategory(category)
		addon.settingsCategory = category
	end

	return about
end

local function NormalizeScale(value)
	value = addon.ClampScale and addon.ClampScale(value) or tonumber(value) or 1
	return math.floor(value * 10 + 0.5) / 10
end

function configFrame:EnableConfig()
	lastObject = nil
	addon.aboutPanel = LoadAboutFrame()

	local db = addon.db or _G.XanEXP_DB or {}
	addon.db = db

	-- bg shown
	local btnBG = createCheckbutton(addon.aboutPanel, L.SlashBGInfo)
	btnBG:SetScript("OnShow", function()
		btnBG:SetChecked(db.bgShown)
	end)
	btnBG.func = function()
		db.bgShown = not db.bgShown
		if db.bgShown then
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashBGOn)
		else
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashBGOff)
		end
		addon:BackgroundToggle()
	end
	btnBG:SetScript("OnClick", btnBG.func)

	addConfigEntry(btnBG, 0, -20)
	addon.aboutPanel.btnBG = btnBG

	-- reset
	local btnReset = createButton(addon.aboutPanel, L.SlashResetInfo)
	btnReset.func = function()
		DEFAULT_CHAT_FRAME:AddMessage(L.SlashResetAlert)
		addon:ClearAllPoints()
		addon:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
	btnReset:SetScript("OnClick", btnReset.func)

	addConfigEntry(btnReset, 0, -30)
	addon.aboutPanel.btnReset = btnReset

	-- scale
	local sliderScale = createSlider(addon.aboutPanel, L.SlashScaleText, 0.5, 5, 0.1)
	sliderScale:SetScript("OnShow", function()
		local value = NormalizeScale(db.scale or 1)
		sliderScale:SetValue(value)
		sliderScale.currVal:SetText("(" .. value .. ")")
	end)
	local function UpdateSliderText(value)
		local normalized = NormalizeScale(value)
		sliderScale.currVal:SetText("(" .. normalized .. ")")
		return normalized
	end
	sliderScale:SetScript("OnValueChanged", function(self, value)
		UpdateSliderText(value)
	end)
	sliderScale:SetScript("OnMouseUp", function(self)
		local value = UpdateSliderText(self:GetValue())
		addon:SetAddonScale(value)
	end)

	addConfigEntry(sliderScale, 0, -40)
	addon.aboutPanel.sliderScale = sliderScale
end
