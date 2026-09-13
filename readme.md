

# UltraMic -- Add Macros to Nuance PowerMic II using AutoHotkey v2 [AutoHotkey v2](https://www.autohotkey.com/)

Using AHK v2, the attached code allows the user to simply add macros to the Nuance PowerMic III. The simple demonstration code add 'CTRL-C' to the left dot button and 'CTRL-V' to the right dot button on the PowerMic. This gives you the framework to make much more complicated macros that are assigned to PowerMic buttons, for example, copying the dictated report to clipboard automatically when hitting a button assigned to sign report. The possibilities are endless.

## Installation

Requires AutoHotkey v2. No other libraries needed. Download or clone the repo and run `ultramic.ahk`.

For AutoHotkey v1.1, use the `main` branch.

## How to Use

This is hard coded for the Nuance PowerMic II -- see below if you're using a different dictation mic. I captured the input information resulting from PowerMic button clicks, as summaring in this crude ASCII representation of PowerMic:

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

```

L MOUSE and R MOUSE are PowerMic III codes. On a PowerMic II those buttons are plain mouse clicks, so use the dots instead.

If you have a device other than a Nuance PowerMic III, obtain the VID, PID, usage and usagepage information and plug them into the code. 

## Updates

**September 2026 (v2 branch)**

* Ported to AutoHotkey v2.
* Removed the AHKHID library. The script reads the PowerMic directly.

**September 2026**

* Corrected syntax, errors and formatting.
* The buttons on either side of the trackball are fixed as left and right mouse clicks and can't be programmed. Macros go on the left dot and right dot.
* Added AHKHID as a submodule.

## TODO:

* Add support for other devices
* Improve code commentary -- spent too much time on the ASCII art and the cute icon!
