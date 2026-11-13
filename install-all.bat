<# : batch
@echo off
chcp 65001 >nul
fltmc >nul 2>&1 || (powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs" & exit /b)
title fln install all
powershell -NoProfile -ExecutionPolicy Bypass -Command "$f='%~f0'; iex ([IO.File]::ReadAllText($f,[Text.Encoding]::UTF8))"
exit /b
#>

# ================== fln install all - one-click setup ==================
# Installs Windhawk + komorebi + whkd, then applies the Mocha Glass presets.
# Windhawk mods themselves are installed through the Windhawk UI (the script
# will guide you), because the stable Windhawk has no CLI for mod installs.

[Console]::OutputEncoding = [Text.Encoding]::UTF8
$ErrorActionPreference = 'Continue'
$repo = Split-Path -Parent $PSScriptRoot
$presets = Join-Path $repo 'presets'

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "    OK: $msg" -ForegroundColor Green }

Step 'Checking winget'
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host 'winget not found. Install "App Installer" from Microsoft Store and re-run.' -ForegroundColor Red
    Read-Host 'Enter to exit'; exit 1
}
Ok 'winget available'

Step 'Installing Windhawk (skip if already present)'
winget install --id RamenSoftware.Windhawk --accept-source-agreements --accept-package-agreements -e 2>&1 |
    Select-String -Pattern 'Successfully|already installed|No available upgrade' | ForEach-Object { "    $_" }

Step 'Installing komorebi'
winget install --id LGUG2Z.komorebi --accept-source-agreements --accept-package-agreements -e 2>&1 |
    Select-String -Pattern 'Successfully|already installed|No available upgrade' | ForEach-Object { "    $_" }

Step 'Installing whkd (hotkey daemon)'
winget install --id LGUG2Z.whkd --accept-source-agreements --accept-package-agreements -e 2>&1 |
    Select-String -Pattern 'Successfully|already installed|No available upgrade' | ForEach-Object { "    $_" }

Step 'Deploying komorebi configs'
Copy-Item (Join-Path $repo 'komorebi\komorebi.json') "$env:USERPROFILE\komorebi.json" -Force
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config" | Out-Null
Copy-Item (Join-Path $repo 'komorebi\whkdrc') "$env:USERPROFILE\.config\whkdrc" -Force
Ok 'komorebi.json -> %USERPROFILE%, whkdrc -> %USERPROFILE%\.config'

Step 'Checking Windhawk mods'
$modsRoot = 'HKLM:\SOFTWARE\Windhawk\Engine\Mods'
$required = @(
    'windows-11-taskbar-styler',
    'windows-11-start-menu-styler',
    'windows-11-notification-center-styler',
    'windows-11-file-explorer-styler',
    'taskbar-dock-animation'
)
$installed = (Get-ChildItem $modsRoot -ErrorAction SilentlyContinue).PSChildName
$missing = $required | Where-Object { $installed -notcontains $_ }

if ($missing) {
    Write-Host ''
    Write-Host '  The following mods must be installed manually (2 minutes):' -ForegroundColor Yellow
    foreach ($m in $missing) {
        $url = switch -Wildcard ($m) {
            'taskbar-dock-animation' { 'https://windhawk.net/mods/taskbar-dock-animation' }
            default { "https://windhawk.net/mods/$m" }
        }
        Write-Host "    - $m  ->  $url" -ForegroundColor Yellow
    }
    Write-Host ''
    Write-Host '  1. Open Windhawk -> Explore, install each mod (Just install, no need to configure).'
    Write-Host '  2. Press Enter here when done - the preset will be applied automatically.'
    Start-Process 'https://windhawk.net/'
    Read-Host '  Press Enter after installing the mods'
}

Step 'Applying Mocha Glass presets'
Get-ChildItem $presets -Filter '*.reg' | ForEach-Object {
    Write-Host "    importing $($_.Name)" -NoNewline
    reg import $_.FullName
    Write-Host ' OK' -ForegroundColor Green
}

Step 'Restarting explorer and shell hosts'
taskkill /f /im StartMenuExperienceHost.exe 2>$null
taskkill /f /im ShellExperienceHost.exe 2>$null
taskkill /f /im explorer.exe 2>$null
Start-Process explorer.exe
Start-Sleep -Seconds 3

Step 'Setting up komorebi autostart (optional)'
$kom = Get-ChildItem 'C:\Program Files\komorebi\bin\komorebic-no-console.exe' -ErrorAction SilentlyContinue
if ($kom) {
    $startup = [Environment]::GetFolderPath('Startup')
    $sh = New-Object -ComObject WScript.Shell
    $lnk = $sh.CreateShortcut((Join-Path $startup 'komorebi.lnk'))
    $lnk.TargetPath = $kom.FullName
    $lnk.Arguments = 'start --whkd'
    $lnk.Save()
    Ok 'komorebi autostart shortcut created (starts with tiling on login)'
} else {
    Write-Host '    komorebi not found, skipping autostart' -ForegroundColor DarkYellow
}

Write-Host ''
Write-Host '=== Done! The rice is applied. ===' -ForegroundColor Green
Write-Host 'Dark theme recommended: Settings -> Personalization -> Colors -> Dark.'
Read-Host 'Press Enter to exit'
