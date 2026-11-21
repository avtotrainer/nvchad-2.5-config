# One-command Windows setup for this NvChad config.
#
# On a fresh Windows (normal, non-admin PowerShell):
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/avtotrainer/nvchad-2.5-config/main/install.ps1)))
#
# Or from a local clone:
#   powershell -ExecutionPolicy Bypass -File .\install.ps1
#
# What it does:
#   1. winget: Neovim, Git, ripgrep, fd, MinGW gcc, Node.js LTS, Python, JetBrainsMono Nerd Font (+ Go with -WithGo)
#   2. npm: tree-sitter-cli (builds treesitter parsers)
#   3. git clone the config into %LOCALAPPDATA%\nvim (or `git pull` if it is already there)
#   4. headless: install plugins from lazy-lock.json, treesitter parsers, Mason LSP servers/formatters
#
# Switches:
#   -WithGo      also install Go (gopls)
#   -NoFont      skip the Nerd Font
#   -SkipTools   skip winget/npm (only config + plugins)
#   -Repo/-Branch  clone from somewhere else (e.g. a local path for testing)
#   -AppName     config folder name (default nvim; uses NVIM_APPNAME for anything else)

param(
    [switch]$WithGo,
    [switch]$NoFont,
    [switch]$SkipTools,
    [string]$Repo = 'https://github.com/avtotrainer/nvchad-2.5-config.git',
    [string]$Branch = 'main',
    [string]$AppName = 'nvim'
)

$ErrorActionPreference = 'Stop'

function Write-Step([string]$Text) { Write-Host "==> $Text" -ForegroundColor Cyan }

function Update-SessionPath {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'User') + ';' +
                (Join-Path $env:APPDATA 'npm')
}

function Install-WingetPackage([string]$Id) {
    Write-Step "winget: $Id"
    winget install --id $Id -e --silent --accept-package-agreements --accept-source-agreements | Out-Host
    # -1978335189 = already installed / no applicable upgrade
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
        Write-Warning "winget returned $LASTEXITCODE for $Id"
    }
}

# ---------------------------------------------------------------- 1. tools
if (-not $SkipTools) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'winget not found. Install "App Installer" from Microsoft Store first.'
    }

    $packages = @(
        'Neovim.Neovim',
        'Git.Git',
        'BurntSushi.ripgrep.MSVC',
        'sharkdp.fd',
        'BrechtSanders.WinLibs.POSIX.UCRT',  # gcc for treesitter parsers (zig does not work)
        'OpenJS.NodeJS.LTS',                 # tree-sitter CLI, pyright, ts_ls, prettier, ...
        'Python.Python.3.13'                 # black, py_compile check
    )
    if (-not $NoFont) { $packages += 'DEVCOM.JetBrainsMonoNerdFont' }
    if ($WithGo)      { $packages += 'GoLang.Go' }

    foreach ($p in $packages) { Install-WingetPackage $p }
    Update-SessionPath

    if (-not (Get-Command tree-sitter -ErrorAction SilentlyContinue)) {
        Write-Step 'npm: tree-sitter-cli'
        # npm.cmd, not npm: "npm" resolves to npm.ps1, which is blocked when the
        # execution policy is Restricted (the default on a fresh Windows)
        npm.cmd install -g tree-sitter-cli | Out-Host
        Update-SessionPath
    }
} else {
    Update-SessionPath
}

foreach ($exe in 'nvim', 'git') {
    if (-not (Get-Command $exe -ErrorAction SilentlyContinue)) {
        throw "$exe not found on PATH. Open a new terminal and run the script again."
    }
}

# ---------------------------------------------------------------- 2. config
$cfg = Join-Path $env:LOCALAPPDATA $AppName
if ($AppName -ne 'nvim') { $env:NVIM_APPNAME = $AppName }

$isOurClone = $false
if (Test-Path (Join-Path $cfg '.git')) {
    try { $origin = git -C $cfg remote get-url origin } catch { $origin = $null }
    $isOurClone = ($origin -eq $Repo)
}

if ($isOurClone) {
    Write-Step "Updating config in $cfg (git pull)"
    git -C $cfg pull --ff-only | Out-Host
} else {
    if (Test-Path $cfg) {
        $bak = "$cfg.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
        Write-Host "==> Existing config moved to $bak" -ForegroundColor Yellow
        Move-Item $cfg $bak
    }
    Write-Step "Cloning $Repo -> $cfg"
    git clone --branch $Branch $Repo $cfg | Out-Host
    if ($LASTEXITCODE -ne 0) { throw 'git clone failed' }
}

# ---------------------------------------------------------------- 3. plugins, parsers, LSPs
if (Get-Command gcc -ErrorAction SilentlyContinue) { $env:CC = 'gcc' }

Write-Step 'Installing plugins (Lazy restore from lazy-lock.json)...'
nvim --headless '+Lazy! restore' +qa | Out-Host

Write-Step 'Installing treesitter parsers and Mason packages (several minutes)...'
nvim --headless -c "luafile $(Join-Path $cfg 'bootstrap.lua')" | Out-Host
if ($LASTEXITCODE -ne 0) {
    Write-Warning "bootstrap exited with code $LASTEXITCODE - open nvim and run :checkhealth"
}

# ---------------------------------------------------------------- done
Write-Host ''
Write-Host 'Done!' -ForegroundColor Green
Write-Host 'Remaining manual steps:'
Write-Host '  1. Open a NEW terminal (PATH changes).'
Write-Host '  2. Windows Terminal: Settings > Profile > Appearance > Font face = JetBrainsMono Nerd Font'
Write-Host '  3. In nvim:  :Copilot auth signin   (once per machine)'
Write-Host '  4. Optional: :checkhealth'
