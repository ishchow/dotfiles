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
			Sleep, 200
			CoordMode, Mouse, Screen
			WinGetPos, wx, wy, width, height, A
			WinGet, processName, ProcessName, A

			; these processes send a lot of focus events and thus behave weirdly
			if (processName != "steam.exe")
			{
				; puts the cursor in middle of the active window, tweak to your needs
				mx := Round(wx + width * 0.50)
				my := Round(wy + height * 0.50)

				DllCall("SetCursorPos", int, mx, int, my)
			}
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