#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#UseHook
#InstallKeybdHook
#SingleInstance force

; Deactivate capslock completely.
; Needs to be at top of file and defined before all other keybindings
; and all includes. Otherwise, capslock might be able to be activated.
SetCapslockState, AlwaysOff

; Disable Windows 10 Show Desktop Button
Control, Hide, , TrayShowDesktopButtonWClass1, ahk_class Shell_TrayWnd

#Include %A_ScriptDir%\lib\mouse_cursor_follows_focus.ahk
#Include %A_ScriptDir%\lib\modal_capslock.ahk