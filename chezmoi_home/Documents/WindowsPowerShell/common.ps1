# ------------------------------------------------------------------------------------------------------------------------
# Common Settings
# ------------------------------------------------------------------------------------------------------------------------

# Disable PS7.3+ behaviour where non-zero native exit codes throw
# NativeCommandExitException. Too noisy with tools like git, zoxide, etc.
$PSNativeCommandUseErrorActionPreference = $false

Import-Module PSReadLine

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# In Emacs mode - Tab acts like in bash, but the Windows style completion
# is still useful sometimes, so bind some keys so we can do both
Set-PSReadLineKeyHandler -Key Ctrl+q -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+Q -Function TabCompletePrevious

# Clipboard interaction is bound by default in Windows mode, but not Emacs mode.
Set-PSReadLineKeyHandler -Key Ctrl+C -Function Copy
Set-PSReadLineKeyHandler -Key Ctrl+v -Function Paste

# ------------------------------------------------------------------------------------------------------------------------
# Integrations with External Tools
# ------------------------------------------------------------------------------------------------------------------------

# mise (runtime version manager) activation — must come first so that
# tools installed via mise (zoxide, fzf, starship, etc.) are on PATH
# before we try to initialise them.
if (Get-Command mise -ErrorAction SilentlyContinue) {
    $__misePath = (Get-Command mise -CommandType Application).Source
    $__miseActivate = (& "$__misePath" activate pwsh | Out-String)
    # Fix unquoted exe paths containing spaces (mise bug)
    $__miseActivate = $__miseActivate -replace "& $([regex]::Escape($__misePath))", "& `"$__misePath`""
    Invoke-Expression $__miseActivate
    Remove-Variable __misePath, __miseActivate
}

# NOTE: In PS7.3+, $PSNativeCommandUseErrorActionPreference defaults to $true,
# which causes zoxide's non-zero exit codes (e.g. "no match found") to throw a
# NativeCommandExitException. This is a known zoxide issue — their PowerShell
# init script doesn't account for it. The error is cosmetic and only appears
# when the zoxide database has no match for the query.
if (Get-Command zoxide -ErrorAction "silentlycontinue")
{
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if (Get-Command fzf -ErrorAction "silentlycontinue")
{
    Import-Module -Name PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
}

if (Get-Command starship -ErrorAction "silentlycontinue")
{
    Invoke-Expression (&starship init powershell)
}
# ------------------------------------------------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------------------------------------------------
function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
    $Notifier.Show($Toast);
}

function Remove-StaleBranches
{
   git fetch --prune
   git branch -vv | Select-String ': gone]' | ForEach-Object { ($_ -split '\s+')[1] } | ForEach-Object { git branch -D $_ }
}

# ------------------------------------------------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------------------------------------------------

Set-Alias -Name gprnlcl -Value Remove-StaleBranches