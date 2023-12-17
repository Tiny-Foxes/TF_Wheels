-- Use masks for CD's instead of multiple Banners.
if not TF_WHEEL.MaskMode then TF_WHEEL.MaskMode = false end

-- Difficulty Colours
local DiffColors = {
    color("#88ffff"), -- Difficulty_Beginner
    color("#ffff88"), -- Difficulty_Easy
    color("#ff8888"), -- Difficulty_Medium
    color("#88ff88"), -- Difficulty_Hard
    color("#8888ff"), -- Difficulty_Challenge
    color("#888888") -- Difficulty_Edit
}

-- Difficulty Names.
-- https://en.wikipedia.org/wiki/Dance_Dance_Revolution#Difficulty
local DiffNames = {
    "EASY", -- Difficulty_Beginner
    "BASIC", -- Difficulty_Easy
    "ANOTHER", -- Difficulty_Medium
    "MANIAC ", -- Difficulty_Hard
    "EXTRA", -- Difficulty_Challenge
    "EDIT" -- Difficulty_Edit
}

-- Difficulty Chart Names based on Meter.
local DiffChartNames = {
    "SIMPLE", -- 1 feet
    "MODERATE", -- 2 feet
    "ORDINARY", -- 3 feet
    "SUPERIOR", -- 4 feet
    "MARVELOUS", -- 5 feet
    "GENUINE", -- 6 feet
    "PARAMOUNT", -- 7 feet
    "EXORBITANT" -- 8 feet
}

-- We define the curent song if no song is selected.
if not TF_WHEEL.CurSong then TF_WHEEL.CurSong = 1 end

-- We define the current group to be empty if no group is defined.
if not TF_WHEEL.CurGroup then TF_WHEEL.CurGroup = "" end

-- Position on the difficulty select that shows up after we picked a song.
if not TF_WHEEL.DiffPos then TF_WHEEL.DiffPos = {[PLAYER_1] = 1, [PLAYER_2] = 1} end
local DiffPlayer = GAMESTATE:GetMasterPlayerNumber()

-- The Offset we use for the CD wheel.
local CDOffset = 1

-- Move the wheel, We define the Offset using +1 or -1.
-- We parse the Songs also so we can get the amount of songs.
local function MoveSelection(self, offset, Songs)
    -- Curent Song + Offset.
    TF_WHEEL.CurSong = TF_WHEEL.CurSong + offset

    -- Check if curent song is further than Songs if so, reset to 1.
    if TF_WHEEL.CurSong > #Songs then TF_WHEEL.CurSong = 1 end
    -- Check if curent song is lower than 1 if so, grab last song.
    if TF_WHEEL.CurSong < 1 then TF_WHEEL.CurSong = #Songs end

    -- CD Wheel offset + Offset.
    CDOffset = CDOffset + offset

    -- We want to rotate for every CD, So we grab the current Offset of the CD,
    -- And we Check if its beyond 9 and below 1.
    if CDOffset > 9 then CDOffset = 1 end
    if CDOffset < 1 then CDOffset = 9 end

    -- For every CD on the wheel, Rotate it by 360/9, 9 being the amount of CDs.
    for i = 1, 9 do
        self:GetChild("CDCon"):GetChild("CD" .. i):linear(.1):addrotationz(
            ((360 / 9) * offset) * -1)
    end

    -- We Define the ChangeOffset, Which is used to define the location the CDs change Images.
    local ChangeOffset = CDOffset

    -- An extra check that results the ChangeOffset is right when we go in reverse.
    if offset > 0 then ChangeOffset = ChangeOffset + -1 end

    -- Same as CDOffset, Stay withing limits.
    if ChangeOffset > 9 then CDOffset = 1 end
    if ChangeOffset < 1 then ChangeOffset = 9 end

    -- The Position of Current song, The Wheel is 9 cd's so we grab Half
    local pos = TF_WHEEL.CurSong + (4 * offset)

    -- The Position is checked if its withing Song limits.
    while pos > #Songs do pos = pos - #Songs end
    while pos < 1 do pos = #Songs + pos end

    -- Do a string check, If its a string, Its a group.
    if type(Songs[pos]) ~= "string" then
        -- We check if the song has a banner, We use this for the CDs, If there is no banner, use fallback banner.png
        if Songs[pos][1]:HasBanner() then
            if TF_WHEEL.MaskMode then
                self:GetChild("CDCon"):GetChild("CD" .. ChangeOffset):GetChild(
                    "Container"):GetChild("CDPicture"):LoadCachedBanner(
                    Songs[pos][1]:GetBannerPath())
            else
                self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :LoadCachedBanner(Songs[pos][1]:GetBannerPath())
            end
        else
            if TF_WHEEL.MaskMode then
                self:GetChild("CDCon"):GetChild("CD" .. ChangeOffset):GetChild(
                    "Container"):GetChild("CDPicture"):LoadCachedBanner(
                    THEME:GetPathG("Common", "fallback banner.png"))
            else
                self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :LoadCachedBanner(THEME:GetPathG("Common",
                                                     "fallback banner.png"))
            end
        end

        if TF_WHEEL.MaskMode then
            self:GetChild("CDCon"):GetChild("CD" .. ChangeOffset):GetChild(
                "Container"):GetChild("CDPicture"):setsize(-120, -120)
        else
            -- We make it so that the slices are always w512 h160, and then resize the CD slices so they fit as part of the CD.
            self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset):setsize(
                512, 160):SetCustomPosCoords(
                self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :GetWidth() / 2 - 23, 0, self:GetChild("Con")
                    :GetChild("CDSlice" .. ChangeOffset):GetWidth() / 2 - 9,
                -80, -self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :GetWidth() / 2 + 9, -80, -self:GetChild("Con")
                    :GetChild("CDSlice" .. ChangeOffset):GetWidth() / 2 + 23, 0)
                :zoom(.4):y(-20)
        end

        -- Only do the CD Banner change on 0 offset.
    elseif offset == 0 then
        -- For every CD do
        for i = 1, 9 do
            -- Reset pos for local usage
            local pos = TF_WHEEL.CurSong + i - 5

            -- Stay within limits.
            while pos > #Songs do pos = pos - #Songs end
            while pos < 1 do pos = #Songs + pos end

            -- Do math for the CD slices we want to change at which location.
            local CDSliceOffset = ChangeOffset + i - 1

            -- Same as CDOffset, Stay withing limits.
            while CDSliceOffset > 9 do
                CDSliceOffset = CDSliceOffset - 9
            end
            while CDSliceOffset < 1 do
                CDSliceOffset = 1 + CDSliceOffset
            end

            -- Check if it is a song.
            if type(Songs[pos]) ~= "string" then
                -- We check if the song has a banner, We use this for the CDs, If there is no banner, use fallback banner.png
                if Songs[pos][1]:HasBanner() then
                    if TF_WHEEL.MaskMode then
                        self:GetChild("CDCon"):GetChild("CD" .. CDSliceOffset)
                            :GetChild("Container"):GetChild("CDPicture")
                            :LoadCachedBanner(Songs[pos][1]:GetBannerPath())
                    else
                        self:GetChild("Con")
                            :GetChild("CDSlice" .. CDSliceOffset)
                            :LoadCachedBanner(Songs[pos][1]:GetBannerPath())
                    end
                else
                    if TF_WHEEL.MaskMode then
                        self:GetChild("CDCon"):GetChild("CD" .. CDSliceOffset)
                            :GetChild("Container"):GetChild("CDPicture")
                            :LoadCachedBanner(THEME:GetPathG("Common",
                                                             "fallback banner.png"))
                    else
                        self:GetChild("Con")
                            :GetChild("CDSlice" .. CDSliceOffset)
                            :LoadCachedBanner(THEME:GetPathG("Common",
                                                             "fallback banner.png"))
                    end
                end

                -- Its a song group, Set it to group banner, If it doesnt have a banner, Use fallback banner.png
            else
                if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then
                    if TF_WHEEL.MaskMode then
                        self:GetChild("CDCon"):GetChild("CD" .. CDSliceOffset)
                            :GetChild("Container"):GetChild("CDPicture")
                            :LoadCachedBanner(
                                SONGMAN:GetSongGroupBannerPath(Songs[pos]))
                    else
                        self:GetChild("Con")
                            :GetChild("CDSlice" .. CDSliceOffset)
                            :LoadCachedBanner(
                                SONGMAN:GetSongGroupBannerPath(Songs[pos]))
                    end
                else
                    if TF_WHEEL.MaskMode then
                        self:GetChild("CDCon"):GetChild("CD" .. CDSliceOffset)
                            :GetChild("Container"):GetChild("CDPicture")
                            :LoadCachedBanner(THEME:GetPathG("Common",
                                                             "fallback banner.png"))
                    else
                        self:GetChild("Con")
                            :GetChild("CDSlice" .. CDSliceOffset)
                            :LoadCachedBanner(THEME:GetPathG("Common",
                                                             "fallback banner.png"))
                    end
                end
            end

            if TF_WHEEL.MaskMode then
                self:GetChild("CDCon"):GetChild("CD" .. CDSliceOffset):GetChild(
                    "Container"):GetChild("CDPicture"):setsize(-120, -120)
            else
                -- We make it so that the slices are always w512 h160, and then resize the CD slices so they fit as part of the CD.
                self:GetChild("Con"):GetChild("CDSlice" .. CDSliceOffset)
                    :setsize(512, 160):SetCustomPosCoords(
                        self:GetChild("Con"):GetChild("CDSlice" .. CDSliceOffset)
                            :GetWidth() / 2 - 23, 0, self:GetChild("Con")
                            :GetChild("CDSlice" .. CDSliceOffset):GetWidth() / 2 -
                            9, -80, -self:GetChild("Con")
                            :GetChild("CDSlice" .. CDSliceOffset):GetWidth() / 2 +
                            9, -80, -self:GetChild("Con")
                            :GetChild("CDSlice" .. CDSliceOffset):GetWidth() / 2 +
                            23, 0):zoom(.4):y(-20)
            end
        end
    else
        -- Its a song group, Set it to group banner, If it doesnt have a banner, Use fallback banner.png
        if SONGMAN:GetSongGroupBannerPath(Songs[pos]) ~= "" then
            if TF_WHEEL.MaskMode then
                self:GetChild("CDCon"):GetChild("CD" .. ChangeOffset):GetChild(
                    "Container"):GetChild("CDPicture"):LoadCachedBanner(
                    SONGMAN:GetSongGroupBannerPath(Songs[pos]))
            else
                self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :LoadCachedBanner(SONGMAN:GetSongGroupBannerPath(Songs[pos]))
            end
        else
            if TF_WHEEL.MaskMode then
                self:GetChild("CDCon"):GetChild("CD" .. ChangeOffset):GetChild(
                    "Container"):GetChild("CDPicture"):LoadCachedBanner(
                    THEME:GetPathG("Common", "fallback banner.png"))
            else
                self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :LoadCachedBanner(THEME:GetPathG("Common",
                                                     "fallback banner.png"))
            end
        end

        if TF_WHEEL.MaskMode then
            self:GetChild("CDCon"):GetChild("CD" .. ChangeOffset):GetChild(
                "Container"):GetChild("CDPicture"):setsize(-120, -120)
        else
            -- We make it so that the slices are always w512 h160, and then resize the CD slices so they fit as part of the CD.
            self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset):setsize(
                512, 160):SetCustomPosCoords(
                self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :GetWidth() / 2 - 23, 0, self:GetChild("Con")
                    :GetChild("CDSlice" .. ChangeOffset):GetWidth() / 2 - 9,
                -80, -self:GetChild("Con"):GetChild("CDSlice" .. ChangeOffset)
                    :GetWidth() / 2 + 9, -80, -self:GetChild("Con")
                    :GetChild("CDSlice" .. ChangeOffset):GetWidth() / 2 + 23, 0)
                :zoom(.4):y(-20)
        end
    end

    -- Stop all the music playing, Which is the Song Music
    SOUND:StopMusic()

    -- Check if its a song again.
    if type(Songs[TF_WHEEL.CurSong]) ~= "string" then
        -- Check if a song has a banner, If it doesnt show song title.
        if not Songs[TF_WHEEL.CurSong][1]:HasBanner() then
            self:GetChild("BannerText"):settext(
                Songs[TF_WHEEL.CurSong][1]:GetDisplayMainTitle())

            self:GetChild("Banner"):LoadCachedBanner(
                THEME:GetPathG("Common", "fallback banner.png"))
        else
            self:GetChild("BannerText"):settext("")

            self:GetChild("Banner"):LoadCachedBanner(
                Songs[TF_WHEEL.CurSong][1]:GetBannerPath())
        end

        -- This is the same as Centered Banner, But for CDTitles.
        if Songs[TF_WHEEL.CurSong][1]:HasCDTitle() then
            self:GetChild("CDTitle"):visible(true):Load(
                Songs[TF_WHEEL.CurSong][1]:GetCDTitlePath())
        else
            self:GetChild("CDTitle"):visible(false)
        end

        -- Its a group.
    else
        -- Set banner and hide cdtitle.
        if SONGMAN:GetSongGroupBannerPath(Songs[TF_WHEEL.CurSong]) ~= "" then
            self:GetChild("Banner"):LoadCachedBanner(
                SONGMAN:GetSongGroupBannerPath(Songs[TF_WHEEL.CurSong]))

            self:GetChild("BannerText"):settext("")
        else
            self:GetChild("Banner"):LoadCachedBanner(
                THEME:GetPathG("Common", "fallback banner.png"))

            -- Set name to group.
            self:GetChild("BannerText"):settext(Songs[TF_WHEEL.CurSong])
        end
        self:GetChild("CDTitle"):visible(false)
    end

    -- Play Current selected Song Music.
    self:GetChild("MusicCon"):stoptweening():sleep(0.4):queuecommand(
        "PlayCurrentSong")

    -- Resize the Centered Banner  to be w(512/8)*5 h(160/8)*5
    self:GetChild("Banner"):zoom(TF_WHEEL.Resize(
                                     self:GetChild("Banner"):GetWidth(),
                                     self:GetChild("Banner"):GetHeight(),
                                     (512 / 8) * 5, (160 / 8) * 5))

    -- Resize the CDTitles to be a max of w80 h80.
    self:GetChild("CDTitle"):zoom(TF_WHEEL.Resize(
                                      self:GetChild("CDTitle"):GetWidth(),
                                      self:GetChild("CDTitle"):GetHeight(), 80,
                                      80))
end

-- We use this function to do an effect on the content of the music wheel when we switch to next screen.
local function StartSelection(self, Songs)
    -- For ever CD on the Wheel we send them fying away.
    for i = 1, 9 do
        self:GetChild("CDCon"):GetChild("CD" .. i):GetChild("Container"):linear(
            .4):y(-1280)
    end
end

-- Move the Difficulty (or change selection in this case).
local function MoveDifficulty(self, offset, Songs)
    -- Check if its a group
    if type(Songs[TF_WHEEL.CurSong]) == "string" then
        -- If it is a group hide the diffs
        self:GetChild("Diffs"):visible(false)

        self:GetChild("Difficulty"):settext("")
        self:GetChild("DiffChart"):settext("")

        -- Not a group
    else
        self:GetChild("Diffs"):visible(true)
        -- Move the current difficulty + offset.
        TF_WHEEL.DiffPos[DiffPlayer] = TF_WHEEL.DiffPos[DiffPlayer] + offset

        -- Stay withing limits, But ignoring the first selection because its the entire song.
        if TF_WHEEL.DiffPos[DiffPlayer] > #Songs[TF_WHEEL.CurSong] - 1 then
            TF_WHEEL.DiffPos[DiffPlayer] = 1
        end
        if TF_WHEEL.DiffPos[DiffPlayer] < 1 then
            TF_WHEEL.DiffPos[DiffPlayer] = #Songs[TF_WHEEL.CurSong] - 1
        end

        -- Run on every feet, A feet is a part of the Difficulty, We got a max of 8 feets.
        for i = 1, 8 do
            self:GetChild("Diffs"):GetChild("Feet" .. i):diffuse(
                DiffColors[TF_WHEEL.DiffTab[Songs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[DiffPlayer] +
                    1]:GetDifficulty()]]):diffusealpha(0)
        end

        -- We get the Meter from the game, And make it so it stays between 8 which is the Max feets we support.
        local DiffCount = Songs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[DiffPlayer] +
                              1]:GetMeter()
        if DiffCount > 8 then DiffCount = 8 end

        -- For every Meter value we got for the game, We show the amount of feets for the difficulty, And center them.
        for i = 1, DiffCount do
            self:GetChild("Diffs"):GetChild("Feet" .. i):diffusealpha(1):x(30 *
                                                                               (i -
                                                                                   ((DiffCount /
                                                                                       2) +
                                                                                       .5)))
        end

        -- We grab the Difficulty Text and and change them to the names from the Difficulty Names.
        self:GetChild("Difficulty"):settext(
            DiffNames[TF_WHEEL.DiffTab[Songs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[DiffPlayer] +
                1]:GetDifficulty()]])

        -- Set the name of the Chart Difficulty.
        self:GetChild("DiffChart"):settext(DiffChartNames[DiffCount])
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

    -- All the CDs on the Wheel.
    local CDs = Def.ActorFrame {Name = "CDCon"}

    -- All the Slices of the CDs on the Wheel.
    local CDslice = Def.ActorFrame {Name = "Con"}

    -- Here we generate all the CDs for the wheel
    for i = 1, 9 do
        -- Position of current song, We want the cd in the front, So its the one we change.
        local pos = TF_WHEEL.CurSong + i - 5

        -- Stay within limits.
        while pos > #GroupsAndSongs do pos = pos - #GroupsAndSongs end
        while pos < 1 do pos = #GroupsAndSongs + pos end

        if TF_WHEEL.MaskMode then
            CDs[#CDs + 1] = Def.ActorFrame {
                Name = "CD" .. i,
                OnCommand = function(self)
                    -- We set FOV/Field Of Vision to get a dept effect.
                    self:rotationz((180 - (360 / 9) * (i - 5)) * -1):y(-80)
                        :rotationx(-52):SetFOV(80)
                end,
                -- The Container of the CDs.
                Def.ActorFrame {
                    Name = "Container",
                    OnCommand = function(self) self:y(-220) end,
                    Def.ActorProxy {
                        Name = "CDBG",
                        InitCommand = function(self)
                            self:SetTarget(
                                self:ForParent(4):GetChild("CDBGCon"):GetChild(
                                    "CDBG")):zoom(.23)
                        end
                    },
                    Def.Sprite {
                        Name = "CDMask",
                        Texture = THEME:GetPathG("", "DDR/CDMask.png"),
                        InitCommand = function(self)
                            self:zoom(.23):MaskSource(true)
                        end
                    },
                    Def.Sprite {
                        Name = "CDPicture",
                        -- Load fallback.
                        Texture = THEME:GetPathG("Common", "fallback banner.png"),
                        OnCommand = function(self)
                            -- Check if its a song.
                            if type(GroupsAndSongs[pos]) ~= "string" then
                                -- If the banner exist, Load Banner.png.
                                if GroupsAndSongs[pos][1]:HasBanner() then
                                    self:LoadCachedBanner(
                                        GroupsAndSongs[pos][1]:GetBannerPath())
                                end
                            else
                                -- IF group banner exist, Load banner.png
                                if SONGMAN:GetSongGroupBannerPath(
                                    GroupsAndSongs[pos]) ~= "" then
                                    self:LoadCachedBanner(
                                        SONGMAN:GetSongGroupBannerPath(
                                            GroupsAndSongs[pos]))
                                end
                            end

                            -- Resize the Banner to the size of the Mask.
                            self:setsize(-120, -120):MaskDest():ztestmode(
                                "ZTestMode_WriteOnFail")
                        end
                    }
                }
            }
        else
            -- We load a Banner once, We use ActorProxy to copy it, This is lighter than loading the Banner for every Slice.
            CDslice[#CDslice + 1] = Def.Sprite {
                Name = "CDSlice" .. i,
                -- Load fallback.
                Texture = THEME:GetPathG("Common", "fallback banner.png"),
                OnCommand = function(self)
                    -- Check if its a song.
                    if type(GroupsAndSongs[pos]) ~= "string" then
                        -- If the banner exist, Load Banner.png.
                        if GroupsAndSongs[pos][1]:HasBanner() then
                            self:LoadCachedBanner(
                                GroupsAndSongs[pos][1]:GetBannerPath())
                        end
                    else
                        -- IF group banner exist, Load banner.png
                        if SONGMAN:GetSongGroupBannerPath(GroupsAndSongs[pos]) ~=
                            "" then
                            self:LoadCachedBanner(
                                SONGMAN:GetSongGroupBannerPath(
                                    GroupsAndSongs[pos]))
                        end
                    end

                    -- Resize the Banner to the size of the slice.
                    self:setsize(512, 160):SetCustomPosCoords(self:GetWidth() /
                                                                  2 - 23, 0,
                                                              self:GetWidth() /
                                                                  2 - 9, -80,
                                                              -self:GetWidth() /
                                                                  2 + 9, -80,
                                                              -self:GetWidth() /
                                                                  2 + 23, 0)
                        :zoom(.4):y(-20):visible(false)
                end
            }

            -- The CDHolder, This contains all the slices, And at start the CD Background.
            local CDHolder = Def.ActorFrame {
                Name = "CDHolder",
                Def.ActorProxy {
                    Name = "CDBG",
                    InitCommand = function(self)
                        self:SetTarget(self:ForParent(5):GetChild("CDBGCon")
                                           :GetChild("CDBG")):zoom(.23)
                    end
                }
            }

            -- We use 18 slices for the CDs.
            for i2 = 1, 18 do
                CDHolder[#CDHolder + 1] = Def.ActorFrame {
                    OnCommand = function(self)
                        self:rotationz((360 / 18) * i2)
                    end,
                    -- The ActorProxy's that contain all the CD Slices.
                    Def.ActorProxy {
                        InitCommand = function(self)
                            self:SetTarget(
                                self:ForParent(6):GetChild("Con"):GetChild(
                                    "CDSlice" .. i))
                        end
                    }
                }
            end

            -- The CD's for the music wheel.
            CDs[#CDs + 1] = Def.ActorFrame {
                Name = "CD" .. i,
                OnCommand = function(self)
                    -- We set FOV/Field Of Vision to get a dept effect.
                    self:rotationz((180 - (360 / 9) * (i - 5)) * -1):y(-80)
                        :rotationx(-52):SetFOV(80)
                end,
                -- The Container of the Slices.
                Def.ActorFrame {
                    Name = "Container",
                    OnCommand = function(self) self:y(-220) end,
                    CDHolder
                }
            }
        end
    end

    -- The Left and Right Arrows that change when you press Left or Right.
    local TriSel = Def.ActorFrame {}

    -- We make the arrows out of Triangles, We need 2 images.
    for i = 0, 1 do
        TriSel[#TriSel + 1] = Def.Sprite {
            Texture = THEME:GetPathG("", "Triangle.png"),
            OnCommand = function(self) self:zoom(.06):y(18 * i) end
        }
    end

    -- The Difficulty Display.
    local Diff = Def.ActorFrame {Name = "Diffs"}

    -- The amount of Feet we use to display the Difficulty using the Meter.
    for i = 1, 8 do
        Diff[#Diff + 1] = Def.Sprite {
            Name = "Feet" .. i,
            Texture = THEME:GetPathG("", "DDR/Feet.png"),
            InitCommand = function(self)
                self:zoomx(-.25):zoomy(.3):x(30 * (i - 4.5))
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
                if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
                    TF_WHEEL.BG:LoadCachedBackground(
                        GroupsAndSongs[TF_WHEEL.CurSong][1]:GetBackgroundPath())
                        :FullScreen()
                    if GroupsAndSongs[TF_WHEEL.CurSong][1].PlayPreviewMusic then
                        GroupsAndSongs[TF_WHEEL.CurSong][1]:PlayPreviewMusic()
                    elseif GroupsAndSongs[TF_WHEEL.CurSong][1]:GetMusicPath() then
                        SOUND:PlayMusicPart(
                            GroupsAndSongs[TF_WHEEL.CurSong][1]:GetMusicPath(),
                            GroupsAndSongs[TF_WHEEL.CurSong][1]:GetSampleStart(),
                            GroupsAndSongs[TF_WHEEL.CurSong][1]:GetSampleLength(),
                            0, 0, true)
                    end
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
            self:GetChild("Left"):stoptweening()
            -- Play the colour effect 5 times.
            for i = 1, 5 do
                self:GetChild("Left"):queuecommand("Colour")
            end
        end,

        -- Do stuff when a user presses Right on Pad or Menu buttons.
        MenuRightCommand = function(self)
            MoveSelection(self, 1, GroupsAndSongs)
            MoveDifficulty(self, 0, GroupsAndSongs)
            self:GetChild("Right"):stoptweening()
            -- Play the colour effect 5 times.
            for i = 1, 5 do
                self:GetChild("Right"):queuecommand("Colour")
            end
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
                if GAMESTATE:IsSideJoined(PLAYER_1) and
                    GAMESTATE:IsSideJoined(PLAYER_2) then
                    -- If both players are joined, We want to unjoin the player that pressed back.
                    GAMESTATE:UnjoinPlayer(self.pn)

                    -- A Player left, Change back to Single.
                    self:GetChild("Style"):settext("SINGLE")
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
                                                  GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[DiffPlayer] +
                                                      1])
                        GAMESTATE:SetCurrentSteps(PLAYER_2,
                                                  GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[DiffPlayer] +
                                                      1])
                    else
                        -- If we are single player, Use Single.
                        GAMESTATE:SetCurrentStyle(TF_WHEEL.StyleDB[Style])

                        -- Save Profile.
                        PROFILEMAN:SaveProfile(self.pn)

                        -- Set the Current Step to use.
                        GAMESTATE:SetCurrentSteps(self.pn,
                                                  GroupsAndSongs[TF_WHEEL.CurSong][TF_WHEEL.DiffPos[DiffPlayer] +
                                                      1])
                    end

                    -- We want to go to player options when people doublepress, So we set the StartOptions to true,
                    -- So when the player presses Start again, It will go to player options.
                    StartOptions = true

                    -- Do the effects on actors.
                    StartSelection(self, GroupsAndSongs)

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
                if GAMESTATE:IsSideJoined(PLAYER_1) and
                    GAMESTATE:IsSideJoined(PLAYER_2) then
                    self:GetChild("Style"):settext("VERSUS")
                end
            end
        end,

        -- Change to ScreenGameplay.
        StartSongCommand = function(self)
            SCREENMAN:GetTopScreen():SetNextScreenName(
                "ScreenLoadGameplayElements"):StartTransitioningScreen(
                "SM_GoToNextScreen")
        end,

        -- The CD Background.
        Def.ActorFrame {
            Name = "CDBGCon",
            -- We define the zoom as 0 to hide the CD Background,
            -- Because we use an ActorProxy to display it.
            OnCommand = function(self) self:zoom(0) end,
            Def.Sprite {
                Name = "CDBG",
                Texture = THEME:GetPathG("", "DDR/CDCon.png")
            }
        },
        CDslice, -- Load CD Slices.
        CDs .. {OnCommand = function(self) self:y(-25) end}, -- Load CDs.

        -- Load the Global Centered Banner.
        Def.Sprite {
            Name = "Banner",
            Texture = THEME:GetPathG("Common", "fallback banner.png"),
            OnCommand = function(self)
                -- Check if we are on song
                if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
                    self:LoadCachedBanner(
                        GroupsAndSongs[TF_WHEEL.CurSong][1]:GetBannerPath())

                    -- Not on song, Show group banner.
                else
                    if SONGMAN:GetSongGroupBannerPath(
                        GroupsAndSongs[TF_WHEEL.CurSong]) ~= "" then
                        self:LoadCachedBanner(
                            SONGMAN:GetSongGroupBannerPath(
                                GroupsAndSongs[TF_WHEEL.CurSong]))
                    else
                        self:visible(false)
                    end
                end

                self:y(-80):zoom(TF_WHEEL.Resize(self:GetWidth(),
                                                 self:GetHeight(),
                                                 (512 / 8) * 5, (160 / 8) * 5))
            end
        },

        -- Global Centered Banner Text, Incase there is no banner.
        Def.BitmapText {
            Name = "BannerText",
            Font = "_noto sans 40px",
            OnCommand = function(self)
                -- Check if we are on group.
                if type(GroupsAndSongs[TF_WHEEL.CurSong]) == "string" then
                    -- Check if group has banner, If so, Set text to empty
                    if SONGMAN:GetSongGroupBannerPath(
                        GroupsAndSongs[TF_WHEEL.CurSong]) == "" then
                        self:settext(GroupsAndSongs[TF_WHEEL.CurSong])
                    end
                    -- not group.
                else
                    -- Check if we have banner, if not, set text to song title.
                    if not GroupsAndSongs[TF_WHEEL.CurSong][1]:HasBanner() then
                        self:settext(
                            GroupsAndSongs[TF_WHEEL.CurSong][1]:GetDisplayMainTitle())
                    end
                end

                self:y(-80):diffuse(1, 1, 0, 1):strokecolor(0, 0, 1, 1):zoom(.5)
            end
        },

        -- Load the CDTitles.
        Def.Sprite {
            Name = "CDTitle",
            Texture = THEME:GetPathG("Common", "fallback banner.png"),
            OnCommand = function(self)
                -- Check if its a song.
                if type(GroupsAndSongs[TF_WHEEL.CurSong]) ~= "string" then
                    self:visible(true):Load(
                        GroupsAndSongs[TF_WHEEL.CurSong][1]:GetCDTitlePath())

                    -- Not song, Hide CDTitle.
                else
                    self:visible(false)
                end

                self:xy(220, 120):zoom(TF_WHEEL.Resize(self:GetWidth(),
                                                       self:GetHeight(), 80, 80))
            end
        },

        -- Load the Difficulty Text.
        Def.BitmapText {
            Name = "Difficulty",
            Font = "_noto sans 40px",
            OnCommand = function(self)
                self:xy(-220, 110):diffuse(1, 1, 0, 1):strokecolor(0, 0, 1, 1)
                    :zoom(.5)
            end
        },

        -- Load the Syle Text.
        Def.BitmapText {
            Name = "Style",
            Text = "SINGLE",
            Font = "_noto sans 40px",
            OnCommand = function(self)
                self:xy(-220, 130):diffuse(1, 1, 0, 1):strokecolor(0, 0, 1, 1)
                    :zoom(.5)
            end
        },

        -- Load the arrow for the Left size.
        TriSel .. {
            Name = "Left",
            OnCommand = function(self)
                self:xy(-120, 50):rotationz(-90):diffuse(1, 0, 0, 1)
            end,
            ColourCommand = function(self)
                self:sleep(0.02):diffuse(0, 0, 1, 1):sleep(0.02):diffuse(1, 1,
                                                                         1, 1)
                    :sleep(0.02):diffuse(1, 0, 0, 1)
            end
        },

        -- Load the arrow for the Right size.
        TriSel .. {
            Name = "Right",
            OnCommand = function(self)
                self:xy(120, 50):rotationz(90):diffuse(1, 0, 0, 1)
            end,
            ColourCommand = function(self)
                self:sleep(0.02):diffuse(0, 0, 1, 1):sleep(0.02):diffuse(1, 1,
                                                                         1, 1)
                    :sleep(0.02):diffuse(1, 0, 0, 1)
            end
        },

        -- The Difficulty Feet Meter.
        Diff .. {OnCommand = function(self) self:y(130) end},

        -- The Difficulty Chart Names based on Meter.
        Def.BitmapText {
            Name = "DiffChart",
            Font = "_noto sans 40px",
            OnCommand = function(self)
                self:y(150):diffuse(1, 1, 0, 1):strokecolor(0, 0, 1, 1):zoom(.5)
            end
        }
    }
end
