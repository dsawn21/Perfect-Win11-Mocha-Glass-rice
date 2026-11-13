# fln Windhawk Preset - apply script
# Requires: Windhawk installed, mods installed (taskbar-styler, start-menu-styler,
# notification-center-styler, taskbar-dock-animation). Run the backup script first.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$modsRoot = 'HKLM:\SOFTWARE\Windhawk\Engine\Mods'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$presets = Join-Path (Split-Path -Parent $here) 'presets'

$files = @(
    'taskbar-styler.reg',
    'start-menu-styler.reg',
    'notification-center-styler.reg',
    'file-explorer-styler.reg',
    'taskbar-dock-animation.reg'
)

Write-Host '=== fln Windhawk preset ===' -ForegroundColor Cyan

$installed = Get-ChildItem $modsRoot -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PSChildName
$required = @('windows-11-taskbar-styler','windows-11-start-menu-styler','windows-11-notification-center-styler','windows-11-file-explorer-styler','taskbar-dock-animation')
$missing = $required | Where-Object { $installed -notcontains $_ }
if ($missing) {
    Write-Warning "Mods not installed: $($missing -join ', ')"
    Write-Warning 'Install them in Windhawk first (Explore tab), then re-run this script.'
    if ((Read-Host 'Continue anyway? (y/n)') -ne 'y') { exit 1 }
}

foreach ($f in $files) {
    $path = Join-Path $presets $f
    if (Test-Path $path) {
        Write-Host "Importing $f ..." -NoNewline
        reg import $path
        Write-Host ' OK' -ForegroundColor Green
    } else {
        Write-Warning "Missing: $path"
    }
}

Write-Host 'Restarting shell hosts...'
taskkill /f /im StartMenuExperienceHost.exe 2>$null
taskkill /f /im ShellExperienceHost.exe 2>$null
taskkill /f /im explorer.exe 2>$null
Start-Process explorer.exe

Write-Host 'Done. Give the taskbar/menu a few seconds to rebuild.' -ForegroundColor Green
Write-Host 'To revert: restore the backup created by backup-windhawk.ps1'
