local ADDON_NAME, private = ...

local L = private:NewLocale("esES")
if not L then return end

L.SlashBG = "fondo"
L.SlashBGOn = "xanEXP: El fondo ahora esta [|cFF99CC33MOSTRADO|r]"
L.SlashBGOff = "xanEXP: El fondo ahora esta [|cFF99CC33OCULTO|r]"
L.SlashBGInfo = "Mostrar el fondo de la ventana."

L.SlashReset = "reiniciar"
L.SlashResetInfo = "Restablecer la posicion del marco."
L.SlashResetAlert = "xanEXP: La posicion del marco ha sido restablecida!"

L.SlashScale = "escala"
L.SlashScaleSet = "xanEXP: la escala se ha establecido en [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "Escala no valida! El numero debe ser de [0.5 - 5]. (0.5, 1, 3, 4.6, etc..)"
L.SlashScaleInfo = "Establecer la escala del marco xanEXP (0.5 - 5)."
L.SlashScaleText = "Escala del marco xanEXP"

L.Waiting = "Esperando..."
L.FormatDay = "d"
L.FormatHour = "h"
L.FormatMinute = "m"
L.FormatSecond = "s"

L.TooltipDragInfo = "[Manten Shift y arrastra para mover la ventana.]"
L.TooltipEXP = "EXP:"
L.TooltipRest = "Descanso:"
L.TooltipToNextLevel = "Sig. nivel:"
L.TooltipXPPerSec = "EXP/seg:"
L.TooltipXPPerMinute = "EXP/min:"
L.TooltipXPPerHour = "EXP/h:"
L.TooltipTimeToLevel = "Tiempo para subir:"
L.TooltipTimeToLevelNone = "Ninguno"
L.TooltipSessionHoursPlayed = "%s horas jugadas en esta sesion"
L.TooltipSessionExpGained = " EXP ganada en esta sesion"
L.TooltipSessionLevelsGained = "%s niveles ganados en esta sesion"
