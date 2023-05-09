#Include, <CommonIncludes>
AppLaunch()
Return

#If WinActive("ahk_id " Main)
	Enter::LogMain()
#If

AppLaunch() {
	Try { 
		LangLoad()
		UserLoad()
		GuiBuild()
		Colorize()
		LogCheck()
		UptCheck()
	} Catch e {
		Msgbox, 16, % "ERROR", % "AN ERROR OCCURED WHILE TRYING TO START UP!"
					. "`n`nFILE: " e.file
					. "`n`nLINE: " e.line
	}
}

GuiClose() {
	ExitApp
}

UserLoad() {
	Global UsersDB, RemLogin
	UsersDB := {}, UsersDB.Clean := True
	RemLogin := {}, RemLogin.Clean := True
	If !FileExist("sets\Acc.chu") {
		Return
	}
	UsersDB.Headers := ["Pass", "Level", "Thumb", "Access"]
	FileRead, Registers, sets\Acc.chu
	Registers := StrSplit(B64Decode(Registers), ",")
	For Every, Register in Registers {
		RegisterInfo := StrSplit(Register, "|")
		If (Username := RegisterInfo.RemoveAt(1)) {
			UsersDB[Username] := {}
			For Each, Data in RegisterInfo {
				UsersDB[Username][UsersDB.Headers[Each]] := Data
			}
			If (UsersDB.Clean) && (UsersDB[Username]["Pass"]) {
				UsersDB.Clean := False
			}
		}
	}
	
	If !FileExist("sets\RAcc.chu") {
		Return
	}
	FileRead, Savelog, sets\RAcc.chu
	Savelog := StrSplit(B64Decode(Savelog), "|")
	If (Savelog[1]) && (Savelog[2]) && (UsersDB[Savelog[1]]["Pass"] == Savelog[2]) {
		RemLogin.User := [Savelog[1], Savelog[2]]
		RemLogin.Clean := False
	}
}

GuiBuild() {
	Global
	Gui, % "+HwndMain +E" (WS_EX_COMPOSITED := 0x02000000) | (WS_EX_LAYERED := 0x80000) 
	Gui, Margin, 10, 10
	Gui, Color, 0xD8D8AD
	Gui, Font, s12 Bold, Consolas
	Gui, Add, Picture, HwndHGif, % "HBITMAP:" LoadPicture(Gifp := "Gif\StartUp.gif", "GDI+")
	AnimateIt(Gifp)
	Gui, Add, Pic,, img\Keys.png
	Gui, Add, Text, xm+50 yp+5 w120 Center, % UsersDB.Clean ? s92 : s87
	Gui, Add, Combobox, xp+120 yp-3 w220 vUserName
	Gui, Add, Text, xp-120 yp+35 w120 Center, % UsersDB.Clean ? s93 : s88
	Gui, Add, Edit, xp+120 yp-3 w185 vPassWord Password cRed
	Gui, Add, Picture, xp+190 yp+3 gHideShowPass vHSP BackgroundTrans, png\Hide.png
	Gui, Font, s8
	Gui, Add, CheckBox, xp-190 yp+30 vRL, % s32
	Gui, Add, Text, x0 yp+25 0x10 w430
	Gui, Add, Text, xp yp+1 0x10 wp
	Gui, Font, s12
	Gui, Add, Button, xm+125 yp+20 w150 HwndLogin vLogin gLogMain, % UsersDB.Clean ? s196 : s35
	ThemeApply(Login, "style\LogIn_ImageButton.txt")
	Gui, Font, s8 Underline
	Gui, Add, Button, xp yp+60 wp HwndHCtrl vAbout, % s232
	ThemeApply(HCtrl, "style\SubOpt_ImageButton.txt")
	Gui, Font
	Gui, Add, StatusBar,, % s1 " v" AppVersion() " (AHK)"
	Gui, Show, w420, % s35
	PushBtnSetFocus(Main, Login)
}

Colorize(On := True) {
	Global Index := 0 
		 , Increase := True
		 , Colors := [0xD8D8AD, 0x8E8E4C, 0xFFC080, 0x80FF80, 0x80C0FF, 0x0080FF, 0xD8D8AD]
	
	If (!On) {
		SetTimer, ColorizeTimer, Off
		Return
	}
	Gui, Color, % ColorGradient(Index, Colors*)
	SetTimer, ColorizeTimer, 100
}

LogCheck() {
	Global UsersDB, RemLogin
	
	If (!UsersDB.Clean) {
		For User, Data in UsersDB {
			If (User = "Clean") || (User = "Headers")
				Continue
			GuiControl,, UserName, % User
		}
	}
	If (!RemLogin.Clean) {
		GuiControl, ChooseString, UserName, % RemLogin.User[1]
		GuiControl,, PassWord, % RemLogin.User[2]
		GuiControl,, RL, 1
	}
}

UptCheck() {
	Global _16, _18
	IniRead, Check, Sets\config.ini, Update, Check
	If (!Check) {
		Return
	}
	Try {
		IniRead, LatestVer, Sets\config.ini, Update, LatestVer
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", LatestVer, True)
		whr.Send()
		whr.WaitForResponse()
		LV := whr.ResponseText
		FileRead, CV, Version.txt
		If (LV ~= "\d\.\d\.\d\.\d") && ((StrReplace(LV, ".") > StrReplace(CV, "."))) {
			Msgbox, 65, % "[" _16 " " LV "]", % "[" _16 " " LV "]`n" _18
			IfMsgBox, OK
			{
				If !FolderExist("update") {
					FileCreateDir, update
				}
				Run, % "CASH HELPER Setup." SubStr(A_ScriptName, -2) " AutoUpt"
				ExitApp
			}
		}
	}
}

LogMain() {
	Global
	GuiControlGet, UserName
	GuiControlGet, PassWord
	If (UserName = "" || PassWord = "") {
		Msgbox, 16, % s13, % s240
		Return
	}
	
	If (UsersDB.Clean) {
		FileOpen("sets\Acc.chu", "w").Write(B64Encode(UserName "|" PassWord "|ADMIN|FULL")).Close()
		UserLoad()
	}
	
	GuiControlGet, RL
	If (RL) {
		If (RemLogin.User[1] != UserName)
			FileOpen("sets\RAcc.chu", "w").Write(B64Encode(UserName "|" PassWord)).Close()
	} Else If FileExist("sets\RAcc.chu") {
		FileDelete, sets\RAcc.chu
	}
	
	If (UsersDB[UserName]["Pass"] !== PassWord) {
		Msgbox, 16, % s13, % s78
		Return
	}
	AnimateIt("", 0)
	Colorize(False)
	
	Gui, Destroy
	Gui, % "+HwndNMain +E" (WS_EX_COMPOSITED := 0x02000000) | (WS_EX_LAYERED := 0x80000) 
	Gui, Margin, 10, 10
	Gui, Color, 0xD8D8AD
	Gui, Font, s12 Bold, Consolas
	Gui, Add, Pic, w128 h128, % FileExist("img\Users\" UserName ".png") ? "img\Users\" UserName ".png" : "img\UserLogo.png"
	Gui, Add, Edit, xp+140 yp w300 h128 Center -VScroll -E0x200 Border ReadOnly HwndHCtrl, % s206 " " UserName
													. "`n`n" s207 " " UsersDB[UserName]["Level"]
													. "`n`n" (UsersDB[UserName]["Access"] ? s215 " " StrReplace(UsersDB[UserName]["Access"], ";", ", ") : "")
	CtlColors.Attach(HCtrl, "E6E6E6", "000000")
	Gui, Add, Text, x0 0x10 w470
	Gui, Add, Text, xp yp+1 0x10 wp
	
	ATH := {H : []}
	For Each, Auth in StrSplit(UsersDB[UserName]["Access"], ";")
		ATH[Auth] := ""
	Index := 0
	IniRead, Cores, cores.ini
	Loop, Parse, Cores, `n, `r
	{
		If (UsersDB[UserName]["Level"] != "ADMIN") && (!ATH.HasKey(A_LoopField))
			Continue
		IniRead, Name, cores.ini, % A_LoopField, Name
		IniRead, BtnImg, cores.ini, % A_LoopField, BtnImg

		Gui, Add, Button, % "xm+" (Mod(++Index - 1, 3) * 150) " ym+" 150 + (((Index - 1) // 3) * 120) " v" A_LoopField " w140 h90 gStartApp HwndHCtrl", % "`n`n`n" %Name% " (F" Index ")"
		ImageButton.Create(HCtrl, [ [0, BtnImg "\1.png",, 0x804000]
								,   [0, BtnImg "\2.png",, 0x0080FF]
								,   [0, BtnImg "\3.png",, 0xFF0000]
								,   [0, BtnImg "\4.png"]]*)
		Hotkey, IfWinActive, ahk_id %NMain%
		Hotkey, F%Index%, StartAppH
		ATH.H.Push(A_LoopField)
	}
	
	Gui, Add, Text, x0 0x10 w470
	Gui, Add, Text, xp yp+1 0x10 wp
	
	Gui, Add, Picture, xm+50 HwndHGif, % "HBITMAP:" LoadPicture(Gifp := "Gif\Logo.gif", "GDI+")
	AnimateIt(Gifp)
	GuiControl, Focus, % HGif
	Gui, Font
	Gui, Add, StatusBar,, % s1 " v" AppVersion() " (AHK)"
	Gui, Show, w465, % s1
	OnMessage(0xC2, "Recieved_Msg")
}

StartAppH() {
	Global ATH, NMain
	HI := SubStr(A_ThisHotkey, 2)
	IniRead, App, cores.ini, % ATH.H[HI], App
	Try {
		Name := App SubStr(A_ScriptName, -3)
		Run, % Name " START|" NMain "|" Name
	}
}

StartApp() {
	Global ATH, NMain
	IniRead, App, cores.ini, % A_GuiControl, App
	Try {
		Name := App SubStr(A_ScriptName, -3)
		Run, % Name " START|" NMain "|" Name
	}
}

Recieved_Msg(wParam, lParam) {
	Global UserName, UsersDB
	RM := StrSplit(Strget(lParam), "|")
	If (RM[1] == "REQUEST_ACCESS") {
		Send_Msg("ACCEPT_REQUEST|" UserName "|" UsersDB[UserName]["Level"], RM[3] " ahk_class AutoHotkey")
	}
}

HideShowPass() {
	Global HSP
	If (HSP := !HSP) {
		GuiControl,, HSP, png\Show.png
		GuiControl, -Password, Password
	} Else {
		GuiControl,, HSP, png\Hide.png
		GuiControl, +Password, Password
	}
}

ColorizeTimer() {
	Global Increase, Index, Colors
	Increase ? Index += 0.005 : Index -= 0.005
	Gui, Color, % C := ColorGradient(Index, Colors*)
	If (Index >= 1) || (Index <= 0) {
		Increase := !Increase
		Sleep, 5000
	}
}

AnimateIt(Gifp, Play := True) {
	Global
	If (!Play) {
		BGGif.__Delete()
		Return
	}
	pToken := Gdip_Startup()
	BGGif := new Gif(Gifp, HGif)
	BGGif.Play()
	Gdip_Shutdown(pToken)
}