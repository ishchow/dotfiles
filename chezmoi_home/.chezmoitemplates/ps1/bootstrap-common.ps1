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

$ErrorActionPreference = "Stop"