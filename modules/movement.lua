-- [[ AAC MODULE - MOVEMENT (ADVANCED) ]]
local UI = _G.AAC.Core.UI
local Movement = {
    SpeedEnabled = false,
    SpeedMult = 2,
    Noclip = false,
    InfJump = false,
    Flight = false,
    FlightSpeed = 50,
    OriginalGravity = workspace.Gravity
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ CORE FUNCTIONS ]]
local function getHumanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end

-- [[ SPEED HACK ]]
local function updateSpeed()
    local hum = getHumanoid()
    if not hum then return end
    
    if Movement.SpeedEnabled then
        hum.WalkSpeed = 16 * Movement.SpeedMult
    else
        hum.WalkSpeed = 16
    end
end

-- [[ NOCLIP ]]
RunService.Stepped:Connect(function()
    if Movement.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- [[ INF JUMP ]]
UserInputService.JumpRequest:Connect(function()
    if Movement.InfJump then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- [[ ELITE FLIGHT SYSTEM ]]
local function updateFlight()
    if not Movement.Flight or not LocalPlayer.Character then 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bp = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AAC_Flight")
            if bp then bp:Destroy() end
        end
        return 
    end
    
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local bv = root:FindFirstChild("AAC_Flight") or Instance.new("BodyVelocity")
    bv.Name = "AAC_Flight"
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root
    
    local cam = workspace.CurrentCamera
    local moveDir = Vector3.new(0,0,0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
    
    bv.Velocity = moveDir.Unit * Movement.FlightSpeed
    if moveDir.Magnitude == 0 then bv.Velocity = Vector3.new(0, 0, 0) end
end

RunService.RenderStepped:Connect(function()
    if Movement.Flight then updateFlight() end
end)

-- [[ INITIALIZATION ]]
function Movement.Init()
    local page = UI:CreatePage("Movement")
    
    local speed = UI:AddFeatureTile("Movement", "Speed Hack", false, function(s) Movement.SpeedEnabled = s updateSpeed() end)
    speed:AddSlider("Multiplier", 1, 20, 2, function(v) Movement.SpeedMult = v updateSpeed() end)
    
    local flight = UI:AddFeatureTile("Movement", "Elite Flight", false, function(s) Movement.Flight = s end)
    flight:AddSlider("Flight Speed", 20, 200, 50, function(v) Movement.FlightSpeed = v end)
    
    local hacks = UI:AddFeatureTile("Movement", "Utilities", false, function(s) Movement.Noclip = s Movement.InfJump = s end)
    hacks:AddToggle("Noclip", false, function(s) Movement.Noclip = s end)
    hacks:AddToggle("Infinite Jump", false, function(s) Movement.InfJump = s end)
end

Movement.Init()
return Movement
