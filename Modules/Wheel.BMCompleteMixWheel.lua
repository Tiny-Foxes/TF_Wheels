-- Difficulty Names.
local DiffNames = {
	"EASY", -- 1 Star
	"NORMAL", -- 2 Stars
	"NORMAL", -- 3 Stars
	"HARD", -- 4 Stars
	"HARD", -- 5 Stars
	"HARD", -- 6 Stars
}

-- We define the curent song if no song is selected.
if not CurSong then CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not CurGroup then GurGroup = "" end

-- Position on the difficulty select that shows up after we picked a song.
if not DiffPos then DiffPos = { [PLAYER_1] = 1, [PLAYER_2] = 1 } end
local DiffPlayer = GAMESTATE:GetMasterPlayerNumber()

-- The increase offset for when we move with postive.
local IncOffset = 1

-- The decrease offset for when we move with negative.
local DecOffset = 5

-- The center offset of the wheel.
local XOffset = 3

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

	if DecOffset > 5 then DecOffset = 1 end
	if IncOffset > 5 then IncOffset = 1 end

	if DecOffset < 1 then DecOffset = 5 end
	if IncOffset < 1 then IncOffset = 5 end

	-- Set the offset for the center of the wheel.
	XOffset = XOffset + offset
	if XOffset > 5 then XOffset = 1 end
	if XOffset < 1 then XOffset = 5 end


	-- If we are calling this command with an offset that is not 0 then do stuff.
	if offset ~= 0 then
		-- For every part on the wheel do.
		for i = 1, 5 do
			-- Calculate current position based on song with a value to get center.
			local pos = CurSong + (2 * offset)

			-- Keep it within reasonable values.
			while pos > #Songs do pos = pos - #Songs end
			while pos < 1 do pos = #Songs + pos end

			-- Transform the wheel, As in make it move.
			self:GetChild("LPCon"):GetChild("LP" .. i):linear(.1):addx((offset * 400))
			self:GetChild("LPCon"):GetChild("LP" .. i):GetChild("Container"):sleep(0):y(320)

			if i == XOffset then
				self:GetChild("LPCon"):GetChild("LP" .. i):GetChild("Container"):sleep(.1):y(340)
			end

			-- Here we define what the wheel does if it is outside the values.
			-- So that when a part is at the bottom it will move to the top.
			if (i == IncOffset and offset == -1) or (i == DecOffset and offset == 1) then
				-- Move wheelpart instantly to new location.
				self:GetChild("LPCon"):GetChild("LP" .. i):sleep(0):addx((offset * 400) * -5)

				-- Check if it's a song.
				if type(Songs[pos]) ~= "string" then
					if Songs[pos][1]:HasBanner() then
						self:GetChild("LPCon"):GetChild("LP" .. i):GetChild("Container"):GetChild("LPPicture")
							:Load(Songs[pos][1]:GetBannerPath())
					else
						self:GetChild("LPCon"):GetChild("LP" .. i):GetChild("Container"):GetChild("LPPicture")
							:Load(THEME:GetPathG("", "white.png"))
					end
				else
					if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then
						self:GetChild("LPCon"):GetChild("LP" .. i):GetChild("Container"):GetChild("LPPicture"):Load(
							SONGMAN:GetSongGroupBannerPath(Songs[pos]))
					else
						self:GetChild("LPCon"):GetChild("LP" .. i):GetChild("Container"):GetChild("LPPicture"):Load(
							THEME:GetPathG("", "white.png"))
					end
				end

				self:GetChild("LPCon"):GetChild("LP" .. i):GetChild("Container"):GetChild("LPPicture")
					:setsize(180, 180)
			end
		end
		-- We are on an offset of 0.
	else
		-- For every part of the wheel do.
		for i = 1, 5 do
			-- Offset for the wheel items.
			local off = i + XOffset

			-- Stay withing limits.
			while off > 5 do off = off - 5 end
			while off < 1 do off = off + 5 end

			-- Get center position.
			local pos = CurSong + i

			-- If item is above 3 then we do a +5 to fix the display.
			if i > 2 then
				pos = CurSong + i - 5
			end

			-- Keep pos withing limits.
			while pos > #Songs do pos = pos - #Songs end
			while pos < 1 do pos = #Songs + pos end

			-- Check if it's a song.
			if type(Songs[pos]) ~= "string" then
				if Songs[pos][1]:HasBanner() then
					self:GetChild("LPCon"):GetChild("LP" .. off):GetChild("Container"):GetChild("LPPicture")
						:Load(Songs[pos][1]:GetBannerPath())
				else
					self:GetChild("LPCon"):GetChild("LP" .. off):GetChild("Container"):GetChild("LPPicture")
						:Load(THEME:GetPathG("", "white.png"))
				end
			else
				if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then
					self:GetChild("LPCon"):GetChild("LP" .. off):GetChild("Container"):GetChild("LPPicture"):Load(
						SONGMAN:GetSongGroupBannerPath(Songs[pos]))
				else
					self:GetChild("LPCon"):GetChild("LP" .. off):GetChild("Container"):GetChild("LPPicture"):Load(
						THEME:GetPathG("", "white.png"))
				end
			end

			self:GetChild("LPCon"):GetChild("LP" .. off):GetChild("Container"):GetChild("LPPicture")
				:setsize(180, 180)
		end
	end

	-- Stop all the music playing, Which is the Song Music
	SOUND:StopMusic()

	-- Check if its a song again.
	if type(Songs[CurSong]) ~= "string" then
		-- Check if a song has a banner, If it doesnt show song title.
		if not Songs[CurSong][1]:HasBanner() then
			self:GetChild("Banner"):visible(false)

			self:GetChild("BannerAFT"):GetChild("BannerText"):settext(Songs[CurSong][1]:GetDisplayMainTitle()):maxwidth(280)
				:maxheight(120):Regen()
		else
			self:GetChild("Banner"):visible(true):Load(Songs[CurSong][1]:GetBannerPath())

			self:GetChild("BannerAFT"):GetChild("BannerText"):settext(""):maxwidth(280):maxheight(120):Regen()
		end

		local Genre = Songs[CurSong][1]:GetGenre()

		if Genre == "" then Genre = "UNKNOWN" end

		self:GetChild("GenreAFT"):GetChild("GenreText"):settext("\"" .. ToLower(Genre) .. "\""):maxwidth(280)
			:maxheight(60):Regen()

		-- Its a group.
	else
		-- Set banner.
		if SONGMAN:GetSongGroupBannerPath(Songs[CurSong]) ~= "" then
			self:GetChild("Banner"):visible(true):Load(SONGMAN:GetSongGroupBannerPath(Songs[CurSong]))

			self:GetChild("BannerAFT"):GetChild("BannerText"):settext(""):maxwidth(280):maxheight(120):Regen()
		else
			self:GetChild("Banner"):visible(false)

			-- Set name to group.
			self:GetChild("BannerAFT"):GetChild("BannerText"):settext(Songs[CurSong]):maxwidth(280):maxheight(120):Regen()
		end

		self:GetChild("GenreAFT"):GetChild("GenreText"):settext("\"pack\""):maxwidth(280):maxheight(60):Regen()
	end

	-- Play Current selected Song Music.
	self:GetChild("MusicCon"):stoptweening():sleep(0.4):queuecommand("PlayCurrentSong")

	-- Resize the Centered Banner  to be w(512/8)*5 h(160/8)*5
	self:GetChild("Banner"):zoom(TF_WHEEL.Resize(self:GetChild("Banner"):GetWidth(), self:GetChild("Banner"):GetHeight(),
		(512 / 12) * 5, (160 / 12) * 5))
end

-- Move the Difficulty (or change selection in this case).
local function MoveDifficulty(self, offset, Songs)
	-- Check if its a group
	if type(Songs[CurSong]) == "string" then
		-- If it is a group hide the diffs
		for i = 1, 6 do
			self:GetChild("Diffs"):GetChild("Star" .. i):visible(false)
		end
		self:GetChild("Diffs"):x(140)
		self:GetChild("Diffs"):GetChild("StarBG6"):visible(false)
		self:GetChild("DiffChart"):visible(false)

		-- Not a group
	else
		for i = 1, 6 do
			self:GetChild("Diffs"):GetChild("Star" .. i):visible(true)
		end
		self:GetChild("Diffs"):x(140)
		self:GetChild("Diffs"):GetChild("StarBG6"):visible(false)
		self:GetChild("DiffChart"):visible(true)
		-- Move the current difficulty + offset.
		DiffPos[DiffPlayer] = DiffPos[DiffPlayer] + offset

		-- Stay withing limits, But ignoring the first selection because its the entire song.
		if DiffPos[DiffPlayer] > #Songs[CurSong] - 1 then DiffPos[DiffPlayer] = 1 end
		if DiffPos[DiffPlayer] < 1 then DiffPos[DiffPlayer] = #Songs[CurSong] - 1 end

		-- Run on every Star, A Star is a part of the Difficulty, We got a max of 6 Stars.
		for i = 1, 6 do
			self:GetChild("Diffs"):GetChild("Star" .. i):diffuse(1, 0, 0, 1):diffusealpha(0)
		end

		-- We get the Meter from the game, And make it so it stays between 6 which is the Max Stars we support.
		local DiffCount = math.floor(Songs[CurSong][DiffPos[DiffPlayer] + 1]:GetMeter() / 2)
		if DiffCount > 6 then DiffCount = 6 end
		if DiffCount < 1 then DiffCount = 1 end

		-- For every Meter value we got for the game, We show the amount of Stars for the difficulty, And center them.
		for i = 1, DiffCount do
			self:GetChild("Diffs"):GetChild("Star" .. i):diffusealpha(1)
			if i == 6 then
				self:GetChild("Diffs"):x(120)
				self:GetChild("Diffs"):GetChild("StarBG6"):visible(true)
			end

		end

		-- Set the name of the Chart Difficulty.
		self:GetChild("DiffChart"):settext(DiffNames[DiffCount]):Regen()
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

	-- All the LPs on the Wheel.
	local LPs = Def.ActorFrame { Name = "LPCon" }

	-- Here we generate all the LPs for the wheel
	for i = 1, 5 do
		-- Position of current song, We want the LP in the front, So its the one we change.
		local pos = CurSong + i - 3

		-- Stay within limits.
		while pos > #GroupsAndSongs do pos = pos - #GroupsAndSongs end
		while pos < 1 do pos = #GroupsAndSongs + pos end

		LPs[#LPs + 1] = Def.ActorFrame {
			Name = "LP" .. i,
			OnCommand = function(self)
				self:xy((i * -400) - (-400 * 3), -300)
			end,
			-- The Container of the LPs.
			Def.ActorFrame {
				Name = "Container",
				OnCommand = function(self)
					self:y(320):zoom(.8)
					if i == 3 then
						self:y(340)
					end
				end,
				Def.ActorProxy {
					Name = "LPBG",
					InitCommand = function(self)
						self:SetTarget(self:ForParent(4):GetChild("LPBGCon"):GetChild("LPBG")):zoom(.9)
					end
				},
				Def.Sprite {
					Name = "LPMask",
					Texture = THEME:GetPathG("", "BM/MaskLP.png"),
					InitCommand = function(self)
						self:zoom(.9):MaskSource(true)
					end
				},
				Def.Sprite {
					Name = "LPPicture",
					-- Load white as fallback.
					Texture = THEME:GetPathG("", "white.png"),
					OnCommand = function(self)
						-- Check if its a song.
						if type(GroupsAndSongs[pos]) ~= "string" then
							-- If the banner exist, Load Banner.png.
							if GroupsAndSongs[pos][1]:HasBanner() then
								self:Load(GroupsAndSongs[pos][1]
									:GetBannerPath())
							end
						else
							-- IF group banner exist, Load banner.png
							if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]) ~= "" then
								self:Load(SONGMAN:GetSongGroupBannerPath(GroupsAndSongs
									[pos]))
							end
						end

						-- Resize the Banner to the size of the Mask.
						self:setsize(180, 180)
							:MaskDest()
							:ztestmode("ZTestMode_WriteOnFail")
					end
				}
			}
		}
	end

	-- The Left and Right Arrows that change when you press Left or Right.
	local Sel = Def.ActorFrame { Name = "Arrows" }

	for i = 1, 2 do
		Sel[#Sel + 1] = Def.ActorFrame {
			Name = "Arrow" .. i,
			OnCommand = function(self)
				self:x(-150)
				if i == 2 then
					self:zoomx(-1):x(150)
				end
			end,
			EnableEffectCommand = function(self)
				self:GetChild("Inside"):diffuseshift():effectcolor1(color("#ec0393")):effectcolor2(color("#b1e425"))
					:effectperiod(.2)
				self:GetChild("Outside"):diffuseshift():effectcolor1(color("#062ebf")):effectcolor2(color("#ff5e03"))
					:effectperiod(.2)
				self:stoptweening():sleep(.3):queuecommand("StopEffect")
			end,
			StopEffectCommand = function(self)
				self:GetChild("Inside"):stopeffect()
				self:GetChild("Outside"):stopeffect()
			end,
			Def.Sprite {
				Name = "Inside",
				Texture = THEME:GetPathG("", "BM/ArrowInside.png"),
				OnCommand = function(self)
					self:diffuse(0, 0, 0, 1)
				end
			},
			Def.Sprite {
				Name = "Outside",
				Texture = THEME:GetPathG("", "BM/ArrowOutside.png")
			}
		}
	end

	-- The Difficulty Display.
	local Diff = Def.ActorFrame { Name = "Diffs", }

	-- The amount of Star we use to display the Difficulty using the Meter.
	for i = 1, 6 do
		Diff[#Diff + 1] = Def.ActorProxy {
			Name = "StarBG" .. i,
			InitCommand = function(self)
				self:SetTarget(self:ForParent(2):GetChild("BGStar")):x(35 * (i - 4.5))
				if i == 6 then self:visible(false) end
			end
		}
		Diff[#Diff + 1] = Def.Sprite {
			Name = "Star" .. i,
			Texture = THEME:GetPathG("", "StarSharp.png"),
			InitCommand = function(self)
				self:zoom(.04):x(35 * (i - 4.5))
				if i == 6 then self:visible(false) end
			end
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
			self:GetChild("MusicCon"):sleep(0):queuecommand("PlayCurrentSong")

			-- Initalize the Difficulties.
			if not DiffPlayer then DiffPlayer = PLAYER_1 end
			MoveDifficulty(self, 0, GroupsAndSongs)
		end,
		
		-- Play Music at start of screen,.
		Def.ActorFrame {
			Name = "MusicCon",
			PlayCurrentSongCommand = function(self)
				if type(GroupsAndSongs[CurSong]) ~= "string" then
					TF_WHEEL.BG:Load(GroupsAndSongs[CurSong][1]:GetBackgroundPath()):FullScreen()
					if GroupsAndSongs[CurSong][1].PlayPreviewMusic then
						GroupsAndSongs[CurSong][1]:PlayPreviewMusic()
					elseif GroupsAndSongs[CurSong][1]:GetMusicPath() then
						SOUND:PlayMusicPart(GroupsAndSongs[CurSong][1]:GetMusicPath(),
							GroupsAndSongs[CurSong][1]:GetSampleStart(),
							GroupsAndSongs[CurSong][1]:GetSampleLength(), 0, 0, true)
					end
				else
					TF_WHEEL.BG:Load(THEME:GetPathG("Common", "fallback background")):FullScreen()
				end
			end
		},

		-- Do stuff when a user presses left on Pad or Menu buttons.
		MenuLeftCommand = function(self)
			self:GetChild("Arrows"):GetChild("Arrow1"):queuecommand("EnableEffect")
			MoveSelection(self, -1, GroupsAndSongs)
			MoveDifficulty(self, 0, GroupsAndSongs)
		end,

		-- Do stuff when a user presses Right on Pad or Menu buttons.
		MenuRightCommand = function(self)
			self:GetChild("Arrows"):GetChild("Arrow2"):queuecommand("EnableEffect")
			MoveSelection(self, 1, GroupsAndSongs)
			MoveDifficulty(self, 0, GroupsAndSongs)
		end,

		-- Do stuff when a user presses the Down on Pad or Menu buttons.
		MenuDownCommand = function(self) MoveDifficulty(self, 1, GroupsAndSongs) end,

		-- Do stuff when a user presses the Down on Pad or Menu buttons.
		MenuUpCommand = function(self) MoveDifficulty(self, -1, GroupsAndSongs) end,

		-- Do stuff when a user presses the Back on Pad or Menu buttons.
		BackCommand = function(self)
			-- Check if User is joined.
			if GAMESTATE:IsSideJoined(self.pn) then
				if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
					-- If both players are joined, We want to unjoin the player that pressed back.
					GAMESTATE:UnjoinPlayer(self.pn)
				else
					-- Go to the previous screen.
					SCREENMAN:GetTopScreen():SetNextScreenName(SCREENMAN:GetTopScreen():GetPrevScreenName())
						:StartTransitioningScreen("SM_GoToNextScreen")
				end
			end
		end,

		-- Do stuff when a user presses the Start on Pad or Menu buttons.
		StartCommand = function(self)
			-- Check if we want to go to ScreenPlayerOptions instead of ScreenGameplay.
			if StartOptions then
				SCREENMAN:GetTopScreen():SetNextScreenName("ScreenPlayerOptions"):StartTransitioningScreen(
					"SM_GoToNextScreen")
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
					--We use PlayMode_Regular for now.
					GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")

					--Set the song we want to play.
					GAMESTATE:SetCurrentSong(GroupsAndSongs[CurSong][1])

					-- Check if 2 players are joined.
					if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
						-- If they are, We will use Versus.
						GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDBVersus[Style])

						-- Save Profiles.
						PROFILEMAN:SaveProfile(PLAYER_1)
						PROFILEMAN:SaveProfile(PLAYER_2)

						-- Set the Current Steps to use.
						GAMESTATE:SetCurrentSteps(PLAYER_1, GroupsAndSongs[CurSong][DiffPos[DiffPlayer] + 1])
						GAMESTATE:SetCurrentSteps(PLAYER_2, GroupsAndSongs[CurSong][DiffPos[DiffPlayer] + 1])
					else
						-- If we are single player, Use Single.
						GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDB[Style])

						-- Save Profile.
						PROFILEMAN:SaveProfile(self.pn)

						-- Set the Current Step to use.
						GAMESTATE:SetCurrentSteps(self.pn, GroupsAndSongs[CurSong][DiffPos[DiffPlayer] + 1])
					end

					-- We want to go to player options when people doublepress, So we set the StartOptions to true,
					-- So when the player presses Start again, It will go to player options.
					StartOptions = true

					-- Wait 0.4 sec before we go to next screen.
					self:sleep(0.4):queuecommand("StartSong")
				end
			else
				-- If no player is active Join.
				GAMESTATE:JoinPlayer(self.pn)

				-- Load the profles.
				GAMESTATE:LoadProfiles()

				-- Set DiffPlayer to current master player
				DiffPlayer = GAMESTATE:GetMasterPlayerNumber()

				-- Set Style Text to VERSUS when 2 Players.
				if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
					self:GetChild("Style"):settext("VERSUS")
				end
			end
		end,

		-- Change to ScreenGameplay.
		StartSongCommand = function(self)
			SCREENMAN:GetTopScreen():SetNextScreenName("ScreenLoadGameplayElements"):StartTransitioningScreen(
				"SM_GoToNextScreen")
		end,

		-- The LP Background.
		Def.ActorFrame {
			Name = "LPBGCon",
			-- We define the zoom as 0 to hide the LP Background,
			-- Because we use an ActorProxy to display it.
			OnCommand = function(self) self:zoom(0) end,
			Def.Sprite {
				Name = "LPBG",
				Texture = THEME:GetPathG("", "BM/LP.png")
			}
		},

		LPs,

		Def.Sprite {
			Texture = THEME:GetPathG("", "BM/BannerCon.png"),
			OnCommand = function(self)
				self:zoom(0.75)
					:y(-80)
			end
		},

		-- Load the Global Centered Banner.
		Def.Sprite {
			Name = "Banner",
			Texture = THEME:GetPathG("", "white.png"),
			OnCommand = function(self)
				-- Check if we are on song
				if type(GroupsAndSongs[CurSong]) ~= "string" then
					self:Load(GroupsAndSongs[CurSong][1]:GetBannerPath())

					-- Not on song, Show group banner.
				else
					if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[CurSong]) ~= "" then
						self:Load(SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[CurSong]))
					else
						self:visible(false)
					end
				end

				self:y(-70):zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), (512 / 12) * 5, (160 / 12) * 5))
			end
		},

		Def.ActorFrameTexture {
			Name = "BannerAFT",
			InitCommand = function(self)
				self:SetTextureName("BannerAFT")
					:SetWidth(280)
					:SetHeight(120)
					:EnableAlphaBuffer(true)
					:Create()
					:Draw()
			end,
			-- Global Centered Banner Text, Incase there is no banner.
			Def.Text {
				Name = "BannerText",
				--Fallback = THEME:GetPathF("", "NotoSans-All.ttf"),
				Font = THEME:GetPathF("", "BM/forgotten-futurist.rg-bold.ttf"),
				Size = 100,
				OnCommand = function(self)
					-- Check if we are on group.
					if type(GroupsAndSongs[CurSong]) == "string" then
						-- Check if group has banner, If so, Set text to empty
						if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[CurSong]) == "" then
							self:settext(GroupsAndSongs[CurSong]):maxwidth(280):maxheight(120):Regen()
						end
						-- not group.
					else
						-- Check if we have banner, if not, set text to song title.
						if not GroupsAndSongs[CurSong][1]:HasBanner() then
							self:settext(GroupsAndSongs[CurSong][1]:GetDisplayMainTitle()):maxwidth(280):maxheight(120)
								:Regen()
						end
					end

					self:MainActor():xy(140, 60)
					self:StrokeActor():diffusealpha(0)
				end
			}
		},

		Def.Sprite {
			Texture = "BannerAFT",
			OnCommand = function(self)
				self:y(-50):cropbottom(.32):diffusetopedge(0, .5, 1, 1)
			end
		},

		Def.Sprite {
			Texture = "BannerAFT",
			OnCommand = function(self)
				self:y(-50):croptop(.32):diffuse(1, .5, 0, 1):diffusebottomedge(1, 1, 0, 1)
			end
		},

		Def.ActorFrameTexture {
			Name = "GenreAFT",
			InitCommand = function(self)
				self:SetTextureName("GenreAFT")
					:SetWidth(280)
					:SetHeight(60)
					:EnableAlphaBuffer(true)
					:Create()
					:Draw()
			end,
			-- Global Centered Banner Text, Incase there is no banner.
			Def.Text {
				Name = "GenreText",
				--Fallback = THEME:GetPathF("", "NotoSans-All.ttf"),
				Font = THEME:GetPathF("", "BM/forgotten-futurist.rg-bold.ttf"),
				Size = 60,
				OnCommand = function(self)
					-- Check if we are on group.
					if type(GroupsAndSongs[CurSong]) == "string" then
						-- Check if group has banner, If so, Set text to empty
						self:settext("\"pack\""):maxwidth(280):maxheight(60):Regen()
						-- not group.
					else
						local Genre = GroupsAndSongs[CurSong][1]:GetGenre()
						if Genre == "" then Genre = "UNKNOWN" end

						-- Check if we have banner, if not, set text to song title.
						self:settext("\"" .. ToLower(Genre) .. "\""):maxwidth(280)
							:maxheight(60):Regen()
					end

					self:MainActor():xy(140, 30)
					self:StrokeActor():diffusealpha(0)
				end
			}
		},

		Def.Sprite {
			Texture = "GenreAFT",
			OnCommand = function(self)
				self:y(-105):cropbottom(.32):diffusetopedge(0, .5, 1, 1)
			end
		},

		Def.Sprite {
			Texture = "GenreAFT",
			OnCommand = function(self)
				self:y(-105):croptop(.32):diffuse(1, .5, 0, 1):diffusebottomedge(1, 1, 0, 1)
			end
		},

		Def.Text {
			Font = THEME:GetPathF("", "BM/BadComic-2OXnX.ttf"),
			Size = 40,
			OnCommand = function(self)
				self:settext("SOUND SELECT"):Regen()
				self:y(-160)
			end
		},

		Def.ActorFrame {
			Name = "BGStar",
			OnCommand = function(self)
				self:visible(false)
			end,
			Def.Sprite {
				Texture = THEME:GetPathG("", "StarSharp.png"),
				InitCommand = function(self)
					self:zoom(.02)
						:MaskSource(true)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "StarSharp.png"),
				InitCommand = function(self)
					self:zoom(.05)
						:MaskDest()
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "StarSharp.png"),
				InitCommand = function(self)
					self:zoom(.04):diffuse(0, 0, 0, 1)
						:MaskDest()
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "StarSharp.png"),
				InitCommand = function(self)
					self:zoom(.03)
						:MaskDest()
				end
			}
		},

		-- The Difficulty Star Meter.
		Diff .. { OnCommand = function(self) self:xy(140, 10) end },

		Sel .. { OnCommand = function(self) self:y(80) end },

		-- The Difficulty Chart Names based on Meter.
		Def.Text {
			Name = "DiffChart",
			Font = THEME:GetPathF("", "BM/forgotten-futurist.rg-regular.ttf"),
			Size = 60,
			StrokeSize = 5,
			OnCommand = function(self)
				self:y(60):zoomy(.6)
				self:MainActor():diffuse(0, 0, 0, 1)
				self:StrokeActor():diffuse(1, 1, 0, 1)
			end
		},

		Def.Text {
			Text = "play level",
			Font = THEME:GetPathF("", "BM/forgotten-futurist.rg-bold.ttf"),
			Size = 40,
			StrokeSize = 2,
			OnCommand = function(self)
				self:xy(-90, 20):zoomy(.6)
				self:MainActor():diffuse(0, 0, 0, 1)
				self:StrokeActor():diffuse(1, 1, 1, 1)
			end
		}
	}
end
