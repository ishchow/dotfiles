#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#UseHook
#InstallKeybdHook
#SingleInstance force

#Include %A_ScriptDir%\Lib\mouse_cursor_follows_focus.ahk

SetTimer, ReloadScript,% 30*1000 ;30 seconds

ReloadScript()
{
	Reload
}