-- [[ NEXUS MODULE - WORLD ]]
-- Contains Lighting, Themes, and World effects.

local Module = {
    Name = "World",
    Icon = "🌎"
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("World", Module.Icon)
    
    local rainbow = page:AddFeatureTile("Rainbow", "🌈", false, function(state) end)
    rainbow:AddSlider("Speed", 1, 10, 1, function(v) end)
    rainbow:AddToggle("Distortion", true, function(s) end)
    
    local themes = page:AddFeatureTile("Themes", "🎨", false, function(state) end)
end

return Module
