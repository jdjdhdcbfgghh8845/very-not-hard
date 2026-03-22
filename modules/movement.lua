-- [[ AAC MODULE - MOVEMENT ]]
local UI = _G.AAC.Core.UI
local Movement = {
    SpeedActive = false,
    SpeedValue = 50,
    InfJumpActive = false
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

RunService.Heartbeat:Connect(function()
    if Movement.SpeedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Movement.SpeedValue
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Movement.InfJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

function Movement.Init()
    local page = UI:CreatePage("Movement")
    
    local speed = UI:AddFeatureTile("Movement", "Speed Hack", false, function(state)
        Movement.SpeedActive = state
        if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
    speed:AddSlider("Speed", 16, 200, 50, function(v) Movement.SpeedValue = v end)
    
    local infjump = UI:AddFeatureTile("Movement", "Inf Jump", false, function(state)
        Movement.InfJumpActive = state
    end)
    
    local test = UI:AddFeatureTile("Movement", "Test Button", false, function(state) print("Movement Test Clicked!") end)
end

Movement.Init()
return Movement
