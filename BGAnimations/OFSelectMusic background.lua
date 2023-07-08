-- Random BG Colour
return Def.ActorFrame {
	Def.Sprite {
		Frag = THEME:GetPathG("", "Blur.frag"),
		Texture = THEME:GetPathG("", "_white"),
		InitCommand = function(self)
			TF_WHEEL.BG = self
		end
	}
}