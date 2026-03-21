-- [[ NEXUS MODULE - COMBAT ]]
-- Contains Aimbot, Silent Aim, and Trigger Bot features.

local Module = {
    Name = "Combat",
    Icon = "rbxassetid://10709761143" -- Target/Aim Icon
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("Combat", Module.Icon)
    
    local aimbot = page:AddFeatureTile("Aimbot", "rbxassetid://10709761143", false, function(state) end)
    aimbot:AddToggle("Wall Check", true, function(s) end)
    aimbot:AddSlider("Smoothness", 1, 10, 5, function(v) end)
    aimbot:AddSlider("FOV", 10, 360, 90, function(v) end)
    aimbot:AddToggle("Predict Movement", true, function(s) end)
    
    local triggerbot = page:AddFeatureTile("Trigger Bot", "rbxassetid://10709761595", false, function(state) end)
    triggerbot:AddSlider("Delay", 0, 1, 0.1, function(v) end)
    triggerbot:AddToggle("Require ADS", false, function(s) end)

    local silentaim = page:AddFeatureTile("Silent Aim", "rbxassetid://10709761922", false, function(state) end)
    silentaim:AddToggle("Headshot Only", false, function(s) end)
    silentaim:AddSlider("Hit Chance", 0, 100, 80, function(v) end)
end

return Module
