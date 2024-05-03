

# UltraMic -- Add Macros to Nuance PowerMic III using AutoHotkey v1.1[AutoHotkey v 1.1](https://www.autohotkey.com/)

Using [jleb's AHKHID](https://github.com/jleb/AHKHID) and AHK 1.1, the attached code allows the user to simply add macros to the Nuance PowerMic III. The simple demonstration code add 'CTRL-C' to the left mouse button and 'CTRL-V' to the right mouse button on the PowerMic. This gives you the framework to make much more complicated macros that are assigned to PowerMic buttons, for example, copying the dictated report to clipboard automatically when hitting a button assigned to sign report. The possibilities are endless.

## How to Use

This is hard coded for the Nuance PowerMic III -- see below if you're using a different dictation mic. I captured the input information resulting from PowerMic button clicks, as summaring in this crude ASCII representation of PowerMic:

```

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

```

If you have a device other than a Nuance PowerMic III, obtain the VID, PID, usage and usagepage information and plug them into the code. 

## TODO:

* Add support for other devices
* Improve code commentary -- spent too much time on the ASCII art and the cute icon!
