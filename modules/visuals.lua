-- [[ NEXUS MODULE - VISUALS ]]
local Module = {
    Name = "Visuals",
    Icon = "👁️"
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("Visuals", Module.Icon)
    
    local esp = page:AddFeatureTile("ESP", "👁️", false, function(state) end)
    esp:AddToggle("Show Names", true, function(s) end)
    esp:AddToggle("Show Boxes", true, function(s) end)
    esp:AddSlider("Max Distance", 100, 5000, 1000, function(v) end)
    
    local chams = page:AddFeatureTile("Chams", "👻", false, function(state) end)
    chams:AddToggle("Team Check", true, function(s) end)
    
    local tracers = page:AddFeatureTile("Tracers", "📏", false, function(state) end)
    tracers:AddSlider("Thickness", 1, 5, 2, function(v) end)
end

return Module
