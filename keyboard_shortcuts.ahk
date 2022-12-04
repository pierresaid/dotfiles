#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

# ctrl+alt+n launch terminal
^!t::
Run, wt
return

# ctrl+alt+n launch vscode
^!c::
Run, code
return

# ctrl+alt+n launch navigator
^!n::
Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
return

# ctrl+alt+n create guid
^!g::
myvar := ComObjCreate("Scriptlet.TypeLib").GUID
clipboard := SubStr(myvar, 2, StrLen(myvar) - 4)

# Disable win+space
#Space::
return