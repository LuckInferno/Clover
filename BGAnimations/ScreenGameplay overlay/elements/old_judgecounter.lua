-- the judge counter. counts judges

-- judgments to display and the order for them
local jdgT = {
    "TapNoteScore_W1",
    "TapNoteScore_W2",
    "TapNoteScore_W3",
    "TapNoteScore_W4",
    "TapNoteScore_W5",
    "TapNoteScore_Miss",
    "HoldNoteScore_Held",
    "HoldNoteScore_LetGo",
}

local judgeFontSize = GAMEPLAY:getItemHeight("judgeDisplayJudgeText")
local countFontSize = GAMEPLAY:getItemHeight("judgeDisplayCountText")
local accFontSize = GAMEPLAY:getItemHeight("judgeDisplayCountText")
local rateFontSize = GAMEPLAY:getItemHeight("judgeDisplayCountText")
local spacing = GAMEPLAY:getItemHeight("judgeDisplayVerticalSpacing") -- Spacing between the judgetypes
local frameWidth = GAMEPLAY:getItemWidth("judgeDisplay") -- Width of the Frame
local frameHeight = ((#jdgT + 1) * spacing) + (48 * judgeFontSize) -- Height of the Frame
local formatacc = "%05.2f%%"
local formatrate = "%1.2fx"

local function recalcSizing()
    spacing = GAMEPLAY:getItemHeight("judgeDisplayVerticalSpacing") * MovableValues.JudgeCounterSpacing
    frameWidth = GAMEPLAY:getItemWidth("judgeDisplay")
    frameHeight = ((#jdgT + 2) * spacing) + (48 * judgeFontSize)
end

local r = GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate() * 60
local a = GAMESTATE:GetPlayerState():GetSongPosition()
local GetBPS = SongPosition.GetCurBPS

local function updatebpm(self)
    local bpm = GetBPS(a) * r
    self:GetChild("BPM"):settext(notShit.round(bpm, 2))
end

local function initbpm(self)
    if #GAMESTATE:GetCurrentSong():GetTimingData():GetBPMs() > 0 then
        self:SetUpdateFunction(updatebpm(self))
        self:SetUpdateRate(0.5)
    else
        self:SetUpdateFunction(nil)
        local bpm = GetBPS(a) * r
        self:GetChild("BPM"):settext(notShit.round(bpm, 2))
    end
end

-- the text actors for each judge count
local judgeCounts = {}

local t = Def.ActorFrame {
    Name = "JudgeCounter",
    InitCommand = function(self)
        self:playcommand("SetUpMovableValues")
        registerActorToCustomizeGameplayUI({
            actor = self,
            coordInc = {5,1},
            zoomInc = {0.1,0.05},
            spacingInc = {0.1,0.05},
        })
    end,
    BeginCommand = function(self)
        for _, j in ipairs(jdgT) do
            judgeCounts[j] = self:GetChild(j .. "count")
        end
    end,
    SetUpMovableValuesMessageCommand = function(self)
        recalcSizing()

        self:xy(MovableValues.JudgeCounterX, MovableValues.JudgeCounterY)
        self:zoomto(MovableValues.JudgeCounterWidth, MovableValues.JudgeCounterHeight)
        self:playcommand("FinishSetUpMovableValues")
    end,
    SpottedOffsetCommand = function(self, params)
        if params == nil then return end
        local cur = params.judgeCurrent
        if cur and judgeCounts[cur] ~= nil then
            judgeCounts[cur]:settext(params.judgeCount)
        end
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
    Def.Quad {
        Name = "BG",
        InitCommand = function(self)
            self:diffuse(COLORS:getGameplayColor("PrimaryBackground"))
            self:diffusealpha(0.4)
        end,
        FinishSetUpMovableValuesMessageCommand = function(self)
            self:zoomto(frameWidth, frameHeight)
        end,
    },
}

local function makeJudgeText(judge, index)
    return LoadFont("Common normal") .. {
        Name = judge .. "text",
        InitCommand = function(self)
            self:halign(0)
            self:settext(getShortJudgeStrings(judge))
            self:diffuse(COLORS:colorByJudgment(judge))
            self:diffusealpha(1)
        end,
        FinishSetUpMovableValuesMessageCommand = function(self)
            self:xy(-frameWidth / 2 + 5, -frameHeight / 2 + ((index+1) * spacing))
            self:zoom(judgeFontSize)
        end,
    }
end

local function makeJudgeCount(judge, index)
    return LoadFont("Common Normal") .. {
        Name = judge .. "count",
        InitCommand = function(self)
            self:halign(1)
            self:settext(0)
            self:diffuse(COLORS:getGameplayColor("PrimaryText"))
            self:diffusealpha(1)
        end,
        PracticeModeResetMessageCommand = function(self)
            self:settext(0)
        end,
        FinishSetUpMovableValuesMessageCommand = function(self)
            self:xy(frameWidth / 2 - 5, -frameHeight / 2 + ((index+1) * spacing))
            self:zoom(countFontSize)
        end,
    }
end

t[#t+1] = LoadFont("Common large") .. {
    Name = "wifepercent",
    InitCommand = function(self)
        self:halign(1):valign(0)
        self:zoom(accFontSize)
        self:diffuse(COLORS:getGameplayColor("PrimaryText"))
        self:diffusealpha(1)
    end,
    SpottedOffsetCommand = function(self, params)
        if params.wifePercent ~= nil then
            self:settextf(formatacc, params.wifePercent)
        else
            self:settextf(formatacc, 0)
        end
    end,
    FinishSetUpMovableValuesMessageCommand = function(self)
        self:xy(frameWidth / 2 - 5, -frameHeight / 2 + (spacing / 3))
        self:zoom(accFontSize)
    end,
}

for i, j in ipairs(jdgT) do
    t[#t+1] = makeJudgeText(j, i)
    t[#t+1] = makeJudgeCount(j, i)
end

t[#t+1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:halign(0)
        self:zoom(judgeFontSize)
        self:diffuse(COLORS:getGameplayColor("PrimaryText"))
        self:settext("RATE")
    end,
    FinishSetUpMovableValuesMessageCommand = function(self)
        self:xy(-frameWidth / 2 + 5, -frameHeight / 2 + (10 * spacing))
        self:zoom(judgeFontSize)
    end
}

t[#t+1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:halign(1)
        self:zoom(rateFontSize)
        self:diffuse(COLORS:getGameplayColor("PrimaryText"))
        self:playcommand("SetRate")
    end,
    SetRateCommand = function(self)
        self:settextf(formatrate, GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate())
    end,
    DoneLoadingNextSongMessageCommand = function(self)
        self:playcommand("SetRate")
    end,
    CurrentRateChangedMessageCommand = function(self)
        self:playcommand("SetRate")
    end,
    FinishSetUpMovableValuesMessageCommand = function(self)
        self:xy(frameWidth / 2 - 5, -frameHeight / 2 + (10 * spacing))
        self:zoom(rateFontSize)
    end,
}

t[#t+1] = LoadFont("Common Normal") .. {
    InitCommand = function(self)
        self:halign(0)
        self:zoom(judgeFontSize)
        self:diffuse(COLORS:getGameplayColor("PrimaryText"))
        self:settext("BPM")
    end,
    FinishSetUpMovableValuesMessageCommand = function(self)
        self:xy(-frameWidth / 2 + 5, -frameHeight / 2 + (11 * spacing))
        self:zoom(judgeFontSize)
    end
}

t[#t+1] = LoadFont("Common Normal") .. {
    Name = "BPM",
    InitCommand = function(self)
        self:halign(1)
        self:zoom(rateFontSize)
        self:diffuse(COLORS:getGameplayColor("PrimaryText"))
        self:diffusealpha(1)
    end,
    FinishSetUpMovableValuesMessageCommand = function(self)
        self:xy(frameWidth/2 - 5, -frameHeight / 2 + (11 * spacing))
        self:zoom(rateFontSize)
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
}

local rotationAmount = -90
local height = frameWidth * 0.16
local width = frameHeight

t[#t+1] = Def.ActorFrame {
    Name = "Streamdisplay",
    InitCommand = function(self)
        self:x(frameWidth/2 + height/2)
    end,
    Def.Quad {
        InitCommand = function(self)
            self:setsize(width,height):diffuse(color("#7f7f7f"))
            self:rotationz(rotationAmount)
        end,
        LifeChangedMessageCommand = function(self, params)
            local health = params.LifeMeter:GetLife()
            if health < 0.2 then
                self:smooth(0.4):diffuseleftedge(color("#7f0000"))
            else
                self:smooth(0.4):diffuse(color("#7f7f7f"))
            end
            
        end
    },
    Def.Sprite {
        Texture = THEME:GetPathG("LifeMeterBar", "hot"),
        InitCommand = function(self)
            self:rotationz(rotationAmount)
            self:zoomto(width,height)
            self:texcoordvelocity(-(540/width),0)
        end,
        LifeChangedMessageCommand = function(self, params)
            local health = params.LifeMeter:GetLife()
            if health == 1 then
                self:stoptweening():smooth(0.2):diffusealpha(1):cropright(1 - health)
            else
                self:stoptweening():smooth(0.2):diffusealpha(1):cropright(1 - health)
            end
            
        end
    },
    Def.Sprite {
        Texture = THEME:GetPathG("LifeMeterBar", "normal"),
        InitCommand = function(self)
            self:rotationz(rotationAmount)
            self:zoomto(width,height)
            self:texcoordvelocity(-(540/width),0)
        end,
        LifeChangedMessageCommand = function(self, params)
            local health = params.LifeMeter:GetLife()
            if health == 1 then
                self:stoptweening():smooth(0.2):diffusealpha(0):cropright(1 - health)
            else
                self:stoptweening():smooth(0.2):diffusealpha(1):cropright(1 - health)
            end
        end
    }
}



return t
