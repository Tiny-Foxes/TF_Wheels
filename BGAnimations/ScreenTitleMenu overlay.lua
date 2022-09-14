-- Insantly go to DDR Wheel.
return Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():SetNextScreenName("OFSelectMusic"):StartTransitioningScreen("SM_GoToNextScreen")
	end
}
