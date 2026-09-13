#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

A_IconTip := "UltraMic"
TraySetIcon(A_ScriptDir "\ultramic.ico")
A_TrayMenu.Add()
A_TrayMenu.Add("Microsoft Edge", (*) => Run("msedge.exe"))
A_TrayMenu.Add("Google Chrome", (*) => Run("chrome.exe"))
A_TrayMenu.Add()
A_TrayMenu.Add("StatDx", (*) => Run("https://my.StatDx.com"))
A_TrayMenu.Add("qGenda", (*) => Run("https://www.qgenda.com/"))

;hidden window to receive WM_INPUT
win := Gui()

;register usage page 1 (PowerMic), but skip mice and keyboards
size := 8 + A_PtrSize
devices := Buffer(size * 3, 0)
AddDevice(0, 1, 0, 0x120, win.Hwnd)  ;RIDEV_PAGEONLY + RIDEV_INPUTSINK
AddDevice(1, 1, 2, 0x10, 0)          ;RIDEV_EXCLUDE mice
AddDevice(2, 1, 6, 0x10, 0)          ;RIDEV_EXCLUDE keyboards
DllCall("RegisterRawInputDevices", "Ptr", devices, "UInt", 3, "UInt", size)

AddDevice(i, usagePage, usage, flags, hwnd) {
	NumPut("UShort", usagePage, "UShort", usage, "UInt", flags, "Ptr", hwnd, devices, i * size)
}

OnMessage(0x00FF, InputMsg)  ;WM_INPUT

InputMsg(wParam, lParam, *)
{
	static held := 0
	static header := 8 + 2 * A_PtrSize
	Critical

	;get the raw input
	rawSize := 0
	DllCall("GetRawInputData", "Ptr", lParam, "UInt", 0x10000003, "Ptr", 0, "UIntP", &rawSize, "UInt", header)
	raw := Buffer(rawSize, 0)
	if DllCall("GetRawInputData", "Ptr", lParam, "UInt", 0x10000003, "Ptr", raw, "UIntP", &rawSize, "UInt", header) != rawSize
		return

	if NumGet(raw, 0, "UInt") != 2 || !IsPowerMic(NumGet(raw, 8, "Ptr"))
		return  ;not a PowerMic

	;get the keycode
	key := NumGet(raw, header + 8, "UInt")
	; uncomment the line below to be alerted of the key
	; MsgBox(key)

	;only buttons that just went down
	pressed := key & ~held
	held := key

	if (pressed & 8388608) ; If the left dot on the Powermic is clicked
	{
		Send("^c")
	}

	if (pressed & 33554432) ; If the right dot on the Powermic is clicked
	{
		if WinActive("ahk_exe msedge.exe")
		{
			Send("^v")
		}
	}
}

;Nuance PowerMic II and III are both VID 1364 / PID 4097
IsPowerMic(device)
{
	info := Buffer(32, 0)
	NumPut("UInt", 32, info)
	infoSize := 32
	DllCall("GetRawInputDeviceInfoW", "Ptr", device, "UInt", 0x2000000b, "Ptr", info, "UIntP", &infoSize)
	return NumGet(info, 8, "UInt") = 1364 && NumGet(info, 12, "UInt") = 4097
}



/*


+----------------------------------+
|              Nuance              |
|                                  |
|+--------+             +--------+ |
||  Back  | +--------+  |  FWD   | |
|| 131072 | |Dictate |  | 524288 | |
|+--------+ | 262144 |  +-------+| |
|           +--------+             |
|+--------+             +---------+|
|| Rewind | +--------+  |  FFWD   ||
|| 1048576| |  Stop  |  | 2097152 ||
|+--------+ |4194304 |  +--------+||
|           +--------+             |
|                                  |
|+--------+ +--------+  +---------+|
|| L DOT  | | Check  |  | R DOT   ||
|| 8388608| |16777216|  | 33554432||
|+--------+ +------- +  +--------+||
|                                  |
|+--------+  +-------+  +---------+|
||L MOUSE |  | MOUSE |  |R MOUSE  ||
||67108864|  +-------+  |134217728||
|+--------+             +---------+|
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
|                                  |
+----------------------------------+

Transcribe 65536
Back 131072
Forward 524288
Record 262144
Reverse 1048576
FForward 2097152
Stop 4194304
Left Dot 8388608
Check 16777216
Right Dot 33554432
Left mouse 67108864 (PowerMic III)
Right mouse 134217728 (PowerMic III)

*/
