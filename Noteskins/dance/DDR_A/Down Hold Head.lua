local Active = string.find(Var "Element", "Active") ~= nil

return Def.ActorFrame{
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Note Top' ),
		InitCommand=function(self)
			self:SetAllStateDelays(0)
		end
	}, 
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Tap Note' ),
		InitCommand=function(self) 
			self:diffuse(1,1,0,1):diffusetopedge(0,1,0,1)
		end
	},
	Def.Sprite {
		Texture=NOTESKIN:GetPath( '_Down', 'Note Top' ),
		InitCommand=function(self)
			self:SetAllStateDelays(0)
            if not Active then
                self:setstate(1)
            end
		end
	}
}