-- We define the curent song if no song is selected.
if not CurSong then CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not CurGroup then GurGroup = "" end

-- Position on the difficulty select that shows up after we picked a song.
local DiffPos = { [PLAYER_1] = 1, [PLAYER_2] = 1 }

local CurConfirm = 1

-- The increase offset for when we move with postive.
local IncOffset = 1

-- The decrease offset for when we move with negative.
local DecOffset = 9

-- The center offset of the wheel.
local XOffset = 5

-- We start on the wheel so dont start the difficulty select being active.
local DiffSelection = false

-- Move the wheel, We define the Offset using +1 or -1.
-- We parse the Songs also so we can get the amount of songs.
local function MoveSelection(self, offset, Songs)

	-- Curent Song + Offset.
	CurSong = CurSong + offset

	-- Check if curent song is further than Songs if so, reset to 1.
	if CurSong > #Songs then CurSong = 1 end
	-- Check if curent song is lower than 1 if so, grab last song.
	if CurSong < 1 then CurSong = #Songs end

	-- Set the offsets for increase and decrease.
	DecOffset = DecOffset + offset
	IncOffset = IncOffset + offset

	if DecOffset > 9 then DecOffset = 1 end
	if IncOffset > 9 then IncOffset = 1 end

	if DecOffset < 1 then DecOffset = 9 end
	if IncOffset < 1 then IncOffset = 9 end

	local XOldOffset = XOffset

	-- Set the offset for the center of the wheel.
	XOffset = XOffset + offset
	if XOffset > 9 then XOffset = 1 end
	if XOffset < 1 then XOffset = 9 end

	-- If we are calling this command with an offset that is not 0 then do stuff.
	if offset ~= 0 then

		-- For every part on the wheel do.
		for i = 1, 9 do
			-- Calculate current position based on song with a value to get center.
			local pos = CurSong + (4 * offset)

			-- Keep it within reasonable values.
			while pos > #Songs do pos = pos - #Songs end
			while pos < 1 do pos = #Songs + pos end

			-- Transform the wheel, As in make it move.
			self:GetChild("Wheel"):GetChild("Container" .. i):decelerate(.1):addx((offset * -88))

			-- Here we define what the wheel does if it is outside the values.
			-- So that when a part is at the bottom it will move to the top.
			if (i == IncOffset and offset == -1) or (i == DecOffset and offset == 1) then

				-- Move wheelpart instantly to new location.
				self:GetChild("Wheel"):GetChild("Container" .. i):sleep(0):addx(((offset * -88) * -9) + 40 * offset)
				-- Check if it's a song.
				if type(Songs[pos]) ~= "string" then
					if Songs[pos][1]:HasJacket() then
						self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):visible(1):Load(Songs[pos][1]:GetJacketPath())
					elseif Songs[pos][1]:HasBanner() then
						self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):visible(1):Load(Songs[pos][1]:GetBannerPath())
					else
						self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):visible(0)
					end
				else
					if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then
						self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):visible(1):Load(SONGMAN:
							GetSongGroupBannerPath(Songs[pos]))
					else
						self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):visible(0)
					end
				end

				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):zoomto(75, 75)
			end

			if i == XOffset then
				self:GetChild("Wheel"):GetChild("Container" .. i):addx(-20 * offset)
				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):decelerate(.1):zoomto(135, 135):y(-20)
				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("JacketFrame"):decelerate(.1):zoomto(135, 135):y(-20)
				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("JacketShadow"):decelerate(.1):zoomto(135, 135 / 2):y(-20
					+ 135 / 2)
			elseif i == XOldOffset then
				self:GetChild("Wheel"):GetChild("Container" .. i):addx(-20 * offset)
				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Jacket"):decelerate(.1):zoomto(75, 75):y(0)
				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("JacketFrame"):decelerate(.1):zoomto(75, 75):y(0)
				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("JacketShadow"):decelerate(.1):zoomto(75, 75 / 2):y(75 / 2)
			end
		end

		self:GetChild("SongSelBar"):decelerate(.1)
			:x(-SCREEN_CENTER_X + ((SCREEN_WIDTH - 120) / 12) * OFMath.map(CurSong, 1, #Songs, 2, 11.95))

		-- Check if we are on song.
		if type(Songs[CurSong]) ~= "string" then
			self:GetChild("CurSongTitle"):settext(Songs[CurSong][1]:GetDisplayMainTitle()):diffusealpha(0):y(0):decelerate(.1):y(30)
				:diffusealpha(1)
		else
			self:GetChild("CurSongTitle"):settext(Songs[CurSong]):diffusealpha(0):y(0):decelerate(.1):y(30):diffusealpha(1)
		end
		-- We are on an offset of 0.
	else
		-- For every part on the wheel do.
		for i = 1, 9 do
			-- Offset for the wheel items.
			local off = i + XOffset

			-- Stay withing limits.
			while off > 9 do off = off - 9 end
			while off < 1 do off = off + 9 end

			-- Calculate current position based on song with a value to get center.
			local pos = CurSong + i

			-- If item is above 6 then we do a -9 to fix the display.
			if i > 4 then
				pos = CurSong + i - 9
			end

			-- Keep it within reasonable values.
			while pos > #Songs do pos = pos - #Songs end
			while pos < 1 do pos = #Songs + pos end

			-- Check if it's a song.
			if type(Songs[pos]) ~= "string" then
				if Songs[pos][1]:HasJacket() then
					self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Jacket"):visible(1):Load(Songs[pos][1]:GetJacketPath())
				elseif Songs[pos][1]:HasBanner() then
					self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Jacket"):visible(1):Load(Songs[pos][1]:GetBannerPath())
				else
					self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Jacket"):visible(0)
				end
			else
				if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then
					self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Jacket"):visible(1):Load(SONGMAN:
						GetSongGroupBannerPath(Songs[pos]))
				else
					self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Jacket"):visible(0)
				end
			end

			if off == XOffset then
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Jacket"):zoomto(135, 135)
			else
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Jacket"):zoomto(75, 75)
			end
		end

		self:GetChild("SongSelBar"):decelerate(.1)
			:x(-SCREEN_CENTER_X + ((SCREEN_WIDTH - 120) / 12) * OFMath.map(CurSong, 1, #Songs, 2, 11.95))
	end

	-- Check if we are on song.
	if type(Songs[CurSong]) ~= "string" then
		self:GetChild("Data"):GetChild("Artist"):settext("Artist : " ..
			Songs[CurSong][1]:GetDisplayArtist() .. "  Producer : " .. Songs[CurSong][2]:GetAuthorCredit())
		if Songs[CurSong][1]:GetDisplaySubTitle() == "" then
			self:GetChild("Data"):GetChild("SubTitle"):settext(TF_WHEEL.FormatAddNewline(Songs[CurSong][1]:GetTags(), 60)):
				stopeffect():y(-5)
		else
			self:GetChild("Data"):GetChild("SubTitle"):settext(TF_WHEEL.FormatAddNewline(Songs[CurSong][1]:GetDisplaySubTitle(),
				60)):stopeffect():y(-5)
		end

		if self:GetChild("Data"):GetChild("SubTitle"):GetHeight() > 140 then
			self:GetChild("Data"):GetChild("SubTitle"):y(-self:GetChild("Data"):GetChild("SubTitle"):GetHeight() * .125):bob()
				:effectmagnitude(0, (-.04 * (self:GetChild("Data"):GetChild("SubTitle"):GetHeight() / .3)), 0)
				:effecttiming(self:GetChild("Data"):GetChild("SubTitle"):GetHeight() / 50, 0,
					self:GetChild("Data"):GetChild("SubTitle"):GetHeight() / 50, 0, 0)
		end

		local BPMS = Songs[CurSong][1]:GetDisplayBpms()

		if BPMS[1] ~= BPMS[2] then
			self:GetChild("Data"):GetChild("BPM"):settext("BPM : " .. string.format("%3.1f", BPMS[1]))
		else
			self:GetChild("Data"):GetChild("BPM"):settext("BPM : " .. string.format("%3.1f", BPMS[1]))
		end
		-- not song.
	else
		self:GetChild("Data"):GetChild("Artist"):settext("Artist :")
		self:GetChild("Data"):GetChild("SubTitle"):settext("")
		self:GetChild("Data"):GetChild("BPM"):settext("BPM : 000.0")
	end

	self:GetChild("CurSongLoc"):settext(CurSong .. "/")
	self:GetChild("CurSongAmount"):settext(#Songs)

	-- Check if offset is not 0.
	if offset ~= 0 then
		-- Stop all the music playing, Which is the Song Music
		SOUND:StopMusic()

		self:GetChild("MusicCon"):stoptweening():sleep(0.4):queuecommand("PlayCurrentSong")
	end
end

local function MoveConfirm(self, offset)

	if GAMESTATE:IsSideJoined(self.pn) then

		CurConfirm = CurConfirm + offset

		if CurConfirm > 2 then CurConfirm = 2 end
		if CurConfirm < 1 then CurConfirm = 1 end

		self:GetChild("DiffSel"):GetChild("Confirm"):stoptweening():linear(.1):x((SCREEN_WIDTH / 16) * ((CurConfirm - 1.5) * 2
			))

	end
end

local function MoveDifficulty(self, offset, Songs)

	-- If player is joined, let them change the difficulty.
	if GAMESTATE:IsSideJoined(self.pn) then

		-- Change the difficulty position for the current player.
		DiffPos[self.pn] = DiffPos[self.pn] + offset

		-- Check if its within limits.
		if DiffPos[self.pn] < 1 then DiffPos[self.pn] = 1 end
		if DiffPos[self.pn] > #Songs[CurSong] - 1 then DiffPos[self.pn] = #Songs[CurSong] - 1 end
	end
end

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
	for i = 1, 9 do
		-- Grab center of wheel.
		local offset = i - 5

		-- Also grab center of wheel.
		local pos = CurSong + i - 5

		-- But we keep it within limits.
		while pos > #GroupsAndSongs do pos = pos - #GroupsAndSongs end
		while pos < 1 do pos = #GroupsAndSongs + pos end

		Wheel[#Wheel + 1] = Def.ActorFrame {
			Name = "Container" .. i,
			InitCommand = function(self)
				local loc = 0
				local time = 1
				if offset < 0 then
					time = offset * -1 + 1
					loc = -20
				elseif offset > 0 then
					time = offset + 1
					loc = 20
				end
				self:x(88 * offset + loc):zoomx(0)
					:sleep(.9):sleep(.1 * time):decelerate(.3):zoomx(1)
			end,
			Def.Quad {
				Name = "JacketShadow",
				InitCommand = function(self)
					self:zoomto(75, 75 / 2):y(75 / 2):diffuse(0, 0, 0, .5):fadebottom(.8)
					if offset == 0 then
						self:zoomto(135, 135 / 2):y(-20 + 135 / 2)
					end
				end

			},
			Def.Quad {
				Name = "JacketFrame",
				InitCommand = function(self)
					self:zoomto(75, 75):diffuse(.5, .5, .5, 1)
					if offset == 0 then
						self:zoomto(135, 135):y(-20)
					end
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

					self:zoomto(75, 75)
					if offset == 0 then
						self:zoomto(135, 135):y(-20)
					end
				end
			}
		}
	end

	-- Here we return the actual Music Wheel Actor.
	return Def.ActorFrame {
		OnCommand = function(self)
			self:Center():zoom(SCREEN_HEIGHT / 480)

			MoveSelection(self, 0, GroupsAndSongs)

			-- Sleep for 1.8 sec, And then load the current song music.
			self:GetChild("MusicCon"):stoptweening():sleep(0):queuecommand("PlayCurrentSong")
		end,

		-- Play Music at start of screen,.
		Def.ActorFrame {
			Name = "MusicCon",
			PlayCurrentSongCommand = function(self)
				-- We use a Input function from the Scripts folder.
				-- It uses a Command function. So you can define all the Commands,
				-- Like MenuLeft is MenuLeftCommand.
				SCREENMAN:GetTopScreen():AddInputCallback(TF_WHEEL.Input(self))

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

		-- Do stuff when a user presses left on Pad or Menu buttons.
		MenuLeftCommand = function(self) if DiffSelection then MoveConfirm(self, -1) else MoveSelection(self, -1,
			GroupsAndSongs) end end,

		-- Do stuff when a user presses Right on Pad or Menu buttons.
		MenuRightCommand = function(self) if DiffSelection then MoveConfirm(self, 1) else MoveSelection(self, 1, GroupsAndSongs) end end,

		-- Do stuff when a user presses Up on Pad or Menu buttons.
		MenuUpCommand = function(self) if DiffSelection then MoveDifficulty(self, -1, GroupsAndSongs) end end,

		-- Do stuff when a user presses Down on Pad or Menu buttons.
		MenuDownCommand = function(self) if DiffSelection then MoveDifficulty(self, 1, GroupsAndSongs) end end,

		-- Do stuff when a user presses the Back on Pad or Menu buttons.
		BackCommand = function(self)
			-- Check if User is joined.
			if GAMESTATE:IsSideJoined(self.pn) then
				if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
					-- If both players are joined, We want to unjoin the player that pressed back.
					GAMESTATE:UnjoinPlayer(self.pn)

					MoveSelection(self, 0, GroupsAndSongs)
				else
					-- Go to the previous screen.
					SCREENMAN:GetTopScreen():SetNextScreenName(SCREENMAN:GetTopScreen():GetPrevScreenName()):StartTransitioningScreen("SM_GoToNextScreen")
				end
			end
		end,

		-- Do stuff when a user presses the Start on Pad or Menu buttons.
		StartCommand = function(self)
			-- Check if we want to go to ScreenPlayerOptions instead of ScreenGameplay.
			if StartOptions then
				SCREENMAN:GetTopScreen():SetNextScreenName("ScreenPlayerOptions"):StartTransitioningScreen("SM_GoToNextScreen")
			end
			-- Check if player is joined.
			if GAMESTATE:IsSideJoined(self.pn) then

				-- Check if we are on a group.
				if type(GroupsAndSongs[CurSong]) == "string" then

					-- Check if we are on the same group thats currently open,
					-- If not we set the curent group to our new selection.
					if CurGroup ~= GroupsAndSongs[CurSong] then
						CurGroup = GroupsAndSongs[CurSong]

						-- Same group, Close it.
					else
						CurGroup = ""
					end

					-- Reset the groups location so we dont bug.
					GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs, "")
					MoveSelection(self, 0, GroupsAndSongs)

					-- Set CurSong to the right group.
					for i, v in ipairs(GroupsAndSongs) do
						if v == CurGroup then
							CurSong = i
						end
					end

					-- Set the current group.
					GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs, CurGroup)
					MoveSelection(self, 0, GroupsAndSongs)

					-- Not on a group, Start song.
				else
					if DiffSelection then
						-- We are on Yes, Continue to Song.
						if CurConfirm == 1 then
							-- Check if 2 players are joined.
							if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then

								-- If they are, We will use Versus.
								GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDBVersus[Style])

								-- Save Profiles.
								PROFILEMAN:SaveProfile(PLAYER_1)
								PROFILEMAN:SaveProfile(PLAYER_2)

								-- Set the Current Steps to use.
								GAMESTATE:SetCurrentSteps(PLAYER_1, GroupsAndSongs[CurSong][DiffPos[PLAYER_1] + 1])
								GAMESTATE:SetCurrentSteps(PLAYER_2, GroupsAndSongs[CurSong][DiffPos[PLAYER_2] + 1])
							else

								-- If we are single player, Use Single.
								GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDB[Style])

								-- Save Profile.
								PROFILEMAN:SaveProfile(self.pn)

								-- Set the Current Step to use.
								GAMESTATE:SetCurrentSteps(self.pn, GroupsAndSongs[CurSong][DiffPos[self.pn] + 1])
							end

							-- We want to go to player options when people doublepress, So we set the StartOptions to true,
							-- So when the player presses Start again, It will go to player options.
							StartOptions = true

							-- Wait 0.4 sec before we go to next screen.
							self:sleep(0.4):queuecommand("StartSong")
						else
							-- We are on No, Return to Song select.
							DiffSelection = false

							self:GetChild("Filter"):sleep(.25):linear(.25):diffusealpha(0)
							self:GetChild("DiffSel"):sleep(.25):queuecommand("Hide")

						end
					else
						--We use PlayMode_Regular for now.
						GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")

						DiffSelection = true

						self:GetChild("Filter"):linear(.25):diffusealpha(.5)
						self:GetChild("DiffSel"):sleep(.25):queuecommand("Show")
					end
				end
			else
				-- If no player is active Join.
				GAMESTATE:JoinPlayer(self.pn)

				-- Load the profles.
				GAMESTATE:LoadProfiles()

				MoveSelection(self, 0, GroupsAndSongs)
			end
		end,

		-- Change to ScreenGameplay.
		StartSongCommand = function(self)
			SCREENMAN:GetTopScreen():SetNextScreenName("ScreenLoadGameplayElements"):StartTransitioningScreen("SM_GoToNextScreen")
		end,

		Def.Sprite {
			Texture = THEME:GetPathG("", "IDOL/IdolBG.png"),
			InitCommand = function(self)
				self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), SCREEN_WIDTH, SCREEN_HEIGHT, true)):glow(1, 1, 1, .5)
			end
		},
		Def.Sprite {
			Name = "Circles",
			Texture = THEME:GetPathG("", "IDOL/circle.png"),
			InitCommand = function(self)
				self:valign(0):y(-SCREEN_CENTER_Y)
					:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT / 3)
					:customtexturerect(0, 0, SCREEN_WIDTH / 6, SCREEN_HEIGHT / 6 / 3)
					:fadebottom(.5):diffuse(0, 0, 0, .1)
			end
		},
		Def.ActorProxy {
			InitCommand = function(self)
				self:SetTarget(self:GetParent():GetChild("Circles")):zoomy(-1)
			end
		},
		Def.BitmapText {
			Text = "SONG SELECT",
			Font = "IdolM/_squarefont 24px",
			InitCommand = function(self)
				self:zoomy(1.4):zoomx(1.8):xy(-SCREEN_CENTER_X + 47, -SCREEN_CENTER_Y):rotationz(90):diffuse(0, 0, 0, 0):decelerate(.6)
					:diffusealpha(.2):y(-40)
			end
		},
		Def.Quad {
			Name = "Line",
			InitCommand = function(self)
				self:zoomto(2, 2):xy(-SCREEN_CENTER_X + 60, -SCREEN_CENTER_Y - 2):diffuse(0, 0, 0, 1):valign(0):decelerate(1):zoomto(2
					, SCREEN_HEIGHT + 4)
			end
		},
		Def.ActorProxy {
			InitCommand = function(self)
				self:SetTarget(self:GetParent():GetChild("Line")):x(SCREEN_WIDTH - 120)
			end
		},

		Def.Quad {
			InitCommand = function(self)
				self:diffuse(1, 1, 1, .6):y(-40):zoomto(4, 4)
					:decelerate(.3):zoomto(4, 260):decelerate(.7):zoomto(SCREEN_WIDTH - 180, 260)
			end
		},

		Def.Quad {
			Name = "Corner",
			InitCommand = function(self)
				self:y(-40):diffuse(1, 1, 1, 1):zoomto(8, 4):decelerate(.3
				):y(-40 - 128):decelerate(.7):zoomto(SCREEN_WIDTH - 180, 4)
			end
		},
		Def.ActorProxy {
			InitCommand = function(self)
				self:y(-80):SetTarget(self:GetParent():GetChild("Corner")):zoomy(-1)
			end
		},

		Def.Quad {
			Name = "SongSelBar",
			InitCommand = function(self)
				self:y(88):diffuse(.9, .5, .6, 0)
					:x(-SCREEN_CENTER_X + ((SCREEN_WIDTH - 120) / 12) * OFMath.map(CurSong, 1, #GroupsAndSongs, 2, 12))
					:zoomto((SCREEN_WIDTH - 180) / 12, 4):sleep(1):diffusealpha(1)
			end
		},

		Def.ActorFrame {
			Name = "Slider",
			InitCommand = function(self)
				self:xy(-2, -40):sleep(.3):decelerate(.7):x(-SCREEN_CENTER_X + 90)
			end,
			Def.Quad {
				InitCommand = function(self)
					self:diffuse(0, 0, 0, 1):zoomto(4, 4):decelerate(.3):zoomto(4, 260)
				end
			},
			Def.Quad {
				Name = "Corner",
				InitCommand = function(self)
					self:x(2):diffuse(0, 0, 0, 1):zoomto(8, 4):decelerate(.3):y(-128)
				end
			},
			Def.ActorProxy {
				InitCommand = function(self)
					self:SetTarget(self:GetParent():GetChild("Corner")):zoomy(-1)
				end
			}
		},

		Def.ActorProxy {
			InitCommand = function(self)
				self:SetTarget(self:GetParent():GetChild("Slider")):zoomx(-1)
			end
		},

		Def.ActorFrame {
			Name = "Data",
			InitCommand = function(self)
				self:diffusealpha(0):xy(-80, 120):sleep(.5)
					:decelerate(.5):diffusealpha(1):y(140)
			end,
			Def.Quad {
				InitCommand = function(self)
					self:diffuse(.7, .7, .4, 1):zoomto(SCREEN_WIDTH - 360, 80)
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:diffuse(.8, .8, .5, 1):zoomto(SCREEN_WIDTH - 365, 75)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "IDOL/circle.png"),
				InitCommand = function(self)
					self:y(-10):zoomto(SCREEN_WIDTH - 390, 2)
						:customtexturerect(0, 0, SCREEN_WIDTH / 4 - 390, 1)
						:diffuse(0, 0, 0, 1)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "IDOL/circle.png"),
				InitCommand = function(self)
					self:xy(SCREEN_WIDTH / 2 - 220, -20):zoomto(2, 16)
						:customtexturerect(0, 0, 1, 8)
						:diffuse(0, 0, 0, 1)
				end
			},
			Def.BitmapText {
				Name = "Artist",
				Text = "Artist :",
				Font = "_noto sans 40px",
				InitCommand = function(self)
					self:xy(-226, -20):diffuse(0, 0, 0, 1):zoom(.3):halign(0):maxwidth(1000):queuecommand("BPMChange")
				end,
				BPMChangeCommand = function(self)
					if type(GroupsAndSongs[CurSong]) ~= "string" then
						self:settext("Artist : " ..
							GroupsAndSongs[CurSong][1]:GetDisplayArtist() .. "  Producer : " .. GroupsAndSongs[CurSong][2]:GetAuthorCredit())
					else
						self:settext("Artist :")
					end
				end,
			},
			Def.Quad {
				InitCommand = function(self)
					self:valign(1):zoomto(SCREEN_WIDTH - 360, 9999):y(-8):MaskSource(true)
				end,
			},
			Def.Quad {
				InitCommand = function(self)
					self:valign(0):zoomto(SCREEN_WIDTH - 360, 9999):y(40):MaskSource()
				end,
			},
			Def.BitmapText {
				Name = "SubTitle",
				Font = "_noto sans 40px",
				InitCommand = function(self)
					self:xy(-226, -5):diffuse(0, 0, 0, 1):zoom(.3):valign(0):halign(0):vertspacing(4):MaskDest()
				end
			},
			Def.BitmapText {
				Name = "BPM",
				Text = "BPM : 000.0",
				Font = "_noto sans 40px",
				InitCommand = function(self)
					self:xy(SCREEN_WIDTH / 2 - 226, -20):diffuse(0, 0, 0, 1):zoom(.3):halign(1):queuecommand("BPMChange")
				end,
				BPMChangeCommand = function(self)
					if type(GroupsAndSongs[CurSong]) ~= "string" then
						local BPMS = GroupsAndSongs[CurSong][1]:GetDisplayBpms()

						if BPMS[1] ~= BPMS[2] then
							self:settext("BPM : " .. string.format("%3.1f", BPMS[1]))
						else
							self:settext("BPM : " .. string.format("%3.1f", BPMS[1]))
						end
					else
						self:settext("BPM : 000.0")
					end
				end,
			},
			Def.ActorFrame {
				Name = "Star",
				InitCommand = function(self)
					self:xy(220, -20):sleep(.5):decelerate(1):rotationz(360)
				end,
				Def.Sprite {
					Texture = THEME:GetPathG("", "Star.png"),
					InitCommand = function(self)
						self:zoom(.025):diffuse(0, 0, 0, 1)
					end
				},
				Def.Sprite {
					Texture = THEME:GetPathG("", "Star.png"),
					InitCommand = function(self)
						self:zoom(.015):diffuse(.25, .5, 1, 1)
					end
				}
			}

		},
		Def.Quad {
			InitCommand = function(self)
				self:x(-SCREEN_CENTER_X):MaskSource(true):zoomto(190, SCREEN_HEIGHT)
			end
		},
		Def.Quad {
			InitCommand = function(self)
				self:x(SCREEN_CENTER_X):MaskSource():zoomto(190, SCREEN_HEIGHT)
			end
		},
		Wheel .. {
			InitCommand = function(self)
				self:y(-60)
					:MaskDest():sleep(1):decelerate(.3):y(-40)
			end
		},
		Def.BitmapText {
			Name = "CurSongTitle",
			Font = "_noto sans 40px",
			InitCommand = function(self)
				-- Check if we are on group.
				if type(GroupsAndSongs[CurSong]) == "string" then
					self:settext(GroupsAndSongs[CurSong])
					-- not group.
				else
					self:settext(GroupsAndSongs[CurSong][1]:GetDisplayMainTitle())
				end

				self:diffuse(0, 0, 0, 0):zoom(.5):sleep(1)
					:decelerate(.3):diffusealpha(1):y(30)
			end
		},
		Def.BitmapText {
			Name = "CurSongLoc",
			Font = "_noto sans 40px",
			Text = CurSong .. "/",
			InitCommand = function(self)
				self:xy(10, -145):diffuse(0, 0, 0, 0):halign(1)
					:zoom(.7):sleep(1):decelerate(.3):diffusealpha(1)
			end
		},
		Def.BitmapText {
			Name = "CurSongAmount",
			Font = "_noto sans 40px",
			Text = #GroupsAndSongs,
			InitCommand = function(self)
				self:xy(10, -141):diffuse(0, 0, 0, 0):halign(0)
					:zoom(.4):sleep(1):decelerate(.3):diffusealpha(1)
			end
		},
		Def.ActorFrame {
			Name = "Arrow",
			InitCommand = function(self)
				self:diffusealpha(0):zoom(.4):xy(-SCREEN_CENTER_X + 100, -40):rotationz(90):sleep(1.8):diffusealpha(1)
			end,
			Def.ActorFrame {
				InitCommand = function(self)
					self:bounce():effecttiming(.6, 0, 0, 0, 0):zoom(1.2)
				end,
				Def.Quad {
					Name = "ArrowTop",
					InitCommand = function(self)
						self:SetCustomPosCoords(-9, 1, -6, 3, 6, 1, 12, -4):rotationz(-135):x(-4.5)
							:diffuseshift():effecttiming(.6, 0, 0, 0, 0)
							:effectcolor1(0, 0, 0, 1):effectcolor2(0, 0, 0, 0)
					end
				},
				Def.ActorProxy {
					InitCommand = function(self)
						self:SetTarget(self:GetParent():GetChild("ArrowTop")):zoomx(-1):x(4.5)
					end
				}
			}
		},
		Def.ActorProxy {
			InitCommand = function(self)
				self:SetTarget(self:GetParent():GetChild("Arrow")):zoomx(-1)
			end
		},

		Def.ActorFrame {
			InitCommand = function(self)
				self:rotationz(180):xy(SCREEN_CENTER_X + 240, SCREEN_CENTER_Y - 50):decelerate(.3):x(SCREEN_CENTER_X)
			end,
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(120, 26):halign(0):MaskSource(true)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "Circle.png"),
				InitCommand = function(self)
					self:zoomto(26, 26):x(120):MaskSource()
				end
			},

			Def.Sprite {
				Texture = THEME:GetPathG("", "Circle.png"),
				InitCommand = function(self)
					self:zoomto(30, 30):x(120):diffuse(.5, .5, .5, 1):MaskDest()
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(120, 30):halign(0):diffuse(.5, .5, .5, 1):MaskDest()
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(120, 26):halign(0):MaskSource(true)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "Circle.png"),
				InitCommand = function(self)
					self:zoomto(26, 26):x(120):diffusealpha(.8):MaskDest()
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(120, 26):halign(0):diffusealpha(.8)
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(60, 15):halign(0):diffuse(0, 0, 0, 1):y(-12)
				end
			},
			Def.BitmapText {
				Text = "KEY",
				Font = "IdolM/_squarefont 24px",
				InitCommand = function(self)
					self:zoom(.4):xy(55, -12):halign(0):rotationz(180)
				end
			},
		},

		Def.ActorFrame {
			InitCommand = function(self)
				self:xy(-SCREEN_CENTER_X - 240, -SCREEN_CENTER_Y + 50):decelerate(.3):x(-SCREEN_CENTER_X)
			end,
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(180, 26):halign(0):MaskSource(true)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "Circle.png"),
				InitCommand = function(self)
					self:zoomto(26, 26):x(180):MaskSource()
				end
			},

			Def.Sprite {
				Texture = THEME:GetPathG("", "Circle.png"),
				InitCommand = function(self)
					self:zoomto(30, 30):x(180):diffuse(.5, .5, .5, 1):MaskDest()
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(180, 30):halign(0):diffuse(.5, .5, .5, 1):MaskDest()
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(180, 26):halign(0):MaskSource(true)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "Circle.png"),
				InitCommand = function(self)
					self:zoomto(26, 26):x(180):diffusealpha(.8):MaskDest()
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(180, 26):halign(0):diffusealpha(.8)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "IDOL/circle.png"),
				InitCommand = function(self)
					self:x(175):zoomto(12, 20)
						:customtexturerect(0, 0, 3, 5)
						:diffuse(.5, .5, .5, 1)
				end
			},
			Def.Quad {
				InitCommand = function(self)
					self:zoomto(60, 15):halign(0):diffuse(0, 0, 0, 1):y(-12)
				end
			},
			Def.BitmapText {
				Text = "INFO",
				Font = "IdolM/_squarefont 24px",
				InitCommand = function(self)
					self:zoom(.4):xy(55, -12):halign(1)
				end
			},
			Def.ActorFrame {
				InitCommand = function(self)
					self:xy(90, -10)
				end,
				Def.Quad {
					InitCommand = function(self)
						self:zoomto(40, 40):diffuse(.9, .5, .6, .8)
					end
				},
				Def.Quad {
					InitCommand = function(self)
						self:zoomto(36, 36):diffuse(1, 1, 1, .2)
					end
				},
				Def.Sprite {
					Texture = THEME:GetPathG("", "Circle.png"),
					InitCommand = function(self)
						self:zoomto(15, 15):MaskSource(true)
					end
				},
				Def.Sprite {
					Texture = THEME:GetPathG("", "Circle.png"),
					InitCommand = function(self)
						self:zoomto(30, 30):diffuse(1, 1, 1, 1):MaskDest()
					end
				},
				Def.Sprite {
					Texture = THEME:GetPathG("", "Circle.png"),
					InitCommand = function(self)
						self:zoomto(8, 8):MaskSource(true)
					end
				},
				Def.Sprite {
					Texture = THEME:GetPathG("", "Circle.png"),
					InitCommand = function(self)
						self:zoomto(12, 12):diffuse(1, 1, 1, 1):MaskDest()
					end
				},
			}
		},

		Def.Quad {
			Name = "Filter",
			InitCommand = function(self)
				self:stretchto(-SCREEN_WIDTH, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT):diffuse(0, 0, 0, 0)
			end
		},

		Def.ActorFrameTexture {
			InitCommand = function(self)
				self:SetTextureName("DiffAFT")
					:SetWidth(SCREEN_WIDTH / 2)
					:SetHeight(180)
					:EnableAlphaBuffer(true)
					:Create()
					:Draw()
			end,
			Def.ActorFrame {
				InitCommand = function(self)
					self:xy(SCREEN_CENTER_X / 2, SCREEN_CENTER_Y / 2 + 10)
				end,
				Def.Quad {
					InitCommand = function(self)
						self:diffuse(1, 1, 1, .85):y(-40):zoomto(SCREEN_WIDTH / 2, 180)
					end
				},

				Def.Quad {
					Name = "Corner",
					InitCommand = function(self)
						self:y(-128):diffuse(1, 1, 1, 1):zoomto(SCREEN_WIDTH / 2, 4)
					end
				},
				Def.ActorProxy {
					InitCommand = function(self)
						self:y(-80):SetTarget(self:GetParent():GetChild("Corner")):zoomy(-1)
					end
				},

				Def.ActorFrame {
					Name = "Slider",
					InitCommand = function(self)
						self:xy(-SCREEN_CENTER_X + 214, -40)
					end,
					Def.Quad {
						InitCommand = function(self)
							self:diffuse(0, 0, 0, 1):zoomto(4, 180)
						end
					},
					Def.Quad {
						Name = "Corner",
						InitCommand = function(self)
							self:xy(2, -88):diffuse(0, 0, 0, 1):zoomto(8, 4)
						end
					},
					Def.ActorProxy {
						InitCommand = function(self)
							self:SetTarget(self:GetParent():GetChild("Corner")):zoomy(-1)
						end
					}
				},

				Def.ActorProxy {
					InitCommand = function(self)
						self:SetTarget(self:GetParent():GetChild("Slider")):zoomx(-1)
					end
				}
			}
		},
		Def.ActorFrame {
			Name = "DiffSel",
			InitCommand = function(self)
				self:diffusealpha(0)
			end,
			ShowCommand = function(self)
				self:y(-20):linear(.25):y(10):diffusealpha(1)
			end,
			HideCommand = function(self)
				self:y(10):linear(.25):y(-20):diffusealpha(0)
			end,
			Def.Sprite {
				Texture = "DiffAFT"
			},
			Def.ActorFrame {
				InitCommand = function(self)
					self:y(30)
				end,
				Def.Quad {
					InitCommand = function(self)
						self:y(20):zoomto(SCREEN_WIDTH / 4, 23)
							:MaskSource(true)
					end
				},
				Def.Quad {
					InitCommand = function(self)
						self:xy(8, 20):zoomto(SCREEN_WIDTH / 9.5, 40):halign(0)
							:MaskSource()
					end
				},
				Def.Quad {
					InitCommand = function(self)
						self:xy(-8, 20):zoomto(SCREEN_WIDTH / 9.5, 40):halign(1)
							:MaskSource()
					end
				},
				Def.Quad {
					InitCommand = function(self)
						self:xy(2, 20):zoomto(SCREEN_WIDTH / 8.4, 34):halign(0)
							:MaskSource()
					end
				},
				Def.Quad {
					InitCommand = function(self)
						self:xy(-2, 20):zoomto(SCREEN_WIDTH / 8.4, 34):halign(1)
							:MaskSource()
					end
				},
				Def.Sprite {
					Texture = THEME:GetPathG("", "IDOL/circle.png"),
					InitCommand = function(self)
						self:y(20):zoomto(SCREEN_WIDTH / 4, 40)
							:customtexturerect(0, 0, SCREEN_WIDTH / 4 / 3, 42 / 3)
							:diffuse(0, 0, 0, 1)
							:MaskDest()
					end
				},
				Def.BitmapText {
					Font = "_noto sans 40px",
					Text = "Yes",
					InitCommand = function(self)
						self:xy(-SCREEN_WIDTH / 16, 20):zoom(.5):diffuse(0, 0, 0, 1)
					end
				},
				Def.BitmapText {
					Font = "_noto sans 40px",
					Text = "No",
					InitCommand = function(self)
						self:xy(SCREEN_WIDTH / 16, 20):zoom(.5):diffuse(0, 0, 0, 1)
					end
				}
			},
			Def.Quad {
				Name = "Confirm",
				InitCommand = function(self)
					self:xy(-SCREEN_WIDTH / 16, 64):zoomto(SCREEN_WIDTH / 9.5, 4):rainbow():fadeleft(.2):faderight(.2)
				end
			}
		}
	}
end
