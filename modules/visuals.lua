-- [[ AAC MODULE - VISUALS (ADVANCED) ]]
local UI = _G.AAC.Core.UI
local Visuals = {
    Boxes = false,
    Names = false,
    Health = false,
    Distance = false,
    Skeleton = false,
    Tracers = false,
    Chams = false,
    RainbowChams = false,
    Glow = false,
    TeamCheck = true,
    MaxDist = 1000,
    Crosshair = false,
    Zoom = 70
}

local defaultFOV = 70
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local espObjects = {}
local crosshair = Instance.new("Frame", UI.Refs.MainGui)
crosshair.Size = UDim2.new(0, 4, 0, 4)
crosshair.BackgroundColor3 = Color3.new(1, 0, 0)
crosshair.BorderSizePixel = 0
crosshair.Visible = false
Instance.new("UICorner", crosshair).CornerRadius = UDim.new(1, 0)

-- [[ ESP LOGIC ]]
local function createESP(player)
    local data = {}
    data.Highlight = Instance.new("Highlight", player.Character or workspace)
    data.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    data.Billboard = Instance.new("BillboardGui", player.Character or workspace)
    data.Billboard.Size = UDim2.new(0, 200, 0, 50)
    data.Billboard.AlwaysOnTop = true
    data.Billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    
    data.Text = Instance.new("TextLabel", data.Billboard)
    data.Text.Size = UDim2.new(1, 0, 1, 0)
    data.Text.BackgroundTransparency = 1
    data.Text.TextColor3 = Color3.new(1, 1, 1)
    data.Text.Font = UI.Config.Font
    data.TextSize = 10
    
    espObjects[player] = data
    return data
end

RunService.Heartbeat:Connect(function()
    crosshair.Visible = Visuals.Crosshair
    crosshair.Position = UserInputService:GetMouseLocation()
    crosshair.BackgroundColor3 = UI.Config.AccentColor

    if Visuals.Zoom ~= defaultFOV then
        Camera.FieldOfView = Visuals.Zoom
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local data = espObjects[p] or createESP(p)
            local root = p.Character.HumanoidRootPart
            local dist = (Camera.CFrame.Position - root.Position).Magnitude
            local inRange = dist <= Visuals.MaxDist
            
            data.Highlight.Enabled = inRange and (Visuals.Boxes or Visuals.Chams or Visuals.RainbowChams)
            data.Highlight.FillTransparency = (Visuals.Chams or Visuals.RainbowChams) and 0.5 or 1
            data.Highlight.OutlineTransparency = Visuals.Boxes and 0 or 1
            
            if Visuals.RainbowChams then
                data.Highlight.FillColor = Color3.fromHSV((tick() * 0.5) % 1, 1, 1)
            else
                data.Highlight.FillColor = Visuals.Chams and Color3.fromRGB(255, 0, 100) or Color3.new(1,1,1)
            end
            
            data.Billboard.Adornee = root
            data.Billboard.Enabled = inRange and (Visuals.Names or Visuals.Health or Visuals.Distance)
            
            local text = ""
            if Visuals.Names then text = text .. p.Name .. "\n" end
            if Visuals.Health then text = text .. math.floor(p.Character.Humanoid.Health) .. " HP\n" end
            if Visuals.Distance then text = text .. math.floor(dist) .. "m" end
            data.Text.Text = text
        else
            if espObjects[p] then
                espObjects[p].Highlight.Enabled = false
                espObjects[p].Billboard.Enabled = false
            end
        end
    end
end)

-- [[ INITIALIZATION ]]
function Visuals.Init()
    local page = UI:CreatePage("Visuals")
    
    local esp = UI:AddFeatureTile("Visuals", "Main ESP", false, function(s) Visuals.Boxes = s Visuals.Names = s end)
    esp:AddToggle("Show Boxes", false, function(s) Visuals.Boxes = s end)
    esp:AddToggle("Show Names", false, function(s) Visuals.Names = s end)
    esp:AddToggle("Show Health", false, function(s) Visuals.Health = s end)
    esp:AddKeybind("Shortcut")
    
    local adv = UI:AddFeatureTile("Visuals", "Advanced", false, function(s) Visuals.Chams = s end)
    adv:AddToggle("Chams", false, function(s) Visuals.Chams = s end)
    adv:AddToggle("Rainbow Chams", false, function(s) Visuals.RainbowChams = s end)
    adv:AddSlider("Zoom / FOV", 30, 120, 70, function(v) Visuals.Zoom = v end)
    adv:AddKeybind("Shortcut")
    
    local extras = UI:AddFeatureTile("Visuals", "Extras", false, function(s) Visuals.Crosshair = s end)
    extras:AddToggle("Crosshair", false, function(s) Visuals.Crosshair = s end)
    extras:AddSlider("Max Distance", 100, 5000, 1000, function(v) Visuals.MaxDist = v end)
    extras:AddKeybind("Shortcut")
end

Visuals.Init()
return Visuals
