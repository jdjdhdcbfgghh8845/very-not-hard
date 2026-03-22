-- [[ AAC MODULE - VISUALS ]]
local UI = _G.AAC.Core.UI
local Visuals = {
    ESPActive = false,
    ShowBoxes = true,
    ShowNames = true,
    MaxDist = 1000,
    TeamCheck = true
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local ESP_Elements = {}

local function createESP(player)
    local elements = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text")
    }
    
    elements.Box.Thickness = 1
    elements.Box.Filled = false
    elements.Box.Color = UI.Config.AccentColor
    
    elements.Name.Size = 14
    elements.Name.Center = true
    elements.Name.Outline = true
    elements.Name.Color = Color3.fromRGB(255, 255, 255)
    
    ESP_Elements[player] = elements
end

local function removeESP(player)
    if ESP_Elements[player] then
        ESP_Elements[player].Box:Remove()
        ESP_Elements[player].Name:Remove()
        ESP_Elements[player] = nil
    end
end

Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESP_Elements[player] then createESP(player) end
            
            local char = player.Character
            local hrp = char.HumanoidRootPart
            local head = char:FindFirstChild("Head")
            
            local elements = ESP_Elements[player]
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            
            local isTeammate = (player.Team == LocalPlayer.Team and player.Team ~= nil)
            
            if onScreen and Visuals.ESPActive and dist < Visuals.MaxDist and (not Visuals.TeamCheck or not isTeammate) then
                -- Calculate Box size
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 1.5
                
                elements.Box.Size = Vector2.new(width, height)
                elements.Box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
                elements.Box.Visible = Visuals.ShowBoxes
                
                elements.Name.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 15)
                elements.Name.Text = string.format("%s [%d]", player.Name, math.floor(dist))
                elements.Name.Visible = Visuals.ShowNames
            else
                elements.Box.Visible = false
                elements.Name.Visible = false
            end
        elseif ESP_Elements[player] then
            ESP_Elements[player].Box.Visible = false
            ESP_Elements[player].Name.Visible = false
        end
    end
end)

function Visuals.Init()
    local page = UI:CreatePage("Visuals")
    
    local esp = UI:AddFeatureTile("Visuals", "Player ESP", false, function(state)
        Visuals.ESPActive = state
    end)
    esp:AddToggle("Boxes", true, function(s) Visuals.ShowBoxes = s end)
    esp:AddToggle("Names", true, function(s) Visuals.ShowNames = s end)
    esp:AddToggle("Team Check", true, function(s) Visuals.TeamCheck = s end)
    esp:AddSlider("Max Dist", 100, 5000, 1000, function(v) Visuals.MaxDist = v end)
    
    local test = UI:AddFeatureTile("Visuals", "Test Button", false, function(state) print("Visuals Test Clicked!") end)
end

Visuals.Init()
return Visuals
