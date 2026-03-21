--[[
    VISUALS MODULE (v4.0)
    Handles ESP, Chams, Tracers, and Crosshairs.
]]

local VisualsModule = {}
local G = getgenv and getgenv() or _G

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    Enabled = false,
    Boxes = true,
    Skeleton = false,
    Chams = false,
    Tracers = false,
    MaxDistance = 5000,
    TeamCheck = true
}

local Math = G.UniversalShooter.Load("utils/math_helper")
local DrawingLib = G.UniversalShooter.Load("utils/drawing_helper")

local espCaches = {}

-- [[ ESP RENDERER ]]
local function createESPElements()
    return {
        Box = DrawingLib:CreateLine(Color3.fromRGB(255, 255, 255), 1.5),
        Name = DrawingLib:CreateText("", Color3.fromRGB(255, 255, 255), 14)
    }
end

-- [[ CORE ]]
function VisualsModule:Initialize(Framework)
    local Window = G.UniversalShooter.UIWindow
    local Page = Window:AddTab("Visuals", "✺")
    
    -- UI Tiles
    local espTile, espCont = Page:AddTile("ESP", settings.Enabled, function(s) settings.Enabled = s end)
    espTile:AddToggle("Boxes", settings.Boxes, function(s) settings.Boxes = s end)
    espTile:AddToggle("Skeleton", settings.Skeleton, function(s) settings.Skeleton = s end)
    espTile:AddSlider("Max Distance", 100, 10000, settings.MaxDistance, function(v) settings.MaxDistance = v end)
    espTile:AddToggle("Team Check", settings.TeamCheck, function(s) settings.TeamCheck = s end)
    
    -- Chams Tile
    local chamsTile, chamsCont = Page:AddTile("Chams", settings.Chams, function(s) settings.Chams = s end)
    
    -- Tracers Tile
    local tracerTile, tracerCont = Page:AddTile("Tracers", settings.Tracers, function(s) settings.Tracers = s end)
    
    -- Main Loop
    RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            
            local cache = espCaches[player]
            if not cache then
                cache = createESPElements()
                espCaches[player] = cache
            end
            
            local visible = false
            if settings.Enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local screenPos, onScreen = Math:GetScreenPos(root.Position)
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
                
                if onScreen and dist < settings.MaxDistance then
                    visible = true
                    -- Update Box/Text logic here (Simplified for v4.0 Demo)
                    cache.Name.Visible = true
                    cache.Name.Position = screenPos
                    cache.Name.Text = player.Name .. " [" .. math.round(dist) .. "m]"
                end
            end
            
            if not visible then
                cache.Name.Visible = false
            end
        end
    end)
    
    print("[MODULE] 👁️ Visuals Rendering Active")
end

return VisualsModule
