;CapsLock增强脚本，例子
;by Ez
;v190721 添加在tc里面中键点击打开目录
;v190904 更新暂停等热键，直接把AutoHotkey.exe改名为capsez.exe
;v190916 添加几种模式的开关，解决BUG10任务栏无法切换
;v190927 添加快捷键在TC中打开资源管理器中选中的文件，添加在tc中双击右键返回上一级。自动获取TC路径
;v191214 添加媒体播放相关快捷键和右键拖动窗口，解决一点小问题和小细节
;v200108 修复在资管或桌面没选文件的问题。再修复一些细节
;v200401 添加不同程序中对应不同的小菜单，增强对话框，tab组合键等

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
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_0    ;Chrome
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_1    ;Chrome
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_100  ;liebao
GroupAdd, group_browser,ahk_class QQBrowser_WidgetWin_1

GroupAdd, group_disableCtrlSpace, ahk_exe excel.exe
GroupAdd, group_disableCtrlSpace, ahk_exe pycharm.exe
GroupAdd, group_disableCtrlSpace, ahk_exe SQLiteStudio.exe

GroupAdd,GroupDiagOpenAndSave,Open ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Save As ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,另存为 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,保存 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,复制 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,新建 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,打开 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,图形另存为 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,文件打开 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,保存副本 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,上传 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,选择文件 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,打开文件 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,插入图片 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,导入 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,置入嵌入对象 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,浏览 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,选择要比较的图形 ahk_class #32770
SetTitleMatchMode RegEx ; 2019/10/16 增加正则组，方便调整
GroupAdd, GroupDiagOpenAndSave, i).*(选择|Select|保存|上传|另存|打开).*(文件|files?|images?|图像|图形|program|程序) ahk_class #32770 ; 
SetTitleMatchMode 2 ; 2019/10/16 正则定义结束，恢复普通匹配


;GroupAdd, group_disableCtrlSpace, ahk_exe gvim.exe 
;GroupAdd, group_disableCtrlSpace, ahk_class NotebookFrame（注：ahk_class后面是AHK检测出的mathematica的class名）

;************** group定义$ **************

;设定15分钟重启一次脚本，防止卡键 1000*60*15
GV_ReloadTimer := % 1000*60*15
Gosub,AutoReloadInit
Gosub,CreatTrayMenu

;是否启用光标下滚轮
GV_ToggleWheelOnCursor := 1

;tab系列组合键，适合左键右鼠，启用后直接按tab会感觉有一点延迟，默认开启，开关为ctrl+win+alt+花号
GV_ToggleTabKeys := 1

;启用空格系列快捷键，启用会影响打字，在tc中会不能按住连选文件，默认关闭，开关为ctrl+win+alt+空格
GV_ToggleSpaceKeys := 0

;在浏览器中启用空格系列快捷键
GV_GroupBrowserToggleSpaceKeys := 1

;单键模式，开关按键为caps+/
GV_ToggleKeyMode := 0

;64位的Win7下，在输入框中是148003967
GV_CursorInputBox_64Win7 := 148003967

;如果是自己从tc中启动的本脚本，将会自动带上COMMANDER_PATH
;但如果是别的地方，比如注册表的autorun环节先启动的本脚本，那么就有必要先设置这个变量
;1、先启动脚本，正常是随系统自启动，那么COMMANDER_PATH为空
;2、再启动tc，那么COMMANDER_PATH变量还是为空，可以读取运行中的exe路径
;3、最后再是根据脚本所在目录中是否存在TOTALCMD.EXE或者TOTALCMD64.EXE
COMMANDER_PATH := % GF_GetSysVar("COMMANDER_PATH")
WinGet,TcExeFullPath,ProcessPath,ahk_class TTOTAL_CMD
if !TcExeFullPath ;没tc在运行
{
	if A_Is64bitOS {
		if FileExist(A_WorkingDir . "\" . "TOTALCMD64.EXE") {
			TcExeFullPath := % A_WorkingDir . "\" . "TOTALCMD64.EXE"
			EnvSet,COMMANDER_PATH, A_WorkingDir
		} else if FileExist(A_WorkingDir . "\" . "TOTALCMD.EXE") {
			TcExeFullPath := % A_WorkingDir . "\" . "TOTALCMD.EXE"
			EnvSet,COMMANDER_PATH, A_WorkingDir
		} else{
			toolTip 当前目录下没Totalcmd程序
			sleep 2000
			tooltip
		}
	}
	else {
		if FileExist(A_WorkingDir . "\" . "TOTALCMD.EXE") {
			TcExeFullPath := A_WorkingDir . "\" . "TOTALCMD.EXE"
			EnvSet,COMMANDER_PATH, % A_WorkingDir
		} else {
			toolTip 当前目录下没Totalcmd程序
			sleep 2000
			tooltip
		}
	}
}
else{ ;有tc在运行
	if(COMMANDER_PATH == A_WorkingDir) {
		EnvSet,COMMANDER_PATH, % A_WorkingDir
	}
	else if !COMMANDER_PATH  ;但脚本先启动，比如随系统自启动，所以并没有COMMANDER_PATH变量
	{
		WinGet,TcExeName,ProcessName,ahk_class TTOTAL_CMD
		StringTrimRight, COMMANDER_PATH, TcExeFullPath, StrLen(TcExeName)+1
		EnvSet,COMMANDER_PATH, % COMMANDER_PATH
	}
}

;GV_ToolsPath := % GF_GetSysVar("ToolsPath")
GV_TempPath := % GF_GetSysVar("TEMP")


;默认双击快捷键间隔175微秒
GV_KeyTimer := 175
GV_MouseTimer := 400
GV_KeyClickAction1 :=
GV_KeyClickAction2 :=
GV_KeyClickAction3 :=

TC_Msg := 1075
CM_OpenDrives := 2122
CM_OpenDesktop := 2121
CM_OpenPrinters := 2126
CM_OpenNetwork := 2125
CM_OpenControls := 2123
CM_OpenRecycled := 2127
CM_CopySrcPathToClip := 2029
cm_CopyFullNamesToClip := 2018
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

;在任务栏上滚轮调整音量
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}
MButton::Send,{Volume_Mute}
#If
;Win10里面已经不需要光标下滚轮这个功能

#If GV_ToggleWheelOnCursor=1
	WheelUp::
		if A_OSVersion in WIN_2003,WIN_XP,WIN_7
		{
			FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,{WheelUp}
		}
	return

	^WheelUp::
		if A_OSVersion in WIN_2003,WIN_XP,WIN_7
		{
			FocuslessScroll(MinLinesPerNotch, MinLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,^{WheelUp}
		}
	return

	WheelDown::
		if A_OSVersion in WIN_2003,WIN_XP,WIN_7
		{
			FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,{WheelDown}
		}
	return

	^WheelDown::
		if A_OSVersion in WIN_2003,WIN_XP,WIN_7
		{
			FocuslessScroll(MinLinesPerNotch, MinLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,^{WheelDown}
		}
	return
#if

;************** 在光标下方滚轮结束 ************** {{{2

;************** 定时重启脚本部分，别动位置 ************** {{{1
AutoReloadInit:
	SetTimer, SelfReload, % GV_ReloadTimer
return
SelfReload:
	reload
return

;************** caps+鼠标滚轮调整窗口透明度^    ************** {{{1
;caps+鼠标滚轮调整窗口透明度（设置30-255的透明度，低于30基本上就看不见了，如需要可自行修改）
;~LShift & WheelUp::
CapsLock & WheelUp::
; 透明度调整，增加。
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
		;Transparent_New:=Transparent+10
	Transparent_New:=Transparent+20    ;◆透明度增加速度。
	If (Transparent_New > 254)
		Transparent_New =255
	WinSet,Transparent,%Transparent_New%,A

	tooltip 原透明度: %Transparent_New% `n新透明度: %Transparent%
	;查看当前透明度（操作之后的）。
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

CapsLock & WheelDown::
	;透明度调整，减少。
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
	Transparent_New:=Transparent-10  ;◆透明度减少速度。
	;msgbox,Transparent_New=%Transparent_New%
	If (Transparent_New < 30)    ;◆最小透明度限制。
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
Escape & LButton::
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
Escape & RButton::
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
LWin & LButton::GoSub,Sub_MaxRestore
;Win加右键给了popsel作为启动器，关键是滥用置顶并不好，所以给难受的中键
LWin & MButton::Winset, Alwaysontop, toggle, A
;对于置顶最好用快捷键来的更准确一点
#F1::Winset, Alwaysontop, toggle, A
;从默认Ctrl＋W是关闭标签上修改一点成关闭程序。
#w::WinClose A

;按住Win加滚轮来调整音量大小
LWin & WheelUp::Send,{Volume_Up}
LWin & WheelDown::Send,{Volume_Down}


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
		fun_KeyClickAction123(GV_KeyClickAction1)
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
}


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
			run, nircmd shexec open "%A_LoopField%"
		}
	}
return


;map tc :tabnew<cr>"+P
;map <F1> :tabnew<CR>
Sub_CopyAllVim:
	SendInput,^{Home}^+{End}^c
	sleep 500
	if not WinExist("ahk_class Vim")
		run %COMMANDER_PATH%\TOOLS\vim\gvim.exe, %COMMANDER_PATH%\TOOLS\vim
	WinActivate
	sleep 500
	SendInput,{F1}^v
return

Sub_CopyVim:
	SendInput,^c
	sleep 500
	if not WinExist("ahk_class Vim")
		run %COMMANDER_PATH%\TOOLS\vim\gvim.exe, %COMMANDER_PATH%\TOOLS\vim
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
~Escape::
	suspend permit
	SendInput,{Escape}
	switchime(0)
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

CapsLock & w::SendInput,{Up}
CapsLock & s::SendInput,{Down}
CapsLock & a::SendInput,{Left}
CapsLock & d::SendInput,{Right}

CapsLock & q::SendInput,{PgUp}
CapsLock & e::SendInput,{PgDn}

CapsLock & r:: SendInput,{Delete}
CapsLock & f:: SendInput,{Enter}

CapsLock & x:: SendInput,{Del}
CapsLock & z:: SendInput,{Backspace}

;左右手结合上下左右
CapsLock & j::SendInput,{Down}
CapsLock & k::SendInput,{Up}
CapsLock & h::SendInput,{Left}
CapsLock & l::SendInput,{Right}

;右键菜单
;CapsLock & y:: send,{AppsKey}
CapsLock & y:: Send {Click Right}

 
;媒体相关
CapsLock & 9::send,{Media_Prev}
CapsLock & 0::send,{Media_Next}

CapsLock & -::send,{Volume_Down}
CapsLock & =::send,{Volume_Up}

CapsLock & Del::send,{Volume_Mute}
CapsLock & backspace::send,{Media_Play_Pause}

CapsLock & PgUp:: send,{Media_Prev}
CapsLock & PgDn:: send,{Media_Next}

;移动鼠标光标，例如用在屏幕取色
CapsLock & up::MouseMove, 0, -1, 0, R
CapsLock & down::MouseMove, 0, 1, 0, R
CapsLock & left::MouseMove, -1, 0, 0, R
CapsLock & right::MouseMove, 1, 0, 0, R

;************** u,i单击双击^ **************
;CapsLock & i:: SendInput,{Blind}^{Home}
;CapsLock & u:: SendInput,{Blind}^{End}
;CapsLock & n:: SendInput,{Blind}{PgDn}
;CapsLock & m:: SendInput,{Blind}{PgUp}

CapsLock & u::
	GV_KeyClickAction1 := "SendInput,{End}"
	GV_KeyClickAction2 := "SendInput,^{End}"
	GoSub,Sub_KeyClick123
return

CapsLock & i::
	GV_KeyClickAction1 := "SendInput,{Home}"
	GV_KeyClickAction2 := "SendInput,^{Home}"
	GoSub,Sub_KeyClick123
return

CapsLock & n::
	GV_KeyClickAction1 := "SendInput,{PgDn}"
	GV_KeyClickAction2 := "SendInput,^{PgDn}"
	GoSub,Sub_KeyClick123
return

CapsLock & m::
	GV_KeyClickAction1 := "SendInput,{PgUp}"
	GV_KeyClickAction2 := "SendInput,^{PgUp}"
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
	Menu, MyMenu, Add  ; 添加分隔线.
	Menu, MyMenu, Add, 播放器打开, Sub_OpenUrlByPlayer
	Menu, MyMenu, Add  ; 添加分隔线.
	Menu, MyMenu, Add, 纯文本粘贴, PastePureText
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

Sub_OpenUrlByPlayer:
	send,^c
	sleep,100
	clip:=
	clip:=clipboard
	run,%COMMANDER_PATH%\Plugins\WLX\vlister\mpv.exe "%clip%"
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
^CapsLock::  ; control + capslock to toggle capslock.  alwaysoff/on so that the key does not blink
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
	GV_KeyClickAction2 := "SendInput,^{Home}"
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
LButton & WheelUp::ShiftAltTab
LButton & WheelDown::AltTab
;就没必要还用这个了
;LWin & WheelUp::ShiftAltTab
;LWin & WheelDown::AltTab

;鼠标中操作
#IfWinActive, ahk_class TaskSwitcherWnd
	;Win10自己已经支持alttab中按空格选择程序
	;if A_OSVersion in WIN_2003, WIN_XP, WIN_7
	;{
	!Space::send,{Alt Up}
	Space::send,{Alt Up}
	;}
	;在alttab的菜单中，点右键选中对应的程序
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;alt+shift+tab，切换到上一个窗口功能，放在一起共用 TaskSwitcherWnd算了
	;<+Tab::ShiftAltTab


	;左手
	!q::SendInput,{Blind}{Left}
	;右手
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
#IfWinActive

;Win10改成了MultitaskingViewFrame
#IfWinActive, ahk_class MultitaskingViewFrame
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;左手
	!q::SendInput,{Blind}{Left}
	;右手
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
#IfWinActive


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
	if(wd==1){
		SSFileName = % ScreenShotPath . "SSAW-" . fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
		run nircmd savescreenshotwin "%SSFileName%"
	}
	else{
		SSFileName = % ScreenShotPath . "SSWD-" .  fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
		run nircmd savescreenshot "%SSFileName%"
	}
}


;************** 窗口相关 ************** {{{2
;去掉标题栏
#f11::
	;WinSet, Style, ^0xC00000, A ;用来切换标题行，主要影响是无法拖动窗口位置。
	;WinSet, Style, ^0x40000, A ;用来切换sizing border，主要影响是无法改变窗口大小。
	GoSub, Sub_WindowNoCaption
return



;************** mouse鼠标相关 ************** {{{2
;鼠标侧边键ahk只认这两个，可以自行去掉注释
;XButton1:: Send,{PgUp}
;XButton2:: Send,{PgDn}

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
	Reload
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
	`;:: 
		;msgbox % GetCursorShape()
		;64位的Win7下，在输入框中是148003967
		If (GetCursorShape() = GV_CursorInputBox_64Win7)      ;I 型光标
			SendInput,`;
		else 
			Send {Click}
	return
	!`;:: Send {Click Right}
	;^`;:: Send,`;

	;按住左键点右键发送Ctrl+W关闭标签
	~LButton & RButton:: send ^w

#IfWinActive

;在浏览器中单独启用空格组合键
#If WinActive("ahk_group group_browser") and (GV_GroupBrowserToggleSpaceKeys = 1)
{

	Space & j:: SendInput,{Blind}{Down}
	Space & k:: SendInput,{Blind}{Up}
	Space & h:: SendInput,{Blind}{Left}
	Space & l:: SendInput,{Blind}{Right}

	Space & w:: SendInput,{Blind}^{Right}
	Space & b:: SendInput,{Blind}^{Left}

	Space & e:: SendInput,{Blind}{PgDn}
	Space & q:: SendInput,{Blind}{PgUp}

	Space & s:: SendInput,^v{Enter}
	Space & \:: SendInput,^a^v{Enter}

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
}

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
	run %COMMANDER_PATH%\Tools\notepad\Notepad.exe /f %COMMANDER_PATH%\Tools\notepad\Lite.ini, , , OutputVarPID
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
^#b::
	run %COMMANDER_PATH%\Tools\notepad\Notepad.exe /b /f %COMMANDER_PATH%\Tools\notepad\Lite.ini, , , OutputVarPID
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
#z::run %COMMANDER_PATH%\Tools\popsel\PopSel.exe /pc /n 
;#RButton::run %COMMANDER_PATH%\Tools\popsel\PopSel.exe /n /i
#h::run, cmd
;管理员权限cmd
^#h::run, *RunAs cmd
#c::run %COMMANDER_PATH%\Tools\notepad\Notepad.exe /c
#f::run %COMMANDER_PATH%\Everything.exe
#p::run powershell 
;#F5::run winword.exe
;#F6::run excel.exe
;#F7::run powerpnt.exe

;************** 各程序快捷键或功能 ************** {{{1
;调用任务栏相关程序快捷键 {{{2
`; & Tab::
	;Totalcmd
	send,#1
return

`; & Capslock::
	;Vim
	send,#2
return

`; & q::
	;QQ
	send,#3
return

`; & w::
	;微信
	send,#4
return

`; & e::
	send,#5
return

`; & r::
	send,#6
return

`; & t::
	send,#7
return


;Ctrl+Alt+点击，定位程序对应的目录
^!LButton::
	Send {Click}
	WinGet, ProcessPath, ProcessPath, A
	;Run Explorer /select`, %ProcessPath%
	run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /S /L="%ProcessPath%"
	WinActivate, ahk_class TTOTAL_CMD
return

;把资源管理器中选中的文件用tc打开  {{{2
;Win10的资源管理器
;资源管理器
#If WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
{
	!w::
		if(TcExeFullPath="")
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
		run, %TcExeFullPath% /T /O /S /A /L=%selected%
	return
}
;桌面
#If WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")
{
	!w::
		if(TcExeFullPath="")
			return
		selected := Explorer_Get("",true)
		if(selected = ""){
			selected := """" A_Desktop """"
			run, %TcExeFullPath% /T /O /A /S /L=%selected%
			sleep 200
			selected := """" A_DesktopCommon """"
			run, %TcExeFullPath% /T /O /A /S /R=%selected%
		}
		else{
			selected := """" selected """"
			run, %TcExeFullPath% /T /O /S /A /L=%selected%
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
	;!f::run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /P=L /L="D:\My Documents\Tencent Files\123456789\FileRecv\"
	!f::run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /S /L="D:\Document\Tencent Files\498459272\FileRecv\"
}

;QQ
#If WinActive("ahk_class TXGuiFoundation") and WinActive("ahk_exe qq.exe")
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
	;!f::run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /P=L /L="D:\My Documents\Tencent Files\123456789\FileRecv\"
	!f::run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /S /L="D:\Document\Tencent Files\498459272\FileRecv\"
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

	;快速到微信接收的文件目录，请自己修改对应目录
	!f::
		wx_path = % "D:\Document\WeChat Files\shtonyteng\FileStorage\File\" . fun_GetFormatTime( "yyyy-MM" )
		run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /S /L="%wx_path%"
	return

	;点右键选删除
	!d::
		send,{RButton}
		Sleep,200
		send,{Up 2}{Enter}
		Sleep,500
		send,{Enter}
	Return

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
			run,%COMMANDER_PATH%\Plugins\WLX\vlister\mpv.exe "%Out%"
		return
	}
#IfWinActive

;totalcmd中快捷键 {{{2
#IfWinActive ahk_class TTOTAL_CMD
	!e::Send {F4} /*e key conflict with edit*/
	Escape & f4::SendInput,!{F3}

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
	^F2::
		send,+{F6}
		Sleep,300
		send,{right}
		Sleep,300
		send,{Space}^v
		Sleep,300
		send,{Enter}
	return

	;中键点击，在新建标签中打开
	MButton::
		Send,{Click}
		Sleep 50
		TcSendPos(3003)
	return

	;双击右键，发送退格，返回上一级目录
	~RButton::
		KeyWait,RButton
		KeyWait,RButton, d T0.1
		If ! Errorlevel
		{
		  send {Backspace} 
		}
	Return

	`:: GoSub,Sub_azHistory

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
						ControlSetText, Edit1, %fileName% 
					}
					else{
						ControlSetText, Edit1, %orgFileName% 
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
					ControlSetText, Edit1, %selFiles% 
				}
			}
			reload
		}
		else{
			EzTip("系统当前没有打开或保存对话框",2)
		}
	return

#IfWinActive

TcSendPos(Number)
{
    PostMessage 1075, %Number%, 0, , AHK_CLASS TTOTAL_CMD
}

#IfWinActive,批量重命名 ahk_class TMultiRename
{
F1::Send,!p{tab}{enter}e
}

;excel中 {{{2
;excel 2010: ahk_class bosa_sdm_XL9  excel2013: ahk_class XLMAIN ahk_exe C:\Windows\System32\Notepad.exe 
#IfWinActive ahk_exe excel.exe 
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

	!WheelUp::Send,!{PgUp}
	!WheelDown::Send,!{PgDn}

}

;word中 {{{2
;word2013: ahk_class OpusApp
#IfWinActive ahk_exe winword.exe
{
	CapsLock & o:: send,^+{F6}
	CapsLock & p:: send,^{F6}
}

;快速目录切换 {{{2
;收藏的目录，
;最近使用的目录
;#IfWinActive 另存为 ahk_class #32770
;#If WinActive("另存为 ahk_class #32770") or WinActive("打开 ahk_class #32770")
;!f:: SendPath2Diag("另存为","Edit1","d:\My Documents\桌面")
;send,!n%2Path%{Enter}{Del}
;send,% text
;ControlSetText, Edit1, "d:\My Documents\桌面",A
;ControlSetText, Edit1, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
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
Sub_azHistory:

    Global TC_azHistorySelect
	;MaxItem := 36
	;MaxItem := 10
	MaxItem := 30

	WinGet,exeName,ProcessName,A
	WinGet,exeFullPath,ProcessPath,A
	;D:\tools\totalcmd\TOTALCMD.EXE 正常多数是这种情况

	if(SubStr(exeFullPath,2,2)!=":\")
	{
		WinGet,pid,PID,A
		;\Device\RAMDriv\totalcmd\TOTALCMD.EXE 在内存盘上是
		sql = Select * from Win32_Process WHERE ProcessId = %pid%
		for process in ComObjGet("winmgmts:").ExecQuery(sql)
		{
			exeFullPath := process.CommandLine
			;"Z:\totalcmd\TOTALCMD.EXE"
		}
		exeFullPath := SubStr(exeFullPath,2,StrLen(exeFullPath)-3)
	}

	StringLeft, tcPath, exeFullPath, StrLen(exeFullPath)-StrLen(exeName)-1

	aTCINI = %tcPath%\wincmd.ini
    If Strlen(aTCINI)
    {
		PostMessage, TC_Msg, CM_ConfigSaveDirHistory,0,, ahk_class TTOTAL_CMD
        Sleep, 800
        If Mod(TC_LeftRight(), 2)
            Direct := "Left"
        Else
            Direct := "Right"

		try{
			;[LeftHistory]RedirectSection=%COMMANDER_PATH%\USER\HISTORY.INI
			INIRead, aRSTCINI, %aTCINI%, %Direct%History, RedirectSection
			;%COMMANDER_PATH%\USER\HISTORY.INI
			if SubStr(aRSTCINI,2,14)=="COMMANDER_PATH"
			{
				HINI := % SubStr(aRSTCINI,17)
				aTCINI = %tcPath%%HINI%
			}
		}
		catch e{
		}

        INIRead, HistoryList, %aTCINI%, %Direct%History
        arrHistory := StrSplit(HistoryList, "`n", "`r")
        TC_azHistorySelect := {}
        SplitPath, A_LineFile, , ScriptDir
        ;IconFile := ScriptDir "\azHistory.icl"
        Menu, TC_azHistory, UseErrorLevel
        Menu, TC_azHistory, DeleteAll
		if(arrHistory.MaxIndex()<MaxItem)
			MaxItem := arrHistory.MaxIndex()
        Loop % MaxItem
        {
			Value := RegExReplace(arrHistory[A_Index],"^\d\d?=")
			IconNum := A_Index
			if(A_Index <= 10)
				Char := "[&" Chr(A_Index+47) "]"
			else if(A_Index <= 36)
				Char := "[&" Chr(A_Index+54) "]"
			Else
				Char = ""
				;Break
            TC_azHistorySelect[A_Index] := Value
            Value := RegExReplace(Value, "::(\{[0-9a-zA-Z\-]*\})?\|")
            Menu, TC_azHistory, Add, %Char%    %Value%, azHistory_Select
            ;Menu, TC_azHistory, Add, %Value%%A_Tab%%Char%, azHistory_Select
            ;Menu, TC_azHistory, Icon, %Value%%A_Tab%%Char%, %IconFile%, %IconNum%
        }
        ControlGetFocus,TLB,ahk_class TTOTAL_CMD
        ControlGetPos,xn,yn,wn,,%TLB%,ahk_class TTOTAL_CMD

        Menu, TC_azHistory, Add, 关闭%A_Tab%[& ],TC_azHistory_DeleteAll
		Menu, TC_azHistory, Show, %XN%, %YN%
    }
return

TC_azHistory_DeleteAll:
	Menu, TC_azHistory, DeleteAll
return

azHistory_Select:
	Global TC_azHistorySelect
    Value := TC_azHistorySelect[A_ThisMenuItemPos]
    If RegExMatch(Value, "^::")
    {
        If RegExMatch(Value, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}")
            Number := CM_OpenDrives
        Else If RegExMatch(Value, "::(?!\{)")
            Number := CM_OpenDesktop
        Else If RegExMatch(Value, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}")
		    Number := cm_OpenPrinters
	    Else If RegExMatch(Value, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}")
		    Number := cm_OpenNetwork
        Else If RegExMatch(Value, "::\{26EE0668\-A00A\-44D7\-9371\-BEB064C98683\}\\0")
		    Number := cm_OpenControls
	    Else If RegExMatch(Value, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}")
		    Number := cm_OpenRecycled
        PostMessage, %TC_Msg%, %Number%, 0, , AHK_CLASS TTOTAL_CMD
    }
    Else
    {
        ThisMenuItem := RegExReplace(Value,"\t.*$")
        WinGet, ExeName, ProcessName, ahk_class TTOTAL_CMD
		ControlSetText, Edit1, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
		ControlSend, Edit1, {enter}, ahk_class TTOTAL_CMD
    }
return

TC_LeftRight()
{
	Location := 0
	ControlGetPos,x1,y1,,,%TCPanel1%,AHK_CLASS TTOTAL_CMD
	If x1 > %y1%
		location += 2
	ControlGetFocus,TLB,ahk_class TTOTAL_CMD
	ControlGetPos,x2,y2,wn,,%TLB%,ahk_class TTOTAL_CMD
	If location
	{
		If x1 > %x2%
			location += 1
	}
	Else
	{
		If y1 > %y2%
			location += 1
	}
	Return location
}

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
return


CreatTrayMenu:
	Menu,Tray,NoStandard
	Menu,Tray,add,Spy(&D),Menu_Debug
	Menu,Tray,add,重启(&R),Menu_Reload
	Menu,Tray,add
	Menu,Tray,add,暂停热键(&S),Menu_Suspend
	Menu,Tray,add,暂停脚本(&A),Menu_Pause
	Menu,Tray,add,退出(&X),Menu_Exit
return

Menu_Debug:
	run,AU3_Spy.exe
return

Menu_Reload:
	Reload
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

; 自定义功能 {{{1
; 输入法切换 {{{2
; ~Escape::switchimei(0)
Shift:: switchime(1)

switchime(ime := "A")
{
    if (ime = 1)
    {
        DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("LoadKeyboardLayout", Str,"00000804", UInt, 1))
    }
    else If (ime = 0)
    {
        DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("LoadKeyboardLayout", Str,, UInt, 1))
    }
    Else If (ime = "A")
    {
        ;ime_status:=DllCall("GetKeyboardLayout","int",0,UInt)
        Send, #{Space}
    }
}
