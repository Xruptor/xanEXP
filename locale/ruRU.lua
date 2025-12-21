local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "ruRU")
if not L then return end
-- Translator ZamestoTV
L.SlashBG = "bg"
L.SlashBGOn = "xanEXP: Фон теперь [|cFF99CC33ПОКАЗАН|r]"
L.SlashBGOff = "xanEXP: Фон теперь [|cFF99CC33СКРЫТ|r]"
L.SlashBGInfo = "Показывать фон окна."

L.SlashReset = "reset"
L.SlashResetInfo = "Сбросить позицию окна."
L.SlashResetAlert = "xanEXP: Позиция окна сброшена!"

L.SlashScale = "scale"
L.SlashScaleSet = "xanEXP: масштаб установлен на [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "Неверный масштаб! Число должно быть от [0.5 - 5]. (0.5, 1, 3, 4.6 и т.д.)"
L.SlashScaleInfo = "Установить масштаб окон лута LootRollMover (0.5 - 5)."
L.SlashScaleText = "Масштаб окна xanEXP"

L.Waiting = "Ожидание..."
L.FormatDay = "д"
L.FormatHour = "ч"
L.FormatMinute = "м"
L.FormatSecond = "с"

L.TooltipDragInfo = "[Зажмите Shift и перетащите, чтобы перемещать окно.]"
L.TooltipEXP = "ОПЫТ:"
L.TooltipRest = "Отдых:"
L.TooltipToNextLevel = "До уровня:"
L.TooltipXPPerSec = "ОПЫТ/сек:"
L.TooltipXPPerMinute = "ОПЫТ/мин:"
L.TooltipXPPerHour = "ОПЫТ/час:"
L.TooltipTimeToLevel = "Время до уровня:"
L.TooltipTimeToLevelNone = "Нет"
L.TooltipSessionHoursPlayed = "%s часов сыграно в этой сессии"
L.TooltipSessionExpGained = " опыта получено в этой сессии"
L.TooltipSessionLevelsGained = "%s уровней получено в этой сессии"
