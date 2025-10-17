# Throw if run as admin
if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { throw "Cannot run the bootstrap script as Admin!" }

sudo powershell.exe -File "$($PSScriptRoot)\001_basic_setup.ps1"
sudo powershell.exe -File "$($PSScriptRoot)\002_setup_ssh.ps1"
sudo powershell.exe -File "$($PSScriptRoot)\003_setup_ps_profile.ps1"
sudo powershell.exe -File "$($PSScriptRoot)\004_start_sshd.ps1"
powershell.exe -File "$($PSScriptRoot)\005_install_packages.ps1"
sudo powershell.exe -File "$($PSScriptRoot)\006_setup_path.ps1"
sudo powershell.exe -File "$($PSScriptRoot)\007_setup_wsl.ps1"
sudo powershell.exe -File "$($PSScriptRoot)\008_setup_kanata.ps1"
sudo powershell.exe -File "$($PSScriptRoot)\009_install_ahk_v1.ps1"