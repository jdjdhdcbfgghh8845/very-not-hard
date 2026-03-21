--[[
    WORLD MODULE (v4.0)
    Themes, Rainbow Mode, and Distortion Effects.
]]

local WorldModule = {}
local G = getgenv and getgenv() or _G

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local settings = {
    RainbowEnabled = false,
    Distortion = true,
    Theme = "Cyberpunk"
}

function WorldModule:Initialize(Framework)
    local Window = G.UniversalShooter.UIWindow
    local Page = Window:AddTab("World", "🌍")
    
    -- Rainbow Tile
    local rainTile, rainCont = Page:AddTile("Rainbow Mode", settings.RainbowEnabled, function(s) 
        settings.RainbowEnabled = s 
        if not s then 
            -- Reset effects
            if G.CustomBlur then G.CustomBlur.Size = 0 end
        end
    end)
    rainTile:AddToggle("Distortion", settings.Distortion, function(s) settings.Distortion = s end)
    
    -- Themes Tile
    local themeTile, themeCont = Page:AddTile("Themes", true, function() end)

    -- Setup Effects
    local blur = Lighting:FindFirstChild("CustomBlur") or Instance.new("BlurEffect", Lighting)
    blur.Name = "CustomBlur"
    G.CustomBlur = blur

    -- Rainbow Loop
    RunService.Heartbeat:Connect(function()
        if not settings.RainbowEnabled then return end
        
        local t = tick()
        local hue = (t * 0.2) % 1
        local color = Color3.fromHSV(hue, 0.8, 1)
        
        Lighting.Ambient = color
        Lighting.OutdoorAmbient = Color3.fromHSV((hue + 0.1) % 1, 0.7, 0.8)
        
        if settings.Distortion then
            blur.Enabled = true
            blur.Size = 4 + math.sin(t * 3) * 4
        end
    end)

    print("[MODULE] 🌍 World Initialized")
end

return WorldModule
