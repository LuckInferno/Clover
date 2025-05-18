local ratios = {
    Height = 30 / 1080,
    Width = 1920 / 1920,
    TextHorizontalPadding = 15 / 1920, -- distance to move text to align left or right from edge
}

local actuals = {
    Height = ratios.Height * SCREEN_HEIGHT,
    Width = ratios.Width * SCREEN_WIDTH,
    TextHorizontalPadding = ratios.TextHorizontalPadding * SCREEN_WIDTH,
}

-- how much of the visible area can the quote take up before being restricted in width?
local allowedPercentageForQuote = 1
local textSize = 0.95
local textZoomFudge = 5
local p1name = GAMESTATE:GetPlayerDisplayName(PLAYER_1)
local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate()
local judge = THEME:GetString("ScreenGameplay", "JudgeDifficulty"), GetTimingDifficulty()
local mods = GAMESTATE:GetPlayerState():GetPlayerOptionsString("ModsLevel_Current")

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
    Name = "GameplayFooterFile",
    InitCommand = function(self)
        -- all positions should be relative to the bottom left corner of the screen
        self:y(SCREEN_HEIGHT)

        -- update current time
        self:SetUpdateFunction(function(self)
            self:GetChild("CurrentTime"):playcommand("UpdateTime")
        end)
        -- update once per second
        self:SetUpdateFunctionInterval(1)
    end
}

t[#t+1] = Def.Quad {
    Name = "BG",
    InitCommand = function(self)
        self:halign(0):valign(1)
        self:zoomto(actuals.Width, actuals.Height)
        self:diffusealpha(0.6)
        registerActorToColorConfigElement(self, "main", "PrimaryBackground")
    end
}

t[#t+1] = LoadFont("Common Normal") .. {
    Name = "UserName",
    InitCommand = function(self)
        self:halign(0)
        self:xy(actuals.TextHorizontalPadding, -actuals.Height / 2)
        self:zoom(textSize)
        registerActorToColorConfigElement(self, "main", "PrimaryText")
        self:settextf("%s J%s", p1name, GetTimingDifficulty())
    end
}

t[#t+1] = LoadFont("Common Normal") .. {
    Name = "CurrentTime",
    InitCommand = function(self)
        self:halign(1)
        self:xy(actuals.Width - actuals.TextHorizontalPadding, -actuals.Height / 2)
        self:zoom(textSize)
        self:maxwidth(actuals.Width * (1) / textSize - textZoomFudge)
        registerActorToColorConfigElement(self, "main", "PrimaryText")
        self:playcommand("UpdateTime")
    end,
    UpdateTimeCommand = function(self)
        local year = Year()
        local month = MonthOfYear() + 1
        local day = DayOfMonth()
        local hour = Hour()
        local minute = Minute()
        local second = Second()
        self:settextf("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
    end
}

-- t[#t + 1] = LoadFont("Common Normal") .. {
--     -- Judge
--     InitCommand = function(self)
--         self:zoom(textSize)
--         self:halign(0)
--         local x = self:GetParent():GetChild("UserName"):GetWidth()
--         self:xy(actuals.TextHorizontalPadding + x, -actuals.Height / 2)
--         registerActorToColorConfigElement(self, "main", "PrimaryText")
--     end,
--     BeginCommand = function(self)
--         self:settextf("%s: %d", THEME:GetString("ScreenGameplay", "JudgeDifficulty"), GetTimingDifficulty())
--     end,
--     DoneLoadingNextSongMessageCommand = function(self)
--         self:settextf("%s: %d", THEME:GetString("ScreenGameplay", "JudgeDifficulty"), GetTimingDifficulty())
--     end,
-- }


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
            self:zoom(textSize)
            self:x(actuals.Width/2)
            self:y(-actuals.Height / 2)
            registerActorToColorConfigElement(self, "main", "PrimaryText")
        end,
    }
}





return t