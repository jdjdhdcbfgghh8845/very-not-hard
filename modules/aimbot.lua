--[[
    AIMBOT MODULE (v4.0)
    Modular Aimbot & Silent Aim logic.
]]

local AimbotModule = {}
local G = getgenv and getgenv() or _G

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ STATE ]]
local settings = {
    Enabled = false,
    Smoothness = 0.2,
    FOV = 200,
    TargetPart = "Head",
    WallCheck = true,
    TeamCheck = true,
    SilentAim = false,
    SilentHitChance = 100
}

local Math = G.UniversalShooter.Load("utils/math_helper")

-- [[ Target Logic ]]
local function getClosestPlayer()
    local closest = nil
    local dist = settings.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(settings.TargetPart) then
            -- Team check
            if settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local part = player.Character[settings.TargetPart]
            local screenDist = Math:GetMouseDistance(part.Position)
            
            if screenDist < dist then
                -- Wall check
                if settings.WallCheck then
                    local ray = workspace.CurrentCamera:ViewportPointToRay(screenDist.X, screenDist.Y)
                    -- Simplified wall check logic
                end
                
                dist = screenDist
                closest = player
            end
        end
    end
    return closest
end

-- [[ CORE ]]
function AimbotModule:Initialize(Framework)
    local Window = G.UniversalShooter.UIWindow
    local Page = Window:AddTab("Aimbot", "🎯")
    
    -- Aimbot Tile
    local aimTile, aimCont = Page:AddTile("Aimbot", settings.Enabled, function(s) settings.Enabled = s end)
    aimTile:AddSlider("Smoothness", 0.05, 1, settings.Smoothness, function(v) settings.Smoothness = v end)
    aimTile:AddSlider("FOV size", 50, 800, settings.FOV, function(v) settings.FOV = v end)
    aimTile:AddToggle("Wall Check", settings.WallCheck, function(s) settings.WallCheck = s end)
    aimTile:AddToggle("Team Check", settings.TeamCheck, function(s) settings.TeamCheck = s end)
    
    -- Silent Aim Tile
    local silentTile, silentCont = Page:AddTile("Silent Aim", settings.SilentAim, function(s) settings.SilentAim = s end)
    silentTile:AddSlider("Hit Chance %", 0, 100, settings.SilentHitChance, function(v) settings.SilentHitChance = v end)

    -- Loop
    RunService.RenderStepped:Connect(function()
        if not settings.Enabled then return end
        
        local target = getClosestPlayer()
        if target and target.Character then
            -- Aim logic
            local targetPart = target.Character[settings.TargetPart]
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
        end
    end)
    
    print("[MODULE] 🎯 Aimbot Initialized")
end

return AimbotModule
