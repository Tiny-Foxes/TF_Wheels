local Colour = Var "Color"

local Colours = {
	["4th"]	= 80,
	["8th"] = 0,
	["12th"] = -80,
	["16th"] = -80,
	["24th"] = -80,
	["32nd"] = -80,
	["48th"] = -80,
	["64th"] = -80,
	["192nd"] = -80
}

return Def.ActorFrame{ 
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Tap Note' ),
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Mask' ),
		InitCommand=function(self)
			self:MaskSource(true) 
		end
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Scroll' ),
		InitCommand=function(self) 
			self:y(Colours[Colour])
				:set_use_effect_clock_for_texcoords(true)
				:effectclock("beat")
				:texcoordvelocity(0,-1)
				:MaskDest()
		end
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Note Top' ),
		InitCommand=function(self)
			self:set_use_effect_clock_for_texcoords(true)
				:effectclock("beat")
				:SetAllStateDelays(.25)
		end
	},
	Def.Quad {
		InitCommand=function(self)
			self:MaskSource(true)
				:MaskDest()
		end
	}
}