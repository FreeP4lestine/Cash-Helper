#Include, <CommonIncludes>
LangLoad()
Gui, +HwndMain +Resize
Gui, Add, Pic, % "x0 y0", Img\BG.png
Gui, Margin, 10, 10
Gui, Color, 0x7D7D3A
Gui, Font, s14 Bold, Calibri

qw := ((A_ScreenWidth - 255) // 5)

Gui, Add, Text, % "xm+220 y30 vDbcT w" qw " h32 Center BackgroundTrans", % s56 ":"
Gui, Add, Text, % "xp+" qw " yp wp hp Center BackgroundTrans", % s57 ":"
Gui, Add, Text, % "xp+" qw " yp wp hp Center BackgroundTrans", % s58 ":"
Gui, Add, Text, % "xp+" qw " yp wp hp Center BackgroundTrans", % s59 ":"
Gui, Add, Text, % "xp+" qw " yp wp hp Center BackgroundTrans", % s176 ":"
Gui, Font, s15
Gui, Add, Edit, % "xp-" qw * 4 " yp+32 wp Center Border vDbc -E0x200 cBlue"
Gui, Add, Edit, % "xp+" qw " yp wp Center Border vDnm -E0x200"
Gui, Add, Edit, % "xp+" qw " yp wp Center Border vDbp -E0x200 Number cRed"
Gui, Add, Edit, % "xp+" qw " yp wp Center Border vDsp -E0x200 Number cGreen"
Gui, Add, Edit, % "xp+" qw " yp wp Center Border vDst -E0x200"

Gui, Font, s15
Gui, Add, ListView, % "xm+220 yp+75 w" qw * 5 " h" A_ScreenHeight - 280 " Grid vLV2 HwndHCtrl gEdit BackgroundE6E6E6", % s63 "|" s38 "|" s40 "|" s39 "|" s118

LV_ModifyCol(1, qw)
LV_ModifyCol(2, qw)
LV_ModifyCol(3, qw)
LV_ModifyCol(4, qw)
LV_ModifyCol(5, qw)

Gui, Font, s17
Gui, Add, Edit, % "xp+" qw*3 " yp+" A_ScreenHeight - 275 " w" qw*2 " Center vStockSum -E0x200 HwndHCtrl Border"
CtlColors.Attach(HCtrl, "EAEAB5")

ButtonTheme := [[3, 0x80FF80, 0x5ABB5A, 0x000000, 2,, 0x008000, 1]
              , [3, 0x44DB44, 0x2F982F, 0x000000, 2,, 0x008000, 1]
              , [3, 0x1AB81A, 0x107410, 0x000000, 2,, 0x008000, 1]
              , [3, 0xCCCCCC, 0xCCCCCC, 0x000000, 2,, 0x999999, 1]]

ButtonTheme2 := [[3, 0x00E7E7, 0x02A0A0, 0x000000, 2,, 0x007E80, 1]
               , [3, 0x02CBCB, 0x028080, 0x000000, 2,, 0x007E80, 1]
               , [3, 0x03A4A4, 0x036767, 0x000000, 2,, 0x007E80, 1]
               , [3, 0xCCCCCC, 0xCCCCCC, 0x000000, 2,, 0x999999, 1]]

ButtonTheme3 := [[3, 0xFFC488, 0xBF9264, 0x000000, 2,, 0x804000, 1]
               , [3, 0xE0AB75, 0x96724E, 0x000000, 2,, 0x804000, 1]
               , [3, 0xC29465, 0x826344, 0x000000, 2,, 0x804000, 1]
               , [3, 0xCCCCCC, 0xCCCCCC, 0x000000, 2,, 0x999999, 1]]

ButtonTheme4 := [[3, 0xFF6F6F, 0xBC5454, 0x000000, 2,, 0xFF0000, 1]
               , [3, 0xDC6262, 0x9C4545, 0x000000, 2,, 0xFF0000, 1]
               , [3, 0xBF5454, 0x8A3C3C, 0x000000, 2,, 0xFF0000, 1]
               , [3, 0xCCCCCC, 0xCCCCCC, 0x000000, 2,, 0xFF0000, 1]]

Gui, Add, Text, xm+5 ym w190 Center BackgroundTrans, % s200

Gui, Font, s14
Gui, Add, Text, wp BackgroundTrans, % s208 ":"
Gui, Add, DDL, vViewMode wp AltSubmit gLoadProducts, % s209 "||" s210
Gui, Add, ListBox, % "0x100 wp r10 vGroup gDisplayGroup HwndHCtrl", % s74
CtlColors.Attach(HCtrl, "D8D8AD")
Gui, Font, s13
Gui, Add, Button, % "wp h30 gAddGroup HwndHCtrl", % s183
ImageButton.Create(HCtrl, ButtonTheme*)
                         
Gui, Add, Button, % "w190 h30 gDelGroup HwndHCtrl", % s195
ImageButton.Create(HCtrl, ButtonTheme4*)

Gui, Add, Button, % "xm+220 y100 wp h30 gEnter HwndHCtrl", % s36 " ↓"
ImageButton.Create(HCtrl, ButtonTheme*)

Gui, Add, Button, % "xp+" qw*4 + (qw - 190) " yp w190 hp gEdit HwndHCtrl", %  "↑ " s131
ImageButton.Create(HCtrl, ButtonTheme2*)

Gui, Font, Italic
Gui, Add, Button, % "xm+220 y" A_ScreenHeight - 130 " w100 h30 gFillForms HwndHCtrl", % s193
ImageButton.Create(HCtrl, ButtonTheme3*)
                         
Gui, Add, Button, % "xp+110 yp wp hp gResetAll HwndHCtrl", % s142
ImageButton.Create(HCtrl, ButtonTheme3*)
                         
Gui, Add, Button, % "xp+110 yp wp hp gDelete HwndHCtrl", % s130
ImageButton.Create(HCtrl, ButtonTheme3*)

Gui, Add, Button, % "xp+110 yp wp hp gEsc HwndHCtrl", % s169
ImageButton.Create(HCtrl, ButtonTheme3*)

Gui, Font
Gui, Font, s12 Bold, Calibri
Levels := ["Admin", "User"]
Gui, Add, StatusBar
SB_SetParts(10, 200, 200)
SB_SetText(s206 ": " AdminName, 2)
SB_SetText(s207 ": " Levels[Level], 3)

Gui, Show, Maximize, Definition GUI
ThemeAdd()
LoadGroups()
GuiControl, Choose, Group, |1
Return

#Include, GUIDefine_Labels.ahk
#Include, GUIDefine_Functions.ahk
#Include, GUIDefine_Hotkeys.ahk