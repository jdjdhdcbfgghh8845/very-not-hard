-- [[ NEXUS MODULE - WORLD ]]
local Module = {
    Name = "World",
    Icon = "rbxassetid://10709710343"
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("World", Module.Icon)
    
    local rainbow = page:AddFeatureTile("Rainbow", "rbxassetid://10709771131", false, function(state) end)
    rainbow:AddSlider("Speed", 1, 10, 1, function(v) end)
    rainbow:AddToggle("Distortion", true, function(s) end)
    
    local themes = page:AddFeatureTile("Themes", "rbxassetid://10709771480", false, function(state) end)
    themes:AddToggle("Dark Mode", true, function(s) end)
end

return Module
