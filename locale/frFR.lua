local ADDON_NAME, private = ...

local L = private:NewLocale("frFR")
if not L then return end

L.SlashBG = "fond"
L.SlashBGOn = "xanEXP : l'arriere-plan est maintenant [|cFF99CC33AFFICHE|r]"
L.SlashBGOff = "xanEXP : l'arriere-plan est maintenant [|cFF99CC33MASQUE|r]"
L.SlashBGInfo = "Afficher l'arriere-plan de la fenetre."

L.SlashReset = "reinitialiser"
L.SlashResetInfo = "Reinitialiser la position du cadre."
L.SlashResetAlert = "xanEXP : La position du cadre a ete reinitialisee !"

L.SlashScale = "echelle"
L.SlashScaleSet = "xanEXP : l'echelle a ete definie sur [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "Echelle invalide ! Le nombre doit etre entre [0.5 - 5]. (0.5, 1, 3, 4.6, etc..)"
L.SlashScaleInfo = "Definir l'echelle du cadre xanEXP (0.5 - 5)."
L.SlashScaleText = "Echelle du cadre xanEXP"

L.Waiting = "En attente..."
L.FormatDay = "j"
L.FormatHour = "h"
L.FormatMinute = "m"
L.FormatSecond = "s"

L.TooltipDragInfo = "[Maintenez Maj et faites glisser pour deplacer la fenetre.]"
L.TooltipEXP = "EXP :"
L.TooltipRest = "Repos :"
L.TooltipToNextLevel = "Niv. suivant :"
L.TooltipXPPerSec = "EXP/s :"
L.TooltipXPPerMinute = "EXP/min :"
L.TooltipXPPerHour = "EXP/h :"
L.TooltipTimeToLevel = "Temps jusqu'au niveau :"
L.TooltipTimeToLevelNone = "Aucun"
L.TooltipSessionHoursPlayed = "%s heures jouees cette session"
L.TooltipSessionExpGained = " EXP gagnee cette session"
L.TooltipSessionLevelsGained = "%s niveaux gagnes cette session"
