# Oh My Posh
oh-my-posh init pwsh --config "$HOME\oh-my-posh\themes\night-owl.omp.json" | Invoke-Expression

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Modules
Import-Module Terminal-Icons

# Aliases
Set-Alias -Name vim -Value nvim
Set-Alias -Name g -Value git

# Useful functions
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function ls { eza --icons }
function ll {  Clear-Host eza -l --icons }
function la { eza -la --icons }
function dd { Set-Location $HOME\Desktop\work }
function ddd { Set-Location \\wsl.localhost\Ubuntu\home\azarias\work }
function q { Set-Location .. }
function c { Clear-Host }
function gs { git status }
function ni { npm install }
function nd { npm run dev }
function nt { explorer . }
