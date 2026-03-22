-- [[ AAC MODULE - SETTINGS ]]
local UI = _G.AAC.Core.UI
local Settings = {}

function Settings.Init()
    local page = UI:CreatePage("Settings")
    
    local uiConfig = UI:AddFeatureTile("Settings", "UI Config", true, function(state) end)
    uiConfig:AddToggle("Parallax", true, function(s) end)
    
    local unload = UI:AddFeatureTile("Settings", "Unload Cheat", false, function(state)
        if state then
            UI.Refs.MainGui:Destroy()
            -- Add cleanup logic here
        end
    end)
end

Settings.Init()
return Settings
