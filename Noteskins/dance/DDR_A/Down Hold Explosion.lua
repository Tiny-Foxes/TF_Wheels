return Def.ActorFrame {
	InitCommand=function(self)
		self:diffusealpha(1)
			:effectclock("beat")
			:glowblink()
			:effectcolor1(1,1,0,.25)
			:effectcolor2(1,1,0,1)
			:effecttiming(.025,0,.025,0)
	end,
	Def.Sprite {
        Texture=NOTESKIN:GetPath( '_Down', 'Note Outline' )
    },  
    Def.Sprite {
        Texture=NOTESKIN:GetPath( '_Down', 'Mask' ),
        InitCommand=function(self)
            self:MaskSource(true) 
        end
    },
    Def.Sprite {
        Texture=NOTESKIN:GetPath( 'Down', 'Tap Explosion Dim' ),
        InitCommand=function(self)
            self:MaskDest()
        end
    },
	Def.Quad {
		InitCommand=function(self)
			self:MaskSource(true)
				:MaskDest()
		end
	}
}