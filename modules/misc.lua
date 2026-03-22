-- [[ AAC MODULE - MISC (WORLD VISUALS) ]]
local UI = _G.AAC.Core.UI
local Misc = {
    Themes = {
        Cyberpunk = {Ambient = Color3.fromRGB(40, 0, 80), Fog = Color3.fromRGB(20, 0, 40)},
        Neon = {Ambient = Color3.fromRGB(100, 0, 150), Fog = Color3.fromRGB(50, 0, 70)},
        Hell = {Ambient = Color3.fromRGB(120, 0, 0), Fog = Color3.fromRGB(60, 0, 0)},
        Ice = {Ambient = Color3.fromRGB(0, 100, 200), Fog = Color3.fromRGB(50, 100, 150)},
        Matrix = {Ambient = Color3.fromRGB(0, 80, 0), Fog = Color3.fromRGB(0, 40, 0)},
        Vaporwave = {Ambient = Color3.fromRGB(150, 50, 150), Fog = Color3.fromRGB(200, 100, 200)},
        Sunset = {Ambient = Color3.fromRGB(255, 100, 0), Fog = Color3.fromRGB(150, 50, 0)}
    },
    CurrentTheme = "None",
    RainbowEnabled = false,
    PulseEnabled = false,
    FullBright = false,
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
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        ExposureCompensation = Lighting.ExposureCompensation
    }
end
if not Misc.OriginalLighting.Ambient then saveLighting() end

local function applyTheme(name)
    local theme = Misc.Themes[name]
    if theme then
        Lighting.Ambient = theme.Ambient
        Lighting.FogColor = theme.Fog
        Lighting.Brightness = 2
        UI:Notify("THEME: " .. name)
    else
        Lighting.Ambient = Misc.OriginalLighting.Ambient
        Lighting.FogColor = Misc.OriginalLighting.FogColor
        Lighting.Brightness = Misc.OriginalLighting.Brightness
        UI:Notify("THEME RESET")
    end
end

RunService.RenderStepped:Connect(function()
    local t = tick()
    
    if Misc.FullBright then
        Lighting.Brightness = 3
        Lighting.ExposureCompensation = 1.5
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.new(1, 1, 1)
    elseif not Misc.RainbowEnabled and Misc.CurrentTheme == "None" then
        Lighting.Brightness = Misc.OriginalLighting.Brightness
        Lighting.ExposureCompensation = Misc.OriginalLighting.ExposureCompensation
        Lighting.OutdoorAmbient = Misc.OriginalLighting.OutdoorAmbient
    end

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
    
    local world = UI:AddFeatureTile("Misc", "World Themes", false, function(s) if not s then applyTheme("None") Misc.CurrentTheme = "None" end end)
    world:AddToggle("FullBright", false, function(s) Misc.FullBright = s end)
    world:AddToggle("Rainbow Mode", false, function(s) Misc.RainbowEnabled = s end)
    world:AddToggle("Pulse Light", false, function(s) Misc.PulseEnabled = s end)
    world:AddKeybind("Shortcut")

    local selector = UI:AddFeatureTile("Misc", "Theme Select", false, function(s) end)
    for name, _ in pairs(Misc.Themes) do
        selector:AddToggle(name, false, function(s) 
            if s then 
                Misc.CurrentTheme = name
                applyTheme(name) 
            end 
        end)
    end
    
    local clock = UI:AddFeatureTile("Misc", "Time Control", false, function(s) end)
    clock:AddSlider("Time / Hour", 0, 24, 12, function(v) Lighting.ClockTime = v end)
    clock:AddSlider("Exposure", -5, 5, 0, function(v) Lighting.ExposureCompensation = v end)
    clock:AddKeybind("Shortcut")
end

Misc.Init()
return Misc
