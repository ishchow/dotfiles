$commonFile = "$HOME\Documents\WindowsPowerShell\common.ps1"
if (Test-Path $commonFile)
{
    . $commonFile
}