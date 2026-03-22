-- [[ AAC MODULE - MISC (WORLD VISUALS) ]]
local UI = _G.AAC.Core.UI
local Misc = {
    Themes = {
        Cyberpunk = {Ambient = Color3.fromRGB(40, 0, 80), Fog = Color3.fromRGB(20, 0, 40)},
        Neon = {Ambient = Color3.fromRGB(100, 0, 150), Fog = Color3.fromRGB(50, 0, 70)},
        Hell = {Ambient = Color3.fromRGB(120, 0, 0), Fog = Color3.fromRGB(60, 0, 0)},
        Ice = {Ambient = Color3.fromRGB(0, 100, 200), Fog = Color3.fromRGB(50, 100, 150)},
        Matrix = {Ambient = Color3.fromRGB(0, 80, 0), Fog = Color3.fromRGB(0, 40, 0)}
    },
    CurrentTheme = "None",
    RainbowEnabled = false,
    PulseEnabled = false,
    OriginalLighting = {}
}

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local blur = Instance.new("BlurEffect", Lighting)
local correction = Instance.new("ColorCorrectionEffect", Lighting)
blur.Enabled = false
correction.Enabled = false

-- [[ LIGHTING LOGIC ]]
local function saveLighting()
    Misc.OriginalLighting = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogColor = Lighting.FogColor,
        Brightness = Lighting.Brightness
    }
end
saveLighting()

local function applyTheme(name)
    local theme = Misc.Themes[name]
    if theme then
        Lighting.Ambient = theme.Ambient
        Lighting.FogColor = theme.Fog
        Lighting.Brightness = 2
        UI:Notify("THEME APPLIED: " .. name)
    else
        Lighting.Ambient = Misc.OriginalLighting.Ambient
        Lighting.FogColor = Misc.OriginalLighting.FogColor
        Lighting.Brightness = Misc.OriginalLighting.Brightness
        UI:Notify("THEME RESET")
    end
end

RunService.RenderStepped:Connect(function()
    local t = tick()
    if Misc.RainbowEnabled then
        local color = Color3.fromHSV((t * 0.2) % 1, 1, 1)
        Lighting.Ambient = color
        Lighting.OutdoorAmbient = Color3.fromHSV((t * 0.2 + 0.1) % 1, 1, 1)
        
        blur.Enabled = true
        blur.Size = 3 + math.sin(t * 3) * 3
        correction.Enabled = true
        correction.Saturation = 0.4 + math.sin(t * 2) * 0.3
        correction.Contrast = 0.2 + math.sin(t * 1.5) * 0.15
    else
        blur.Enabled = false
        correction.Enabled = false
    end
    
    if Misc.PulseEnabled then
        Lighting.Brightness = 2 + math.sin(t * 4) * 0.5
    end
end)

-- [[ INITIALIZATION ]]
function Misc.Init()
    local page = UI:CreatePage("Misc")
    
    local world = UI:AddFeatureTile("Misc", "World Themes", false, function(s) if not s then applyTheme("None") end end)
    world:AddToggle("Rainbow Mode", false, function(s) Misc.RainbowEnabled = s end)
    world:AddToggle("Pulse Light", false, function(s) Misc.PulseEnabled = s end)
    for name, _ in pairs(Misc.Themes) do
        world:AddToggle(name, false, function(s) if s then applyTheme(name) end end)
    end
    world:AddKeybind("Shortcut")

    local clock = UI:AddFeatureTile("Misc", "Time Control", false, function(s) end)
    clock:AddSlider("Time of Day", 0, 24, 12, function(v) Lighting.ClockTime = v end)
    clock:AddKeybind("Shortcut")
end

Misc.Init()
return Misc
