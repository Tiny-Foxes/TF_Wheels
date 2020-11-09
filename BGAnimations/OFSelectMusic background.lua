-- Random BG Colour
return Def.Quad {
	OnCommand=function(self) self:Center():zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):diffuse(math.random()/4,math.random()/4,math.random()/4,1) end
}