local ADDON_NAME, private = ...

local L = private:NewLocale("ptBR")
if not L then return end

L.SlashBG = "fundo"
L.SlashBGOn = "xanEXP: O fundo agora esta [|cFF99CC33MOSTRADO|r]"
L.SlashBGOff = "xanEXP: O fundo agora esta [|cFF99CC33OCULTO|r]"
L.SlashBGInfo = "Mostrar o fundo da janela."

L.SlashReset = "resetar"
L.SlashResetInfo = "Redefinir a posicao do quadro."
L.SlashResetAlert = "xanEXP: A posicao do quadro foi redefinida!"

L.SlashScale = "escala"
L.SlashScaleSet = "xanEXP: a escala foi definida para [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "Escala invalida! O numero deve ser de [0.5 - 5]. (0.5, 1, 3, 4.6, etc..)"
L.SlashScaleInfo = "Definir a escala do quadro xanEXP (0.5 - 5)."
L.SlashScaleText = "Escala do quadro xanEXP"

L.Waiting = "Aguardando..."
L.FormatDay = "d"
L.FormatHour = "h"
L.FormatMinute = "m"
L.FormatSecond = "s"

L.TooltipDragInfo = "[Segure Shift e arraste para mover a janela.]"
L.TooltipEXP = "EXP:"
L.TooltipRest = "Descanso:"
L.TooltipToNextLevel = "Ate o proximo nivel:"
L.TooltipXPPerSec = "EXP/seg:"
L.TooltipXPPerMinute = "EXP/min:"
L.TooltipXPPerHour = "EXP/h:"
L.TooltipTimeToLevel = "Tempo ate o nivel:"
L.TooltipTimeToLevelNone = "Nenhum"
L.TooltipSessionHoursPlayed = "%s horas jogadas nesta sessao"
L.TooltipSessionExpGained = " EXP ganho nesta sessao"
L.TooltipSessionLevelsGained = "%s niveis ganhos nesta sessao"
