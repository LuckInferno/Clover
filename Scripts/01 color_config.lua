local settings_prefix = "/" .. THEME:GetRealThemeDisplayName() .. "_settings/"
local ETTERNA_PURPLE = "#614080" -- originally "Main Highlight" color
local defaultConfig = {
    main = {
        PrimaryBackground = "#000000",
        SecondaryBackground = "#325c40", -- darker version of PrimaryBackground
        PrimaryText = "#f5f7fa",
        SecondaryText = "#f5f7fa", -- probably shouldnt be far from PrimaryText
        IconColor = "#f5f7fa",
        Visualizer = "#f5f7fa",
        SeparationDivider = "#f5f7fa", -- also some accents like slider markers and text cursors
        SelectMusicBackground = "#000000", -- only used if single bg is on
    },
    multiplayer = {
        UserStatusInEval = "#9585f1",
        UserStatusNotReady = "#ff7676",
        UserStatusReady = "#7fbd39",
        UserStatusInGameplay = "#626871",
        UserStatusInOptions = "#584a7f",
        UserInLobby = "#584a7f",
    },
    leaderboard = {
        Background = "#111111CC",
        Border = "#000111",
        Text = "#ffcdff",
    },
    musicWheel = {
        HeaderBackground = "#000000",
        FolderBackground = "#434549",
        SongBackground = "#000000",
        ItemDivider = "#f5f7fa",
        GraphLine = "#f5f7fa",
        Favorite = "#f8c6da",
        Permamirror = "#5bacad6",
        HighlightColor = "#f5f7fa",
    },
    generalBox = {
        SliderBackground = "#000000",
        RequiredTag = "#8e8ce2",
        AssignedTag = "#ff7676",
        FilteredTag = "#91daa1",
        GoalBackground = "#f5f7fa",
        GoalAchieved = "#9585f1",
        GoalDefault = "#ff7676",
        InvalidScore = "#ff7676",
        ChordCohesionOnScore = "#ff7676",
        Wife2Score = "#ff7676", -- unused
        MultiButtonActive = "#7fbd39",
        MultiButtonNotActive = "#ff3333",
    },
    chartPreview = {
        Background = "#000000",
        GraphBackground = "#f5f7fa",
        GraphNPSLine = "#584a7f",
        GraphNPSText = "#584a7f",
        GraphSeekBar = "#584a7f",
        GraphProgress = "#7fbd39",
        GraphLowestDensityBar = "#f5f7fa",
        GraphHighestDensityBar = "#000000",
    },
    downloader = {
        ProgressBarFill = "#f5f7fa",
        ProgressBarBackground = "#f5f7fa",
        InstalledIcon = "#55b67d",
        NotInstalledIcon = "#f5f7fa",
        Bundle1Easiest = "#6dccff",
        Bundle2Easy = "#225918",
        Bundle3Medium = "#ffb108",
        Bundle4Hard = "#ff7676",
        Bundle5Hardest = "#a996ec",
        NSFWPack = "#ffbbc7",
    },
    options = {
        Cursor = "#f5f7fa",
        Arrows = "#f5f7fa",
        KeybindButtonEdge = "#f5f7fa", -- the bg bg, white edges
        KeybindButtonBackground = "#222323", -- the bg
    },
    evaluation = {
        LifeGraphTint = "#f5f7fa",
        LifeGraphBackground = "#626871",
        ComboGraphTint = "#f5f7fa",
        ComboGraphBackground = "#222323",
        MaxComboText = "#828b98",
        NormalComboText = "#f5f7fa",
        InvalidScore = "#ff7676",
        ChordCohesionOnScore = "#ff7676",
        Wife2Score = "#ff7676", -- unused
    },
    assetSettings = {
        HoveredItem = "#f5f7fa",
        SavedItem = "#828b98",
    },
    offsetPlot = {
        Background = "#000000",
        Text = "#ffffff",
        HoverLine = "#aa2222",
        MineHit = "#ff0000",
        HoldDrop = "#ff0000",
        RollDrop = "#ff00ff",
    },
    title = {
        PrimaryText = "#f5f7fa",
        SecondaryText = "#f5f7fa",
        UpdateText = "#a6cc34",
        ProfileBackground = "#000000",
        Separator = "#f5f7fa",
        UnderlayBackground = "#003221",
        LogoE = "#f5f7fa",
        LogoTriangle = "#518822",
        ItemTriangle = "#518822",
        GradientColor1 = "#225918",
        GradientColor2 = "#a6cc34",
    },
    gameplay = {
        ErrorBarCenter = "#ff0000",
        ErrorBarEWMABar = "#55b67d",
        FullProgressBar = "#db99bf",
        FullProgressBarBG = "#626871",
        MiniProgressBar = "#db99bf",
        MiniProgressBarBG = "#626871",
        MiniProgressBarEnd = "#434549",
        TargetGoalAhead = "#9585f1",
        TargetGoalBehind = "#d94a69",
        LaneCover = "#434549",
        LaneCoverBPM = "#55b67d",
        LaneCoverHeight = "#f5f7fa",
        NPSGraph = "#f5f7fa",
        NoteFieldBG = "#000000",
        PracticeBookmark = "#4097ea",
        PracticeRegion = "#ff7daf",
        PrimaryText = "#f5f7fa",
        --SecondaryText = "#ffffff",
        PrimaryBackground = "#000000",
        --SecondaryBackground = "#000000",
        SplashBackground = "#000000",
        SplashText = "#f5f7fa",
    },
    replay = {
        ButtonBG = "#7877c1",
        ButtonBorder = "#434549",
    },
    combo = {
        MarvFullCombo = "#6dccff",
        PerfFullCombo = "#ffb108",
        FullCombo = "#7fbd39",
        RegularCombo = "#cdd2da",
        ComboLabel = "#ffa6c5",
    },
    clearType = {
        MFC = "#6dccff",
        WF = "#cdd2da",
        SDP = "#ba882e",
        PFC = "#e8d24b",
        BF = "#828b98",
        SDG = "#2f690c",
        FC = "#7da42d",
        MF = "#e45c5f",
        SDCB = "#318eb8",
        Clear = "#41b2e3",
        Failed = "#e61e25",
        Invalid = "#e61e25",
        NoPlay = "#626871",
        None = "#626871",
    },
    difficulty = {
        Difficulty_Beginner = "#6dccff", -- light blue
        Difficulty_Easy = "#789e24", -- green
        Difficulty_Medium = "#ffb108", -- yellow
        Difficulty_Hard = "#ff7676", -- red
        Difficulty_Challenge = "#a996ec", -- light blue
        Difficulty_Edit = "#626871", -- gray
        Beginner = "#6dccff",
        Easy = "#789e24", -- green
        Medium = "#ffb108", -- yellow
        Hard = "#ff7676", -- red
        Challenge = "#a996ec", -- Purple
        Edit = "#626871", -- gray
        Difficulty_Crazy = "#ff7676",
        Difficulty_Freestyle = "#626871",
        Difficulty_Nightmare = "#626871",
        Crazy = "#ff7676",
        Freestyle = "#626871",
        Nightmare = "#626871",
    },
    grades = {
        Grade_Tier01 = "#f5f7fa", -- AAAAA
        Grade_Tier02 = "#6dccff", -- AAAA:
        Grade_Tier03 = "#55b1f1", -- AAAA.
        Grade_Tier04 = "#4097ea", -- AAAA
        Grade_Tier05 = "#fff02b", -- AAA:
        Grade_Tier06 = "#ffcf05", -- AAA.
        Grade_Tier07 = "#ffb108", -- AAA
        Grade_Tier08 = "#7fbd39", -- AA:
        Grade_Tier09 = "#789e24", -- AA.
        Grade_Tier10 = "#6b842d", -- AA
        Grade_Tier11 = "#ff7676", -- A:
        Grade_Tier12 = "#e45c5f", -- A.
        Grade_Tier13 = "#b63c35", -- A
        Grade_Tier14 = "#5165ae", -- B
        Grade_Tier15 = "#64659d", -- C
        Grade_Tier16 = "#7e6144", -- D
        Grade_Failed = "#cdd2da", -- F
        Grade_None = "#626871" -- no play
    },
    judgment = {
        TapNoteScore_W1 = "#6dccff",
        TapNoteScore_W2 = "#ffcf05",
        TapNoteScore_W3 = "#518822",
        TapNoteScore_W4 = "#4097ea",
        TapNoteScore_W5 = "#f85d80",
        TapNoteScore_Miss = "#b63c35",
        HoldNoteScore_Held = "#ffb108",
        HoldNoteScore_LetGo = "#b63c35",
        TextOverBars = "#f5f7fa", -- just for the text that goes over the bars
    },
}

local presetfolder = "Save" .. settings_prefix .. "color_presets/"
local defaultpresetname = "default"
local defaultpresetpath = presetfolder .. defaultpresetname .. ".lua"

local defaultGlobalConfig = {
    currentPreset = defaultpresetname,
}

function getDefaultColor(category, element)
    if defaultConfig[category] ~= nil then
        if defaultConfig[category][element] ~= nil then
            return color(defaultConfig[category][element])
        else
            print("Element "..element.." does not exist in the default color config.")
            return color("1,1,1,1")
        end
    else
        print("Category "..category.." does not exist in the default color config.")
        return color("1,1,1,1")
    end
end

-- the global color config table
-- serious big boy coding style would dictate that i put meta tables and stuff in this
--     and a bunch of stuff would be private and whatever but nah im not doing that
-- all the loaded presets will be present here at once
-- hope you dont load 5gb of presets (this would be a feat tbh. someone try this)
COLORS = {}

-- contains info about color config preset and any other color config global settings
colorConfig = create_setting("colorConfig", "colorConfig.lua", defaultGlobalConfig, -1)

local function load_conf_file(fname)
    local file = RageFileUtil.CreateRageFile()
    local ret = {}
    if file:Open(fname, 1) then
        local data = loadstring(file:Read())
        setfenv(data, {})
        local success, data_ret = pcall(data)
        if success then
            ret = data_ret
        end
        file:Close()
    end
    file:destroy()
    return ret
end

local function writePreset(name)
    local presetData = COLORS.presets[name]
    local fname = presetfolder .. name .. ".lua"
    local f = RageFileUtil.CreateRageFile()
    if not f:Open(fname, 2) then
        print("Could not open '" .. fname .. "' to write.")
        return false
    else
        local o = "return " .. lua_table_to_string(presetData)
        f:Write(o)
        f:Close()
        f:destroy()
        return true
    end
end

local function writeNamedDefaultPreset(name)
    local fname = presetfolder .. name .. ".lua"
    local f = RageFileUtil.CreateRageFile()
    if not f:Open(fname, 2) then
        print("Could not open '" .. fname .. "' to write.")
        return false
    else
        local o = "return " .. lua_table_to_string(defaultConfig)
        f:Write(o)
        f:Close()
        f:destroy()
        return true
    end
end

local function writeDefaultPreset()
    local file_handle = RageFileUtil.CreateRageFile()
    local fname = defaultpresetpath
    if not file_handle:Open(fname, 2) then
        print("Could not open '" .. fname .. "' to write.")
        return false
    else
        local output = "return " .. lua_table_to_string(defaultConfig)
        file_handle:Write(output)
        file_handle:Close()
        file_handle:destroy()
        return true
    end
end

-- works like the process of loading any config but loads it from a directory of configs instead
function COLORS.loadColorConfigPresets(self)
    print("Loading color config presets.")
    FILEMAN:FlushDirCache(presetfolder) -- the dir cache resets every 30 seconds. we need to be faster

    -- put the default in
    if not FILEMAN:DoesFileExist(defaultpresetpath) then
        writeDefaultPreset()
        FILEMAN:FlushDirCache(presetfolder)
    end

    -- check the preset folder for more presets
    local tmp = FILEMAN:GetDirListing(presetfolder)
    local confignames = {}
    for _, name in ipairs(tmp) do
        if ActorUtil.GetFileType(presetfolder .. name) == "FileType_Lua" then
            confignames[#confignames+1] = name:gsub(".lua", "")
        end
    end

    self.presets = {}
    if #confignames == 0 then
        print("No color config presets present even after writing the default one!!!")
        return
    end

    local count = 0
    -- load all the presets
    for _, name in ipairs(confignames) do
        count = count + 1
        local pname = presetfolder .. name .. ".lua"
        local from_file = load_conf_file(pname)
        if type(from_file) == "table" then
            force_table_elements_to_match_type(from_file, defaultConfig, -1)
            self.presets[name] = from_file
        else
            self.presets[name] = DeepCopy(defaultConfig)
        end
    end
    print("Loaded "..count.." color config presets.")
end

-- return category names overall
function getColorConfigCategories()
    local o = {}
    for c, _ in pairs(defaultConfig) do
        o[#o+1] = c
    end
    table.sort(o, function(a,b) return a:lower()<b:lower() end)
    return o
end

-- return element names for a category
function getColorConfigElementsForCategory(cat)
    local o = {}
    for e, _ in pairs(defaultConfig[cat]) do
        o[#o+1] = e
    end
    table.sort(o, function(a,b) return a:lower()<b:lower() end)
    return o
end

-- return preset names
function getColorConfigPresets()
    -- we will load all presets for this action just in case
    COLORS:loadColorConfigPresets()
    local o = {}
    for p, _ in pairs(COLORS.presets) do
        o[#o+1] = p
    end
    table.sort(o, function(a,b) return a:lower()<b:lower() end)
    return o
end

-- return the current set color preset
function getColorPreset()
    if colorConfig ~= nil then
        return colorConfig:get_data().currentPreset
    else
        return nil
    end
end

function COLORS.loadColorPreset(self, preset)
    if self.presets[preset] == nil then
        self:loadColorConfigPresets()
    end
    if self.presets[preset] == nil then
        local pname = presetfolder .. preset .. ".lua"
        local from_file = load_conf_file(pname)
        if type(from_file) == "table" then
            force_table_elements_to_match_type(from_file, defaultConfig, -1)
            self.presets[preset] = from_file
        else
            self.presets[preset] = DeepCopy(defaultConfig)
        end
    end
    return true
end
function loadColorPreset(preset) return COLORS:loadColorPreset(preset) end

function changeCurrentColorPreset(preset)
    if colorConfig == nil then print("Color config does not exist???") return end
    colorConfig:get_data().currentPreset = preset
    colorConfig:set_dirty()
    colorConfig:save()

    COLORS:loadColorPreset(preset)
    MESSAGEMAN:Broadcast("ColorConfigUpdated")
end

function COLORS.saveColor(self, category, element, rawColor)
    self.presets[getColorPreset()][category][element] = rawColor
    MESSAGEMAN:Broadcast("ColorConfigUpdated")
end
function saveColor(category, element, rawColor) COLORS:saveColor(category, element, rawColor) end

function COLORS.saveColorPreset(self, preset) return writePreset(preset) end
function saveColorPreset(preset) return COLORS:saveColorPreset(preset) end
function COLORS.newColorPreset(self, name) return writeNamedDefaultPreset(name) end
function newColorPreset(name) return COLORS:newColorPreset(name) end

-- main color access function
-- uses the currently selected preset in COLORS
function COLORS.getColor(self, category, element)
    local preset = getColorPreset()
    if element == nil then
        print("The element given to COLORS:getColor was nil, so #FFFFFF was returned.")
        return color("1,1,1,1")
    end
    if preset ~= nil then
        local presetconfig = self.presets[preset]
        if presetconfig ~= nil then
            local catdef = presetconfig[category]
            if catdef ~= nil then
                local result = catdef[element]
                if result ~= nil then
                    return color(result)
                else
                    print("The element "..element.." was not in category "..category.." in the color preset "..preset..". Loaded default in its place.")
                    return getDefaultColor(category, element)
                end
            else
                print("The category "..category.." was not in the color preset "..preset..". Loaded default in its place.")
                return getDefaultColor(category, element)
            end
        else
            print("The color preset "..preset.." was not loaded. Loaded the default preset in its place.")
            return getDefaultColor(category, element)
        end
    else
        print("Current color preset is empty. Malformed colorConfig.lua? Loaded default color instead.")
        return getDefaultColor(category, element)
    end
end

function COLORS.getMainColor(self, element)
    return self:getColor("main", element)
end

function COLORS.getLeaderboardColor(self, element)
    return self:getColor("leaderboard", element)
end

function COLORS.getComboColor(self, element)
    return self:getColor("combo", element)
end

function COLORS.colorByClearType(self, type)
    return self:getColor("clearType", type)
end

function COLORS.getTitleColor(self, element)
    return self:getColor("title", element)
end
function getTitleColor(element) return COLORS:getTitleColor(element) end

function COLORS.getGameplayColor(self, element)
    return self:getColor("gameplay", element)
end
function getGameplayColor(element) return COLORS:getGameplayColor(element) end

function COLORS.getWheelColor(self, element)
    return self:getColor("musicWheel", element)
end
function getWheelColor(element) return COLORS:getWheelColor(element) end

function COLORS.getDownloaderColor(self, element)
    return self:getColor("downloader", element)
end
function getDownloaderColor(element) return COLORS:getDownloaderColor(element) end

function COLORS.colorByJudgment(self, judge)
    return self:getColor("judgment", judge)
end

function COLORS.colorByDifficulty(self, diff)
    return self:getColor("difficulty", diff)
end

function COLORS.colorByGrade(self, grade)
    return self:getColor("grades", grade)
end

-- expecting ms input (153, 13.321, etc) so convert to seconds to compare to judgment windows -mina
function COLORS.colorByTapOffset(self, offset, scale)
    local offset = math.abs(offset / 1000)
    if not scale then
        scale = PREFSMAN:GetPreference("TimingWindowScale")
    end
    if offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW1") then
        return self:colorByJudgment("TapNoteScore_W1")
    elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW2") then
        return self:colorByJudgment("TapNoteScore_W2")
    elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW3") then
        return self:colorByJudgment("TapNoteScore_W3")
    elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW4") then
        return self:colorByJudgment("TapNoteScore_W4")
    elseif offset <= math.max(scale * PREFSMAN:GetPreference("TimingWindowSecondsW5"), 0.180) then
        return self:colorByJudgment("TapNoteScore_W5")
    else
        return self:colorByJudgment("TapNoteScore_Miss")
    end
end

function COLORS.colorByTapOffsetCustomWindow(self, offset, windows)
	local offset = math.abs(offset)
	if offset <= windows.TapNoteScore_W1 then
		return self:colorByJudgment("TapNoteScore_W1")
	elseif offset <= windows.TapNoteScore_W2 then
		return self:colorByJudgment("TapNoteScore_W2")
	elseif offset <= windows.TapNoteScore_W3 then
		return self:colorByJudgment("TapNoteScore_W3")
	elseif offset <= windows.TapNoteScore_W4 then
		return self:colorByJudgment("TapNoteScore_W4")
	elseif offset <= windows.TapNoteScore_W5 then
		return self:colorByJudgment("TapNoteScore_W5")
	else
		return self:colorByJudgment("TapNoteScore_Miss")
	end
end

function colorByMSD(x)
    if x then
        return HSV(math.max(95 - (x / 40) * 150, -50), 0.9, 0.9)
    end
    return HSV(0, 0.9, 0.9)
end

function colorByMusicLength(x)
    if x then
        x = math.min(x, 600)
        return HSV(math.max(95 - (x / 900) * 150, -50), 0.9, 0.9)
    end
    return HSV(0, 0.9, 0.9)
end

function colorByFileSize(x)
    if x then
        x = math.min(x, 600)
        return HSV(math.max(95 - (x / 1025) * 150, -50), 0.9, 0.9)
    end
    return HSV(0, 0.9, 0.9)
end

function colorByNPS(x)
    return color("#ffffff")
    -- if we want to make a gradient
    --[[
    if x then
        x = math.min(x, 60)
        return HSV(math.max(95 - (x / 50) * 150, -50), 0.9, 0.9)
    end
    return HSV(0, 0.9, 0.9)
    ]]
end

-- aliases for smooth brains
function COLORS.getColorConfigElementsForCategory(self, cat) return getColorConfigElementsForCategory(cat) end
function COLORS.getColorConfigCategories(self) return getColorConfigCategories() end
function COLORS.colorByMSD(self, x) return colorByMSD(x) end
function COLORS.colorByMusicLength(self, x) return colorByMusicLength(x) end
function COLORS.colorByFileSize(self, x) return colorByFileSize(x) end
function COLORS.colorByNPS(self, x) return colorByNPS(x) end
function getMainColor(ele) return COLORS:getMainColor(ele) end
function getLeaderboardColor(ele) return COLORS:getLeaderboardColor(ele) end
function getComboColor(ele) return COLORS:getComboColor(ele) end
function colorByClearType(x) return COLORS:colorByClearType(x) end
function colorByJudgment(x) return COLORS:colorByJudgment(x) end
function colorByDifficulty(x) return COLORS:colorByDifficulty(x) end
function colorByGrade(x) return COLORS:colorByGrade(x) end
function colorByTapOffset(x, ts) return COLORS:colorByTapOffset(x, ts) end
function colorByTapOffsetCustomWindow(x, windows) return COLORS:colorByTapOffsetCustomWindow(x, windows) end

---=======- UTIL
-- convert a given color = {r,g,b,a} to the 4 HSV+alpha values
function colorToHSVNums(color)
    local r = color[1]
    local g = color[2]
    local b = color[3]
    local cmax = math.max(r, g, b)
    local cmin = math.min(r, g, b)
    local dc = cmax - cmin -- delta c
    local h = 0
    if dc == 0 then
        h = 0
    elseif cmax == r then
        h = 60 * (((g-b)/dc) % 6)
    elseif cmax == g then
        h = 60 * (((b-r)/dc) + 2)
    elseif cmax == b then
        h = 60 * (((r-g)/dc) + 4)
    end
    local s = (cmax == 0 and 0 or dc / cmax)
    local v = cmax

    local alpha = (color[4] and color[4] or 1)

    return h, 1-s, 1-v, alpha
end

-- convert a given color = {r,g,b,a} to the 4 hex bytes RRGGBBAA
function colorToRGBNums(c)
    local r = c[1]
    local g = c[2]
    local b = c[3]
    local a = HasAlpha(c)
    local rX = scale(r, 0, 1, 0, 255)
    local gX = scale(g, 0, 1, 0, 255)
    local bX = scale(b, 0, 1, 0, 255)
    local aX = scale(a, 0, 1, 0, 255)
    return rX, gX, bX, aX
end

-- use this function and provide any actor to be colored automatically
-- allows providing a stroke brightness optionally
-- immediately updates the color and also listens for future updates
-- make sure not to overwrite ColorConfigUpdateMessage[Command]
-- however, this function will not be useful for complex items which
--    require coloring different ways based on conditions
--    for those situations, do not use this function but instead utilize the command
function registerActorToColorConfigElement(self, category, element, stroke)
    if stroke == nil then stroke = 0 end
    local cmd = function(self)
        local alphab4 = self:GetDiffuseAlpha()
        local clr = COLORS:getColor(category, element)
        self:diffuse(clr)
        self:diffusealpha(alphab4)
        if self.strokecolor and stroke ~= 0 then
            self:strokecolor(Brightness(clr, stroke))
        end
    end
    cmd(self)
    if self:GetCommand("ColorConfigUpdated") == nil then
        self:addcommand("ColorConfigUpdatedMessage", cmd)
    else
        print("Found duplicate ColorConfigUpdatedMessageCommand in element "..(self:GetName() or "UNNAMED"))
    end
end

-- same as the above but instead its for elements that use diffuseramp
function registerActorToColorConfigElementForDiffuseRamp(self, category, element, lowAlpha, hiAlpha)
    local cmd = function(self)
        local lowColor = COLORS:getColor(category, element)
        lowColor[4] = lowAlpha
        local hiColor = COLORS:getColor(category, element)
        hiColor[4] = hiAlpha
        self:effectcolor1(lowColor)
        self:effectcolor2(hiColor)
    end
    cmd(self)
    if self:GetCommand("ColorConfigUpdated") == nil then
        self:addcommand("ColorConfigUpdatedMessage", cmd)
    else
        print("Found duplicate ColorConfigUpdatedMessageCommand in element "..(self:GetName() or "UNNAMED"))
    end
end

-- run this stuff at init/load
COLORS:loadColorConfigPresets()
