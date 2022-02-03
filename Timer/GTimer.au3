#Region Libraries
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <UpDownConstants.au3>
#include <WindowsConstants.au3>
#include <DateTimeConstants.au3>
#include <FontConstants.au3>
#include <ColorConstants.au3>
#include <Date.au3>
#include <GuiEdit.au3>
#include <AutoItConstants.au3>
#include <Misc.au3>
#include <TrayConstants.au3>
#EndRegion Libraries

#Region Wrapper
#AutoIt3Wrapper_Icon="ICO icon.ico"
TraySetIcon(@ScriptDir & "\icon.ico")
Opt("TrayMenuMode", 3) ;hide default paused and exit
Opt("TrayAutoPause", 0)
TraySetState($TRAY_ICONSTATE_SHOW)
#EndRegion Wrapper

#Region Global Variables
Global $hr, $min, $sec, $elapsed, $intEvery, $TimerOn, $intTimerOn, $seconds, $secondsInt, $intTime
Global $idColor1, $idColor2, $idColor3
Global $hrInt = 0
Global $intBool = False
Global $timerOn = False
Global $sound1 = @WindowsDir & "\Media\Ring06.wav"
Global $sound2 = @WindowsDir & "\Media\Tada.wav"
Global $sound3 = @WindowsDir & "\Media\Speech On.wav"
Global $sound4 = @WindowsDir & "\Media\Speech Off.wav"
#EndRegion Global Variables

ini_read()
ThemePop()
CheckTheme()
Global $theme = $ini_theme

; -Horizontal+, Vertical -up +down, HorizontalSize, VerticalSize)
#Region GUI MAIN
$GUI_MAIN = GUICreate("Timer Main", 441, 472, -1, -1)
;groups
$gPresets = GUICtrlCreateGroup("Presets", 16, 8, 409, 65, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grpCustom = GUICtrlCreateGroup("Custom Timer", 16, 296, 193, 113, BitOR($GUI_SS_DEFAULT_GROUP,$BS_LEFT))
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grpInt = GUICtrlCreateGroup("Intervals", 224, 296, 201, 113, BitOR($GUI_SS_DEFAULT_GROUP,$BS_LEFT))
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grpTimerControls = GUICtrlCreateGroup("Timer Controls", 16, 200, 409, 89, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;interval
$labIntApplied = GUICtrlCreateLabel("Interval:", 28, 225, 42, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$labIntIndicator = GUICtrlCreateLabel("OFF", 75, 225, 30, 17)
GUICtrlSetFont(-1, 10, 900, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUICtrlSetColor($labIntIndicator, $COLOR_RED)
;labels
$time = GUICtrlCreateLabel("00:00:00", 50, 100, 350, 75, $ES_CENTER)
GUICtrlSetFont(-1, 50, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$timeInt = GUICtrlCreateLabel("00:00:00", 50, 100, 350, 75, $ES_CENTER)
GUICtrlSetFont(-1, 50, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUICtrlSetColor($timeInt, $COLOR_RED)
GUICtrlSetState($timeInt, $GUI_HIDE)
$labHrsCustom = GUICtrlCreateLabel("Hours", 34, 325, 35, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$labMinsCustom = GUICtrlCreateLabel("Minutes", 86, 325, 45, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$labSecsCustom = GUICtrlCreateLabel("Seconds", 142, 325, 50, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$labEvery = GUICtrlCreateLabel("Every...", 248, 329, 40, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$labMinsInt = GUICtrlCreateLabel("Minutes", 311, 312, 43, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$labSecsInt = GUICtrlCreateLabel("Seconds", 358, 312, 50, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$labTimeFor = GUICtrlCreateLabel("Pause For...", 236, 352, 80, 17)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
;buttons
$b5 = GUICtrlCreateButton("5 Mins", 32, 32, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$b10 = GUICtrlCreateButton("10 Mins", 96, 32, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$b15 = GUICtrlCreateButton("15 Mins", 160, 32, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$b20 = GUICtrlCreateButton("20 Mins", 224, 32, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$b25 = GUICtrlCreateButton("25 Mins", 288, 32, 59, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$b30 = GUICtrlCreateButton("30 Mins", 352, 32, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butCustom = GUICtrlCreateButton("Set Custom Time", 32, 376, 153, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butApplyInterval = GUICtrlCreateButton("Apply Interval", 232, 376, 89, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butRemoveInterval = GUICtrlCreateButton("Remove Interval", 321, 376, 100, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butExit = GUICtrlCreateButton("Exit", 328, 416, 97, 41)
GUICtrlSetFont(-1, 11, 600, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butSounds = GUICtrlCreateButton("Sounds", 224, 416, 97, 41)
GUICtrlSetFont(-1, 11, 600, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butDonate = GUICtrlCreateButton("Donate", 16, 416, 97, 41)
GUICtrlSetFont(-1, 11, 600, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butReset = GUICtrlCreateButton("Reset", 336, 220, 81, 57)
GUICtrlSetFont(-1, 12, 600, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butStart = GUICtrlCreateButton("Start Timer", 112, 220, 217, 57)
GUICtrlSetFont(-1, 16, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$butPause = GUICtrlCreateButton("Pause Timer", 112, 220, 217, 57)
GUICtrlSetFont(-1, 16, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUICtrlSetState($butPause, $GUI_HIDE)
$butThemes = GUICtrlCreateButton("Themes", 120, 416, 97, 41)
GUICtrlSetFont(-1, 11, 600, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
;inputs
$iHrs = GUICtrlCreateInput($ini_customhours, 32, 344, 41, 21, BitOR($ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit(-1, 3, 0)
$iMins = GUICtrlCreateInput($ini_custommins, 88, 344, 41, 21, BitOR($ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit(-1, 2, 0)
$iSecs = GUICtrlCreateInput($ini_customsecs, 144, 344, 41, 21, BitOR($ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit(-1, 2, 0)
$iEveryMins = GUICtrlCreateInput($ini_inteverymins, 312, 328, 41, 21, BitOR($ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit(-1, 2, 0)
$iEverySecs = GUICtrlCreateInput($ini_inteverysecs, 360, 328, 41, 21, BitOR($ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit(-1, 2, 0)
$iPauseForMins = GUICtrlCreateInput($ini_intpausemins, 312, 352, 41, 21, BitOR($ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit(-1, 2, 0)
$iPauseForSecs = GUICtrlCreateInput($ini_intpausesecs, 360, 352, 41, 21, BitOR($ES_CENTER, $ES_NUMBER))
GUICtrlSetLimit(-1, 2, 0)
;checkbox
$checkAuto = GUICtrlCreateCheckbox("Auto-start", 29, 250, 72, 30, $BS_RIGHTBUTTON)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
If $ini_autostart = 1 Then ;1=checked, 4=unchecked
   GUICtrlSetState($checkAuto, $GUI_CHECKED)
Else
   GUICtrlSetState($checkAuto, $GUI_UNCHECKED)
EndIf
GUISetState(@SW_SHOW)
#EndRegion GUI

GUISetBkColor($BGColor)

#Region GUI Sounds
$GUI_SOUNDS = GUICreate("Sounds", 508, 241, -1, -1)
;labels
$slabTimerStart = GUICtrlCreateLabel("Timer Start", 15, 18, 80, 17)
GUICtrlSetFont(-1, 10, 800, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$slabTimerEnd = GUICtrlCreateLabel("Timer End", 20, 58, 80, 17)
GUICtrlSetFont(-1, 10, 800, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$slabIntStart = GUICtrlCreateLabel("Interval Start", 8, 98, 100, 17)
GUICtrlSetFont(-1, 10, 800, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$slabIntEnd = GUICtrlCreateLabel("Interval End", 10, 138, 95, 17)
GUICtrlSetFont(-1, 10, 800, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$slabTip = GUICtrlCreateLabel("Leave field clear to disable" & @CRLF & "sounds for the event.", 120, 180, 259, 40, $SS_CENTER)
GUICtrlSetFont(-1, 11, 500, $GUI_FONTITALIC, "", $CLEARTYPE_QUALITY)
;inputs
$iTimerStart = GUICtrlCreateInput($ini_timerstart, 104, 17, 250, 21)
$iTimerEnd = GUICtrlCreateInput($ini_timerend, 104, 57, 250, 21)
$iIntStart = GUICtrlCreateInput($ini_intstart, 104, 97, 250, 21)
$iIntEnd = GUICtrlCreateInput($ini_intend, 104, 137, 250, 21)
;buttons
$sbutTimerStartBrowse = GUICtrlCreateButton("Browse...", 361, 16, 65, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutTimerEndBrowse = GUICtrlCreateButton("Browse...", 361, 56, 65, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutIntStartBrowse = GUICtrlCreateButton("Browse...", 361, 96, 65, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutIntEndBrowse = GUICtrlCreateButton("Browse...", 361, 136, 65, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutTimerStartClr = GUICtrlCreateButton("Clear", 433, 16, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutTimerEndClr = GUICtrlCreateButton("Clear", 433, 56, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutIntStartClr = GUICtrlCreateButton("Clear", 433, 96, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutIntEndClr = GUICtrlCreateButton("Clear", 433, 136, 57, 25)
GUICtrlSetFont(-1, 9, 500, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutClose = GUICtrlCreateButton("Save + Close", 378, 176, 113, 49)
GUICtrlSetFont(-1, 10, 600, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
$sbutDefault = GUICtrlCreateButton("Defaults", 16, 176, 113, 49)
GUICtrlSetFont(-1, 10, 600, $GUI_FONTNORMAL, "", $CLEARTYPE_QUALITY)
GUISetState(@SW_HIDE)
#EndRegion Sounds

#Region GUI Themes
$GUI_THEMES = GUICreate("Themes", 240, 350, -1, -1)
;button
$butColorClose = GUICtrlCreateButton("Save + Close", 125, 308, 100, 33)
$butColorApply = GUICtrlCreateButton("Apply", 20, 308, 100, 33)
;custom
$radCustom = GUICtrlCreateRadio("Custom", 16, 265, 90, 17)
$eCust1 = GUICtrlCreateEdit("", 112, 256, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
$eCust2 = GUICtrlCreateEdit("", 152, 256, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
$eCust3 = GUICtrlCreateEdit("", 192, 256, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
$butCust1 = GUICtrlCreateButton("pick", 112, 277, 33, 22)
$butCust2 = GUICtrlCreateButton("pick", 152, 277, 33, 22)
$butCust3 = GUICtrlCreateButton("pick", 192, 277, 33, 22)
If $ini_custom1 OR $ini_custom2 OR $ini_custom3 Then ;if any custom colors are defined
   Global $idColor1 = $ini_custom1
   Global $idColor2 = $ini_custom2
   Global $idColor3 = $ini_custom3
   GUICtrlSetBkColor($eCust1, $idColor1)
   GUICtrlSetBkColor($eCust2, $idColor2)
   GUICtrlSetBkColor($eCust3, $idColor3)
EndIf
;default
$radDefault = GUICtrlCreateRadio("Default", 16, 16, 90, 17)
$eDef1 = GUICtrlCreateEdit("", 112, 16, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xf0f0f0)
$eDef2 = GUICtrlCreateEdit("", 152, 16, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xe1e1e1)
$eDef3 = GUICtrlCreateEdit("", 192, 16, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xffffff)
;graytan
$radGrayTan = GUICtrlCreateRadio("Gray + Tan", 16, 40, 90, 17)
$eGT1 = GUICtrlCreateEdit("", 112, 40, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xbac1ca)
$eGT2 = GUICtrlCreateEdit("", 152, 40, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xd8d4c1)
$eGT3 = GUICtrlCreateEdit("", 192, 40, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xf3f0e2)
;lavender
$radLavender = GUICtrlCreateRadio("Lavender", 16, 64, 90, 17)
$eLav1 = GUICtrlCreateEdit("", 112, 64, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xdcc9f0)
$eLav2 = GUICtrlCreateEdit("", 152, 64, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xeee5f7)
$eLav3 = GUICtrlCreateEdit("", 192, 64, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xf3eef8)
;forest
$radForest = GUICtrlCreateRadio("Forest", 16, 88, 90, 17)
$eFor1 = GUICtrlCreateEdit("", 112, 88, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xd3eed6)
$eFor2 = GUICtrlCreateEdit("", 152, 88, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xeee9d3)
$eFor3 = GUICtrlCreateEdit("", 192, 88, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xedf1e2)
;bluesteel
$radBlueSteel = GUICtrlCreateRadio("Blue Steel", 16, 112, 90, 17)
$eBS1 = GUICtrlCreateEdit("", 112, 112, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xdbe0ee)
$eBS2 = GUICtrlCreateEdit("", 152, 112, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xd7d7d7)
$eBS3 = GUICtrlCreateEdit("", 192, 112, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xe4e8f0)
;inquest
$radInquest = GUICtrlCreateRadio("Inquest", 16, 136, 90, 17)
$eInq1 = GUICtrlCreateEdit("", 112, 136, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xeecece)
$eInq2 = GUICtrlCreateEdit("", 152, 136, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xc1c1c1)
$eInq3 = GUICtrlCreateEdit("", 192, 136, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xe9e2e2)
;oceansky
$radOceanSky = GUICtrlCreateRadio("Ocean Sky", 16, 160, 90, 17)
$eOc1 = GUICtrlCreateEdit("", 112, 160, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0x91dcff)
$eOc2 = GUICtrlCreateEdit("", 152, 160, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xccefff)
$eOc3 = GUICtrlCreateEdit("", 192, 160, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xe5f6fd)
;rose
$radRose = GUICtrlCreateRadio("Roses", 16, 184, 90, 17)
$eRo1 = GUICtrlCreateEdit("", 112, 184, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xf7dbef)
$eRo2 = GUICtrlCreateEdit("", 152, 184, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xfeeffa)
$eRo3 = GUICtrlCreateEdit("", 192, 184, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xfffafe)
;dawn
$radDawn = GUICtrlCreateRadio("Dawn", 16, 208, 90, 17)
$eDa1 = GUICtrlCreateEdit("", 112, 208, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xf7ebdb)
$eDa2 = GUICtrlCreateEdit("", 152, 208, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xf7f4db)
$eDa3 = GUICtrlCreateEdit("", 192, 208, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xfffdf1)
;neon
$radNeon = GUICtrlCreateRadio("Neon", 16, 232, 90, 17)
$eNe1 = GUICtrlCreateEdit("", 112, 232, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xff91f4)
$eNe2 = GUICtrlCreateEdit("", 152, 232, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0x91ffbb)
$eNe3 = GUICtrlCreateEdit("", 192, 232, 33, 17, BitOR($ES_CENTER, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xfffca3)
#EndRegion GUI Colors

ApplyStyle()

#Region Main Loop
While 1
   $nMsg = GUIGetMsg()
   Switch $nMsg
   Case $GUI_EVENT_CLOSE
	  ini_write()
	  If WinActive("Sounds") Then
		 GUISetState(@SW_HIDE, $GUI_SOUNDS)
	  ElseIf WinActive("Themes") Then
		 GUISetState(@SW_HIDE, $GUI_THEMES)
	  Else
		 Exit
	  EndIf
	  Case $butExit ;main gui cases
		 ini_write()
		 Terminate()
	  Case $butPause
		 If $intTimerOn = True Then $secondsInt = 0
		 Pause()
	  Case $butReset
		 Pause()
		 Reset()
	  Case $b5
		 PopPreset(5)
	  Case $b10
		 PopPreset(10)
	  Case $b15
		 PopPreset(15)
	  Case $b20
		 PopPreset(20)
	  Case $b25
		 PopPreset(25)
	  Case $b30
		 PopPreset(30)
	  Case $butCustom
		 Populate()
	  Case $butStart
		 If $seconds = 0 Then
			sleep(10)
		 Else
			Start()
		 EndIf
	  Case $butApplyInterval
		 ApplyInterval()
	  Case $butRemoveInterval
		 RemoveInterval()
	  Case $butSounds
		 GUISetState(@SW_SHOW, $GUI_SOUNDS)
	  Case $butDonate
		 If MsgBox($MB_SYSTEMMODAL + $MB_YESNO + $MB_ICONINFORMATION, "Open Browser request", "Click Yes to allow this program to open a URL in your default browser.") = 6 Then
			ShellExecute("https://www.paypal.com/donate?hosted_button_id=LZHSKZXSWD4QA")
		 EndIf
	  Case $butThemes
		 ThemeConfig()
		 GUISetState(@SW_SHOW, $GUI_THEMES)
	  Case $sbutTimerStartBrowse ;sound cases
		 $TimerStartFile = FileOpenDialog("Choose a sound", @WindowsDir & "\", "WAV Audio Files (*.wav)", $FD_FILEMUSTEXIST)
		 _GUICtrlEdit_SetText($iTimerStart, $TimerStartFile)
		 ini_write()
	  Case $sbutTimerEndBrowse
		 $TimerEndFile = FileOpenDialog("Choose a sound", @WindowsDir & "\", "WAV Audio Files (*.wav)", $FD_FILEMUSTEXIST)
		 _GUICtrlEdit_SetText($iTimerEnd, $TimerEndFile)
		 ini_write()
	  Case $sbutIntStartBrowse
		 $IntStartFile = FileOpenDialog("Choose a sound", @WindowsDir & "\", "WAV Audio Files (*.wav)", $FD_FILEMUSTEXIST)
		 _GUICtrlEdit_SetText($iIntStart, $IntStartFile)
		 ini_write()
	  Case $sbutIntEndBrowse
		 $IntEndFile = FileOpenDialog("Choose a sound", @WindowsDir & "\", "WAV Audio Files (*.wav)", $FD_FILEMUSTEXIST)
		 _GUICtrlEdit_SetText($iIntEnd, $IntEndFile)
		 ini_write()
	  Case $sbutTimerStartClr
		 GUICtrlSetData($iTimerStart, "")
	  Case $sbutTimerEndClr
		 GUICtrlSetData($iTimerEnd, "")
	  Case $sbutIntStartClr
		 GUICtrlSetData($iIntStart, "")
	  Case $sbutIntEndClr
		 GUICtrlSetData($iIntEnd, "")
	  Case $sbutDefault
		 GUICtrlSetData($iTimerStart, $sound1)
		 GUICtrlSetData($iTimerEnd, $sound2)
		 GUICtrlSetData($iIntStart, $sound3)
		 GUICtrlSetData($iIntEnd, $sound4)
	  Case $sbutClose
		 ini_write()
		 GUISetState(@SW_HIDE, $GUI_SOUNDS)
	  Case $radDefault ;theme cases
		 Global $theme = "Default"
		 ini_write()
	  Case $radRose
		 Global $theme = "roses"
		 ini_write()
	  Case $radGrayTan
		 Global $theme = "grayandtan"
		 ini_write()
	  Case $radLavender
		 Global $theme = "lavender"
		 ini_write()
	  Case $radForest
		 Global $theme = "forest"
		 ini_write()
	  Case $radBlueSteel
		 Global $theme = "bluesteel"
		 ini_write()
	  Case $radInquest
		 Global $theme = "inquest"
		 ini_write()
	  Case $radOceanSky
		 Global $theme = "oceansky"
		 ini_write()
	  Case $radDawn
		 Global $theme = "dawn"
		 ini_write()
	  Case $radNeon
		 Global $theme = "neon"
		 ini_write()
	  Case $radCustom
		 Global $theme = "custom"
		 ini_write()
	  Case $butColorApply
		 ThemePop()
		 ApplyStyle()
	  Case $butColorClose
		 ThemePop()
		 ApplyStyle()
		 ini_write()
		 GUISetState(@SW_HIDE, $GUI_THEMES)
	  Case $butCust1
		 Global $idColor1 = _ChooseColor(2, 0xffffff, 2, $GUI_THEMES)
		 GUICtrlSetBkColor($eCust1, $idColor1)
		 ini_write()
	  Case $butCust2
		 Global $idColor2 = _ChooseColor(2, 0xffffff, 2, $GUI_THEMES)
		 GUICtrlSetBkColor($eCust2, $idColor2)
		 ini_write()
	  Case $butCust3
		 Global $idColor3 = _ChooseColor(2, 0xffffff, 2, $GUI_THEMES)
		 GUICtrlSetBkColor($eCust3, $idColor3)
		 ini_write()
	  EndSwitch

   If $intBool = True Then
	  Global $diff = Mod($elapsed,$intEvery)
   EndIf
 WEnd
 #EndRegion Main Loop

#Region Timer Functions
Func Populate()
   $hourz = GUICtrlRead($iHrs)
   $minutez = GUICtrlRead($iMins)
   $secondz = GUICtrlRead($iSecs)
   Global $secInHrs = $hourz * 3600
   Global $secInMins = $minutez * 60
   Global $seconds = $secInHrs + $secInMins + $secondz
   PopTimer()
   If GUICtrlRead($checkAuto) = 1 Then Start()
   EndFunc

Func PopTimer()
   Local $sec, $min, $hr
   $sec = Mod($seconds, 60)
   $min = Mod($seconds / 60, 60)
   $hr = Floor($seconds / 60 ^ 2)
   GUICtrlSetData($time, StringFormat("%02i:%02i:%02i", $hr, $min, $sec))
EndFunc

Func PopPreset($n)
   Local $hourz, $secondz
   $minutez = $n
   Global $secInHrs = $hourz * 3600
   Global $secInMins = $minutez * 60
   Global $seconds = $secInHrs + $secInMins + $secondz
   GUICtrlSetData($time, StringFormat("%02i:%02i:%02i", $hr, $min, $sec))
   PopTimer()
   If GUICtrlRead($checkAuto) = 1 Then Start()
EndFunc

Func Countdown()
   Global $TimerOn = True
   Local $sec, $min, $hr
   $sec = Mod($seconds, 60)
   $min = Mod($seconds / 60, 60)
   $hr = Floor($seconds / 60 ^ 2)
   GUICtrlSetData($time, StringFormat("%02i:%02i:%02i", $hr, $min, $sec))
   $seconds -= 1
   $elapsed += 1
   If $seconds <= 0 Then $seconds = 0
   If $seconds <= 0 Then
	  AdlibUnRegister("Countdown")
   EndIf
   ;begin int logic
   If $intBool = True Then
	  If $seconds >= 0 And $elapsed >=1 and $elapsed-1 = $intEvery Then
		 $elapsed = 0
		 $TimerOn = False
		 AdlibUnregister("Countdown")
		 GUICtrlSetState($time, $GUI_HIDE)
		 PopInt()
		 IntCountdown()
		 AdlibRegister("IntCountdown", 1000)
		 GUICtrlSetState($timeInt, $GUI_SHOW)
		 sndIntStart()
	  EndIf
   EndIf
EndFunc
;int
Func IntCountdown()
   Global $intTimerOn = True
   Global $secInt, $minInt, $hrInt
   $secInt = Mod($secondsInt, 60)
   $minInt = Mod($secondsInt / 60, 60)
   $hrInt = Floor($secondsInt / 60 ^ 2)
   GUICtrlSetData($timeInt, StringFormat("%02i:%02i:%02i", $hrInt, $minInt, $secInt))
   $secondsInt -= 1
;~    If $intTimerOn = False Then
;~ 	  AdlibUnregister("IntCountdown")
;~ 	  GUICtrlSetState($timeInt, $GUI_HIDE)
;~ 	  PopTimer()
;~ 	  Countdown()
;~ 	  AdlibRegister("Countdown", 1000)
;~ 	  GUICtrlSetState($time, $GUI_SHOW)
;~    EndIf
   If $secondsInt <= -1 Then
	  $intTimerOn = False
	  sndIntEnd()
	  AdlibUnregister("IntCountdown")
	  GUICtrlSetState($timeInt, $GUI_HIDE)
	  $seconds += 1
	  PopTimer()
	  Countdown()
	  AdlibRegister("Countdown", 1000)
	  GUICtrlSetState($time, $GUI_SHOW)
   EndIf
EndFunc

Func ApplyInterval()
   $intBool = True
   GUICtrlSetData($labIntIndicator, "ON")
   GUICtrlSetColor($labIntIndicator, $COLOR_GREEN)
   Global $intPause = GUICtrlRead($iPauseForMins) * 60 + GUICtrlRead($iPauseForSecs)
   Global $intEvery = GUICtrlRead($iEveryMins) * 60 + GUICtrlRead($iEverySecs)
   PopInt()
EndFunc

Func RemoveInterval()
   $intBool = False
   GUICtrlSetColor($labIntIndicator, $COLOR_RED)
   GUICtrlSetData($labIntIndicator, "OFF")
EndFunc

Func PopInt()
   $minsInt = GUICtrlRead($iPauseForMins)
   $secsInt = GUICtrlRead($iPauseForSecs)
   Global $secInMinsInt = $minsInt * 60
   Global $secondsInt = $secInMinsInt + $secsInt
   $secInt = Mod($secondsInt, 60)
   $minInt = Mod($secondsInt / 60, 60)
   $hrInt = Floor($secondsInt / 60 ^ 2)
   GUICtrlSetData($timeInt, StringFormat("%02i:%02i:%02i", $hrInt, $minInt, $secInt))
EndFunc

Func Start()
   ButtonToggle($GUI_DISABLE)
   sndTimerStart()
   If $intTimerOn = True Then
	  IntCountdown()
	  AdlibRegister("IntCountdown", 1000)
   Else
	  Countdown()
	  AdlibRegister("Countdown", 1000)
   EndIf
   GUICtrlSetState($butStart, $GUI_HIDE)
   GUICtrlSetState($butPause, $GUI_SHOW)
EndFunc

Func Pause()
   AdlibUnregister("IntCountdown")
   AdlibUnRegister("Countdown")
   ButtonToggle($GUI_ENABLE)
   GUICtrlSetState($butPause, $GUI_HIDE)
   GUICtrlSetState($butStart, $GUI_SHOW)
EndFunc

Func Reset()
   $intTimerOn = False
   Pause()
   Global $seconds = 0
   Global $elapsed = 0
   Global $secondsInt = 0
   Global $secInt = 0
   Global $minInt = 0
   Global $hrInt = 0
   Global $sec = 0
   Global $min = 0
   Global $hr = 0
   GUICtrlSetState($timeInt, $GUI_HIDE)
   GUICtrlSetState($time, $GUI_SHOW)
   GUICtrlSetData($time, StringFormat("%02i:%02i:%02i", 0, 0, 0))
EndFunc

Func ButtonToggle($t)
   GUICtrlSetState($butReset, $t)
   GUICtrlSetState($b5, $t)
   GUICtrlSetState($b10, $t)
   GUICtrlSetState($b15, $t)
   GUICtrlSetState($b20, $t)
   GUICtrlSetState($b25, $t)
   GUICtrlSetState($b30, $t)
   GUICtrlSetState($butApplyInterval, $t)
   GUICtrlSetState($butRemoveInterval, $t)
   GUICtrlSetState($butCustom, $t)
EndFunc

Func Terminate()
   Exit 11
EndFunc
#EndRegion Timer Functions

#Region Theme Functions
Func ThemeConfig()
   If $ini_theme = "" Then GUICtrlSetState($radDefault, $GUI_CHECKED)
   If $ini_theme = "default" Then GUICtrlSetState($radDefault, $GUI_CHECKED)
   If $ini_theme = "grayandtan" Then GUICtrlSetState($radGrayTan, $GUI_CHECKED)
   If $ini_theme = "lavender" Then GUICtrlSetState($radLavender, $GUI_CHECKED)
   If $ini_theme = "forest" Then GUICtrlSetState($radForest, $GUI_CHECKED)
   If $ini_theme = "bluesteel" Then GUICtrlSetState($radBlueSteel, $GUI_CHECKED)
   If $ini_theme = "inquest" Then GUICtrlSetState($radInquest, $GUI_CHECKED)
   If $ini_theme = "neon" Then GUICtrlSetState($radGNeon, $GUI_CHECKED)
   If $ini_theme = "oceansky" Then GUICtrlSetState($radOceanSky, $GUI_CHECKED)
   If $ini_theme = "roses" Then GUICtrlSetState($radRoses, $GUI_CHECKED)
   If $ini_theme = "dawn" Then GUICtrlSetState($radDawn, $GUI_CHECKED)
   If $ini_theme = "custom" Then GUICtrlSetState($radCustom, $GUI_CHECKED)
EndFunc

Func CheckTheme()
   If $ini_theme = "custom" Then
	  Global $idColor1 = $ini_custom1
	  Global $idColor2 = $ini_custom2
	  Global $idColor3 = $ini_custom3
   EndIf
EndFunc

Func ThemePop()
   ini_read()
   If $ini_theme = "grayandtan" Then
	  Global $BGColor = 0xbac1ca
	  Global $ButtonColor = 0xd8d4c1
	  Global $InputColor = 0xf3f0e2
   ElseIf $ini_theme = "lavender" Then
	  Global $BGColor = 0xdcc9f0
	  Global $ButtonColor = 0xeee5f7
	  Global $InputColor = 0xf3eef8
   ElseIf $ini_theme = "forest" Then
	  Global $BGColor = 0xd3eed6
	  Global $ButtonColor = 0xeee9d3
	  Global $InputColor = 0xedf1e2
   ElseIf $ini_theme = "bluesteel" Then
	  Global $BGColor = 0xdbe0ee
	  Global $ButtonColor = 0xd7d7d7
	  Global $InputColor = 0xe4e8f0
   ElseIf $ini_theme = "inquest" Then
	  Global $BGColor = 0xeecece
	  Global $ButtonColor = 0xc1c1c1
	  Global $InputColor = 0xe9e2e2
   ElseIf $ini_theme = "neon" Then
	  Global $BGColor = 0xff91f4
	  Global $ButtonColor = 0x91ffbb
	  Global $InputColor = 0xfffca3
   ElseIf $ini_theme = "oceansky" Then
	  Global $BGColor = 0x91dcff
	  Global $ButtonColor = 0xccefff
	  Global $InputColor = 0xe5f6fd
   ElseIf $ini_theme = "roses" Then
	  Global $BGColor = 0xfeeffa
	  Global $ButtonColor = 0xf7dbef
	  Global $InputColor = 0xfffafe
   ElseIf $ini_theme = "dawn" Then
	  Global $BGColor = 0xf7ebdb
	  Global $ButtonColor = 0xf7f4db
	  Global $InputColor = 0xfffdf1
   ElseIf $ini_theme = "custom" Then
	  Global $BGColor = $ini_custom1
	  Global $ButtonColor = $ini_custom2
	  Global $InputColor = $ini_custom3
   Else
	  Global $BGColor = 0xf0f0f0
	  Global $ButtonColor = 0xe1e1e1
	  Global $InputColor = 0xffffff
   EndIf
EndFunc

Func ApplyStyle()
   GUISetBkColor($BGColor)
   GUISetBkColor($BGColor, $GUI_MAIN)
   GUISetBkColor($BGColor, $GUI_SOUNDS)
   GUISetBkColor($BGColor, $GUI_THEMES)
   ;buttons
   GUICtrlSetBkColor($b5, $ButtonColor)
   GUICtrlSetBkColor($b10, $ButtonColor)
   GUICtrlSetBkColor($b15, $ButtonColor)
   GUICtrlSetBkColor($b20, $ButtonColor)
   GUICtrlSetBkColor($b25, $ButtonColor)
   GUICtrlSetBkColor($b30, $ButtonColor)
   GUICtrlSetBkColor($butCustom, $ButtonColor)
   GUICtrlSetBkColor($butApplyInterval, $ButtonColor)
   GUICtrlSetBkColor($butRemoveInterval, $ButtonColor)
   GUICtrlSetBkColor($butExit, $ButtonColor)
   GUICtrlSetBkColor($butSounds, $ButtonColor)
   GUICtrlSetBkColor($butDonate, $ButtonColor)
   GUICtrlSetBkColor($butReset, $ButtonColor)
   GUICtrlSetBkColor($butStart, $ButtonColor)
   GUICtrlSetBkColor($butPause, $ButtonColor)
   GUICtrlSetBkColor($butThemes, $ButtonColor)
   GUICtrlSetBkColor($butColorClose, $ButtonColor)
   GUICtrlSetBkColor($butColorApply, $ButtonColor)
   ;inputs
   GUICtrlSetBkColor($iHrs, $InputColor)
   GUICtrlSetBkColor($iMins, $InputColor)
   GUICtrlSetBkColor($iSecs, $InputColor)
   GUICtrlSetBkColor($iPauseForMins, $InputColor)
   GUICtrlSetBkColor($iPauseForSecs, $InputColor)
   GUICtrlSetBkColor($iEveryMins, $InputColor)
   GUICtrlSetBkColor($iEverySecs, $InputColor)
   GUICtrlSetBkColor($iTimerStart, $InputColor)
   GUICtrlSetBkColor($iTimerEnd, $InputColor)
   GUICtrlSetBkColor($iIntStart, $InputColor)
   GUICtrlSetBkColor($iIntEnd, $InputColor)
   ;soundGUI
   GUICtrlSetBkColor($sbutTimerStartBrowse, $ButtonColor)
   GUICtrlSetBkColor($sbutTimerStartBrowse, $ButtonColor)
   GUICtrlSetBkColor($sbutTimerEndBrowse, $ButtonColor)
   GUICtrlSetBkColor($sbutIntStartBrowse, $ButtonColor)
   GUICtrlSetBkColor($sbutIntEndBrowse, $ButtonColor)
   GUICtrlSetBkColor($sbutTimerStartClr, $ButtonColor)
   GUICtrlSetBkColor($sbutTimerEndClr, $ButtonColor)
   GUICtrlSetBkColor($sbutIntStartClr, $ButtonColor)
   GUICtrlSetBkColor($sbutIntEndClr, $ButtonColor)
   GUICtrlSetBkColor($sbutClose, $ButtonColor)
   GUICtrlSetBkColor($sbutDefault, $ButtonColor)
EndFunc
#EndRegion Theme Functions

#Region ini Functions
Func ini_read()
   Global $search = FileFindFirstFile(@ScriptDir & "\settings.ini")
   Global $sFileName = FileFindNextFile($search)
	  If $search = -1 Then
		 MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Error", "settings.ini not found" & @CRLF & "If you are not running this directly from the program folder, try creating a shortcut instead." & @CRLF & @CRLF & "CODE: 111")
		 Exit 111
	  EndIf
   Global $ini_autostart = IniRead($sFileName, "settings", "autostart", "Default")
   Global $ini_customhours = IniRead($sFileName, "timevals", "customhours", "Default")
   Global $ini_custommins = IniRead($sFileName, "timevals", "custommins", "Default")
   Global $ini_customsecs = IniRead($sFileName, "timevals", "customsecs", "Default")
   Global $ini_inteverymins = IniRead($sFileName, "timevals", "inteverymins", "Default")
   Global $ini_inteverysecs = IniRead($sFileName, "timevals", "inteverysecs", "Default")
   Global $ini_intpausemins = IniRead($sFileName, "timevals", "intpausemins", "Default")
   Global $ini_intpausesecs = IniRead($sFileName, "timevals", "intpausesecs", "Default")
   Global $ini_timerstart = IniRead($sFileName, "sounds", "timerstart", "Default")
   Global $ini_timerend = IniRead($sFileName, "sounds", "timerend", "Default")
   Global $ini_intstart = IniRead($sFileName, "sounds", "intstart", "Default")
   Global $ini_intend = IniRead($sFileName, "sounds", "intend", "Default")
   Global $ini_theme = IniRead($sFileName, "themes", "theme", "Default")
   Global $ini_custom1 = IniRead($sFileName, "themes", "custom1", "Default")
   Global $ini_custom2 = IniRead($sFileName, "themes", "custom2", "Default")
   Global $ini_custom3 = IniRead($sFileName, "themes", "custom3", "Default")
EndFunc

Func ini_write()
   IniWrite(@ScriptDir & "\settings.ini", "settings", "autostart", GUICtrlRead($checkAuto))
   IniWrite(@ScriptDir & "\settings.ini", "timevals", "customhours", GUICtrlRead($iHrs))
   IniWrite(@ScriptDir & "\settings.ini", "timevals", "custommins", GUICtrlRead($iMins))
   IniWrite(@ScriptDir & "\settings.ini", "timevals", "customsecs", GUICtrlRead($iSecs))
   IniWrite(@ScriptDir & "\settings.ini", "timevals", "inteverymins", GUICtrlRead($iEveryMins))
   IniWrite(@ScriptDir & "\settings.ini", "timevals", "inteverysecs", GUICtrlRead($iEverySecs))
   IniWrite(@ScriptDir & "\settings.ini", "timevals", "intpausemins", GUICtrlRead($iPauseForMins))
   IniWrite(@ScriptDir & "\settings.ini", "timevals", "intpausesecs", GUICtrlRead($iPauseForSecs))
   IniWrite(@ScriptDir & "\settings.ini", "sounds", "timerstart", GUICtrlRead($iTimerStart))
   IniWrite(@ScriptDir & "\settings.ini", "sounds", "timerend", GUICtrlRead($iTimerEnd))
   IniWrite(@ScriptDir & "\settings.ini", "sounds", "intstart", GUICtrlRead($iIntStart))
   IniWrite(@ScriptDir & "\settings.ini", "sounds", "intend", GUICtrlRead($iIntEnd))
   IniWrite(@ScriptDir & "\settings.ini", "themes", "theme", $theme)
   IniWrite(@ScriptDir & "\settings.ini", "themes", "custom1", $idColor1)
   IniWrite(@ScriptDir & "\settings.ini", "themes", "custom2", $idColor2)
   IniWrite(@ScriptDir & "\settings.ini", "themes", "custom3", $idColor3)
EndFunc
#EndRegion ini Functions

#Region Sound Functions
Func sndTimerStart()
   SoundPlay(GUICtrlRead($iTimerStart))
EndFunc

Func sndTimerEnd()
   SoundPlay(GUICtrlRead($iTimerEnd))
EndFunc

Func sndIntStart()
   SoundPlay(GUICtrlRead($iIntStart))
EndFunc

Func sndIntEnd()
   SoundPlay(GUICtrlRead($iIntEnd))
EndFunc
#EndRegion Sound Functions

#Region ErrorCodes
;CODE 111 = ini not found, not being ran from program folder
#EndRegion ErrorCodes