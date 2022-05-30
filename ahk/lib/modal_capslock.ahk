#Include %A_LineFile%\..\Common\screen_utils.ahk

Capslock UP::
	if (A_PriorKey = "Capslock") {
		Send {Esc}
	}
return

; modal shortcuts using CapsLock
#If GetKeyState("Capslock","P") ;"P" means "pressed".

; Turn caps lock off in case it was turned on. CapsLock + Ctrl + Shift + Alt + Win + C.
^+!#c::SetCapslockState, off

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
^k::RunWait, fancywm.exe --action IncreaseHeight, , Hide
^l::RunWait, fancywm.exe --action IncreaseWidth, , Hide


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

; Toggle floating mode for the active window. CapsLock + Shift + F
+f::RunWait, fancywm.exe --action ToggleFloatingMode, , Hide

; Temporarily toggle the window management functionality in FancyWM. CapsLock + Alt + Shift + F
!+f::RunWait, fancywm.exe --action ToggleManager, , Hide

; Manually refresh the window positions. CapsLock + Shift + R.
+r::RunWait, fancywm.exe --action RefreshWorkspace, , Hide

; Reload current ahk script, CapsLock + Alt + Shift + '
!+'::reload

; Kill application/window. CapsLock + W
w::!F4

; Focus virtual desktop to the right. CapsLock + N
n::Send,^#{Right}

; Focus virtual desktop to left. CapsLock + B
b::Send,^#{Left}

; Move mouse to monitor on left. CapsLock + ,
,::MoveMouseToMonitorInDirection("left")

; Mouve mouse to monitor on right. CapsLock + .
.::MoveMouseToMonitorInDirection("right")

; Left click mouse. CapsLock + [
[::Click

; Right click mouse. CapsLock + ]
]::Click Right

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