-- [[ NEXUS MODULE - MOVEMENT ]]
-- Contains Speed, Noclip, and Fly features.

local Module = {
    Name = "Movement",
    Icon = "rbxassetid://10709763784" -- Run Icon
}

function Module.Init()
    local page = _G.Nexus.Core.UI:CreatePage("Movement", Module.Icon)
    
    local speed = page:AddFeatureTile("Speed", "rbxassetid://10709763784", false, function(state) end)
    speed:AddSlider("Multiplier", 1, 10, 2, function(v) end)
    
    local noclip = page:AddFeatureTile("Noclip", "rbxassetid://10709764121", false, function(state) end)
    local infjump = page:AddFeatureTile("Inf Jump", "rbxassetid://10709764350", false, function(state) end)
end

return Module
