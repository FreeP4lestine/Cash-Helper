ColorGradient(proportion,color*){
	color_R := []
	color_G := []
	color_B := []
	colors := color.length()
	
	loop, %colors%{
		color_R[A_index] := ((color[A_index]  & 0xFF0000) >> 16)
		color_G[A_index] := ((color[A_index]  & 0xFF00) >> 8)
		color_B[A_index] := (color[A_index]  & 0xFF)
	}
	
	if proportion >= 1
	{
		r := color_R[colors]
		g := color_G[colors]
		b := color_B[colors]
	}
	else
	{
		segments := colors-1
		segment := floor(proportion*segments)+1
		subsegment := ((proportion*segments)-segment+1)
		
		r := round((subsegment * (color_R[segment+1]-color_R[segment]))+color_R[segment])
		g := round((subsegment * (color_G[segment+1]-color_G[segment]))+color_G[segment])
		b := round((subsegment * (color_B[segment+1]-color_B[segment]))+color_B[segment])
	}
	
	hex:=format("0x{1:02x}{2:02x}{3:02x}", r, g, b)
	return hex
}