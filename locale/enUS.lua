local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true)
if not L then return end

--for non-english fonts
--https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml

--Get the best possible font for the localization langugage.
--Some fonts are better than others to display special character sets.
L.GetFontType = "Fonts\\FRIZQT__.TTF"

L.SlashBG = "bg"
L.SlashBGOn = "xanEXP: Background is now [|cFF99CC33SHOWN|r]"
L.SlashBGOff = "xanEXP: Background is now [|cFF99CC33HIDDEN|r]"
L.SlashBGInfo = "Show the window background."

L.SlashReset = "reset"
L.SlashResetInfo = "Reset frame position."
L.SlashResetAlert = "xanEXP: Frame position has been reset!"

L.SlashScale = "scale"
L.SlashScaleOn = "xanTooltipHoudini: Quest toolips are now [|cFF99CC33ON|r]"
L.SlashScaleOff = "xanTooltipHoudini: Quest toolips are now [|cFF99CC33OFF|r]"
L.SlashScaleInfo = "Allow quest tooltips to be displayed during combat."

L.Waiting = "Waiting..."
L.FormatDay = "d"
L.FormatHour = "h"
L.FormatMinute = "m"
L.FormatSecond = "s"

L.TooltipDragInfo = "[Hold Shift and Drag to move window.]"
L.TooltipEXP = "EXP:"
L.TooltipRest = "Rest:"
L.TooltipToNextLevel = "TNL:"
L.TooltipXPPerSec = "XP/Sec:"
L.TooltipXPPerMinute = "XP/Minute:"
L.TooltipXPPerHour = "XP/Hour:"
L.TooltipTimeToLevel = "Time To Level:"
L.TooltipTimeToLevelNone = "None"
L.TooltipSessionHoursPlayed = "%s hours played this session"
L.TooltipSessionExpGained = " EXP gained this session"
L.TooltipSessionLevelsGained = "%s levels gained this session"
