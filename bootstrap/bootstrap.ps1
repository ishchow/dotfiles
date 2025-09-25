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

Write-Header "Installing winget packages"
winget import -i .\winget-packages.json

Write-Header "Installing powershell modules"
Install-Module -Name PowerShellGet -Force
Install-Module ZLocation
Install-Module -Name PSFzf

Write-Header "Adding Alt-Tab Terminator to PATH"
$p = [System.Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine)
if (!$p.Contains("C:\Program Files\Alt-Tab Terminator"))
{
    Write-Header "Adding Alt-Tab Terminator to path"
    $p += ";C:\Program Files\Alt-Tab Terminator"
    [System.Environment]::SetEnvironmentVariable('Path',$p,[System.EnvironmentVariableTarget]::Machine);
}

Write-Header "Setting neovim config symlink"
$symLinkPath = Join-Path $(Resolve-Path ~/AppData/Local).Path "nvim"
$actualNvimConfigPath = $(Resolve-Path ~/.local/share/chezmoi/home/.config/nvim).Path
if (!$(Test-Path $symLinkPath) -and $(Test-Path $actualNvimConfigPath))
{
    cmd /c mklink /d $symLinkPath $actualNvimConfigPath
}

Write-Header "Installing VS Code extensions"
if (Get-Command code)
{
    Get-Content ~/.local/share/chezmoi/misc/vscode/extensions.txt | ForEach-Object { Invoke-Expression "code --install-extension $_" }
}

Write-Header "Setup OpenSUSE Tumbleweed in WSL"
$wslDistros = wsl.exe -l -q
if ($wslDistros -contains "openSUSE-Tumbleweed")
{
    Write-Host "openSUSE Tumbleweed is already installed"
}
else
{
    Write-Host "Installing openSUSE-Tumbleweed"
    wsl --install --distribution openSUSE-Tumbleweed
}
