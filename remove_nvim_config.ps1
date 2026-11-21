# Windows counterpart of remove_nvim_config
#   .\remove_nvim_config.ps1            remove config, data, state, cache
#   .\remove_nvim_config.ps1 -Backup    back up to ~\nvim_backup first
#   .\remove_nvim_config.ps1 -DeleteBackup   only delete ~\nvim_backup
param(
    [switch]$Backup,
    [switch]$DeleteBackup
)

$dirs = @(
    (Join-Path $env:LOCALAPPDATA 'nvim'),        # config
    (Join-Path $env:LOCALAPPDATA 'nvim-data'),   # data + state (lazy, mason, shada, logs)
    (Join-Path $env:TEMP 'nvim')                 # cache
)
$backupDir = Join-Path $HOME 'nvim_backup'

if ($DeleteBackup) {
    if (Test-Path $backupDir) {
        Remove-Item $backupDir -Recurse -Force
        Write-Host 'Backup deleted.'
    } else {
        Write-Host 'No backup found.'
    }
    return
}

if ($Backup) {
    Write-Host 'Creating backup...'
    New-Item -ItemType Directory -Force $backupDir | Out-Null
    foreach ($d in $dirs) {
        if (Test-Path $d) { Copy-Item $d $backupDir -Recurse -Force }
    }
    Write-Host "Backup completed: $backupDir"
}

foreach ($d in $dirs) {
    if (Test-Path $d) { Remove-Item $d -Recurse -Force }
}
Write-Host 'NVim configuration has been removed.'
