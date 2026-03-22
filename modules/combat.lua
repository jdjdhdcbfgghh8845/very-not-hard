-- [[ AAC MODULE - COMBAT (ADVANCED) ]]
local UI = _G.AAC.Core.UI
local Combat = {
    AimbotEnabled = false,
    TriggerBotEnabled = false,
    FOV = 200,
    WallCheck = true,
    TeamCheck = true,
    Prediction = true,
    PredictionMult = 0.15,
    AutoShoot = false,
    HitboxEnabled = false,
    HitboxSize = 2,
    TargetPart = "Head",
    StickyAim = true
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ ANTI-CHEAT BYPASS (STEALTH) ]]
if hookmetamethod and checkcaller then
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if not checkcaller() and self == Camera and key == "CFrame" and Combat.AimbotEnabled then
            return CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.LookVector)
        end
        return oldIndex(self, key)
    end)
end

-- [[ UTILS ]]
local function isTeammate(player)
    if not Combat.TeamCheck then return false end
    return player.Team == LocalPlayer.Team
end

local function isVisible(part)
    if not Combat.WallCheck then return true end
    local castPoints = {part.Position, Camera.CFrame.Position}
    local ignoreList = {LocalPlayer.Character, part.Parent}
    local ray = Ray.new(castPoints[2], (castPoints[1] - castPoints[2]).Unit * (castPoints[1] - castPoints[2]).Magnitude)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    return hit == nil
end

-- [[ CORE LOGIC ]]
local currentTarget = nil
local posHistory = {}

local function getClosestPlayer()
    local target = nil
    local dist = Combat.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Combat.TargetPart) then
            if not isTeammate(p) then
                local part = p.Character[Combat.TargetPart]
                local screenPos, visible = Camera:WorldToViewportPoint(part.Position)
                if visible then
                    local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if screenDist < dist and isVisible(part) then
                        dist = screenDist
                        target = p
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- Hitbox Expansion
    if Combat.HitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not Combat.TeamCheck or not isTeammate(p) then
                    pcall(function()
                        local head = p.Character.Head
                        head.Size = Vector3.new(Combat.HitboxSize, Combat.HitboxSize, Combat.HitboxSize)
                        head.Transparency = 0.5
                        head.CanCollide = false
                    end)
                end
            end
        end
    end

    -- Aimbot 
    if Combat.AimbotEnabled then
        if Combat.StickyAim and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(Combat.TargetPart) then
            -- Stay on target
        else
            currentTarget = getClosestPlayer()
        end
        
        if currentTarget and currentTarget.Character then
            local part = currentTarget.Character[Combat.TargetPart]
            local pos = part.Position
            
            if Combat.Prediction then
                local vel = part.Velocity
                local d = (Camera.CFrame.Position - pos).Magnitude
                pos = pos + (vel * (d / 1000) * Combat.PredictionMult * 10)
            end
            
            local sPos = Camera:WorldToViewportPoint(pos)
            mousemoverel((sPos.X - UserInputService:GetMouseLocation().X) / 2, (sPos.Y - UserInputService:GetMouseLocation().Y) / 2)
            
            if Combat.AutoShoot and isVisible(part) then
                mouse1press()
                task.wait(0.01)
                mouse1release()
            end
        end
    else
        currentTarget = nil
    end
end)

-- [[ TRIGGER BOT ]]
task.spawn(function()
    while task.wait(0.01) do
        if Combat.TriggerBotEnabled then
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                local player = Players:GetPlayerFromCharacter(target.Parent)
                if player and player ~= LocalPlayer and not isTeammate(player) then
                    mouse1click()
                end
            end
        end
    end
end)

-- [[ INITIALIZATION ]]
function Combat.Init()
    local page = UI:CreatePage("Combat")
    
    local aim = UI:AddFeatureTile("Combat", "Aimbot", false, function(s) Combat.AimbotEnabled = s end)
    aim:AddToggle("Sticky", true, function(s) Combat.StickyAim = s end)
    aim:AddToggle("Prediction", true, function(s) Combat.Prediction = s end)
    aim:AddToggle("Auto Shoot", false, function(s) Combat.AutoShoot = s end)
    aim:AddSlider("FOV", 50, 800, 200, function(v) Combat.FOV = v end)
    aim:AddKeybind("Shortcut")
    
    local hitbox = UI:AddFeatureTile("Combat", "Hitbox", false, function(s) Combat.HitboxEnabled = s end)
    hitbox:AddSlider("Size", 1, 15, 2, function(v) Combat.HitboxSize = v end)
    hitbox:AddToggle("Team Check", true, function(s) Combat.TeamCheck = s end)
    hitbox:AddKeybind("Shortcut")

    local trigger = UI:AddFeatureTile("Combat", "Trigger Bot", false, function(s) Combat.TriggerBotEnabled = s end)
    trigger:AddKeybind("Shortcut")
end

Combat.Init()
return Combat
