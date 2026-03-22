-- [[ NEXUS MODULE - MOVEMENT ]]
local Module = {
    Name = "Movement",
    Icon = "rbxassetid://6035041071"
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("Movement", Module.Icon)
    
    local speed = page:AddFeatureTile("Speed", "rbxassetid://6035041071", false, function(state) end)
    speed:AddSlider("Multiplier", 1, 10, 2, function(v) end)
    
    local fly = page:AddFeatureTile("Fly", "rbxassetid://6447167882", false, function(state) end)
    fly:AddSlider("Fly Speed", 1, 100, 50, function(v) end)
    
    local noclip = page:AddFeatureTile("Noclip", "rbxassetid://6015243180", false, function(state) end)
    local infjump = page:AddFeatureTile("Inf Jump", "rbxassetid://6034440130", false, function(state) end)
end

return Module
