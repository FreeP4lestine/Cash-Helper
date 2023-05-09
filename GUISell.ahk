#Include, <CommonIncludes>
ALogVerif()
Return

Recieved_Msg(wParam, lParam) {
	Global UserName, Level
         , s234
    RM := StrSplit(Strget(lParam), "|")
	If (RM[1] == "ACCEPT_REQUEST") {
        UserName := RM[2]
        Level := RM[3]
        AppLaunch()
	}
}

AppLaunch() {
	Try {
		LangLoad()
		GuiBuild()
        GuiCharg()
	} Catch e {
		Msgbox, 16, % "ERROR", % "AN ERROR OCCURED WHILE TRYING TO START UP!"
					. "`n`nFILE: " e.file
					. "`n`nLINE: " e.line
	}
}

GuiBuild() {
    Global
    Gui, +HwndMain +Resize
    Gui, Add, Pic, % "x" A_ScreenWidth - 120 " ym w100 h100 vUserPic"
    Gui, Margin, 10, 10
    Gui, Color, 0xD8D8AD
    Gui, Font, s10 Bold, Calibri

    Gui, Add, Text, xm ym w190 BackgroundTrans Center, % s205
    Gui, Font, s14
    Gui, Add, ListBox, 0x100 wp r10 vSearch gWriteToBc AltSubmit HwndHCtrl
    CtlColors.Attach(HCtrl, "E6E6E6", "000080")

    Gui, Font, s10
    Gui, Add, Text, wp BackgroundTrans Center, % s245
    Gui, Font, s14
    Gui, Add, Edit, % "wp vSellItems -E0x200 ReadOnly Center -VScroll HwndHCtrl Border", 0
    CtlColors.Attach(HCtrl, "E6E6E6", "000080")
    Gui, Add, Edit, % "wp vSellPrice -E0x200 ReadOnly Center -VScroll cGreen HwndHCtrl Border", 0
    CtlColors.Attach(HCtrl, "008000", "FFFFFF")
    Gui, Add, Edit, % "wp vBuyPrice -E0x200 ReadOnly Center -VScroll cRed HwndHCtrl Border", 0
    CtlColors.Attach(HCtrl, "800000", "FFFFFF")
    Gui, Add, Edit, % "wp vMadeProfit -E0x200 ReadOnly Center -VScroll cGreen HwndHCtrl Border", 0
    CtlColors.Attach(HCtrl, "008000", "FFFFFF")

    ButtonTheme := [[3, 0x80FF80, 0x5ABB5A, 0x000000, 2,, 0x008000, 1]
                  , [3, 0x44DB44, 0x2F982F, 0x000000, 2,, 0x008000, 1]
                  , [3, 0x1AB81A, 0x107410, 0x000000, 2,, 0x008000, 1]
                  , [3, 0xCCCCCC, 0xCCCCCC, 0x000000, 2,, 0x999999, 1]]

    Gui, Font, s25
    pw := (A_ScreenWidth - 235) / 3
    Gui, Add, Edit, % "x225 ym+85 w" pw " h45 vGivenMoney -E0x200 gCalc Center Border Hidden"
    CtlColors.Attach(HCtrl, "EAEAB5", "FF0000")

    Gui, Add, Edit, % "xp+" pw " yp wp h45 vAllSum -E0x200 ReadOnly Center Border cGreen Hidden HwndHCtrl"
    CtlColors.Attach(HCtrl, "EAEAB5", "000000")

    Gui, Add, Edit, % "xp+" pw " yp wp h45 vChange -E0x200 ReadOnly Center Border cRed Hidden HwndHCtrl"
    CtlColors.Attach(HCtrl, "EAEAB5", "FF0000")

    Gui, Font, s25
    Gui, Add, Edit, % "x225 y30 w" pw " -VScroll vBc Center -E0x200 gAnalyzeAvail Border HwndHCtrl "
    SetEditCueBanner(HCtrl, s201)
    Gui, Add, Button, % "xp+" pw + 5 " yp vAddEnter gEnter w80 hp HwndHCtrl Disabled", % "→"
    ImageButton.Create(HCtrl, ButtonTheme*)

    Gui, Add, Edit, % "xp-" (pw + 5) " yp+85 w" pw " vNm h45 -E0x200 ReadOnly Center HwndHCtrl Border"
    CtlColors.Attach(HCtrl, "C5C585")

    Gui, Add, Edit, % "xp+" pw " yp wp h45 vQn Center -E0x200 ReadOnly HwndHCtrl Border cRed"
    CtlColors.Attach(HCtrl, "C5C585")

    Gui, Add, Edit, % "xp+" pw " wp h45 -E0x200 ReadOnly Center HwndHCtrl Border vSum"
    CtlColors.Attach(HCtrl, "C5C585")

    Gui, Add, Button, % "vAddUp xp-" pw/2 + 50 " yp+70 gUp HwndHCtrl w50 h30 Disabled", % "+"
    ImageButton.Create(HCtrl, ButtonTheme*)

    Gui, Add, Button, % "vAddDown xp+50 yp gDown HwndHCtrl wp hp Disabled", % "-"
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Font, s16
    Gui, Add, Text, % "x225 yp w" pw - 31 " h30 vTransc HwndTHCtrl Center gViewLastTrans Hidden"
    CtlColors.Attach(THCtrl, "B2B2B2")
    Gui, Add, Pic, % "x" 225 + pw - 31 " yp w30 h30 vTranscOK  gViewLastTrans Hidden", Img\Idle.png

    Gui, Font, s18
    Gui, Add, ListView, % "HwndHCtrl x225 yp+37 w" pw*3 " h" A_ScreenHeight - 380 " vListView Grid ", % s63 "|" s61 "|" s38 "|" s68 "|" s69

    LV_ModifyCol(1, "0 Center")
    LV_ModifyCol(2, Level = 1? pw / 2 : 0)
    LV_ModifyCol(3, (Level = 1? pw / 2 : pw) " Center")
    LV_ModifyCol(4, pw " Center")
    LV_ModifyCol(5, pw " Center")

    ;Gui, Font, s15
    Gui, Add, Edit, % "xp+" pw*2 " yp-50 w" pw " vThisListSum -E0x200 ReadOnly HwndHCtrl Center"
    CtlColors.Attach(HCtrl, "D8D8AD", "FF0000")

    Gui, Font, s12

    Gui, Add, Button, % "vAddSell x225 y" A_ScreenHeight - 150 " gSpace w100 hp HwndHCtrl Disabled", % s115
    ImageButton.Create(HCtrl, ButtonTheme*)

    Gui, Add, Button, % "vAddDelete xp+100 yp gDelete HwndHCtrl wp hp Disabled", % s130
    ImageButton.Create(HCtrl, ButtonTheme* )

    Gui, Add, Button, % "vAddSubmit xp+100 yp gEnter w100 hp HwndHCtrl Disabled", % s168
    ImageButton.Create(HCtrl, ButtonTheme*)

    Gui, Add, Button, % "vSubKridi xp+100 yp gSubKridi HwndHCtrl wp hp Disabled", % s29
    ImageButton.Create(HCtrl, ButtonTheme* )

    Gui, Add, Button, % "vCancel xp+100 yp gEsc HwndHCtrl wp hp Disabled", % s169
    ImageButton.Create(HCtrl, ButtonTheme* )

    Gui, Font, s15

    Gui, Add, Button, % "xm+15 y" A_ScreenHeight - 160 " w30 h25 vSession1 HwndHCtrl gSession1 ", 1
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession2 HwndHCtrl gSession2 ", 2
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession3 HwndHCtrl gSession3 ", 3
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession4 HwndHCtrl gSession4 ", 4
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession5 HwndHCtrl gSession5 ", 5
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xm+15 yp+35 wp hp vSession6 HwndHCtrl gSession6 ", 6
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession7 HwndHCtrl gSession7 ", 7
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession8 HwndHCtrl gSession8 ", 8
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession9 HwndHCtrl gSession9 ", 9
    ImageButton.Create(HCtrl, ButtonTheme*)
    Gui, Add, Button, % "xp+35 yp wp hp vSession10 HwndHCtrl gSession10 ", 10
    ImageButton.Create(HCtrl, ButtonTheme*)
    
    Gui, Font, s12
    Levels := ["Admin", "User"]
    Gui, Add, StatusBar
    SB_SetParts(10, 200, 200)
    SB_SetText(s206 ": " AdminName, 2)
    SB_SetText(s207 ": " Levels[Level], 3)
    Gui, Show, Maximize, %s234%
    ThemeAdd()

    GuiControl, Disabled, Session1
    Selling     := 0
    ProdDefs    := LoadDefinitions()
    Session     := 1
    If FileExist("Dump\" Session ".session") {
        RestoreSession()
        CalculateSum()
    }
    CheckLatestSells()
}

GuiCharg() {
    Global UserName
         , s37
    GuiControl,, UserPic, % FileExist("img\Users\" UserName ".png") ? "img\Users\" UserName ".png" : "img\UserLogo.png"
    VSellItems := VSellPrice := VBuyPrice := VMadeProfit := 0
    Loop, Files, curr\*.sell
    {
        FileRead, Content, % A_LoopFileFullPath
        If !(Content := IsItAValidSell(Content))["Valid"]
            Continue
        For Each, One in Content["Data"] {
            GuiControl,, SellItems , % (VSellItems += StrSplit((Data := StrSplit(One, ";"))[3], "x")[2]) " " s37
            GuiControl,, SellPrice , % ConvertMillimsToDT(VSellPrice  += Data[4], "↑", False)
            GuiControl,, BuyPrice  , % ConvertMillimsToDT(VBuyPrice   += Data[6], "↓", False)
            GuiControl,, MadeProfit, % ConvertMillimsToDT(VMadeProfit += Data[7], "↑", False)
        }
    }
}

IsItAValidSell(Data) {
    Data := StrSplit(Data, "> ")
    Resume := StrSplit(Data[3], ";")
    If (!Resume[1] || !Resume[2] || !Resume[3])
        Return {"Valid" : False}
    Return {"Valid" : True, "Data" : StrSplit(Trim(Data[2], "|"), "|")}
}

#Include, GUISell_Hotkeys.ahk
#Include, GUISell_Functions.ahk
#Include, GUISell_Labels.ahk