-- We define the curent song if no song is selected.
if not CurSong then CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not CurGroup then GurGroup = "" end

-- This is the main function, Its the function that contains the wheel.
return function(Style)

	-- Load the songs from the Songs.Loader module.
	local Songs = LoadModule("Songs.Loader.lua")(Style)

	-- Sort the Songs and Group.
	local GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs, CurGroup)

	-- We define here is we load the Options menu when people double press,
	-- Because they need to double press it starts at false.
	local StartOptions = false

	-- The actual wheel.
	local Wheel = Def.ActorFrame { Name = "Wheel" }

	-- For every item on the wheel do.
	for i = 1, 5 do
		-- Grab center of wheel.
		local offset = i - 3

		-- Also grab center of wheel.
		local pos = CurSong + i - 3

		-- But we keep it within limits.
		while pos > #GroupsAndSongs do pos = pos - #GroupsAndSongs end
		while pos < 1 do pos = #GroupsAndSongs + pos end

		Wheel[#Wheel + 1] = Def.ActorFrame {
			Name = "Container" .. i,
			InitCommand = function(self)
				self:xy(105 * offset, 130)
				if offset == 0 then
					self:diffuse(.5, .5, .5, 1)
				end
			end,
			Def.Quad {
				Name = "JacketFrame",
				InitCommand = function(self)
					self:zoomto(85, 85):diffuse(.5, .5, .5, 1)
				end

			},
			Def.Sprite {
				Name = "Jacket",
				InitCommand = function(self)
					-- Check if its a song.
					if type(GroupsAndSongs[pos]) ~= "string" then
						if GroupsAndSongs[pos][1]:HasJacket() then
							self:Load(GroupsAndSongs[pos][1]:GetJacketPath())
						else
							self:Load(GroupsAndSongs[pos][1]:GetBannerPath())
						end
					else
						if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]) ~= "" then
							self:Load(SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]))
						end
					end

					self:zoomto(85, 85)
				end
			}
		}
	end

	-- Here we return the actual Music Wheel Actor.
	return Def.ActorFrame {
		OnCommand = function(self)
			self:Center():zoom(SCREEN_HEIGHT / 480)
			-- We use a Input function from the Scripts folder.
			-- It uses a Command function. So you can define all the Commands,
			-- Like MenuLeft is MenuLeftCommand.
			SCREENMAN:GetTopScreen():AddInputCallback(TF_WHEEL.Input(self))

			-- Sleep for 0.2 sec, And then load the current song music.
			self:GetChild("MusicCon"):stoptweening():sleep(0):queuecommand("PlayCurrentSong")
		end,

		-- Play Music at start of screen,.
		Def.ActorFrame {
			Name = "MusicCon",
			PlayCurrentSongCommand = function(self)
				TF_WHEEL.BG:Load(GroupsAndSongs[CurSong][1]:GetBackgroundPath()):FullScreen()
				if type(GroupsAndSongs[CurSong]) ~= "string" then
					if GroupsAndSongs[CurSong][1].PlayPreviewMusic then
						GroupsAndSongs[CurSong][1]:PlayPreviewMusic()
					elseif GroupsAndSongs[CurSong][1]:GetMusicPath() then
						SOUND:PlayMusicPart(GroupsAndSongs[CurSong][1]:GetMusicPath(),
							GroupsAndSongs[CurSong][1]:GetSampleStart(),
							GroupsAndSongs[CurSong][1]:GetSampleLength(), 0, 0, true)
					end
				end
			end
		},

		Def.Sprite {
			Texture = THEME:GetPathG("", "Popila/BG.png"),
			InitCommand = function(self)
				self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), SCREEN_WIDTH, SCREEN_HEIGHT, true))
			end
		},

		Def.Quad {
			Name = "JacketFrame",
			InitCommand = function(self)
				self:y(130):zoomto(SCREEN_WIDTH, 120):diffuse(0, 0, 0, .4)
			end

		},
		Wheel,
		Def.BitmapText {
			Text = "[X]···CHANGE   [Shift]···OPERATOR",
			Font = "Popila/besttendot 10px",
			InitCommand = function(self)
				self:SetTextureFiltering(false)
				self:halign(0):valign(1):xy(-SCREEN_CENTER_X + 12, SCREEN_CENTER_Y - 26):diffuse(0, 0, 0, 1):zoom(1.8)
			end
		},
		Def.BitmapText {
			Text = "[X]···CHANGE   [Shift]···OPERATOR",
			Font = "Popila/besttendot 10px",
			InitCommand = function(self)
				self:SetTextureFiltering(false)
				self:halign(0):valign(1):xy(-SCREEN_CENTER_X + 10, SCREEN_CENTER_Y - 28):diffuse(1, 1, 1, 1):zoom(1.8)
			end
		},
	}
end
