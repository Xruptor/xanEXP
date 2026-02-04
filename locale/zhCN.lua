local ADDON_NAME, private = ...

local L = private:NewLocale("zhCN")
if not L then return end

L.SlashBG = "背景"
L.SlashBGOn = "xanEXP: 背景现在是 [|cFF99CC33显示|r]"
L.SlashBGOff = "xanEXP: 背景现在是 [|cFF99CC33隐藏|r]"
L.SlashBGInfo = "显示窗口背景。"

L.SlashReset = "重置"
L.SlashResetInfo = "重置窗口位置。"
L.SlashResetAlert = "xanEXP: 窗口位置已重置!"

L.SlashScale = "缩放"
L.SlashScaleSet = "xanEXP: 缩放比例设置为 [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "缩放无效！数字必须为 [0.5 - 5]。 (0.5, 1, 3, 4.6, 等..)"
L.SlashScaleInfo = "设置 xanEXP 窗口缩放比例 (0.5 - 5)。"
L.SlashScaleText = "xanEXP 窗口缩放"

L.Waiting = "等待..."
L.FormatDay = "天"
L.FormatHour = "时"
L.FormatMinute = "分"
L.FormatSecond = "秒"

L.TooltipDragInfo = "[按住 Shift 拖动以移动窗口。]"
L.TooltipEXP = "经验:"
L.TooltipRest = "休息:"
L.TooltipToNextLevel = "到下一级:"
L.TooltipXPPerSec = "经验/秒:"
L.TooltipXPPerMinute = "经验/分钟:"
L.TooltipXPPerHour = "经验/小时:"
L.TooltipTimeToLevel = "升级所需时间:"
L.TooltipTimeToLevelNone = "无"
L.TooltipSessionHoursPlayed = "本次已玩 %s 小时"
L.TooltipSessionExpGained = " 本次获得经验"
L.TooltipSessionLevelsGained = "本次提升了 %s 级"
