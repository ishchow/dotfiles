#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#UseHook
#InstallKeybdHook
#SingleInstance force
#Include %A_ScriptDir%\komorebic.lib.ahk

KomorebicExists()
{
	Run, komorebic.exe --version, , Hide, UseErrorLevel
	return Errorlevel == 0
}

HardResetKomorebic()
{
	RunWait, komorebic.exe stop, , Hide
	Sleep, 5000
	RunWait, komorebic.exe restore-windows, , Hide
	Sleep, 5000
	RunWait, komorebic.exe stop, , Hide
}

if (KomorebicExists())
{
	; Default to minimizing windows when switching workspaces
	WindowHidingBehaviour("minimize")

	; Enable hot reloading of changes to this file
	WatchConfiguration("enable")

	; TODO: Figure out how to do this in a loop
	; Ensure 10 workspaces are created on every monitor
	EnsureWorkspaces(0, 10)
	EnsureWorkspaces(1, 10)
	EnsureWorkspaces(2, 10)
	EnsureWorkspaces(3, 10)
	EnsureWorkspaces(4, 10)
	EnsureWorkspaces(5, 10)
	EnsureWorkspaces(6, 10)
	EnsureWorkspaces(7, 10)
	EnsureWorkspaces(8, 10)
	EnsureWorkspaces(9, 10)

	; TODO: Figure out how to do this in a loop
	; Set padding around screen edges on every monitor
	WorkspacePadding(0, 0, 0)
	WorkspacePadding(0, 1, 0)
	WorkspacePadding(0, 2, 0)
	WorkspacePadding(0, 3, 0)
	WorkspacePadding(0, 4, 0)
	WorkspacePadding(0, 5, 0)
	WorkspacePadding(0, 6, 0)
	WorkspacePadding(0, 7, 0)
	WorkspacePadding(0, 8, 0)
	WorkspacePadding(0, 9, 0)
	WorkspacePadding(1, 0, 0)
	WorkspacePadding(1, 1, 0)
	WorkspacePadding(1, 2, 0)
	WorkspacePadding(1, 3, 0)
	WorkspacePadding(1, 4, 0)
	WorkspacePadding(1, 5, 0)
	WorkspacePadding(1, 6, 0)
	WorkspacePadding(1, 7, 0)
	WorkspacePadding(1, 8, 0)
	WorkspacePadding(1, 9, 0)
	WorkspacePadding(2, 0, 0)
	WorkspacePadding(2, 1, 0)
	WorkspacePadding(2, 2, 0)
	WorkspacePadding(2, 3, 0)
	WorkspacePadding(2, 4, 0)
	WorkspacePadding(2, 5, 0)
	WorkspacePadding(2, 6, 0)
	WorkspacePadding(2, 7, 0)
	WorkspacePadding(2, 8, 0)
	WorkspacePadding(2, 9, 0)
	WorkspacePadding(3, 0, 0)
	WorkspacePadding(3, 1, 0)
	WorkspacePadding(3, 2, 0)
	WorkspacePadding(3, 3, 0)
	WorkspacePadding(3, 4, 0)
	WorkspacePadding(3, 5, 0)
	WorkspacePadding(3, 6, 0)
	WorkspacePadding(3, 7, 0)
	WorkspacePadding(3, 8, 0)
	WorkspacePadding(3, 9, 0)
	WorkspacePadding(4, 0, 0)
	WorkspacePadding(4, 1, 0)
	WorkspacePadding(4, 2, 0)
	WorkspacePadding(4, 3, 0)
	WorkspacePadding(4, 4, 0)
	WorkspacePadding(4, 5, 0)
	WorkspacePadding(4, 6, 0)
	WorkspacePadding(4, 7, 0)
	WorkspacePadding(4, 8, 0)
	WorkspacePadding(4, 9, 0)
	WorkspacePadding(5, 0, 0)
	WorkspacePadding(5, 1, 0)
	WorkspacePadding(5, 2, 0)
	WorkspacePadding(5, 3, 0)
	WorkspacePadding(5, 4, 0)
	WorkspacePadding(5, 5, 0)
	WorkspacePadding(5, 6, 0)
	WorkspacePadding(5, 7, 0)
	WorkspacePadding(5, 8, 0)
	WorkspacePadding(5, 9, 0)
	WorkspacePadding(6, 0, 0)
	WorkspacePadding(6, 1, 0)
	WorkspacePadding(6, 2, 0)
	WorkspacePadding(6, 3, 0)
	WorkspacePadding(6, 4, 0)
	WorkspacePadding(6, 5, 0)
	WorkspacePadding(6, 6, 0)
	WorkspacePadding(6, 7, 0)
	WorkspacePadding(6, 8, 0)
	WorkspacePadding(6, 9, 0)
	WorkspacePadding(7, 0, 0)
	WorkspacePadding(7, 1, 0)
	WorkspacePadding(7, 2, 0)
	WorkspacePadding(7, 3, 0)
	WorkspacePadding(7, 4, 0)
	WorkspacePadding(7, 5, 0)
	WorkspacePadding(7, 6, 0)
	WorkspacePadding(7, 7, 0)
	WorkspacePadding(7, 8, 0)
	WorkspacePadding(7, 9, 0)
	WorkspacePadding(8, 0, 0)
	WorkspacePadding(8, 1, 0)
	WorkspacePadding(8, 2, 0)
	WorkspacePadding(8, 3, 0)
	WorkspacePadding(8, 4, 0)
	WorkspacePadding(8, 5, 0)
	WorkspacePadding(8, 6, 0)
	WorkspacePadding(8, 7, 0)
	WorkspacePadding(8, 8, 0)
	WorkspacePadding(8, 9, 0)
	WorkspacePadding(9, 0, 0)
	WorkspacePadding(9, 1, 0)
	WorkspacePadding(9, 2, 0)
	WorkspacePadding(9, 3, 0)
	WorkspacePadding(9, 4, 0)
	WorkspacePadding(9, 5, 0)
	WorkspacePadding(9, 6, 0)
	WorkspacePadding(9, 7, 0)
	WorkspacePadding(9, 8, 0)
	WorkspacePadding(9, 9, 0)

	; Configure the invisible border dimensions
	InvisibleBorders(7, 0, 14, 7)

	; Configure floating rules
	FloatRule("class", "SunAwtDialog") ; All the IntelliJ popups
	FloatRule("title", "Control Panel")
	FloatRule("class", "TaskManagerWindow")
	FloatRule("exe", "Wally.exe")
	FloatRule("exe", "wincompose.exe")
	FloatRule("exe", "1Password.exe")
	FloatRule("exe", "Wox.exe")
	FloatRule("exe", "ddm.exe")
	FloatRule("exe", "Steam.exe")
	FloatRule("class", "Chrome_RenderWidgetHostHWND") ; GOG Electron invisible overlay
	FloatRule("class", "CEFCLIENT")

	; Identify Minimize-to-Tray Applications
	IdentifyTrayApplication("exe", "Discord.exe")
	IdentifyTrayApplication("exe", "Spotify.exe")
	IdentifyTrayApplication("exe", "GalaxyClient.exe")
	IdentifyTrayApplication("exe", "Teams.exe")

	; Identify Electron applications with overflowing borders
	IdentifyBorderOverflow("exe", "Discord.exe")
	IdentifyBorderOverflow("exe", "Spotify.exe")
	IdentifyBorderOverflow("exe", "GalaxyClient.exe")
	IdentifyBorderOverflow("class", "ZPFTEWndClass")
	IdentifyBorderOverflow("exe", "Teams.exe")

	; Identify applications to be forcibly managed
	ManageRule("exe", "GalaxyClient.exe")
	ManageRule("exe", "code.exe")
	ManageRule("exe", "notepad.exe")
}

;; deactivate capslock completely
SetCapslockState, AlwaysOff

Capslock UP::
	if (A_PriorKey = "Capslock") {
		Send {Esc}
	}
return

;; modal shortcuts using CapsLock specifically for managing komorebi
#If GetKeyState("Capslock","P") and KomorebicExists() ;"P" means "pressed".
; Change focused windows. CapsLock + Alt + Vim keys
!h::Focus("left")
!j::Focus("down")
!k::Focus("up")
!l::Focus("right")

; Move the focused window in a given direction, CapsLock + Alt + Shift + Vim direction keys
!+h::Move("left")
!+j::Move("down")
!+k::Move("up")
!+l::Move("right")

; Resize window size along axis, CapsLock + Ctrl + Vim Keys
^h::ResizeAxis("horizontal", "decrease")
^j::ResizeAxis("vertical", "decrease")
^k::ResizeAxis("vertical", "increase")
^l::ResizeAxis("horizontal", "increase")

; Stack the focused window in a given direction, CapsLock + Alt + Shift + direction keys
!+Left::Stack("left")
!+Down::Stack("down")
!+Up::Stack("up")
!+Right::Stack("right")

; Focus next window in stack, CapsLock + ]
!]::CycleStack("next")

; Focus previous window in stack, CapsLock + [
![::CycleStack("previous")

; Unstack the focused window, CapsLock + Shift + D
+d::Unstack()

; Promote the focused window to the top of the tree, CapsLock + Shift + Enter
+Enter::Promote()

; Toggle monocle for the focused window, CapsLock + Shift + M
+m::ToggleMonocle()

; Force a retile if things get janky, CapsLock + Shift + R
+r::Retile()

; Hard reset komorebic if there are deadlocks, CapsLock + Ctrl + Alt + Shift + R
^!+r::HardResetKomorebic()

; Reload current ahk script, CapsLock + Alt + Shift + '
!+'::reload

; Float the focused window, CapsLock + Shift + F
+f::ToggleFloat()

; Toggle tiling on focused workspace, CapsLock + Alt + Shift + F
!+f::ToggleTiling()

; Flip layout on horizontal axis, CapsLock + Shift + ,
+,::FlipLayout("horizontal")

; Flip layout on vertical axis, CapsLock + Shift + .
+.::FlipLayout("vertical")

; Switch to an equal-width, max-height column layout on the main workspace, CapsLock + Alt + Shift + C
!+c::ChangeLayout("columns")

; Switch to the default bsp tiling layout on the main workspace, CapsLock + Alt + Shift + T
!+t::ChangeLayout("bsp")

; Cycle focus to next window. CapsLock + Alt + N
!n::CycleFocus("next")

; Cycle focus to previous window. CapsLock + Alt + B
!b::CycleFocus("previous")

; Cycle focus to next workspace. CapsLock + Shift + N
+n::CycleWorkspace("next")

; Cycle focus to next previous workspace. CapsLock + Shift + N
+b::CycleWorkspace("previous")

; Cycle focus to next monitor. CapsLock + Ctrl + N
^n::CycleMonitor("next")

; Cycle focus to previous monitor. CapsLock + Ctrl + B
^b::CycleMonitor("previous")

; Switch to workspace, CapsLock + Alt + Number
!1::FocusWorkspace(0)
!2::FocusWorkspace(1)
!3::FocusWorkspace(2)
!4::FocusWorkspace(3)
!5::FocusWorkspace(4)
!6::FocusWorkspace(5)
!7::FocusWorkspace(6)
!8::FocusWorkspace(7)
!9::FocusWorkspace(8)
!0::FocusWorkspace(9)

; Send focused window to workspace, CapsLock + Shift + Number
+1::SendToWorkspace(0)
+2::SendToWorkspace(1)
+3::SendToWorkspace(2)
+4::SendToWorkspace(3)
+5::SendToWorkspace(4)
+6::SendToWorkspace(5)
+7::SendToWorkspace(6)
+8::SendToWorkspace(7)
+9::SendToWorkspace(8)
+0::SendToWorkspace(9)

; Move focused window to workspace (basically SendToWorkspace() + FocusWorkspace()), CapsLock + Alt + Shift + Number
!+1::MoveToWorkspace(0)
!+2::MoveToWorkspace(1)
!+3::MoveToWorkspace(2)
!+4::MoveToWorkspace(3)
!+5::MoveToWorkspace(4)
!+6::MoveToWorkspace(5)
!+7::MoveToWorkspace(6)
!+8::MoveToWorkspace(7)
!+9::MoveToWorkspace(8)
!+0::MoveToWorkspace(9)

; Switch to monitor, CapsLock + Win + Number
#1::FocusMonitor(0)
#2::FocusMonitor(1)
#3::FocusMonitor(2)
#4::FocusMonitor(3)
#5::FocusMonitor(4)
#6::FocusMonitor(5)
#7::FocusMonitor(6)
#8::FocusMonitor(7)
#9::FocusMonitor(8)
#0::FocusMonitor(9)

; Send focused window to monitor, CapsLock + Ctrl + Number
^1::SendToMonitor(0)
^2::SendToMonitor(1)
^3::SendToMonitor(2)
^4::SendToMonitor(3)
^5::SendToMonitor(4)
^6::SendToMonitor(5)
^7::SendToMonitor(6)
^8::SendToMonitor(7)
^9::SendToMonitor(8)
^0::SendToMonitor(9)

; Move focused window to workspace (basically SendToMonitor() + FocusMonitor()), CapsLock + Win + Ctrl + Number
#^1::MoveToMonitor(0)
#^2::MoveToMonitor(1)
#^3::MoveToMonitor(2)
#^4::MoveToMonitor(3)
#^5::MoveToMonitor(4)
#^6::MoveToMonitor(5)
#^7::MoveToMonitor(6)
#^8::MoveToMonitor(7)
#^9::MoveToMonitor(8)
#^0::MoveToMonitor(9)
#If

; modal shortcuts using CapsLock
#If GetKeyState("Capslock","P") ;"P" means "pressed".
; Kill application/window. CapsLock + W
w::!F4

; CapsLock + any unhandled key combo + vim keys to key combo + arrow keys.
; * is the wildcard prefix, it matches any key combo. {Blind} is the wildcard key combo.
; Example: Can use CapsLock + Vim keys to navigate as if using arrow keys.
; Example: Can use CapsLock + Shift + Vim keys to select text in specified direction by character.
; Example: Can use CapsLock + Ctrl + Shift + Vim keys to select text in specified direction by word.
; Note: I think this has to go last after all other bindings with hjkl since we use hjkl in many other key combos earlier in the script.
*h::Send,{Blind}{Left}
*l::Send,{Blind}{Right}
*k::Send,{Blind}{Up}
*j::Send,{Blind}{Down}

; CapsLock + any unhandled key combo + yuio to key combo + Home/Page Down/Page Up/End.
*y::Send,{Blind}{Home}
*u::Send,{Blind}{PgDn}
*i::Send,{Blind}{PgUp}
*o::Send,{Blind}{End}
#If