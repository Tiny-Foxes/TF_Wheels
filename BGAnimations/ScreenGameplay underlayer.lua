return Def.ActorFrame{
	FOV=45,
	OnCommand=function(self)
		self:Center()
	end,
	
	--[[
	Def.NoteField{
		--NoteSkin="shotrhythm",
		Chart="Challenge",
		DrawDistanceBeforeTargetsPixels=720,
		InitMods="C900",
		FieldID=3,
		--Player=PLAYER_1,
		AutoPlay=true,
		OnCommand=function(self)
			self:rotationx(300):x(64*5)
		end
	},
	Def.NoteField{
		--NoteSkin="shotrhythm",
		Chart="Medium",
		DrawDistanceBeforeTargetsPixels=720,
		InitMods="C900",
		FieldID=4,
		--Player=PLAYER_1,
		AutoPlay=true,
		OnCommand=function(self)
			self:rotationx(300):x(-64*5)
		end
	},--]]

	--[[
	Def.AudioVisualizer {
		UpdateRate = 0.02,
		Amount = 128,
		LinearPeaks = true,
		PeakHeight = SCREEN_HEIGHT,
		OnCommand = function(self)
			self:zoomx(SCREEN_HEIGHT/360/1.6)
			self:SetSound(SCREENMAN:GetTopScreen():GetSound())

			local quads = self:GetQuads()
			for k,v in pairs(quads) do
				v:diffuse(1-(k/128),k/128,0,.5)
				v:diffusetopedge((k/128),1,1-(k/128),.5)
			end
		end
	},--]]

	--[[
	Def.ActorFrame {
		Def.AudioVisualizer {
			UpdateRate = 0.02,
			Amount = 128,
			LinearPeaks = true,
			PeakHeight = SCREEN_HEIGHT,
			OnCommand = function(self)
				self:zoomx(SCREEN_HEIGHT/360/1.6)
				self:SetSound(SCREENMAN:GetTopScreen():GetSound())
	
				local quads = self:GetQuads()
				for k,v in pairs(quads) do
					v:MaskSource()
				end
			end
		},
		Def.Sprite {
			Texture = GAMESTATE:GetCurrentSong():GetBackgroundPath(),
			OnCommand = function(self)
				self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):MaskDest()
			end
		},
		Def.Quad {
			OnCommand = function(self)
				self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT):clearzbuffer(true):blend("NoEffect")
			end
		},
	},--]]

	--[[
	Def.AudioVisualizer {
		UpdateRate = 0.02,
		Amount = 128,
		LinearPeaks = true,
		PeakHeight = SCREEN_HEIGHT/2,
		OnCommand = function(self)
			self:zoomx(SCREEN_HEIGHT/360)
			self:SetSound(SCREENMAN:GetTopScreen():GetSound())

			local quads = self:GetQuads()
			for k,v in pairs(quads) do
				v:xy(160*math.cos((k/124)*(math.pi*2)),160*math.sin((k/124)*(math.pi*2)))
					:diffuse(1,0,0,1):diffusetopedge(1,1,1,1)
					:addrotationz(-90+(k/124)*360)
			end
		end
	},--]]

	--[[
	Def.ActorFrame {
		Def.AudioVisualizer {
			Name="AV",
			UpdateRate = 0.02,
			Amount = 128,
			PeakHeight = SCREEN_HEIGHT,
			UseQuads = false,
			OnCommand = function(self)
				self:SetSound(SCREENMAN:GetTopScreen():GetSound())
			end,
		},
		OnCommand = function(self)
			self:queuecommand("Update")
		end,
		UpdateCommand = function(self)
			print("PENIS")
			PrintTable(self:GetChild("AV"):GetOutputValues())
			
			self:sleep(0.05):queuecommand("Update")
		end
	},--]]

	LoadModule("Gameplay.ComboManager.lua")()
}