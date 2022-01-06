-- We define the curent song if no song is selected.
if not CurSong then CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not CurGroup then GurGroup = "" end

-- This is the main function, Its the function that contains the wheel.
return function(Style)

    -- Load the songs from the Songs.Loader module.
	local Songs = LoadModule("Songs.Loader.lua")(Style)
	
	-- Sort the Songs and Group.
    local GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs,"Outfox")

    -- We define here is we load the Options menu when people double press,
	-- Because they need to double press it starts at false.
	local StartOptions = false

	-- The actual wheel.
	local Wheel = Def.ActorFrame{Name="Wheel"}

	-- For every item on the wheel do.
	for i = 1,9 do
		-- Grab center of wheel.
		local offset = i - 5
		
		-- Also grab center of wheel.
		local pos = CurSong+i-5

		-- But we keep it within limits.
		while pos > #GroupsAndSongs do pos = pos-#GroupsAndSongs end
		while pos < 1 do pos = #GroupsAndSongs+pos end
		
		Wheel[#Wheel+1] = Def.ActorFrame{
			InitCommand=function(self)
				local loc = 0
				if offset < 0 then 
					loc = -20
				elseif offset > 0 then
					loc = 20
				end
				self:xy(SCREEN_CENTER_X+88*offset+loc,SCREEN_CENTER_Y-40)
			end,
			Def.Quad{
				InitCommand=function(self)
					self:zoomto(75,75/2):y(75/2):diffuse(0,0,0,.5):fadebottom(.8)
					if offset == 0 then
						self:zoomto(135,135/2):y(-20+135/2)
					end
				end

			},
			Def.Quad{
				InitCommand=function(self)
					self:zoomto(75,75):diffuse(.5,.5,.5,1)
					if offset == 0 then
						self:zoomto(135,135):y(-20)
					end
				end

			},
			Def.Sprite{
				InitCommand=function(self)
					-- Check if its a song.
					if type(GroupsAndSongs[pos]) ~= "string" then
						if GroupsAndSongs[pos][1]:HasJacket() then
								self:Load(GroupsAndSongs[pos][1]:GetJacketPath())
						else
							self:Load(GroupsAndSongs[pos][1]:GetBannerPath())
						end
					else
						-- It's a group, Check if it has a banner.
						if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]) ~= "" then
							-- It does, Load it.
							self:Load(SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]))
						end
					end

					self:zoomto(75,75)
					if offset == 0 then
						self:zoomto(135,135):y(-20)
					end
				end
			}	
		}
	end


	return Def.ActorFrame{
		Def.Sprite{
			Texture=THEME:GetPathG("","IDOL/IdolBG.png"),
			InitCommand=function(self) 
				self:Center()
					:zoom(TF_WHEEL.Resize(self:GetWidth(),self:GetHeight(),SCREEN_WIDTH,SCREEN_HEIGHT, true)):glow(1,1,1,.5)
			end
		},
		Def.Sprite{
			Name="Circles",
			Texture=THEME:GetPathG("","IDOL/circle.png"),
			InitCommand=function(self) 
				self:CenterX():valign(0)
					:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT/3)
					:customtexturerect(0,0,SCREEN_WIDTH/6,SCREEN_HEIGHT/6/3)
					:fadebottom(.5):diffuse(0,0,0,.1)
			end
		},
		Def.ActorProxy{
			InitCommand=function(self)
				self:SetTarget(self:GetParent():GetChild("Circles")):zoomy(-1):y(SCREEN_HEIGHT)
			end
		},
		Def.BitmapText{
			Text="SONG SELECT",
			Font="_squarefont 24px",
			InitCommand=function(self)
				self:zoomy(1.4):zoomx(2):x(47):rotationz(90):diffuse(0,0,0,0):decelerate(.6):diffusealpha(.2):y(SCREEN_CENTER_Y-40)
			end
		},
		Def.Quad{
			Name="Line",
			InitCommand=function(self)
				self:zoomto(2,2):xy(60,-2):diffuse(0,0,0,1):valign(0):decelerate(1):zoomto(2,SCREEN_HEIGHT+4)
			end
		},
		Def.ActorProxy{
			InitCommand=function(self)
				self:SetTarget(self:GetParent():GetChild("Line")):x(SCREEN_WIDTH-120)
			end
		},

		Def.Quad{
			InitCommand=function(self)
				self:diffuse(1,1,1,.6):CenterX():y(SCREEN_CENTER_Y-40):zoomto(4,4)
					:decelerate(.3):zoomto(4,260):decelerate(.7):zoomto(SCREEN_WIDTH-180,260)
			end
		},

		Def.Quad{
			Name="Corner",
			InitCommand=function(self)
				self:CenterX():y(SCREEN_CENTER_Y-40):diffuse(1,1,1,1):zoomto(8,4):decelerate(.3):y(SCREEN_CENTER_Y-40-128):decelerate(.7):zoomto(SCREEN_WIDTH-180,4)
			end
		},
		Def.ActorProxy{
			InitCommand=function(self)
				self:y(SCREEN_CENTER_Y+160):SetTarget(self:GetParent():GetChild("Corner")):zoomy(-1)
			end
		},

		Def.ActorFrame{
			Name="Slider",
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X-2,SCREEN_CENTER_Y-40):sleep(.3):decelerate(.7):x(90)
			end,
			Def.Quad{
				InitCommand=function(self)
					self:diffuse(0,0,0,1):zoomto(4,4):decelerate(.3):zoomto(4,260)
				end
			},
			Def.Quad{
				Name="Corner",
				InitCommand=function(self)
					self:x(2):diffuse(0,0,0,1):zoomto(8,4):decelerate(.3):y(-128)
				end
			},
			Def.ActorProxy{
				InitCommand=function(self)
					self:SetTarget(self:GetParent():GetChild("Corner")):zoomy(-1)
				end
			}
		},
		
		Def.ActorProxy{
			InitCommand=function(self)
				self:SetTarget(self:GetParent():GetChild("Slider")):zoomx(-1):x(SCREEN_WIDTH)
			end
		},

		Def.ActorFrame{
			InitCommand=function(self)
				self:diffusealpha(0):xy(SCREEN_CENTER_X-80,SCREEN_CENTER_Y+120):sleep(.5)
					:decelerate(.5):diffusealpha(1):y(SCREEN_CENTER_Y+140)
			end,
			Def.Quad{
				InitCommand=function(self)
					self:diffuse(.7,.7,.4,1):zoomto(SCREEN_WIDTH-360,80)
				end
			},
			Def.Quad{
				InitCommand=function(self)
					self:diffuse(.8,.8,.5,1):zoomto(SCREEN_WIDTH-365,75)
				end
			},
			Def.Sprite{
				Texture=THEME:GetPathG("","IDOL/circle.png"),
				InitCommand=function(self) 
					self:y(-10):zoomto(SCREEN_WIDTH-390,2)
						:customtexturerect(0,0,SCREEN_WIDTH/4-390,1)
						:diffuse(0,0,0,1)
				end
			},
			Def.Sprite{
				Texture=THEME:GetPathG("","IDOL/circle.png"),
				InitCommand=function(self) 
					self:xy(SCREEN_WIDTH/2-220,-20):zoomto(2,16)
						:customtexturerect(0,0,1,8)
						:diffuse(0,0,0,1)
				end
			},
			Def.BitmapText{
				Text="BPM : 000.0",
				Font="_open sans 40px",
				InitCommand=function(self)
					self:xy(SCREEN_WIDTH/2-226,-20):diffuse(0,0,0,1):zoom(.3):halign(1):queuecommand("BPMChange")
				end,
				BPMChangeCommand=function(self)
					if type(GroupsAndSongs[CurSong]) ~= "string" then
						local BPMS = GroupsAndSongs[CurSong][1]:GetDisplayBpms()

						if BPMS[1] ~= BPMS[2] then
							self:settext(string.format("%03.0f",BPMS[1]))
						else
							self:settext(string.format("%03.0f",BPMS[1]))
						end
					else
						self:settext("BPM : 000.0")
					end
				end,
			}
		},
		Def.Quad{
			InitCommand=function(self)
				self:MaskSource():zoomto(190,SCREEN_HEIGHT):CenterY()
			end
		},
		Def.Quad{
			InitCommand=function(self)
				self:x(SCREEN_WIDTH):MaskSource():zoomto(190,SCREEN_HEIGHT):CenterY()
			end
		},			
		Wheel..{
			InitCommand=function(self)
				self:MaskDest()
			end
		}
	}
end