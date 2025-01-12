#Requires AutoHotkey v2.0

; ctrl+alt+t launch terminal
^!t::
{
    Run("wt")
}

; ctrl+alt+p launch terminal with powershell
^!p::
{
    Run("wt powershell")
}

; ctrl+alt+c launch vscode
^!c::
{
    Run("C:\Users\Pierre Said\AppData\Local\Programs\Microsoft VS Code\Code.exe")
}

; ctrl+alt+n launch browser
^!n::
{
    Run("C:\Program Files\Google\Chrome\Application\chrome.exe")
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

^!d::
{
    Run("C:\Users\Pierre Said\AppData\Local\Programs\Microsoft VS Code\Code.exe", "C:\Users\Pierre Said\Desktop\work\ww.md")
}

; disable win space
#Space::
{
    return
}

; remap insert to suppr
Ins::
{
    Send("{Del}")
}
