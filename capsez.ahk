;CapsLock��ǿ�ű�������
;by Ez
;v190721 �����tc�����м������Ŀ¼
;v190904 ������ͣ���ȼ���ֱ�Ӱ�AutoHotkey.exe����Ϊcapsez.exe
;v190916 ��Ӽ���ģʽ�Ŀ��أ����BUG10�������޷��л�
;v190927 ��ӿ�ݼ���TC�д���Դ��������ѡ�е��ļ��������tc��˫���Ҽ�������һ�����Զ���ȡTC·��
;v191214 ���ý�岥����ؿ�ݼ����Ҽ��϶����ڣ����һ��С�����Сϸ��
;v200108 �޸����ʹܻ�����ûѡ�ļ������⡣���޸�һЩϸ��
;v200401 ��Ӳ�ͬ�����ж�Ӧ��ͬ��С�˵�����ǿ�Ի���tab��ϼ���

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
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_0    ;Chrome
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_1    ;Chrome
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_100  ;liebao
GroupAdd, group_browser,ahk_class QQBrowser_WidgetWin_1

GroupAdd, group_disableCtrlSpace, ahk_exe excel.exe
GroupAdd, group_disableCtrlSpace, ahk_exe pycharm.exe
GroupAdd, group_disableCtrlSpace, ahk_exe SQLiteStudio.exe

GroupAdd,GroupDiagOpenAndSave,Open ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Save As ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���Ϊ ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,�½� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,�� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,ͼ�����Ϊ ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,�ļ��� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���渱�� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,�ϴ� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,ѡ���ļ� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���ļ� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,����ͼƬ ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,���� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,����Ƕ����� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,��� ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,ѡ��Ҫ�Ƚϵ�ͼ�� ahk_class #32770
SetTitleMatchMode RegEx ; 2019/10/16 ���������飬�������
GroupAdd, GroupDiagOpenAndSave, i).*(ѡ��|Select|����|�ϴ�|���|��).*(�ļ�|files?|images?|ͼ��|ͼ��|program|����) ahk_class #32770 ; 
SetTitleMatchMode 2 ; 2019/10/16 ������������ָ���ͨƥ��


;GroupAdd, group_disableCtrlSpace, ahk_exe gvim.exe 
;GroupAdd, group_disableCtrlSpace, ahk_class NotebookFrame��ע��ahk_class������AHK������mathematica��class����

;************** group����$ **************

;�趨15��������һ�νű�����ֹ���� 1000*60*15
GV_ReloadTimer := % 1000*60*15
Gosub,AutoReloadInit
Gosub,CreatTrayMenu

;�Ƿ����ù���¹���
GV_ToggleWheelOnCursor := 1

;tabϵ����ϼ����ʺ�����������ú�ֱ�Ӱ�tab��о���һ���ӳ٣�Ĭ�Ͽ���������Ϊctrl+win+alt+����
GV_ToggleTabKeys := 1

;���ÿո�ϵ�п�ݼ������û�Ӱ����֣���tc�л᲻�ܰ�ס��ѡ�ļ���Ĭ�Ϲرգ�����Ϊctrl+win+alt+�ո�
GV_ToggleSpaceKeys := 0

;������������ÿո�ϵ�п�ݼ�
GV_GroupBrowserToggleSpaceKeys := 1

;����ģʽ�����ذ���Ϊcaps+/
GV_ToggleKeyMode := 0

;64λ��Win7�£������������148003967
GV_CursorInputBox_64Win7 := 148003967

;������Լ���tc�������ı��ű��������Զ�����COMMANDER_PATH
;������Ǳ�ĵط�������ע����autorun�����������ı��ű�����ô���б�Ҫ�������������
;1���������ű�����������ϵͳ����������ôCOMMANDER_PATHΪ��
;2��������tc����ôCOMMANDER_PATH��������Ϊ�գ����Զ�ȡ�����е�exe·��
;3��������Ǹ��ݽű�����Ŀ¼���Ƿ����TOTALCMD.EXE����TOTALCMD64.EXE
COMMANDER_PATH := % GF_GetSysVar("COMMANDER_PATH")
WinGet,TcExeFullPath,ProcessPath,ahk_class TTOTAL_CMD
if !TcExeFullPath ;ûtc������
{
	if A_Is64bitOS {
		if FileExist(A_WorkingDir . "\" . "TOTALCMD64.EXE") {
			TcExeFullPath := % A_WorkingDir . "\" . "TOTALCMD64.EXE"
			EnvSet,COMMANDER_PATH, A_WorkingDir
		} else if FileExist(A_WorkingDir . "\" . "TOTALCMD.EXE") {
			TcExeFullPath := % A_WorkingDir . "\" . "TOTALCMD.EXE"
			EnvSet,COMMANDER_PATH, A_WorkingDir
		} else{
			toolTip ��ǰĿ¼��ûTotalcmd����
			sleep 2000
			tooltip
		}
	}
	else {
		if FileExist(A_WorkingDir . "\" . "TOTALCMD.EXE") {
			TcExeFullPath := A_WorkingDir . "\" . "TOTALCMD.EXE"
			EnvSet,COMMANDER_PATH, % A_WorkingDir
		} else {
			toolTip ��ǰĿ¼��ûTotalcmd����
			sleep 2000
			tooltip
		}
	}
}
else{ ;��tc������
	if(COMMANDER_PATH == A_WorkingDir) {
		EnvSet,COMMANDER_PATH, % A_WorkingDir
	}
	else if !COMMANDER_PATH  ;���ű���������������ϵͳ�����������Բ�û��COMMANDER_PATH����
	{
		WinGet,TcExeName,ProcessName,ahk_class TTOTAL_CMD
		StringTrimRight, COMMANDER_PATH, TcExeFullPath, StrLen(TcExeName)+1
		EnvSet,COMMANDER_PATH, % COMMANDER_PATH
	}
}

;GV_ToolsPath := % GF_GetSysVar("ToolsPath")
GV_TempPath := % GF_GetSysVar("TEMP")


;Ĭ��˫����ݼ����175΢��
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

;���������Ϲ��ֵ�������
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}
MButton::Send,{Volume_Mute}
#If
;Win10�����Ѿ�����Ҫ����¹����������

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

;************** �ڹ���·����ֽ��� ************** {{{2

;************** ��ʱ�����ű����֣���λ�� ************** {{{1
AutoReloadInit:
	SetTimer, SelfReload, % GV_ReloadTimer
return
SelfReload:
	reload
return

;************** caps+�����ֵ�������͸����^    ************** {{{1
;caps+�����ֵ�������͸���ȣ�����30-255��͸���ȣ�����30�����ϾͿ������ˣ�����Ҫ�������޸ģ�
;~LShift & WheelUp::
CapsLock & WheelUp::
; ͸���ȵ��������ӡ�
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
		;Transparent_New:=Transparent+10
	Transparent_New:=Transparent+20    ;��͸���������ٶȡ�
	If (Transparent_New > 254)
		Transparent_New =255
	WinSet,Transparent,%Transparent_New%,A

	tooltip ԭ͸����: %Transparent_New% `n��͸����: %Transparent%
	;�鿴��ǰ͸���ȣ�����֮��ģ���
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

CapsLock & WheelDown::
	;͸���ȵ��������١�
	WinGet, Transparent, Transparent,A
	If (Transparent="")
		Transparent=255
	Transparent_New:=Transparent-10  ;��͸���ȼ����ٶȡ�
	;msgbox,Transparent_New=%Transparent_New%
	If (Transparent_New < 30)    ;����С͸�������ơ�
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

;��סcaps���Ҽ��Ŵ����С����
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
;************** ��סCaps�϶�����$    **************

;��סWin������Ŵ����С����
Capslock & MButton::GoSub,Sub_MaxRestore
LWin & LButton::GoSub,Sub_MaxRestore
;Win���Ҽ�����popsel��Ϊ���������ؼ��������ö������ã����Ը����ܵ��м�
LWin & MButton::Winset, Alwaysontop, toggle, A
;�����ö�����ÿ�ݼ����ĸ�׼ȷһ��
#F1::Winset, Alwaysontop, toggle, A
;��Ĭ��Ctrl��W�ǹرձ�ǩ���޸�һ��ɹرճ���
#w::WinClose A

;��סWin�ӹ���������������С
LWin & WheelUp::Send,{Volume_Up}
LWin & WheelDown::Send,{Volume_Down}


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
		fun_KeyClickAction123(GV_KeyClickAction1)
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


;************** CapsLock��� ************** {{{2
;win+caps+����
;Capslock & e::
;state := GetKeyState("LWin", "T")  ; �� CapsLock ��ʱΪ��, ����Ϊ��.
;if state
	;msgbox handle��
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

;�����ֽ����������
CapsLock & j::SendInput,{Down}
CapsLock & k::SendInput,{Up}
CapsLock & h::SendInput,{Left}
CapsLock & l::SendInput,{Right}

;�Ҽ��˵�
;CapsLock & y:: send,{AppsKey}
CapsLock & y:: Send {Click Right}

 
;ý�����
CapsLock & 9::send,{Media_Prev}
CapsLock & 0::send,{Media_Next}

CapsLock & -::send,{Volume_Down}
CapsLock & =::send,{Volume_Up}

CapsLock & Del::send,{Volume_Mute}
CapsLock & backspace::send,{Media_Play_Pause}

CapsLock & PgUp:: send,{Media_Prev}
CapsLock & PgDn:: send,{Media_Next}

;�ƶ�����꣬����������Ļȡɫ
CapsLock & up::MouseMove, 0, -1, 0, R
CapsLock & down::MouseMove, 0, 1, 0, R
CapsLock & left::MouseMove, -1, 0, 0, R
CapsLock & right::MouseMove, 1, 0, 0, R

;************** u,i����˫��^ **************
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
	Menu, MyMenu, Add  ; ��ӷָ���.
	Menu, MyMenu, Add, ��������, Sub_OpenUrlByPlayer
	Menu, MyMenu, Add  ; ��ӷָ���.
	Menu, MyMenu, Add, ���ı�ճ��, PastePureText
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
^CapsLock::  ; control + capslock to toggle capslock.  alwaysoff/on so that the key does not blink
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
	GV_KeyClickAction2 := "SendInput,^{Home}"
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
LButton & WheelUp::ShiftAltTab
LButton & WheelDown::AltTab
;��û��Ҫ���������
;LWin & WheelUp::ShiftAltTab
;LWin & WheelDown::AltTab

;����в���
#IfWinActive, ahk_class TaskSwitcherWnd
	;Win10�Լ��Ѿ�֧��alttab�а��ո�ѡ�����
	;if A_OSVersion in WIN_2003, WIN_XP, WIN_7
	;{
	!Space::send,{Alt Up}
	Space::send,{Alt Up}
	;}
	;��alttab�Ĳ˵��У����Ҽ�ѡ�ж�Ӧ�ĳ���
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;alt+shift+tab���л�����һ�����ڹ��ܣ�����һ���� TaskSwitcherWnd����
	;<+Tab::ShiftAltTab


	;����
	!q::SendInput,{Blind}{Left}
	;����
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
#IfWinActive

;Win10�ĳ���MultitaskingViewFrame
#IfWinActive, ahk_class MultitaskingViewFrame
	!RButton::send,{Alt Up}
	~LButton & RButton::send,{Alt Up}

	;����
	!q::SendInput,{Blind}{Left}
	;����
	!j::SendInput,{Blind}{Down}
	!k::SendInput,{Blind}{Up}
	!h::SendInput,{Blind}{Left}
	!l::SendInput,{Blind}{Right}
	!u::SendInput,{Blind}{End}
	!i::SendInput,{Blind}{Home}
	!,::SendInput,{Blind}{Left}
	!.::SendInput,{Blind}{Right}
#IfWinActive


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
	if(wd==1){
		SSFileName = % ScreenShotPath . "SSAW-" . fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
		run nircmd savescreenshotwin "%SSFileName%"
	}
	else{
		SSFileName = % ScreenShotPath . "SSWD-" .  fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
		run nircmd savescreenshot "%SSFileName%"
	}
}


;************** ������� ************** {{{2
;ȥ��������
#f11::
	;WinSet, Style, ^0xC00000, A ;�����л������У���ҪӰ�����޷��϶�����λ�á�
	;WinSet, Style, ^0x40000, A ;�����л�sizing border����ҪӰ�����޷��ı䴰�ڴ�С��
	GoSub, Sub_WindowNoCaption
return



;************** mouse������ ************** {{{2
;����߼�ahkֻ������������������ȥ��ע��
;XButton1:: Send,{PgUp}
;XButton2:: Send,{PgDn}

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
	Reload
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
	`;:: 
		;msgbox % GetCursorShape()
		;64λ��Win7�£������������148003967
		If (GetCursorShape() = GV_CursorInputBox_64Win7)      ;I �͹��
			SendInput,`;
		else 
			Send {Click}
	return
	!`;:: Send {Click Right}
	;^`;:: Send,`;

	;��ס������Ҽ�����Ctrl+W�رձ�ǩ
	~LButton & RButton:: send ^w

#IfWinActive

;��������е������ÿո���ϼ�
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
	run %COMMANDER_PATH%\Tools\notepad\Notepad.exe /f %COMMANDER_PATH%\Tools\notepad\Lite.ini, , , OutputVarPID
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
^#b::
	run %COMMANDER_PATH%\Tools\notepad\Notepad.exe /b /f %COMMANDER_PATH%\Tools\notepad\Lite.ini, , , OutputVarPID
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
#z::run %COMMANDER_PATH%\Tools\popsel\PopSel.exe /pc /n 
;#RButton::run %COMMANDER_PATH%\Tools\popsel\PopSel.exe /n /i
#h::run, cmd
;����ԱȨ��cmd
^#h::run, *RunAs cmd
#c::run %COMMANDER_PATH%\Tools\notepad\Notepad.exe /c
#f::run %COMMANDER_PATH%\Everything.exe
#p::run powershell 
;#F5::run winword.exe
;#F6::run excel.exe
;#F7::run powerpnt.exe

;************** �������ݼ����� ************** {{{1
;������������س����ݼ� {{{2
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
	;΢��
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


;Ctrl+Alt+�������λ�����Ӧ��Ŀ¼
^!LButton::
	Send {Click}
	WinGet, ProcessPath, ProcessPath, A
	;Run Explorer /select`, %ProcessPath%
	run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /S /L="%ProcessPath%"
	WinActivate, ahk_class TTOTAL_CMD
return

;����Դ��������ѡ�е��ļ���tc��  {{{2
;Win10����Դ������
;��Դ������
#If WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
{
	!w::
		if(TcExeFullPath="")
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
		run, %TcExeFullPath% /T /O /S /A /L=%selected%
	return
}
;����
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

	;���ٵ�΢�Ž��յ��ļ�Ŀ¼�����Լ��޸Ķ�ӦĿ¼
	!f::
		wx_path = % "D:\Document\WeChat Files\shtonyteng\FileStorage\File\" . fun_GetFormatTime( "yyyy-MM" )
		run,"%COMMANDER_PATH%\totalcmd.EXE" /T /O /S /L="%wx_path%"
	return

	;���Ҽ�ѡɾ��
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

;IDM�����ضԻ����У���ȡurl���ӣ�Ȼ����MPC���� {{{2
#IfWinActive �����ļ���Ϣ
	if WinActive ahk_class #32770{
		RButton::
			ControlGetText,Out,Edit1
			WinClose A
			;run,%COMMANDER_PATH%\Tools\MPC\mpc.exe "%Out%"
			run,%COMMANDER_PATH%\Plugins\WLX\vlister\mpv.exe "%Out%"
		return
	}
#IfWinActive

;totalcmd�п�ݼ� {{{2
#IfWinActive ahk_class TTOTAL_CMD
	!e::Send {F4} /*e key conflict with edit*/
	Escape & f4::SendInput,!{F3}

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
	^F2::
		send,+{F6}
		Sleep,300
		send,{right}
		Sleep,300
		send,{Space}^v
		Sleep,300
		send,{Enter}
	return

	;�м���������½���ǩ�д�
	MButton::
		Send,{Click}
		Sleep 50
		TcSendPos(3003)
	return

	;˫���Ҽ��������˸񣬷�����һ��Ŀ¼
	~RButton::
		KeyWait,RButton
		KeyWait,RButton, d T0.1
		If ! Errorlevel
		{
		  send {Backspace} 
		}
	Return

	`:: GoSub,Sub_azHistory

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
						ControlSetText, Edit1, %fileName% 
					}
					else{
						ControlSetText, Edit1, %orgFileName% 
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
					ControlSetText, Edit1, %selFiles% 
				}
			}
			reload
		}
		else{
			EzTip("ϵͳ��ǰû�д򿪻򱣴�Ի���",2)
		}
	return

#IfWinActive

TcSendPos(Number)
{
    PostMessage 1075, %Number%, 0, , AHK_CLASS TTOTAL_CMD
}

#IfWinActive,���������� ahk_class TMultiRename
{
F1::Send,!p{tab}{enter}e
}

;excel�� {{{2
;excel 2010: ahk_class bosa_sdm_XL9  excel2013: ahk_class XLMAIN ahk_exe C:\Windows\System32\Notepad.exe 
#IfWinActive ahk_exe excel.exe 
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

	!WheelUp::Send,!{PgUp}
	!WheelDown::Send,!{PgDn}

}

;word�� {{{2
;word2013: ahk_class OpusApp
#IfWinActive ahk_exe winword.exe
{
	CapsLock & o:: send,^+{F6}
	CapsLock & p:: send,^{F6}
}

;����Ŀ¼�л� {{{2
;�ղص�Ŀ¼��
;���ʹ�õ�Ŀ¼
;#IfWinActive ���Ϊ ahk_class #32770
;#If WinActive("���Ϊ ahk_class #32770") or WinActive("�� ahk_class #32770")
;!f:: SendPath2Diag("���Ϊ","Edit1","d:\My Documents\����")
;send,!n%2Path%{Enter}{Del}
;send,% text
;ControlSetText, Edit1, "d:\My Documents\����",A
;ControlSetText, Edit1, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
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
Sub_azHistory:

    Global TC_azHistorySelect
	;MaxItem := 36
	;MaxItem := 10
	MaxItem := 30

	WinGet,exeName,ProcessName,A
	WinGet,exeFullPath,ProcessPath,A
	;D:\tools\totalcmd\TOTALCMD.EXE �����������������

	if(SubStr(exeFullPath,2,2)!=":\")
	{
		WinGet,pid,PID,A
		;\Device\RAMDriv\totalcmd\TOTALCMD.EXE ���ڴ�������
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

        Menu, TC_azHistory, Add, �ر�%A_Tab%[& ],TC_azHistory_DeleteAll
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
	Menu,Tray,add,����(&R),Menu_Reload
	Menu,Tray,add
	Menu,Tray,add,��ͣ�ȼ�(&S),Menu_Suspend
	Menu,Tray,add,��ͣ�ű�(&A),Menu_Pause
	Menu,Tray,add,�˳�(&X),Menu_Exit
return

Menu_Debug:
	run,AU3_Spy.exe
return

Menu_Reload:
	Reload
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

; �Զ��幦�� {{{1
; ���뷨�л� {{{2
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
