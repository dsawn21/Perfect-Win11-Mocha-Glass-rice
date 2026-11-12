# fln Windhawk Preset - backup script
# Saves current Windhawk mod settings to .\backup\<timestamp>\ before applying the preset.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$modsRoot = 'HKLM:\SOFTWARE\Windhawk\Engine\Mods'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$repo = Split-Path -Parent $here
$stamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$outDir = Join-Path $repo "backup\$stamp"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$mods = @(
    'windows-11-taskbar-styler',
    'windows-11-start-menu-styler',
    'windows-11-notification-center-styler',
    'taskbar-dock-animation'
)

foreach ($m in $mods) {
    $key = "$modsRoot\$m\Settings"
    $file = Join-Path $outDir "$m.reg"
    if (Test-Path "Registry::$key") {
        reg export $key $file /y | Out-Null
        Write-Host "Backed up: $m" -ForegroundColor Green
    } else {
        Write-Warning "Not found (mod not installed?): $m"
    }
}

Write-Host "Backup saved to: $outDir" -ForegroundColor Cyan
Write-Host 'To restore: double-click any .reg file, then restart explorer.exe'
