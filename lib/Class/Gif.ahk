Class Gif
{   
   __New(file, hwnd, cycle := true)
   {
      this.file := file
      this.hwnd := hwnd
      this.cycle := cycle
      this.pBitmap := Gdip_CreateBitmapFromFile(this.file)
      Gdip_GetImageDimensions(this.pBitmap, width, height)
      this.width := width, this.height := height
      this.isPlaying := false
      
      DllCall("Gdiplus\GdipImageGetFrameDimensionsCount", "ptr", this.pBitmap, "uptr*", frameDimensions)
      this.SetCapacity("dimensionIDs", 16*frameDimensions)
      DllCall("Gdiplus\GdipImageGetFrameDimensionsList", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int", frameDimensions)
      DllCall("Gdiplus\GdipImageGetFrameCount", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int*", count)
      this.frameCount := count
      this.frameCurrent := -1
      this.frameDelay := this.GetFrameDelay(this.pBitmap)
      this._Play("")
   }

   ; Return a zero-based array, containing the frames delay (in milliseconds)
   GetFrameDelay(pImage) {
      static PropertyTagFrameDelay := 0x5100

      DllCall("Gdiplus\GdipGetPropertyItemSize", "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt*", ItemSize)
      VarSetCapacity(Item, ItemSize, 0)
      DllCall("Gdiplus\GdipGetPropertyItem"    , "Ptr", pImage, "UInt", PropertyTagFrameDelay, "UInt", ItemSize, "Ptr", &Item)

      PropLen := NumGet(Item, 4, "UInt")
      PropVal := NumGet(Item, 8 + A_PtrSize, "UPtr")

      outArray := []
      Loop, % PropLen//4 {
         if !n := NumGet(PropVal+0, (A_Index-1)*4, "UInt")
            n := 10
         outArray[A_Index-1] := n * 10
      }
      return outArray
   }
   
   Play()
   {
      this.isPlaying := true
      fn := this._Play.Bind(this)
      this._fn := fn
      SetTimer, % fn, -1
   }
   
   Pause()
   {
      this.isPlaying := false
      fn := this._fn
      SetTimer, % fn, Delete
   }
   
   _Play(mode := "set")
   {
      this.frameCurrent := mod(++this.frameCurrent, this.frameCount)
      DllCall("Gdiplus\GdipImageSelectActiveFrame", "ptr", this.pBitmap, "uptr", this.GetAddress("dimensionIDs"), "int", this.frameCurrent)
      hBitmap := Gdip_CreateHBITMAPFromBitmap(this.pBitmap)
      SetImage(this.hwnd, hBitmap)
      DeleteObject(hBitmap)
      if (mode = "set" && this.frameCurrent < (this.cycle ? 0xFFFFFFFF : this.frameCount - 1)) {
         fn := this._fn
         SetTimer, % fn, % -1 * this.frameDelay[this.frameCurrent]
      }
   }
   
   __Delete()
   {
      Gdip_DisposeImage(this.pBitmap)
      Object.Delete("dimensionIDs")
   }
}