-- [[ NEXUS MODULE - WORLD ]]
local Module = {
    Name = "World",
    Icon = "World"
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("World", Module.Icon)
    
    local rainbow = page:AddFeatureTile("Rainbow", "Rainbow", false, function(state) end)
    rainbow:AddSlider("Speed", 1, 10, 1, function(v) end)
    rainbow:AddToggle("Distortion", true, function(s) end)
    
    local themes = page:AddFeatureTile("Themes", "World", false, function(state) end)
    themes:AddToggle("Dark Mode", true, function(s) end)
end

return Module
