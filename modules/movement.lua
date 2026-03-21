--[[
    MOVEMENT MODULE (v4.0)
    Speed Hack, Noclip, Infinite Jump.
]]

local MovementModule = {}
local G = getgenv and getgenv() or _G

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local settings = {
    SpeedEnabled = false,
    SpeedMultiplier = 2,
    Noclip = false,
    InfJump = false
}

function MovementModule:Initialize(Framework)
    local Window = G.UniversalShooter.UIWindow
    local Page = Window:AddTab("Movement", "✈️")
    
    -- Speed Tile
    local speedTile, speedCont = Page:AddTile("Speed Hack", settings.SpeedEnabled, function(s) settings.SpeedEnabled = s end)
    speedTile:AddSlider("Multiplier", 1, 10, settings.SpeedMultiplier, function(v) settings.SpeedMultiplier = v end)
    
    -- Noclip Tile
    local noclipTile, noclipCont = Page:AddTile("Noclip", settings.Noclip, function(s) settings.Noclip = s end)
    
    -- Infinite Jump Tile
    local jumpTile, jumpCont = Page:AddTile("Infinite Jump", settings.InfJump, function(s) settings.InfJump = s end)

    -- Loops
    task.spawn(function()
        while task.wait(0.1) do
            if settings.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16 * settings.SpeedMultiplier
            end
        end
    end)

    RunService.Stepped:Connect(function()
        if settings.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    print("[MODULE] 🚀 Movement Initialized")
end

return MovementModule
