-- Random BG Colour
return Def.ActorFrame {
	Def.Sprite {
		Frag = THEME:GetPathG("", "Blur.frag"),
		Texture = THEME:GetPathG("Common", "fallback background"),
		InitCommand = function(self)
			TF_WHEEL.BG = self
		end
	},
	--[[
	Def.AudioVisualizer {
		Name="AV",
		UpdateRate = 0.05,
		Amount = 68,
		OnCommand = function(self)
			self:Center():diffuse(1,1,1,.25):zoomx(SCREEN_HEIGHT/360):zoomy(20*(360/SCREEN_HEIGHT))
		end
	}
	--]]
}