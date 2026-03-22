-- [[ AAC MODULE - SETTINGS (ELITE CONFIG) ]]
local UI = _G.AAC.Core.UI
local Settings = {}
local HttpService = game:GetService("HttpService")

-- [[ SAVE / LOAD CONFIG ]]
local function saveConfig()
    local config = {
        Keybinds = UI.Keybinds,
        AccentColor = {R = UI.Config.AccentColor.R, G = UI.Config.AccentColor.G, B = UI.Config.AccentColor.B}
    }
    writefile("AAC_Config.json", HttpService:JSONEncode(config))
    UI:Notify("CONFIGURATION SAVED")
end

local function loadConfig()
    if isfile("AAC_Config.json") then
        local config = HttpService:JSONDecode(readfile("AAC_Config.json"))
        if config.Keybinds then UI.Keybinds = config.Keybinds end
        if config.AccentColor then
            local c = config.AccentColor
            UI:UpdateAccentColor(Color3.new(c.R, c.G, c.B))
        end
        UI:Notify("CONFIGURATION LOADED")
    end
end

-- [[ INITIALIZATION ]]
function Settings.Init()
    local page = UI:CreatePage("Settings")
    
    local theme = UI:AddFeatureTile("Settings", "Theme Color", true, function() end)
    theme:AddSlider("Accent R", 0, 255, 200, function(v) 
        local c = UI.Config.AccentColor
        UI:UpdateAccentColor(Color3.fromRGB(v, c.G*255, c.B*255))
    end)
    theme:AddSlider("Accent G", 0, 255, 30, function(v) 
        local c = UI.Config.AccentColor
        UI:UpdateAccentColor(Color3.fromRGB(c.R*255, v, c.B*255))
    end)
    theme:AddSlider("Accent B", 0, 255, 30, function(v) 
        local c = UI.Config.AccentColor
        UI:UpdateAccentColor(Color3.fromRGB(c.R*255, c.G*255, v))
    end)
    theme:AddKeybind("Shortcut")

    local config = UI:AddFeatureTile("Settings", "Config Manager", true, function() end)
    config:AddToggle("Auto Save", false, function(s) end)
    config:AddToggle("Save Now", false, function() saveConfig() end)
    config:AddToggle("Load Now", false, function() loadConfig() end)
    
    local info = UI:AddFeatureTile("Settings", "Elite Status", true, function() end)
    -- Labels are added automatically in Tile
end

Settings.Init()
return Settings
