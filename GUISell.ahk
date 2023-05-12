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

    Gui, Add, Text, xm ym+25 w190 BackgroundTrans Center, % s205
    Gui, Font, s14
    Gui, Add, ListBox, 0x100 wp r10 vQuickAccess gGiveDetailsQA HwndHCtrl
    CtlColors.Attach(HCtrl, "D8D8AD", "000000")

    Gui, Font, s10
    Gui, Add, Text, wp BackgroundTrans Center, % s245
    Gui, Font, s14
    Gui, Add, Edit, wp vSellItems -E0x200 ReadOnly HwndHCtrl Border, -
    CtlColors.Attach(HCtrl, "E6E6E6", "000080")
    Gui, Add, Edit, wp vSellPrice -E0x200 ReadOnly cGreen HwndHCtrl Border, -
    CtlColors.Attach(HCtrl, "239840", "FFFFFF")
    Gui, Add, Edit, wp vBuyPrice -E0x200 ReadOnly cRed HwndHCtrl Border, -
    CtlColors.Attach(HCtrl, "DD3447", "FFFFFF")
    Gui, Add, Edit, wp vMadeProfit -E0x200 ReadOnly cGreen HwndHCtrl Border, -
    CtlColors.Attach(HCtrl, "239840", "FFFFFF")

    WSlice := (A_ScreenWidth - 225) // 3
    Gui, Font, s25
    Gui, Add, Text, % "xm+210 ym w" WSlice " Center", % s246
    Gui, Font, Norm Bold
    Gui, Add, Edit, wp vCode Center -E0x200 Border cGreen gGiveDetails

    Gui, Add, Button, % "xp+" WSlice + 5 " yp vAddChart w100 hp HwndHCtrl Disabled", % "→"
    ThemeApply(HCtrl, "style\Add2Chart_ImageButton.txt")
    
    Gui, Font, s12 Italic
    Gui, Add, Text, % "xp-" (WSlice + 5) " yp+50 w" WSlice " Center", % s38
    Gui, Font, s20 Norm Bold
    Gui, Add, Edit, xp yp+25 wp vName -E0x200 ReadOnly Center HwndHCtrl Border
    CtlColors.Attach(HCtrl, "C5C585", "800000")
    Gui, Font, s12 Italic
    Gui, Add, Text, % "xp+" WSlice " yp-25 wp Center", % s6
    Gui, Font, s20 Norm Bold
    Gui, Add, Edit, xp yp+25 wp vQuan Center -E0x200 ReadOnly HwndHCtrl Border cRed
    CtlColors.Attach(HCtrl, "C5C585", "800000")
    Gui, Font, s12 Italic
    Gui, Add, Text, % "xp+" WSlice " yp-25 wp Center", % s39
    Gui, Font, s20 Norm Bold
    Gui, Add, Edit, xp yp+25 wp vSell -E0x200 ReadOnly Center HwndHCtrl Border
    CtlColors.Attach(HCtrl, "C5C585", "800000")

    Gui, Font, s16
    Gui, Add, Text, % "xm+210 yp+45 w" WSlice * 3 " h30 vSubmitSell HwndTHCtrl Center"
    CtlColors.Attach(THCtrl, "B2B2B2")

    Gui, Font, s18
    Gui, Add, ListView, % "HwndHCtrl xm+210 yp+30 w" WSlice * 3 " h" A_ScreenHeight - 380 " vListView Grid +0x4000000", % s63 "|" s61 "|" s38 "|" s68 "|" s69
    LV_ModifyCol(1, "0 Center")
    LV_ModifyCol(2, Level = s212 ? WSlice / 2 : 0)
    LV_ModifyCol(3, (Level = s212 ? WSlice / 2 : WSlice) " Center")
    LV_ModifyCol(4, WSlice " Center")
    LV_ModifyCol(5, WSlice " Center")
    
    Gui, Font, s30
    Gui, Add, Edit, % "xm+210 yp+" A_ScreenHeight - 370 " w" WSlice " vGivenMoney -E0x200 Center Border HwndHCtrl Number"
    CtlColors.Attach(HCtrl, "FFFFFF", "FF0000")

    Gui, Add, Edit, % "xp+" WSlice " yp wp vThisListSum -E0x200 ReadOnly Center Border cGreen HwndHCtrl"
    CtlColors.Attach(HCtrl, "EAEAB5", "000000")

    Gui, Add, Edit, % "xp+" WSlice " yp wp vChange -E0x200 ReadOnly Center Border cRed HwndHCtrl"
    CtlColors.Attach(HCtrl, "EAEAB5", "FF0000")

    Gui, Font, s12

    ;gSpace
    ;Gui, Add, Button, % "vAddSell xm+210 yp+40  w100 hp HwndHCtrl Disabled", % s115
    ;ThemeApply(HCtrl, "style\Add2Chart_ImageButton.txt")
;
    ;;gDelete
    ;Gui, Add, Button, % "vAddDelete xp+100 yp  HwndHCtrl wp hp Disabled", % s130
    ;ThemeApply(HCtrl, "style\RemUser_ImageButton.txt")
;
    ;;gEnter
    ;Gui, Add, Button, % "vAddSubmit xp+100 yp  w100 hp HwndHCtrl Disabled", % s168
    ;ThemeApply(HCtrl, "style\Add2Chart_ImageButton.txt")
;
    ;;gSubKridi
    ;Gui, Add, Button, % "vSubKridi xp+100 yp  HwndHCtrl wp hp Disabled", % s29
    ;ThemeApply(HCtrl, "style\Add2Chart_ImageButton.txt")
;
    ;;gEsc
    ;Gui, Add, Button, % "vCancel xp+100 yp HwndHCtrl wp hp Disabled", % s169
    ;ThemeApply(HCtrl, "style\Add2Chart_ImageButton.txt")

    Gui, Font, s15

    Loop, 15 {
        Gui, Add, Button, % "xm+" 15 + (Mod(A_Index - 1, 5) * 35) " ym+" (A_ScreenHeight - 190 + ((A_Index - 1) // 5 * 30)) " w30 h25 vSession" A_Index " HwndHCtrl", % A_Index
        ThemeApply(HCtrl, "style\Sessions_ImageButton.txt")
    }
    
    Gui, Font, s12
    Gui, Add, StatusBar
    SB_SetParts(10, 200, 200)
    Gui, Show, Maximize, %s234%
    ;Gui, Font, s12
    ;Levels := ["Admin", "User"]
    ;Gui, Add, StatusBar
    
    ;GuiControl, Disabled, Session1
    ;Selling     := 0
    ;Session     := 1
    ;If FileExist("Dump\" Session ".session") {
    ;    RestoreSession()
    ;    CalculateSum()
    ;}
    ;CheckLatestSells()
}

GuiCharg() {
    Global Definitions := LoadDefinition()
    UpdateInterfac()
}

UpdateInterfac() {
    Global UserName, Level, Definitions, QuickAccessList := {}
         , s37, s206, s207
    
    ; Status Bar
    SB_SetText(s206 " " UserName, 2), SB_SetText(s207 " " Level, 3)
    
    ; User Image
    GuiControl,, UserPic, % FileExist("img\Users\" UserName ".png") ? "img\Users\" UserName ".png" : "img\UserLogo.png"
    
    ; Quick Resume
    VSellItems := VSellPrice := VBuyPrice := VMadeProfit := 0
    Loop, Files, curr\*.sell
    {
        FileRead, Content, % A_LoopFileFullPath
        If !(Content := IsItAValidSell(Content))["Valid"]
            Continue
        For Each, One in Content["Data"] {
            GuiControl,, SellItems , % "↑ " (VSellItems += StrSplit((Data := StrSplit(One, ";"))[3], "x")[2]) " " s37
            GuiControl,, SellPrice , % ConvertMillimsToDT(VSellPrice  += Data[4], "↑", False)
            GuiControl,, BuyPrice  , % ConvertMillimsToDT(VBuyPrice   += Data[6], "↓", False)
            GuiControl,, MadeProfit, % ConvertMillimsToDT(VMadeProfit += Data[7], "↑", False)
        }
    }

    ; Last Sells
    GuiControl,, QuickAccess, |
    If FileExist("Dump\Last.sell") {
        FileRead, Codes, Dump\Last.sell
        For Each, Code in StrSplit(Codes, "`n") {
            If Definitions.HasKey("" Code "") {
                GuiControl,, QuickAccess, % Each " - " Definitions["" Code ""]["Name"]
                QuickAccessList[Each] := "" Code ""
            }
        }
    }
}

GiveDetailsQA() {
    Global QuickAccessList, Definitions
    GuiControlGet, QuickAccess
    Code := QuickAccessList[StrSplit(QuickAccess, " - ")[1]]
    If (Code != "") && Definitions.HasKey("" Code "") {
        GuiControl,, Code, % Code
    }
}

GiveDetails() {
    Global Definitions
    GuiControlGet, Code
    If (Code = "") || !Definitions.HasKey("" Code "") {
        GuiControl,, Name
        GuiControl,, Quan
        GuiControl,, Sell
        GuiControl, Disabled, AddChart
        Return
    }
    GuiControl,, Name, % Definitions["" Code ""]["Name"]
    GuiControl,, Quan, % Definitions["" Code ""]["Quantity"]
    GuiControl,, Sell, % Definitions["" Code ""]["SellPrice"]
    GuiControl, Enabled, AddChart
}

IsItAValidSell(Data) {
    Data := StrSplit(Data, "> ")
    Resume := StrSplit(Data[3], ";")
    If (!Resume[1] || !Resume[2] || !Resume[3])
        Return {"Valid" : False}
    Return {"Valid" : True, "Data" : StrSplit(Trim(Data[2], "|"), "|")}
}

LoadDefinition() {
    Definitions := {}
    Loop, Files, Sets\Def\*.Def, R
    {
        FileRead, Content, % A_LoopFileFullPath
        If ((Content := StrSplit(Content, ";")).Length() < 4)
            Continue
        Barcode := SubStr(A_LoopFileName, 1, -4)
        Definitions["" StrReplace(A_LoopFileName, ".def") ""] := { "Name"      : Content[1]
                                                                 , "BuyPrice"  : Content[2]
                                                                 , "SellPrice" : Content[3]
                                                                 , "Quantity"  : Content[4] }
    }
    Return, Definitions
}

;#Include, GUISell_Hotkeys.ahk
;#Include, GUISell_Functions.ahk
;#Include, GUISell_Labels.ahk