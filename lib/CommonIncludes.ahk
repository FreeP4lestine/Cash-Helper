#Requires AutoHotkey v1.1.36.02
#SingleInstance, Force
#Include, <Class\CtlColors>
#Include, <Class\ImageButton>
#Include, <Class\GDIplus>
#Include, <Class\Gif>
#Include, <Func\Gdip_All>
#Include, <Func\Eval>
#Include, <Func\ColorGradient>
#NoEnv
SetBatchLines, -1
SetWorkingDir, % A_ScriptDir
DetectHiddenWindows, On
SetTitleMatchMode, 2
LangLoad()
ThemeApply(Hwnd, Theme) {
	FileRead, Style, % Theme
	Return ImageButton.Create(Hwnd, Eval(StrReplace(StrReplace(Style, "`r"), "`n"))[1]*)
}
AppVersion() {
	FileRead, Version, Version.txt
	Return Version
}
PushBtnSetFocus(HGUI, HBTN) {
   SendMessage, 0x0028, HBTN, 1, , ahk_id %HGUI%
}
FolderExist(Folder) {
    Return InStr(FileExist(Folder), "D")
}
B64Encode(String) {
	VarSetCapacity(bin, StrPut(String, "UTF-8")) && len := StrPut(String, &bin, "UTF-8") - 1 
	if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x1, "ptr", 0, "uint*", size))
		throw Exception("CryptBinaryToString failed", -1)
	VarSetCapacity(buf, size << 1, 0)
	if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x1, "ptr", &buf, "uint*", size))
		throw Exception("CryptBinaryToString failed", -1)
	return StrGet(&buf)
}
B64Decode(String) {
	if !(DllCall("crypt32\CryptStringToBinary", "ptr", &String, "uint", 0, "uint", 0x1, "ptr", 0, "uint*", size, "ptr", 0, "ptr", 0))
		throw Exception("CryptStringToBinary failed", -1)
	VarSetCapacity(buf, size, 0)
	if !(DllCall("crypt32\CryptStringToBinary", "ptr", &String, "uint", 0, "uint", 0x1, "ptr", &buf, "uint*", size, "ptr", 0, "ptr", 0))
		throw Exception("CryptStringToBinary failed", -1)
	return StrGet(&buf, size, "UTF-8")
}
LangLoad() {
	Global
	FileRead, Strings, Language.txt
	Loop, Parse, Strings, `n, `r
	{
		Pair	:= StrSplit(A_LoopField, "=")
		Index	:= Pair[1]
		Value	:= Pair[2]
		s%Index% := Value
	}
}
Send_Msg(Msg, Target) {
	SendMessage, 0xC2, 0, &Msg,, % Target
}
ALogVerif() {
	Global s13, s244
	OnMessage(0xC2, "Recieved_Msg")
	If !A_Args.Length() {
		Msgbox, 48, % s13, % s244, 5
		ExitApp
	}
	Arg := StrSplit(A_Args[1], "|")
	If (Arg[1] == "START")
		Result := Send_Msg("REQUEST_ACCESS|" Main "|" A_ScriptName, "ahk_id " Arg[2])
}
ConvertMillimsToDT(Value, Sign := "", Enclose := True) {
    If (Value = "..." || !Value)
        Return
    ValueArr := StrSplit(Value / 1000, ".")
	Pre := (Sign ? Sign " " : "") ValueArr[1] (ValueArr[2] ? "." RTrim(ValueArr[2], 0) : "")
    Return, Enclose ? "[" Pre " DT]" : Pre " DT"
}
SetExplorerTheme(HCTL) {
    If (DllCall("GetVersion", "UChar") > 5) {
        VarSetCapacity(ClassName, 1024, 0)
        If DllCall("GetClassName", "Ptr", HCTL, "Str", ClassName, "Int", 512, "Int") {
            Return !DllCall("UxTheme.dll\SetWindowTheme", "Ptr", HCTL, "WStr", "Explorer", "Ptr", 0)
        }
    }
    Return False
}
SetEditCueBanner(HWND, Cue) {
   Static EM_SETCUEBANNER := (0x1500 + 1)
   Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}