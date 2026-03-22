-- [[ AAC MODULE - COMBAT ]]
local UI = _G.AAC.Core.UI
local Combat = {
    AimbotActive = false,
    Smoothness = 5,
    FOV = 150,
    WallCheck = true,
    Target = nil
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = UI.Config.AccentColor
FOVCircle.Filled = false
FOVCircle.Visible = false

function Combat.GetClosestPlayer()
    local closestDist = Combat.FOV
    local target = nil
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        -- Wall check
                        local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 500)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, player.Character})
                        
                        if not Combat.WallCheck or not hit then
                            closestDist = dist
                            target = head
                        end
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Combat.FOV
    FOVCircle.Visible = Combat.AimbotActive
    
    if Combat.AimbotActive and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = Combat.GetClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local move = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) / Combat.Smoothness
            mousemoverel(move.X, move.Y)
        end
    end
end)

function Combat.Init()
    local page = UI:CreatePage("Combat")
    
    local aimbot = UI:AddFeatureTile("Combat", "Aimbot", false, function(state)
        Combat.AimbotActive = state
    end)
    aimbot:AddToggle("Wall Check", true, function(s) Combat.WallCheck = s end)
    aimbot:AddSlider("Smoothness", 1, 20, 5, function(v) Combat.Smoothness = v end)
    aimbot:AddSlider("FOV", 10, 800, 150, function(v) Combat.FOV = v end)
    
    local silentaim = UI:AddFeatureTile("Combat", "Silent Aim", false, function(state) end)
    
    local test = UI:AddFeatureTile("Combat", "Test Button", false, function(state) print("Combat Test Clicked!") end)
end

Combat.Init()
return Combat

Combat.Init()
return Combat
