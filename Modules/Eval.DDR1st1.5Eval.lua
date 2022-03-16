local function GetStats(stat)
	return STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetHighScore():GetTapNoteScore(stat)
end

local function GetScore()
	return TF_WHEEL.DDR1stScore[PLAYER_1]
end

local function GetAllNotes()
	return GetStats('TapNoteScore_W1')+
	GetStats('TapNoteScore_W2')+
	GetStats('TapNoteScore_W3')+
	GetStats('TapNoteScore_W4')+
	GetStats('TapNoteScore_W5')+
	GetStats('TapNoteScore_Miss')
end

local function GetPercent(stat)
	return (GetStats(stat) / GetAllNotes())*100
end

return function()
	return Def.ActorFrame{
		OnCommand=function(self)
			self:CenterX():zoom(SCREEN_HEIGHT/480)

			SCREENMAN:GetTopScreen():AddInputCallback(TF_WHEEL.Input(self))
		end,

		BackCommand=function(self)
			SCREENMAN:GetTopScreen():SetNextScreenName("ScreenGameplay"):StartTransitioningScreen("SM_GoToNextScreen")
		end,

		StartCommand=function(self)
			SCREENMAN:GetTopScreen():SetNextScreenName("OFSelectMusic"):StartTransitioningScreen("SM_GoToNextScreen")
		end,

		Def.BitmapText{
			Font="_noto sans 40px",
			Text="DANCE LEVEL",
			OnCommand=function(self)
				self:zoom(1.25)
					:y(40)
					:diffuse(color("#4D4DFF"))
					:diffusebottomedge(color("#ADD8E6"))
					:strokecolor(1,1,1,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text=string.format("%03d",GetStats('TapNoteScore_W1')+GetStats('TapNoteScore_W2')).."\n".. -- W1 and W2 are the same in DDR 1st.
			string.format("%03d",GetStats('TapNoteScore_W3')).."\n"..
			string.format("%03d",GetStats('TapNoteScore_W4')).."\n"..
			string.format("%03d",GetStats('TapNoteScore_W5')).."\n"..
			string.format("%03d",GetStats('TapNoteScore_Miss')),
			OnCommand=function(self) 
				self:halign(0)
					:valign(0)
					:xy(-180,70)
					:zoom(.7)
					:vertspacing(8)
					:diffuse(color("#FF69B4"))
					:strokecolor(1,1,0,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text=string.format("%03d",STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetHighScore():GetMaxCombo()),
			OnCommand=function(self) 
				self:halign(0)
					:valign(0)
					:xy(-180,220)
					:zoom(.7)
					:vertspacing(8)
					:diffuse(color("#FF69B4"))
					:strokecolor(1,1,0,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text=string.format("%01.1f",GetPercent('TapNoteScore_W1')+GetPercent('TapNoteScore_W2')).."%\n".. -- W1 and W2 are the same in DDR 1st.
			string.format("%01.1f",GetPercent('TapNoteScore_W3')).."%\n"..
			string.format("%01.1f",GetPercent('TapNoteScore_W4')).."%\n"..
			string.format("%01.1f",GetPercent('TapNoteScore_W5')).."%\n"..
			string.format("%01.1f",GetPercent('TapNoteScore_Miss')).."%",
			OnCommand=function(self) 
				self:halign(1)
					:valign(0)
					:xy(-200,74)
					:zoom(.47)
					:vertspacing(28)
					:diffuse(color("#FFFF00"))
					:strokecolor(0,0,1,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text="PERFECT\nGREAT\nGOOD\nBOO\nMISS",
			OnCommand=function(self) 
				self:valign(0)
					:y(70)
					:zoom(.7)
					:vertspacing(8)
					:diffuse(color("#FF69B4"))
					:strokecolor(1,1,0,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text="MAX COMBO\n\nRANK",
			OnCommand=function(self) 
				self:valign(0)
					:y(220)
					:zoom(.6)
					:vertspacing(8)
					:diffuse(color("#FF69B4"))
					:strokecolor(1,1,0,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text="D",
			OnCommand=function(self)
				self:valign(0)
					:xy(-180,260)
					:zoom(2.5)
					:diffuse(1,0,0,1)
					:strokecolor(1,0,0,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text="STAGE  SCORE\n\nTOTAL  SCORE",
			OnCommand=function(self) 
				self:valign(0)
					:y(356)
					:zoom(.6)
					:vertspacing(8)
					:diffuse(color("#FFFF00"))
					:strokecolor(0,0,1,1)
			end
		},
		Def.BitmapText{
			Font="_noto sans 40px",
			Text=string.format("%09d",GetScore()).."\n000000000",
			OnCommand=function(self) 
				self:halign(1)
					:valign(0)
					:xy(-100,360)
					:zoom(.8)
					:vertspacing(28)
					:diffuse(color("#FF69B4"))
					:strokecolor(1,1,0,1)
			end
		}
	}
end