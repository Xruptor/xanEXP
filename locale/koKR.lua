local ADDON_NAME, private = ...

local L = private:NewLocale("koKR")
if not L then return end

L.SlashBG = "배경"
L.SlashBGOn = "xanEXP: 배경이 [|cFF99CC33표시|r]되었습니다"
L.SlashBGOff = "xanEXP: 배경이 [|cFF99CC33숨김|r]되었습니다"
L.SlashBGInfo = "창 배경을 표시합니다."

L.SlashReset = "초기화"
L.SlashResetInfo = "프레임 위치를 초기화합니다."
L.SlashResetAlert = "xanEXP: 프레임 위치가 초기화되었습니다!"

L.SlashScale = "크기"
L.SlashScaleSet = "xanEXP: 크기가 [|cFF20ff20%s|r]로 설정되었습니다"
L.SlashScaleSetInvalid = "잘못된 크기입니다! 숫자는 [0.5 - 5] 사이여야 합니다. (0.5, 1, 3, 4.6 등)"
L.SlashScaleInfo = "xanEXP 프레임의 크기를 설정합니다 (0.5 - 5)."
L.SlashScaleText = "xanEXP 프레임 크기"

L.Waiting = "대기 중..."
L.FormatDay = "일"
L.FormatHour = "시간"
L.FormatMinute = "분"
L.FormatSecond = "초"

L.TooltipDragInfo = "[Shift를 누른 채로 드래그하여 창을 이동합니다.]"
L.TooltipEXP = "경험치:"
L.TooltipRest = "휴식:"
L.TooltipToNextLevel = "다음 레벨까지:"
L.TooltipXPPerSec = "초당 경험치:"
L.TooltipXPPerMinute = "분당 경험치:"
L.TooltipXPPerHour = "시간당 경험치:"
L.TooltipTimeToLevel = "레벨까지 시간:"
L.TooltipTimeToLevelNone = "없음"
L.TooltipSessionHoursPlayed = "이번 세션에서 %s시간 플레이"
L.TooltipSessionExpGained = " 이번 세션에서 획득한 경험치"
L.TooltipSessionLevelsGained = "이번 세션에서 %s레벨 상승"
