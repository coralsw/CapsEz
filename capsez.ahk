;CapsLock��ǿ�ű������� {{{1
;by Ez
;v190721 �����tc�����м������Ŀ¼
;v190904 ������ͣ���ȼ���ֱ�Ӱ�AutoHotkey.exe����Ϊcapsez.exe
;v190916 ��Ӽ���ģʽ�Ŀ��أ����BUG10�������޷��л�
;v190927 ��ӿ�ݼ���TC�д���Դ��������ѡ�е��ļ��������tc��˫���Ҽ�������һ�����Զ���ȡTC·��
;v191214 ���ý�岥����ؿ�ݼ����Ҽ��϶����ڣ����һ��С�����Сϸ��
;v200108 �޸����ʹܻ�����ûѡ�ļ������⡣���޸�һЩϸ��
;v200401 ��Ӳ�ͬ�����ж�Ӧ��ͬ��С�˵�����ǿ�Ի���tab��ϼ���
;v210405 ��Ӳ�߼���ǿ�ȵ�ϸ�ڡ�
;v210601 ������Ӷ�������Ͳ������Ͳ�߼�����ʹ����ǿ��
;v210801 ��Ӷ�IrfanView�ȳ���Ŀ�ݼ���ǿ���Ľ�����������popsel�ķ�ʽ������Сϸ�ڵ�
;v211125 ��ӿ�����ر���ϵͳ�Զ��������Լ�������Сϸ�ڵ��Ż�
;v220401 Сϸ���Ż�
;v220626 ���tc�����ּ�������˫��Ч���������곤��ģʽ�����everything��ɸѡ���ȣ����alt�ո��ͼ�Ŀ��أ�tc��alt+EΪF4���м���Ϊ�ڶԲ�����¿���ǩ��
;v220629 �޸�������ʱ�򿨶٣��Լ���������
;v220710 �Ż�tc�����ּ�˫���ͳ����������Ż�΢�Ž����ļ���

;����ԡ����ӡ�λ�ý��������޸�

;����ԱȨ�޴��룬�����ļ���ͷ {{{1
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

;�ļ�ͷ {{{1
;Directives
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent                   ;�ýű��־�����(�رջ�ExitApp)
#MaxMem 4	;max memory per var use
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 10000 ;Avoid warning when mouse wheel turned very fast
SetCapsLockState AlwaysOff
;SendMode InputThenPlay
;KeyHistory
SetBatchLines -1                	 	;�ýű������ߵ�ִ�У����仰˵��Ҳ�����ýű�ȫ�����У�
SetKeyDelay -1							;����ÿ��Send��ControlSend���ͼ������Զ�����ʱ,ʹ��-1��ʾ����ʱ
Process Priority,,High           	    ;�߳�,��,�߼���

SendMode Input

DetectHiddenWindows, on

SetWinDelay,0
SetControlDelay,0


;************** group����^ ************** {{{1
;GroupAdd, group_browser,ahk_class St.HDBaseWindow
GroupAdd, group_browser,ahk_class IEFrame               ;IE
GroupAdd, group_browser,ahk_class ApplicationFrameWindow ;Edge
GroupAdd, group_browser,ahk_class MozillaWindowClass    ;Firefox
GroupAdd, group_browser,ahk_class QQBrowser_WidgetWin_1
GroupAdd, group_browser,ahk_exe chrome.exe               ;Chrome
GroupAdd, group_browser,ahk_exe msedge.exe
GroupAdd, group_browser,ahk_exe 115chrome.exe
;115�Ĳ�����
GroupAdd, group_browser,YywPlayerOperateFrame ahk_class XMLWnd

GroupAdd, group_disableCtrlSpace, ahk_exe excel.exe
GroupAdd, group_disableCtrlSpace, ahk_exe pycharm.exe
GroupAdd, group_disableCtrlSpace, ahk_exe SQLiteStudio.exe

GroupAdd,GroupDiagOpenAndSave,�½� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,ѡ�� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,��� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,�� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,�ϴ� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,��� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Open ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Save ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Select ahk_class #32770


;GroupAdd, group_disableCtrlSpace, ahk_exe gvim.exe 
;GroupAdd, group_disableCtrlSpace, ahk_class NotebookFrame��ע��ahk_class������AHK������mathematica��class����

;************** group����$ **************

;�趨5��������һ�νű�����ֹ���� 1000*60*15
GV_ReloadTimer := % 1000*60*5
GV_ToggleReload := 1
Gosub,AutoReloadInit
Gosub,CreatTrayMenu


;Esc�������ã�Ĭ��WinClose����Ϊalt+f4�رճ��򣬿�ѡCapsLock����Ϊ�л���Сд
;GV_EscKeyAs := "WinClose"
;GV_EscKeyAs := "Escape"
;GV_EscKeyAs := "CapsLock"
GV_EscKeyAs := "Backspace"

;������ѡ�񣬿�ѡΪpopsel��qsel
;GV_PopSel_QSel := "popsel"
GV_PopSel_QSel := "qsel"

;�Ƿ����ù���¹���
GV_ToggleWheelOnCursor := 0

;tabϵ����ϼ����ʺ�����������ú�ֱ�Ӱ�tab��о���һ���ӳ٣�Ĭ�Ͽ���������Ϊctrl+win+alt+����
GV_ToggleTabKeys := 1

;���ÿո�ϵ�п�ݼ������û�Ӱ����֣���tc�л᲻�ܰ�ס��ѡ�ļ���Ĭ�Ϲرգ�����Ϊctrl+win+alt+�ո�
GV_ToggleSpaceKeys := 0

;������������ÿո�ϵ�п�ݼ�
GV_GroupBrowserToggleSpaceKeys := 1

;����������л�����ģʽ
;��Ƶ�й���Ϊ���ҿ������Ҫ����������Ƶ��վ������Ĭ��Ϊ���alt�ӿո����˫����߼�1
GV_GroupBrowserToggleWheelModeLeftRight := 0
;ҳ���й���Ϊ��ҳ�����к�һҳ���л�
GV_GroupBrowserToggleWheelModeUpDown := 0
;����������л���߼���Ϊ�м�ģʽ
GV_GroupBrowserToggleMButtonMode := 0

;��Totalcmd��ʹ�����ּ����������ٴ򿪣�˫����ת
GV_TotalcmdToggleJumpByNumber := 1

;����ģʽ�����ذ���Ϊcaps+/
GV_ToggleKeyMode := 0

;��ͼ�ļ���ʱ����
global SSFileName
;��ͼ��ʱ��ͬʱ��������
global GV_ScreenShot2Clip := 1

;64λ��Win7�£������������148003967
GV_CursorInputBox_64Win710 := 148003967
;�������ָ��
GV_CursorNormal_64Win710 := 124973738
;���������ָ��
GV_CursorClick_64Win710 := 1197314685

GV_CursorInputBox := GV_CursorInputBox_64Win710
GV_CursorClick := GV_CursorClick_64Win710
GV_CursorNormal := GV_CursorNormal_64Win710

;���ڱ༭״̬
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

;�����Ŀ¼SoftDir��Ĭ����tcĿ¼����һ�㣬�����ǽű��ڵĻ������������д�ahk�������ĳ��򶼻�̳����������
;���������Թ̶�������Կ������Ҽ��˵���ѡ���ϵͳ�Ļ��������̶�����
;��EnvUpdate �ᵼ�¿���
SOFTDIR := % GF_GetSysVar("SoftDir")
if !SOFTDIR
{
	SOFTDIR := RegExReplace(A_ScriptDir,"\\[^\\]+\\?$")
	EnvSet,SoftDir, % SOFTDIR
}


;Ĭ��˫����ݼ����175΢��
GV_KeyTimer := 175
GV_MouseTimer := 400
GV_KeyClickAction1 :=
GV_KeyClickAction2 :=
GV_KeyClickAction3 :=
;�����İ�ť��0ΪĬ�ϲ��ܣ�1���2�Ҽ�3�м�
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

;Tim������λ��
Tim_Start_X := 100
Tim_Start_Y := 100
Tim_Bar_Height := 60 

;QQ������λ��
QQ_Start_X := 100
QQ_Start_Y := 30
QQ_Bar_Height := 45 

WX_Start_X := 180
WX_Start_Y := 100
WX_Bar_Height := 62 

TG_Start_X := 100
TG_Start_Y := 110
TG_Bar_Height := 62 


;��ramdisk��ʱ����ʱ�����Զ��Ľ���TempĿ¼
;FileDelete,% GV_TempPath
;FileCreateDir, % GV_TempPath
;run nircmd execmd mkdir "%GV_TempPath%"
;FileCreateDir, % GV_TempPath . "\ChromeCache"


;************** �ڹ���·����� ************** {{{1
;Autoexecute code
MinLinesPerNotch := 1
MaxLinesPerNotch := 5
AccelerationThreshold := 100
AccelerationType := "L" ;Change to "P" for parabolic acceleration
StutterThreshold := 10

;************** �ڹ���·����ֿ�ʼ^ ************** {{{2
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

;���������Ϲ��ֵ������� {{{2
#If MouseIsOver("ahk_class Shell_TrayWnd") or MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
	WheelUp::GoSub,Sub_volUp
	WheelDown::GoSub,Sub_volDown

	;�м�����	
	MButton::GoSub,Sub_volMute

	;����svv
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
		Progress,0,0, ,������С
return

SliderOff:
	Progress,Off
Return

DisplaySlider:
	SoundGet,Volume
	Volume:=Round(Volume)
	Progress,%Volume%,%Volume%, ,������С
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



;Win10�����Ѿ�����Ҫ����¹����������
#If (GV_ToggleWheelOnCursor=1) and (A_OSVersion in WIN_2003,WIN_XP,WIN_7)
WheelUp::FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
WheelDown::FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
^WheelUp::Send,^{WheelUp}
^WheelDown::Send,^{WheelDown}
!WheelUp::Send,!{WheelUp}
!WheelDown::Send,!{WheelDown}
#if

;************** �ڹ���·����ֽ��� ************** {{{2

;************** ��ʱ�����ű����֣���λ�� ************** {{{1
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

;************** caps+�����ֵ�������͸����^    ************** {{{1
;caps+�����ֵ�������͸���ȣ�����30-255��͸���ȣ�����30�����ϾͿ������ˣ�����Ҫ�������޸ģ�
;~LShift & WheelUp::
CapsLock & WheelUp::
	;͸���ȵ��������ӡ�
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
	Transparent_New:=Transparent+20
	If (Transparent_New > 254)
		Transparent_New =255
	WinSet,Transparent,%Transparent_New%,A

	tooltip ԭ͸����: %Transparent_New% `n��͸����: %Transparent%
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

CapsLock & WheelDown::
	;͸���ȵ��������١�
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
	Transparent_New:=Transparent-20
	If (Transparent_New < 30)
		Transparent_New = 30
	WinSet,Transparent,%Transparent_New%,A
	tooltip ԭ͸����: %Transparent_New% `n��͸����: %Transparent%
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

;����CapsLock �Ӳ�߼� ֱ�ӻָ�͸���ȵ�255��û�в�߼��ľ����ˣ��Ͼ����ֹ�һ��Ҳ��ú�
;CapsLock & XButton1::
	;WinGet, Transparent, Transparent,A
	;WinSet,Transparent,255,A
	;tooltip �ָ�͸����
	;SetTimer, RemoveToolTip_transparent_Lwin, 1500
;return

RemoveToolTip_transparent_Lwin:
	tooltip
	SetTimer, RemoveToolTip_transparent_Lwin, Off
return

;************caps+�����ֵ�������͸����$***********


;************** ��סCaps�϶����^    ************** {{{1
;��סcaps������϶�����
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

;��סcaps���Ҽ��Ŵ����С����
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
;************** ��סCaps�϶�����$    **************

;��סWin������Ŵ����С����
Capslock & MButton::GoSub,Sub_MaxRestore
;LWin & LButton::GoSub,Sub_MaxRestore
;Win���Ҽ�����popsel��Ϊ���������ؼ��������ö������ã����Ը����ܵ��м�
LWin & MButton::Winset, Alwaysontop, toggle, A
;�����ö�����ÿ�ݼ����ĸ�׼ȷһ��
#F1::Winset, Alwaysontop, toggle, A
;��Ĭ��Ctrl��W�ǹرձ�ǩ���޸�һ��ɹرճ���
#w::WinClose A

;��סWin�ӹ���������������С
LWin & WheelUp::GoSub,Sub_volUp
LWin & WheelDown::GoSub,Sub_volDown


;Escape & LButton::WinClose A

;************** �Զ��巽��^ ************** {{{1
MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}

;fp,ȫ·���ļ��� 1·��,2ȫ�ļ���,3���ļ���,4��չ��,5���64����
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
		;���ļ���û�к�׺��
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

;�ʺϵ���ֱ�ӵ���
CoordWinClick(x,y){
	CoordMode, Mouse, Window
	click %x%, %y%
}

;�ʺϵ���ֱ�ӵ���
CoordWinDbClick(x,y){
	CoordMode, Mouse, Window
	click %x%, %y%, 2
}

;�ڵ��õĹ���ǰ��ͳһ����һ�� CoordMode, Mouse, Window �Ϻã���ͬ
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

GetCursorShape(){   ;��ȡ��������� by nnrxin  
    VarSetCapacity( PCURSORINFO, 20, 0) ;Ϊ�����Ϣ �ṹ ���ó�20�ֽڿռ�
    NumPut(20, PCURSORINFO, 0, "UInt")  ;*������ �ṹ �Ĵ�СcbSize = 20�ֽ�
    DllCall("GetCursorInfo", "Ptr", &PCURSORINFO) ;��ȡ �ṹ-�����Ϣ
    if ( NumGet( PCURSORINFO, 4, "UInt")="0" ) ;���������ʱ��ֱ�����������Ϊ0
        return, 0
    VarSetCapacity( ICONINFO, 20, 0) ;���� �ṹ-ͼ����Ϣ
    DllCall("GetIconInfo", "Ptr", NumGet(PCURSORINFO, 8), "Ptr", &ICONINFO)  ;��ȡ �ṹ-ͼ����Ϣ
    VarSetCapacity( lpvMaskBits, 128, 0) ;���� ����-��ͼ��Ϣ��128�ֽڣ�
    DllCall("GetBitmapBits", "Ptr", NumGet( ICONINFO, 12), "UInt", 128, "UInt", &lpvMaskBits)  ;��ȡ ����-��ͼ��Ϣ
    loop, 128{ ;��ͼ��
        MaskCode += NumGet( lpvMaskBits, A_Index, "UChar")  ;�ۼ�ƴ��
    }
    if (NumGet( ICONINFO, 16, "UInt")<>"0"){ ;��ɫͼ��Ϊ��ʱ����ɫͼ��ʱ��
        VarSetCapacity( lpvColorBits, 4096, 0)  ;���� ����-ɫͼ��Ϣ��4096�ֽڣ�
        DllCall("GetBitmapBits", "Ptr", NumGet( ICONINFO, 16), "UInt", 4096, "UInt", &lpvColorBits)  ;��ȡ ����-ɫͼ��Ϣ
        loop, 256{ ;ɫͼ��
            ColorCode += NumGet( lpvColorBits, A_Index*16-3, "UChar")  ;�ۼ�ƴ��
        }  
    } else
        ColorCode := "0"
    DllCall("DeleteObject", "Ptr", NumGet( ICONINFO, 12))  ; *������ͼ
    DllCall("DeleteObject", "Ptr", NumGet( ICONINFO, 16))  ; *����ɫͼ
    VarSetCapacity( PCURSORINFO, 0) ;��� �ṹ-�����Ϣ
    VarSetCapacity( ICONINFO, 0) ;��� �ṹ-ͼ����Ϣ
    VarSetCapacity( lpvMaskBits, 0)  ;��� ����-��ͼ
    VarSetCapacity( lpvColorBits, 0)  ;��� ����-ɫͼ
    return, % MaskCode//2 . ColorCode  ;���������
}

Sub_MouseClick123:
	if winc_presses > 0 ; SetTimer �Ѿ�����, �������Ǽ�¼����.
	{
		winc_presses += 1
		return
	}
	; ����, �����¿�ʼϵ���е��״ΰ���. �Ѵ�����Ϊ 1 ������
	; ��ʱ����
	winc_presses = 1
	SetTimer, KeyWinC, % GV_MouseTimer ; �� 400 �����ڵȴ�����ļ���.
return

Sub_KeyClick123:
	if winc_presses > 0 ; SetTimer �Ѿ�����, �������Ǽ�¼����.
	{
		winc_presses += 1
		return
	}
	; ����, �����¿�ʼϵ���е��״ΰ���. �Ѵ�����Ϊ 1 ������
	; ��ʱ����
	winc_presses = 1
	SetTimer, KeyWinC, % GV_KeyTimer ; �� 400 �����ڵȴ�����ļ���.
return

KeyWinC:
	SetTimer, KeyWinC, off
	if winc_presses = 1 ; �˼�������һ��.
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
				;����Ϊ0
				GV_MouseButton = 0
			}
			else {
				fun_KeyClickAction123(GV_KeyClickAction1)	
			}
		}
	}
	else if winc_presses = 2 ; �˼�����������.
	{
		fun_KeyClickAction123(GV_KeyClickAction2)
	}
	else if winc_presses > 2
	{
		fun_KeyClickAction123(GV_KeyClickAction3)
		;MsgBox, Three or more clicks detected.
	}
	; ���۴�����������ĸ�����, ���� count ��������
	; Ϊ��һ��ϵ�еİ�����׼��:
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
	ToolTip �Ѿ���ӵ� %GV_TempPath%\ClipAppend.txt
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
	if(xTB == 0){ ;��ߺ��ϡ���������
		if(yTB == 0){ ;���������Ϻ���
			if(lengthTB == A_ScreenWidth){ ;����
				xW := 0
				yW := hightTB
				lW := A_ScreenWidth
				hW := A_ScreenHeight - hightTB
			}
			else{ ;����
				xW := lengthTB
				yW := 0
				lW := A_ScreenWidth - lengthTB
				hW := A_ScreenHeight
			}
		}
		else{ ;����
			xW := 0	
			yW := 0
			lW := A_ScreenWidth
			hW := A_ScreenHeight - hightTB
		}
	}
	else{ ;����
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

;�򿪼������ж������
OpenClipURLS:
	Loop, parse, clipboard, `n, `r  ; �� `r ֮ǰָ�� `n, ��������ͬʱ֧�ֶ� Windows �� Unix �ļ��Ľ���.
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

;************** �Զ��巽��$ **************


;************** Youdao_���緭��^ ********* {{{1
;����+����  ����-��Ӣ����	by����	From:Cando_�е�����+�����庯��+Splash����+�жϵ���

<#y::
	ԭֵ:=Clipboard
	clipboard =
	Send ^c
	gosub sound
Return
sound:
	ClipWait,0.5
	If(ErrorLevel)
		{
		InputBox,varTranslation,������,���뷭��ɶ������˵
		if !ErrorLevel
			{
			Youdao����:=YouDaoApi(varTranslation)
			Youdao_��������:= json(Youdao����, "web.value")
			SplashYoudaoMsg("Youdao_���緭��", Youdao_��������)
			spovice:=ComObjCreate("sapi.spvoice")
			spovice.Speak(Youdao_��������)
			Sleep, 3000
			SplashTextOff
			}
		}
	else
		{
			varTranslation:=clipboard
			Youdao����:=YouDaoApi(varTranslation)
			Youdao_��������:= json(Youdao����, "web.value")
			SplashYoudaoMsg("Youdao_���緭��", Youdao_��������)
			spovice:=ComObjCreate("sapi.spvoice")
			spovice.Speak(Youdao_��������)
			Sleep, 3000
			SplashTextOff
		}
	;Clipboard:=ԭֵ
	Clipboard:=Youdao_��������
return

SplashYoudaoMsg(title, content){
	;SoundBeep 750, 500
	MouseGetPos, MouseX, MouseY ;������λ��x,y
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
;************** Youdao_���緭��$ *********

;************** ��Ͽ�ݼ����� ************** {{{1
;************** Escape��� ************** {{{2
; +HJKL ��ʾ�������Ϸ���  SendInput@chm
Escape & j:: SendInput,{Blind}{Down}
Escape & k:: SendInput,{Blind}{Up}
Escape & h:: SendInput,{Blind}{Left}
Escape & l:: SendInput,{Blind}{Right}

Escape & w:: SendInput,{Blind}^{Right}
Escape & b:: SendInput,{Blind}^{Left}

Escape & e:: SendInput,{Blind}{PgDn}
Escape & q:: SendInput,{Blind}{PgUp}

;************** u,i����˫��^ ************** 
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
;************** u,i����˫��$ **************

;***************** ���������^ ************** {{{2
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
;***************** ���������$ **************
;�رպ�ˢ��
Escape & g:: SendInput,{Blind}^w
Escape & r:: SendInput,{Blind}^r
;�л�tab
Escape & o:: send,{Blind}^+{Tab}
Escape & p:: send,{Blind}^{Tab}
;�Ҽ���DEL
;Escape & y:: send,{AppsKey}
Escape & y:: Send {Click Right}
Escape & d:: SendInput,{Delete}
;Alttab��Win8����ʱ������
Escape & .:: AltTab
Escape & ,:: ShiftAltTab

Escape & `;:: WinClose A

;enter �س��������
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

;���һ�лָ������ܣ���Ҫ

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


;************** CapsLock��� ************** {{{2
;win+caps+����
;Capslock & e::
;state := GetKeyState("LWin", "T")  ; �� CapsLock ��ʱΪ��, ����Ϊ��.
;if state
	;msgbox handle��
;else
	;send #e
;return
;�����ֽ����������
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

;�Ҽ��˵�
;CapsLock & y:: send,{AppsKey}
CapsLock & y:: Send {Click Right}
 
;ý�����
CapsLock & 9::send,{Media_Prev}
CapsLock & 0::send,{Media_Next}

CapsLock & -::GoSub,Sub_volDown
CapsLock & =::GoSub,Sub_volUp
CapsLock & Del::GoSub,Sub_volMute

CapsLock & backspace::send,{Media_Play_Pause}

CapsLock & PgUp:: send,{Media_Prev}
CapsLock & PgDn:: send,{Media_Next}

;�ƶ�����꣬����������Ļȡɫ
CapsLock & up::MouseMove, 0, -1, 0, R
CapsLock & down::MouseMove, 0, 1, 0, R
CapsLock & left::MouseMove, -1, 0, 0, R
CapsLock & right::MouseMove, 1, 0, 0, R
CapsLock & '::Send,{Click}

;************** u,i����˫��^ **************
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

;************** u,i����˫��$ **************

;***************** ���������^ **************
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
	Menu, MyMenu, Add, ����, Sub_SearchSelectTxt
	Menu, MyMenu, Add, Everything����, Sub_EverythingSelectTxt
	Menu, MyMenu, Add  ; ��ӷָ���.
	Menu, MyMenu, Add, ��������, Sub_OpenUrlByPlayer
	Menu, MyMenu, Add  ; ��ӷָ���.
	Menu, MyMenu, Add, ���ı�ճ��, PastePureText
	Menu, MyMenu, Add, Zת����ճ��, JoinAndPaste
	Menu, MyMenu, Add  ; ��ӷָ���.
	Menu, MyMenu, Add, ���Quote, PasteQuote
	Menu, MyMenu, Add, ���Code, PasteCode
	Menu, MyMenu, Add, ��Ӵ�ͷMagnet, PasteMagnet

	Menu, MyMenu, Add  ; ��ӷָ���.

	GoSub,EzOtherMenu_MyApps
	Menu, MyMenu, Add  ; ��ӷָ���.

	Menu, MyMenu, Add, ȡ��[& ],EzOtherMenu_DeleteAll
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
			;ȥ��β������=notepad_trim
			;���ո��tabɾ��=notepad_cleanWhitespace
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
	;����1
	;��tc���ļ������ļ���֮�������˫���Ų��ҰѶ��кϲ���һ�в�����������
	;clip := RegExReplace(clip, "(.+)(`r`n)?", """$1""`|")
	;����2
	;��everything������������д���ȥ��˫���Ų��ҰѶ��кϲ���һ�в���tab�ָ�
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

;***************** ���������$ **************
CapsLock & c::
	GoSub,Sub_ClipAppend
return

CapsLock & g:: SendInput,{Blind}^w

CapsLock & o:: SendInput,{Blind}^+{Tab}
CapsLock & p:: SendInput,{Blind}^{Tab}

;AltTabMenu �ô�����
CapsLock & .:: AltTab
CapsLock & ,:: ShiftAltTab

;�رմ���
CapsLock & `;:: WinClose A

;enter �س��������
CapsLock & Enter:: GoSub,Sub_MaxRestore
CapsLock & Space:: WinMinimize A

;��caps�滻Ϊesc
CapsLock::
	suspend permit
	SendInput,{Escape}
return

;+CapsLock:: CapsLock "֮ǰ��д��
;^PrintScreen::
; control + capslock to toggle capslock.  alwaysoff/on so that the key does not blink
^CapsLock::
!CapsLock::
	GetKeyState t, CapsLock, T
	IfEqual t,D, SetCapslockState AlwaysOff
	Else SetCapslockState AlwaysOn
Return


;************** �ֺ�;��� ************** {{{2
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

;ճ��Ȼ��س���������������������λ�ã�һ��˫�֣�һ������
`; & g::
	GV_KeyClickAction1 := "SendInput,^v{Enter}"
	GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^v{Enter}"
	GoSub,Sub_KeyClick123
return


;����ѡ�е��ı�
`; & s::GoSub,Sub_SearchSelectTxt


;��ո���ճ��
`; & d::SendInput,{Home 2}+{End}{Backspace}
`; & a::SendInput,^{Home}^+{End}{Delete}



;ճ����ת��,�����������tc�ж�����
`; & u:: send,^t!d^v{Enter}
;`; & u:: send,^t!dwww.^v{Enter}


`; & 1:: AscSend(fun_GetFormatTime("yyyy-MM-dd"))
`; & 2:: AscSend(fun_GetFormatTime(" HHmm"))
`; & 3:: AscSend("#" . fun_GetFormatTime("MMdd"))

;�ָ��ֺ�������
;$`;:: SendInput,`;

`;:: send,`;
^`;:: send,^`;
+`;:: send,+`;
^+`;:: send,^+`;
!`;:: send,!`;
::: send,:

;************** Space�ո����� ************** {{{2
#If GV_ToggleSpaceKeys==1 
;vim���г�ͻ�ų�������tc�в��������ո�
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

;************** `���ż���� ************** {{{2
;���λ��˳�֣���Ҫ���ڰ�ס������ôѡ��֮����ȥ��ctrl���ߣ��ֺŵȾ��Ե�Զ��
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

;�㲻��Ĭ�ϵġ�ȷ��������OK��ť�����û�о͵��һ��Button1�����������ּ򵥵ĶԻ��򣬱���TC�ı�ע
` & Enter::
	try {
		SetTitleMatchMode RegEx
		SetTitleMatchMode Slow
		ControlClick, i).*ȷ��|OK.*, A
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


;************** Alttab��� ************** {{{2
;��ס����ٽ��й��֣���AltaTab�˵��У����Ե���Ҽ����߰��ո����ȷ��ѡ��
;�����ڰ��ļ��ϵ���ĳ����д򿪣�����������qq΢�Ŵ��ļ���Ҳ���Խ�������е�ͼƬֱ���ϵ��ļ��������б���
;LButton & WheelUp::ShiftAltTab
;LButton & WheelDown::AltTab
;��û��Ҫ���������
;LWin & WheelUp::ShiftAltTab
;LWin & WheelDown::AltTab

;����в���
#If WinActive("ahk_class TaskSwitcherWnd")
{
	;Win10�Լ��Ѿ�֧��alttab�а��ո�ѡ�����
	if A_OSVersion in WIN_2003, WIN_XP, WIN_7
	{
		!Space::send,{Alt Up}
		Space::send,{Alt Up}
	}
	;��alttab�Ĳ˵��У����Ҽ�ѡ�ж�Ӧ�ĳ���
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;alt+shift+tab���л�����һ�����ڹ��ܣ�����һ���� TaskSwitcherWnd����
	;<+Tab::ShiftAltTab


	;����
	!q::SendInput,{Blind}{Left}
	!s::SendInput,{Blind}{Down}
	!w::SendInput,{Blind}{Up}
	!a::SendInput,{Blind}{Left}
	!d::SendInput,{Blind}{Right}

	;����
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
}

;Win10�ĳ���MultitaskingViewFrame,Win11�ĳ���XamlExplorerHostIslandWindow
#If WinActive("ahk_class MultitaskingViewFrame") or WinActive("ahk_class XamlExplorerHostIslandWindow") 
{
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;����
	!q::SendInput,{Blind}{Left}
	!s::SendInput,{Blind}{Down}
	!w::SendInput,{Blind}{Up}
	!a::SendInput,{Blind}{Left}
	!d::SendInput,{Blind}{Right}

	;����
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
}


;************** tab��� ************** {{{2
#If GV_ToggleTabKeys=1
	;���������������ң���������չ����Ҫ�����������Ĳ�����ʽ
	Tab & s:: SendInput,^{Down}
	Tab & w:: SendInput,^{Up}
	Tab & a:: SendInput,^{Left}
	Tab & d:: SendInput,^{Right}
	Tab & q:: SendInput,^{PgUp}
	Tab & e:: SendInput,^{PgDn}

	;��Ӧ�������Ϲ̶���ǰ5����������л�
	Tab & 1:: send,#1
	Tab & 2:: send,#2
	Tab & 3:: send,#3
	Tab & 4:: send,#4
	Tab & 5:: send,#5

	;���õ���������
	Tab & r:: SendInput,{Del}
	Tab & f:: SendInput,{Enter}
	Tab & space:: SendInput,{Backspace}

	;���λ�ð��������������������
	Tab & x:: SendInput,{Del}
	Tab & z:: SendInput,{Backspace}

	;����ģʽ����capsһ������㰴��һ�����У����ɷ��Ӱ�
	Tab & j:: SendInput,^{Down}
	Tab & k:: SendInput,^{Up}
	Tab & h:: SendInput,^{Left}
	Tab & l:: SendInput,^{Right}
	Tab & n:: SendInput,^{PgDn}
	Tab & m:: SendInput,^{PgUp}
	Tab & u:: SendInput,^{End}
	Tab & i:: SendInput,^{Home}

	;���������ӦС�˵�
	Tab & v:: GoSub,EzOtherMenuShow

	;ճ��Ȼ��س���������������������λ�ã�һ��˫�֣�һ������
	Tab & g::
		GV_KeyClickAction1 := "SendInput,^v{Enter}"
		GV_KeyClickAction2 := "SendInput,^{Home}^+{End}^v{Enter}"
		GoSub,Sub_KeyClick123
	return

	;ת��Vim���б༭
	Tab & c::
		GV_KeyClickAction1 := "GoSub,Sub_CopyVim"
		GV_KeyClickAction2 := "GoSub,Sub_CopyAllVim"
		GoSub,Sub_KeyClick123
	return

	;��Ҫ��alttab�˵�
	<!Tab::AltTab

	;�ָ�tab������
	Tab:: SendInput,{Tab}
	;˫��tab�������Լ���tab����Ӧ�ٶȣ�����
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


;************** ����ģʽ ************** {{{2
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



;************** ��ͼС���� ************** {{{2
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

;************** ������� ************** {{{2
;ȥ��������
#f11::
	;WinSet, Style, ^0xC00000, A ;�����л������У���ҪӰ�����޷��϶�����λ�á�
	;WinSet, Style, ^0x40000, A ;�����л�sizing border����ҪӰ�����޷��ı䴰�ڴ�С��
	GoSub, Sub_WindowNoCaption
return



;************** mouse������ ************** {{{2
;����߼�XButton2,ahkֻ������������������ȥ��ע��
XButton2::Send,{PgUp}
XButton1::Send,{PgDn}
XButton2 & XButton1::SendInput,{Escape}
XButton1 & XButton2::SendInput,{Escape}

;************** ����ģʽ�Ŀ��أ���ͣ���� ************** {{{2
ScrollLock::
CapsLock & /::
Escape & /::
	GV_ToggleKeyMode := !GV_ToggleKeyMode
	if(GV_ToggleKeyMode == 1)
		tooltip ����ģʽ����
	else
		tooltip ����ģʽ�ر�
	sleep 2000
	tooltip
return

^!#Space::
	GV_ToggleSpaceKeys := !GV_ToggleSpaceKeys
	if(GV_ToggleSpaceKeys == 1)
		tooltip �ո���ϼ�����
	else
		tooltip �ո���ϼ��ر�
	sleep 2000
	tooltip
return

;ֱ����ctrl+win+alt+tab��������alttab�������ʡ���caps�ͻ����ǲ�����ģʽ���ڵġ����û��š�
^!#`::
	GV_ToggleTabKeys := !GV_ToggleTabKeys
	if(GV_ToggleTabKeys == 1)
		tooltip Tab��ϼ�����
	else
		tooltip Tab��ϼ��ر�
	sleep 2000
	tooltip
return


;��ͣ�ȼ��������ٰ��ָ�
Pause::
^!#t::
;Escape & Pause::
;CapsLock & Pause::
	suspend permit
	suspend toggle
return

;��ͣ�ű��������Ҽ��˵�ѡ������������ű��ָ�
^!#z:: 
	suspend permit
	pause toggle
return

^!#r::
	Gosub,ForceSelfReload
return

;���Win10���������޷��л��ĳ�ë��
^!#e::run,nircmd shellrefresh


;************** Ӧ�ó������ ************** {{{1
;************** _group��� ************** {{{2
#IfWinActive, ahk_group group_browser
	F1:: SendInput,^t
	F2:: send,{Blind}^+{Tab}
	F3:: send,{Blind}^{Tab}
	F4:: SendInput,^w

	;`;:: 
		;;msgbox % GetCursorShape()
		;;64λ��Win7�£������������148003967
		;If (GetCursorShape() = GV_CursorInputBox)      ;I �͹��
			;SendInput,`;
		;else 
			;Send {Click}
	;return
	;!`;:: Send {Click Right}
	;^`;:: Send,`;


	;��ס������Ҽ�����Ctrl+W�رձ�ǩ
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
			;����
			if GV_GroupBrowserToggleWheelModeLeftRight 
				SendInput,{MButton}
			else
				Send,{PgUp}
		} Else If (p = "00") {
			;˫��
			GV_GroupBrowserToggleWheelModeLeftRight := !GV_GroupBrowserToggleWheelModeLeftRight
			eztip("�л�������ģʽ" . GV_GroupBrowserToggleWheelModeLeftRight,2)
		}
	return

	XButton1::
		p := ClickAndLongClick()
		If (p = "0") {
			;����
			if GV_GroupBrowserToggleMButtonMode 
				SendInput,{MButton}
			else
				Send,{PgDn}
		} Else If (p = "00") {
			;˫��
			GV_GroupBrowserToggleMButtonMode := !GV_GroupBrowserToggleMButtonMode
			eztip("�л���߼���Ϊ�м�" . GV_GroupBrowserToggleMButtonMode,2)
		} Else If (p = "01") {
			;˫���ٰ�ס
			GV_GroupBrowserToggleWheelModeUpDown := !GV_GroupBrowserToggleWheelModeUpDown
			eztip("�л�����Ϊ��ҳ" . GV_GroupBrowserToggleWheelModeUpDown,2)
		}
	return


	;��������л�����ģʽ����Ҫ�Ƿ��㿴��Ƶ�����Ϻ�Bվ
	<!Space::
		GV_GroupBrowserToggleWheelModeLeftRight := !GV_GroupBrowserToggleWheelModeLeftRight
		eztip("������ģʽ�л�" . GV_GroupBrowserToggleWheelModeLeftRight,2)
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

;��������е������ÿո���ϼ�
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

	;�Ƚ������ͣ�������ϣ����������Ҽ��˵���Ȼ��ѡ���Ϊ
	Space & a:: 
		Send,{RButton}
		sleep,200
		send,k
	return

	;�����ı�
	Space & RButton:: SendInput,^c
	;ճ��

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


	;����3������ѡ���ı����䣬Ȼ����
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
	;�ȵ��IDM����
	ControlGetPos, x, y, w, h, IDM Download Button class1
	ControlClick, IDM Download Button class1, , , LEFT, 1, x12 y8
	sleep 500
	MouseMove, x,y
	;���������Լ�ѡ�������һ�������ȵ�
	sleep 3000

	WinWait, �����ļ���Ϣ ahk_class #32770, , 20
	IfWinNotActive, �����ļ���Ϣ ahk_class #32770, , WinActivate, �����ļ���Ϣ ahk_class #32770
	WinWaitActive, �����ļ���Ϣ ahk_class #32770, , 20

	;WinWaitActive, �����ļ���Ϣ ahk_class #32770, , 20
	if !ErrorLevel
	{
		;ControlGetText,Out,Edit1,�����ļ���Ϣ ahk_class #32770 ahk_exe IDMan.exe
		ControlGetText,Out,Edit1,�����ļ���Ϣ ahk_class #32770
		WinClose,�����ļ���Ϣ ahk_class #32770
		run,%A_ScriptDir%\Plugins\WLX\vlister\mpv.exe "%Out%"
	}
return


#IfWinActive, ahk_group group_disableCtrlSpace
	^Space::Controlsend,,^{Space}
	+Space::Controlsend,,+{Space}
#IfWinActive



;totalcmd������İ�ס������Ҽ��ƶ�
;#IfWinNotActive ahk_class TTOTAL_CMD
;~LButton & RButton::
	;;opera ���������֮�ж��������Լ��İ�ס������Ҽ�����
	;if not WinActive("ahk_class OperaWindowClass") and not WinActive("GreenBrowser"){
	;send ^w
	;}
;return 
;#IfWinNotActive




;************** ���±� ************** {{{1

;�������±���ȥ����� {{{3
#n::
	run %A_ScriptDir%\Tools\notepad\Notepad.exe /f %A_ScriptDir%\Tools\notepad\Lite.ini, , , OutputVarPID
	sleep 100
	WinWait ahk_pid %OutputVarPID%
	if ErrorLevel
	{
		toolTip ��ʱ�ˣ�����һ�£�
		sleep 2000
		tooltip
		return
	}
	else
	{
		PID = %OutputVarPID%
		WinGet, ThisHWND, ID, ahk_pid %PID% 
		;����λ�úʹ�С, x,y,width,height
		;WinMove, ahk_id %ThisHWND%,, 700,400,550,350
		WinMove, ahk_id %ThisHWND%,, 700,600,310,144
		;WinMove, ahk_pid %PID%,, 700,400,550,350
		;ȥ����
		;WinSet, Style, ^0xC00000, ahk_pid %PID%
		;���ܸı��С
		;WinSet, Style, ^0x40000, ahk_pid %PID%
		;ȥ�˵�
		DllCall("SetMenu", "Ptr", ThisHWND, "Ptr", 0)
		;����
		;Winset, Alwaysontop, On,  ahk_pid %PID%
	}
return

;�������±���ȥ����ȣ����ռ������� {{{3
^#n::
	run %A_ScriptDir%\Tools\notepad\Notepad.exe /b /f %A_ScriptDir%\Tools\notepad\Lite.ini, , , OutputVarPID
	sleep 100
	WinWait ahk_pid %OutputVarPID%
	if ErrorLevel
	{
		toolTip ��ʱ�ˣ�����һ�£�
		sleep 2000
		tooltip
		return
	}
	else
	{
		PID = %OutputVarPID%
		WinGet, ThisHWND, ID, ahk_pid %PID% 
		;����λ�úʹ�С, x,y,width,height
		;WinMove, ahk_id %ThisHWND%,, 700,400,550,350
		WinMove, ahk_id %ThisHWND%,, 700,600,310,144
		;WinMove, ahk_pid %PID%,, 700,400,550,350
		;ȥ����
		;WinSet, Style, ^0xC00000, ahk_pid %PID%
		;���ܸı��С
		;WinSet, Style, ^0x40000, ahk_pid %PID%
		;ȥ�˵�
		DllCall("SetMenu", "Ptr", ThisHWND, "Ptr", 0)
		;����
		;Winset, Alwaysontop, On,  ahk_pid %PID%
	}
return



;************** ����,����������޸� ************** {{{1
;�������ɫ��Я��С�˵�����PopSel
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

;�������ɫ��Я��С�˵�����Qsel����������ѡһ����
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
;����ԱȨ��cmd
^#h::run, *RunAs cmd
#c::run %A_ScriptDir%\Tools\notepad\Notepad.exe /c

#F5::run winword.exe
#F6::run excel.exe
#F7::run powerpnt.exe

;************** �������ݼ����� ************** {{{1
;������������س����ݼ� {{{2
;������м���Ϊ��ϼ��������л���Ĭ��ע�͵�
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
	;΢��
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


;Ctrl+Alt+�������λ�����Ӧ��Ŀ¼
^!LButton::
	Send {Click}
	WinGet, ProcessPath, ProcessPath, A
	;Run Explorer /select`, %ProcessPath%
	run,"%COMMANDER_EXE%" /T /O /S /L="%ProcessPath%"
	WinActivate, ahk_class TTOTAL_CMD
return

;����Դ��������ѡ�е��ļ���tc��  {{{2
;Win10����Դ������
;��Դ������
#If WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
{
	!w::
		if(COMMANDER_EXE="")
			return
		selected := Explorer_Get("",true)

		;���û��ѡ���ļ����Ǿ�ֱ���õ�ǰĿ¼
		if(selected = "")
		{
			WinGetText, CurWinAllText
			Loop, parse, CurWinAllText, `n, `r
			{
				If RegExMatch(A_LoopField, "^��ַ: "){
					curWinPath := SubStr(A_LoopField,5)
					break
				}
			}
			selected := curWinPath
		}

		selected := """" selected """"
		;msgbox % selected
		WinClose A  ;�ѵ�ǰ��Դ�������ر�
		run, %COMMANDER_EXE% /T /O /S /A /L=%selected%
	return
}
;����
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

;�õ��ĺ���
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


;QQ,Tim�п��ٶ�λ����λ�� {{{2
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
		;����ĳ��Լ���Ӧ��·��
		run,"%COMMANDER_EXE%" /T /O /S /L="D:\My Documents\Tencent Files\123456789�Լ���qq����\FileRecv\"
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
		;����ĳ��Լ���Ӧ��·��
		run,"%COMMANDER_EXE%" /T /O /S /L="D:\My Documents\Tencent Files\123456789�Լ���qq����\FileRecv\"
		sleep 500
		MyWinWaitActive("ahk_class TTOTAL_CMD")
	return
}


;΢��PC�ͻ��� {{{2
#IfWinActive ahk_exe WeChat.exe
{
	;�۽�������
	!/::CoordWinClick(100,36)
	;�����ɫ���������
	!,::
		CoordMode, Mouse, Window
		click 28,90 2
		Sleep,100
		click 180,100
	Return
	;�۽����ֿ�
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

	;�������޸�everything�е���ǩ��ȷ��ev����ǩ���ֱ���һ��
	!e::
		run, "%A_ScriptDir%\everything.exe" -bookmark wechatfile
	return
	;�������޸�tc������������Ŀ¼λ�� �ĳ��Լ��� ��

	;��tc��Ĭ��D:\My Documents\WeChat Files\corals\FileStorage\MsgAttach�ĳ��Լ���MsgAttac����Ŀ¼ȫ·��
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

	;���Ҽ�ѡɾ��
	!d::
		send,{RButton}
		Sleep,200
		send,{Up 2}{Enter}
		Sleep,500
		send,{Enter}
	Return

	;���Ҽ�ѡ����
	!c::
		send,{RButton}
		Sleep,200
		send,{Down 2}{Enter}
	Return
}


;΢��
;#If WinActive("ͼƬ�鿴 ahk_exe WeChat.exe")
#If WinActive("ͼƬ�鿴 ahk_class ImagePreviewWnd") or WinActive("΢�� ahk_class ImagePreviewLayerWnd")
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

	;˫���Ҽ��ر�
	RButton::
		GV_MouseTimer := 400
		GV_KeyClickAction1 := "Send,{RButton}"
		GV_KeyClickAction2 := "Send,{Escape}"
		GV_MouseButton := 2
		GV_LongClickAction := "Send,{Escape}"
		GoSub,Sub_MouseClick123
	return

	Enter:: GoSub,Sub_MaxRestore
	;����Ƶ���ݵ������
	space:: 
		WinGetPos, x, y,lengthA,hightA, A
		;MouseMove, % lengthA/2 ,hightA/2
		CoordWinClick(lengthA/2,hightA/2)
	return

}

;΢���е�ҳ��
#IfWinActive ΢�� ahk_class CefWebViewWnd
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

;΢�������¼
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

;΢����ת���������¼
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

;QQ Tim�в鿴��Ƭ
#If WinActive("ͼƬ�鿴 ahk_class TXGuiFoundation")
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

;F4menu��
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

;IDM�����ضԻ����У���ȡurl���ӣ�Ȼ����MPC���� {{{2
#IfWinActive �����ļ���Ϣ
	if WinActive ahk_class #32770{
		RButton::
			ControlGetText,Out,Edit1
			WinClose A
			;run,%COMMANDER_PATH%\Tools\MPC\mpc.exe "%Out%"
			run,%A_ScriptDir%\Plugins\WLX\vlister\mpv.exe "%Out%"
		return
	}
#IfWinActive


;IDM��������ɶԻ����У���ȡ�ļ���Ϣ��Ȼ����ת��tc
#If WinActive("������� ahk_class #32770 ahk_exe IDMan.exe")
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

;IDM����
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
	;�����0�ͻ�ȡ�ܹ�����
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

;�жϵ�ǰtc���Ƿ�������ʾ���ղؼв˵�
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
;0����
;00˫��
;01�Ͷ̰�+����
;001����˫��+����


Sub_TcSrcActivateLastTab:
	TcSendPos(5001)
	TcSendPos(3006)
return

;TC��ע�п����Ǻ�����
#IfWinActive �ļ���ע ahk_class TCmtEditForm ahk_exe totalcmd.exe 
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
	text := StrRepeat("��", cnt) . StrRepeat("��", 5-cnt)
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


;Totalcmd�п���
#IfWinActive QUICKSEARCH ahk_class TQUICKSEARCH
{
	;����������в���ֱ�����֣����ÿո�����֣�Ҳ�����Ȱ�capsȡ�������״̬�ٵ���������
	;�۾��ʺϱ��ϵ�Ҳ��ǰ5
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

	;����alt+e��ΪF4
	!e::
		BlockInput On
		Sendinput,{Esc}
		Sleep,100
		Sendinput,{Alt up}
		Sendinput,{F4}
		BlockInput Off
	return

	;����۽���������ж��޷���Ч
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


;eztc totalcmd�п�ݼ� {{{2
#IfWinActive ahk_class TTOTAL_CMD
	Escape & f4::SendInput,!{F3}

	CapsLock & Enter:: SendInput,{Enter}
	CapsLock & Space:: SendInput,{Space}

;tc��ʹ�����ְ��������п��ٴ򿪺Ϳ����л���ǩ
;����֮���������ʹ�ÿ��ѣ��ǿ�����ʼ�����������֣�
;��Ҫ�򿪻�ر�ֱ���޸����е�ע�ͼ���

	^!+d::
		GV_TotalcmdToggleJumpByNumber := !GV_TotalcmdToggleJumpByNumber
		if(GV_TotalcmdToggleJumpByNumber == 1)
			tooltip ������TC�����ּ���ת����
		else
			tooltip �ѹر�TC�����ּ���ת����
		sleep 2000
		tooltip
	return

	1::
		if !GV_TotalcmdToggleJumpByNumber or fun_TcExistHotMenu() or TC_Focus_Edit()
			Sendinput,1
		else {
			p := ClickAndLongClick()
			If (p = "0") {
				;����
				fun_TCselectFileByNum(1)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5001)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(2)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5002)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(3)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5003)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(4)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5004)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(5)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5005)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(6)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5006)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(7)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5007)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(8)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5008)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(9)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5009)
			} Else If (p = "1") {
				;����
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
				;����
				fun_TCselectFileByNum(0)
			} Else If (p = "00") {
				;˫��
				TcSendPos(5001)
				TcSendPos(3006)
			} Else If (p = "1") {
				;����
				TcSendPos(5001)
				TcSendPos(3006)
				TcSendPos(2001)
			}
		}
	return



	;�����������뷨������
	,:: 
		ControlGetFocus, TC_CurrentControl, A
		;TInEdit1 ��ַ���������� Edit1 ������
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
	;���Ƶ�����ѡ��Ŀ¼
	!+F5::
		send,{Tab}^+c{Tab}{F5}
		Sleep,500
		send,^v
		Sleep,500
		send,{Enter 2}
	return
	;�ƶ�������ѡ��Ŀ¼
	!+F6::
		send,{Tab}^+c{Tab}{F6}
		Sleep,500
		send,^v
		Sleep,500
		send,{Enter 2}
	return
	;���ϼ����������ݸ���
	;ez�汾�л���tcfs2ʵ��
	;^F2::
		;send,+{F6}
		;Sleep,300
		;send,{right}
		;Sleep,300
		;send,{Space}^v
		;Sleep,300
		;send,{Enter}
	;return

	^+F2:: ;�����ļ���������
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

	;cm_OpenDirInNewTabOther�м�������ڶ����±�ǩ�д�
	MButton::
		Send,{Click}
		Sleep 50
		TcSendPos(3004)
	return

	;cm_OpenDirInNewTab�м���������±�ǩ�д�
	^MButton::
		Send,{Click}
		Sleep 50
		TcSendPos(3003)
	return

	;����alt+e��ΪF4
	!e::
		BlockInput On
		Sendinput,{Esc}
		Sleep,100
		Sendinput,{Alt up}
		Sendinput,{F4}
		BlockInput Off
	return

	;˫���Ҽ��������˸񣬷�����һ��Ŀ¼
	;~RButton::
		;KeyWait,RButton
		;KeyWait,RButton, d T0.1
		;If ! Errorlevel
		;{
		  ;send {Backspace} 
		;}
	;Return


	;���ŵ�����
	;`:: GoSub,Sub_azHistory
	;`:: Send,{Enter}
	`:: Send,{Appskey}
	!j::TC_azHistory()

	;���ܶԻ�����ת
	!w::
		Dlg_HWnd := WinExist("ahk_group GroupDiagOpenAndSave")
		if Dlg_HWnd 
		;IfWinExist ahk_group GroupDiagOpenAndSave
		{
			WinGetTitle, Dlg_Title, ahk_id %Dlg_HWnd%
			If RegExMatch(Dlg_Title, "���Ϊ|����|ͼ�����Ϊ|���渱��"){
				;msgbox "���Ǳ���Ի���"
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
					eztip("�Ի����Ǳ������ͣ�ֻ�ϵ�һ���ļ�",1)
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
				;msgbox "�򿪶Ի���"
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
			EzTip("ϵͳ��ǰû�д򿪻򱣴�Ի���",2)
		}
	return

#IfWinActive

#If WinActive("ahk_class TTOTAL_CMD") and MouseUnder("(TMy|LCL)ListBox[123]")
	;�������������F4
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

#IfWinActive,���������� ahk_class TMultiRename
{
;F1::Send,!p{tab}{enter}e
F1::Send,{F10}e
}


;wps�� {{{2
;excel 2010: ahk_class bosa_sdm_XL9  excel2013: ahk_class XLMAIN ahk_exe C:\Windows\System32\Notepad.exe
#IfWinActive ahk_Class QWidget ahk_exe wps.exe
{
	;���Ƶ�Ԫ���ı�
	!c:: 
		send,{F2}
		sleep,100
		send,^+{Home}
		sleep,100
		send,^c{Esc}
	return
	;������
	!1::send,!hrcer
	;������
	!2::send,!hrcec
	;�Զ��и�
	![::send,!hrca
	;�Զ��п�
	!]::send,!hrci
}

;excel�� {{{2
;excel 2010: ahk_class bosa_sdm_XL9  excel2013: ahk_class XLMAIN 
;#IfWinActive ahk_exe excel.exe 
#If WinActive("ahk_exe excel.exe") or WinActive("ahk_class XLMAIN")
{
	;���Ƶ�Ԫ���ı�
	!c:: send,{F2}^+{Home}^c{Esc}
	;ɸѡ
	f3::PostMessage, 0x111, 447, 0, , a   
	;��λ
	!g::ControlClick, Edit1
	;��ϸ�༭
	!;::
		ControlClick, EXCEL<1
		send,{Home}
	return
	;���е����и�
	![::
		try{
			ox := ComObjActive("Excel.Application")
			ox.Application.Selection.EntireRow.AutoFit
		}
		catch e{
			;������ô�ͳ��ݼ�
			Send,!ora
		}
	return
	;���е����п�
	!]::
		try{
			ox := ComObjActive("Excel.Application")
			ox.Application.Selection.EntireColumn.AutoFit
		}
		catch e{
			Send,!oca
		}
	return

	;��ӵ�Ԫ��
	^=::SendInput,{Blind}^+=
	;�½�������
	!i::send,!his
	;ɾ��������
	!x::send,!el
	;������������
	!s::send,!ohr

	;Ĭ�Ͽ�ݼ�
	;!WheelUp::Send,!{PgUp}
	;!WheelDown::Send,!{PgDn}

	!WheelUp::Send,{left 8}
	!WheelDown::Send,{right 8}

	+WheelUp::Send,{Left}
	+WheelDown::Send,{Right}

}

;word�� {{{2
;word2013: ahk_class OpusApp
#IfWinActive ahk_exe winword.exe
{
	CapsLock & o:: send,^+{F6}
	CapsLock & p:: send,^{F6}
}

;Everything�� {{{2
;audio:	������Ƶ�ļ�.
;zip:	����ѹ���ļ�.
;doc:	�����ĵ��ļ�.
;exe:	������ִ���ļ�.
;pic:	����ͼƬ�ļ�.
;video:	������Ƶ�ļ�.
;folder:��ƥ���ļ���.
;8-tf-�ı��ļ�
;9-ct-��������
;cf-�ظ��ļ�
;mt-��Ƶ-����ר������
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

;MPV�������� {{{2
#IfWinActive ahk_exe MPV.exe
{
	;�ٶȿ���
	XButton1 & WheelUp::SendInput,[
	XButton2 & WheelUp::SendInput,[
	XButton1 & WheelDown::SendInput,]
	XButton2 & WheelDown::SendInput,]

	;4���л�
	XButton2 & RButton::SendInput,\
	XButton1 & RButton::SendInput,\

	;����
	XButton1::Send,.
	XButton2::Send,,

}

;Qsel������ {{{2
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
	;IrfanView����֧��ctrl+���֣���alt���ð���Ҳ���ö��뵽����һ������
	!WheelDown::send,{,}
	!WheelUp::send,{.}
	;.:: send,{+}
	;,:: send,{-}


	`;::send,{Esc}

	y:: send,{PgDn}
	;����Ƕ������Ȱ�g��ͣ����ͼƬ�˺��ٰ�jk
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



;����Ŀ¼�л� {{{2
;�ղص�Ŀ¼��
;���ʹ�õ�Ŀ¼
#IfWinActive, ahk_group GroupDiagOpenAndSave
	;�ӶԻ������л���tc����tc����ѡ�ļ���Ȼ��alt+w�ٻ���
	!w:: GoSub,Sub_SendCurDiagPath2Tc
	;ֱ����tc�еĵ�ַ���Ѿ�ѡ�ã�
	!g:: GoSub,Sub_SendTcCurPath2Diag
#IfWinActive

;��TC�д򿪶Ի����·��
Sub_SendCurDiagPath2Tc:
	WinActivate, ahk_class TTOTAL_CMD
	;WinGetText, CurWinAllText
	;;MsgBox, The text is:`n%CurWinAllText%
	;Loop, parse, CurWinAllText, `n, `r
	;{
		;If RegExMatch(A_LoopField, "^��ַ: "){
			;curDiagPath := SubStr(A_LoopField,4)
			;break
		;}
	;}
	;WinActivate, ahk_class TTOTAL_CMD
	;ControlSetText, Edit1, cd %curDiagPath%, ahk_class TTOTAL_CMD
	;sleep 900
	;ControlSend, Edit1, {enter}, ahk_class TTOTAL_CMD
return


;��tc��·�����͵��Ի���
Sub_SendTcCurPath2Diag:
	;���أ� ����������������Ϊ�ļ���
	B_Clip2Name := false
	;���أ� �Ƿ�Ĵ�Ի���
	B_ChangeDiagSize := true

	ControlGetText, orgFileName,Edit1

	;�Ȼ�ȡTC�е�ǰ·��
	clip:=Clipboard
	Clipboard =
	TcSendPos(CM_CopySrcPathToClip)
	;TcSendPos(CM_CopyFullNamesToClip)

	ClipWait, 1
	tcSrcPath := Clipboard
	Clipboard:=clip

	;���������Ŀ¼c:\�Ͳ��ö������\
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
		;�ı�Ի����С��ʡ�¾�ֱ���ƶ���100,100��λ�ã�Ȼ��85%��Ļ��С�������Ҫ��ϸ�������������������ҵ�λ��
		WinMove, A,,80,80, A_ScreenWidth * 0.85, A_ScreenHeight * 0.85
	}
return


;�����Ի����в˵�
Sub_Menu2Diag:
;�����ʷ
;�ұ���ʷ
;hotdir
return


;Totalcmd��ʷ��¼ {{{2
;��Ӱ���ini��ȡ�������˵����ӹ�`����
;��������ǿ
;�̶��ı���Ŀ��ǿ
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
		;����&��ʶ��ɿ�ݼ�
		value := RegExReplace(value, "\t.*$")
		name := StrReplace(value, "&", ":��:")

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
		if RegExMatch(Value, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|") ;NothingIsBig����XPϵͳ�������ھ����������
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
	Menu, az, Add, [& ]    �ر�,azHistoryDeleteAll
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
	else if ( history_name_obj[A_ThisMenuItem] = 2125 ) or RegExMatch(A_ThisMenuItem, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}") or RegExMatch(A_ThisMenuItem, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|") ;NothingIsBig����XPϵͳ�������ھ����������
		TcSendPos(cm_OpenNetwork)
	else if ( history_name_obj[A_ThisMenuItem] = 2127 ) or RegExMatch(A_ThisMenuItem, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}")
		TcSendPos(cm_OpenRecycled)
	else
	{
		ThisMenuItem := StrReplace(A_ThisMenuItem, ":��:", "&")
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
	Menu,Tray,add,Edit�༭�ű�,Menu_Edit
	Menu,Tray,add,Spy,Menu_Debug
	Menu,Tray,add,AHK�����ĵ�,Menu_Document
	Menu,Tray,add,Open�������,Menu_Open
	Menu,Tray,add
	Menu,Tray,add,������ر���ϵͳ�Զ�����,Menu_AutoStart
	Menu,Tray,add,��ӻ�ȥ������SoftDir����,Menu_SoftDir
	Menu,Tray,add,ʰ�Ų�ȱ���̻�,Menu_GreenPath
	Menu,Tray,add
	Menu,Tray,add,�����ű�(&R),Menu_Reload
	Menu,Tray,add
	Menu,Tray,add,��ͣ�ȼ�(&S),Menu_Suspend
	Menu,Tray,add,��ͣ�ű�(&A),Menu_Pause
	Menu,Tray,add,�˳�(&X),Menu_Exit
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
		eztip("�ѹر�CapsEz��ϵͳ�Զ�����",10)
	}
	else
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, Software\Microsoft\Windows\CurrentVersion\Run, CapsEz, "%A_AhkPath%"
		eztip("������CapsEz��ϵͳ�Զ�����",10)
	}
return

Menu_SoftDir:
	if A_Is64bitOS 
		SetRegView 64
	RegRead, OutputVar, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
	if OutputVar
	{
		RegDelete, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
		eztip("��ȥ��SoftDir��������",10)
	}
	else
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir, %SOFTDIR%
		eztip("�����SoftDir��������",10)
	}
return

;Menu_RightMenu:
	;if A_Is64bitOS 
		;SetRegView 64
	;RegRead, OutputVar, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
	;if OutputVar
	;{
		;RegDelete, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir
		;eztip("��ȥ��SoftDir��������",10)
	;}
	;else
	;{
		;RegWrite, REG_SZ, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Control\Session Manager\Environment, SoftDir, %SOFTDIR%
		;eztip("�����SoftDir��������",10)
	;}
;return


Menu_GreenPath:
	;1��newfile�е�ģ�壬Tools\NewFiles\NewFiles.ini
	p := A_scriptDir . "\Tools\NewFiles\Templates"
	IniWrite, %p%,  %A_scriptDir%\Tools\NewFiles\NewFiles.ini, FileList,TemplatePath

	;2��everything��Everything.ini
	p := "$exec(""" . A_scriptDir . "\" . COMMANDER_NAME . """ /A /T /O /S /L=""%1"")"
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,open_folder_command2
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,open_path_command2
	p := "$exec(""" . A_scriptDir . "\Tools\F4Menu\F4Menu.exe"" ""%1"")"
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,explore_command2
	IniWrite, %p%,  %A_scriptDir%\Everything.ini, Everything,explore_path_command2

	;3��tcmatch.ini
	p := "Long description@" . A_scriptDir . "\Plugins\WDX\FileDiz\FileDiz.wdx"
	IniWrite, %p%,  %A_scriptDir%\tcmatch.ini, wdx, wdx_text_plugin3
return

Menu_Suspend:
	Menu,tray,ToggleCheck,��ͣ�ȼ�(&S)
	Suspend
return
Menu_Pause:
	Menu,tray,ToggleCheck,��ͣ�ű�(&A)
	Pause
return
Menu_Exit:
	ExitApp
return

Quit:
ExitApp

; vim: textwidth=120 wrap tabstop=4 shiftwidth=4
; vim: foldmethod=marker fdl=0
