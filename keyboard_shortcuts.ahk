#Requires AutoHotkey v2.0

; ctrl+alt+t launch terminal
^!t::
{
    Run("wt")
}

; ctrl+alt+p launch terminal with PowerShell
^!p::
{
    Run("wt powershell")
}

; ctrl+alt+c launch VS Code
^!c::
{
    Run(EnvGet("LOCALAPPDATA") "\Programs\Microsoft VS Code\Code.exe")
}

; ctrl+alt+n launch browser
^!n::
{
    Run("chrome.exe")
}

GUID()
{ 
    myvar := ComObject("Scriptlet.TypeLib").GUID
    return SubStr(myvar, 2, StrLen(myvar) - 4)
}

^!g::
{
    A_Clipboard := GUID()
}

RemoveToolTip() {
    ToolTip()
}

; Open ww.md in VS Code (Fixed)
^!d::
{
    filePath := EnvGet("USERPROFILE") "\Desktop\work\ww.md"
    Run(Format('"{}" "{}"', EnvGet("LOCALAPPDATA") "\Programs\Microsoft VS Code\Code.exe", filePath))
}

; disable win+space
#Space::
{
    return
}

; remap insert to delete
Ins::
{
    Send("{Del}")
}
