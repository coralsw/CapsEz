;CapsLock增强脚本，例子 {{{1
;by Ez
;v190721 添加在tc里面中键点击打开目录
;v190904 更新暂停等热键，直接把AutoHotkey.exe改名为capsez.exe
;v190916 添加几种模式的开关，解决BUG10任务栏无法切换
;v190927 添加快捷键在TC中打开资源管理器中选中的文件，添加在tc中双击右键返回上一级。自动获取TC路径
;v191214 添加媒体播放相关快捷键和右键拖动窗口，解决一点小问题和小细节
;v200108 修复在资管或桌面没选文件的问题。再修复一些细节
;v200401 添加不同程序中对应不同的小菜单，增强对话框，tab组合键等
;v210405 添加侧边键增强等等细节。
;v210601 继续添加对浏览器和播放器和侧边键鼠标的使用增强。
;v210801 添加对IrfanView等程序的快捷键增强，改进调用启动器popsel的方式，其他小细节等
;v211125 添加开启或关闭随系统自动启动，以及其他很小细节的优化
;v220401 小细节优化
;v220626 添加tc中数字键单击和双击效果，添加鼠标长按模式，添加everything中筛选器等，添加alt空格截图的开关，tc中alt+E为F4，中键改为在对侧面板新开标签，
;v220629 修复启动的时候卡顿，以及卡键问题
;v220710 优化tc中数字键双击和长按操作，优化微信接收文件等

;建议对“例子”位置进行自行修改

;管理员权限代码，放在文件开头 {{{1
Loop, %0%
  {
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    params .= A_Space . param
  }
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
    If A_IsCompiled
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
    Else
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}

;文件头 {{{1
;Directives
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent                   ;让脚本持久运行(关闭或ExitApp)
#MaxMem 4	;max memory per var use
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 10000 ;Avoid warning when mouse wheel turned very fast
SetCapsLockState AlwaysOff
;SendMode InputThenPlay
;KeyHistory
SetBatchLines -1                	 	;让脚本无休眠地执行（换句话说，也就是让脚本全速运行）
SetKeyDelay -1							;设置每次Send和ControlSend发送键击后自动的延时,使用-1表示无延时
Process Priority,,High           	    ;线程,主,高级别

SendMode Input

DetectHiddenWindows, on

SetWinDelay,0
SetControlDelay,0


;************** group定义^ ************** {{{1
;GroupAdd, group_browser,ahk_class St.HDBaseWindow
GroupAdd, group_browser,ahk_class IEFrame               ;IE
GroupAdd, group_browser,ahk_class ApplicationFrameWindow ;Edge
GroupAdd, group_browser,ahk_class MozillaWindowClass    ;Firefox
GroupAdd, group_browser,ahk_class QQBrowser_WidgetWin_1
GroupAdd, group_browser,ahk_exe chrome.exe               ;Chrome
GroupAdd, group_browser,ahk_exe msedge.exe
GroupAdd, group_browser,ahk_exe 115chrome.exe
;115的播放器
GroupAdd, group_browser,YywPlayerOperateFrame ahk_class XMLWnd

GroupAdd, group_disableCtrlSpace, ahk_exe excel.exe
GroupAdd, group_disableCtrlSpace, ahk_exe pycharm.exe
GroupAdd, group_disableCtrlSpace, ahk_exe SQLiteStudio.exe

GroupAdd,GroupDiagOpenAndSave,新建 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,选择 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,保存 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,另存 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,打开 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,上传 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,导入 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,插入 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,浏览 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Open ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Save ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Select ahk_class #32770


;GroupAdd, group_disableCtrlSpace, ahk_exe gvim.exe 
;GroupAdd, group_disableCtrlSpace, ahk_class NotebookFrame（注：ahk_class后面是AHK检测出的mathematica的class名）

;************** group定义$ **************

;设定5分钟重启一次脚本，防止卡键 1000*60*15
GV_ReloadTimer := % 1000*60*5
GV_ToggleReload := 1
Gosub,AutoReloadInit
Gosub,CreatTrayMenu


;Esc键的作用，默认WinClose，作为alt+f4关闭程序，可选CapsLock，作为切换大小写
;GV_EscKeyAs := "WinClose"
;GV_EscKeyAs := "Escape"
;GV_EscKeyAs := "CapsLock"
GV_EscKeyAs := "Backspace"

;启动器选择，可选为popsel和qsel
;GV_PopSel_QSel := "popsel"
GV_PopSel_QSel := "qsel"

;是否启用光标下滚轮
GV_ToggleWheelOnCursor := 0

;tab系列组合键，适合左键右鼠，启用后直接按tab会感觉有一点延迟，默认开启，开关为ctrl+win+alt+花号
GV_ToggleTabKeys := 1

;启用空格系列快捷键，启用会影响打字，在tc中会不能按住连选文件，默认关闭，开关为ctrl+win+alt+空格
GV_ToggleSpaceKeys := 0

;在浏览器中启用空格系列快捷键
GV_GroupBrowserToggleSpaceKeys := 1

;在浏览器中切换滚轮模式
;视频中滚轮为左右快进，主要是用来看视频网站，开关默认为左边alt加空格或者双击侧边键1
GV_GroupBrowserToggleWheelModeLeftRight := 0
;页面中滚轮为翻页，几行和一页间切换
GV_GroupBrowserToggleWheelModeUpDown := 0
;在浏览器中切换侧边键作为中键模式
GV_GroupBrowserToggleMButtonMode := 0

;在Totalcmd中使用数字键，单击快速打开，双击跳转
GV_TotalcmdToggleJumpByNumber := 1

;单键模式，开关按键为caps+/
GV_ToggleKeyMode := 0

;截图文件临时变量
global SSFileName
;截图的时候同时进剪贴板
global GV_ScreenShot2Clip := 1

;64位的Win7下，在输入框中是148003967
GV_CursorInputBox_64Win710 := 148003967
;正常鼠标指针
GV_CursorNormal_64Win710 := 124973738
;超链接鼠标指针
GV_CursorClick_64Win710 := 1197314685

GV_CursorInputBox := GV_CursorInputBox_64Win710
GV_CursorClick := GV_CursorClick_64Win710
GV_CursorNormal := GV_CursorNormal_64Win710

;处于编辑状态
GV_Edit_Mode := 0


gv_url_tdx_f10 := "http://data.eastmoney.com/notices/stock/"
gv_url_html := ".html"


global COMMANDER_PATH := % A_ScriptDir
if A_Is64bitOS AND FileExist(A_ScriptDir . "\" . "TOTALCMD64.EXE") {
		COMMANDER_NAME := "TOTALCMD64.EXE"
} else{
		COMMANDER_NAME := "TOTALCMD.EXE"
}
global COMMANDER_EXE := COMMANDER_PATH . "\" . COMMANDER_NAME
EnvSet,COMMANDER_PATH, %COMMANDER_PATH%
EnvSet,COMMANDER_EXE, %COMMANDER_EXE%

;GV_ToolsPath := % GF_GetSysVar("ToolsPath")
GV_TempPath := % GF_GetSysVar("TEMP")

;绿软根目录SoftDir，默认在tc目录的上一层，这里是脚本内的环境变量，所有从ahk中启动的程序都会继承这个变量，
;如果电脑相对固定，则可以考虑在右键菜单中选添加系统的环境变量固定下来
;用EnvUpdate 会导致卡顿
SOFTDIR := % GF_GetSysVar("SoftDir")
if !SOFTDIR
{
	SOFTDIR := RegExReplace(A_ScriptDir,"\\[^\\]+\\?$")
	EnvSet,SoftDir, % SOFTDIR
}


;默认双击快捷键间隔175微秒
GV_KeyTimer := 175
GV_MouseTimer := 400
GV_KeyClickAction1 :=
GV_KeyClickAction2 :=
GV_KeyClickAction3 :=
;长按的按钮，0为默认不管，1左键2右键3中键
GV_MouseButton := 0
GV_LongClickAction :=

TC_Msg := 1075
CM_OpenDrives := 2122
CM_OpenDesktop := 2121
CM_OpenPrinters := 2126
CM_OpenNetwork := 2125
CM_OpenControls := 2123
CM_OpenRecycled := 2127
CM_CopySrcPathToClip := 2029
CM_CopyFullNamesToClip := 2018
CM_ConfigSaveDirHistory := 582

ScreenShotPath := "C:\"

;Tim中座标位置
Tim_Start_X := 100
Tim_Start_Y := 100
Tim_Bar_Height := 60 

;QQ中座标位置
QQ_Start_X := 100
QQ_Start_Y := 30
QQ_Bar_Height := 45 

WX_Start_X := 180
WX_Start_Y := 100
WX_Bar_Height := 62 

TG_Start_X := 100
TG_Start_Y := 110
TG_Bar_Height := 62 


;用ramdisk的时候，有时候不能自动的建立Temp目录
;FileDelete,% GV_TempPath
;FileCreateDir, % GV_TempPath
;run nircmd execmd mkdir "%GV_TempPath%"
;FileCreateDir, % GV_TempPath . "\ChromeCache"


;************** 在光标下方滚轮 ************** {{{1
;Autoexecute code
MinLinesPerNotch := 1
MaxLinesPerNotch := 5
AccelerationThreshold := 100
AccelerationType := "L" ;Change to "P" for parabolic acceleration
StutterThreshold := 10

;************** 在光标下方滚轮开始^ ************** {{{2
;Function definitions
;See above for details on parameters
FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
{
	SetBatchLines, -1 ;Run as fast as possible
	CoordMode, Mouse, Screen ;All coords relative to screen
	
	;Stutter filter: Prevent stutter caused by cheap mice by ignoring successive WheelUp/WheelDown events that occur to close together.
	If(A_TimeSincePriorHotkey < StutterThreshold) ;Quickest succession time in ms
		If(A_PriorHotkey = "WheelUp" Or A_PriorHotkey ="WheelDown")
			Return

	MouseGetPos, m_x, m_y,, ControlClass2, 2
	ControlClass1 := DllCall( "WindowFromPoint", "int64", (m_y << 32) | (m_x & 0xFFFFFFFF), "Ptr") ;32-bit and 64-bit support

	lParam := (m_y << 16) | (m_x & 0x0000FFFF)
	wParam := (120 << 16) ;Wheel delta is 120, as defined by MicroSoft

	;Detect WheelDown event
	If(A_ThisHotkey = "WheelDown" Or A_ThisHotkey = "^WheelDown" Or A_ThisHotkey = "+WheelDown" Or A_ThisHotkey = "*WheelDown")
		wParam := -wParam ;If scrolling down, invert scroll direction
	
	;Detect modifer keys held down (only Shift and Control work)
	If(GetKeyState("Shift","p"))
		wParam := wParam | 0x4
	If(GetKeyState("Ctrl","p"))
		wParam := wParam | 0x8

	;Adjust lines per notch according to scrolling speed
	Lines := LinesPerNotch(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType)

	If(ControlClass1 != ControlClass2)
	{
		Loop %Lines%
		{
			SendMessage, 0x20A, wParam, lParam,, ahk_id %ControlClass1%
			SendMessage, 0x20A, wParam, lParam,, ahk_id %ControlClass2%
		}
	}
	Else
	{
		SendMessage, 0x20A, wParam * Lines, lParam,, ahk_id %ControlClass1%
	}
}

;All parameters are the same as the parameters of FocuslessScroll()
;Return value: Returns the number of lines to be scrolled calculated from the current scroll speed.
LinesPerNotch(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType)
{
	T := A_TimeSincePriorHotkey

	If((T > AccelerationThreshold) Or (T = -1)) ;T = -1 if this is the first hotkey ever run
	{
		Lines := MinLinesPerNotch
	}
	Else
	{
		If(AccelerationType = "P")
		{
			A := (MaxLinesPerNotch-MinLinesPerNotch)/(AccelerationThreshold**2)
			B := -2 * (MaxLinesPerNotch - MinLinesPerNotch)/AccelerationThreshold
			C := MaxLinesPerNotch
			Lines := Round(A*(T**2) + B*T + C)
		}
		Else
		{
			B := (MinLinesPerNotch-MaxLinesPerNotch)/AccelerationThreshold
			C := MaxLinesPerNotch
			Lines := Round(B*T + C)
		}
	}
	Return Lines
}

;在任务栏上滚轮调整音量 {{{2
#If MouseIsOver("ahk_class Shell_TrayWnd") or MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
	WheelUp::GoSub,Sub_volUp
	WheelDown::GoSub,Sub_volDown

	;中键静音	
	MButton::GoSub,Sub_volMute

	;启动svv
	;~LButton::
		;GV_LongClickAction := "GoSub,Sub_sv"
		;GV_MouseButton := 1
		;GoSub,Sub_ButtonLongPress
	;return
#if

Sub_volDown:
	SetTimer,SliderOff,2000
	SoundSet,-2
	Gosub,DisplaySlider
Return

Sub_volUp:
	SetTimer,SliderOff,2000
	SoundSet,+2
	Gosub,DisplaySlider
Return

Sub_volMute:
	SetTimer,SliderOff,2000
	SoundSet, +1, , mute
	SoundGet, master_mute, , mute
	if master_mute = Off  
		Gosub,DisplaySlider
	 else if master_mute = On
		Progress,0,0, ,音量大小
return

SliderOff:
	Progress,Off
Return

DisplaySlider:
	SoundGet,Volume
	Volume:=Round(Volume)
	Progress,%Volume%,%Volume%, ,音量大小
Return

Sub_sv:
	Run, SndVol.exe
return

#IfWinActive ahk_exe SndVol.exe
	RButton::WinClose A
#IfWinActive

Sub_svv:
	Run, soundvolumeview.exe
return

#IfWinActive ahk_exe soundvolumeview.exe
	MButton::SendInput, ^{6 10}
	; 5%
	k::SendInput, ^4
	j::SendInput, ^3
	WheelUp::SendInput, ^4
	WheelDown::SendInput, ^3
	; 1%
	!k::SendInput, ^2
	!j::SendInput, ^1
	!WheelUp::SendInput, ^2
	!WheelDown::SendInput, ^1
	; 10%
	^k::SendInput, ^4
	^j::SendInput, ^3
	^WheelUp::SendInput, ^4
	^WheelDown::SendInput, ^3
	; Toggle mute
	m::SendInput, {F9}
	Esc::SendInput, !fx

	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,!fx"
		GoSub,Sub_MouseClick123
	return

#IfWinActive



;Win10里面已经不需要光标下滚轮这个功能
#If (GV_ToggleWheelOnCursor=1) and (A_OSVersion in WIN_2003,WIN_XP,WIN_7)
WheelUp::FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
WheelDown::FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
^WheelUp::Send,^{WheelUp}
^WheelDown::Send,^{WheelDown}
!WheelUp::Send,!{WheelUp}
!WheelDown::Send,!{WheelDown}
#if

;************** 在光标下方滚轮结束 ************** {{{2

;************** 定时重启脚本部分，别动位置 ************** {{{1
AutoReloadInit:
	SetTimer, SelfReload, % GV_ReloadTimer
return

SelfReload:
	if (GV_ToggleReload && !GV_GroupBrowserToggleMButtonMode && !GV_GroupBrowserToggleWheelModeLeftRight && !GV_GroupBrowserToggleWheelModeUpDown)
	{
		;Send,{space up}
		Send,{capslock up}

		Send,{LWin Up}
		Send,{RWin Up}

		Send,{Shift Up}
		Send,{LShift Up}
		Send,{RShift Up}

		Send,{Alt Up}
		Send,{LAlt Up}
		Send,{RAlt Up}

		Send,{Control Up}
		Send,{LControl Up}  
		Send,{RControl Up}

		Send,{Volume_Down Up}
		Send,{Volume_Up Up}
		;Send,{Volume_Mute Up}

		reload
	}
return

ForceSelfReload:
	;Send,{space up}
	Send,{capslock up}

	Send,{LWin Up}
	Send,{RWin Up}

	Send,{Shift Up}
	Send,{LShift Up}
	Send,{RShift Up}

	Send,{Alt Up}
	Send,{LAlt Up}
	Send,{RAlt Up}

	Send,{Control Up}
	Send,{LControl Up}  
	Send,{RControl Up}

	Send,{Volume_Down Up}
	Send,{Volume_Up Up}

	sleep 100 
	reload
return

;************** caps+鼠标滚轮调整窗口透明度^    ************** {{{1
;caps+鼠标滚轮调整窗口透明度（设置30-255的透明度，低于30基本上就看不见了，如需要可自行修改）
;~LShift & WheelUp::
CapsLock & WheelUp::
	;透明度调整，增加。
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
	Transparent_New:=Transparent+20
	If (Transparent_New > 254)
		Transparent_New =255
	WinSet,Transparent,%Transparent_New%,A

	tooltip 原透明度: %Transparent_New% `n新透明度: %Transparent%
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

CapsLock & WheelDown::
	;透明度调整，减少。
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
	Transparent_New:=Transparent-20
	If (Transparent_New < 30)
		Transparent_New = 30
	WinSet,Transparent,%Transparent_New%,A
	tooltip 原透明度: %Transparent_New% `n新透明度: %Transparent%
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

;设置CapsLock 加侧边键 直接恢复透明度到255。没有侧边键的就算了，毕竟滚轮滚一下也快得很
;CapsLock & XButton1::
	;WinGet, Transparent, Transparent,A
	;WinSet,Transparent,255,A
	;tooltip 恢复透明度
	;SetTimer, RemoveToolTip_transparent_Lwin, 1500
;return

RemoveToolTip_transparent_Lwin:
	tooltip
	SetTimer, RemoveToolTip_transparent_Lwin, Off
return

;************caps+鼠标滚轮调整窗口透明度$***********


;************** 按住Caps拖动鼠标^    ************** {{{1
;按住caps加左键拖动窗口
Capslock & LButton::
;Escape & LButton::
	CoordMode, Mouse  ; Switch to screen/absolute coordinates.
	MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
	WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
	WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
	if EWD_WinState = 0  ; Only if the window isn't maximized 
		SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
	GetKeyState, EWD_LButtonState, LButton, P
	if EWD_LButtonState = U  ; Button has been released, so drag is complete.
	{
		SetTimer, EWD_WatchMouse, off
		return
	}
	;GetKeyState, EWD_EscapeState, Escape, P
	;if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
	;{
	;	SetTimer, EWD_WatchMouse, off
	;	WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
	;	return
	;}
	; Otherwise, reposition the window to match the change in mouse coordinates
	; caused by the user having dragged the mouse:
	CoordMode, Mouse
	MouseGetPos, EWD_MouseX, EWD_MouseY
	WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
	SetWinDelay, -1   ; Makes the below move faster/smoother.
	WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
	EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
	EWD_MouseStartY := EWD_MouseY
return

;按住caps加右键放大和缩小窗口
Capslock & RButton::
;Escape & RButton::
	CoordMode, Mouse, Screen ; Switch to screen/absolute coordinates.
	MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
	WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY, EWD_WinWidth, EWD_WinHeight, ahk_id %EWD_MouseWin%
	EWD_StartPosX := EWD_WinWidth - EWD_MouseStartX
	EWD_StartPosY := EWD_WinHeight - EWD_MouseStartY

	if ((EWD_MouseStartX - EWD_OriginalPosX)/EWD_WinWidth)<0.5 && ((EWD_MouseStartY - EWD_OriginalPosY)/EWD_WinHeight)<0.5
		LeftUpCorner = 1
	else 
		LeftUpCorner = 0
	WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
	if EWD_WinState = 0  ; Only if the window isn't maximized 
		SetTimer, EWD_ResizeWindow, 10 ; Track the mouse as the user drags it.
Return

EWD_ResizeWindow:
	If Not GetKeyState("RButton", "P"){
		SetTimer, EWD_ResizeWindow, off
		Return
	}
	CoordMode, Mouse, Screen ; Switch to screen/absolute coordinates.
	MouseGetPos, EWD_MouseX, EWD_MouseY
	SetWinDelay, -1   ; Makes the below move faster/smoother.
	if LeftUpCorner
		WinMove, ahk_id %EWD_MouseWin%,, EWD_OriginalPosX-(EWD_MouseStartX-EWD_MouseX), EWD_OriginalPosY-(EWD_MouseStartY-EWD_MouseY), EWD_WinWidth+(EWD_MouseStartX-EWD_MouseX),EWD_WinHeight+(EWD_MouseStartY-EWD_MouseY)
	else
		WinMove, ahk_id %EWD_MouseWin%,, EWD_OriginalPosX, EWD_OriginalPosY, EWD_StartPosX + EWD_MouseX, EWD_StartPosY + EWD_MouseY
Return
;************** 按住Caps拖动窗口$    **************

;按住Win加左键放大和缩小窗口
Capslock & MButton::GoSub,Sub_MaxRestore
;LWin & LButton::GoSub,Sub_MaxRestore
;Win加右键给了popsel作为启动器，关键是滥用置顶并不好，所以给难受的中键
LWin & MButton::Winset, Alwaysontop, toggle, A
;对于置顶最好用快捷键来的更准确一点
#F1::Winset, Alwaysontop, toggle, A
;从默认Ctrl＋W是关闭标签上修改一点成关闭程序。
#w::WinClose A

;按住Win加滚轮来调整音量大小
LWin & WheelUp::GoSub,Sub_volUp
LWin & WheelDown::GoSub,Sub_volDown


;Escape & LButton::WinClose A

;************** 自定义方法^ ************** {{{1
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

;fp,全路径文件名 1路径,2全文件名,3仅文件名,4扩展名,5添加64字样
GetFileInfo(fp,act){
	;D:\Tools\Office\EverEdit\eeie.exe
	;InStr(Haystack, Needle [, CaseSensitive = false, StartingPos = 1, Occurrence = 1]): 
	;SubStr(String, StartingPos [, Length]) 

	dot := InStr(fp,".",false,0,1)
	slash := InStr(fp,"\",false,0,1)

	if(act==1)
		return % substr(fp,1,slash)
	else if(act==2)
		return % substr(fp,slash+1)
	else {
		;当文件名没有后缀名
		if(dot==0){
			if(act==3)
				return % substr(fp,slash+1)
			else if(act==4)
				return ""
			else if(act==5){
				if(A_Is64bitOS)
					return % fp . "64"
				else
					return % fp
			}
		}
		else{
			if(act==3)
				return % substr(fp,slash+1,dot-slash-1)
			else if(act==4)
				return % substr(fp,dot+1)
			else if(act==5){
				if(A_Is64bitOS)
					return % substr(fp,1,dot-1) . "64" . substr(fp,dot)
				else
					return % fp
			}
		}
	}
}

AscSend(str){
	SetFormat, Integer, H
	for k,v in StrSplit(str)
	out.="{U+ " Ord(v) "}"
	Sendinput % out
}

EzTip(tip,s){
	s:=(s>0) ? s*1000 : 2000
	ToolTip % tip
	sleep % s
	ToolTip
}

;适合单行直接调用
CoordWinClick(x,y){
	CoordMode, Mouse, Window
	click %x%, %y%
}

;适合单行直接调用
CoordWinDbClick(x,y){
	CoordMode, Mouse, Window
	click %x%, %y%, 2
}

;在调用的过程前面统一加上一句 CoordMode, Mouse, Window 较好，下同
ClickSleep(x,y,s){
	click %x%, %y%
	Sleep, % 100*s
}


ControlClickSleep(ctl,s){
	ControlClick, %ctl%
	Sleep, % 100*s
}

MyWinWaitActive(title){
	WinWait, %title%, 
	IfWinNotActive, %title%, , WinActivate, %title%, 
	WinWaitActive, %title%, 
}

GetCursorShape(){   ;获取光标特征码 by nnrxin  
    VarSetCapacity( PCURSORINFO, 20, 0) ;为鼠标信息 结构 设置出20字节空间
    NumPut(20, PCURSORINFO, 0, "UInt")  ;*声明出 结构 的大小cbSize = 20字节
    DllCall("GetCursorInfo", "Ptr", &PCURSORINFO) ;获取 结构-光标信息
    if ( NumGet( PCURSORINFO, 4, "UInt")="0" ) ;当光标隐藏时，直接输出特征码为0
        return, 0
    VarSetCapacity( ICONINFO, 20, 0) ;创建 结构-图标信息
    DllCall("GetIconInfo", "Ptr", NumGet(PCURSORINFO, 8), "Ptr", &ICONINFO)  ;获取 结构-图标信息
    VarSetCapacity( lpvMaskBits, 128, 0) ;创造 数组-掩图信息（128字节）
    DllCall("GetBitmapBits", "Ptr", NumGet( ICONINFO, 12), "UInt", 128, "UInt", &lpvMaskBits)  ;读取 数组-掩图信息
    loop, 128{ ;掩图码
        MaskCode += NumGet( lpvMaskBits, A_Index, "UChar")  ;累加拼合
    }
    if (NumGet( ICONINFO, 16, "UInt")<>"0"){ ;颜色图不为空时（彩色图标时）
        VarSetCapacity( lpvColorBits, 4096, 0)  ;创造 数组-色图信息（4096字节）
        DllCall("GetBitmapBits", "Ptr", NumGet( ICONINFO, 16), "UInt", 4096, "UInt", &lpvColorBits)  ;读取 数组-色图信息
        loop, 256{ ;色图码
            ColorCode += NumGet( lpvColorBits, A_Index*16-3, "UChar")  ;累加拼合
        }  
    } else
        ColorCode := "0"
    DllCall("DeleteObject", "Ptr", NumGet( ICONINFO, 12))  ; *清理掩图
    DllCall("DeleteObject", "Ptr", NumGet( ICONINFO, 16))  ; *清理色图
    VarSetCapacity( PCURSORINFO, 0) ;清空 结构-光标信息
    VarSetCapacity( ICONINFO, 0) ;清空 结构-图标信息
    VarSetCapacity( lpvMaskBits, 0)  ;清空 数组-掩图
    VarSetCapacity( lpvColorBits, 0)  ;清空 数组-色图
    return, % MaskCode//2 . ColorCode  ;输出特征码
}

Sub_MouseClick123:
	if winc_presses > 0 ; SetTimer 已经启动, 所以我们记录键击.
	{
		winc_presses += 1
		return
	}
	; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
	; 计时器：
	winc_presses = 1
	SetTimer, KeyWinC, % GV_MouseTimer ; 在 400 毫秒内等待更多的键击.
return

Sub_KeyClick123:
	if winc_presses > 0 ; SetTimer 已经启动, 所以我们记录键击.
	{
		winc_presses += 1
		return
	}
	; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
	; 计时器：
	winc_presses = 1
	SetTimer, KeyWinC, % GV_KeyTimer ; 在 400 毫秒内等待更多的键击.
return

KeyWinC:
	SetTimer, KeyWinC, off
	if winc_presses = 1 ; 此键按下了一次.
	{
		if GV_MouseButton = 0 
		{
			fun_KeyClickAction123(GV_KeyClickAction1)	
		}
		else {
			MouseGetPos, x0, y0
			if GV_MouseButton = 1
				KeyWait, LButton, T0.4
			else if GV_MouseButton = 2
				KeyWait, RButton, T0.4
			else if GV_MouseButton = 3
				KeyWait, MButton, T0.4
			MouseGetPos, x1, y1
			If (ErrorLevel && (x0 = x1 && y0 = y1)) 
			{
				fun_KeyClickAction123(GV_LongClickAction)
				;重置为0
				GV_MouseButton = 0
			}
			else {
				fun_KeyClickAction123(GV_KeyClickAction1)	
			}
		}
	}
	else if winc_presses = 2 ; 此键按下了两次.
	{
		fun_KeyClickAction123(GV_KeyClickAction2)
	}
	else if winc_presses > 2
	{
		fun_KeyClickAction123(GV_KeyClickAction3)
		;MsgBox, Three or more clicks detected.
	}
	; 不论触发了上面的哪个动作, 都对 count 进行重置
	; 为下一个系列的按下做准备:
	winc_presses = 0
return

fun_KeyClickAction123(act){
	If RegExMatch(act,"i)^(run,)",m) {
		run,% substr(act,strlen(m1)+1)
	}
	else If RegExMatch(act,"i)^(send,)",m) {
		Send,% substr(act,strlen(m1)+1)
	}
	else If RegExMatch(act,"i)^(SendInput,)",m) {
		SendInput,% substr(act,strlen(m1)+1)
	}
	else If RegExMatch(act,"i)^(GoSub,)",m) {
		GoSub,% substr(act,strlen(m1)+1)
	}
	else If RegExMatch(act,"i)^(GoFun,)",m) {
		funString := % substr(act,strlen(m1)+1)
		funName := substr(funString,1,InStr(funString,"(")-1)
		funPara := substr(funString,InStr(funString,"(")+1,InStr(funString,")")-InStr(funString,"(")-1)
		RetVal := funName.(funPara)
	}
}

Sub_ButtonLongPress:
	If ButtonLongPress { 
		ButtonLongPress += 1
		Return
	}
	ButtonLongPress = 1
	;SetTimer, ButtonLongPress, -250
	SetTimer, ButtonLongPress, % GV_MouseTimer
Return

ButtonLongPress:
	IfEqual, ButtonLongPress, 1 
	{
		MouseGetPos, x0, y0
		if GV_MouseButton = 1
			KeyWait, LButton, T0.4
		else if GV_MouseButton = 2
			KeyWait, RButton, T0.4
		else if GV_MouseButton = 3
			KeyWait, MButton, T0.4
		MouseGetPos, x1, y1
		If (ErrorLevel && (x0 = x1 && y0 = y1))
			fun_KeyClickAction123(GV_LongClickAction)
	}
	ButtonLongPress = 0
Return

;%A_YYYY%-%A_MM%-%A_DD%-%A_MSec%
;msgbox % fun_GetFormatTime("yyyy-MM-dd-HH-mm-ss")
fun_GetFormatTime(f,t="")
{
	;FormatTime, TimeString, 200504, 'Month Name': MMMM`n'Day Name': dddd
	;FormatTime, TimeString, ,'Month Name': MMMM`n'Day Name': dddd
	FormatTime, TimeString, %t% ,%f%
	return %TimeString%
}
GF_GetSysVar(sys_var_name)
{
	EnvGet, sv,% sys_var_name
	return % sv
}


Sub_ClipAppend:
	;SendInput,^{Home}^+{End}^c
	Send,^c
	ToolTip 已经添加到 %GV_TempPath%\ClipAppend.txt
	FileAppend, %ClipBoard%.`n, %GV_TempPath%\ClipAppend.txt
	Sleep 1000
	ToolTip
return


Sub_MaxRestore:
	WinGet, Status_minmax ,MinMax,A
	If (Status_minmax=1){
		WinRestore A
	}
	else{
		WinMaximize A
	}
return

Sub_MaxAllWindows:
	WinGet, Window_List, List ; Gather a list of running programs
	Loop, %Window_List%
	{
		wid := Window_List%A_Index%
		WinGetTitle, wid_Title, ahk_id %wid%
		WinGet, Style, Style, ahk_id %wid%
		;(WS_CAPTION 0xC00000| WS_SYSMENU 0x80000| WS_MAXIMIZEBOX 0x10000) | WS_SIZEBOX 0x40000
		If (!(Style & 0xC90000) or !(Style & 0x40000) or (Style & WS_DISABLED) or !(wid_Title)) ; skip unimportant windows ; ! wid_Title or
			Continue
		;MsgBox, % (Style & 0x40000)
		WinGet, es, ExStyle, ahk_id %wid%
		Parent := Decimal_to_Hex( DllCall( "GetParent", "uint", wid ) )
		WinGet, Style_parent, Style, ahk_id %Parent%
		Owner := Decimal_to_Hex( DllCall( "GetWindow", "uint", wid , "uint", "4" ) ) ; GW_OWNER = 4
		WinGet, Style_Owner, Style, ahk_id %Owner%

		If (((es & WS_EX_TOOLWINDOW)  and !(Parent)) ; filters out program manager, etc
			or ( !(es & WS_EX_APPWINDOW)
			and (((Parent) and ((Style_parent & WS_DISABLED) =0)) ; These 2 lines filter out windows that have a parent or owner window that is NOT disabled -
				or ((Owner) and ((Style_Owner & WS_DISABLED) =0))))) ; NOTE - some windows result in blank value so must test for zero instead of using NOT operator!
			continue
		WinGet, Status_minmax ,MinMax,ahk_id %wid%
		If (Status_minmax!=1) {
			WinMaximize,ahk_id %wid%
		}
		;MsgBox, 4, , Visiting All Windows`n%a_index% of %Window_List%`n`n%wid_Title%`nContinue?
		;IfMsgBox, NO, break
	}
return


Sub_WindowNoCaption:
	WinGetPos, xTB, yTB,lengthTB,hightTB, ahk_class Shell_TrayWnd
	;msgbox %xTB%
	;msgbox %yTB%
	;msgbox %lengthTB%
	;msgbox %hightTB%
	bd := 8 ;win8Border = 4
	lW := A_ScreenWidth
	hW := A_ScreenHeight
	if(xTB == 0){ ;左边和上、下面的情况
		if(yTB == 0){ ;任务栏在上和左
			if(lengthTB == A_ScreenWidth){ ;在上
				xW := 0
				yW := hightTB
				lW := A_ScreenWidth
				hW := A_ScreenHeight - hightTB
			}
			else{ ;在左
				xW := lengthTB
				yW := 0
				lW := A_ScreenWidth - lengthTB
				hW := A_ScreenHeight
			}
		}
		else{ ;在下
			xW := 0	
			yW := 0
			lW := A_ScreenWidth
			hW := A_ScreenHeight - hightTB
		}
	}
	else{ ;在右
		xW := 0
		yW := 0
		lW := A_ScreenWidth - lengthTB
		hW := A_ScreenHeight
	}
	WinSet, Style, ^0xC00000, A
return

Decimal_to_Hex(var)
{
	SetFormat, integer, hex
	var += 0
	SetFormat, integer, d
	return var
}

;打开剪贴板中多个链接
OpenClipURLS:
	Loop, parse, clipboard, `n, `r  ; 在 `r 之前指定 `n, 这样可以同时支持对 Windows 和 Unix 文件的解析.
	{
		cu := A_LoopField
		if(RegExMatch(A_LoopField,"^http")){
			sleep 200
			run, "%A_LoopField%"
		}
		else if(RegExMatch(A_LoopField,"(^[a-zA-Z]:\\)|(^file:\/\/\/[a-zA-Z]:\/)")){
			sleep 200
			run,"%COMMANDER_EXE%" /A /T /O /S /L="%A_LoopField%"
		}
	}
return


;map tc :tabnew<cr>"+P
;map <F1> :tabnew<CR>
Sub_CopyAllVim:
	SendInput,^{Home}^+{End}^c
	sleep 500
	if not WinExist("ahk_class Vim")
		run %A_ScriptDir%\TOOLS\vim\gvim.exe, %A_ScriptDir%\TOOLS\vim
	WinActivate
	sleep 500
	SendInput,{F1}^v
return

Sub_CopyVim:
	SendInput,^c
	sleep 500
	if not WinExist("ahk_class Vim")
		run %A_ScriptDir%\TOOLS\vim\gvim.exe, %A_ScriptDir%\TOOLS\vim
	WinActivate
	sleep 500
	send,{Esc}
	sleep 200
	AscSend("tc")
return

;************** 自定义方法$ **************


;************** Youdao_网络翻译^ ********* {{{1
;语音+弹窗  翻译-中英互译	by天甜	From:Cando_有道翻译+剪贴板函数+Splash函数+判断调试

<#y::
	原值:=Clipboard
	clipboard =
	Send ^c
	gosub sound
Return
sound:
	ClipWait,0.5
	If(ErrorLevel)
		{
		InputBox,varTranslation,请输入,你想翻译啥，我来说
		if !ErrorLevel
			{
			Youdao译文:=YouDaoApi(varTranslation)
			Youdao_网络释义:= json(Youdao译文, "web.value")
			SplashYoudaoMsg("Youdao_网络翻译", Youdao_网络释义)
			spovice:=ComObjCreate("sapi.spvoice")
			spovice.Speak(Youdao_网络释义)
			Sleep, 3000
			SplashTextOff
			}
		}
	else
		{
			varTranslation:=clipboard
			Youdao译文:=YouDaoApi(varTranslation)
			Youdao_网络释义:= json(Youdao译文, "web.value")
			SplashYoudaoMsg("Youdao_网络翻译", Youdao_网络释义)
			spovice:=ComObjCreate("sapi.spvoice")
			spovice.Speak(Youdao_网络释义)
			Sleep, 3000
			SplashTextOff
		}
	;Clipboard:=原值
	Clipboard:=Youdao_网络释义
return

SplashYoudaoMsg(title, content){
	;SoundBeep 750, 500
	MouseGetPos, MouseX, MouseY ;获得鼠标位置x,y
	MouseZ := MouseX + 100
	SplashTextOn , 400, 60, %title%, %content%
	WinMove, %title%, , %MouseZ%, %MouseY%
	WinSet, Transparent, 200, %title%
}

YouDaoApi(KeyWord)
{
;    KeyWord:=SkSub_UrlEncode(KeyWord,"utf-8")
	url:="http://fanyi.youdao.com/fanyiapi.do?keyfrom=qqqqqqqq123&key=86514254&type=data&doctype=json&version=1.1&q=" . KeyWord
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", url)
    WebRequest.Send()
    result := WebRequest.ResponseText
    Return result
}
json(ByRef js, s, v = "")
{
	j = %js%
	Loop, Parse, s, .
	{
		p = 2
		RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
		Loop {
			If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
				. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
				Return
			Else If (x2 == q2 or q2 == "*") {
				j = %x3%
				z += p + StrLen(x2) - 2
				If (q3 != "" and InStr(j, "[") == 1) {
					StringTrimRight, q3, q3, 1
					Loop, Parse, q3, ], [
					{
						z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
						j = %x1%
					}
				}
				Break
			}
			Else p += StrLen(x)
		}
	}
	If v !=
	{
		vs = "
		If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
			and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
			vs := "", v := vx1
		StringReplace, v, v, ", \", All
		js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
	}
	Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
		? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}
;************** Youdao_网络翻译$ *********

;************** 组合快捷键部分 ************** {{{1
;************** Escape相关 ************** {{{2
; +HJKL 表示左下右上方向  SendInput@chm
Escape & j:: SendInput,{Blind}{Down}
Escape & k:: SendInput,{Blind}{Up}
Escape & h:: SendInput,{Blind}{Left}
Escape & l:: SendInput,{Blind}{Right}

Escape & w:: SendInput,{Blind}^{Right}
Escape & b:: SendInput,{Blind}^{Left}

Escape & e:: SendInput,{Blind}{PgDn}
Escape & q:: SendInput,{Blind}{PgUp}

;************** u,i单击双击^ ************** 
;Escape & u:: SendInput,{Blind}^{End}
;Escape & i:: SendInput,{Blind}^{Home}
;Escape & n:: SendInput,{Blind}{PgDn}
;Escape & m:: SendInput,{Blind}{PgUp}

Escape & u::
	GV_KeyClickAction1 := "SendInput,{End}"
	GV_KeyClickAction2 := "SendInput,^{End}"
	GoSub,Sub_KeyClick123
return

Escape & i::
	GV_KeyClickAction1 := "SendInput,{Home}"
	GV_KeyClickAction2 := "SendInput,^{Home}"
	GoSub,Sub_KeyClick123
return

Escape & n::
	GV_KeyClickAction1 := "SendInput,{PgDn}"
	GV_KeyClickAction2 := "SendInput,^{PgDn}"
	GoSub,Sub_KeyClick123
return

Escape & m::
	GV_KeyClickAction1 := "SendInput,{PgUp}"
	GV_KeyClickAction2 := "SendInput,^{PgUp}"
	GoSub,Sub_KeyClick123
return
;************** u,i单击双击$ **************

;***************** 剪贴板相关^ ************** {{{2
Escape & v::
	if EscapeV_presses > 0
	{
		EscapeV_presses += 1
		return
	}
	EscapeV_presses = 1
	SetTimer, KeyEscapeV, 175
return

KeyEscapeV:
	SetTimer, KeyEscapeV, off
	if EscapeV_presses = 1
	{
		GoSub,PastePureText
	}
	else if EscapeV_presses = 2
	{
		GoSub,EzOtherMenuShow
	}
	EscapeV_presses = 0
return


Escape & c::
	GoSub,Sub_ClipAppend
return



;#z::Menu, MyMenu, Show  ; i.e. press the Win-Z hotkey to show the menu.
;***************** 剪贴板相关$ **************
;关闭和刷新
Escape & g:: SendInput,{Blind}^w
Escape & r:: SendInput,{Blind}^r
;切换tab
Escape & o:: send,{Blind}^+{Tab}
Escape & p:: send,{Blind}^{Tab}
;右键和DEL
;Escape & y:: send,{AppsKey}
Escape & y:: Send {Click Right}
Escape & d:: SendInput,{Delete}
;Alttab，Win8下暂时不能用
Escape & .:: AltTab
Escape & ,:: ShiftAltTab

Escape & `;:: WinClose A

;enter 回车窗口最大化
;Escape & Enter:: WinMaximize A
Escape & Enter:: GoSub,Sub_MaxRestore
Escape & Space:: WinMinimize A
^!#up:: GoSub,Sub_MaxAllWindows
^#u:: GoSub,OpenClipURLS

^Escape:: SendInput,^{Escape}
+Escape:: SendInput,+{Escape}
!Escape:: SendInput,!{Escape}
^+Escape:: SendInput,^+{Escape}
^!Escape:: SendInput,^!{Escape}
!+Escape:: SendInput,!+{Escape}
^!+Escape:: SendInput,^!+{Escape}

;最后一行恢复自身功能，重要

Escape::
	if (GV_EscKeyAs = "WinClose") {
		WinClose A
	}
	if (GV_EscKeyAs = "Backspace") {
		SendInput,{Backspace}
	}
	if (GV_EscKeyAs = "Escape") {
		SendInput,{Escape}
	}
	else if (GV_EscKeyAs = "CapsLock") {
		GetKeyState t, CapsLock, T
		IfEqual t,D, SetCapslockState AlwaysOff
		Else SetCapslockState AlwaysOn
	}
return

/*
~Escape::
If (A_PriorHotkey=A_ThisHotkey && A_TimeSincePriorHotkey<200){
	;MsgBox You double taped %A_ThisHotkey%
	WinClose A
}
else {
	;sleep 200
	;msgbox press %A_ThisHotkey% for %A_TimeSinceThisHotkey%
	;if (A_TimeSinceThisHotkey > 200 && A_TimeSinceThisHotkey < 1000){
	SendInput {Escape}
	;}
}
return
*/


;************** CapsLock相关 ************** {{{2
;win+caps+按键
;Capslock & e::
;state := GetKeyState("LWin", "T")  ; 当 CapsLock 打开时为真, 否则为假.
;if state
	;msgbox handle！
;else
	;send #e
;return
;左右手结合上下左右
CapsLock & j::SendInput,{Blind}{Down}
CapsLock & k::SendInput,{Blind}{Up}
CapsLock & h::SendInput,{Blind}{Left}
CapsLock & l::SendInput,{Blind}{Right}

CapsLock & w::SendInput,{Blind}{Up}
CapsLock & s::SendInput,{Blind}{Down}
CapsLock & a::SendInput,{Blind}{Left}
CapsLock & d::SendInput,{Blind}{Right}

CapsLock & q::SendInput,{Blind}{PgUp}
CapsLock & e::SendInput,{Blind}{PgDn}

CapsLock & r:: SendInput,{Blind}{Delete}
CapsLock & f:: SendInput,{Blind}{Enter}

CapsLock & x:: SendInput,{Blind}{Del}
CapsLock & z:: SendInput,{Blind}{Backspace}

;右键菜单
;CapsLock & y:: send,{AppsKey}
CapsLock & y:: Send {Click Right}
 
;媒体相关
CapsLock & 9::send,{Media_Prev}
CapsLock & 0::send,{Media_Next}

CapsLock & -::GoSub,Sub_volDown
CapsLock & =::GoSub,Sub_volUp
CapsLock & Del::GoSub,Sub_volMute

CapsLock & backspace::send,{Media_Play_Pause}

CapsLock & PgUp:: send,{Media_Prev}
CapsLock & PgDn:: send,{Media_Next}

;移动鼠标光标，例如用在屏幕取色
CapsLock & up::MouseMove, 0, -1, 0, R
CapsLock & down::MouseMove, 0, 1, 0, R
CapsLock & left::MouseMove, -1, 0, 0, R
CapsLock & right::MouseMove, 1, 0, 0, R
CapsLock & '::Send,{Click}

;************** u,i单击双击^ **************
;CapsLock & i:: SendInput,{Blind}^{Home}
;CapsLock & u:: SendInput,{Blind}^{End}
;CapsLock & n:: SendInput,{Blind}{PgDn}
;CapsLock & m:: SendInput,{Blind}{PgUp}

CapsLock & u::
	GV_KeyClickAction1 := "SendInput,{Blind}{End}"
	GV_KeyClickAction2 := "SendInput,{Blind}^{End}"
	GoSub,Sub_KeyClick123
return

CapsLock & i::
	GV_KeyClickAction1 := "SendInput,{Blind}{Home}"
	GV_KeyClickAction2 := "SendInput,{Blind}^{Home}"
	GoSub,Sub_KeyClick123
return

CapsLock & n::
	GV_KeyClickAction1 := "SendInput,{Blind}{PgDn}"
	GV_KeyClickAction2 := "SendInput,{Blind}^{PgDn}"
	GoSub,Sub_KeyClick123
return

CapsLock & m::
	GV_KeyClickAction1 := "SendInput,{Blind}{PgUp}"
	GV_KeyClickAction2 := "SendInput,{Blind}^{PgUp}"
	GoSub,Sub_KeyClick123
return

;************** u,i单击双击$ **************

;***************** 剪贴板相关^ **************
CapsLock & v::
	if CapsLockV_presses > 0
	{
		CapsLockV_presses += 1
		return
	}
	CapsLockV_presses = 1
	SetTimer, KeyCapsLockV, 175
return

KeyCapsLockV:
	SetTimer, KeyCapsLockV, off
	if CapsLockV_presses = 1
	{
		GoSub,PastePureText
	}
	else if CapsLockV_presses = 2
	{
		;Menu, MyMenu, Show
		;EzOtherMenuShow()
		GoSub,EzOtherMenuShow
		;EzOtherMenuShow()
	}
	CapsLockV_presses = 0
return

EzOtherMenuShow:
	Menu, MyMenu, UseErrorLevel
	Menu, MyMenu, DeleteAll
	Menu, MyMenu, Add, 搜索, Sub_SearchSelectTxt
	Menu, MyMenu, Add, Everything搜索, Sub_EverythingSelectTxt
	Menu, MyMenu, Add  ; 添加分隔线.
	Menu, MyMenu, Add, 播放器打开, Sub_OpenUrlByPlayer
	Menu, MyMenu, Add  ; 添加分隔线.
	Menu, MyMenu, Add, 纯文本粘贴, PastePureText
	Menu, MyMenu, Add, Z转换后粘贴, JoinAndPaste
	Menu, MyMenu, Add  ; 添加分隔线.
	Menu, MyMenu, Add, 添加Quote, PasteQuote
	Menu, MyMenu, Add, 添加Code, PasteCode
	Menu, MyMenu, Add, 添加磁头Magnet, PasteMagnet

	Menu, MyMenu, Add  ; 添加分隔线.

	GoSub,EzOtherMenu_MyApps
	Menu, MyMenu, Add  ; 添加分隔线.

	Menu, MyMenu, Add, 取消[& ],EzOtherMenu_DeleteAll
	Menu, MyMenu, Show
return

EzOtherMenu_DeleteAll:
	Menu, MyMenu, DeleteAll
return


EzOtherMenu_MyApps:
	try {
		MyAppsIni :=  % A_ScriptDir . "\capsez_mymenus.ini"

		cur_menus := ""
		current_app := ""
		IniRead, apps, %MyAppsIni%, MyMenus
		arr_app := StrSplit(apps, "`n", "`r")
		Loop % arr_app.MaxIndex()
		{
			;Notepad=ahk_class Notepad
			app := StrSplit(arr_app[a_index],"=")
			if WinActive(app[2]) {
				current_app := app[1]
				break  
			}
			else {
				continue 
			}
		}

		IniRead, cur_menus, %MyAppsIni%, %current_app%
		arr_cur_menus := StrSplit(cur_menus, "`n", "`r")
		Loop % arr_cur_menus.MaxIndex()
		{
			;[Notepad]
			;去掉尾部文字=notepad_trim
			;将空格和tab删除=notepad_cleanWhitespace
			cm := StrSplit(arr_cur_menus[a_index],"=")
			cm_name := cm[1]
			cm_cmd := cm[2]
			Menu, MyMenu, Add, %cm_name%,  %cm_cmd%
		}
	} catch e {
	}
return

PastePureText:
	IfWinActive, ahk_class ConsoleWindowClass
	{
		;SendInput,!{Space}ep
		Send {Click Right}
	}
	else
	{
		clipboard = %clipboard%
		send,{Blind}^v
	}
return

JoinAndPaste:
	clip:=clipboard 
	;例子1
	;对tc中文件复制文件名之后处理，添加双引号并且把多行合并成一行并用竖杠连接
	;clip := RegExReplace(clip, "(.+)(`r`n)?", """$1""`|")
	;例子2
	;对everything的搜索结果进行处理，去掉双引号并且把多行合并成一行并用tab分隔
	clip := RegExReplace(clip, "("".+"")(`r`n)?", "$1`t")
	StringTrimRight, clip, clip, 1
	clipboard = %clip%
	send,{Blind}^v
return


PasteQuote:
	send,^c<quote>{Blind}^v</quote>
return

PasteCode:
	send,^c<code>{Blind}^v</code>
return

PasteMagnet:
	send,^cmagnet:?xt=urn:btih:{Blind}^v
return

#include %A_ScriptDir%\capsez_myapps.ahk


Sub_SearchSelectTxt:
	send,^c
	sleep,100
	clip:=
	clip:=clipboard
	If RegExMatch(clip, "^\d{6}$"){
		Out := gv_url_tdx_f10 . clip . gv_url_html
		run,%Out%
	}
	else{
		run,http://www.baidu.com/s?ie=utf-8&wd=%clip%
	}
return

Sub_EverythingSelectTxt:
	send,^c
	sleep,500
	clip :=
	clip=%clipboard%
	run,%A_ScriptDir%\Everything.exe %clip%
return

Sub_OpenUrlByPlayer:
	send,^c
	sleep,100
	clip:=
	clip:=clipboard
	run,%A_ScriptDir%\Plugins\WLX\vlister\mpv.exe "%clip%"
return

;***************** 剪贴板相关$ **************
CapsLock & c::
	GoSub,Sub_ClipAppend
return

CapsLock & g:: SendInput,{Blind}^w

CapsLock & o:: SendInput,{Blind}^+{Tab}
CapsLock & p:: SendInput,{Blind}^{Tab}

;AltTabMenu 用处不大
CapsLock & .:: AltTab
CapsLock & ,:: ShiftAltTab

;关闭窗口
CapsLock & `;:: WinClose A

;enter 回车窗口最大化
CapsLock & Enter:: GoSub,Sub_MaxRestore
CapsLock & Space:: WinMinimize A

;将caps替换为esc
CapsLock::
	suspend permit
	SendInput,{Escape}
return

;+CapsLock:: CapsLock "之前的写法
;^PrintScreen::
; control + capslock to toggle capslock.  alwaysoff/on so that the key does not blink
^CapsLock::
!CapsLock::
	GetKeyState t, CapsLock, T
	IfEqual t,D, SetCapslockState AlwaysOff
	Else SetCapslockState AlwaysOn
Return


;************** 分号;相关 ************** {{{2
`; & j:: SendInput,{Blind}{Down}
`; & k:: SendInput,{Blind}{Up}
`; & h:: SendInput,{Blind}{Left}
`; & l:: SendInput,{Blind}{Right}
`; & n:: SendInput,{Blind}{PgDn}
`; & m:: SendInput,{Blind}{PgUp}

`; & Space:: SendInput,{Delete}

`; & z::
	GV_KeyClickAction1 := "SendInput,{Backspace}"
	GV_KeyClickAction2 := "SendInput,+{Home}{Backspace}"
	GoSub,Sub_KeyClick123
return

`; & x::
	GV_KeyClickAction1 := "SendInput,{Delete}"
	GV_KeyClickAction2 := "SendInput,+{End}{Delete}"
	GoSub,Sub_KeyClick123
return

`; & c::
	GV_KeyClickAction1 := "SendInput,^c"
	GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^c"
	GoSub,Sub_KeyClick123
return

`; & b::
	GV_KeyClickAction1 := "SendInput,^x"
	GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^x"
	GoSub,Sub_KeyClick123
return

`; & v::
	GV_KeyClickAction1 := "SendInput,^v"
	GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^v"
	GoSub,Sub_KeyClick123
return

;粘贴然后回车，多用在搜索框等输入的位置，一个双手，一个单手
`; & g::
	GV_KeyClickAction1 := "SendInput,^v{Enter}"
	GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^v{Enter}"
	GoSub,Sub_KeyClick123
return


;搜索选中的文本
`; & s::GoSub,Sub_SearchSelectTxt


;清空复制粘贴
`; & d::SendInput,{Home 2}+{End}{Backspace}
`; & a::SendInput,^{Home}^+{End}{Delete}



;粘贴并转到,多数浏览器和tc中都可用
`; & u:: send,^t!d^v{Enter}
;`; & u:: send,^t!dwww.^v{Enter}


`; & 1:: AscSend(fun_GetFormatTime("yyyy-MM-dd"))
`; & 2:: AscSend(fun_GetFormatTime(" HHmm"))
`; & 3:: AscSend("#" . fun_GetFormatTime("MMdd"))

;恢复分号自身功能
;$`;:: SendInput,`;

`;:: send,`;
^`;:: send,^`;
+`;:: send,+`;
^+`;:: send,^+`;
!`;:: send,!`;
::: send,:

;************** Space空格键相关 ************** {{{2
#If GV_ToggleSpaceKeys==1 
;vim等中冲突排除，但在tc中不能连续空格
	Space & j:: SendInput,{Blind}{Down}
	Space & k:: SendInput,{Blind}{Up}
	Space & h:: SendInput,{Blind}{Left}
	Space & l:: SendInput,{Blind}{Right}

	Space & w:: SendInput,{Blind}^{Right}
	Space & b:: SendInput,{Blind}^{Left}

	Space & e:: SendInput,{Blind}{PgDn}
	Space & q:: SendInput,{Blind}{PgUp}


	Space & c::
		GV_KeyClickAction1 := "SendInput,^c"
		GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^c"
		GoSub,Sub_KeyClick123
	return

	Space & u::
		GV_KeyClickAction1 := "SendInput,{End}"
		GV_KeyClickAction2 := "SendInput,^{End}"
		GoSub,Sub_KeyClick123
	return

	Space & i::
		GV_KeyClickAction1 := "SendInput,{Home}"
		GV_KeyClickAction2 := "SendInput,^{Home}"
		GoSub,Sub_KeyClick123
	return

	Space & n::
		GV_KeyClickAction1 := "SendInput,{PgDn}"
		GV_KeyClickAction2 := "SendInput,^{PgDn}"
		GoSub,Sub_KeyClick123
	return

	Space & m::
		GV_KeyClickAction1 := "SendInput,{PgUp}"
		GV_KeyClickAction2 := "SendInput,^{PgUp}"
		GoSub,Sub_KeyClick123
	return

	$Space::send,{Blind}{space}
	^Space::^Space
	+Space::+Space
#If

;************** `花号键相关 ************** {{{2
;这个位置顺手，主要是在按住做了那么选择之后，再去按ctrl或者；分号等就显得远了
` & 1:: SendInput,^x
` & 2:: SendInput,^c
` & 3:: SendInput,^v
` & 4:: SendInput,{Del}
` & `;:: SendInput,{Blind}{Home}+{End}

;` & s:: SendInput,{Blind}+{Down}
;` & w:: SendInput,{Blind}+{Up}
;` & a:: SendInput,{Blind}+{Left}
;` & d:: SendInput,{Blind}+{Right}

` & j:: SendInput,{Blind}+{Down}
` & k:: SendInput,{Blind}+{Up}
` & h:: SendInput,{Blind}+{Left}
` & l:: SendInput,{Blind}+{Right}

` & b:: SendInput,{Blind}^+{Left}
` & w:: SendInput,{Blind}^+{Right}

;` & o:: SendInput,{Blind}^{PgUp}
;` & p:: SendInput,{Blind}^{PgDn}
` & n:: SendInput,{Blind}+{PgDn}
` & m:: SendInput,{Blind}+{PgUp}
;` & y:: SendInput,{Blind}{Home}+{End}
;` & u:: SendInput,{Blind}+{End}
;` & i:: SendInput,{Blind}+{Home}
` & u::
	GV_KeyClickAction1 := "SendInput,+{End}"
	GV_KeyClickAction2 := "SendInput,^+{End}"
	GoSub,Sub_KeyClick123
return

` & i::
	GV_KeyClickAction1 := "SendInput,+{Home}"
	GV_KeyClickAction2 := "SendInput,^+{Home}"
	GoSub,Sub_KeyClick123
return

` & y::
	GV_KeyClickAction1 := "SendInput,{Blind}{Home}+{End}"
	GV_KeyClickAction2 := "SendInput,{Blind}^{Home}^+{End}"
	GoSub,Sub_KeyClick123
return

;点不是默认的“确定”或者OK按钮，如果没有就点第一个Button1，适用与那种简单的对话框，比如TC的备注
` & Enter::
	try {
		SetTitleMatchMode RegEx
		SetTitleMatchMode Slow
		ControlClick, i).*确定|OK.*, A
	} catch e {
		ControlClick, Button1, A
	}
return


+`::SendInput,~
`::SendInput,``
^`::SendInput,^``
!`::SendInput,!``
+!`::SendInput,+!``
;`::EzMenuShow()


;************** Alttab相关 ************** {{{2
;按住左键再进行滚轮，在AltaTab菜单中，可以点击右键或者按空格进行确认选择。
;多用在把文件拖到别的程序中打开，或者类似于qq微信传文件。也可以将浏览器中的图片直接拖到文件管理器中保存
;LButton & WheelUp::ShiftAltTab
;LButton & WheelDown::AltTab
;就没必要还用这个了
;LWin & WheelUp::ShiftAltTab
;LWin & WheelDown::AltTab

;鼠标中操作
#If WinActive("ahk_class TaskSwitcherWnd")
{
	;Win10自己已经支持alttab中按空格选择程序
	if A_OSVersion in WIN_2003, WIN_XP, WIN_7
	{
		!Space::send,{Alt Up}
		Space::send,{Alt Up}
	}
	;在alttab的菜单中，点右键选中对应的程序
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;alt+shift+tab，切换到上一个窗口功能，放在一起共用 TaskSwitcherWnd算了
	;<+Tab::ShiftAltTab


	;左手
	!q::SendInput,{Blind}{Left}
	!s::SendInput,{Blind}{Down}
	!w::SendInput,{Blind}{Up}
	!a::SendInput,{Blind}{Left}
	!d::SendInput,{Blind}{Right}

	;右手
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
}

;Win10改成了MultitaskingViewFrame,Win11改成了XamlExplorerHostIslandWindow
#If WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class XamlExplorerHostIslandWindow") 
{
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;左手
	!q::SendInput,{Blind}{Left}
	!s::SendInput,{Blind}{Down}
	!w::SendInput,{Blind}{Up}
	!a::SendInput,{Blind}{Left}
	!d::SendInput,{Blind}{Right}

	;右手
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
}


;************** tab相关 ************** {{{2
#If GV_ToggleTabKeys=1
	;基本操作上下左右，还可以扩展，主要用在左键右鼠的操作方式
	Tab & s:: SendInput,^{Down}
	Tab & w:: SendInput,^{Up}
	Tab & a:: SendInput,^{Left}
	Tab & d:: SendInput,^{Right}
	Tab & q:: SendInput,^{PgUp}
	Tab & e:: SendInput,^{PgDn}

	;对应任务栏上固定的前5个程序快速切换
	Tab & 1:: send,#1
	Tab & 2:: send,#2
	Tab & 3:: send,#3
	Tab & 4:: send,#4
	Tab & 5:: send,#5

	;常用的三个按键
	Tab & r:: SendInput,{Del}
	Tab & f:: SendInput,{Enter}
	Tab & space:: SendInput,{Backspace}

	;这个位置按起来不舒服，但先留着
	Tab & x:: SendInput,{Del}
	Tab & z:: SendInput,{Backspace}

	;右手模式，和caps一样，随便按哪一个都行，自由发挥吧
	Tab & j:: SendInput,^{Down}
	Tab & k:: SendInput,^{Up}
	Tab & h:: SendInput,^{Left}
	Tab & l:: SendInput,^{Right}
	Tab & n:: SendInput,^{PgDn}
	Tab & m:: SendInput,^{PgUp}
	Tab & u:: SendInput,^{End}
	Tab & i:: SendInput,^{Home}

	;各个程序对应小菜单
	Tab & v:: GoSub,EzOtherMenuShow

	;粘贴然后回车，多用在搜索框等输入的位置，一个双手，一个单手
	Tab & g::
		GV_KeyClickAction1 := "SendInput,^v{Enter}"
		GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^v{Enter}"
		GoSub,Sub_KeyClick123
	return

	;转到Vim进行编辑
	Tab & c::
		GV_KeyClickAction1 := "GoSub,Sub_CopyVim"
		GV_KeyClickAction2 := "GoSub,Sub_CopyAllVim"
		GoSub,Sub_KeyClick123
	return

	;重要的alttab菜单
	<!Tab::AltTab

	;恢复tab自身功能
	Tab:: SendInput,{Tab}
	;双击tab，会明显减慢tab的响应速度，不用
	;Tab::
		;GV_KeyTimer := 150
		;GV_KeyClickAction1 := "SendInput,{Tab}"
		;GV_KeyClickAction2 := "SendInput,#{Tab}"
		;GoSub,Sub_KeyClick123
	;return

	#Tab:: SendInput,#{Tab}
	+Tab:: SendInput,+{Tab}
	^Tab:: SendInput,^{Tab}
	^+Tab:: SendInput,^+{Tab}

#If 


;************** 单键模式 ************** {{{2
#If GV_ToggleKeyMode=1
	j::Send {Down}
	k::Send {Up}
	h::Send {Left}
	l::Send {Right}
	y:: Send {Click Right}

	u::
		GV_KeyClickAction1 := "SendInput,{End}"
		GV_KeyClickAction2 := "SendInput,^{End}"
		GoSub,Sub_KeyClick123
	return

	i::
		GV_KeyClickAction1 := "SendInput,{Home}"
		GV_KeyClickAction2 := "SendInput,^{Home}"
		GoSub,Sub_KeyClick123
	return

	n::
		GV_KeyClickAction1 := "SendInput,{PgDn}"
		GV_KeyClickAction2 := "SendInput,^{PgDn}"
		GoSub,Sub_KeyClick123
	return

	m::
		GV_KeyClickAction1 := "SendInput,{PgUp}"
		GV_KeyClickAction2 := "SendInput,^{PgUp}"
		GoSub,Sub_KeyClick123
	return

	o:: send,{Blind}^+{Tab}
	p:: send,{Blind}^{Tab}
	.:: SendInput,^w
	w:: SendInput,^w

	`;:: Send {Click}
	,:: SendInput,{Escape}
#If



;************** 截图小功能 ************** {{{2
>!Space::fun_NircmdScreenShot(1)
^PrintScreen::fun_NircmdScreenShot(0)
+PrintScreen::fun_NircmdScreenShot(1)

fun_NircmdScreenShot(wd)
{
	;1 ActiveWin ,0 WholeDesktop
	ScreenShotPath := "D:\"
	if(wd = 1) {
		SSFileName = % ScreenShotPath . "SSAW-" . fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
	}
	else {
		SSFileName = % ScreenShotPath . "SSWD-" .  fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
	}

	run nircmd savescreenshotwin "%SSFileName%"
	if(GV_ScreenShot2Clip = 1){
		sleep,1000
		run,nircmd clipboard copyimage "%SSFileName%"
	}
	sleep,1000
	EzTip(SSFileName,2)
}

;************** 窗口相关 ************** {{{2
;去掉标题栏
#f11::
	;WinSet, Style, ^0xC00000, A ;用来切换标题行，主要影响是无法拖动窗口位置。
	;WinSet, Style, ^0x40000, A ;用来切换sizing border，主要影响是无法改变窗口大小。
	GoSub, Sub_WindowNoCaption
return



;************** mouse鼠标相关 ************** {{{2
;鼠标侧边键XButton2,ahk只认这两个，可以自行去掉注释
XButton2::Send,{PgUp}
XButton1::Send,{PgDn}
XButton2 & XButton1::SendInput,{Escape}
XButton1 & XButton2::SendInput,{Escape}

;************** 几种模式的开关，暂停重启 ************** {{{2
ScrollLock::
CapsLock & /::
Escape & /::
	GV_ToggleKeyMode := !GV_ToggleKeyMode
	if(GV_ToggleKeyMode == 1)
		tooltip 单键模式启用
	else
		tooltip 单键模式关闭
	sleep 2000
	tooltip
return

^!#Space::
	GV_ToggleSpaceKeys := !GV_ToggleSpaceKeys
	if(GV_ToggleSpaceKeys == 1)
		tooltip 空格组合键启用
	else
		tooltip 空格组合键关闭
	sleep 2000
	tooltip
return

;直接用ctrl+win+alt+tab键会引发alttab，不合适。而caps和花号是不考虑模式都在的。故用花号。
^!#`::
	GV_ToggleTabKeys := !GV_ToggleTabKeys
	if(GV_ToggleTabKeys == 1)
		tooltip Tab组合键启用
	else
		tooltip Tab组合键关闭
	sleep 2000
	tooltip
return


;暂停热键，可以再按恢复
Pause::
^!#t::
;Escape & Pause::
;CapsLock & Pause::
	suspend permit
	suspend toggle
return

;暂停脚本，可以右键菜单选择或者用重启脚本恢复
^!#z:: 
	suspend permit
	pause toggle
return

^!#r::
	Gosub,ForceSelfReload
return

;解决Win10中任务栏无法切换的臭毛病
^!#e::run,nircmd shellrefresh


;************** 应用程序相关 ************** {{{1
;************** _group相关 ************** {{{2
#IfWinActive, ahk_group group_browser
	F1:: SendInput,^t
	F2:: send,{Blind}^+{Tab}
	F3:: send,{Blind}^{Tab}
	F4:: SendInput,^w

	;`;:: 
		;;msgbox % GetCursorShape()
		;;64位的Win7下，在输入框中是148003967
		;If (GetCursorShape() = GV_CursorInputBox)      ;I 型光标
			;SendInput,`;
		;else 
			;Send {Click}
	;return
	;!`;:: Send {Click Right}
	;^`;:: Send,`;


	;按住左键点右键发送Ctrl+W关闭标签
	~LButton & RButton:: send ^w


	~LButton::
		GV_LongClickAction := "SendInput,{MButton}"
		GV_MouseButton := 1
		GoSub,Sub_ButtonLongPress
	return

	XButton1 & RButton::SendInput,^c
	XButton2 & RButton::SendInput,^c

	XButton2 & XButton1::GoSub,Sub_Idm2Mpv
	XButton1 & XButton2::GoSub,Sub_Idm2Mpv

	XButton1 & WheelUp::SendInput,{Blind}{Left}
	XButton2 & WheelUp::SendInput,{Blind}{Left}
	XButton1 & WheelDown::SendInput,{Blind}{Right}
	XButton2 & WheelDown::SendInput,{Blind}{Right}

	Tab & WheelUp:: SendInput,{Blind}{Left}
	Tab & WheelDown::SendInput,{Blind}{Right}

	XButton2::
		p := ClickAndLongClick()
		If (p = "0") {
			;单击
			if GV_GroupBrowserToggleWheelModeLeftRight 
				SendInput,{MButton}
			else
				Send,{PgUp}
		} Else If (p = "00") {
			;双击
			GV_GroupBrowserToggleWheelModeLeftRight := !GV_GroupBrowserToggleWheelModeLeftRight
			eztip("切换鼠标滚轮模式" . GV_GroupBrowserToggleWheelModeLeftRight,2)
		}
	return

	XButton1::
		p := ClickAndLongClick()
		If (p = "0") {
			;单击
			if GV_GroupBrowserToggleMButtonMode 
				SendInput,{MButton}
			else
				Send,{PgDn}
		} Else If (p = "00") {
			;双击
			GV_GroupBrowserToggleMButtonMode := !GV_GroupBrowserToggleMButtonMode
			eztip("切换侧边键作为中键" . GV_GroupBrowserToggleMButtonMode,2)
		} Else If (p = "01") {
			;双击再按住
			GV_GroupBrowserToggleWheelModeUpDown := !GV_GroupBrowserToggleWheelModeUpDown
			eztip("切换滚轮为翻页" . GV_GroupBrowserToggleWheelModeUpDown,2)
		}
	return


	;浏览器中切换滚轮模式，主要是方便看视频，西瓜和B站
	<!Space::
		GV_GroupBrowserToggleWheelModeLeftRight := !GV_GroupBrowserToggleWheelModeLeftRight
		eztip("鼠标滚轮模式切换" . GV_GroupBrowserToggleWheelModeLeftRight,2)
	return

	WheelUp::
		if GV_GroupBrowserToggleWheelModeLeftRight {
			SendInput,{Blind}{Left}
		} else if GV_GroupBrowserToggleWheelModeUpDown {
			SendInput,{Blind}{PgUp}
		} else {
			SendInput,{WheelUp}
		}
	return
	WheelDown::
		if GV_GroupBrowserToggleWheelModeLeftRight {
			SendInput,{Blind}{Right}
		} else if GV_GroupBrowserToggleWheelModeUpDown {
			SendInput,{Blind}{PgDn}
		} else {
			SendInput,{WheelDown}
		}
	return

#IfWinActive

;在浏览器中单独启用空格组合键
#If WinActive("ahk_group group_browser") and (GV_GroupBrowserToggleSpaceKeys = 1)
{

	Space & j:: SendInput,{Blind}{Down}
	Space & k:: SendInput,{Blind}{Up}
	Space & h:: SendInput,{Blind}{Left}
	Space & l:: SendInput,{Blind}{Right}

	Space & WheelUp::SendInput,{Blind}{Left}{Space up}
	Space & WheelDown::SendInput,{Blind}{Right}{Space up}

	Space & w:: SendInput,{Blind}^{Right}
	Space & b:: SendInput,{Blind}^{Left}

	Space & e:: SendInput,{Blind}{PgDn}
	Space & q:: SendInput,{Blind}{PgUp}

	Space & d:: SendInput,{Del}
	Space & s:: SendInput,^v{Enter}
	Space & \:: SendInput,^a^v{Enter}

	;先将鼠标光标停在链接上，在链接上右键菜单，然后选另存为
	Space & a:: 
		Send,{RButton}
		sleep,200
		send,k
	return

	;复制文本
	Space & RButton:: SendInput,^c
	;粘贴

	XButton2 & LButton::
	Space & LButton::
		If (GetCursorShape() = GV_CursorInputBox){
			SendInput,{Click}
			sleep,100
			SendInput,^v{Enter}
		} else if(GetCursorShape() = GV_CursorClick) {
			SendInput,{MButton}
		} else {
			SendInput,{Enter}
		}
	return


	;连击3下用来选中文本段落，然后复制
	Space & XButton1:: 
		Send,{Click 3}
		sleep 100
		Send,^c
	return

	Space & x::
		GV_KeyClickAction1 := "SendInput,^x"
		GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^x"
		GoSub,Sub_KeyClick123
	return

	Space & c::
		GV_KeyClickAction1 := "SendInput,^c"
		GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^c"
		GoSub,Sub_KeyClick123
	return

	Space & v::
		GV_KeyClickAction1 := "SendInput,^v"
		GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^v"
		GoSub,Sub_KeyClick123
	return

	Space & u::
		GV_KeyClickAction1 := "SendInput,{End}"
		GV_KeyClickAction2 := "SendInput,^{End}"
		GoSub,Sub_KeyClick123
	return

	Space & i::
		GV_KeyClickAction1 := "SendInput,{Home}"
		GV_KeyClickAction2 := "SendInput,^{Home}"
		GoSub,Sub_KeyClick123
	return

	Space & n::
		GV_KeyClickAction1 := "SendInput,{PgDn}"
		GV_KeyClickAction2 := "SendInput,^{PgDn}"
		GoSub,Sub_KeyClick123
	return

	Space & m::
		GV_KeyClickAction1 := "SendInput,{PgUp}"
		GV_KeyClickAction2 := "SendInput,^{PgUp}"
		GoSub,Sub_KeyClick123
	return

	Space & f::GoSub,Sub_Idm2Mpv

	;$Space::send,{Blind}{space}

	Space::space
	^Space::^Space
	+Space::+Space
}

Sub_Idm2Mpv:
	;先点击IDM浮动
	ControlGetPos, x, y, w, h, IDM Download Button class1
	ControlClick, IDM Download Button class1, , , LEFT, 1, x12 y8
	sleep 500
	MouseMove, x,y
	;再来处理，自己选择具体哪一条清晰度等
	sleep 3000

	WinWait, 下载文件信息 ahk_class #32770, , 20
	IfWinNotActive, 下载文件信息 ahk_class #32770, , WinActivate, 下载文件信息 ahk_class #32770
	WinWaitActive, 下载文件信息 ahk_class #32770, , 20

	;WinWaitActive, 下载文件信息 ahk_class #32770, , 20
	if !ErrorLevel
	{
		;ControlGetText,Out,Edit1,下载文件信息 ahk_class #32770 ahk_exe IDMan.exe
		ControlGetText,Out,Edit1,下载文件信息 ahk_class #32770
		WinClose,下载文件信息 ahk_class #32770
		run,%A_ScriptDir%\Plugins\WLX\vlister\mpv.exe "%Out%"
	}
return


#IfWinActive, ahk_group group_disableCtrlSpace
	^Space::Controlsend,,^{Space}
	+Space::Controlsend,,+{Space}
#IfWinActive



;totalcmd中特殊的按住左键点右键移动
;#IfWinNotActive ahk_class TTOTAL_CMD
;~LButton & RButton::
	;;opera 等少数软件之中都可以有自己的按住左键点右键功能
	;if not WinActive("ahk_class OperaWindowClass") and not WinActive("GreenBrowser"){
	;send ^w
	;}
;return 
;#IfWinNotActive




;************** 记事本 ************** {{{1

;启动记事本并去标题等 {{{3
#n::
	run %A_ScriptDir%\Tools\notepad\Notepad.exe /f %A_ScriptDir%\Tools\notepad\Lite.ini, , , OutputVarPID
	sleep 100
	WinWait ahk_pid %OutputVarPID%
	if ErrorLevel
	{
		toolTip 超时了，再试一下？
		sleep 2000
		tooltip
		return
	}
	else
	{
		PID = %OutputVarPID%
		WinGet, ThisHWND, ID, ahk_pid %PID% 
		;设置位置和大小, x,y,width,height
		;WinMove, ahk_id %ThisHWND%,, 700,400,550,350
		WinMove, ahk_id %ThisHWND%,, 700,600,310,144
		;WinMove, ahk_pid %PID%,, 700,400,550,350
		;去标题
		;WinSet, Style, ^0xC00000, ahk_pid %PID%
		;不能改变大小
		;WinSet, Style, ^0x40000, ahk_pid %PID%
		;去菜单
		DllCall("SetMenu", "Ptr", ThisHWND, "Ptr", 0)
		;顶端
		;Winset, Alwaysontop, On,  ahk_pid %PID%
	}
return

;启动记事本并去标题等，并收集剪贴板 {{{3
^#n::
	run %A_ScriptDir%\Tools\notepad\Notepad.exe /b /f %A_ScriptDir%\Tools\notepad\Lite.ini, , , OutputVarPID
	sleep 100
	WinWait ahk_pid %OutputVarPID%
	if ErrorLevel
	{
		toolTip 超时了，再试一下？
		sleep 2000
		tooltip
		return
	}
	else
	{
		PID = %OutputVarPID%
		WinGet, ThisHWND, ID, ahk_pid %PID% 
		;设置位置和大小, x,y,width,height
		;WinMove, ahk_id %ThisHWND%,, 700,400,550,350
		WinMove, ahk_id %ThisHWND%,, 700,600,310,144
		;WinMove, ahk_pid %PID%,, 700,400,550,350
		;去标题
		;WinSet, Style, ^0xC00000, ahk_pid %PID%
		;不能改变大小
		;WinSet, Style, ^0x40000, ahk_pid %PID%
		;去菜单
		DllCall("SetMenu", "Ptr", ThisHWND, "Ptr", 0)
		;顶端
		;Winset, Alwaysontop, On,  ahk_pid %PID%
	}
return



;************** 例子,建议从这里修改 ************** {{{1
;建议的绿色便携的小菜单程序PopSel
#z::
	if(GV_PopSel_QSel="popsel") {
		run %A_ScriptDir%\Tools\popsel\PopSel.exe /pc /T500
		sleep 500
		MyWinWaitActive("PopSel - ahk_class WindowClass_0")
	}
	else if(GV_PopSel_QSel="qsel") {
		run,"%A_ScriptDir%\Tools\qsel\Qsel.exe", %A_ScriptDir%\Tools\qsel
		sleep 500
		MyWinWaitActive("Qsel  ahk_class WindowClass_0")
	}
return

#RButton::
	if(GV_PopSel_QSel="popsel") {
		run %A_ScriptDir%\Tools\popsel\PopSel.exe /i /T500
		sleep 500
		MyWinWaitActive("PopSel - ahk_class WindowClass_0")
	}
	else if(GV_PopSel_QSel="qsel") {
		run,"%A_ScriptDir%\Tools\qsel\Qsel.exe", %A_ScriptDir%\Tools\qsel
		sleep 500
		MyWinWaitActive("Qsel  ahk_class WindowClass_0")
	}
return

;#z::
	;run %A_ScriptDir%\Tools\popsel\PopSel.exe /pc /T500
	;sleep 500
	;MyWinWaitActive("PopSel - ahk_class WindowClass_0")
;return

;#RButton::
	;run %A_ScriptDir%\Tools\popsel\PopSel.exe /i /T500
	;sleep 500
	;MyWinWaitActive("PopSel - ahk_class WindowClass_0")
;return

;建议的绿色便携的小菜单程序Qsel，这两个二选一即可
;#z::
	;run,"%A_ScriptDir%\Tools\qsel\Qsel.exe", %A_ScriptDir%\Tools\qsel
	;sleep 500
	;MyWinWaitActive("Qsel  ahk_class WindowClass_0")
;return

;#RButton::
	;run,"%A_ScriptDir%\Tools\qsel\Qsel.exe", %A_ScriptDir%\Tools\qsel
	;sleep 500
	;MyWinWaitActive("Qsel  ahk_class WindowClass_0")
;return

#f:: 
	run %A_ScriptDir%\Everything.exe
	sleep 500
	MyWinWaitActive("ahk_class EVERYTHING")
return

#h::run, cmd
;管理员权限cmd
^#h::run, *RunAs cmd
#c::run %A_ScriptDir%\Tools\notepad\Notepad.exe /c

#F5::run winword.exe
#F6::run excel.exe
#F7::run powerpnt.exe

;************** 各程序快捷键或功能 ************** {{{1
;调用任务栏相关程序快捷键 {{{2
;用鼠标中键作为组合键来进行切换，默认注释掉
;MButton::Send,{MButton}
;MButton & Tab::
XButton1 & Tab::
XButton2 & Tab::
`; & Tab::
	;Totalcmd
	send,#1
return

XButton1 & Capslock::
XButton2 & Capslock::
`; & Capslock::
	;Vim
	send,#2
return

XButton1 & q::
XButton2 & q::
`; & q::
	;QQ
	send,#3
return

XButton1 & w::
XButton2 & w::
`; & w::
	;微信
	send,#4
return

XButton1 & e::
XButton2 & e::
`; & e::
	send,#5
return


XButton1 & r::
XButton2 & r::
`; & r::
	send,#6
return

XButton1 & t::
XButton2 & t::
`; & t::
	send,#7
return


;Ctrl+Alt+点击，定位程序对应的目录
^!LButton::
	Send {Click}
	WinGet, ProcessPath, ProcessPath, A
	;Run Explorer /select`, %ProcessPath%
	run,"%COMMANDER_EXE%" /T /O /S /L="%ProcessPath%"
	WinActivate, ahk_class TTOTAL_CMD
return

;把资源管理器中选中的文件用tc打开  {{{2
;Win10的资源管理器
;资源管理器
#If WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
{
	!w::
		if(COMMANDER_EXE="")
			return
		selected := Explorer_Get("",true)

		;如果没有选中文件，那就直接用当前目录
		if(selected = "")
		{
			WinGetText, CurWinAllText
			Loop, parse, CurWinAllText, `n, `r
			{
				If RegExMatch(A_LoopField, "^地址: "){
					curWinPath := SubStr(A_LoopField,5)
					break
				}
			}
			selected := curWinPath
		}

		selected := """" selected """"
		;msgbox % selected
		WinClose A  ;把当前资源管理器关闭
		run, %COMMANDER_EXE% /T /O /S /A /L=%selected%
	return
}
;桌面
#If WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")
{
	!w::
		if(COMMANDER_EXE="")
			return
		selected := Explorer_Get("",true)
		if(selected = ""){
			selected := """" A_Desktop """"
			run, %COMMANDER_EXE% /T /O /A /S /L=%selected%
			sleep 200
			selected := """" A_DesktopCommon """"
			run, %COMMANDER_EXE% /T /O /A /S /R=%selected%
		}
		else{
			selected := """" selected """"
			run, %COMMANDER_EXE% /T /O /S /A /L=%selected%
		}
	return
}

;用到的函数
Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}

Explorer_GetWindow(hwnd="")
{
	WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
	WinGetClass class, ahk_id %hwnd%

	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		try{
			for window in ComObjCreate("Shell.Application").Windows
				if (window.hwnd==hwnd)
					return window
		}
		catch {
			return ""
		}
	}
	else if (class ~= "Progman|WorkerW")
		return "desktop"
}


Explorer_Get(hwnd="",selection=false)
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path%
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}


;QQ,Tim中快速定位聊天位置 {{{2
;Tim
#If WinActive("ahk_class TXGuiFoundation") and WinActive("ahk_exe Tim.exe")
{
	!1::CoordWinClick(Tim_Start_X, Tim_Start_Y+(1-1)*Tim_Bar_Height)
	!2::CoordWinClick(Tim_Start_X, Tim_Start_Y+(2-1)*Tim_Bar_Height)
	!3::CoordWinClick(Tim_Start_X, Tim_Start_Y+(3-1)*Tim_Bar_Height)
	!4::CoordWinClick(Tim_Start_X, Tim_Start_Y+(4-1)*Tim_Bar_Height)
	!5::CoordWinClick(Tim_Start_X, Tim_Start_Y+(5-1)*Tim_Bar_Height)
	!6::CoordWinClick(Tim_Start_X, Tim_Start_Y+(6-1)*Tim_Bar_Height)
	!7::CoordWinClick(Tim_Start_X, Tim_Start_Y+(7-1)*Tim_Bar_Height)
	!8::CoordWinClick(Tim_Start_X, Tim_Start_Y+(8-1)*Tim_Bar_Height)
	!9::CoordWinClick(Tim_Start_X, Tim_Start_Y+(9-1)*Tim_Bar_Height)
	!0::CoordWinClick(Tim_Start_X, Tim_Start_Y+(10-1)*Tim_Bar_Height)
	!-::CoordWinClick(Tim_Start_X, Tim_Start_Y+(11-1)*Tim_Bar_Height)
	!=::CoordWinClick(Tim_Start_X, Tim_Start_Y+(12-1)*Tim_Bar_Height)
	!f::
		;这里改成自己对应的路径
		run,"%COMMANDER_EXE%" /T /O /S /L="D:\My Documents\Tencent Files\123456789自己的qq号码\FileRecv\"
		sleep 500
		MyWinWaitActive("ahk_class TTOTAL_CMD")
	return
}

;QQ
#If WinActive("ahk_class TXGuiFoundation") and WinActive("ahk_exe QQ.exe")
{
	!1::CoordWinClick(QQ_Start_X, QQ_Start_Y+(1-1)*QQ_Bar_Height)
	!2::CoordWinClick(QQ_Start_X, QQ_Start_Y+(2-1)*QQ_Bar_Height)
	!3::CoordWinClick(QQ_Start_X, QQ_Start_Y+(3-1)*QQ_Bar_Height)
	!4::CoordWinClick(QQ_Start_X, QQ_Start_Y+(4-1)*QQ_Bar_Height)
	!5::CoordWinClick(QQ_Start_X, QQ_Start_Y+(5-1)*QQ_Bar_Height)
	!6::CoordWinClick(QQ_Start_X, QQ_Start_Y+(6-1)*QQ_Bar_Height)
	!7::CoordWinClick(QQ_Start_X, QQ_Start_Y+(7-1)*QQ_Bar_Height)
	!8::CoordWinClick(QQ_Start_X, QQ_Start_Y+(8-1)*QQ_Bar_Height)
	!9::CoordWinClick(QQ_Start_X, QQ_Start_Y+(9-1)*QQ_Bar_Height)
	!0::CoordWinClick(QQ_Start_X, QQ_Start_Y+(10-1)*QQ_Bar_Height)
	!-::CoordWinClick(QQ_Start_X, QQ_Start_Y+(11-1)*QQ_Bar_Height)
	!=::CoordWinClick(QQ_Start_X, QQ_Start_Y+(12-1)*QQ_Bar_Height)
	!f::
		;这里改成自己对应的路径
		run,"%COMMANDER_EXE%" /T /O /S /L="D:\My Documents\Tencent Files\123456789自己的qq号码\FileRecv\"
		sleep 500
		MyWinWaitActive("ahk_class TTOTAL_CMD")
	return
}


;微信PC客户端 {{{2
#IfWinActive ahk_exe WeChat.exe
{
	;聚焦搜索框
	!/::CoordWinClick(100,36)
	;点击绿色聊天的数字
	!,::
		CoordMode, Mouse, Window
		click 28,90 2
		Sleep,100
		click 180,100
	Return
	;聚焦打字框
	!`;::
		WinGetPos, wxx, wxy,wxw,wxh, ahk_class WeChatMainWndForPC
		wxw := wxw - 80
		wxh := wxh - 60
		CoordWinClick(wxw,wxh)
	return

	!1::CoordWinClick(WX_Start_X, WX_Start_Y+(1-1)*WX_Bar_Height)
	!2::CoordWinClick(WX_Start_X, WX_Start_Y+(2-1)*WX_Bar_Height)
	!3::CoordWinClick(WX_Start_X, WX_Start_Y+(3-1)*WX_Bar_Height)
	!4::CoordWinClick(WX_Start_X, WX_Start_Y+(4-1)*WX_Bar_Height)
	!5::CoordWinClick(WX_Start_X, WX_Start_Y+(5-1)*WX_Bar_Height)
	!6::CoordWinClick(WX_Start_X, WX_Start_Y+(6-1)*WX_Bar_Height)
	!7::CoordWinClick(WX_Start_X, WX_Start_Y+(7-1)*WX_Bar_Height)
	!8::CoordWinClick(WX_Start_X, WX_Start_Y+(8-1)*WX_Bar_Height)
	!9::CoordWinClick(WX_Start_X, WX_Start_Y+(9-1)*WX_Bar_Height)
	!0::CoordWinClick(WX_Start_X, WX_Start_Y+(10-1)*WX_Bar_Height)

	;这里请修改everything中的书签，确保ev中书签名字保持一致
	!e::
		run, "%A_ScriptDir%\everything.exe" -bookmark wechatfile
	return
	;这里请修改tc中搜索条件的目录位置 改成自己的 ，

	;将tc中默认D:\My Documents\WeChat Files\corals\FileStorage\MsgAttach改成自己的MsgAttac所在目录全路径
	!f::
		wx_path = % "D:\My Documents\WeChat Files\corals\FileStorage\File\" . fun_GetFormatTime( "yyyy-MM" )
		run,"%COMMANDER_EXE%" /T /O /S /L="%wx_path%"
		sleep 500
		MyWinWaitActive("ahk_class TTOTAL_CMD")

		;MyWinWaitActive("ahk_class TTOTAL_CMD")
		;TcSendUserCommand("em_loadSearchWechatFile")
		;Sleep,500
		;send,!s
		;Sleep,2000
		;send,!l
	return

	;点右键选删除
	!d::
		send,{RButton}
		Sleep,200
		send,{Up 2}{Enter}
		Sleep,500
		send,{Enter}
	Return

	;点右键选撤回
	!c::
		send,{RButton}
		Sleep,200
		send,{Down 2}{Enter}
	Return
}


;微信
;#If WinActive("图片查看 ahk_exe WeChat.exe")
#If WinActive("图片查看 ahk_class ImagePreviewWnd") or WinActive("微信 ahk_class ImagePreviewLayerWnd")
{
	XButton1::Send,{Right}
	XButton2::Send,{Left}
	!WheelUp::Send,{Left}
	!WheelDown::Send,{Right}
	space & WheelUp::Send,{Left}
	space & WheelDown::Send,{Right}

	h::send,{Left}
	l::send,{Right}
	a::send,{Left}
	d::send,{Right}

	`;::send,{Esc}

	;双击右键关闭
	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,{Escape}"
		GV_MouseButton := 2
		GV_LongClickAction := "Send,{Escape}"
		GoSub,Sub_MouseClick123
	return

	Enter:: GoSub,Sub_MaxRestore
	;对视频内容点击播放
	space:: 
		WinGetPos, x, y,lengthA,hightA, A
		;MouseMove, % lengthA/2 ,hightA/2
		CoordWinClick(lengthA/2,hightA/2)
	return

}

;微信中的页面
#IfWinActive 微信 ahk_class CefWebViewWnd
{
	j::send,{PgDn}
	k::send,{PgUp}
	u::send,{End}
	i::send,{Home}
	`;::send,{Esc}
	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,{Escape}"
		GV_MouseButton := 2
		GV_LongClickAction := "Send,{Escape}"
		GoSub,Sub_MouseClick123
	return
}

;微信聊天记录
#IfWinActive ahk_class FileManagerWnd ahk_exe WeChat.exe
{
	`;::send,{Esc}
	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,{Escape}"
		GV_MouseButton := 2
		GV_LongClickAction := "Send,{Escape}"
		GoSub,Sub_MouseClick123
	return
}

;微信中转发的聊天记录
#IfWinActive ahk_class ChatRecordWnd
{
	`;::send,{Esc}
	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,{Escape}"
		GV_MouseButton := 2
		GV_LongClickAction := "Send,{Escape}"
		GoSub,Sub_MouseClick123
	return
}

;QQ Tim中查看照片
#If WinActive("图片查看 ahk_class TXGuiFoundation")
{
	XButton1::Send,{Left}
	XButton2::Send,{Right}
	!WheelUp::Send,{Left}
	!WheelDown::Send,{Right}

	h::send,{Left}
	l::send,{Right}

	`;::send,{Esc}

	space & WheelUp::Send,{Left}
	space & WheelDown::Send,{Right}
	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,{Escape}"
		GoSub,Sub_MouseClick123
	return
}

;F4menu中
#If WinActive("F4Menu ahk_class F4Menu")
{
	space:: Send,{Enter}
}

;telegram {{{2
#IfWinActive ahk_exe Telegram.exe
{
	!/::CoordWinClick(150,52)
	!1::CoordWinClick(TG_Start_X, TG_Start_Y+(1-1)*TG_Bar_Height)
	!2::CoordWinClick(TG_Start_X, TG_Start_Y+(2-1)*TG_Bar_Height)
	!3::CoordWinClick(TG_Start_X, TG_Start_Y+(3-1)*TG_Bar_Height)
	!4::CoordWinClick(TG_Start_X, TG_Start_Y+(4-1)*TG_Bar_Height)
	!5::CoordWinClick(TG_Start_X, TG_Start_Y+(5-1)*TG_Bar_Height)
	!6::CoordWinClick(TG_Start_X, TG_Start_Y+(6-1)*TG_Bar_Height)
	!7::CoordWinClick(TG_Start_X, TG_Start_Y+(7-1)*TG_Bar_Height)
	!8::CoordWinClick(TG_Start_X, TG_Start_Y+(8-1)*TG_Bar_Height)
	!9::CoordWinClick(TG_Start_X, TG_Start_Y+(9-1)*TG_Bar_Height)
	!0::CoordWinClick(TG_Start_X, TG_Start_Y+(10-1)*TG_Bar_Height)
}

;IDM的下载对话框中，提取url链接，然后用MPC播放 {{{2
#IfWinActive 下载文件信息
	if WinActive ahk_class #32770{
		RButton::
			ControlGetText,Out,Edit1
			WinClose A
			;run,%COMMANDER_PATH%\Tools\MPC\mpc.exe "%Out%"
			run,%A_ScriptDir%\Plugins\WLX\vlister\mpv.exe "%Out%"
		return
	}
#IfWinActive


;IDM的下载完成对话框中，提取文件信息，然后跳转到tc
#If WinActive("下载完成 ahk_class #32770 ahk_exe IDMan.exe")
{
	!g::
	RButton::
		ControlGetText,Out,Edit4
		WinClose A
		run,"%COMMANDER_EXE%" /A /T /O /S /L="%Out%"
		sleep 500
		MyWinWaitActive("ahk_class TTOTAL_CMD")
	return
}

;IDM界面
#If WinActive("Internet Download Manager ahk_class #32770 ahk_exe IDMan.exe")
{
	!f::
		run,"%COMMANDER_EXE%" /T /O /S /L="D:\Downloads\IDM\"
		sleep 500
		MyWinWaitActive("ahk_class TTOTAL_CMD")
	return
}


TC_Focus_Edit(){
	If (A_Cursor = "IBeam" ) {
		GV_Edit_Mode := 1
	} else if(A_Cursor = "Arrow" ) {
		GV_Edit_Mode := 0
	}
	ControlGetFocus theFocus, A
	return (inStr(theFocus , "Edit") or (GV_Edit_Mode = 1))
}


fun_TCselectFileByNum(n){
	;如果是0就获取总共几个
	if(n=0) {
		;1000 to get active panel: 1=left, 2=right (32/64)
		tcLeftRight := fun_TcGet(1000)
		sMsg := % 1000 + tcLeftRight
		;1001/1002 to get number of items in left/right list (32/64)
		n := fun_TcGet(sMsg) - 1
	}
	ControlGetFocus, Ctrl, AHK_CLASS TTOTAL_CMD
	Postmessage, 0x19E, %n%, 1, %Ctrl%, AHK_CLASS TTOTAL_CMD
	Sendinput,{Enter}
}

;判断当前tc中是否正在显示着收藏夹菜单
fun_TcExistHotMenu(){
	Dlg_HWnd := WinExist("ahk_class #32768 ahk_exe TOTALCMD.EXE")
	return Dlg_HWnd
}

fun_TcGet(n)
{
	SendMessage,1074, %n%, 0, , Ahk_class TTOTAL_CMD
	return % ErrorLevel
}

ClickAndLongClick(timeout = 200) { ;
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
	  t := A_TickCount
	  KeyWait %key%
	  Pattern .= A_TickCount-t > timeout
	  KeyWait %key%,DT%tout%
	  If (ErrorLevel)
		 Return Pattern
   }
}
;0单击
;00双击
;01就短按+长按
;001就是双击+长按


Sub_TcSrcActivateLastTab:
	TcSendPos(5001)
	TcSendPos(3006)
return

;TC备注中快速星号评级
#IfWinActive 文件备注 ahk_class TCmtEditForm ahk_exe totalcmd.exe 
{
!0::
!1::
!2::
!3::
!4::
!5::
	ControlFocus, TMyMemo1
	ControlGetText, preText, TMyMemo1
	cnt := SubStr(A_ThisHotkey,2)
	text := StrRepeat("★", cnt) . StrRepeat("☆", 5-cnt)
	if StrLen(preText) >0 
		text .=  "`r`n" preText
	ControlSetText,  TMyMemo1, %text%
	return
}
StrRepeat(str, count){
	res = 
	Loop, % count{
		res .= str
	} 
	Return res
}


;Totalcmd中快搜
#IfWinActive QUICKSEARCH ahk_class TQUICKSEARCH
{
	;快搜输入框中不能直接数字，就用空格加数字，也可以先按caps取消输入框状态再单独按数字
	;眼睛适合辨认的也就前5
	Space & 1::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(1)
	Return
	Space & 2::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(2)
	Return
	Space & 3::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(3)
	Return
	Space & 4::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(4)
	Return
	Space & 5::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(5)
	Return
	Space & 6::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(6)
	Return
	Space & 7::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(7)
	Return
	Space & 8::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(8)
	Return
	Space & 9::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(9)
	Return
	Space & 0::
		Sendinput,{Esc}
		Sleep,100
		fun_TCselectFileByNum(0)
	Return

	;左手alt+e作为F4
	!e::
		BlockInput On
		Sendinput,{Esc}
		Sleep,100
		Sendinput,{Alt up}
		Sendinput,{F4}
		BlockInput Off
	return

	;避免聚焦在输入框中而无法生效
	`;::
		Sendinput,{Esc}
		Sleep,100
		Sendinput,{F4}
	return

	CapsLock & Enter::return
	CapsLock & Space::return

	Space::send,{space}
	^Space::^Space
	+Space::+Space
}


;eztc totalcmd中快捷键 {{{2
#IfWinActive ahk_class TTOTAL_CMD
	Escape & f4::SendInput,!{F3}

	CapsLock & Enter:: SendInput,{Enter}
	CapsLock & Space:: SendInput,{Space}

;tc中使用数字按键来进行快速打开和快速切换标签
;开启之后如需继续使用快搜，那快搜起始键不能是数字，
;需要打开或关闭直接修改下行的注释即可

	^!+d::
		GV_TotalcmdToggleJumpByNumber := !GV_TotalcmdToggleJumpByNumber
		if(GV_TotalcmdToggleJumpByNumber == 1)
			tooltip 已启用TC中数字键跳转功能
		else
			tooltip 已关闭TC中数字键跳转功能
		sleep 2000
		tooltip
	return

	1::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,1
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(1)
			} Else If (p = "00") {
				;双击
				TcSendPos(5001)
			} Else If (p = "1") {
				;长按
				TcSendPos(5001)
				TcSendPos(2001)
			}
		}
	return

	2::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,2
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(2)
			} Else If (p = "00") {
				;双击
				TcSendPos(5002)
			} Else If (p = "1") {
				;长按
				TcSendPos(5002)
				TcSendPos(2001)
			}
		}
	return

	3::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,3
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(3)
			} Else If (p = "00") {
				;双击
				TcSendPos(5003)
			} Else If (p = "1") {
				;长按
				TcSendPos(5003)
				TcSendPos(2001)
			}
		}
	return

	4::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,4
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(4)
			} Else If (p = "00") {
				;双击
				TcSendPos(5004)
			} Else If (p = "1") {
				;长按
				TcSendPos(5004)
				TcSendPos(2001)
			}
		}
	return

	5::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,5
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(5)
			} Else If (p = "00") {
				;双击
				TcSendPos(5005)
			} Else If (p = "1") {
				;长按
				TcSendPos(5005)
				TcSendPos(2001)
			}
		}
	return

	6::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,6
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(6)
			} Else If (p = "00") {
				;双击
				TcSendPos(5006)
			} Else If (p = "1") {
				;长按
				TcSendPos(5006)
				TcSendPos(2001)
			}
		}
	return

	7::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,7
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(7)
			} Else If (p = "00") {
				;双击
				TcSendPos(5007)
			} Else If (p = "1") {
				;长按
				TcSendPos(5007)
				TcSendPos(2001)
			}
		}
	return

	8::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,8
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(8)
			} Else If (p = "00") {
				;双击
				TcSendPos(5008)
			} Else If (p = "1") {
				;长按
				TcSendPos(5008)
				TcSendPos(2001)
			}
		}
	return

	9::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,9
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(9)
			} Else If (p = "00") {
				;双击
				TcSendPos(5009)
			} Else If (p = "1") {
				;长按
				TcSendPos(5009)
				TcSendPos(2001)
			}
		}
	return

	0::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,0
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;单击
				fun_TCselectFileByNum(0)
			} Else If (p = "00") {
				;双击
				TcSendPos(5001)
				TcSendPos(3006)
			} Else If (p = "1") {
				;长按
				TcSendPos(5001)
				TcSendPos(3006)
				TcSendPos(2001)
			}
		}
	return



	;避免中文输入法的问题
	,:: 
		ControlGetFocus, TC_CurrentControl, A
		;TInEdit1 地址栏和重命名 Edit1 命令行
		if (RegExMatch(TC_CurrentControl, "TMyListBox1|TMyListBox2"))
			TcSendPos(524)   ;cm_ClearAll
		else
			send,`,
	return
	CapsLock & y:: send,{AppsKey}
	/*
	   [:: send,{Home}{Down}
	 */
	;]:: send,{End}
	;复制到对面选中目录
	!+F5::
		send,{Tab}^+c{Tab}{F5}
		Sleep,500
		send,^v
		Sleep,500
		send,{Enter 2}
	return
	;移动到对面选中目录
	!+F6::
		send,{Tab}^+c{Tab}{F6}
		Sleep,500
		send,^v
		Sleep,500
		send,{Enter 2}
	return
	;加上剪贴板中内容改名
	;ez版本中还是tcfs2实现
	;^F2::
		;send,+{F6}
		;Sleep,300
		;send,{right}
		;Sleep,300
		;send,{Space}^v
		;Sleep,300
		;send,{Enter}
	;return

	^+F2:: ;更新文件名中日期
		SendInput,{F2}
		Sleep,100
		ControlGetText,OldName,TInEdit1,ahk_class TTOTAL_CMD
		Sleep,100
		NewName:= RegExReplace(OldName,"\d\d-\d\d-\d\d",fun_GetFormatTime("yy-MM-dd"))
		Sleep,100
		ControlSetText,TInEdit1,%NewName%
		Sleep,100
		SendInput,{Enter}
	Return

	;cm_OpenDirInNewTabOther中键点击，在对面新标签中打开
	MButton::
		Send,{Click}
		Sleep 50
		TcSendPos(3004)
	return

	;cm_OpenDirInNewTab中键点击，在新标签中打开
	^MButton::
		Send,{Click}
		Sleep 50
		TcSendPos(3003)
	return

	;左手alt+e作为F4
	!e::
		BlockInput On
		Sendinput,{Esc}
		Sleep,100
		Sendinput,{Alt up}
		Sendinput,{F4}
		BlockInput Off
	return

	;双击右键，发送退格，返回上一级目录
	;~RButton::
		;KeyWait,RButton
		;KeyWait,RButton, d T0.1
		;If ! Errorlevel
		;{
		  ;send {Backspace} 
		;}
	;Return


	;花号的作用
	;`:: GoSub,Sub_azHistory
	;`:: Send,{Enter}
	`:: Send,{Appskey}
	!j::TC_azHistory()

	;智能对话框跳转
	!w::
		Dlg_HWnd := WinExist("ahk_group GroupDiagOpenAndSave")
		if Dlg_HWnd 
		;IfWinExist ahk_group GroupDiagOpenAndSave
		{
			WinGetTitle, Dlg_Title, ahk_id %Dlg_HWnd%
			If RegExMatch(Dlg_Title, "另存为|保存|图形另存为|保存副本"){
				;msgbox "这是保存对话框"
				orgClip:=clipboardAll
				Clipboard =
				;PostMessage, TC_Msg, CM_CopyFullNamesToClip,0,, ahk_class TTOTAL_CMD
				TcSendPos(CM_CopyFullNamesToClip)
				ClipWait, 1
				selFiles := Clipboard
				Clipboard:=orgClip
				selFilesArray := StrSplit(selFiles, "`n","`r")
				if selFilesArray.length() > 1 {
					selFiles:=selFilesArray[1]
					eztip("对话框是保存类型，只认第一个文件",1)
				}
				StringGetPos OutputVar, selFiles,`\,R1
				StringMid, filePath, selFiles,1, OutputVar+1
				StringMid, fileName, selFiles,OutputVar+2,StrLen(selFiles)-OutputVar

				IfWinNotActive, %Dlg_Title% ahk_id %Dlg_HWnd%, , WinActivate, %Dlg_Title% ahk_id %Dlg_HWnd%
				WinWaitActive, %Dlg_Title% ahk_id %Dlg_HWnd%
				if !ErrorLevel
				{
					ControlGetText, orgFileName,Edit1
					ControlFocus, Edit1,
					sleep 200
					Send,{Backspace}
					sleep 300
					setKeyDelay, 10,10
					ControlSetText, Edit1, %filePath% 
					sleep 900
					send,{enter}
					sleep 500
					if StrLen(fileName) > 0 {
						ControlSetText, Edit1, %fileName%, A
					}
					else{
						ControlSetText, Edit1, %orgFileName%, A
					}
				}
			}
			else {
				;msgbox "打开对话框"
				orgClip:=clipboardAll
				Clipboard =
				;PostMessage, TC_Msg, CM_CopyFullNamesToClip,0,, ahk_class TTOTAL_CMD
				TcSendPos(CM_CopyFullNamesToClip)
				ClipWait, 1
				selFiles := Clipboard
				Clipboard:=orgClip

				selFilesArray := StrSplit(selFiles, "`n","`r")
				quote:=(selFilesArray.length() > 1) ? """" : ""
				selFiles=
				Loop % selFilesArray.MaxIndex()
				{
					this_file := selFilesArray[A_Index]
					selFiles=%selFiles% %quote%%this_file%%quote%
				}
				IfWinNotActive, %Dlg_Title% ahk_id %Dlg_HWnd%, , WinActivate, %Dlg_Title% ahk_id %Dlg_HWnd%
				WinWaitActive, %Dlg_Title% ahk_id %Dlg_HWnd%
				if !ErrorLevel
				{
					sleep 300
					setKeyDelay, 10,10
					ControlSetText, Edit1, %selFiles%, A
				}
			}
			Gosub,SelfReload
		}
		else{
			EzTip("系统当前没有打开或保存对话框",2)
		}
	return

#IfWinActive

#If WinActive("ahk_class TTOTAL_CMD") and MouseUnder("(TMy|LCL)ListBox[123]")
	;长按左键，等于F4
	~LButton::
		GV_LongClickAction := "Send,{Click}{F4}"
		GoSub,Sub_ButtonLongPress
	return
#If

MouseUnder(Controls) {
  MouseGetPos,,,, Control
  If RegExMatch(Control, Controls)
    Return, True
}


TcSendPos(Number)
{
    PostMessage 1075, %Number%, 0, , AHK_CLASS TTOTAL_CMD
}

;#IfWinActive ahk_class TTOTAL_CMD
;#0::TcSendUserCommand("em_To7zip") 
;return
TcSendUserCommand(strCommand) ; string 
{ 
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area. 
	dwData := Asc("E") + 256 * Asc("M") 
	NumPut(dwData, CopyDataStruct, 0) 
	cbData := StrPutVar(strCommand, strCommand, "cp0") 
	NumPut(cbData, CopyDataStruct, A_PtrSize)  ; OS requires that this be done. 
	NumPut(&strCommand, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself. 
	SendMessage, 0x4a, 0, &CopyDataStruct,, ahk_class TTOTAL_CMD ; 0x4a is WM_COPYDATA. Must use Send not Post. 
} 
 
StrPutVar(string, ByRef var, encoding) 
{ 
	; Ensure capacity. 
	VarSetCapacity( var, StrPut(string, encoding) * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) ) 
	; Copy or convert the string. 
	return StrPut(string, &var, encoding) 
}

#IfWinActive,批量重命名 ahk_class TMultiRename
{
;F1::Send,!p{tab}{enter}e
F1::Send,{F10}e
}


;wps中 {{{2
;excel 2010: ahk_class bosa_sdm_XL9  excel2013: ahk_class XLMAIN ahk_exe C:\Windows\System32\Notepad.exe
#IfWinActive ahk_Class QWidget ahk_exe wps.exe
{
	;复制单元格纯文本
	!c:: 
		send,{F2}
		sleep,100
		send,^+{Home}
		sleep,100
		send,^c{Esc}
	return
	;插入行
	!1::send,!hrcer
	;插入列
	!2::send,!hrcec
	;自动行高
	![::send,!hrca
	;自动列宽
	!]::send,!hrci
}

;excel中 {{{2
;excel 2010: ahk_class bosa_sdm_XL9  excel2013: ahk_class XLMAIN 
;#IfWinActive ahk_exe excel.exe 
#If WinActive("ahk_exe excel.exe") or WinActive("ahk_class XLMAIN")
{
	;复制单元格纯文本
	!c:: send,{F2}^+{Home}^c{Esc}
	;筛选
	f3::PostMessage, 0x111, 447, 0, , a   
	;定位
	!g::ControlClick, Edit1
	;详细编辑
	!;::
		ControlClick, EXCEL<1
		send,{Home}
	return
	;自行调整行高
	![::
		try{
			ox := ComObjActive("Excel.Application")
			ox.Application.Selection.EntireRow.AutoFit
		}
		catch e{
			;出错就用传统快捷键
			Send,!ora
		}
	return
	;自行调整列宽
	!]::
		try{
			ox := ComObjActive("Excel.Application")
			ox.Application.Selection.EntireColumn.AutoFit
		}
		catch e{
			Send,!oca
		}
	return

	;添加单元格
	^=::SendInput,{Blind}^+=
	;新建工作表
	!i::send,!his
	;删除工作表
	!x::send,!el
	;重命名工作表
	!s::send,!ohr

	;默认快捷键
	;!WheelUp::Send,!{PgUp}
	;!WheelDown::Send,!{PgDn}

	!WheelUp::Send,{left 8}
	!WheelDown::Send,{right 8}

	+WheelUp::Send,{Left}
	+WheelDown::Send,{Right}

}

;word中 {{{2
;word2013: ahk_class OpusApp
#IfWinActive ahk_exe winword.exe
{
	CapsLock & o:: send,^+{F6}
	CapsLock & p:: send,^{F6}
}

;Everything中 {{{2
;audio:	搜索音频文件.
;zip:	搜索压缩文件.
;doc:	搜索文档文件.
;exe:	搜索可执行文件.
;pic:	搜索图片文件.
;video:	搜索视频文件.
;folder:仅匹配文件夹.
;8-tf-文本文件
;9-ct-内容搜索
;cf-重复文件
;mt-音频-作者专辑标题
#IfWinActive ahk_class EVERYTHING
	!a::EverythingChooseType("audio")
	!z::EverythingChooseType("zip")
	!w::EverythingChooseType("doc")
	!e::EverythingChooseType("exe")
	!t::EverythingChooseType("pic")
	!u::EverythingChooseType("video")
	!m::EverythingChooseType("folder")

	~LButton::
		GV_LongClickAction := "Send,{Click}{F4}"
		GV_MouseButton := 1
		GoSub,Sub_ButtonLongPress
	return

#IfWinActive

EverythingChooseType(ft){
	ControlGetText, searching, Edit1, A
	searching := ft . ":" . searching
	ControlSetText, Edit1, %searching%, A
	sleep,800
	send,{End}
}

;MPV播放器中 {{{2
#IfWinActive ahk_exe MPV.exe
{
	;速度控制
	XButton1 & WheelUp::SendInput,[
	XButton2 & WheelUp::SendInput,[
	XButton1 & WheelDown::SendInput,]
	XButton2 & WheelDown::SendInput,]

	;4速切换
	XButton2 & RButton::SendInput,\
	XButton1 & RButton::SendInput,\

	;上下
	XButton1::Send,.
	XButton2::Send,,

}

;Qsel启动器 {{{2
#If WinActive("Qsel  ahk_class WindowClass_0")
{
	XButton1::sendinput,{Tab}
	XButton2::sendinput,{Backspace}
	WheelDown::sendinput,{Tab}
	WheelUp::sendinput,{Backspace}
	space & WheelDown::sendinput,{Tab}
	space & WheelUp::sendinput,{Backspace}
	Space::space

	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,{Escape}"
		GoSub,Sub_MouseClick123
	return
}


;IrfanView {{{2
#If WinActive("ahk_class IrfanView")
{
	;IrfanView自身支持ctrl+滚轮，但alt更好按，也不用多想到底哪一个按键
	!WheelDown::send,{,}
	!WheelUp::send,{.}
	;.:: send,{+}
	;,:: send,{-}


	`;::send,{Esc}

	y:: send,{PgDn}
	;如果是动画，先按g暂停动画图片了后再按jk
	;j:: send,{PgDn}
	;k:: send,{PgUp}

	x:: send,i
	u:: send,{End}
	i:: send,{Home}
	;/:: send,^h
	;\:: send,+f

	c:: send,^c
	!r:: send,{F2}
	;1:: send,!ofn{Enter}
	;4:: send,!ofd{Enter}
	;5:: send,!of{Up}{Enter}
}

#If WinActive("ahk_class IrfanViewThumbnails")
{
	j:: send,{Down}
	k:: send,{Up}
	h:: send,{Left}
	l:: send,{Right}
	x::ControlClick SysTreeView321
}


;SumatraPDF {{{2
#if WinActive("ahk_class SUMATRA_PDF_FRAME")
{
	!e::
		WinGetActiveTitle, title
		Clipboard= % title
		filenamenew := RegExReplace(Clipboard, "(.*(\.chm|\.pdf|\.epub)+).*","$1")
		If RegExMatch(filenamenew, ".pdf$"){
		Run, "FoxitReaderPortable.exe" "%filenamenew%", ..\, Max,
		}
		else If RegExMatch(filenamenew, ".chm$"){
		Run, "hh.exe" "%filenamenew%", ..\, Max,
		}
	Return
}



;快速目录切换 {{{2
;收藏的目录，
;最近使用的目录
#IfWinActive, ahk_group GroupDiagOpenAndSave
	;从对话框中切换到tc，在tc中再选文件，然后alt+w再回来
	!w:: GoSub,Sub_SendCurDiagPath2Tc
	;直接用tc中的地址（已经选好）
	!g:: GoSub,Sub_SendTcCurPath2Diag
#IfWinActive

;在TC中打开对话框的路径
Sub_SendCurDiagPath2Tc:
	WinActivate, ahk_class TTOTAL_CMD
	;WinGetText, CurWinAllText
	;;MsgBox, The text is:`n%CurWinAllText%
	;Loop, parse, CurWinAllText, `n, `r
	;{
		;If RegExMatch(A_LoopField, "^地址: "){
			;curDiagPath := SubStr(A_LoopField,4)
			;break
		;}
	;}
	;WinActivate, ahk_class TTOTAL_CMD
	;ControlSetText, Edit1, cd %curDiagPath%, ahk_class TTOTAL_CMD
	;sleep 900
	;ControlSend, Edit1, {enter}, ahk_class TTOTAL_CMD
return


;将tc中路径发送到对话框
Sub_SendTcCurPath2Diag:
	;开关： 将剪贴板中内容作为文件名
	B_Clip2Name := false
	;开关： 是否改大对话框
	B_ChangeDiagSize := true

	ControlGetText, orgFileName,Edit1

	;先获取TC中当前路径
	clip:=Clipboard
	Clipboard =
	TcSendPos(CM_CopySrcPathToClip)
	;TcSendPos(CM_CopyFullNamesToClip)

	ClipWait, 1
	tcSrcPath := Clipboard
	Clipboard:=clip

	;处理例如根目录c:\就不用额外添加\
	if(SubStr(tcSrcPath, StrLen(tcSrcPath))!="`\"){
	tcSrcPath := tcSrcPath . "`\"
	}

	ControlFocus, Edit1,
	sleep 200
	Send,{Backspace}
	sleep 300
	setKeyDelay, 10,10
	ControlSetText, Edit1, %tcSrcPath% 
	sleep 900
	send,{enter}
	sleep 500

	if(B_Clip2Name){
		ControlSetText, Edit1, %clip%,A
	}
	else{
		ControlSetText, Edit1, %orgFileName% 
	}

	;ControlSetText, Edit1, %text%,A
	if(B_ChangeDiagSize){
		;WinGetPos, xTB, yTB,lengthTB,hightTB, ahk_class Shell_TrayWnd
		;改变对话框大小，省事就直接移动到100,100的位置，然后85%屏幕大小，否则就要详细结算任务栏在上下左右的位置
		WinMove, A,,80,80, A_ScreenWidth * 0.85, A_ScreenHeight * 0.85
	}
return


;构建对话框中菜单
Sub_Menu2Diag:
;左边历史
;右边历史
;hotdir
return


;Totalcmd历史记录 {{{2
;添加按照ini读取的启动菜单，接管`按键
;剪贴板增强
;固定文本条目增强
;#Persistent
TC_azHistory()
{
	if RegExMatch(COMMANDER_EXE, "i)totalcmd64\.exe$")
	{
		TCListBox := "LCLListBox"
		TCEdit := "Edit2"
		TInEdit := "TInEdit1"
		TCPanel1 := "Window1"
		TCPanel2 := "Window11"
		TCPathPanel := "TPathPanel2"
	}
	else
	{
		TCListBox := "TMyListBox"
		TCEdit := "Edit1"
		TInEdit := "TInEdit1"
		TCPanel1 := "TPanel1"
		TCPanel2 := "TMyPanel8"
		TCPathPanel := "TPathPanel1"
	}

	;<cm_ConfigSaveDirHistory>
	TcSendPos(582)
	sleep, 200
	history := ""
	TCINI := COMMANDER_PATH . "\wincmd.ini"
	;msgbox % TCINI
	tcLeftRight := fun_TcGet(1000)
	;msgbox % tcLeftRight
	if tcLeftRight = 1
	{
		IniRead, history, %TCINI%, LeftHistory
		if RegExMatch(history, "RedirectSection=(.+)", HistoryRedirect)
		{			
			StringReplace, HistoryRedirect1, HistoryRedirect1, `%COMMANDER_PATH`%, %COMMANDER_PATH%
			IniRead, history, %HistoryRedirect1%, LeftHistory			
		}
	}
	else if tcLeftRight = 2
	{
		IniRead, history, %TCINI%, RightHistory
		if RegExMatch(history, "RedirectSection=(.+)", HistoryRedirect)
		{
			StringReplace, HistoryRedirect1, HistoryRedirect1, `%COMMANDER_PATH`%, %COMMANDER_PATH%
			IniRead, history, %HistoryRedirect1%, RightHistory
		}
	}
	history_obj := []
	Global history_name_obj := []
	;Loop, Parse, history, `n
		;max := A_index
	Loop, Parse, history, `n
	{
		idx := RegExReplace(A_LoopField, "=.*$")
		value := RegExReplace(A_LoopField, "^\d\d?=")
		;避免&被识别成快捷键
		value := RegExReplace(value, "\t.*$")
		name := StrReplace(value, "&", ":＆:")

		if RegExMatch(Value, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}\|")
		{
			name  := RegExReplace(Value, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}\|")
			value := 2122
		}
		if RegExMatch(Value, "::\|")
		{
			name  := RegExReplace(Value, "::\|")
			value := 2121
		}
		if RegExMatch(Value, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}\|")
		{
			name  :=  RegExReplace(Value, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}\|")
			value := 2126
		}
		if RegExMatch(Value, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|") ;NothingIsBig的是XP系统，网上邻居是这个调整
		{
			name := RegExReplace(Value, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|")
			value := 2125
		}
		if RegExMatch(Value, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}\|")
		{
			name := RegExReplace(Value, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}\|")
			value := 2125
		}
		if RegExMatch(Value, "::\{26EE0668\-A00A\-44D7\-9371\-BEB064C98683\}\\0\|")
		{
			name := RegExReplace(Value, "::\{26EE0668\-A00A\-44D7\-9371\-BEB064C98683\}\\0\|")
			value := 2123
		}
		if RegExMatch(Value, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}\|")
		{
			name := RegExReplace(Value, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}\|")
			value := 2127
		}
		name := "&" . chr(idx+65) . "    " . name
		history_obj[idx] := name
		history_name_obj[name] := value
	}
	Menu, az, UseErrorLevel
	Menu, az, add
	Menu, az, deleteall
	MaxItem := 26
	Loop, %MaxItem%
	{
		idx := A_Index - 1
		name := history_obj[idx]
		Menu, az, Add, %name%, azHistorySelect
	}
	Menu, az, Add, [& ]    关闭,azHistoryDeleteAll
	ControlGetFocus, TLB, ahk_class TTOTAL_CMD
	ControlGetPos, xn, yn, wn, , %TLB%, ahk_class TTOTAL_CMD
	Menu, az, show, %xn%, %yn%
}

azHistoryDeleteAll:
	Menu, az, DeleteAll
return

azHistorySelect:
	azHistorySelect()
return

azHistorySelect()
{
	Global history_name_obj
	if ( history_name_obj[A_ThisMenuItem] = 2122 ) or RegExMatch(A_ThisMenuItem, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}")
		TcSendPos(cm_OpenDrives)
	else if ( history_name_obj[A_ThisMenuItem] = 2121 ) or RegExMatch(A_ThisMenuItem, "::(?!\{)")
		TcSendPos(cm_OpenDesktop)
	else if ( history_name_obj[A_ThisMenuItem] = 2126 ) or RegExMatch(A_ThisMenuItem, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}")
		TcSendPos(cm_OpenPrinters)
	else if ( history_name_obj[A_ThisMenuItem] = 2125 ) or RegExMatch(A_ThisMenuItem, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}") or RegExMatch(A_ThisMenuItem, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|") ;NothingIsBig的是XP系统，网上邻居是这个调整
		TcSendPos(cm_OpenNetwork)
	else if ( history_name_obj[A_ThisMenuItem] = 2127 ) or RegExMatch(A_ThisMenuItem, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}")
		TcSendPos(cm_OpenRecycled)
	else
	{
		ThisMenuItem := StrReplace(A_ThisMenuItem, ":＆:", "&")
		ThisMenuItem := RegExReplace(ThisMenuItem, "^&[A-Z]    ")
		TcSendPos(CM_EditPath)
		sleep,300
		ControlSetText, %TInEdit%, %ThisMenuItem%, ahk_class TTOTAL_CMD
		sleep,300
		ControlSend, %TInEdit%, {enter}, ahk_class TTOTAL_CMD
	}
}

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
return


CreatTrayMenu:
	Menu,Tray,NoStandard
	Menu,Tray,add,Edit编辑脚本,Menu_Edit
	Menu,Tray,add,Spy,Menu_Debug
	Menu,Tray,add,AHK帮助文档,Menu_Document
	Menu,Tray,add,Open自身监视,Menu_Open
	Menu,Tray,add
	Menu,Tray,add,开启或关闭随系统自动启动,Menu_AutoStart
	Menu,Tray,add,添加或去除绿软SoftDir变量,Menu_SoftDir
	Menu,Tray,add,拾遗补缺的绿化,Menu_GreenPath
	Menu,Tray,add
	Menu,Tray,add,重启脚本(&R),Menu_Reload
	Menu,Tray,add
	Menu,Tray,add,暂停热键(&S),Menu_Suspend
	Menu,Tray,add,暂停脚本(&A),Menu_Pause
	Menu,Tray,add,退出(&X),Menu_Exit
return


Menu_Open:
	listlines
return

Menu_Edit:
	;Edit
	run,%A_ScriptDir%\Tools\notepad\Notepad.exe %A_ScriptFullPath%
return

Menu_Debug:
	run,AU3_Spy.exe
return

Menu_Document:
	run,hh.exe %A_ScriptDir%\AutoHotkey.chm
	;run,https://wyagd001.github.io/zh-cn/docs/AutoHotkey.htm
return

Menu_Reload:
	Gosub,ForceSelfReload
return

Menu_AutoStart:
	if A_Is64bitOS 
		SetRegView 64
	RegRead, OutputVar, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Run, CapsEz
	if OutputVar
	{
		RegDelete, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Run, CapsEz
		eztip("已关闭CapsEz随系统自动启动",10)
	}
	else
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Run, CapsEz, "%A_AhkPath%"
		eztip("已设置CapsEz随系统自动启动",10)
	}
return

Menu_SoftDir:
	if A_Is64bitOS 
		SetRegView 64
	RegRead, OutputVar, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
	if OutputVar
	{
		RegDelete, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
		eztip("已去掉SoftDir环境变量",10)
	}
	else
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir, %SOFTDIR%
		eztip("已添加SoftDir环境变量",10)
	}
return

;Menu_RightMenu:
	;if A_Is64bitOS 
		;SetRegView 64
	;RegRead, OutputVar, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
	;if OutputVar
	;{
		;RegDelete, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
		;eztip("已去掉SoftDir环境变量",10)
	;}
	;else
	;{
		;RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir, %SOFTDIR%
		;eztip("已添加SoftDir环境变量",10)
	;}
;return


Menu_GreenPath:
	;1、newfile中的模板，Tools\NewFiles\NewFiles.ini
	p := A_scriptDir . "\Tools\NewFiles\Templates"
	IniWrite, %p%,  %A_scriptDir%\Tools\NewFiles\NewFiles.ini, FileList,TemplatePath

	;2、everything的Everything.ini
	p := "$exec(""" . A_scriptDir . "\" . COMMANDER_NAME . """ /A /T /O /S /L=""%1"")"
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,open_folder_command2
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,open_path_command2
	p := "$exec(""" . A_scriptDir . "\Tools\F4Menu\F4Menu.exe"" ""%1"")"
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,explore_command2
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,explore_path_command2

	;3、tcmatch.ini
	p := "Long description@" . A_scriptDir . "\Plugins\WDX\FileDiz\FileDiz.wdx"
	IniWrite, %p%,  %A_scriptDir%\tcmatch.ini, wdx, wdx_text_plugin3
return

Menu_Suspend:
	Menu,tray,ToggleCheck,暂停热键(&S)
	Suspend
return
Menu_Pause:
	Menu,tray,ToggleCheck,暂停脚本(&A)
	Pause
return
Menu_Exit:
	ExitApp
return

Quit:
ExitApp

; vim: textwidth=120 wrap tabstop=4 shiftwidth=4
; vim: foldmethod=marker fdl=0
