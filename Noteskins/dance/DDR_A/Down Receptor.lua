return Def.ActorFrame{ 
	NoneCommand=function(self)
		self:stoptweening():zoom(.75):linear(.12):zoom(1)
	end,
	Def.ActorFrame{
		InitCommand=function(self)
			self:diffuse(.5,.5,.5,.4)
		end,
		GameplayLeadInChangedMessageCommand=function(self)
			if not GAMESTATE:GetGameplayLeadIn() then
				self:diffusealpha(1)
					:effectclock("beat")
					:diffuseblink()
					:effectcolor1(.5,.5,.5,.75)
					:effectcolor2(1,1,1,1)
					:effecttiming(.2,0,.8,0)
			end
		end,
		Def.Sprite {
			Texture=NOTESKIN:GetPath( '_Down', 'Tap Note' ),
			InitCommand=function(self)
				self:diffusetopedge(.5,.5,.5,1)
			end
		}
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Note Outline ' ),
		InitCommand=function(self)
			self:diffuse(0,0,0,1)
		end,
		GameplayLeadInChangedMessageCommand=function(self)
			if not GAMESTATE:GetGameplayLeadIn() then
				self:diffuse(1,1,1,1)
			end
		end
	}	
}
