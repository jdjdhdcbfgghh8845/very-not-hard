-- [[ AAC MODULE - COMBAT (ADVANCED) ]]
local UI = _G.AAC.Core.UI
local Combat = {
    AimbotEnabled = false,
    TriggerBotEnabled = false,
    FOV = 200,
    ShowFOV = false,
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
local mouse = LocalPlayer:GetMouse()

-- [[ MOUSE FALLBACKS ]]
local mousemoverel = mousemoverel or (Input and Input.MouseMoveRel) or function(x, y)
    -- Fallback for basic executors if needed
end

-- [[ DRAWING API (FOV CIRCLE) ]]
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 60
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Visible = false

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
    -- FOV Circle
    fovCircle.Visible = Combat.ShowFOV
    if Combat.ShowFOV then
        fovCircle.Position = UserInputService:GetMouseLocation()
        fovCircle.Radius = Combat.FOV
        fovCircle.Color = UI.Config.AccentColor
    end

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
                -- Refined Frame-independent prediction
                local travelTime = d / 1500 -- Base velocity assumption for projectiles/hitscan ray
                pos = pos + (vel * travelTime * Combat.PredictionMult * 15)
            end
            
            local sPos, visible = Camera:WorldToViewportPoint(pos)
            if visible then
                local mPos = UserInputService:GetMouseLocation()
                mousemoverel((sPos.X - mPos.X) / 2, (sPos.Y - mPos.Y) / 2)
            end
            
            if Combat.AutoShoot and isVisible(part) then
                if mouse1click then mouse1click() else mouse1press() task.wait() mouse1release() end
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
            if target and target.Parent and (target.Parent:FindFirstChild("Humanoid") or target.Parent.Parent:FindFirstChild("Humanoid")) then
                local character = target.Parent:FindFirstChild("Humanoid") and target.Parent or target.Parent.Parent
                local player = Players:GetPlayerFromCharacter(character)
                if player and player ~= LocalPlayer and not isTeammate(player) then
                    if mouse1click then mouse1click() else mouse1press() task.wait() mouse1release() end
                end
            end
        end
    end
end)

-- [[ INITIALIZATION ]]
function Combat.Init()
    local page = UI:CreatePage("Combat")
    
    local aim = UI:AddFeatureTile("Combat", "Aimbot", false, function(s) Combat.AimbotEnabled = s end)
    aim:AddToggle("Sticky Target", true, function(s) Combat.StickyAim = s end)
    aim:AddToggle("Show FOV Circle", false, function(s) Combat.ShowFOV = s end)
    aim:AddToggle("Prediction", true, function(s) Combat.Prediction = s end)
    aim:AddToggle("Auto Shoot", false, function(s) Combat.AutoShoot = s end)
    aim:AddSlider("FOV Radius", 50, 800, 200, function(v) Combat.FOV = v end)
    aim:AddSlider("Pred Mult", 1, 20, 10, function(v) Combat.PredictionMult = v / 10 end)
    aim:AddKeybind("Shortcut")
    
    local hitbox = UI:AddFeatureTile("Combat", "Hitbox", false, function(s) Combat.HitboxEnabled = s end)
    hitbox:AddSlider("Head Scale", 1, 15, 2, function(v) Combat.HitboxSize = v end)
    hitbox:AddToggle("Team Check", true, function(s) Combat.TeamCheck = s end)
    hitbox:AddKeybind("Shortcut")

    local trigger = UI:AddFeatureTile("Combat", "Trigger Bot", false, function(s) Combat.TriggerBotEnabled = s end)
    trigger:AddKeybind("Shortcut")
end

Combat.Init()
return Combat
