TF_WHEEL.DDR1stScore = {
	[PLAYER_1] = 0,
	[PLAYER_2] = 0
}

local OldCombo = {
	[PLAYER_1] = 0,
	[PLAYER_2] = 0
}


return function()
	return Def.ActorFrame{
		JudgmentMessageCommand=function(self,params) 
			local combo = math.floor(STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player):GetCurrentCombo()/4)
			local score = params.TapNoteScore
			if score then
				if score == 'TapNoteScore_W1' or
				   score == 'TapNoteScore_W2' then
					TF_WHEEL.DDR1stScore[params.Player] = TF_WHEEL.DDR1stScore[params.Player] + (combo * combo * 300)
				end
				if score == 'TapNoteScore_W3' then
					TF_WHEEL.DDR1stScore[params.Player] = TF_WHEEL.DDR1stScore[params.Player] + (combo * combo * 100)
				end
				if score == 'TapNoteScore_W4' then
					TF_WHEEL.DDR1stScore[params.Player] = TF_WHEEL.DDR1stScore[params.Player] + (OldCombo[params.Player] * 100)
				end
			end
			OldCombo[params.Player] = combo;
		end
	}
end