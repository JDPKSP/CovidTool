#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Data := ""

Gui,+AlwaysOnTop
Gui, Color, FFFFFF
Gui, Font, Bold
Gui, Add, GroupBox, X5 Y0 w250 h128,Vaccine dates in clipboard
Gui, Font, norm
Gui, Add, Text, vGuiDates X10 Y15 w75 h110,
Gui, Add, Text, vGuiDescript X85 Y15 w165 h110,



gui, show,, CovidTool


return

GuiClose:
	ExitApp

UpdateMessage()
{
	GuiControl,,Var,Covid vaccine copy paste tool active.`nVaccine dates in clipboard:`n%Data%
	msgBox %Data%
}

$^c::
	Send, ^c
	GuiControl,,GuiDates,Copying
	GuiControl,,GuiDescript,
	Data := ""
	Clipwait
	if(Clipboard ~= "")
	{
		tempDates := ""
		tempDescript := ""
		Loop, Parse, Clipboard, `n, `r
		{
			covidStart := inStr(A_LoopField,"Covid-19 sygdom")
			if(covidStart)
			{
				dateStart := RegExMatch(A_LoopField,"[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]")
				if(dateStart)
				{
					date := SubStr(A_LoopField, dateStart,2)
					date := date SubStr(A_LoopField, dateStart+3,2)
					date := date SubStr(A_LoopField, dateStart+8,2)
					Data := date "`n" Data
					
					tempDates := SubStr(A_LoopField, dateStart,10) "`n" tempDates
					
					tempDescript := SubStr(A_LoopField, dateStart+11,((covidStart-dateStart)-12)) "`n" tempDescript
				}
			}
		}
		Clipboard := ""
		GuiControl,,GuiDates,%tempDates%
		GuiControl,,GuiDescript,%tempDescript%
	}
	else
	{
		GuiControl,,GuiDates,Failed
	}
return

$^v::
	if(Data ~= "")
	{
		GuiControl,,GuiDates,Writing
		GuiControl,,GuiDescript,
		NotFirst := False
		Loop, Parse, Data, `n, `r
		{
			if(StrLen(A_LoopField) = 6)
			{
				if(NotFirst)
				{
					Sleep 200
					Send, `t
					Sleep 200
					Send, `t
					Sleep 200
					
				}
				Send, %A_LoopField%
				NotFirst := True
			}
		}
		Data := ""
		GuiControl,,GuiDates,
	}
return



