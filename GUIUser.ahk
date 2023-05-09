#Include, <CommonIncludes>
ALogVerif()
Return

Recieved_Msg(wParam, lParam) {
	Global s239
    RM := StrSplit(Strget(lParam), "|")
	If (RM[1] == "ACCEPT_REQUEST") {
		AppLaunch()
	}
}

AppLaunch() {
	Try {
		UserLoad()
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
	Gui, +HwndMain
	Gui, Margin, 10, 10
	Gui, Color, 0xD8D8AD
	Gui, Font, s12 Bold, Consolas
	Gui, Add, Text, w250 Center, % s156
	Gui, Font, s10
	Gui, Add, Button, HwndHCtrl w120 h20 gAddUser, % s89
	ThemeApply(HCtrl, "style\AddUser_ImageButton.txt")
	
	Gui, Add, Button, HwndHCtrl xp+130 yp wp h20 gRemUser, % s91
	ThemeApply(HCtrl, "style\RemUser_ImageButton.txt")
	
	Gui, Font, s12
	Gui, Add, ListBox, xp-130 yp+25 w250 r26 HwndHCtrl vUserNm gShowMeUser
	CtlColors.Attach(HCtrl, "D8D8AD", "804000")
	
	Gui, Font, s11
	Gui, Add, Pic, xm+331 ym BackgroundTrans vUserPic gSelectPic, Img\UserLogo.png
	Gui, Add, Text, xp-61 yp+150, %s87%
	Gui, Add, Edit, vUserName w250 -E0x200 Border cGreen gUserNameUpt
	Gui, Add, Text,, %s88%
	Gui, Add, Edit, vPassword w250 -E0x200 Border cRed gPassWordUpt
	Gui, Add, Text,, %s207%
	Gui, Add, DDL, vLevel w250 gEDAuth, %s212%|%s213%

	Gui, Add, Text, cRed, %s215%
	AccessEdit := False
	IniRead, Cores, cores.ini
	ATH := []
	Loop, Parse, Cores, `n, `r
	{
		IniRead, Name, cores.ini, % A_LoopField, Name
		Gui, Add, CheckBox, v%A_LoopField% w250 gAccessUpt, % %Name%
		ATH.Push(A_LoopField)
	}
	
	Gui, Add, Button, HwndHCtrl xp+50 yp+35 w150 h30 gUserSave, % s62
	ThemeApply(HCtrl, "style\Login_ImageButton.txt")
	Gui, Font
	Gui, Add, StatusBar,, % s1 " v" AppVersion() " (AHK)"
	Gui, Show,, %s239%
}

GuiClose() {
	ExitApp
}

UserLoad() {
	Global UsersDB
	UsersDB := {}, UsersDB.Count := 0
	If !FileExist("sets\Acc.chu") {
		Return
	}
	UsersDB.Headers := ["Pass", "Level", "Access", "Thumb"]
	FileRead, Registers, sets\Acc.chu
	Registers := StrSplit(B64Decode(Registers), ",")
	For Every, Register in Registers {
		RegisterInfo := StrSplit(Register, "|")
		If (Username := RegisterInfo.RemoveAt(1)) {
			UsersDB[Username] := {}
			For Each, Data in RegisterInfo {
				UsersDB[Username][UsersDB.Headers[Each]] := Data
			}
			If (UsersDB[Username]["Pass"]) {
				++UsersDB.Count
			}
		}
	}
}

UserSave() {
	Global UsersDB
	UserData := ""
	For User, Header in UsersDB {
		If !(User ~= "Count|Headers") {
			HeaderData := ""
			For Each, Hdr in UsersDB.Headers {
				HeaderData .= HeaderData && UsersDB[User][Hdr] != "" ? "|" UsersDB[User][Hdr] : UsersDB[User][Hdr]
			}
			UserData .= UserData ? "," User "|" HeaderData : User "|" HeaderData
		}
	}
	FileOpen("sets\Acc.chu", "w").Write(B64Encode(UserData)).Close()
}

UserNameUpt() {
	Global UsersDB
	GuiControlGet, UserNm
	GuiControlGet, UserName
	If (UserNm = "" || UserName = "" || UsersDB.HasKey(UserName))
		Return
	UsersDB[UserName] := UsersDB[UserNm]
	UsersDB.Delete(UserNm)
	If FileExist("img\Users\" UserNm ".png")
		FileMove, % "img\Users\" UserNm ".png", % "img\Users\" UserName ".png"
	GuiCharg()
	GuiControl, ChooseString, UserNm, % UserName
}

PassWordUpt() {
	Global UsersDB
	GuiControlGet, UserNm
	GuiControlGet, Password
	If (UserNm = "" || Password = "")
		Return
	UsersDB[UserNm]["Pass"] := Password
}

LevelUpt() {
	Global UsersDB
	GuiControlGet, UserNm
	If (UserNm = "")
		Return
	GuiControlGet, Level
	UsersDB[UserNm]["Level"] := Level
}

AccessUpt() {
	Global UsersDB, ATH
	GuiControlGet, UserNm
	If (UserNm = "")
		Return
	UsersDB[UserNm]["Access"] := ""
	For Each, Auth in ATH {
		GuiControlGet, AuthV,, % Auth
		If (AuthV)
			UsersDB[UserNm]["Access"] .= UsersDB[UserNm]["Access"] ? ";" Auth : Auth
	}
}

GuiCharg() {
	Global UsersDB
	If (!UsersDB.Count)
		Return
	GuiControl,, UserNm, |
	For User, Info in UsersDB {
		If (User != "Headers") && (User != "Count")
		GuiControl,, UserNm, %User%
	}
}

ShowMeUser() {
	Global
	GuiControlGet, UserNm
	If (UserNm != "") {
		GuiControl,, UserPic, % FileExist("img\Users\" UserNm ".png") ? "img\Users\" UserNm ".png" : "img\UserLogo.png"
		GuiControl,, UserName, % UserNm
		GuiControl,, PassWord, % UsersDB[UserNm]["Pass"]
		GuiControl, ChooseString, Level, % UsersDB[UserNm]["Level"]
		For Each, Auth in ATH {
			GuiControl,, % Auth, 0
		}
		If (UsersDB[UserNm]["Level"] = s212) {
			For Each, Auth in ATH {
				GuiControl,, % Auth, 1
			}
		}
		If (UsersDB[UserNm]["Level"] = s213) {
			GuiControl, Enabled, Access
			For Each, Auth in StrSplit(UsersDB[UserNm]["Access"], ";") {
				GuiControl,, % Auth, 1
			}
		}
	}
}

EDAuth() {
	Global
	GuiControlGet, UserNm
	If (UserNm = "")
		Return
	GuiControlGet, Level
	If (Level = s212) {
		GuiControl, Disabled, Access
		For Each, Auth in ATH {
			GuiControl,, % Auth, 1
		}
		UsersDB[UserNm]["Level"] := s212
		UsersDB[UserNm]["Access"] := "Full"
	}
	If (Level = s213) {
		GuiControl, Enabled, Access
		For Each, Auth in ATH {
			GuiControl,, % Auth, 0
		}
		GuiControlGet, UserNm
		For Each, Auth in StrSplit(UsersDB[UserNm]["Access"], ";") {
			GuiControl,, % Auth, 1
		}
		UsersDB[UserNm]["Level"] := s213
	}
}

SelectPic() {
	Global
	GuiControlGet, UserNm
	If (UserNm = "")
		Return
	FileSelectFile, UserPic, 1,, %s242%, %s214% (*.jpeg; *.jpg; *.png; *.gif; *.tiff; *.tif)
	If (UserPic) {
		pToken := Gdip_Startup()
		pUserPic := Gdip_CreateBitmapFromFile(UserPic)
		Gdip_GetImageDimensions(pUserPic, IW, IH)
		IW > IH ? ResConImg(UserPic, 128,, UserNm, ".png", "img\Users") : ResConImg(UserPic,, 128, UserNm, ".png", "img\Users")
		Gdip_Shutdown(pToken)
		GuiControl,, UserPic, % "img\Users\" UserNm ".png"
	}
}

RemUser() {
	Global
    GuiControlGet, UserNm
	If (UserNm = "")
		Return
	If (UsersDB.Count = 1) {
		Msgbox, 49, % s243, % s224
		IfMsgBox, OK
		{
			UsersDB.Delete(UserNm)
		}
		GuiCharg()
		Return
	}
	UsersDB.Delete(UserNm)
	--UsersDB.Count
	GuiCharg()
}

AddUser() {
	Global
	InputBox, AUserName, % s87, % s87,, 300, 130
    InputBox, APassword, % s88, % s88,, 300, 130
	If (AUserName != "") 
	&& (APassword != "") 
	&& (!UsersDB.HasKey(AUserName)) {
        UsersDB[AUserName] := {"Pass" : APassword, "Level" : s213, "Access" : ATH[1]}
        GuiCharg()
    } Else {
        Msgbox, 16, % s13, % s225
    }
}

ResConImg(OriginalFile, NewWidth:="", NewHeight:="", NewName:="", NewExt:="", NewDir:="", PreserveAspectRatio:=true, BitDepth:=24) {
    SplitPath, OriginalFile, SplitFileName, SplitDir, SplitExtension, SplitNameNoExt, SplitDrive
    pBitmapFile := Gdip_CreateBitmapFromFile(OriginalFile)                  ; Get the bitmap of the original file
    Width := Gdip_GetImageWidth(pBitmapFile)                                ; Original width
    Height := Gdip_GetImageHeight(pBitmapFile)                              ; Original height
    NewWidth := NewWidth ? NewWidth : Width
    NewHeight := NewHeight ? NewHeight : Height
    NewExt := NewExt ? NewExt : SplitExtension
    if SubStr(NewExt, 1, 1) != "."                                          ; Add the "." to the extension if required
        NewExt := "." NewExt
    NewPath := ((NewDir != "") ? NewDir : SplitDir)                         ; NewPath := Directory
            . "\" ((NewName != "") ? NewName : "Resized_" SplitNameNoExt)	; \File name
            . NewExt														; .Extension
    if (PreserveAspectRatio) {                                              ; Recalcultate NewWidth/NewHeight if required
        if ((r1 := Width / NewWidth) > (r2 := Height / NewHeight))          ; NewWidth/NewHeight will be treated as max width/height
            NewHeight := Height / r1
        else
            NewWidth := Width / r2
    }
    pBitmap := Gdip_CreateBitmap(128, 128                        			; Create a new bitmap
    , (SubStr(NewExt, -2) = "bmp" && BitDepth = 24) ? 0x21808 : 0x26200A)   ; .bmp files use a bit depth of 24 by default
    G := Gdip_GraphicsFromImage(pBitmap)                                    ; Get a pointer to the graphics of the bitmap
    Gdip_SetSmoothingMode(G, 4)                                             ; Quality settings
    Gdip_SetInterpolationMode(G, 7)
	Gdip_DrawImage(G, pBitmapFile, (128 - NewWidth) // 2, (128 - NewHeight) // 2, NewWidth, NewHeight) ; Draw the original image onto the new bitmap
    Gdip_DisposeImage(pBitmapFile)                                          ; Delete the bitmap of the original image
    Gdip_SaveBitmapToFile(pBitmap, NewPath)                                 ; Save the new bitmap to file
    Gdip_DisposeImage(pBitmap)                                              ; Delete the new bitmap
    Gdip_DeleteGraphics(G)                                                  ; The graphics may now be deleted
}