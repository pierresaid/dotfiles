function la { Get-ChildItem -Force }
function l { Get-ChildItem -Force }
function ll { Get-ChildItem -Force }
function q { Set-Location .. }
function ll {
    Clear-Host
    Get-ChildItem -Force
}
function ne { notepad }
function dd { Set-Location $HOME\Desktop\work }
function ddd { Set-Location \\wsl.localhost\Ubuntu\home\saidp\work }
function gs { git status }
function ni { npm install }
function nd { npm run dev }
function nt { explorer . }

$env:Path += ";C:\Users\Pierre Said\AppData\Local\Programs\oh-my-posh\bin"
$env:POSH_THEMES_PATH = "C:\Users\Pierre Said\AppData\Local\Programs\oh-my-posh\themes"

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{
    "Command"   = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Cyan
    "String"    = [ConsoleColor]::Yellow
    "Operator"  = [ConsoleColor]::Magenta
    "Variable"  = [ConsoleColor]::White
    "Number"    = [ConsoleColor]::DarkYellow
    "Type"      = [ConsoleColor]::DarkCyan
}
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Import-Module -Name Terminal-Icons

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\night-owl.omp.json" | Invoke-Expression
