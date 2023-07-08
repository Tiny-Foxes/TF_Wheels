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

		Def.Text{
			Font=THEME:GetPathF("","Gemsbuck01Black.ttf"),
			Text="DANCE LEVEL",
			Size=50,
			StrokeSize=3,
			OnCommand=function(self)
				self:y(50)
				
				self:MainActor()
					:diffuse(color("#4D4DFF"))
					:diffusebottomedge(color("#ADD8E6"))

				self:StrokeActor()
					:diffuse(1,1,1,1)
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","PartyConfetti-Regular.ttf"),
			Text=string.format("%03d",GetStats('TapNoteScore_W1')+GetStats('TapNoteScore_W2')).."\n".. -- W1 and W2 are the same in DDR 1st.
			string.format("%03d",GetStats('TapNoteScore_W3')).."\n"..
			string.format("%03d",GetStats('TapNoteScore_W4')).."\n"..
			string.format("%03d",GetStats('TapNoteScore_W5')).."\n"..
			string.format("%03d",GetStats('TapNoteScore_Miss')),
			Size=30,
			StrokeSize=3,
			OnCommand=function(self) 
				self:xy(-100,60)
					:halign(1)
					:vertspacing(.95)
					:Regen()

				self:MainActor()
					:valign(0)
					:halign(1)
					:diffuse(color("#FF69B4"))

				self:StrokeActor()
					:valign(0)
					:halign(1)
					:diffuse(1,1,0,1)
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","PartyConfetti-Regular.ttf"),
			Text=string.format("%03d",STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetHighScore():GetMaxCombo()),
			Size=30,
			StrokeSize=3,
			OnCommand=function(self) 
				self:xy(-100,200)
					:halign(1)
					:Regen()
				
				self:MainActor()
					:valign(0)
					:halign(1)
					:diffuse(color("#FF69B4"))

				self:StrokeActor()
					:valign(0)
					:halign(1)
					:diffuse(1,1,0,1)
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","PartyConfetti-Regular.ttf"),
			Text=string.format("%01.1f",GetPercent('TapNoteScore_W1')+GetPercent('TapNoteScore_W2')).."%\n".. -- W1 and W2 are the same in DDR 1st.
			string.format("%01.1f",GetPercent('TapNoteScore_W3')).."%\n"..
			string.format("%01.1f",GetPercent('TapNoteScore_W4')).."%\n"..
			string.format("%01.1f",GetPercent('TapNoteScore_W5')).."%\n"..
			string.format("%01.1f",GetPercent('TapNoteScore_Miss')).."%",
			Size=20,
			StrokeSize=3,
			OnCommand=function(self) 
				self:xy(-180,64)
					:halign(1)
					:vertspacing(1.4)
					:Regen()

				self:MainActor()
					:valign(0)
					:halign(1)
					:diffuse(color("#FFFF00"))

				self:StrokeActor()
					:valign(0)
					:halign(1)
					:diffuse(0,0,1,1)
					
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","PartyConfetti-Regular.ttf"),
			Text="PERFECT\nGREAT\nGOOD\nBOO\nMISS",
			Size=30,
			StrokeSize=3,
			OnCommand=function(self) 
				self:y(60)
					:vertspacing(.95)
					:Regen()
				
				self:MainActor()
					:valign(0)
					:diffuse(color("#FF69B4"))

				self:StrokeActor()
					:valign(0)
					:diffuse(1,1,0,1)
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","PartyConfetti-Regular.ttf"),
			Text="MAX COMBO\nRANK",
			Size=26,
			StrokeSize=3,
			OnCommand=function(self) 
				self:y(200)
					:vertspacing(3)
					:Regen()

				self:MainActor()
					:valign(0)
					:diffuse(color("#FF69B4"))

				self:StrokeActor()
					:valign(0)
					:diffuse(1,1,0,1)
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","Gemsbuck01Black.ttf"),
			Text="D",
			Size=120,
			StrokeSize=6,
			OnCommand=function(self)
				self:xy(-160,220)

				self:MainActor()
					:valign(0)
					:diffuse(1,0,0,1)

				self:StrokeActor()
					:valign(0)
					:diffuse(1,1,0,1)
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","PartyConfetti-Regular.ttf"),
			Text="STAGE  SCORE\nTOTAL  SCORE",
			Size=35,
			StrokeSize=3,
			OnCommand=function(self) 
				self:y(340)
					:vertspacing(2.25)
					:Regen()

				self:MainActor()
					:valign(0)
					:diffuse(color("#FFFF00"))

				self:StrokeActor()
					:valign(0)
					:diffuse(0,0,1,1)
			end
		},
		Def.Text{
			Font=THEME:GetPathF("","PartyConfetti-Regular.ttf"),
			Text=string.format("%09d",GetScore()).."\n000000000",
			Size=45,
			StrokeSize=3,
			OnCommand=function(self) 
				self:xy(-110,340)
					:halign(1)
					:vertspacing(1.80)
					:Regen()

				self:MainActor()
					:valign(0)
					:halign(1)
					:diffuse(color("#FF69B4"))

				self:StrokeActor()
					:valign(0)
					:halign(1)
					:diffuse(1,1,0,1)
			end
		}
	}
end