local Colour = Var "Color"

local Colours = {
	["4th"]	= "4th",
	["8th"] = "8th",
	["12th"] = "12th",
	["16th"] = "16th",
	["24th"] = "12th",
	["32nd"] = "12th",
	["48th"] = "12th",
	["64th"] = "12th",
	["192nd"] = "12th"
}

local InsideColours = {
	["4th"]	= "#ff7885",
	["8th"] = "#787fff",
	["12th"] = "#88ff78",
	["16th"] = "#b8a800",
	["24th"] = "#88ff78",
	["32nd"] = "#88ff78",
	["48th"] = "#88ff78",
	["64th"] = "#88ff78",
	["192nd"] = "#88ff78"
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
				:diffuse(color(InsideColours[Colour]))

		end
	},
	Def.Quad {
		InitCommand=function(self)
			self:MaskSource(true)
				:MaskDest()
		end
	}
}