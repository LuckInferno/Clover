local ratios = {
    Height = 30 / 1080,
    Width = 1920 / 1920,
    ColumnWidth = 512 / 1920,
    ColumnGap = 50 / 1920,
    TextHorizontalPadding = 15 / 1920 -- distance to move text to align left or right from edge
}

local actuals = {
    Height = ratios.Height * SCREEN_HEIGHT,
    Width = ratios.Width * SCREEN_WIDTH,
    ColumnWidth = ratios.ColumnWidth * SCREEN_WIDTH,
    ColumnGap = ratios.ColumnGap * SCREEN_WIDTH,
    TextHorizontalPadding = ratios.TextHorizontalPadding * SCREEN_WIDTH
}

-- how much of the visible area can the quote take up before being restricted in width?
local allowedPercentageForQuote = 1
local textSize = 0.95
local textZoomFudge = 5
local p1name = GAMESTATE:GetPlayerDisplayName(PLAYER_1)
local subtitle = GAMESTATE:GetCurrentSong():GetDisplaySubTitle()
local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate()
local author = GAMESTATE:GetCurrentSong():GetOrTryAtLeastToGetSimfileAuthor()
local artist = GAMESTATE:GetCurrentSong():GetDisplayArtist()
local title = GAMESTATE:GetCurrentSong():GetDisplayMainTitle()
local mods = GAMESTATE:GetPlayerState():GetPlayerOptionsString(
                 "ModsLevel_Current")
local group = GAMESTATE:GetCurrentSong():GetGroupName()
local song = GAMESTATE:GetCurrentSong()

local t = Def.ActorFrame {
    Name = "GameplayHeaderFile",
    InitCommand = function(self)
        -- all positions should be relative to the bottom left corner of the screen
        self:y(actuals.Height)
    end
}

t[#t + 1] = Def.Quad {
    Name = "BG",
    InitCommand = function(self)
        self:halign(0):valign(1)
        self:zoomto(actuals.Width, actuals.Height)
        self:diffusealpha(0.6)
        registerActorToColorConfigElement(self, "main", "PrimaryBackground")
    end
}

t[#t + 1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:halign(0)
        self:xy(actuals.TextHorizontalPadding, -actuals.Height / 2)
        self:zoom(textSize)
        registerActorToColorConfigElement(self, "main", "PrimaryText")
    end,
    BeginCommand = function(self) self:settext(group) end,
    DoneLoadingNextSongMessageCommand = function(self) self:settext(group) end
}

t[#t + 1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:x(actuals.Width - actuals.ColumnGap - (actuals.ColumnWidth/2))
        self:y(-actuals.Height / 2)
        self:zoom(textSize)
        registerActorToColorConfigElement(self, "main", "PrimaryText")
        self:maxwidth((actuals.ColumnWidth) / textSize)
    end,
    SetCommand = function(self)
        local difficulty = getDifficulty(GAMESTATE:GetCurrentSteps():GetDifficulty())
        self:settextf("%s - %s [%s]", artist, title, difficulty)
        local color = colorByDifficulty(GetCustomDifficulty(
                                      GAMESTATE:GetCurrentSteps():GetStepsType(),
                                      GAMESTATE:GetCurrentSteps()
                                          :GetDifficulty()))
        self:AddAttribute(#string.format("%s - %s [", artist, title), {Length = #difficulty, Zoom = textSize, Diffuse = color})
    end,
    CurrentRateChangedMessageCommand = function(self) self:playcommand("Set") end,
    PracticeModeReloadMessageCommand = function(self) self:playcommand("Set") end,
    DoneLoadingNextSongMessageCommand = function(self)
        self:playcommand("Set")
    end
}

t[#t + 1] = LoadFont("Common Normal") .. {
    -- Subtitle + Credit
    InitCommand = function(self)
        self:zoom(textSize * 0.75)
        self:x(actuals.Width - actuals.ColumnGap - (actuals.ColumnWidth/2))
        self:y((-actuals.Height / 2) + actuals.Height)
        self:maxwidth((actuals.ColumnWidth) / (textSize * 0.75))
        registerActorToColorConfigElement(self, "main", "PrimaryText")
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

return t
