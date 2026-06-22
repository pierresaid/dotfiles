# ════════════════════════════════════════════════════════════════════════
#  PowerShell 7 profile — tuned for SPEED
#  • History + completion : PSReadLine + CompletionPredictor
#  • Prompt               : Starship      • Smart cd : zoxide
#  Tool init scripts are CACHED to disk, so no external exe is spawned at
#  startup — they are only regenerated after a `winget upgrade`.
# ════════════════════════════════════════════════════════════════════════

Import-Module PSReadLine   # already auto-loaded; explicit call is idempotent + cheap

# ── History (safe in any host) ──────────────────────────────────────────
Set-PSReadLineOption -HistoryNoDuplicates                 # collapse repeated commands
Set-PSReadLineOption -MaximumHistoryCount 20000
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -BellStyle None                      # no error beep

# ── Keys ────────────────────────────────────────────────────────────────
Set-PSReadLineKeyHandler -Key Tab        -Function MenuComplete            # Tab  -> menu of completions
Set-PSReadLineKeyHandler -Key UpArrow    -Function HistorySearchBackward   # type a prefix, then Up/Down
Set-PSReadLineKeyHandler -Key DownArrow  -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardChar             # at line-end -> accept suggestion
Set-PSReadLineKeyHandler -Key Ctrl+f     -Function AcceptNextSuggestionWord
Set-PSReadLineKeyHandler -Key Ctrl+w     -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+d      -Function KillWord

# ── Predictive IntelliSense — only in an interactive (VT-capable) console,
#    so non-interactive `pwsh -Command ...` runs never throw VT errors. ────
if (-not [Console]::IsOutputRedirected) {
    Import-Module CompletionPredictor -ErrorAction SilentlyContinue   # IntelliSense predictor plugin
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin           # suggest from history + plugin
    Set-PSReadLineOption -PredictionViewStyle ListView                # dropdown list (F2 toggles inline)
    Set-PSReadLineOption -Colors @{
        ListPrediction         = "`e[38;5;244m"   # dim-grey list items
        InlinePrediction       = "`e[38;5;244m"   # dim-grey inline ghost text
        ListPredictionSelected = "`e[48;5;238m"   # highlighted selection bar
    }
}

# ── Fast tool startup: cache each tool's init script; regenerate only when
#    the tool's exe is newer than the cache (i.e. after a winget upgrade).
#    Dot-source at profile (global) scope so `prompt`, `z`, etc. persist —
#    dot-sourcing inside a function would lose them. ────────────────────────
function Get-CachedToolInit {
    param([string]$Name, [string]$CachePath, [scriptblock]$Generate)
    $cmd = Get-Command $Name -CommandType Application -ErrorAction SilentlyContinue
    if (-not $cmd) { return $null }
    $fresh = (Test-Path $CachePath) -and
             ((Get-Item $CachePath).LastWriteTime -ge (Get-Item $cmd.Source).LastWriteTime)
    if (-not $fresh) {
        $dir = Split-Path $CachePath
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
        & $Generate | Out-File -LiteralPath $CachePath -Encoding utf8
    }
    return $CachePath
}

$__cacheDir = Join-Path (Split-Path -Parent $PROFILE) 'init-cache'
$__sp = Get-CachedToolInit 'starship' (Join-Path $__cacheDir 'starship.ps1') { starship init powershell --print-full-init }
if ($__sp) { . $__sp }
$__zx = Get-CachedToolInit 'zoxide'   (Join-Path $__cacheDir 'zoxide.ps1')   { zoxide init powershell }
if ($__zx) { . $__zx }
Remove-Variable __cacheDir, __sp, __zx -ErrorAction SilentlyContinue

# ── fnm (Fast Node Manager) — SAFE per-project Node switching ─────────────
#    `fnm env` (WITHOUT --use-on-cd) just sets up the env; it mints a per-shell
#    multishell path, so it must run fresh each session (can't be cached).
#    Then we add our OWN auto-switch that NEVER prompts or errors — cd stays safe:
#      • switches silently if the pinned version is already installed
#      • ignores malformed / non-version files (e.g. a stray .npmrc in .nvmrc)
#      • if a valid version isn't installed, prints ONE dim hint (no prompt)
if (Get-Command fnm -CommandType Application -ErrorAction SilentlyContinue) {
    fnm env | Out-String | Invoke-Expression

    function global:__Invoke-FnmAutoSwitch {
        try {
            if ($PWD.Path -eq $global:__fnmDir) { return }   # only act when the dir changes
            $global:__fnmDir = $PWD.Path
            $vf = @('.node-version','.nvmrc') |
                  ForEach-Object { Join-Path $PWD.Path $_ } |
                  Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
            if (-not $vf) { return }
            $ver = (Get-Content -LiteralPath $vf -TotalCount 1 -ErrorAction Stop).Trim()
            if ($ver -notmatch '^v?\d+(\.\d+){0,2}$') { return }   # not a version -> ignore
            $bare = $ver.TrimStart('v')
            if ((& fnm list 2>$null) -match [regex]::Escape($bare)) {
                & fnm use $ver --silent-if-unchanged 2>$null | Out-Null
            } else {
                Write-Host "fnm: this folder wants Node $bare (not installed) — run 'fnm install' to use it" -ForegroundColor DarkGray
            }
        } catch { }   # auto-switch must NEVER break the prompt
    }

    if (-not $global:__fnmWrapped) {
        $global:__fnmPrevPrompt = $function:prompt           # chain after starship+zoxide
        function global:prompt {
            __Invoke-FnmAutoSwitch
            if ($global:__fnmPrevPrompt) { & $global:__fnmPrevPrompt } else { "PS $($PWD.Path)> " }
        }
        $global:__fnmWrapped = $true
    }
}

# ── Prettier `ls` via eza (Rust binary — zero startup cost) ──────────────
#    ls/ll/la/lt = pretty viewing (icons + colors).  gci / Get-ChildItem / dir
#    stay NATIVE PowerShell (objects intact) — use those to pipe/filter, e.g.
#    `gci *.ts | measure`.  (@args lets you pass paths/flags: `ls subdir`, `la ..`)
if (Get-Command eza -CommandType Application -ErrorAction SilentlyContinue) {
    if (Test-Path Alias:ls) { Remove-Item Alias:ls -Force }   # ls is a built-in alias to Get-ChildItem
    function ls { eza --icons @args }                  # quick list
    function ll { Clear-Host; eza -l --icons @args }   # clear screen, then long list
    function la { eza -la --icons @args }              # long + hidden
    function lt { eza --tree --level=2 --icons @args } # tree, 2 levels deep
}

# ── Small zero-cost niceties (delete any line you don't want) ────────────
$env:STARSHIP_LOG = 'error'                                  # keep the prompt quiet
function which { param([Parameter(Mandatory)] $Name) (Get-Command $Name).Source }   # which <cmd>

# ── Custom shortcuts ─────────────────────────────────────────────────────
function ..  { Set-Location .. }                        # up one directory
function q   { Set-Location .. }                        # up one directory (same as ..)
function dd  { Set-Location "$HOME\Desktop\work" }      # jump to your work folder
function gs  { git status @args }                       # git status
function gl  { git pull @args }                         # git pull
function gp  { git push @args }                         # git push
function gd  { git diff @args }                         # git diff
function ga  { git add @args }                          # git add
function nd  { npm run dev @args }                      # npm run dev
function nt  { explorer . }                             # open current folder in Explorer
function pp  { $p = (Get-Location).Path; Set-Clipboard $p; Write-Host "Copied: $p" -ForegroundColor DarkGray }  # copy current path to clipboard
if (Test-Path Alias:ni) { Remove-Item Alias:ni -Force } # ni is a built-in alias to New-Item
function ni  { npm install @args }                       # npm install
