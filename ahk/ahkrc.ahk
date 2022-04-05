#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#UseHook
#InstallKeybdHook
#SingleInstance force

; Makes the mouse cursor follow window focus, but ONLY if the focus change
; wasn't caused by the mouse - e.g. Alt-Tab, Win+<Number>, hotkeys, ...
; Saves a lot of mousing around on multi-monitor setups!
; Source: https://gist.githubusercontent.com/bladeSk/9feeeb6c2ba9939faa3c88cc9133700c/raw/cabc86477ca9bc23856cf84146ecc55eda74ff32/mouse%2520cursor%2520follows%2520focus.ahk

Gui +LastFound 

lastMouseClickTime := 0
hWnd := WinExist()

DllCall("RegisterShellHookWindow", UInt, hWnd)
msgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
OnMessage(msgNum, "OnShellMessage")
OnMessage(WM_MOUSEMOVE:=0x0201, "OnMouseDown")
Return

OnShellMessage( wParam, lParam )
{
	global
	; HSHELL_WINDOWACTIVATED | HSHELL_RUDEAPPACTIVATED
	If (wParam = 4 or wParam = 32772) {
		; ignore when dragging
		GetKeyState, mouseDown, LButton
		if (mouseDown <> "D" and A_TickCount - lastMouseClickTime > 500) {
			; delay a tiny bit to ignore taskbar focus on Win+Number switching
			Sleep, 100
			CoordMode, Mouse, Screen
			WinGetPos, wx, wy, width, height, A

			; puts the cursor in middle of the active window, tweak to your needs
			mx := Round(wx + width * 0.50)
			my := Round(wy + height * 0.50)

			DllCall("SetCursorPos", int, mx, int, my)
		}
	}
}

*~LButton::
	lastMouseClickTime := A_TickCount
Return

*~RButton::
	lastMouseClickTime := A_TickCount
Return

*~MButton::
	lastMouseClickTime := A_TickCount
Return

; Disable Windows 10 Show Desktop Button
Control, Hide, , TrayShowDesktopButtonWClass1, ahk_class Shell_TrayWnd

;; deactivate capslock completely
SetCapslockState, AlwaysOff

Capslock UP::
	if (A_PriorKey = "Capslock") {
		Send {Esc}
	}
return

; modal shortcuts using CapsLock
#If GetKeyState("Capslock","P") ;"P" means "pressed".

; Move the focused window out of its containing panel. CapsLock + Shift + Enter
+Enter::RunWait, fancywm.exe --action PullWindowUp, , Hide

; Change focused windows. CapsLock + Alt + Vim keys
!h::RunWait, fancywm.exe --action MoveFocusLeft, , Hide
!j::RunWait, fancywm.exe --action MoveFocusDown, , Hide
!k::RunWait, fancywm.exe --action MoveFocusUp, , Hide
!l::RunWait, fancywm.exe --action MoveFocusRight, , Hide

; Move the focused window in a given direction. CapsLock + Alt + Shift + Vim direction keys
!+h::RunWait, fancywm.exe --action MoveLeft, , Hide
!+j::RunWait, fancywm.exe --action MoveDown, , Hide
!+k::RunWait, fancywm.exe --action MoveUp, , Hide
!+l::RunWait, fancywm.exe --action MoveRight, , Hide

; Embed the focused window in a panel. CapsLock + Shift + {,./}
+,::RunWait, fancywm.exe --action CreateHorizontalPanel, , Hide
+.::RunWait, fancywm.exe --action CreateVerticalPanel, , Hide
+/::RunWait, fancywm.exe --action CreateStackPanel, , Hide

; Change the width/height of the focused window. CapsLock + Ctrl + Vim keys
^h::RunWait, fancywm.exe --action DecreaseWidth, , Hide
^j::RunWait, fancywm.exe --action DecreaseHeight, , Hide
^k::RunWait, fancywm.exe --action IncreaseWidth, , Hide
^l::RunWait, fancywm.exe --action IncreaseHeight, , Hide

; Switch to the selected virtual desktop. CapsLock + Alt + Number
!1::RunWait, fancywm.exe --action SwitchToDesktop1, , Hide
!2::RunWait, fancywm.exe --action SwitchToDesktop2, , Hide
!3::RunWait, fancywm.exe --action SwitchToDesktop3, , Hide
!4::RunWait, fancywm.exe --action SwitchToDesktop4, , Hide
!5::RunWait, fancywm.exe --action SwitchToDesktop5, , Hide
!6::RunWait, fancywm.exe --action SwitchToDesktop6, , Hide
!7::RunWait, fancywm.exe --action SwitchToDesktop7, , Hide
!8::RunWait, fancywm.exe --action SwitchToDesktop8, , Hide
!9::RunWait, fancywm.exe --action SwitchToDesktop9, , Hide

; Send the focused window to the selected virtual desktop. CapsLock + Shift + Number
+1::RunWait, fancywm.exe --action MoveToDesktop1, , Hide
+2::RunWait, fancywm.exe --action MoveToDesktop2, , Hide
+3::RunWait, fancywm.exe --action MoveToDesktop3, , Hide
+4::RunWait, fancywm.exe --action MoveToDesktop4, , Hide
+5::RunWait, fancywm.exe --action MoveToDesktop5, , Hide
+6::RunWait, fancywm.exe --action MoveToDesktop6, , Hide
+7::RunWait, fancywm.exe --action MoveToDesktop7, , Hide
+8::RunWait, fancywm.exe --action MoveToDesktop8, , Hide
+9::RunWait, fancywm.exe --action MoveToDesktop9, , Hide

; Move focused window to workspace (basically MoveToDesktopX + SwitchToDesktopX), CapsLock + Alt + Shift + Number
!+1::
RunWait, fancywm.exe --action MoveToDesktop1, , Hide
RunWait, fancywm.exe --action SwitchToDesktop1, , Hide
return

!+2::
RunWait, fancywm.exe --action MoveToDesktop2, , Hide
RunWait, fancywm.exe --action SwitchToDesktop2, , Hide
return

!+3::
RunWait, fancywm.exe --action MoveToDesktop3, , Hide
RunWait, fancywm.exe --action SwitchToDesktop3, , Hide
return

!+4::
RunWait, fancywm.exe --action MoveToDesktop4, , Hide
RunWait, fancywm.exe --action SwitchToDesktop4, , Hide
return

!+5::
RunWait, fancywm.exe --action MoveToDesktop5, , Hide
RunWait, fancywm.exe --action SwitchToDesktop5, , Hide
return

!+6::
RunWait, fancywm.exe --action MoveToDesktop6, , Hide
RunWait, fancywm.exe --action SwitchToDesktop6, , Hide
return

!+7::
RunWait, fancywm.exe --action MoveToDesktop7, , Hide
RunWait, fancywm.exe --action SwitchToDesktop7, , Hide
return

!+8::
RunWait, fancywm.exe --action MoveToDesktop8, , Hide
RunWait, fancywm.exe --action SwitchToDesktop8, , Hide
return

!+9::
RunWait, fancywm.exe --action MoveToDesktop9, , Hide
RunWait, fancywm.exe --action SwitchToDesktop9, , Hide
return

; Toggle floating mode for the active window.
+f::RunWait, fancywm.exe --action ToggleFloatingMode, , Hide

; Temporarily toggle the window management functionality in FancyWM.
!+f::RunWait, fancywm.exe --action ToggleManager, , Hide

; Manually refresh the window positions.
+r::RunWait, fancywm.exe --action RefreshWorkspace, , Hide

; Reload current ahk script, CapsLock + Alt + Shift + '
!+'::reload

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