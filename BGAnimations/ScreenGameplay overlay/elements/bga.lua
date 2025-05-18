local ratios = {
    Width = (512 + 30) / 1920, -- Width
	Height = (512 + 30) / 1080, -- Height
    OutlineWidth = 2 / 1920,
    OutlineHeight = 2 / 1080,
    GapRight = (50 - 15) / 1920, -- Distance from right of screen to right edge
    -- GapBottom = (500 - 15) / 1080, -- Distance from bottom of screen to bottom edge
    GapBottom =(((1080 - 512) * (3/4)) - 15) / 1080,
}

local actuals = {
    Width = ratios.Width * SCREEN_WIDTH,
    Height = ratios.Height * SCREEN_HEIGHT,
    OutlineWidth = ratios.OutlineWidth * SCREEN_WIDTH,
    OutlineHeight = ratios.OutlineHeight * SCREEN_HEIGHT,
    GapRight = ratios.GapRight * SCREEN_WIDTH,
    GapBottom = ratios.GapBottom * SCREEN_HEIGHT,
}

local colors = {
    Frame = color("#FFFFFF"),
    FrameDark = color("#000000"),
}

local opacities = {
    BG = 0.75,
}

local song = GAMESTATE:GetCurrentSong()

local t = Def.ActorFrame {
    Name="BGA",
    InitCommand = function(self)
        self:xy(SCREEN_WIDTH - actuals.GapRight, SCREEN_HEIGHT - actuals.GapBottom)
        self:visible(true)
    end,
    OnCommand = function(self)
        self:sleep(5)
        self:smooth(1):diffusealpha(1)
    end,
}



t[#t + 1] = Def.Quad {
    InitCommand = function(self)
        self:halign(1):valign(1)
        self:xy(actuals.OutlineWidth, actuals.OutlineHeight)
        self:zoomtowidth(actuals.Width + (2 * actuals.OutlineWidth))
        self:zoomtoheight(actuals.Height + (2 * actuals.OutlineHeight))
        self:diffuse(colors.Frame)
        self:diffusealpha(1)
    end,
}

t[#t + 1] = Def.Quad {
    InitCommand = function(self)
        self:halign(1):valign(1)
        self:zoomtowidth(actuals.Width)
        self:zoomtoheight(actuals.Height)
        self:diffuse(colors.FrameDark)
        self:diffusealpha(1)
    end,
}

t[#t + 1] = Def.Sprite {
    Name = "BGSprite",
    InitCommand = function(self)
        self:halign(1):valign(1)
        self:diffusealpha(0)
    end,
    CurrentSongChangedMessageCommand = function(self)
        self:stoptweening():diffusealpha(0)
        self:sleep(0.2):queuecommand("ModifySongBackground")
    end,
    ModifySongBackgroundCommand = function(self)
        if song and song:GetBackgroundPath() then
            self:finishtweening()
            self:visible(true)
            self:LoadBackground(song:GetBackgroundPath())
            -- self:scaletoclipped(actuals.Width, actuals.Height)
            self:zoomtoheight(actuals.Height)
            self:cropto(actuals.Width, actuals.Height)
            self:sleep(0.05)
            self:smooth(0.4):diffusealpha(1)
        else
            self:visible(false)
        end
    end,
    OffCommand = function(self)
        self:smooth(0.6):diffusealpha(0)
    end,
}

t[#t + 1] = Def.Quad {
    InitCommand = function(self)
        self:halign(1):valign(1)
        self:zoomtowidth(actuals.Width)
        self:zoomtoheight(actuals.Height)
        self:diffuse(colors.FrameDark)
        self:diffusealpha(1 - opacities.BG)
    end,
}

return t