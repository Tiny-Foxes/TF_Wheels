return Def.ActorFrame{ 
	NoneCommand=function(self)
		self:stoptweening():zoom(.75):linear(.12):zoom(1)
	end,
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Tap Note' ),
		InitCommand=function(self)
			self:diffusetopedge(.5,.5,.5,1)
		end,		
		GameplayLeadInChangedMessageCommand=function(self)
			if not GAMESTATE:GetGameplayLeadIn() then
				self:effectclock("beat")
					:glowblink()
					:effectcolor1(.4,.4,.4,.4)
					:effectcolor2(.8,.8,.8,.8)
					:effecttiming(.2,0,.8,0)
			end
		end
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Note Outline ' ),
		InitCommand=function(self)
			self:visible(false)
		end,
		GameplayLeadInChangedMessageCommand=function(self)
			self:visible(not GAMESTATE:GetGameplayLeadIn())
		end
	}	
}
