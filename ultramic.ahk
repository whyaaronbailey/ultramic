#SingleInstance Force
#include lib/AHKHID.ahk
#Persistent
Menu, Tray, Tip, UltraMic
Menu, Tray, Icon, ultramic.ico
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

AHKHID_Register(1, 0,GuiH, RIDEV_INPUTSINK + RIDEV_PAGEONLY) 
; AHKHID_Register(UsagePage = False, Usage = False, Handle = False, Flags = 0)

InputMsg(wParam, lParam) 
{
	Local devh, key
	Critical    ;or otherwise you could get ERROR_INVALID_HANDLE

	;get handle of device
	devh := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)

	If (devh <> -1)
        And (AHKHID_GetDevInfo(devh, DI_DEVTYPE, True) = RIM_TYPEHID)
        And (AHKHID_GetDevInfo(devh, DI_HID_VENDORID, True) = 1364) 
        And (AHKHID_GetDevInfo(devh, DI_HID_PRODUCTID, True) = 4097)
		; device matches Nuance Powermic III
		
    {

		;get the keycode
		key := AHKHID_GetInputInfo(lParam, II_MSE_RAWBUTTONS)
		; uncommont the line below to be alerted of the key
		; msgBox, %key% 
	} 

	if (key == 67108864) ; If the left mouse on the Powermic is clicked
	{
		Send, {Ctrl Down}c{Ctrl Up}
	}	


	if (key == 134217728) ; If the right mouse on the Powermic is clicked
	{
		If WinActive ("ahk_exe" msedge.exe)
		{
			Send,  {Ctrl Down}v{Ctrl Up}
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
|| 8388609| |16777216|  | 33554432||
|+--------+ +------- +  +--------+||
|                                  |
|+--------+  +-------+  +---------+|
||L MOUSE |  | MOUSE |  |R MOUSE  ||
 |67108864|  +-------+  |134217728||
|+--------+  +-------+  +---------+|
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
Left Dot 8388609
Check 16777216
Right Dot 33554432
Left mouse 67108864
Right mouse 134217728

*/

