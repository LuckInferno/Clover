local t = Def.ActorFrame {}

local posx = SCREEN_CENTER_X
local posy = SCREEN_CENTER_Y
local width = SCREEN_WIDTH
local height = SCREEN_HEIGHT - 200
local barheight = 100

t[#t+1] = LoadActor(THEME:GetPathG("Title", "BG"))

t[#t+1] = Def.Quad {
    InitCommand = function(self)
        self:setsize(width,height):diffuse(COLORS:getMainColor("PrimaryBackground"))
        self:xy(posx,posy)
        self:halign(0.5)
        self:valign(0.5)
        self:diffusealpha(0.7)
    end,
}
t[#t+1] = Def.Quad {
    InitCommand = function(self)
        self:setsize(width,barheight):diffuse(COLORS:getMainColor("PrimaryBackground"))
        self:xy(posx,0)
        self:halign(0.5)
        self:valign(0)
        self:diffusealpha(0.9)
    end,
}
t[#t+1] = Def.Quad {
    InitCommand = function(self)
        self:setsize(width,barheight):diffuse(COLORS:getMainColor("PrimaryBackground"))
        self:xy(posx,SCREEN_HEIGHT)
        self:halign(0.5)
        self:valign(1)
        self:diffusealpha(0.9)
    end,
}

return t