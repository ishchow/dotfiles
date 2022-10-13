# Run script as admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Write-Header($header) 
{
    Write-Host "------------------------------------" -ForegroundColor Green
    Write-Host $header -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
}

function Check-Command($cmdname) 
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function Install-WingetPkg($appName)
{
    $app = $(winget list $appName | Select-String "No installed package found")
    if ($app)
    {
        winget install $appName
    }
}

Write-Header "Disable Sleep on AC Power..."
Powercfg /Change standby-timeout-ac 0

# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Header "Removing UWP Apps..."
$uwpApps = @(
    "Microsoft.Messaging",
    "king.com.CandyCrushSaga",
    "Microsoft.BingNews",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.YourPhone",
    "Microsoft.MicrosoftOfficeHub",
    "Fitbit.FitbitCoach",
    "Microsoft.SkypeApp",
    "Microsoft.GetHelp")

foreach ($uwp in $uwpApps) 
{
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}

Write-Header "Enable Windows 10 Developer Mode..."
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

Write-Header "Enable Remote Desktop..."
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name "fDenyTSConnections" -Value 0
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -Name "UserAuthentication" -Value 1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

if (!$(Check-Command "choco"))
{
    Write-Header "Installing Chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Header "Installing Base Chocolatey packages"
cinst -y .\packages-base.config

Write-Header "Installing Windows Features"
cinst -y .\features.config -s windowsFeatures

Write-Header "Installing winget packages"
Intall-WingetPkg Git.Git
Intall-WingetPkg Microsoft.PowerToys
Intall-WingetPkg Microsoft.WindowsTerminal
Intall-WingetPkg Microsoft.PowerShell
Intall-WingetPkg Microsoft.VisualStudioCode
Intall-WingetPkg 2203VeselinKaraganev.FancyWM_9x2ndwrcmyd2c
Intall-WingetPkg 46932SUSE.openSUSETumbleweed_022rs5jcyhyac
Intall-WingetPkg 7zip.7zip
Intall-WingetPkg voidtools.Everything

Write-Header "Installing scoop packages..."
scoop bucket add main
scoop install gsudo
scoop install bat
scoop install ripgrep
scoop install fzf

Write-Header "Installing powershell modules"
Install-Module -Name PowerShellGet -Force
Install-Module ZLocation
Install-Module -Name PSFzf

Write-Header "Setting up gsudo"
gsudo config CacheMode auto

if (Check-Command "wsl")
{
	Write-Header "Setting WSL 2 as default version"
	wsl --set-default-version 2
}