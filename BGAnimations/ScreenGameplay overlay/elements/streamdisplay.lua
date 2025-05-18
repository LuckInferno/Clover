local t = Def.ActorFrame {}

-- local lifebar = screen:GetLifeMeter(PLAYER_1)
-- if lifebar ~= nil then
--     lifebar:zoomtowidth(MovableValues.LifeP1Width)
--     lifebar:zoomtoheight(MovableValues.LifeP1Height)
--     lifebar:xy(MovableValues.LifeP1X, MovableValues.LifeP1Y)
--     lifebar:rotationz(MovableValues.LifeP1Rotation)
-- end

local posx = SCREEN_CENTER_X - 160 * 1.5
-- local posx = SCREEN_CENTER_X - 180 * 1.5

local posy = 240 * 1.5
local width = 360 * 1.5
local height = 20 * 1.5
local rotationAmount = -90

-- t[#t+1] = Def.Sprite {
--     Texture = THEME:GetPathG("", "single1"),
--     InitCommand = function(self)
--         self:halign(0)
--         self:valign(0)
--         self:xy(posx - (height/2),0)
--     end,
-- }


t[#t+1] = Def.Quad {
    InitCommand = function(self)
        self:setsize(width,height):diffuse(color("#7f7f7f"))
        self:xy(posx,posy)
        self:rotationz(rotationAmount)
        self:croptop(0.2)
    end,
    LifeChangedMessageCommand = function(self, params)
        local health = params.LifeMeter:GetLife()
        if health < 0.2 then
            self:smooth(0.4):diffuseleftedge(color("#7f0000"))
        else
            self:smooth(0.4):diffuse(color("#7f7f7f"))
        end
        
    end
}


t[#t+1] = Def.Sprite {
    Texture = THEME:GetPathG("LifeMeterBar", "hot"),
    InitCommand = function(self)
        self:xy(posx,posy)
        self:rotationz(rotationAmount)
        self:zoomto(width,height)
        self:texcoordvelocity(-1,0)
        self:croptop(0.2)
    end,
    LifeChangedMessageCommand = function(self, params)
        local health = params.LifeMeter:GetLife()
        if health == 1 then
            self:stoptweening():smooth(0.2):diffusealpha(1):cropright(1 - health)
        else
            self:stoptweening():smooth(0.2):diffusealpha(1):cropright(1 - health)
        end
        
    end
}

t[#t+1] = Def.Sprite {
    Texture = THEME:GetPathG("LifeMeterBar", "normal"),
    InitCommand = function(self)
        self:xy(posx,posy)
        self:rotationz(rotationAmount)
        self:zoomto(width,height)
        self:texcoordvelocity(-1,0)
        self:croptop(0.2)
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

-- t[#t+1] = Def.Sprite {
--     Texture = THEME:GetPathG("LifeMeterBar", "frame"),
--     InitCommand = function(self)
--         self:xy(posx,posy)
--         self:rotationz(rotationAmount)
--         self:zoomto(480,20)
--     end
-- }

return t