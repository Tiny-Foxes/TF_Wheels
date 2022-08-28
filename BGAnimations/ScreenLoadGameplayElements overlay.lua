local SoundLevel = .2
local LoweringVolume = false
local EndingSong = false
local End = false
local IsDone = false

local foxes = Def.ActorFrame {
	Name="Foxes",
	OnCommand=function(self)
		self:y(80):zoom(.4)
	end
}

for i = 1,4 do
	foxes[#foxes+1] = Def.ActorFrame {
		Name=i,
		Def.Sprite {
			Name="First_"..i,
			Texture=THEME:GetPathO("","yap"),
			Frame0000=0,
			Delay0000=.8,
			Frame0001=1,
			Delay0001=.8,
			Frame0002=0,
			Delay0002=.8,
			Frame0003=2,
			Delay0003=.8,
			OnCommand=function(self)
				self:x(400*(i-2)-300)
					:visible(false)
			end
		},
		Def.Sprite {
			Name="Second_"..i,
			Texture=i == 4 and THEME:GetPathO("","yip") or THEME:GetPathO("","yap"),
			Frame0000=1,
			Delay0000=.8,
			Frame0001=0,
			Delay0001=.8,
			Frame0002=1,
			Delay0002=.8,
			Frame0003=2,
			Delay0003=.8,
			OnCommand=function(self)
				self:x(400*(i-2)-100)
					:visible(false)
			end
		}
	}
end

return Def.ActorFrame {
	OnCommand=function(self)
		self:Center()
	end,
	Def.Sprite {
		Texture=THEME:GetPathO("","bg")
	},
	Def.Sprite {
		Texture=THEME:GetPathO("","Devider"),
		OnCommand=function(self)
			self:zoomto(SCREEN_WIDTH,12):y(-140):customtexturerect(0,0,SCREEN_WIDTH/20,1)
		end
	},
	Def.Text{
		Font=THEME:GetPathF("","NotoSans-All.ttf"),
		Size=60,
		StrokeSize=2,
		Text="SONG LOADING",
		OnCommand=function(self)
			self:y(-190)
			self:MainActor():diffuse(0,.5,0,1)
			self:StrokeActor():diffuse(0,0,0,1)
		end
	},
	Def.Text{
		Font=THEME:GetPathF("","NotoSans-All.ttf"),
		Size=24,
		StrokeSize=2,
		OnCommand=function(self)
			self:y(-40)
				:halign(0)

			self:StrokeActor():diffuse(0,0,0,1)
		end,
		LoadingKeysoundMessageCommand=function(self,params)
			self:settext("Loading... "..string.gsub(params.File, ".*/", "").."\n\n".."Please do not press any\nbutton while loading."):Regen()
		end
	},
	LoadingKeysoundMessageCommand=function(self,params)
		local fox = self:GetChild("Foxes")		
		for i = 1,4 do
			if params.Percent >= (i*30)-40 then
				fox:GetChild(i):GetChild("First_"..i):visible(true)
			end
			if params.Percent >= (i*30)-20 then 
				fox:GetChild(i):GetChild("Second_"..i):visible(true)
			end
		end
		if params.Done and not End then
			End = true
			self:sleep(2):queuecommand("End")
		end
		if params.Done and not IsDone then
			IsDone = true
			self:sleep(3):queuecommand("NextScreen")
		end		
	end,
	EndCommand=function(self)
		local fox = self:GetChild("Foxes")		
		for i = 1,4 do
			fox:GetChild(i):GetChild("First_"..i):animate(false):setstate(3)
			fox:GetChild(i):GetChild("Second_"..i):animate(false):setstate(3)
		end
		
	end,
	NextScreenCommand=function(self)
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
	end,
	Def.ActorFrame {
		Def.Quad {
			OnCommand=function(self)
				self:zoomto(600,20):diffuse(0,0,0,1)
			end
		},
		Def.Quad {
			OnCommand=function(self)
				self:zoomto(596,16):diffuse(1,.5,0,1):cropright(0)
			end,
			LoadingKeysoundMessageCommand=function(self,params)
				self:cropright(1-(params.Percent/100))
			end
		}
	},
	Def.Sound {
		File=THEME:GetPathO("","Bark (loop).ogg"),
		OnCommand=function(self)
			self:play()
		end,
		LoadingKeysoundMessageCommand=function(self,params)
			if params.Done and not LoweringVolume then 
				LoweringVolume = true 
				self:sleep(2):queuecommand("stop")
			end
		end,
		stopCommand=function(self)
			self:stop()
		end
	},
	Def.Sound {
		File=THEME:GetPathO("","whistle.ogg"),
		LoadingKeysoundMessageCommand=function(self,params)
			if params.Done and not EndingSong then 
				EndingSong = true
				self:get():volume(.5)
				self:play()
				self:GetParent():GetChild("End"):sleep(2):queuecommand("play")
			end
		end
	},
	Def.Sound {
		Name="End",
		File=THEME:GetPathO("","end.ogg"),
		playCommand=function(self)
			self:play()
		end
	},
	foxes
}