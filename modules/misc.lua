-- [[ AAC MODULE - MISC ]]
local UI = _G.AAC.Core.UI
local Misc = {}

function Misc.Init()
    local page = UI:CreatePage("Misc")
    
    local fullbright = UI:AddFeatureTile("Misc", "Fullbright", false, function(state)
        if state then
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
            game:GetService("Lighting").Brightness = 2
        else
            game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
            game:GetService("Lighting").Brightness = 1
        end
    end)
    
    local fpsboost = UI:AddFeatureTile("Misc", "FPS Boost", false, function(state)
        if state then
            settings().Rendering.QualityLevel = 1
        end
    end)
end

Misc.Init()
return Misc
