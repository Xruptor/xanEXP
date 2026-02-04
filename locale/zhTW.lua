local ADDON_NAME, private = ...

local L = private:NewLocale("zhTW")
if not L then return end

L.SlashBG = "背景"
L.SlashBGOn = "xanEXP: 背景現在為 [|cFF99CC33顯示|r]"
L.SlashBGOff = "xanEXP: 背景現在為 [|cFF99CC33隱藏|r]"
L.SlashBGInfo = "顯示視窗背景。"

L.SlashReset = "重置"
L.SlashResetInfo = "重置視窗位置。"
L.SlashResetAlert = "xanEXP: 視窗位置已重置!"

L.SlashScale = "縮放"
L.SlashScaleSet = "xanEXP: 縮放比例設定為 [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "縮放無效！數字必須為 [0.5 - 5]。 (0.5, 1, 3, 4.6, 等..)"
L.SlashScaleInfo = "設定 xanEXP 視窗縮放比例 (0.5 - 5)。"
L.SlashScaleText = "xanEXP 視窗縮放"

L.Waiting = "等待..."
L.FormatDay = "天"
L.FormatHour = "時"
L.FormatMinute = "分"
L.FormatSecond = "秒"

L.TooltipDragInfo = "[按住 Shift 拖曳以移動視窗。]"
L.TooltipEXP = "經驗:"
L.TooltipRest = "休息:"
L.TooltipToNextLevel = "到下一級:"
L.TooltipXPPerSec = "經驗/秒:"
L.TooltipXPPerMinute = "經驗/分鐘:"
L.TooltipXPPerHour = "經驗/小時:"
L.TooltipTimeToLevel = "升級所需時間:"
L.TooltipTimeToLevelNone = "無"
L.TooltipSessionHoursPlayed = "本次已玩 %s 小時"
L.TooltipSessionExpGained = " 本次獲得經驗"
L.TooltipSessionLevelsGained = "本次提升了 %s 級"
