#Include, <CommonIncludes>
LangLoad()

Gui, +HwndMain +Resize
Gui, Add, Pic, % "x0 y0", Img\BG.png
Gui, Margin, 10, 10
Gui, Color, 0x7D7D3A
Gui, Font, s14 Bold Italic, Calibri

ButtonTheme := [[3, 0x80FF80, 0x5ABB5A, 0x000000, 2,, 0x008000, 1]
              , [3, 0x44DB44, 0x2F982F, 0x000000, 2,, 0x008000, 1]
              , [3, 0x1AB81A, 0x107410, 0x000000, 2,, 0x008000, 1]
              , [3, 0xCCCCCC, 0xCCCCCC, 0x000000, 2,, 0x999999, 1]]

Gui, Font, Norm
Gui, Font, s15 Bold

qw := ((A_ScreenWidth - 255) / 4)

Gui, Add, Text, % "xm+5 ym w190 vProfByProductText BackgroundTrans", % s202 ":"
Gui, Add, DDL, xp yp+30 wp vProfByProduct gShowTheInfo AltSubmit, % s203 "||" s204

Gui, Add, Text, wp vShowTheInfo BackgroundTrans, % s156 ":"
Gui, Add, DDL, xp yp+30 wp vProfByName gShowTheInfo

Gui, Add, DateTime, w190 vBegin Center h30, yyyy/MM/dd
Gui, Add, DateTime, wp vEnd Center hp, yyyy/MM/dd

Gui, Font, Norm
Gui, Font, s13 Bold italic

Gui, Add, Button, wp gCheckTheListBox HwndHCtrl h30, % "↓ " s172
ImageButton.Create(HCtrl, ButtonTheme*)

Gui, Add, ListBox, % "0x100 wp h" A_ScreenHeight - 410 " vDates HwndHCtrl gShowTheInfo Multi"
CtlColors.Attach(HCtrl, "D8D8AD", "404000")

Gui, Font, s12
Gui, Add, Edit, % "xm+220 ym+10 w" qw*2 " vOverview -E0x200 HwndHCtrl"
CtlColors.Attach(HCtrl, "000000", "FFFF00")

Gui, Font, Norm
Gui, Font, s15 Bold
Gui, Add, Progress, % "xm+" A_ScreenWidth - 240 " yp cC3C378 vPB w200 hp", 0
Gui, Add, ListView, % "xm+220 yp+40 w" qw*4 " h" A_ScreenHeight - 200 " Grid HwndHLV -Multi BackgroundE6E6E6 gShowDetails", % s70 "|" s72 "|" s39 "|" s40 "|" s41 "|Notused"
Global HLV

LV_ModifyCol(1, 0)
LV_ModifyCol(2, qw)
LV_ModifyCol(3, qw)
LV_ModifyCol(4, qw)
LV_ModifyCol(5, qw)

Gui, Add, Edit, % "xp+" qw + 4 " yp+" A_ScreenHeight - 190 " -E0x200 ReadOnly vSPr w" qw - 4 " Border HwndHCtrl Center"
CtlColors.Attach(HCtrl, "EAEAB5", "000000")

Gui, Add, Edit, % "xp+" qw " yp -E0x200 ReadOnly vCPr wp Border HwndHCtrl Center"
CtlColors.Attach(HCtrl, "EAEAB5", "FF0000")

Gui, Add, Edit, % "xp+" qw " yp -E0x200 ReadOnly vOAProfit wp Border HwndHCtrl Center"
CtlColors.Attach(HCtrl, "EAEAB5", "008000")

Gui, Add, Button, % "xm+220 yp w" qw " hp vSinceBegin HwndHCtrl gCalculateAll", % s85 " ↑"
ImageButton.Create(HCtrl, ButtonTheme*)

Gui, Add, Button, xm+5 yp w190 gChart vChart HwndHCtrl hp, % "→ " s173 " ←"
ImageButton.Create(HCtrl, ButtonTheme*)

Gui, Font, s12
Levels := ["Admin", "User"]
View := ["Normal", "More Details"]
Gui, Add, StatusBar
SB_SetParts(10, 200, 200)
SB_SetText(s206 ": " AdminName, 2)
SB_SetText(s207 ": " Levels[Level], 3)

Gui, Show, Maximize, Review GUI
ThemeAdd()

Global LVContent, Header := 1
LoadAllSells()
AnalyzeUsers()
AnalyzeDates()
GuiControl, Choose, Dates, |1
Return

#Include, GUIReview_Hotkeys.ahk
#Include, GUIReview_Functions.ahk
#Include, GUIReview_Labels.ahk