-- We define the curent song if no song is selected.
if not TF_WHEEL.CurSong then TF_WHEEL.CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not TF_WHEEL.CurGroup then TF_WHEEL.CurGroup = "" end

-- Position on the difficulty select that shows up after we picked a song.
if not TF_WHEEL.DiffPos then TF_WHEEL.DiffPos = {[PLAYER_1] = 1, [PLAYER_2] = 1} end

-- Move the wheel, We define the Offset using +1 or -1.
-- We parse the Songs also so we can get the amount of songs.
local function MoveSelection(self, offset, Songs)
    -- Curent Song + Offset.
    TF_WHEEL.CurSong = TF_WHEEL.CurSong + offset

    -- Check if curent song is further than Songs if so, reset to 1.
    if TF_WHEEL.CurSong > #Songs then TF_WHEEL.CurSong = 1 end
    -- Check if curent song is lower than 1 if so, grab last song.
    if TF_WHEEL.CurSong < 1 then TF_WHEEL.CurSong = #Songs end

    -- Check if offset is not 0.
    if offset ~= 0 then

        -- Stop all the music playing, Which is the Song Music
        SOUND:StopMusic()

        -- Play Current selected Song Music.
        self:GetChild("MusicCon"):stoptweening():sleep(0.4):queuecommand(
            "PlayCurrentSong")
    end
end

-- Change the cursor of Player on the difficulty selector.
local function MoveDifficulty(self, offset, Songs)
    -- check if player is joined.
    if self.pn and GAMESTATE:IsSideJoined(self.pn) then
        -- Move cursor.
        TF_WHEEL.DiffPos[self.pn] = TF_WHEEL.DiffPos[self.pn] + offset

        -- Keep within boundaries.
        if TF_WHEEL.DiffPos[self.pn] < 1 then
            TF_WHEEL.DiffPos[self.pn] = 1
        end
        if TF_WHEEL.DiffPos[self.pn] > #Songs[TF_WHEEL.CurSong] - 1 then
            TF_WHEEL.DiffPos[self.pn] = #Songs[TF_WHEEL.CurSong] - 1
        end

        -- Call the move selecton command to update the graphical location of cursor.
        MoveSelection(self, 0, Songs)
    end
end

-- This is the main function, Its the function that contains the wheel.
return function(Style)
    -- Load the songs from the Songs.Loader module.
    local Songs = LoadModule("Songs.Loader.lua")(Style)

    -- Sort the Songs and Group.
    local GroupsAndSongs =
        LoadModule("Group.Sort.lua")(Songs, TF_WHEEL.CurGroup)

    -- We define here is we load the Options menu when people double press,
    -- Because they need to double press it starts at false.
    local StartOptions = false

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
            self:GetChild("MusicCon"):stoptweening():sleep(0):queuecommand(
                "PlayCurrentSong")
        end,

        -- Play Music at start of screen,.
        Def.ActorFrame {
            Name = "MusicCon",
            PlayCurrentSongCommand = function(self)
                if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
                    if GroupsAndSongs[TF_WHEEL.CurSong][1].PlayPreviewMusic then
                        GroupsAndSongs[TF_WHEEL.CurSong][1]:PlayPreviewMusic()
                    elseif GroupsAndSongs[TF_WHEEL.CurSong][1]:GetMusicPath() then
                        SOUND:PlayMusicPart(
                            GroupsAndSongs[TF_WHEEL.CurSong][1]:GetMusicPath(),
                            GroupsAndSongs[TF_WHEEL.CurSong][1]:GetSampleStart(),
                            GroupsAndSongs[TF_WHEEL.CurSong][1]:GetSampleLength(),
                            0, 0, true)
                    end
                end
                if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" and GroupsAndSongs[TF_WHEEL.CurSong][1]:HasBackground() then
                    TF_WHEEL.BG:LoadCachedBackground(
                        GroupsAndSongs[TF_WHEEL.CurSong][1]:GetBackgroundPath())
                        :FullScreen()
                else
                    TF_WHEEL.BG:LoadCachedBackground(
                        THEME:GetPathG("Common", "fallback background"))
                        :FullScreen()
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
        MenuDownCommand = function(self)
            MoveDifficulty(self, 1, GroupsAndSongs)
        end,

        -- Do stuff when a user presses the Down on Pad or Menu buttons.
        MenuUpCommand = function(self)
            MoveDifficulty(self, -1, GroupsAndSongs)
        end,

        -- Do stuff when a user presses the Back on Pad or Menu buttons.
        BackCommand = function(self)
            -- Check if User is joined.
            if GAMESTATE:IsSideJoined(self.pn) then
                if GAMESTATE:IsSideJoined(LAYER_1) and
                    GAMESTATE:IsSideJoined(PLAYER_2) then
                    -- If both players are joined, We want to unjoin the player that pressed back.
                    GAMESTATE:UnjoinPlayer(self.pn)

                    MoveSelection(self, 0, GroupsAndSongs)
                    MoveDifficulty(self, 0, GroupsAndSongs)
                else
                    -- Go to the previous screen.
                    SCREENMAN:GetTopScreen():SetNextScreenName(
                        SCREENMAN:GetTopScreen():GetPrevScreenName())
                        :StartTransitioningScreen("SM_GoToNextScreen")
                end
            end
        end,

        -- Do stuff when a user presses the Start on Pad or Menu buttons.
        StartCommand = function(self)
            -- Check if we want to go to ScreenPlayerOptions instead of ScreenGameplay.
            if StartOptions then
                SCREENMAN:GetTopScreen()
                    :SetNextScreenName("ScreenPlayerOptions")
                    :StartTransitioningScreen("SM_GoToNextScreen")
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
                    GroupsAndSongs = LoadModule("Group.Sort.lua")(Songs,
                                                                  TF_WHEEL.CurGroup)
                    MoveSelection(self, 0, GroupsAndSongs)

                    -- Not on a group, Start song.
                else
                    -- We use PlayMode_Regular for now.
                    GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")

                    -- Set the song we want to play.
                    GAMESTATE:SetCurrentSong(GroupsAndSongs[TF_WHEEL.CurSong][1])

                    -- Check if 2 players are joined.
                    if GAMESTATE:IsSideJoined(PLAYER_1) and
                        GAMESTATE:IsSideJoined(PLAYER_2) then
                        -- If they are, We will use Versus.
                        GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDBVersus[Style])

                        -- Save Profiles.
                        PROFILEMAN:SaveProfile(PLAYER_1)
                        PROFILEMAN:SaveProfile(PLAYER_2)

                        -- Set the Current Steps to use.
                        GAMESTATE:SetCurrentSteps(PLAYER_1,
                                                  GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[PLAYER_1] +
                                                      1])
                        GAMESTATE:SetCurrentSteps(PLAYER_2,
                                                  GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[PLAYER_2] +
                                                      1])
                    else
                        -- If we are single player, Use Single.
                        GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDB[Style])

                        -- Save Profile.
                        PROFILEMAN:SaveProfile(self.pn)

                        -- Set the Current Step to use.
                        GAMESTATE:SetCurrentSteps(self.pn,
                                                  GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[self.pn] +
                                                      1])
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
            SCREENMAN:GetTopScreen():SetNextScreenName(
                "ScreenLoadGameplayElements"):StartTransitioningScreen(
                "SM_GoToNextScreen")
        end
    }
end
