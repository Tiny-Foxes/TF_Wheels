local Colour = Var "Color"

local Colours = {
	["4th"]	= "4th",
	["8th"] = "8th",
	["12th"] = "12th",
	["16th"] = "16th",
	["24th"] = "16th",
	["32nd"] = "16th",
	["48th"] = "16th",
	["64th"] = "16th",
	["192nd"] = "16th"
}

return Def.ActorFrame{ 
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Note Top' ),
		InitCommand=function(self)
			self:SetAllStateDelays(0)
		end
	},
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
		Texture=NOTESKIN:GetPath( '_Down', 'Scroll '..Colours[Colour] ),
		InitCommand=function(self) 
			self:y(32)
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