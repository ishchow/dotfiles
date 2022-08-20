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
winget install gerardog.gsudo
winget install -e --id voidtools.Everything
winget install 7zip.7zip

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
	
	$isTumbleweedInstalled = @(@(wsl -l -q) |? { $_ -eq "openSUSE-Tumbleweed" }).Count -eq 0
	if ($isTumbleweedInstalled)
	{
		Write-Header "Installing the latest openSUSE Tumbleweed WSL from OBS"
		
		$appxPath = ".\tumbleweed-latest.Appx"
		
		if (!$(Test-Path -Path $appxPath))
		{		
			$baseUrl = "https://download.opensuse.org/tumbleweed/appliances/"
			$resp =  $r = iwr $baseUrl -UseBasicParsing
			$appx = $($resp.Links | ?{$_.href -Match "-WSL.x86_64.appx$"})[0].href
			$appxUrl = -join($baseUrl, $appx)

			$progresspreference = 'silentlyContinue'
			iwr $appxUrl -OutFile $appxPath
			$progressPreference = 'Continue'	
		}

		$certPath = ".\tumbleweed-latest.cer"
		if (!$(Test-Path -Path $certPath))
		{
			$cert = $(Get-AuthenticodeSignature -FilePath $appxPath).SignerCertificate
			Export-Certificate -Cert $cert -FilePath $certPath -Type CERT
		}
	
		Import-Certificate -FilePath $certPath -CertStoreLocation Cert:\LocalMachine\Root
		Add-AppxPackage $appxPath
		$installDir = $(Get-AppxPackage | ?{$_.Name -match "Tumbleweed"})[0].InstallLocation
		Start-Process -FilePath $(Join-Path $installDir "openSUSE-Tumbleweed") -Wait
		rm $appxPath
		rm $certPath
	}
}