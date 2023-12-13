-- Global Colour to define the colour of the wheel, Change this if orange isnt your flavour.
local DisplayColor = { 1, .5, 0, 1 }

-- Difficulty Colours
local DiffColors = {
	color("#00b4ff"), -- Difficulty_Beginner
	color("#ffad00"), -- Difficulty_Easy
	color("#e333ac"), -- Difficulty_Medium
	color("#6eff00"), -- Difficulty_Hard
	color("#1881cb"), -- Difficulty_Challenge
	color("#888888") -- Difficulty_Edit
}

-- Grooveradar Inside Colours.
local DiffColorsInside = {
	color("#00b4ff88"), -- Difficulty_Beginner
	color("#ffad0088"), -- Difficulty_Easy
	color("#e333ac88"), -- Difficulty_Medium
	color("#6eff0088"), -- Difficulty_Hard
	color("#1881cb88"), -- Difficulty_Challenge
	color("#88888888") -- Difficulty_Edit
}

-- Difficulty Names.
-- https://en.wikipedia.org/wiki/Dance_Dance_Revolution#Difficulty
local DiffNames = {
	"BEGINNER", -- Difficulty_Beginner
	"LIGHT", -- Difficulty_Easy
	"STANDARD", -- Difficulty_Medium
	"HEAVY ", -- Difficulty_Hard
	"ONI",   -- Difficulty_Challenge
	"EDIT"   -- Difficulty_Edit
}
local DiffImage = {
	-- 習/楽/踊/激/鬼/創 -- Thanks paraph.
	"習", -- Difficulty_Beginner
	"楽", -- Difficulty_Easy
	"踊", -- Difficulty_Medium
	"激", -- Difficulty_Hard
	"鬼", -- Difficulty_Challenge
	"創" -- Difficulty_Edit
}

local GrooveRadarNames = {
	--[[
		STREAM: 全体密度
		VOLTAGE: 最大密度
		AIR: ジャンプ度
		FREEZE: 踏みっぱ度
		CHAOS: 変則度
	--]] -- Thanks paraph.
	"全体密度\nSTREAM",
	"変則度\nCHAOS",
	"踏みっぱ度\nFREEZE",
	"ジャンプ度\nAIR",
	"最大密度\nVOLTAGE"
}

-- We define the curent song if no song is selected.
if not TF_WHEEL.CurSong then TF_WHEEL.CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not TF_WHEEL.CurGroup then TF_WHEEL.CurGroup = "" end

-- Position on the difficulty select that shows up after we picked a song.
if not TF_WHEEL.DiffPos then TF_WHEEL.DiffPos = { [PLAYER_1] = 1, [PLAYER_2] = 1 } end

-- The increase offset for when we move with postive.
local IncOffset = 1

-- The decrease offset for when we move with negative.
local DecOffset = 13

-- The center offset of the wheel.
local XOffset = 7

-- Move the wheel, We define the Offset using +1 or -1.
-- We parse the Songs also so we can get the amount of songs.
local function MoveSelection(self, offset, Songs)
	-- Curent Song + Offset.
	TF_WHEEL.CurSong = TF_WHEEL.CurSong + offset

	-- Check if curent song is further than Songs if so, reset to 1.
	if TF_WHEEL.CurSong > #Songs then TF_WHEEL.CurSong = 1 end
	-- Check if curent song is lower than 1 if so, grab last song.
	if TF_WHEEL.CurSong < 1 then TF_WHEEL.CurSong = #Songs end

	-- Set the offsets for increase and decrease.
	DecOffset = DecOffset + offset
	IncOffset = IncOffset + offset

	if DecOffset > 13 then DecOffset = 1 end
	if IncOffset > 13 then IncOffset = 1 end

	if DecOffset < 1 then DecOffset = 13 end
	if IncOffset < 1 then IncOffset = 13 end

	-- Set the offset for the center of the wheel.
	XOffset = XOffset + offset
	if XOffset > 13 then XOffset = 1 end
	if XOffset < 1 then XOffset = 13 end

	-- If we are calling this command with an offset that is not 0 then do stuff.
	if offset ~= 0 then
		-- For every part on the wheel do.
		for i = 1, 13 do
			-- Make a transform command that changes the location of the part.
			local transform = ((i - XOffset) * (i - XOffset)) * 3

			-- If the part is outside the decrease and increase value then transform it.
			if DecOffset < i and DecOffset > XOffset then
				transform = ((13 - i + XOffset) * (13 - i + XOffset)) * 3
			end

			-- If the part is inside the decrease and increase value then transform it.
			if IncOffset > i and DecOffset < XOffset then
				transform = ((13 + i - XOffset) * (13 + i - XOffset)) * 3
			end

			-- Calculate current position based on song with a value to get center.
			local pos = TF_WHEEL.CurSong + (6 * offset)

			-- Keep it within reasonable values.
			while pos > #Songs do pos = pos - #Songs end
			while pos < 1 do pos = #Songs + pos end

			-- Transform the wheel, As in make it move.
			self:GetChild("Wheel"):GetChild("Container" .. i):linear(.1):x(transform):addy((offset * -45))

			-- Here we define what the wheel does if it is outside the values.
			-- So that when a part is at the bottom it will move to the top.
			if (i == IncOffset and offset == -1) or (i == DecOffset and offset == 1) then
				-- Move wheelpart instantly to new location.
				self:GetChild("Wheel"):GetChild("Container" .. i):sleep(0):addy((offset * -45) * -13)

				-- Check if it's a song.
				if type(Songs[pos]) ~= "string" then
					-- It's a song, Display song title.
					self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Title"):settext(Songs[pos][1]
					:GetDisplayMainTitle())
				else
					-- It is not a song, Display group name instead.
					self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Title"):settext(Songs[pos])
				end

				-- Set the width of the text.
				self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Title"):zoom(.6):y(-8):maxwidth(400)

				-- Check if it's a song.
				if type(Songs[pos]) ~= "string" then
					-- Check if song has subtitle.
					if Songs[pos][1]:GetDisplaySubTitle() ~= "" then
						-- It does have a subtitle so resize the title to fit it.
						self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Title"):zoom(.4):y(-10):maxwidth(650)
					end

					-- Set subtitle and artist to the values it has.
					self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("SubTitle"):settext(Songs[pos][1]
					:GetDisplaySubTitle())
					self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Artist"):settext("/" ..
					Songs[pos][1]:GetDisplayArtist())
				else
					self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Title"):y(0)

					-- It is not a song so we set it to empty, Because groups dont have subtitles or atists.
					self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("SubTitle"):settext("")
					self:GetChild("Wheel"):GetChild("Container" .. i):GetChild("Artist"):settext("")
				end
			end
		end

		-- We have a top banner and an under banner to make smooth transisions between songs.

		-- Check if it's a song.
		if type(Songs[TF_WHEEL.CurSong]) ~= "string" then
			-- It is a song, so we load the under banner.
			self:GetChild("BannerUnderlay"):visible(1):Load(Songs[TF_WHEEL.CurSong][1]:GetBannerPath())
		else
			-- It is not a song, Do an extra check to see if group has banner.
			if SONGMAN:GetSongGroupBannerPath(Songs[TF_WHEEL.CurSong]) ~= "" then
				-- It does, Display it.
				self:GetChild("BannerUnderlay"):visible(1):Load(SONGMAN:GetSongGroupBannerPath(Songs[TF_WHEEL.CurSong]))
			else
				-- It doesnt, Hide it.
				self:GetChild("BannerUnderlay"):visible(0)
			end
		end

		-- Now we resize the banner to the proper size we want.
		self:GetChild("BannerUnderlay"):zoom(TF_WHEEL.Resize(self:GetChild("BannerUnderlay"):GetWidth(),
			self:GetChild("BannerUnderlay"):GetHeight(), 256, 80))

		-- Load the top banner, This one shows when its done transitioning.
		self:GetChild("BannerOverlay"):diffusealpha(1):linear(.1):diffusealpha(0):sleep(0):queuecommand("Load")
			:diffusealpha(1)

		-- Change CDTitle.
		self:GetChild("CDTitle"):queuecommand("Load")

		-- We are on an offset of 0.
	else
		-- For every part of the wheel do.
		for i = 1, 13 do
			-- Offset for the wheel items.
			local off = i + XOffset

			-- Stay withing limits.
			while off > 13 do off = off - 13 end
			while off < 1 do off = off + 13 end

			-- Get center position.
			local pos = TF_WHEEL.CurSong + i

			-- If item is above 6 then we do a +13 to fix the display.
			if i > 6 then
				pos = TF_WHEEL.CurSong + i - 13
			end

			-- Keep pos withing limits.
			while pos > #Songs do pos = pos - #Songs end
			while pos < 1 do pos = #Songs + pos end

			-- Check if it's a song.
			if type(Songs[pos]) ~= "string" then
				-- It's a song, Display song title.
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Title"):settext(Songs[pos][1]
				:GetDisplayMainTitle())
			else
				-- It is not a song, Display group name instead.
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Title"):settext(Songs[pos])
			end

			-- Set the width of the text.
			self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Title"):zoom(.6):y(-8):maxwidth(400)

			-- Check if it's a song.
			if type(Songs[pos]) ~= "string" then
				-- Check if song has subtitle.
				if Songs[pos][1]:GetDisplaySubTitle() ~= "" then
					-- It does have a subtitle so resize the title to fit it.
					self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Title"):zoom(.4):y(-10):maxwidth(650)
				end

				-- Set subtitle and artist to the values it has.
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("SubTitle"):settext(Songs[pos][1]
				:GetDisplaySubTitle())
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Artist"):settext("/" ..
					Songs[pos][1]:GetDisplayArtist())
			else
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Title"):y(0)
				-- It is not a song so we set it to empty, Because groups dont have subtitles or atists.
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("SubTitle"):settext("")
				self:GetChild("Wheel"):GetChild("Container" .. off):GetChild("Artist"):settext("")
			end
		end
	end

	-- Check if offset is not 0.
	if offset ~= 0 then
		self:GetChild("BPMDummy"):GetChild("Num"):stoptweening():queuecommand("BPMChange")
		self:GetChild("BPMDummy"):GetChild("Text"):stoptweening():queuecommand("BPMChange")
		self:GetChild("BPM"):stoptweening():linear(.1):y(-155):sleep(0):y(-120)
		self:GetChild("BPMDummy"):stoptweening():linear(.1):y(-120):sleep(0):y(-95)
		self:GetChild("BPM"):GetChild("Num"):stoptweening():sleep(.1):queuecommand("BPMChange")
		self:GetChild("BPM"):GetChild("Text"):stoptweening():sleep(.1):queuecommand("BPMChange")

		-- Stop all the music playing, Which is the Song Music
		SOUND:StopMusic()

		-- Play Current selected Song Music.
		self:GetChild("MusicCon"):stoptweening():sleep(0.4):queuecommand("PlayCurrentSong")
	end
end

-- Change the cursor of Player on the difficulty selector.
local function MoveDifficulty(self, offset, Songs)
	-- check if player is joined.
	if offset == 0 then
		for _, v in pairs(GAMESTATE:GetHumanPlayers()) do
			if TF_WHEEL.DiffPos[v] < 1 then TF_WHEEL.DiffPos[v] = 1 end
			if TF_WHEEL.DiffPos[v] > #Songs[TF_WHEEL.CurSong] - 1 then TF_WHEEL.DiffPos[v] = #Songs[TF_WHEEL.CurSong] - 1 end
		end

		-- Call the move selecton command to update the graphical location of cursor.
		MoveSelection(self, 0, Songs)
	elseif self.pn and GAMESTATE:IsSideJoined(self.pn) then
		-- Move cursor.
		TF_WHEEL.DiffPos[self.pn] = TF_WHEEL.DiffPos[self.pn] + offset

		-- Keep within boundaries.
		if TF_WHEEL.DiffPos[self.pn] < 1 then TF_WHEEL.DiffPos[self.pn] = 1 end
		if TF_WHEEL.DiffPos[self.pn] > #Songs[TF_WHEEL.CurSong] - 1 then TF_WHEEL.DiffPos[self.pn] = #Songs[TF_WHEEL.CurSong] - 1 end

		-- Call the move selecton command to update the graphical location of cursor.
		MoveSelection(self, 0, Songs)
	end

	for i = 1, 2 do
		if type(Songs[TF_WHEEL.CurSong]) ~= "string" then
			if GAMESTATE:IsSideJoined(((i == 1) and PLAYER_1 or PLAYER_2)) then
				self:GetChild("Diffs"):GetChild("Radar" .. i):GetChild("GrooveBG"):diffusealpha(1):playcommand("Move",
					{ .1, .5, true, i == 1, TF_WHEEL.DiffPos, Songs })
				self:GetChild("Diffs"):GetChild("Radar" .. i):GetChild("GrooveLine"):diffusealpha(1):playcommand("Move",
					{ .1, 1, false, i == 1, TF_WHEEL.DiffPos, Songs })
				self:GetChild("Diffs"):GetChild("DiffCon" .. i):visible(true)
				self:GetChild("Diffs"):GetChild("DiffCon" .. i):GetChild("DiffText"):settext(DiffImage[
				TF_WHEEL.DiffTab[Songs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[(i == 1) and PLAYER_1 or PLAYER_2] + 1]:GetDifficulty()]])
				self:GetChild("Diffs"):GetChild("DiffCon" .. i):GetChild("DiffBG"):diffuse(DiffColors[
				TF_WHEEL.DiffTab[Songs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[(i == 1) and PLAYER_1 or PLAYER_2] + 1]:GetDifficulty()]])
			else
				self:GetChild("Diffs"):GetChild("DiffCon" .. i):visible(false)
				self:GetChild("Diffs"):GetChild("Radar" .. i):GetChild("GrooveBG"):diffusealpha(0)
				self:GetChild("Diffs"):GetChild("Radar" .. i):GetChild("GrooveLine"):diffusealpha(0)
			end
		else
			self:GetChild("Diffs"):GetChild("DiffCon" .. i):visible(false)
			self:GetChild("Diffs"):GetChild("Radar" .. i):GetChild("GrooveBG"):diffusealpha(0):playcommand("Move",
				{ .1, .5, true, i == 1, TF_WHEEL.DiffPos, Songs })
			self:GetChild("Diffs"):GetChild("Radar" .. i):GetChild("GrooveLine"):diffusealpha(0):playcommand("Move",
				{ .1, 1, false, i == 1, TF_WHEEL.DiffPos, Songs })
		end
	end
end

-- This is the main function, Its the function that contains the wheel.
return function(Style)
	-- Load the songs from the Songs.Loader module.
	local Songs = LoadModule("Songs.Loader.lua")(Style)

	-- Sort the Songs and Group.
	local GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs, TF_WHEEL.CurGroup)

	-- We define here is we load the Options menu when people double press,
	-- Because they need to double press it starts at false.
	local StartOptions = false

	-- The actual wheel.
	local Wheel = Def.ActorFrame { Name = "Wheel" }

	-- The difficulties.
	local Diffs = Def.ActorFrame { Name = "Diffs" }

	-- Groove Radar Name.
	local GRName = Def.ActorFrame { Name = "GRName" }

	-- For every item on the wheel do.
	for i = 1, 13 do
		-- Grab center of wheel.
		local offset = i - 7

		-- Also grab center of wheel.
		local pos = TF_WHEEL.CurSong + i - 7

		-- But we keep it within limits.
		while pos > #GroupsAndSongs do pos = pos - #GroupsAndSongs end
		while pos < 1 do pos = #GroupsAndSongs + pos end

		-- Append to the wheel.
		Wheel[#Wheel + 1] = Def.ActorFrame {
			Name = "Container" .. i,

			-- Set position of item.
			OnCommand = function(self) self:xy((offset * offset) * 3, offset * 45) end,

			Def.Sprite {
				Texture = THEME:GetPathG("", "DDR/BackPlate"),
				OnCommand = function(self)
					self:zoom(.35):halign(0):x(-20)
						:diffuse(DisplayColor[1] / 2, DisplayColor[2] / 2, DisplayColor[3] / 2, DisplayColor[4])
				end
			},

			-- Song Title for on wheel.
			Def.BitmapText {
				Name = "Title",
				Font = "_noto sans 40px",
				OnCommand = function(self)
					-- Check if we are on group.
					if type(GroupsAndSongs[pos]) == "string" then
						-- Show group name.
						self:settext(GroupsAndSongs[pos])
						-- not group.
					else
						-- Show song title.
						self:settext(GroupsAndSongs[pos][1]:GetDisplayMainTitle())
					end

					-- Set the size of the text and the location.
					self:zoom(.4):halign(0):y(-10):maxwidth(640):skewx(-.2)
						:diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3], DisplayColor[4])
						:strokecolor(DisplayColor[1] / 1.5, DisplayColor[2] / 1.5, DisplayColor[3] / 1.5, DisplayColor
						[4])

					-- Check if it's a song.
					if type(GroupsAndSongs[pos]) ~= "string" then
						-- Check if song subtitle is empty.
						if GroupsAndSongs[pos][1]:GetDisplaySubTitle() == "" then
							-- Its empty, Make title full size.
							self:zoom(.6):y(-8):maxwidth(400)
						end
					else
						-- It's not a song, And groups dont have subtitles.
						self:zoom(.6):y(0):maxwidth(400)
					end
				end
			},

			-- The subtitle.
			Def.BitmapText {
				Name = "SubTitle",
				Font = "_noto sans 40px",
				OnCommand = function(self)
					-- Check if we are on group.
					if type(GroupsAndSongs[pos]) ~= "string" then
						-- Set Subtitle.
						self:settext(GroupsAndSongs[pos][1]:GetDisplaySubTitle())
					end

					-- Set size and colour.
					self:zoom(.3):halign(0):maxwidth(650):skewx(-.2)
						:diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3], DisplayColor[4])
						:strokecolor(DisplayColor[1] / 1.5, DisplayColor[2] / 1.5, DisplayColor[3] / 1.5, DisplayColor
						[4])
				end
			},
			Def.BitmapText {
				Name = "Artist",
				Font = "_noto sans 40px",
				OnCommand = function(self)
					-- Check if we are on group.
					if type(GroupsAndSongs[pos]) ~= "string" then
						-- Set artist.
						self:settext("/" .. GroupsAndSongs[pos][1]:GetDisplayArtist())
					end

					-- Set size and colour.
					self:zoom(.3):halign(0):y(10):maxwidth(650):skewx(-.2)
						:diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3], DisplayColor[4])
						:strokecolor(DisplayColor[1] / 1.5, DisplayColor[2] / 1.5, DisplayColor[3] / 1.5, DisplayColor
						[4])
				end
			}
		}
	end

	local function MoveFunction(self, param)
		--local colour = param[4] and {DisplayColor[1],DisplayColor[2],DisplayColor[3],param[2]} or {DisplayColor[3],DisplayColor[2],DisplayColor[1],param[2]}
		local colour = { 1, 1, 1, 1 }
		local zero = { { 0, 0, 0 }, colour }

		if type(param[6][TF_WHEEL.CurSong]) ~= "string" then
			local Val = {}
			colour = param[3] and
				DiffColorsInside[TF_WHEEL.DiffTab[param[6][TF_WHEEL.CurSong][param[5][param[4] and PLAYER_1 or PLAYER_2] + 1]:GetDifficulty()]]
				or DiffColors
				[TF_WHEEL.DiffTab[param[6][TF_WHEEL.CurSong][param[5][param[4] and PLAYER_1 or PLAYER_2] + 1]:GetDifficulty()]]
			zero = { { 0, 0, 0 }, colour }
			for i = 0, 4 do
				local temp = param[6][TF_WHEEL.CurSong][param[5][param[4] and PLAYER_1 or PLAYER_2] + 1]:GetRadarValues(param[4] and
					PLAYER_1
					or PLAYER_2):GetValue(i)
				Val[#Val + 1] = (temp < 1) and temp or 1
			end

			if param[3] then
				self:linear(param[1])
					:SetVertices({
						{ { -80 * Val[2], -25 * Val[2], 0 }, colour }, zero,
						{ { 0, -85 * Val[1], 0 },            colour }, { { 0, -85 * Val[1], 0 }, colour }, zero,
						{ { 80 * Val[5], -25 * Val[5], 0 }, colour }, { { 80 * Val[5], -25 * Val[5], 0 }, colour }, zero,
						{ { 45 * Val[4], 70 * Val[4], 0 },  colour }, { { 45 * Val[4], 70 * Val[4], 0 }, colour }, zero,
						{ { -45 * Val[3], 70 * Val[3], 0 },  colour }, { { -45 * Val[3], 70 * Val[3], 0 }, colour }, zero,
						{ { -80 * Val[2], -25 * Val[2], 0 }, colour }
					})
			else
				self:linear(param[1])
					:SetVertices({
						{ { -80 * Val[2], -25 * Val[2], 0 }, colour },
						{ { 0, -85 * Val[1], 0 },            colour },
						{ { 80 * Val[5], -25 * Val[5], 0 },  colour },
						{ { 45 * Val[4], 70 * Val[4], 0 },   colour },
						{ { -45 * Val[3], 70 * Val[3], 0 },  colour },
						{ { -80 * Val[2], -25 * Val[2], 0 }, colour }
					})
			end
		else
			local empty = {}

			for i = 1, param[3] and 15 or 6 do
				empty[#empty + 1] = zero
			end

			self:linear(param[1])
				:SetVertices(empty)
		end
	end

	for i = 0, 1 do
		Diffs[#Diffs + 1] = Def.ActorFrame {
			Name = "DiffCon" .. i + 1,
			OnCommand = function(self)
				self:zoom(.35):xy(-280 + (i * 200), 10):visible(GAMESTATE:IsSideJoined(((i == 0) and PLAYER_1 or PLAYER_2)))
			end,
			Def.Sprite {
				Texture = THEME:GetPathG("", "DDR/DiffMAX"),
				OnCommand = function(self)
					self:diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3], 1)
						:zoomx(i == 0 and 1 or -1):x(i * -120)
				end
			},
			Def.Quad {
				OnCommand = function(self)
					self:zoomto(100, 100):xy(-60, 0)
						:diffuse(0, 0, 0, 1)
				end
			},
			Def.Quad {
				Name = "DiffBG",
				OnCommand = function(self)
					self:zoomto(80, 80):xy(-60, 0)
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						self:diffuse(DiffColors[
						TF_WHEEL.DiffTab[GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[i == 0 and PLAYER_1 or PLAYER_2] + 1]:GetDifficulty()]])
					end
				end
			},
			Def.BitmapText {
				Name = "DiffText",
				Font = "_noto sans 40px",
				OnCommand = function(self)
					self:zoom(2):xy(-60, 0):maxwidth(40)
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						self:settext(DiffImage[
						TF_WHEEL.DiffTab[GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[i == 0 and PLAYER_1 or PLAYER_2] + 1]:GetDifficulty()]])
					end
				end
			},
			Def.BitmapText {
				Font = "_noto sans 40px",
				Text = (i + 1) .. "P",
				OnCommand = function(self)
					self:zoomy(1.5):zoomx(2):xy(70 + (i * -260), -30)
						:diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3], 1)
				end
			}
		}

		Diffs[#Diffs + 1] = Def.ActorFrame {
			Name = "Radar" .. (i == 0 and 2 or 1),
			Def.ActorMultiVertex {
				Name = "GrooveBG",
				InitCommand = function(self)
					self:SetDrawState { Mode = "DrawMode_Triangles" }
						:xy(-200, 120)
						:playcommand("Move", { 0, .5, true, i == 0, TF_WHEEL.DiffPos, GroupsAndSongs })
				end,
				MoveCommand = MoveFunction
			},

			Def.ActorMultiVertex {
				Name = "GrooveLine",
				InitCommand = function(self)
					self:SetDrawState { Mode = "DrawMode_LineStrip" }
						:xy(-200, 120)
						:SetLineWidth(4)
						:playcommand("Move", { 0, 1, false, i == 0, TF_WHEEL.DiffPos, GroupsAndSongs })
				end,
				MoveCommand = MoveFunction
			}
		}
	end

	local GRLocation = {
		{ 0,    -105 },
		{ 110,  -35 },
		{ 85,   80 },
		{ -85,  80 },
		{ -110, -35 }
	}

	for i, v in ipairs(GrooveRadarNames) do
		GRName[#GRName + 1] = Def.BitmapText {
			Text = v,
			Font = "_noto sans 40px",
			OnCommand = function(self)
				self:zoom(.25):xy(GRLocation[i][1], GRLocation[i][2])
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

			MoveSelection(self, 0, GroupsAndSongs)
			MoveDifficulty(self, 0, GroupsAndSongs)

			-- Sleep for 0.2 sec, And then load the current song music.
			self:GetChild("MusicCon"):stoptweening():sleep(0):queuecommand("PlayCurrentSong")
		end,

		-- Play Music at start of screen,.
		Def.ActorFrame {
			Name = "MusicCon",
			PlayCurrentSongCommand = function(self)
				if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
					TF_WHEEL.BG:Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetBackgroundPath()):FullScreen()
					if GroupsAndSongs[TF_WHEEL.CurSong][1].PlayPreviewMusic then
						GroupsAndSongs[TF_WHEEL.CurSong][1]:PlayPreviewMusic()
					elseif GroupsAndSongs[TF_WHEEL.CurSong][1]:GetMusicPath() then
						SOUND:PlayMusicPart(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetMusicPath(),
							GroupsAndSongs[TF_WHEEL.CurSong][1]:GetSampleStart(),
							GroupsAndSongs[TF_WHEEL.CurSong][1]:GetSampleLength(), 0, 0, true)
					end
				else
					TF_WHEEL.BG:Load(THEME:GetPathG("Common", "fallback background")):FullScreen()
				end
			end
		},

		-- Do stuff when a user presses left on Pad or Menu buttons.
		MenuLeftCommand = function(self)
			MoveSelection(self, -1, GroupsAndSongs)
			MoveDifficulty(self, 0, GroupsAndSongs)
		end,

		-- Do stuff when a user presses Right on Pad or Menu buttons.
		MenuRightCommand = function(self)
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
				if GAMESTATE:IsSideJoined(LAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
					-- If both players are joined, We want to unjoin the player that pressed back.
					GAMESTATE:UnjoinPlayer(self.pn)

					MoveSelection(self, 0, GroupsAndSongs)
					MoveDifficulty(self, 0, GroupsAndSongs)
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
				if type(GroupsAndSongs[TF_WHEEL.CurSong]) == "string" then
					-- Check if we are on the same group thats currently open,
					-- If not we set the curent group to our new selection.
					if TF_WHEEL.CurGroup ~= GroupsAndSongs[TF_WHEEL.CurSong] then
						TF_WHEEL.CurGroup = GroupsAndSongs[TF_WHEEL.CurSong]

						-- Same group, Close it.
					else
						TF_WHEEL.CurGroup = ""
					end

					-- Reset the groups location so we dont bug.
					GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs, "")
					MoveSelection(self, 0, GroupsAndSongs)

					-- Set TF_WHEEL.CurSong to the right group.
					for i, v in ipairs(GroupsAndSongs) do
						if v == TF_WHEEL.CurGroup then
							TF_WHEEL.CurSong = i
						end
					end

					-- Set the current group.
					GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs, TF_WHEEL.CurGroup)
					MoveSelection(self, 0, GroupsAndSongs)

					-- Not on a group, Start song.
				else
					--We use PlayMode_Regular for now.
					GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")

					--Set the song we want to play.
					GAMESTATE:SetCurrentSong(GroupsAndSongs[TF_WHEEL.CurSong][1])

					-- Check if 2 players are joined.
					if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
						-- If they are, We will use Versus.
						GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDBVersus[Style])

						-- Save Profiles.
						PROFILEMAN:SaveProfile(PLAYER_1)
						PROFILEMAN:SaveProfile(PLAYER_2)

						-- Set the Current Steps to use.
						GAMESTATE:SetCurrentSteps(PLAYER_1, GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[PLAYER_1] + 1])
						GAMESTATE:SetCurrentSteps(PLAYER_2, GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[PLAYER_2] + 1])
					else
						-- If we are single player, Use Single.
						GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDB[Style])

						-- Save Profile.
						PROFILEMAN:SaveProfile(self.pn)

						-- Set the Current Step to use.
						GAMESTATE:SetCurrentSteps(self.pn, GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[self.pn] + 1])
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

				MoveSelection(self, 0, GroupsAndSongs)
				MoveDifficulty(self, 0, GroupsAndSongs)
			end
		end,

		-- Change to ScreenGameplay.
		StartSongCommand = function(self)
			SCREENMAN:GetTopScreen():SetNextScreenName("ScreenLoadGameplayElements"):StartTransitioningScreen(
			"SM_GoToNextScreen")
		end,

		Def.Quad {
			InitCommand = function(self)
				self:zoomto(256, 80):xy(-SCREEN_CENTER_X + 14, -65):halign(0)
					:diffuse(0, 0, 0, 1)
			end
		},

		-- Load the under banner.
		Def.Sprite {
			Name = "BannerUnderlay",
			InitCommand = function(self)
				self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), 256, 80))
					:xy(-SCREEN_CENTER_X + 142, -65)
			end
		},

		-- Load the top banner.
		Def.Sprite {
			Name = "BannerOverlay",
			InitCommand = function(self)
				-- Check if its a song.
				if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
					-- It is, Load banner.
					self:Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetBannerPath())
				else
					-- It's a group, Check if it has a banner.
					if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "" then
						-- It does, Load it.
						self:Load(SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[TF_WHEEL.CurSong]))
					end
				end

				self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), 256, 80))
					:xy(-SCREEN_CENTER_X + 142, -65)
			end,
			LoadCommand = function(self)
				-- Check if its a song.
				if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
					-- It is, Load banner.
					self:visible(1):Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetBannerPath())
				else
					-- It's a group, Check if it has a banner.
					if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "" then
						-- It does, Load it.
						self:visible(1):Load(SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[TF_WHEEL.CurSong]))
					else
						-- It doesnt, Hide the banner.
						self:visible(0)
					end
				end

				self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), 256, 80))
			end
		},

		-- The Info display container.
		Def.Sprite {
			Texture = THEME:GetPathG("DDR/InfoMAX", "Display"),
			OnCommand = function(self)
				self:zoom(.32):xy(-SCREEN_CENTER_X, -80):halign(0)
					:diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3], DisplayColor[4])
			end
		},

		Def.BitmapText {
			Font = "_noto sans 40px",
			Text = "SPEED",
			OnCommand = function(self)
				self:zoomy(.2):zoomx(.25):xy(-SCREEN_CENTER_X + 160, -136)
					:diffuse(1, 1, 0, 1):halign(0)
			end
		},

		Def.ActorFrame {
			OnCommand = function(self)
			end,
			Def.Quad {
				OnCommand = function(self)
					self:zoomto(160, 25):xy(-SCREEN_CENTER_X + 170, -95):MaskSource()
				end
			},
			Def.Quad {
				OnCommand = function(self)
					self:zoomto(160, 36):xy(-SCREEN_CENTER_X + 170, -150):MaskSource()
				end
			},
		},

		Def.ActorFrame {
			Name = "BPM",
			OnCommand = function(self)
				self:xy(-SCREEN_CENTER_X + 156, -120):zbuffer(true)
			end,
			Def.BitmapText {
				Name = "Num",
				Font = "_noto sans 40px",
				Text = "ーーー",
				OnCommand = function(self)
					self:zoomy(.6):zoomx(.8):diffuse(1, 1, 0, 1):halign(0)
						:queuecommand("BPMChange")
				end,
				BPMChangeCommand = function(self)
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						local BPMS = GroupsAndSongs[TF_WHEEL.CurSong][1]:GetDisplayBpms()

						if BPMS[1] ~= BPMS[2] then
							self:diffuse(1, 0, 0, 1)
								:settext(string.format("%03.0f", BPMS[1]))
								:queuecommand("BPMOne")
						else
							self:diffuse(1, 1, 0, 1)
								:settext(string.format("%03.0f", BPMS[1]))
						end
					else
						self:diffuse(0, 1, 0, 1)
							:settext("ーーー")
					end
				end,
				BPMOneCommand = function(self)
					TF_WHEEL.CountingNumbers(self, self:GetText(), GroupsAndSongs[TF_WHEEL.CurSong][1]:GetDisplayBpms()[1], .4,
						"%03.0f")
					self:sleep(.8):queuecommand("BPMTwo")
				end,
				BPMTwoCommand = function(self)
					TF_WHEEL.CountingNumbers(self, self:GetText(), GroupsAndSongs[TF_WHEEL.CurSong][1]:GetDisplayBpms()[2], .4,
						"%03.0f")
					self:sleep(.8):queuecommand("BPMOne")
				end
			},
			Def.BitmapText {
				Name = "Text",
				Font = "_noto sans 40px",
				Text = "bpm",
				OnCommand = function(self)
					self:zoomy(.2):zoomx(.4):diffuse(1, 1, 0, 1):halign(0):xy(58, 4)
						:queuecommand("BPMChange")
				end,
				BPMChangeCommand = function(self)
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						local BPMS = GroupsAndSongs[TF_WHEEL.CurSong][1]:GetDisplayBpms()

						if BPMS[1] ~= BPMS[2] then
							self:diffuse(1, 0, 0, 1)
						else
							self:diffuse(1, 1, 0, 1)
						end
					else
						self:diffuse(0, 1, 0, 1)
					end
				end
			}
		},

		Def.ActorFrame {
			Name = "BPMDummy",
			OnCommand = function(self)
				self:xy(-SCREEN_CENTER_X + 156, -95):zbuffer(true)
			end,
			Def.BitmapText {
				Name = "Num",
				Font = "_noto sans 40px",
				Text = "ーーー",
				OnCommand = function(self)
					self:zoomy(.6):zoomx(.8):diffuse(1, 1, 0, 1):halign(0)
						:queuecommand("BPMChange")
				end,
				BPMChangeCommand = function(self)
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						local BPMS = GroupsAndSongs[TF_WHEEL.CurSong][1]:GetDisplayBpms()

						if BPMS[1] ~= BPMS[2] then
							self:diffuse(1, 0, 0, 1)
						else
							self:diffuse(1, 1, 0, 1)
						end
						self:settext(string.format("%03.0f", BPMS[1]))
					else
						self:diffuse(0, 1, 0, 1)
						self:settext("ーーー")
					end
				end
			},
			Def.BitmapText {
				Name = "Text",
				Font = "_noto sans 40px",
				Text = "bpm",
				OnCommand = function(self)
					self:zoomy(.2):zoomx(.4):diffuse(1, 1, 0, 1):halign(0):xy(58, 4)
						:queuecommand("BPMChange")
				end,
				BPMChangeCommand = function(self)
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						local BPMS = GroupsAndSongs[TF_WHEEL.CurSong][1]:GetDisplayBpms()

						if BPMS[1] ~= BPMS[2] then
							self:diffuse(1, 0, 0, 1)
						else
							self:diffuse(1, 1, 0, 1)
						end
					else
						self:diffuse(0, 1, 0, 1)
					end
				end
			}
		},

		Def.BitmapText {
			Font = "_noto sans 40px",
			Text = "STAGE",
			OnCommand = function(self)
				self:zoomy(.2):zoomx(.25):xy(-SCREEN_CENTER_X + 40, -136)
					:diffuse(1, 1, 0, 1):halign(0)
			end
		},

		Def.BitmapText {
			Text = ToEnumShortString(GAMESTATE:GetCurrentStage()):upper(),
			Font = "_noto sans 40px",
			OnCommand = function(self)
				self:diffuse(.8, .8, 1, 1):zoom(.5)
					:xy(-SCREEN_CENTER_X + 40, -120):halign(0)
			end
		},

		Def.ActorFrame {
			Name = "CDTitle",
			OnCommand = function(self)
				self:spin():effectmagnitude(0, -140, 0)
					:xy(-SCREEN_CENTER_X + 250, -90):z(400)
			end,
			LoadCommand = function(self)
				for i = 1, self:GetNumChildren() do
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						-- It is, Get CDTitle.
						self:GetChild("")[i]:visible(true):Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetCDTitlePath())
							:zoom(TF_WHEEL.Resize(self:GetChild("")[i]:GetWidth(), self:GetChild("")[i]:GetHeight(), 60,
								60))
					else
						self:GetChild("")[i]:visible(false)
					end
				end
			end,
			Def.Sprite {
				InitCommand = function(self)
					-- Check if its a song.
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						-- It is, Get CDTitle.
						self:Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetCDTitlePath())
					end

					self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), 60, 60)):z(-1)
						:diffuse(0, 0, 0, 1):zbuffer(true)
				end
			},
			Def.Sprite {
				InitCommand = function(self)
					-- Check if its a song.
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						-- It is, Get CDTitle.
						self:Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetCDTitlePath())
					end

					self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), 60, 60)):z(-.9)
						:glow(1, 1, 1, 1):zbuffer(true)
				end
			},
			Def.Sprite {
				InitCommand = function(self)
					-- Check if its a song.
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						-- It is, Get CDTitle.
						self:Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetCDTitlePath())
					end

					self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), 60, 60)):z(.9)
						:glow(1, 1, 1, 1):zbuffer(true)
				end
			},
			Def.Sprite {
				InitCommand = function(self)
					-- Check if its a song.
					if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
						-- It is, Get CDTitle.
						self:Load(GroupsAndSongs[TF_WHEEL.CurSong][1]:GetCDTitlePath())
					end

					self:zoom(TF_WHEEL.Resize(self:GetWidth(), self:GetHeight(), 60, 60)):z(1)
						:zbuffer(true)
				end
			}
		},

		-- Load the wheel.
		Wheel .. {
			OnCommand = function(self) self:x(SCREEN_CENTER_X - 280) end
		},

		-- Add the glowing selector part on the top of the wheel.
		Def.ActorFrame {
			OnCommand = function(self)
				self:zoom(.35):x(SCREEN_CENTER_X - 145)
			end,
			Def.Sprite {
				Texture = THEME:GetPathG("", "DDR/MAXSelector"),
				OnCommand = function(self)
					self:diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3], 1)
				end
			},
			Def.Sprite {
				Texture = THEME:GetPathG("", "DDR/MAXSelector"),
				OnCommand = function(self)
					self:diffuseshift():effectcolor1(DisplayColor[1], DisplayColor[2], DisplayColor[3], 1)
						:effectcolor2(DisplayColor[1], DisplayColor[2], DisplayColor[3], 0)
				end
			}
		},

		Def.Sprite {
			Texture = THEME:GetPathG("", "DDR/Radar"),
			OnCommand = function(self)
				self:zoom(.35):xy(-SCREEN_CENTER_X + 140, 120):diffuse(DisplayColor[1], DisplayColor[2], DisplayColor[3],
					1)
			end
		},

		Diffs .. {
			OnCommand = function(self) self:x(-SCREEN_CENTER_X + 340) end
		},

		GRName .. {
			OnCommand = function(self)
				self:xy(-SCREEN_CENTER_X + 140, 120)
			end
		}
	}
end
