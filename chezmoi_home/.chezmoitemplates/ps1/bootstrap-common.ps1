function Write-Header($header)
{
    Write-Host "------------------------------------" -ForegroundColor Green
    Write-Host $header -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
}

function New-Symlink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SymLinkPath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

        [switch]$IsDirectory
    )

    # Resolve full paths
    $resolvedSymLinkPath = Resolve-Path -LiteralPath $SymLinkPath -ErrorAction SilentlyContinue
    $resolvedTargetPath = Resolve-Path -LiteralPath $TargetPath -ErrorAction SilentlyContinue

    if (-not $resolvedTargetPath) {
        Write-Warning "Target path '$TargetPath' does not exist. Cannot create symlink."
        return
    }

    if ($resolvedSymLinkPath) {
        Write-Host "Symlink already exists at '$SymLinkPath'. Skipping creation."
        return
    }

    # Determine type of link
    if ($IsDirectory) {
        $linkType = "/D"
    } else {
        $linkType = ""
    }

    # Create the symlink using cmd /c mklink
    Write-Host "Creating symbolic link:"
    Write-Host "  Link:    $SymLinkPath"
    Write-Host "  Target:  $resolvedTargetPath"
    cmd /c "mklink $linkType `"$SymLinkPath`" `"$($resolvedTargetPath.Path)`"" | Out-Null

    if ($?) {
        Write-Host "Symlink created successfully."
    } else {
        Write-Warning "Failed to create symlink. You may need to run PowerShell as Administrator."
    }
}

$ErrorActionPreference = "Stop"