#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ctrl+alt+t launch terminal
^!t::
Run, wt
return

; ctrl+alt+p launch terminal with powershell
^!p::
Run, wt powershell
return

; ctrl+alt+c launch vscode
^!c::
Run, "C:\Users\saidp\AppData\Local\Programs\Microsoft VS Code\Code.exe"
return

; ctrl+alt+n launch browser
^!n::
Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
return

; ctrl+alt+g create guid
^!g::
myvar := ComObjCreate("Scriptlet.TypeLib").GUID
clipboard := SubStr(myvar, 2, StrLen(myvar) - 4)
return

^!d::
Run, "C:\Users\saidp\AppData\Local\Programs\Microsoft VS Code\Code.exe" "C:\Users\saidp\Desktop\work\ww.md"
return

; disable win space
#Space::
return

; remap insert to suppr
Ins::Del
