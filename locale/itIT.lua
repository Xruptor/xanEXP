local ADDON_NAME, private = ...

local L = private:NewLocale("itIT")
if not L then return end

L.SlashBG = "sfondo"
L.SlashBGOn = "xanEXP: lo sfondo ora e [|cFF99CC33MOSTRATO|r]"
L.SlashBGOff = "xanEXP: lo sfondo ora e [|cFF99CC33NASCOSTO|r]"
L.SlashBGInfo = "Mostra lo sfondo della finestra."

L.SlashReset = "reset"
L.SlashResetInfo = "Reimposta la posizione del riquadro."
L.SlashResetAlert = "xanEXP: la posizione del riquadro e stata reimpostata!"

L.SlashScale = "scala"
L.SlashScaleSet = "xanEXP: la scala e stata impostata su [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "Scala non valida! Il numero deve essere tra [0.5 - 5]. (0.5, 1, 3, 4.6, ecc..)"
L.SlashScaleInfo = "Imposta la scala del riquadro xanEXP (0.5 - 5)."
L.SlashScaleText = "Scala riquadro xanEXP"

L.Waiting = "In attesa..."
L.FormatDay = "g"
L.FormatHour = "h"
L.FormatMinute = "m"
L.FormatSecond = "s"

L.TooltipDragInfo = "[Tieni premuto Maiusc e trascina per spostare la finestra.]"
L.TooltipEXP = "EXP:"
L.TooltipRest = "Riposo:"
L.TooltipToNextLevel = "Al prossimo livello:"
L.TooltipXPPerSec = "EXP/sec:"
L.TooltipXPPerMinute = "EXP/min:"
L.TooltipXPPerHour = "EXP/ora:"
L.TooltipTimeToLevel = "Tempo al livello:"
L.TooltipTimeToLevelNone = "Nessuno"
L.TooltipSessionHoursPlayed = "%s ore giocate in questa sessione"
L.TooltipSessionExpGained = " EXP guadagnata in questa sessione"
L.TooltipSessionLevelsGained = "%s livelli guadagnati in questa sessione"
