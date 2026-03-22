-- [[ NEXUS MODULE - MOVEMENT ]]
local Module = {
    Name = "Movement",
    Icon = "⚡"
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("Movement", Module.Icon)
    
    local speed = page:AddFeatureTile("Speed", "⚡", false, function(state) end)
    speed:AddSlider("Multiplier", 1, 10, 2, function(v) end)
    
    local fly = page:AddFeatureTile("Fly", "✈️", false, function(state) end)
    fly:AddSlider("Fly Speed", 1, 100, 50, function(v) end)
    
    local noclip = page:AddFeatureTile("Noclip", "🧱", false, function(state) end)
    local infjump = page:AddFeatureTile("Inf Jump", "🦘", false, function(state) end)
end

return Module
