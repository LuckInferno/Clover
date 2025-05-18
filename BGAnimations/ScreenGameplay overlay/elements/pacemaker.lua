-- Pacemaker
-- Whether this is a massive performance drain or not remains to be seen
local ratios = {
    -- Height = 384 / 1080, -- Height of whole graph
	Height = 512 / 1080, -- Height of whole graph
    -- Height = (1080 * (1 - 0.2)) / 1080, -- Height of whole graph
    Width = 512 / 1920, -- Width of whole graph

    GapRight = 50 / 1920, -- Distance from right of screen to right side of graph
    -- GapBottom = (1080 - 512 - 50) / 1080, -- Distance from bottom of screen to bottom of graph
    GapBottom =((1080 - 512) * (3/4)) / 1080,
    -- GapBottom =(1080 * 0.1) / 1080,

    -- Bar order is: | Current | Best | Target |
    CurrentBarOffset = 210 / 1980, -- Right of bar to right edge of graph
    BestBarOffset = 110 / 1980, -- ..
    TargetBarOffset = 10 / 1980, -- ..
    CurrentBarWidth = 80 / 1980, -- Width of bar
    BestBarWidth = 80 / 1980, -- ..
    TargetBarWidth = 80 / 1980, -- ..

    LineHeight = 2 / 1080, -- Height of the marking lines for the graph
    BarHighlightWidth = 2 / 1920, -- Width of the bar outline

    KeyLeftGap = 15 / 1920, -- Gap to the left of the key boxes
    KeyCurrentOffset = 150 / 1080, -- Bottom of graph to bottom of Current box
    KeyBestOffset = 110 / 1080, -- Bottom of graph to bottom of Best box
    KeyTargetOffset = 70 / 1080, -- Bottom of graph to bottom of Target box
    KeyWidth = 140 / 1920, -- Width of box
    KeyHeight = 25 / 1080, -- Height of box
    KeyShadowWidth = 2 / 1920, -- Width of outline
    KeyShadowHeight = 2 / 1080, -- Height of outline

    ScoreLeftGap = 15 / 1920, -- Left of score info to left side of graph
    ScoreWidth = 180 / 1920, -- Allowed width for the score info
    CurrentScoreBottomGap = 25 / 1080, -- Bottom of current info to bottom of graph
    TargetScoreBottomGap = 10 / 1080 -- Bottom of target info to bottom of graph

}
local actuals = {
    Height = ratios.Height * SCREEN_HEIGHT,
    Width = ratios.Width * SCREEN_WIDTH,
    GapRight = ratios.GapRight * SCREEN_WIDTH,
    GapBottom = ratios.GapBottom * SCREEN_HEIGHT,
    CurrentBarOffset = ratios.CurrentBarOffset * SCREEN_WIDTH,
    BestBarOffset = ratios.BestBarOffset * SCREEN_WIDTH,
    TargetBarOffset = ratios.TargetBarOffset * SCREEN_WIDTH,
    CurrentBarWidth = ratios.CurrentBarWidth * SCREEN_WIDTH,
    BestBarWidth = ratios.BestBarWidth * SCREEN_WIDTH,
    TargetBarWidth = ratios.TargetBarWidth * SCREEN_WIDTH,
    LineHeight = ratios.LineHeight * SCREEN_HEIGHT,
    BarHighlightWidth = ratios.BarHighlightWidth * SCREEN_WIDTH,
    KeyLeftGap = ratios.KeyLeftGap * SCREEN_WIDTH,
    KeyCurrentOffset = ratios.KeyCurrentOffset * SCREEN_HEIGHT,
    KeyBestOffset = ratios.KeyBestOffset * SCREEN_HEIGHT,
    KeyTargetOffset = ratios.KeyTargetOffset * SCREEN_HEIGHT,
    KeyWidth = ratios.KeyWidth * SCREEN_WIDTH,
    KeyHeight = ratios.KeyHeight * SCREEN_HEIGHT,
    KeyShadowWidth = ratios.KeyShadowWidth * SCREEN_WIDTH,
    KeyShadowHeight = ratios.KeyShadowHeight * SCREEN_HEIGHT,
    ScoreLeftGap = ratios.ScoreLeftGap * SCREEN_WIDTH,
    ScoreWidth = ratios.ScoreWidth * SCREEN_WIDTH,
    CurrentScoreBottomGap = ratios.CurrentScoreBottomGap * SCREEN_HEIGHT,
    TargetScoreBottomGap = ratios.TargetScoreBottomGap * SCREEN_HEIGHT
}
local colors = {
    BaseLine = color("#FFFFFF"),
    MidLine = color("#6666ff"),
    TopLine = color("#fffe65"),
    Best = color("#00FF00"),
    Target = color("#FF0000"),
    Current = color("#0000FF"),
    Bg = color("#000000"),
    Shadow = color("#000000"),
    Highlight = color("#FFFFFF"),
    Text = color("#FFFFFF")
}
local gradetier = {
    Tier00 = 99.9355 / 100, -- AAAAA
    Tier01 = 99.955 / 100, -- AAAA
    Tier02 = 99.70 / 100, -- AAA
    Tier03 = 93 / 100, -- AA
    Tier04 = 80 / 100, -- A
    Tier05 = 70 / 100, -- B
    Tier06 = 60 / 100, -- C
    Tier07 = 0 / 100 -- D
}

local p1name = GAMESTATE:GetPlayerDisplayName(PLAYER_1)
local target = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).TargetGoal /
                   100

local keytextzoom = 0.6
local scoretextzoom = 0.6
local clearlinetextzoom = 0.4

local spaceforname = actuals.ScoreWidth / scoretextzoom * 0.6
local spaceforscore = actuals.ScoreWidth / scoretextzoom * 0.4
local keyboxtextmaxwidth = actuals.KeyWidth / keytextzoom * 0.8

-- Functions

OR, XOR, AND = 1, 3, 4
function bitwise(a, b, oper)
    local r, m, s = 0, 2 ^ 31
    repeat
        s, a, b = a + b + m, a % m, b % m
        r, m = r + m * oper % (s - a - b), m / 2
    until m < 1
    return r
end

function WifeToPercentPacemaker(params)
    return (-(params.WifeDifferential - params.CurWifeScore)) *
               (params.TotalPercent / (100 * params.CurWifeScore)) * 100
end

function WifeToPercentUser(params)
    return string.format("%5.2f", params.TotalPercent)
end

function getLight(self)
    return self:GetHeight() * self:GetTrueZoomY() / actuals.Height
end

function GetBestScore()
    -- local score = getBestScore(PLAYER_1, nil, getCurRate(), nil)
    local score = GetDisplayScore()
    -- local score = SCOREMAN:GetChartPBAt()
    return score
end

local t = Def.ActorFrame { -- Main Frame
    Name = "Pacemaker",
    InitCommand = function(self)
        self:x(SCREEN_WIDTH - actuals.GapRight)
        self:y(SCREEN_HEIGHT - actuals.GapBottom)
    end
}

t[#t + 1] = Def.ActorFrame {
    Name = "ScoreGraph", -- The graph itself
    InitCommand = function(self) self:visible(true) end,
    Def.Quad { -- Graph BG
        Name = "graphbg",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:zoomto(actuals.Width, actuals.Height)
            self:diffuse(colors.Bg)
            self:diffusealpha(0)
            self:visible(true)
        end
    },
    LoadFont("Common Normal") .. { -- AAA Text
        Name = "AAALineText",
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width)
            self:y(-actuals.Height * gradetier.Tier02)
            self:zoom(clearlinetextzoom * 1.5)
            self:diffuse(colors.TopLine)
            self:diffusealpha(0.5)
            self:shadowlength(1)
            self:settext('AAA')
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier02 then
                self:diffusealpha(1)
            else
                self:diffusealpha(0.5)
            end
        end
    },
    LoadFont("Common Normal") .. { -- AA Text
        Name = "AALineText",
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width)
            self:y(-actuals.Height * gradetier.Tier03)
            self:zoom(clearlinetextzoom)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5)
            self:shadowlength(1)
            self:settext('AA')
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier03 then
                self:diffusealpha(1)
            else
                self:diffusealpha(0.5)
            end
        end
    },
    LoadFont("Common Normal") .. { -- A Text
        Name = "ALineText",
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width)
            self:y(-actuals.Height * gradetier.Tier04)
            self:zoom(clearlinetextzoom)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5)
            self:shadowlength(1)
            self:settext('A')
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier04 then
                self:diffusealpha(1)
            else
                self:diffusealpha(0.5)
            end
        end
    },
    LoadFont("Common Normal") .. { -- B Text
        Name = "BLineText",
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width)
            self:y(-actuals.Height * gradetier.Tier05)
            self:zoom(clearlinetextzoom)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5)
            self:shadowlength(1)
            self:settext('B')
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier05 then
                self:diffusealpha(1)
            else
                self:diffusealpha(0.5)
            end
        end
    },
    LoadFont("Common Normal") .. { -- C Text
        Name = "CLineText",
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width)
            self:y(-actuals.Height * gradetier.Tier06)
            self:zoom(clearlinetextzoom)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5)
            self:shadowlength(1)
            self:settext('C')
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier06 then
                self:diffusealpha(1)
            else
                self:diffusealpha(0.5)
            end
        end
    },
    Def.Quad { -- AAA Grade Line
        Name = "AAALine",
        InitCommand = function(self)
            self:valign(0):halign(1)
            self:y(-actuals.Height * gradetier.Tier02)
            self:zoomto(actuals.Width, actuals.LineHeight)
            self:diffuse(colors.TopLine)
            self:diffusealpha(0.5);
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier02 then
                self:diffusealpha(1);
            else
                self:diffusealpha(0.5);
            end
        end
    },
    Def.Quad { -- AA Grade Line
        Name = "AALine",
        InitCommand = function(self)
            self:valign(0):halign(1)
            self:y(-actuals.Height * gradetier.Tier03)
            self:zoomto(actuals.Width, actuals.LineHeight)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5);
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier03 then
                self:diffusealpha(1);
            else
                self:diffusealpha(0.5);
            end
        end
    },
    Def.Quad { -- A Grade Line
        Name = "ALine",
        InitCommand = function(self)
            self:valign(0):halign(1)
            self:y(-actuals.Height * gradetier.Tier04)
            self:zoomto(actuals.Width, actuals.LineHeight)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5);
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier04 then
                self:diffusealpha(1);
            else
                self:diffusealpha(0.5);
            end
        end
    },
    Def.Quad { -- B Grade Line
        Name = "BLine",
        InitCommand = function(self)
            self:valign(0):halign(1)
            self:y(-actuals.Height * gradetier.Tier05)
            self:zoomto(actuals.Width, actuals.LineHeight)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5);
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier05 then
                self:diffusealpha(1);
            else
                self:diffusealpha(0.5);
            end
        end
    },
    Def.Quad { -- C Grade Line
        Name = "CLine",
        InitCommand = function(self)
            self:valign(0):halign(1)
            self:y(-actuals.Height * gradetier.Tier06)
            self:zoomto(actuals.Width, actuals.LineHeight)
            self:diffuse(colors.MidLine)
            self:diffusealpha(0.5);
            self:visible(true)
        end,
        JudgmentMessageCommand = function(self, params)
            if params.TotalPercent / 100 >= gradetier.Tier06 then
                self:diffusealpha(1);
            else
                self:diffusealpha(0.5);
            end
        end
    },
    Def.Quad { -- Base Line
        Name = "BaseLine",
        InitCommand = function(self)
            self:valign(0):halign(1)
            self:zoomto(actuals.Width, actuals.LineHeight)
            self:diffuse(colors.BaseLine)
            self:visible(true)
        end
    },
    Def.Quad { -- Current Score Bar Highlight
        Name = "Current Score Bar",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.CurrentBarOffset + actuals.BarHighlightWidth)
            self:zoomx(actuals.CurrentBarWidth + actuals.BarHighlightWidth * 2)
            self:diffuse(colors.Highlight)
            self:visible(false)
        end,
        JudgmentMessageCommand = function(self, params)
            local score = (params.TotalPercent / 100 * (actuals.Height))
            if score >= 1 then
                self:zoomtoheight(score);
                self:visible(true);
            end
        end
    },
    Def.Quad { -- Current Score Bar
        Name = "Current Score Bar",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.CurrentBarOffset)
            self:zoomx(actuals.CurrentBarWidth)
            self:diffuse(colors.Current)
            self:visible(false)
        end,
        JudgmentMessageCommand = function(self, params)
            local score = (params.TotalPercent / 100 * actuals.Height)
            if score >= 1 then
                self:zoomtoheight(score);
                local light = getLight(self)
                self:diffusetopedge(light, light, 1, 1)
                self:visible(true);
            end
        end
    },
    Def.Quad { -- Best Score Bar Highlight
        Name = "Best Score Bar",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.BestBarOffset + actuals.BarHighlightWidth)
            self:zoomx(actuals.BestBarWidth + actuals.BarHighlightWidth * 2)
            self:diffuse(colors.Highlight)
            self:visible(false)
        end,
        BeginCommand = function(self, params)
            local score = GetBestScore()

            if score then
                local truescore = score:GetWifeScore()
                self:zoomtoheight(truescore * actuals.Height);
                self:visible(true)
            end
        end,
        JudgmentMessageCommand = function(self, params)
            local score = GetBestScore()

            if not score then
                local score = (params.TotalPercent / 100 * actuals.Height)
                if score >= 1 then
                    self:zoomtoheight(score);
                    self:visible(true);
                end
            end
        end
    },
    Def.Quad { -- Best Score Bar
        Name = "Best Score Bar",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.BestBarOffset)
            self:zoomx(actuals.BestBarWidth)
            self:diffuse(colors.Best)
            self:visible(false)
        end,
        BeginCommand = function(self)
            local score = GetBestScore()
            if score then
                truescore = score:GetWifeScore()
                self:zoomtoheight(truescore * actuals.Height);
                local light = getLight(self)
                self:diffusetopedge(light, 1, light, 1)
                self:visible(true)
            end
        end,
        JudgmentMessageCommand = function(self, params)
            local score = GetBestScore()
            if not score then
                local score = (params.TotalPercent / 100 * actuals.Height)
                if score >= 1 then
                    self:zoomtoheight(score);
                    local light = getLight(self)
                    self:diffusetopedge(light, 1, light, 1)
                    self:visible(true);
                end
            end
        end
    },
    Def.Quad { -- Target Bar Ghost
        Name = "Target Bar Ghost",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.TargetBarOffset)
            self:zoomx(actuals.TargetBarWidth)
            self:diffuse(colors.Shadow)
            self:diffusealpha(0.5)
            self:MaskSource()
            self:visible(true)
        end,
        BeginCommand = function(self)
            self:zoomtoheight(target * actuals.Height)
            self:visible(true)
        end
    },
    Def.Quad { -- Target Bar Ghost Highlight
        Name = "Target Bar Ghost",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.TargetBarOffset + actuals.BarHighlightWidth)
            self:zoomx(actuals.TargetBarWidth + actuals.BarHighlightWidth * 2)
            self:diffuse(colors.Highlight)
            self:valign(1)
            self:MaskDest()
            self:visible(true)
        end,
        BeginCommand = function(self)
            self:zoomtoheight(target * actuals.Height)
            self:visible(true)
        end
    },
    Def.Quad { -- Target Bar Ghost
        Name = "Target Bar Ghost",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.TargetBarOffset)
            self:zoomx(actuals.TargetBarWidth)
            self:diffuse(colors.Shadow)
            self:diffusealpha(0.5)
            self:visible(true)
        end,
        BeginCommand = function(self)
            self:zoomtoheight(target * actuals.Height)
            self:visible(true)
        end
    },
    Def.Quad { -- Target Bar
        Name = "Target Bar",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:x(-actuals.TargetBarOffset)
            self:zoomx(actuals.TargetBarWidth)
            self:diffuse(colors.Target)
            self:visible(false)
        end,
        JudgmentMessageCommand = function(self, params)
            local score = (-(params.WifeDifferential - params.CurWifeScore)) *
                              (params.TotalPercent / (100 * params.CurWifeScore))
            self:zoomtoheight(score * actuals.Height);
            local light = getLight(self)
            self:diffusetopedge({1, light, light, 1})
            self:visible(true);
        end
    }
}

t[#t + 1] = Def.ActorFrame { -- All the data being displayed
    Name = "Display Data",
    InitCommand = function(self) self:visible(true) end,
    LoadFont("Common Normal") .. { -- Current Score
        Name = "Current Score",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:xy(-actuals.Width + actuals.ScoreLeftGap + actuals.ScoreWidth,
                    -actuals.CurrentScoreBottomGap)
            self:zoom(scoretextzoom)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
            self:maxwidth(spaceforscore)
        end,
        BeginCommand = function(self) self:settext(0); end,
        JudgmentMessageCommand = function(self, params)
            self:settext(string.format("%5.2f", params.TotalPercent))
            self:visible(true)
        end
    },
    LoadFont("Common Normal") .. { -- Username
        Name = "Pacemaker username",
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:xy(-actuals.Width + actuals.ScoreLeftGap,
                    -actuals.CurrentScoreBottomGap)
            self:zoom(scoretextzoom)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
            self:maxwidth(spaceforname)
        end,
        BeginCommand = function(self) self:queuecommand("Set") end,
        SetCommand = function(self) self:settext(p1name); end
    },
    LoadFont("Common Normal") .. { -- Target Score
        Name = "Pacemaker Target Score",
        InitCommand = function(self)
            self:valign(1):halign(1)
            self:xy(-actuals.Width + actuals.ScoreLeftGap + actuals.ScoreWidth,
                    -actuals.TargetScoreBottomGap)
            self:zoom(scoretextzoom)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
            self:maxwidth(spaceforscore)
        end,
        BeginCommand = function(self) self:settext(0); end,
        JudgmentMessageCommand = function(self, params)
            local score = (-(params.WifeDifferential - params.CurWifeScore)) *
                              (params.TotalPercent / (100 * params.CurWifeScore))
            self:settext(string.format("%5.2f", score * 100))
            self:visible(true)
        end
    },
    LoadFont("Common Normal") .. { -- Pacemaker
        Name = "Pacemaker Target Score",
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:xy(-actuals.Width + actuals.ScoreLeftGap,
                    -actuals.TargetScoreBottomGap)
            self:zoom(scoretextzoom)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
            self:maxwidth(spaceforname)
        end,
        BeginCommand = function(self) self:queuecommand("Set") end,
        SetCommand = function(self) self:settext('Pacemaker'); end
    }
}

t[#t + 1] = Def.ActorFrame {
    Name = "Key",
    InitCommand = function(self) self:visible(true) end,
    Def.Quad { -- Current Key Box Highlight
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width + actuals.KeyLeftGap - actuals.KeyShadowWidth)
            self:y(-actuals.KeyCurrentOffset + actuals.KeyShadowHeight)
            self:setsize(actuals.KeyWidth + (2 * actuals.KeyShadowWidth),
                         actuals.KeyHeight + (2 * actuals.KeyShadowHeight))
            self:diffuse(colors.Shadow)
            self:visible(true)
        end
    },
    Def.Quad { -- Best Key Box Highlight
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width + actuals.KeyLeftGap - actuals.KeyShadowWidth)
            self:y(-actuals.KeyBestOffset + actuals.KeyShadowHeight)
            self:setsize(actuals.KeyWidth + (2 * actuals.KeyShadowWidth),
                         actuals.KeyHeight + (2 * actuals.KeyShadowHeight))
            self:diffuse(colors.Shadow)
            self:visible(true)
        end
    },
    Def.Quad { -- Target Key Box Highlight
        InitCommand = function(self)
            self:valign(1):halign(0)
            self:x(-actuals.Width + actuals.KeyLeftGap - actuals.KeyShadowWidth)
            self:y(-actuals.KeyTargetOffset + actuals.KeyShadowHeight)
            self:setsize(actuals.KeyWidth + (2 * actuals.KeyShadowWidth),
                         actuals.KeyHeight + (2 * actuals.KeyShadowHeight))
            self:diffuse(colors.Shadow)
            self:visible(true)
        end
    },
    Def.Quad { -- Current Key Box
        InitCommand = function(self)
            local c = colors.Current
            local ctop = color(("#%06X"):format(bitwise(
                                                    tonumber(ColorToHex(c), 16),
                                                    tonumber("505050", 16), OR)))
            local cbot = color(("#%06X"):format(bitwise(
                                                    tonumber(ColorToHex(c), 16),
                                                    tonumber("AAAAAA", 16), AND)))

            self:valign(1):halign(0)
            self:x(-actuals.Width + actuals.KeyLeftGap)
            self:y(-actuals.KeyCurrentOffset)
            self:setsize(actuals.KeyWidth, actuals.KeyHeight)
            self:diffuse(c)
            self:diffusetopedge(ctop)
            self:diffusebottomedge(cbot)
            self:visible(true)
        end
    },
    Def.Quad { -- Best Key Box
        InitCommand = function(self)
            local c = colors.Best
            local ctop = color(("#%06X"):format(bitwise(
                                                    tonumber(ColorToHex(c), 16),
                                                    tonumber("505050", 16), OR)))
            local cbot = color(("#%06X"):format(bitwise(
                                                    tonumber(ColorToHex(c), 16),
                                                    tonumber("AAAAAA", 16), AND)))

            self:valign(1):halign(0)
            self:x(-actuals.Width + actuals.KeyLeftGap)
            self:y(-actuals.KeyBestOffset)
            self:setsize(actuals.KeyWidth, actuals.KeyHeight)
            self:diffuse(c)
            self:diffusetopedge(ctop)
            self:diffusebottomedge(cbot)
            self:visible(true)
        end
    },
    Def.Quad { -- Target Key Box
        InitCommand = function(self)
            local c = colors.Target
            local ctop = color(("#%06X"):format(bitwise(
                                                    tonumber(ColorToHex(c), 16),
                                                    tonumber("505050", 16), OR)))
            local cbot = color(("#%06X"):format(bitwise(
                                                    tonumber(ColorToHex(c), 16),
                                                    tonumber("AAAAAA", 16), AND)))

            self:valign(1):halign(0)
            self:x(-actuals.Width + actuals.KeyLeftGap)
            self:y(-actuals.KeyTargetOffset)
            self:setsize(actuals.KeyWidth, actuals.KeyHeight)
            self:diffuse(c)
            self:diffusetopedge(ctop)
            self:diffusebottomedge(cbot)
            self:visible(true)
        end
    },
    LoadFont("Common Normal") .. { -- Current Key Text
        Name = "Current Score",
        InitCommand = function(self)
            self:x(-actuals.Width + actuals.KeyLeftGap + (actuals.KeyWidth / 2))
            self:y(-actuals.KeyCurrentOffset - actuals.KeyHeight / 2)
            self:zoom(keytextzoom)
            self:diffuse(colors.Text)
            self:maxwidth(keyboxtextmaxwidth)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
        end,
        BeginCommand = function(self) self:settext('Current Score') end
    },
    LoadFont("Common Normal") .. { -- Best Key Text
        Name = "Best Score",
        InitCommand = function(self)
            self:x(-actuals.Width + actuals.KeyLeftGap + (actuals.KeyWidth / 2))
            self:y(-actuals.KeyBestOffset - actuals.KeyHeight / 2)
            self:zoom(keytextzoom)
            self:diffuse(colors.Text)
            self:maxwidth(keyboxtextmaxwidth)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
        end,
        BeginCommand = function(self)
            self:settext('Loading...')

            local score = GetBestScore()
            if score then
                self:settext('Best Score')
            else
                self:settext('First Score')
            end
        end
    },
    LoadFont("Common Normal") .. { -- Target Key Text
        InitCommand = function(self)
            self:x(-actuals.Width + actuals.KeyLeftGap + (actuals.KeyWidth / 2))
            self:y(-actuals.KeyTargetOffset - actuals.KeyHeight / 2)
            self:zoom(keytextzoom)
            self:diffuse(colors.Text)
            self:maxwidth(keyboxtextmaxwidth)
            self:shadowlength(1)
            self:shadowcolor(colors.Shadow)
        end,
        BeginCommand = function(self)
            if target == 1 then
                self:settext('Rank AAA')
            elseif target == gradetier["Tier03"] then
                self:settext('Rank AA')
            elseif target == gradetier["Tier04"] then
                self:settext('Rank A')
            elseif target == gradetier["Tier05"] then
                self:settext('Rank B')
            elseif target == gradetier["Tier06"] then
                self:settext('Rank C')
            else
                self:settext('Wife ' .. tostring(target * 100) .. '%')
            end
        end
    }
}

return t
