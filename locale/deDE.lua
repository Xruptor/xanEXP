local ADDON_NAME, private = ...

local L = private:NewLocale("deDE")
if not L then return end

L.SlashBG = "bg"
L.SlashBGOn = "xanEXP: Hintergrund ist jetzt [|cFF99CC33SICHTBAR|r]"
L.SlashBGOff = "xanEXP: Hintergrund ist jetzt [|cFF99CC33VERSTECKT|r]"
L.SlashBGInfo = "Fensterhintergrund anzeigen."

L.SlashReset = "reset"
L.SlashResetInfo = "Fensterposition zuruecksetzen."
L.SlashResetAlert = "xanEXP: Fensterposition wurde zurueckgesetzt!"

L.SlashScale = "scale"
L.SlashScaleSet = "xanEXP: Skalierung wurde auf [|cFF20ff20%s|r] gesetzt"
L.SlashScaleSetInvalid = "Skalierung ungueltig! Zahl muss zwischen [0.5 - 5] liegen. (0.5, 1, 3, 4.6, usw.)"
L.SlashScaleInfo = "Skalierung des xanEXP-Fensters einstellen (0.5 - 5)."
L.SlashScaleText = "xanEXP Fenster-Skalierung"

L.Waiting = "Warten..."
L.FormatDay = "T"
L.FormatHour = "h"
L.FormatMinute = "m"
L.FormatSecond = "s"

L.TooltipDragInfo = "[Shift gedrueckt halten und Fenster ziehen.]"
L.TooltipEXP = "EP:"
L.TooltipRest = "Erholung:"
L.TooltipToNextLevel = "Bis Level:"
L.TooltipXPPerSec = "EP/Sek:"
L.TooltipXPPerMinute = "EP/Min:"
L.TooltipXPPerHour = "EP/Std:"
L.TooltipTimeToLevel = "Zeit bis Level:"
L.TooltipTimeToLevelNone = "Keine"
L.TooltipSessionHoursPlayed = "%s Stunden in dieser Sitzung gespielt"
L.TooltipSessionExpGained = " EP in dieser Sitzung erhalten"
L.TooltipSessionLevelsGained = "%s Level in dieser Sitzung gewonnen"
