; This only works for horizontally arranged monitors.
GetVirtualScreen()
{
	VirtualScreen := {}

	SysGet, VirtualScreenLeft, 76
	SysGet, VirtualScreenTop, 77
	SysGet, VirtualScreenWidth, 78
	SysGet, VirtualScreenHeight, 79
	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary

	VirtualScreen.Left := VirtualScreenLeft
	VirtualScreen.Top := VirtualScreenTop
	VirtualScreen.Width := VirtualScreenWidth
	VirtualScreen.Height := VirtualScreenHeight
	VirtualScreen.MonitorPrimary := MonitorPrimary
	VirtualScreen.MonitorCount := MonitorCount

	VirtualScreen.Monitors := []
	MonitorsLength := 0

	Loop % MonitorCount
	{
		SysGet, MonitorName, MonitorName, %A_Index%
		SysGet, Monitor, Monitor, %A_Index%
        SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%

		CurrentMonitor := {}
		CurrentMonitor.Name := MonitorName
		CurrentMonitor.Index := A_Index
		CurrentMonitor.Left := MonitorLeft
		CurrentMonitor.Top := MonitorTop
		CurrentMonitor.Right := MonitorRight
		CurrentMonitor.Bottom := MonitorBottom
        CurrentMonitor.WorkAreaLeft := MonitorWorkAreaLeft
        CurrentMonitor.WorkAreaTop := MonitorWorkAreaTop
        CurrentMonitor.WorkAreaRight := MonitorWorkAreaRight
        CurrentMonitor.WorkAreaBottom := MonitorWorkAreaBottom

		VirtualScreen.Monitors.Push(CurrentMonitor)
		MonitorsLength += 1

		MonitorsSliceLength := MonitorsLength - 1
		Loop % MonitorsSliceLength
		{
			if (VirtualScreen.Monitors[A_Index].Left > VirtualScreen.Monitors[A_Index + 1].Left)
			{
				Tmp := VirtualScreen.Monitors[A_Index]
				VirtualScreen.Monitors[A_Index] := VirtualScreen.Monitors[A_Index + 1]
				VirtualScreen.Monitors[A_Index + 1] := Tmp
			}
		}
	}

	return VirtualScreen
}

GetMousePositionOnScreen()
{
	Mouse := {}
	Coordmode, Mouse, Screen
	MouseGetPos, MouseX, MouseY, MouseActiveWindowHandle, MouseControlClass 
	Mouse.X := MouseX
	Mouse.Y := MouseY
	Mosue.WindowHandle := MouseActiveWindowHandle
	Mouse.ControlClass := MouseControlClass
	return Mouse
}

IsMouseIsOnMonitor(Mouse, Monitor)
{
    return Mouse.X >= Monitor.Left
        and Mouse.X <= Monitor.Right
        and Mouse.Y >= Monitor.Top
        and Mouse.Y <= Monitor.Bottom
}

MoveMouseToCenterOfMonitor(Mouse, Monitor)
{
    NewMouseX := Monitor.Left + 0.5 * (Monitor.Right - Monitor.Left)
    NewMouseY := Monitor.Top + 0.5 * (Monitor.Bottom - Monitor.Top) 

    Coordmode, Mouse, Screen
    
    ; This works better than MouseMove for some reason.
    ; MouseMove doesn't seem to center mouse on screen properly.
    DllCall("SetCursorPos", int, NewMouseX, int, NewMouseY)
}

MoveMouseToMonitorInDirection(Direction)
{
    VirtualScreen := GetVirtualScreen()
    Mouse := GetMousePositionOnScreen()

    if (VirtualScreen.MonitorCount == 1)
    {
        ;MsgBox, "Only one monitor, nothing to do!"
        return
    }

    Loop % VirtualScreen.MonitorCount
    {
        Monitor := VirtualScreen.Monitors[A_Index]

        if (IsMouseIsOnMonitor(Mouse, Monitor))
        {
            NewMonitorIndex := A_Index

            if (Direction == "right" and (A_Index < VirtualScreen.MonitorCount))
            {
                NewMonitorIndex += 1
            }
            else if (Direction == "right")
            {
                NewMonitorIndex := 1
            }
            else if (Direction == "left" and (A_Index > 1))
            {
                NewMonitorIndex -= 1
            }
            else if (Direction == "left")
            {
                NewMonitorIndex := VirtualScreen.MonitorCount
            }

            ;MsgStr := Format("Direction:`t{1}`nA_Index:`t{2}`nNewMonitorIndex:`t{3}", Direction, A_Index, NewMonitorIndex)
            ;MsgBox, %MsgStr%

            if (NewMonitorIndex != A_Index)
            {
                NewMonitor := VirtualScreen.Monitors[NewMonitorIndex]
                MoveMouseToCenterOfMonitor(Mouse, NewMonitor)
            }
            else
            {
                ;MsgBox, "No monitor in specified direction"
            }

            break
        }
    }
}

ShowRawVirtualScreenInfo()
{
	SysGet, VirtualScreenLeft, 76
	SysGet, VirtualScreenTop, 77
	SysGet, VirtualScreenWidth, 78
	SysGet, VirtualScreenHeight, 79
	MsgBox, VirtualScreenLeft:`t%VirtualScreenLeft%`nVirtualScreenTop:`t%VirtualScreenTop%`nVirtualScreenWidth:`t%VirtualScreenWidth%`nVirtualScreenHeight:`t%VirtualScreenHeight%

	SysGet, MonitorCount, MonitorCount
	SysGet, MonitorPrimary, MonitorPrimary
	MsgBox, Monitor Count:`t%MonitorCount%`nPrimary Monitor:`t%MonitorPrimary%
	Loop, %MonitorCount%
	{
		SysGet, MonitorName, MonitorName, %A_Index%
		SysGet, Monitor, Monitor, %A_Index%
		SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
		MsgBox, Monitor:`t#%A_Index%`nName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
	}
}

ShowMousePosition()
{
	Mouse := GetMousePositionOnScreen()
	MsgStr := Format("The cursor is at X{1} Y{2}", Mouse.X, Mouse.Y)
	MsgBox, %MsgStr%.
}

ShowVirtualScreen()
{
	VirtualScreen := GetVirtualScreen()
	MsgStr := Format("VirtualScreenLeft:`t{1}`nVirtualScreenTop:`t{2}`nVirtualScreenWidth:`t{3}`nVirtualScreenHeight:`t{4}`nMonitorCount:`t{5}`nMonitorPrimary:`t{6}", VirtualScreen.Left, VirtualScreen.Top, VirtualScreen.Width, VirtualScreen.Height, VirtualScreen.MonitorCount, VirtualScreen.MonitorPrimary)
	MsgBox, %MsgStr%

	Loop % VirtualScreen.MonitorCount
	{
		Monitor := VirtualScreen.Monitors[A_Index]
		MsgStr := Format("Index:`t{1}`nMonitorName:{2}`t`nMonitorIndex:`t{3}`nMonitorLeft:`t{4}`nMonitorTop:`t{5}`nMonitorRight:`t{6}`nMonitorBottom:`t{7}`nWorkAreaLeft:`t{8}`nWorkAreaTop:`t{9}`nWorkAreaRight:`t{10}`nWorkAreBottom:`t{11}"
            , A_Index
            , Monitor.Name
            , Monitor.Index
            , Monitor.Left
            , Monitor.Top
            , Monitor.Right
            , Monitor.Bottom
            , Monitor.WorkAreaLeft
            , Monitor.WorkAreaTop
            , Monitor.WorkAreaRight
            , Monitor.WorkAreaBottom)
		MsgBox, %MsgStr%
	}
}