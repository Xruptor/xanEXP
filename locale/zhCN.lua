local ADDON_NAME, addon = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhCN")
if not L then return end

L.SlashBG = "背景"
L.SlashBGOn = "xanEXP: 背景现在是 [|cFF99CC33显示|r]"
L.SlashBGOff = "xanEXP: 背景现在是 [|cFF99CC33隐藏|r]"
L.SlashBGInfo = "显示窗口背景。"

L.SlashReset = "重置"
L.SlashResetInfo = "重置信息条位置。"
L.SlashResetAlert = "xanEXP: 信息条已重置为默认！"

L.SlashScale = "缩放"
L.SlashScaleSet = "xanEXP: 缩放比列设置为 [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "缩放无效！数字必需为 [0.5 - 5]。 (0.5, 1, 3, 4.6, 等..)"
L.SlashScaleInfo = "设置xanEXP比例为 (0.5 - 5)。"
L.SlashScaleText = "xanEXP 窗口比例"

L.Waiting = "等待..."
L.FormatDay = "d"
L.FormatHour = "h"
L.FormatMinute = "m"
L.FormatSecond = "s"

L.TooltipDragInfo = "[按住 Shift 移动窗口。]"
L.TooltipEXP = "经验:"
L.TooltipRest = "休息:"
L.TooltipToNextLevel = "下一级:"
L.TooltipXPPerSec = "XP/秒:"
L.TooltipXPPerMinute = "XP/分钟:"
L.TooltipXPPerHour = "XP/小时:"
L.TooltipTimeToLevel = "等级用时:"
L.TooltipTimeToLevelNone = "无"
L.TooltipSessionHoursPlayed = "玩家已用 %s 小时"
L.TooltipSessionExpGained = "本次游戏获得经验"
L.TooltipSessionLevelsGained = "本次在线升到 %s 级"
