local ratios = {
    GapLeft = 0 / 1920,
    GapTop = 40 / 1080,
    Width = 30 / 1920,
    Height = (1080 - 40 - 40) / 1080,
    BarHeight = 110 / 1080,
    Bevel = 2 / 1080
}
local actuals = {
    GapLeft = ratios.GapLeft * SCREEN_WIDTH,
    GapTop = ratios.GapTop * SCREEN_HEIGHT,
    Width = ratios.Width * SCREEN_WIDTH,
    Height = ratios.Height * SCREEN_HEIGHT,
    BarHeight = ratios.BarHeight * SCREEN_HEIGHT,
    Bevel = ratios.Bevel * SCREEN_HEIGHT
}
local colors = {
    BG = color("#e0e0e0"),
    Layer1 = color("#000000"),
    Layer2 = color("#c0c0c0"),
    Layer3 = color("#808080"),
    Layer4 = color("#ffffff"),
    Layer5 = color("#c0c0c0"),
    Arrow = color("#000000")
}
-- local colors = {
--     BG = color("#000000"),
--     Layer1 = color("#000000"),
--     Layer2 = color("#c0c0c0"),
--     Layer3 = color("#808080"),
--     Layer4 = color("#ffffff"),
--     Layer5 = color("#c0c0c0"),
--     Arrow = color("#000000")
-- }
-- local colors = {
--     BG = color("#431729"),
--     Layer1 = color("#000000"),
--     Layer2 = color("#ff7daf"),
--     Layer3 = color("#9f3b52"),
--     Layer4 = color("#ffcdff"),
--     Layer5 = color("#ffa6c5"),
--     Arrow = color("#000000")
-- }

local trackStart = actuals.Width
local trackEnd = actuals.Height - actuals.Width - actuals.BarHeight
local trackLength = trackEnd - trackStart
local steps = GAMESTATE:GetCurrentSteps()

local function UpdateProgressPosition(self, params)
    local top = SCREENMAN:GetTopScreen()
    local song = GAMESTATE:GetCurrentSong()
    local r = getCurRateValue()
    local musicpositionratio = 1

    if steps ~= nil and top ~= nil and song then
        local length = steps:GetLengthSeconds()
        musicpositionratio =
            (steps:GetFirstSecond() / r + length) / trackLength * r
        if top.GetSampleMusicPosition then
            local pos = top:GetSampleMusicPosition() / musicpositionratio
            self:y(clamp(pos + trackStart, trackStart, trackEnd))
        elseif top.GetSongPosition then
            local pos = top:GetSongPosition() / musicpositionratio
            self:y(clamp(pos + trackStart, trackStart, trackEnd))
        else
            self:y(trackStart)
        end
    else
        self:y(trackStart)
    end
end

local t = Def.ActorFrame {
    Name = "Scroll Bar",
    InitCommand = function(self)
        self:xy(0, 0)
        self:visible(true)
    end
}

t[#t + 1] = Def.Quad {
    Name = "BG",
    InitCommand = function(self)
        self:xy(0, 0)
        self:halign(0):valign(0)
        self:zoomtowidth(actuals.Width)
        self:zoomtoheight(actuals.Height)
        self:diffuse(colors.BG)
        self:diffusealpha(0.5)
    end
}
t[#t + 1] = Def.ActorFrame { -- Top Cap
    Name = "Top Cap",
    InitCommand = function(self)
        self:xy(0, 0)
        self:halign(0):valign(0)
        self:visible(true)
    end,
    Def.Quad {
        Name = "Layer 1",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:zoomtowidth(actuals.Width)
            self:zoomtoheight(actuals.Width)
            self:diffuse(colors.Layer1)
        end
    },
    Def.Quad {
        Name = "Layer 2",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:zoomtowidth(actuals.Width - actuals.Bevel)
            self:zoomtoheight(actuals.Width - actuals.Bevel)
            self:diffuse(colors.Layer2)
        end
    },
    Def.Quad {
        Name = "Layer 3",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy(actuals.Bevel, actuals.Bevel)
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 2))
            self:zoomtoheight(actuals.Width - (actuals.Bevel * 2))
            self:diffuse(colors.Layer3)
        end
    },
    Def.Quad {
        Name = "Layer 4",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy(actuals.Bevel, actuals.Bevel)
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 3))
            self:zoomtoheight(actuals.Width - (actuals.Bevel * 3))
            self:diffuse(colors.Layer4)
        end
    },
    Def.Quad {
        Name = "Layer 5",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy((actuals.Bevel * 2), (actuals.Bevel * 2))
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 4))
            self:zoomtoheight(actuals.Width - (actuals.Bevel * 4))
            self:diffuse(colors.Layer5)
        end
    },
    Def.Sprite {
        Name = "Arrow Up",
        Texture = THEME:GetPathG("", "_triangle"),
        InitCommand = function(self)
            self:halign(0.5):valign(0.5)
            self:xy(actuals.Width / 2, actuals.Width / 2)
            self:zoomtowidth(actuals.Width / 2)
            self:zoomtoheight(actuals.Width / 3)
            self:diffuse(colors.Arrow)
        end
    }
}
t[#t + 1] = Def.ActorFrame { -- Bottom Cap
    Name = "Bottom Cap",
    InitCommand = function(self)
        self:visible(true)
        self:halign(0):valign(0)
        self:x(0)
        self:y(actuals.Height - actuals.Width)
    end,
    Def.Quad {
        Name = "Layer 1",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:zoomtowidth(actuals.Width)
            self:zoomtoheight(actuals.Width)
            self:diffuse(colors.Layer1)
        end
    },
    Def.Quad {
        Name = "Layer 2",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:zoomtowidth(actuals.Width - actuals.Bevel)
            self:zoomtoheight(actuals.Width - actuals.Bevel)
            self:diffuse(colors.Layer2)
        end
    },
    Def.Quad {
        Name = "Layer 3",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy(actuals.Bevel, actuals.Bevel)
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 2))
            self:zoomtoheight(actuals.Width - (actuals.Bevel * 2))
            self:diffuse(colors.Layer3)
        end
    },
    Def.Quad {
        Name = "Layer 4",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy(actuals.Bevel, actuals.Bevel)
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 3))
            self:zoomtoheight(actuals.Width - (actuals.Bevel * 3))
            self:diffuse(colors.Layer4)
        end
    },
    Def.Quad {
        Name = "Layer 5",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy((actuals.Bevel * 2), (actuals.Bevel * 2))
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 4))
            self:zoomtoheight(actuals.Width - (actuals.Bevel * 4))
            self:diffuse(colors.Layer5)
        end
    },
    Def.Sprite {
        Name = "Arrow Up",
        Texture = THEME:GetPathG("", "_triangle"),
        InitCommand = function(self)
            self:halign(0.5):valign(0.5)
            self:xy(actuals.Width / 2, actuals.Width / 2)
            self:zoomtowidth(actuals.Width / 2)
            self:zoomtoheight(actuals.Width / 3)
            self:diffuse(colors.Arrow)
            self:addrotationz(180)
        end
    }
}
t[#t + 1] = Def.ActorFrame { -- Bar
    InitCommand = function(self)
        self:xy(0, actuals.Width)
        self:halign(0):valign(0)
        self:visible(true)
    end,
    BeginCommand = function(self)
        self:SetUpdateFunction(UpdateProgressPosition)
        self:SetUpdateInterval(1.0)
    end,
    Def.Quad {
        Name = "Layer 1",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:zoomtowidth(actuals.Width)
            self:zoomtoheight(actuals.BarHeight)
            self:diffuse(colors.Layer1)
        end
    },
    Def.Quad {
        Name = "Layer 2",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:zoomtowidth(actuals.Width - actuals.Bevel)
            self:zoomtoheight(actuals.BarHeight - actuals.Bevel)
            self:diffuse(colors.Layer2)
        end
    },
    Def.Quad {
        Name = "Layer 3",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy(actuals.Bevel, actuals.Bevel)
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 2))
            self:zoomtoheight(actuals.BarHeight - (actuals.Bevel * 2))
            self:diffuse(colors.Layer3)
        end
    },
    Def.Quad {
        Name = "Layer 4",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy(actuals.Bevel, actuals.Bevel)
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 3))
            self:zoomtoheight(actuals.BarHeight - (actuals.Bevel * 3))
            self:diffuse(colors.Layer4)
        end
    },
    Def.Quad {
        Name = "Layer 5",
        InitCommand = function(self)
            self:halign(0):valign(0)
            self:xy((actuals.Bevel * 2), (actuals.Bevel * 2))
            self:zoomtowidth(actuals.Width - (actuals.Bevel * 4))
            self:zoomtoheight(actuals.BarHeight - (actuals.Bevel * 4))
            self:diffuse(colors.Layer5)
        end
    }
}

return t
