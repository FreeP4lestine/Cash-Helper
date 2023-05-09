#Requires AutoHotkey v1.1.36.02
#SingleInstance, Force
SetBatchLines, -1
#NoEnv
SetWorkingDir, % A_ScriptDir
WM_USER := 0x00000400
PBM_SETMARQUEE := WM_USER + 10
PBS_MARQUEE := 0x00000008
Gui, Add, Progress, w300 h20 hwndMARQ1 +%PBS_MARQUEE% -Smooth
Gui, Add, Text, vPr wp Center
DllCall("User32.dll\SendMessage", "Ptr", MARQ1, "Int", PBM_SETMARQUEE, "Ptr", 1, "Ptr", 50)
Gui, Show,, Updating...
If DllCall("Wininet.dll\InternetGetConnectedState", "Str", 0x40, "Int", 0) {
	Try {
		GuiControl,, Pr, Getting latest version...
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", "https://raw.githubusercontent.com/FreeP4lestine/Cash-Helper/main/Version.txt", True)
		whr.Send()
		whr.WaitForResponse()
		LV := whr.ResponseText
	} Catch e {
		Msgbox, 48, % "CONTACTING GITHUB SERVER ERROR", % "IT SEEMS LIKE YOU ARE CONNECTED TO THE INTERNET BUT COULD NOT GET THE APPLICATION LATEST VERSION!"
		If (A_OSVersion != "WIN_7")
			ExitApp
		Msgbox, 65, % "HOTFIX", % "FOR WINDOWS 7 USERS, IF YOU ARE ALREADY CONNECTED TO THE INTERNET THEN ENABLING THE SECURE PROTOCOLS TLS 1.1 AND TLS 1.2 SHOULD FIX THAT, GIVE IT A TRY?"
		IfMsgBox, OK
		{
			RunWait, secure\MicrosoftEasyFix51044.msi
			If (A_Is64bitOS)
				RunWait, secure\TLS 1.1_TLS 1.2_x64.msu
			Else
				RunWait, secure\TLS 1.1_TLS 1.2_x86.msu
		}
		ExitApp
	}
	GuiControl,, Pr, Getting update v%LV% ready...
	Try {
		Whr.Option(WinHttpRequestOption_EnableRedirects := 6) := False
		Whr.Open("GET", "https://github.com/FreeP4lestine/Cash-Helper/releases/download/v" LV "/Update.zip", False)
		Whr.Send()
		directUrl := Whr.GetResponseHeader("Location")
		Req := ComObjCreate("Msxml2.XMLHTTP.6.0")
		Req.Open("GET", directUrl, False)
		Req.Send()
		Arr := Req.responseBody
		pData := NumGet(ComObjValue(Arr) + 8 + A_PtrSize)
		len := Arr.MaxIndex() + 1
		FileOpen("update\update.zip", "w").RawWrite(pData + 0, len)
		GuiControl,, Pr, Applying update v%LV%...
		FileCopyDir, update\update.zip, %A_ScriptDir%, 1
	} Catch e {
		Msgbox, 48, % "ERROR", % "THERE WAS AN ERROR WHILE TRYING TO WRITE THE UPDATE v" LV "!"
	}
	Run, % "StartUp." SubStr(A_ScriptName, -2)
}

GuiClose:
ExitApp