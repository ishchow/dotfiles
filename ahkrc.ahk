#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#UseHook
#InstallKeybdHook
#SingleInstance force

;; deactivate capslock completely
SetCapslockState, AlwaysOff

Capslock UP::
	if (A_PriorKey = "Capslock") {
		Send {Esc}
	}
return

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