#SingleInstance Force
#include %A_ScriptDir%\lib\AHKHID.ahk
#Persistent
Menu, Tray, Tip, UltraMic
Menu, Tray, Icon, %A_ScriptDir%\ultramic.ico
Menu, Tray, Add
Menu, Tray, Add, Microsoft Edge, OpenEdge
Menu, Tray, Add, Google Chrome, OpenChrome
Menu, Tray, Add
Menu, Tray, Add, StatDx, OpenStatDx
Menu, Tray, Add, qGenda, OpenqGenda

OpenqGenda() { 
	Run, https://www.qgenda.com/ 
	}

OpenStatDx() { 
	Run, https://my.StatDx.com 
	}
	
OpenEdge() { 
	Run, msedge.exe 
	}
OpenChrome() { 
	Run, chrome.exe 
	}

Gui, +LastFound
GuiH := WinExist()
;SendMode, Input

;set input level to be able to activate hotkey of merge script
#InputLevel 0 

;Intercept WM_INPUT messages
WM_INPUT := 0x00FF
OnMessage(WM_INPUT, "InputMsg")

;register usage page 1 (PowerMic), but skip mice and keyboards
AHKHID_AddRegister(3)
AHKHID_AddRegister(1, 0, GuiH, RIDEV_INPUTSINK + RIDEV_PAGEONLY)
AHKHID_AddRegister(1, 2, 0, RIDEV_EXCLUDE)
AHKHID_AddRegister(1, 6, 0, RIDEV_EXCLUDE)
AHKHID_Register()

InputMsg(wParam, lParam)
{
	Local devh, key, pressed
	Static held := 0
	Critical    ;or otherwise you could get ERROR_INVALID_HANDLE

	;get handle of device
	devh := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)

	If (devh = -1)
        Or (AHKHID_GetDevInfo(devh, DI_DEVTYPE, True) != RIM_TYPEHID)
        Or (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) != 1364)
        Or (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) != 4097)
		Return  ;not a PowerMic

	;get the keycode
	key := AHKHID_GetInputInfo(lParam, II_MSE_RAWBUTTONS)
	; uncomment the line below to be alerted of the key
	; msgBox, %key%

	;only buttons that just went down
	pressed := key & ~held
	held := key

	if (pressed & 8388608) ; If the left dot on the Powermic is clicked
	{
		Send, {Ctrl Down}c{Ctrl Up}
	}


	if (pressed & 33554432) ; If the right dot on the Powermic is clicked
	{
		If WinActive("ahk_exe msedge.exe")
		{
			Send,  {Ctrl Down}v{Ctrl Up}
		}
	}
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

