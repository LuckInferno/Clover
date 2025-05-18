local ratios = {
    Width = 512 / 1920,
    GapRight = 50 / 1920,
    GapTop = (1080 - ((1080 - 512) * (3/4))) / 1080,
    Spacing = 15 / 1080
}
local actuals = {
    Width = ratios.Width * SCREEN_WIDTH,
    GapRight = ratios.GapRight * SCREEN_WIDTH,
    GapTop = ratios.GapTop * SCREEN_HEIGHT,
    Spacing = ratios.Spacing * SCREEN_HEIGHT
}
local colors = {
    Shadow = color("#000000"),
    Text = color("#FFFFFF")
}
local translations = {
    Judge = THEME:GetString("ScreenGameplay", "JudgeDifficulty"),
    Scoring = THEME:GetString("ScreenGameplay", "ScoringType"),
}

local subtitle = GAMESTATE:GetCurrentSong():GetDisplaySubTitle()
local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate()
local author = GAMESTATE:GetCurrentSong():GetOrTryAtLeastToGetSimfileAuthor()
local artist = GAMESTATE:GetCurrentSong():GetDisplayArtist()
local title = GAMESTATE:GetCurrentSong():GetDisplayMainTitle()
local mods = GAMESTATE:GetPlayerState():GetPlayerOptionsString("ModsLevel_Current")
local fontSize = 0.8
local fontRatio = (fontSize * 24) / 720
local offset = actuals.Spacing

local function initbpm(self)
    local r = GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate() * 60
    local a = GAMESTATE:GetPlayerState():GetSongPosition()
    local GetBPS = SongPosition.GetCurBPS
    if #GAMESTATE:GetCurrentSong():GetTimingData():GetBPMs() > 1 then
        self:SetUpdateFunction(function(self)
            local bpm = GetBPS(a) * r
            self:GetChild("RateBPM"):settextf("%5.2fxMusic, %5.2fBPM", rate, notShit.round(bpm, 2))
        end)
        self:SetUpdateRate(0.5)
    else
        local bpm = GetBPS(a) * r
        self:GetChild("RateBPM"):settextf("%5.2fxMusic, %5.2fBPM", rate, notShit.round(bpm, 2))
    end
end


local t = Def.ActorFrame {
    Name = "SongInfo",
    InitCommand = function(self)
        self:x(SCREEN_WIDTH - actuals.GapRight - actuals.Width)
        self:y(actuals.GapTop)
    end
}

t[#t + 1] = LoadFont("Common Normal") .. {
    -- title
    InitCommand = function(self)
        self:zoom(fontSize * 1.25)
        self:x(actuals.Width/2)
        self:y(offset)
        self:valign(0)
        self:maxwidth(actuals.Width / (fontSize * 1.25))
        self:diffuse(colors.Text)
        self:shadowlength(1)
        self:shadowcolor(colors.Shadow)

        offset = offset + actuals.Spacing + (16 * (fontSize * 1.25))
    end,
    BeginCommand = function(self)
        self:settextf("%s - %s", artist, title)
    end,
    DoneLoadingNextSongMessageCommand = function(self)
        self:settextf("%s - %s", artist, title)
    end,
}


t[#t + 1] = LoadFont("Common Normal") .. {
    -- Mods
    InitCommand = function(self)
        self:zoom(fontSize)
        self:x(actuals.Width/2)
        self:y(offset)
        self:valign(0)
        self:maxwidth(actuals.Width / fontSize)
        self:diffuse(colors.Text)
        self:shadowlength(1)
        self:shadowcolor(colors.Shadow)
        offset = offset + actuals.Spacing + (16 * (fontSize))
    end,
    BeginCommand = function(self)
        self:settext(mods)
    end,
    DoneLoadingNextSongMessageCommand = function(self)
        self:settext(mods)
    end,
}

t[#t + 1] = LoadFont("Common Normal") .. {
    -- Subtitle + Credit
    InitCommand = function(self)
        self:zoom(fontSize)
        self:x(actuals.Width/2)
        self:y(offset)
        self:valign(0)
        self:maxwidth(actuals.Width / fontSize)
        self:diffuse(colors.Text)
        self:shadowlength(1)
        self:shadowcolor(colors.Shadow)
        offset = offset + actuals.Spacing + (16 * (fontSize))
    end,
    BeginCommand = function(self)
        if string.len(subtitle) > 0 then
            self:settextf("\"%s\" -%s", subtitle, author)
        else
            self:settextf("%s", author)
        end
    end,
    DoneLoadingNextSongMessageCommand = function(self)
        if string.len(subtitle) > 0 then
            self:settextf("\"%s\" -%s", subtitle, author)
        else
            self:settextf("%s", author)
        end
    end,
}

t[#t + 1] = Def.ActorFrame {
    Name = "RateBPMText",
    InitCommand = function(self)
        self:queuecommand("Set")
    end,
    SetCommand = function(self)
        initbpm(self)
    end,
    CurrentRateChangedMessageCommand = function(self)
        self:playcommand("Set")
    end,
    PracticeModeReloadMessageCommand = function(self)
        self:playcommand("Set")
    end,
    DoneLoadingNextSongMessageCommand = function(self)
        self:playcommand("Set")
    end,
    LoadFont("Common Normal") .. {
        -- Rate + BPM
        Name = "RateBPM",
        InitCommand = function(self)
            self:zoom(fontSize)
            self:x(actuals.Width/2)
            self:y(offset)
            self:valign(0)
            self:maxwidth(actuals.Width / fontSize)
            self:diffuse(colors.Text)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
            offset = offset + actuals.Spacing + (16 * (fontSize))
        end,
    }
}

t[#t + 1] = Def.ActorFrame {
    Name = "JudgeAndDiff",
    InitCommand = function(self)
        self:SetWidth(self:GetChild("Difficulty"):GetWidth() + self:GetChild("Judge"):GetWidth())
        self:x(actuals.Width/2 - (self:GetWidth()/2))
        self:halign(0.5)
    end,
    LoadFont("Common Normal") .. {
        Name = "Judge",
        InitCommand = function(self)
            self:zoom(fontSize)
            self:valign(0)
            self:halign(0)
            self:y(offset)
            self:maxwidth(actuals.Width / fontSize)
            self:diffuse(colors.Text)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
        end,
        BeginCommand = function(self)
            self:settextf("%s: %d", translations["Judge"], GetTimingDifficulty())
        end,
        DoneLoadingNextSongMessageCommand = function(self)
            self:settextf("%s: %d", translations["Judge"], GetTimingDifficulty())
        end,
    },
    LoadFont("Common Normal") .. {
        Name = "Difficulty",
        InitCommand = function(self)
            self:zoom(fontSize)
            self:valign(0)
            self:halign(0)
            self:y(offset)
            self:maxwidth(actuals.Width / fontSize)
            self:diffuse(colors.Text)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
            offset = offset + actuals.Spacing + (16 * (fontSize))
        end,
        SetCommand = function(self)
            self:settextf(" %s", getDifficulty(GAMESTATE:GetCurrentSteps():GetDifficulty()))
            self:diffuse(
                colorByDifficulty(
                    GetCustomDifficulty(
                        GAMESTATE:GetCurrentSteps():GetStepsType(),
                        GAMESTATE:GetCurrentSteps():GetDifficulty()
                    )
                )
            )
        end,
        CurrentRateChangedMessageCommand = function(self)
            self:playcommand("Set")
        end,
        PracticeModeReloadMessageCommand = function(self)
            self:playcommand("Set")
        end,
        DoneLoadingNextSongMessageCommand = function(self)
            self:playcommand("Set")
        end,
    }

}


-- t[#t + 1] = LoadFont("Common Normal") .. {
--     -- Judge
--     InitCommand = function(self)
--         self:zoom(fontSize)
--         self:halign(1)
--         self:valign(0)
--         self:x((actuals.Width) / 2)
--         self:y(offset)
--         self:maxwidth(actuals.Width / fontSize)
--         self:diffuse(colors.Text)
--         self:shadowlength(1)
--         self:shadowcolor(colors.Shadow)
--     end,
--     BeginCommand = function(self)
--         self:settextf("%s: %d", translations["Judge"], GetTimingDifficulty())
--     end,
--     DoneLoadingNextSongMessageCommand = function(self)
--         self:settextf("%s: %d", translations["Judge"], GetTimingDifficulty())
--     end,
-- }

-- t[#t + 1] = LoadFont("Common Normal") .. {
--     -- Difficulty
--     InitCommand = function(self)
--         self:zoom(fontSize)
--         self:halign(0)
--         self:valign(0)
--         self:x((actuals.Width) / 2)
--         self:y(offset)
--         self:maxwidth(actuals.Width / fontSize)
--         self:diffuse(colors.Text)
--         self:shadowlength(1)
--         self:shadowcolor(colors.Shadow)
--         offset = offset + actuals.Spacing + (16 * (fontSize))
--     end,
--     SetCommand = function(self)
--         self:settextf(" %s", getDifficulty(GAMESTATE:GetCurrentSteps():GetDifficulty()))
--         self:diffuse(
--             colorByDifficulty(
--                 GetCustomDifficulty(
--                     GAMESTATE:GetCurrentSteps():GetStepsType(),
--                     GAMESTATE:GetCurrentSteps():GetDifficulty()
--                 )
--             )
--         )
--     end,
--     CurrentRateChangedMessageCommand = function(self)
--         self:playcommand("Set")
--     end,
--     PracticeModeReloadMessageCommand = function(self)
--         self:playcommand("Set")
--     end,
--     DoneLoadingNextSongMessageCommand = function(self)
--         self:playcommand("Set")
--     end,
-- }




return t

