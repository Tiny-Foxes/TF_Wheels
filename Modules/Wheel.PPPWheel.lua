-- We define the curent song if no song is selected.
if not CurSong then CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not CurGroup then GurGroup = "" end

-- The player joined.
if not Joined then Joined = {} end

-- The increase offset for when we move with postive.
local IncOffset = 1

-- The decrease offset for when we move with negative.
local DecOffset = 10

-- The center offset of the wheel.
local XOffset = 5

-- Move the wheel, We define the Offset using +1 or -1.
-- We parse the Songs also so we can get the amount of songs.
local function MoveSelection(self,offset,Songs)

	-- Curent Song + Offset.
	CurSong = CurSong + offset
	
	-- Check if curent song is further than Songs if so, reset to 1.
	if CurSong > #Songs then CurSong = 1 end
	-- Check if curent song is lower than 1 if so, grab last song.
	if CurSong < 1 then CurSong = #Songs end
	
	-- Set the offsets for increase and decrease.
	DecOffset = DecOffset + offset
	IncOffset = IncOffset + offset

	if DecOffset > 10 then DecOffset = 1 end
	if IncOffset > 10 then IncOffset = 1 end

	if DecOffset < 1 then DecOffset = 10 end
    if IncOffset < 1 then IncOffset = 10 end
    
    -- Set the offset for the center of the wheel.	
	XOffset = XOffset + offset
	if XOffset > 10 then XOffset = 1 end
	if XOffset < 1 then XOffset = 10 end
    
    -- If we are calling this command with an offset that is not 0 then do stuff.
	if offset ~= 0 then

		self:GetChild("Selector"):stoptweening():linear(.05):diffusealpha(.2):linear(.05):diffusealpha(1)

		-- For every part on the wheel do.
		for i = 1,10 do	
		
			-- Calculate current position based on song with a value to get center.
            local pos = CurSong+(4*offset)
            
            if offset == 1 then
                pos = CurSong+(5*offset)
            end
		
			-- Keep it within reasonable values.
			while pos > #Songs do pos = pos-#Songs end
			while pos < 1 do pos = #Songs+pos end
		
			-- Transform the wheel, As in make it move.
			self:GetChild("SongWheel"):GetChild("CD"..i):linear(.1):addx((offset*-240))

			-- Here we define what the wheel does if it is outside the values.
			-- So that when a part is at the bottom it will move to the top.
			if (i == IncOffset and offset == -1) or (i == DecOffset and offset == 1) then

				-- Move wheelpart instantly to new location.
                self:GetChild("SongWheel"):GetChild("CD"..i):sleep(0):addx((offset*-240)*-10)
				
				self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDText"):settext("")

                if type(Songs[pos]) ~= "string" then
                    if Songs[pos][1]:HasJacket() then self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDTexture"):Load(Songs[pos][1]:GetJacketPath()) 
                    elseif Songs[pos][1]:HasBackground() then self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDTexture"):Load(Songs[pos][1]:GetBackgroundPath())
					else self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDTexture"):Load(THEME:GetPathG("","white.png"))
						self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDText"):settext(Songs[pos][1]:GetDisplayMainTitle())
                    end
                else
                    if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDTexture"):Load(SONGMAN:GetSongGroupBannerPath(Songs[pos])) 
					else self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDTexture"):Load(THEME:GetPathG("","white.png"))
						self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDText"):settext(Songs[pos])
                    end
                end
                self:GetChild("SongWheel"):GetChild("CD"..i):GetChild("CDTexture"):zoomto(400,400) 
            end
        end
    else
        -- For every part of the wheel do.
		for i = 1,10 do	

			-- Offset for the wheel items.
			off = i + XOffset

			-- Stay withing limits.
			while off > 10 do off = off-10 end
			while off < 1 do off = off+10 end

			-- Get center position.
			local pos = CurSong+i

			-- If item is above 5 then we do a -10 to fix the display.
			if i > 5 then
				pos = CurSong+i-10
			end

			-- Keep pos withing limits.
			while pos > #Songs do pos = pos-#Songs end
            while pos < 1 do pos = #Songs+pos end
			
			self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDText"):settext("")

            if type(Songs[pos]) ~= "string" then
                if Songs[pos][1]:HasJacket() then self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDTexture"):Load(Songs[pos][1]:GetJacketPath()) 
                elseif Songs[pos][1]:HasBackground() then self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDTexture"):Load(Songs[pos][1]:GetBackgroundPath())
				else self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDTexture"):Load(THEME:GetPathG("","white.png"))
					self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDText"):settext(Songs[pos][1]:GetDisplayMainTitle())
                end
            else
                if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDTexture"):Load(SONGMAN:GetSongGroupBannerPath(Songs[pos])) 
				else self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDTexture"):Load(THEME:GetPathG("","white.png"))
					self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDText"):settext(Songs[pos])
                end
            end
            self:GetChild("SongWheel"):GetChild("CD"..off):GetChild("CDTexture"):zoomto(400,400) 
        end
    end

    -- Check if offset is not 0.
	if offset ~= 0 then
		-- Stop all the music playing, Which is the Song Music
		SOUND:StopMusic()

		-- Check if its a song.
		if type(Songs[CurSong]) ~= "string" then
			-- Play Current selected Song Music.
			if Songs[CurSong][1]:GetMusicPath() then
				SOUND:PlayMusicPart(Songs[CurSong][1]:GetMusicPath(),Songs[CurSong][1]:GetSampleStart(),Songs[CurSong][1]:GetSampleLength(),0,0,true)
			end
		end
	end
end

-- This is the main function, Its the function that contains the wheel.
return function(Style)

    -- Load the songs from the Songs.Loader module.
	local Songs = LoadModule("Songs.Loader.lua")(Style)
	
	-- Sort the Songs and Group.
    local GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs,CurGroup)
    
    -- We define here is we load the Options menu when people double press,
	-- Because they need to double press it starts at false.
	local StartOptions = false

    -- The main songwheel that contains all the songs.
    local SongWheel = Def.ActorFrame{Name="SongWheel"}

    for i = 1,10 do

        -- Position of current song, We want the cd in the front, So its the one we change.
		local pos = CurSong+i-5
		
		-- Stay within limits.
		while pos > #GroupsAndSongs do pos = pos-#GroupsAndSongs end
		while pos < 1 do pos = #GroupsAndSongs+pos end

        SongWheel[#SongWheel+1] = Def.ActorFrame{
            Name="CD"..i,
            OnCommand=function(self)
                self:zoom(.5):x(200+(-240*5)+(240*i))
            end,
            Def.Sprite{
                Texture=THEME:GetPathG("","PPP/CD.png")
            },
            Def.Sprite{
                Texture=THEME:GetPathG("","PPP/Mask.png"),
                OnCommand=function(self)
                    self:MaskSource()
                end
            },
            Def.Sprite{
                Name="CDTexture",
                Texture=THEME:GetPathG("","white.png"),
                OnCommand=function(self)
                    if type(GroupsAndSongs[pos]) ~= "string" then
                        if GroupsAndSongs[pos][1]:HasJacket() then self:Load(GroupsAndSongs[pos][1]:GetJacketPath()) 
                        elseif GroupsAndSongs[pos][1]:HasBackground() then self:Load(GroupsAndSongs[pos][1]:GetBackgroundPath()) 
                        end
                    else
                        if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]) ~= "" then self:Load(SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos])) end
                    end
                    self:MaskDest():zoomto(400,400) 
                end
			},
			Def.BitmapText{
				Name="CDText",
				OnCommand=function(self)
					if type(GroupsAndSongs[pos]) ~= "string" then
						if not GroupsAndSongs[pos][1]:HasJacket() and not GroupsAndSongs[pos][1]:HasBackground() then
							self:settext(GroupsAndSongs[pos][1]:GetDisplayMainTitle())
                        end
                    else
						if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]) == "" then
							self:settext(GroupsAndSongs[pos])
						end
					end
					self:diffuse(0,0,0,1):maxwidth(320):y(-100)
				end
			}
        }


    end

     -- Here we return the actual Music Wheel Actor.
    return Def.ActorFrame{
        OnCommand=function(self)
            self:Center()
            -- We use a Input function from the Scripts folder.
			-- It uses a Command function. So you can define all the Commands,
			-- Like MenuLeft is MenuLeftCommand.
			SCREENMAN:GetTopScreen():AddInputCallback(TF_WHEEL.Input(self))
			
			-- Sleep for 0.2 sec, And then load the current song music.
			self:sleep(0.2):queuecommand("PlayCurrentSong")
        end,
        
        -- Play Music at start of screen,.
		PlayCurrentSongCommand=function(self)
			if type(GroupsAndSongs[CurSong]) ~= "string" and GroupsAndSongs[CurSong][1]:GetMusicPath() then
				SOUND:PlayMusicPart(GroupsAndSongs[CurSong][1]:GetMusicPath(),GroupsAndSongs[CurSong][1]:GetSampleStart(),GroupsAndSongs[CurSong][1]:GetSampleLength(),0,0,true)
			end
        end,
        
        -- Do stuff when a user presses left on Pad or Menu buttons.
        MenuLeftCommand=function(self) MoveSelection(self,-1,GroupsAndSongs) end,
		
		-- Do stuff when a user presses Right on Pad or Menu buttons.
        MenuRightCommand=function(self) MoveSelection(self,1,GroupsAndSongs) end,

        -- Do stuff when a user presses the Back on Pad or Menu buttons.
		BackCommand=function(self) 
			-- Check if User is joined.
			if Joined[self.pn] then
				if Joined[PLAYER_1] and Joined[PLAYER_2] then
					-- If both players are joined, We want to unjoin the player that pressed back.
					GAMESTATE:UnjoinPlayer(self.pn)
					Joined[self.pn] = false
					
					MoveSelection(self,0,GroupsAndSongs)
				else
					-- Go to the previous screen.
					SCREENMAN:GetTopScreen():SetNextScreenName(SCREENMAN:GetTopScreen():GetPrevScreenName()):StartTransitioningScreen("SM_GoToNextScreen") 
				end
			end
		end,

        -- Do stuff when a user presses the Start on Pad or Menu buttons.
		StartCommand=function(self)
			-- Check if we want to go to ScreenPlayerOptions instead of ScreenGameplay.
			if StartOptions then
				SCREENMAN:GetTopScreen():SetNextScreenName("ScreenPlayerOptions"):StartTransitioningScreen("SM_GoToNextScreen")
			end
			-- Check if player is joined.
			if Joined[self.pn] then 
			
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
					GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs,"")
					MoveSelection(self,0,GroupsAndSongs)
					
					-- Set CurSong to the right group.
					for i,v in ipairs(GroupsAndSongs) do
						if v == CurGroup then
							CurSong = i
						end
					end

					-- Set the current group.
					GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs,CurGroup)
					MoveSelection(self,0,GroupsAndSongs)
					
				-- Not on a group, Start song.
				else

					--We use PlayMode_Regular for now.
					GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")
				
					--Set the song we want to play.
					GAMESTATE:SetCurrentSong(GroupsAndSongs[CurSong][1])
				
					-- Check if 2 players are joined.
					if Joined[PLAYER_1] and Joined[PLAYER_2] then
				
						-- If they are, We will use Versus.
						GAMESTATE:SetCurrentStyle('versus')
					
						-- Save Profiles.
						PROFILEMAN:SaveProfile(PLAYER_1)
						PROFILEMAN:SaveProfile(PLAYER_2)
					
						-- Set the Current Steps to use.
						GAMESTATE:SetCurrentSteps(PLAYER_1,GroupsAndSongs[CurSong][2])
						GAMESTATE:SetCurrentSteps(PLAYER_2,GroupsAndSongs[CurSong][2])
					else
				
						-- If we are single player, Use Single.
						GAMESTATE:SetCurrentStyle('single')
					
						-- Save Profile.
						PROFILEMAN:SaveProfile(self.pn)
					
						-- Set the Current Step to use.
						GAMESTATE:SetCurrentSteps(self.pn,GroupsAndSongs[CurSong][2])
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
				
				-- Add to joined list.
				Joined[self.pn] = true
				
				MoveSelection(self,0,GroupsAndSongs)
			end			
		end,
		
		-- Change to ScreenGameplay.
		StartSongCommand=function(self)
			SCREENMAN:GetTopScreen():SetNextScreenName("ScreenGameplay"):StartTransitioningScreen("SM_GoToNextScreen")
		end,

		SongWheel,
		
		Def.Sprite{
			Name="Selector",
			OnCommand=function(self)
				self:x(200):zoom(.5):diffuse(color("#CFEEFA"))
			end,
			Texture=THEME:GetPathG("","PPP/Selector.png")
		}
    }
end