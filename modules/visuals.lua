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
local drawingCache = {Skeletons = {}, Tracers = {}}
local crosshair = Instance.new("Frame", UI.Refs.MainGui)
crosshair.Size = UDim2.new(0, 4, 0, 4)
crosshair.BackgroundColor3 = Color3.new(1, 0, 0)
crosshair.BorderSizePixel = 0
crosshair.Visible = false
Instance.new("UICorner", crosshair).CornerRadius = UDim.new(1, 0)

-- [[ DRAWING UTILS ]]
local function createLine()
    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Color = UI.Config.AccentColor
    line.Transparency = 1
    line.Visible = false
    return line
end

local function getSkeleton(player)
    if drawingCache.Skeletons[player] then return drawingCache.Skeletons[player] end
    local skel = {
        HToT = createLine(), -- Head to Torso
        TToLA = createLine(), -- Torso to Left Arm
        TToRA = createLine(), -- Torso to Right Arm
        TToLL = createLine(), -- Torso to Left Leg
        TToRL = createLine()  -- Torso to Right Leg
    }
    drawingCache.Skeletons[player] = skel
    return skel
end

local function getTracer(player)
    if drawingCache.Tracers[player] then return drawingCache.Tracers[player] end
    local tracer = createLine()
    drawingCache.Tracers[player] = tracer
    return tracer
end

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
    local m = UserInputService:GetMouseLocation()
    crosshair.Position = UDim2.new(0, m.X, 0, m.Y)
    crosshair.BackgroundColor3 = UI.Config.AccentColor

    if Visuals.Zoom ~= defaultFOV then
        Camera.FieldOfView = Visuals.Zoom
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local data = espObjects[p] or createESP(p)
            local root = char.HumanoidRootPart
            local dist = (Camera.CFrame.Position - root.Position).Magnitude
            local inRange = dist <= Visuals.MaxDist
            local onScreen, pos = Camera:WorldToViewportPoint(root.Position)
            
            -- Basic ESP
            data.Highlight.Enabled = inRange and (Visuals.Boxes or Visuals.Chams or Visuals.RainbowChams)
            data.Highlight.FillTransparency = (Visuals.Chams or Visuals.RainbowChams) and 0.5 or 1
            data.Highlight.OutlineTransparency = Visuals.Boxes and 0 or 1
            data.Highlight.FillColor = Visuals.RainbowChams and Color3.fromHSV((tick() * 0.5) % 1, 1, 1) or UI.Config.AccentColor
            
            data.Billboard.Adornee = root
            data.Billboard.Enabled = inRange and (Visuals.Names or Visuals.Health or Visuals.Distance)
            
            local text = ""
            if Visuals.Names then text = text .. p.Name .. "\n" end
            if Visuals.Health then text = text .. math.floor(char.Humanoid.Health) .. " HP\n" end
            if Visuals.Distance then text = text .. math.floor(dist) .. "m" end
            data.Text.Text = text

            -- Skeleton ESP
            local skel = getSkeleton(p)
            if Visuals.Skeleton and inRange and onScreen then
                local head = char:FindFirstChild("Head")
                local la = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
                local ra = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
                local ll = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
                local rl = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
                
                if head then
                    local hPos = Camera:WorldToViewportPoint(head.Position)
                    local rPos = Camera:WorldToViewportPoint(root.Position)
                    skel.HToT.From = Vector2.new(hPos.X, hPos.Y)
                    skel.HToT.To = Vector2.new(rPos.X, rPos.Y)
                    skel.HToT.Visible = true
                else skel.HToT.Visible = false end
            else
                for _, l in pairs(skel) do l.Visible = false end
            end

            -- Tracers ESP
            local tracer = getTracer(p)
            if Visuals.Tracers and inRange and onScreen then
                tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(pos.X, pos.Y)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        else
            if espObjects[p] then
                espObjects[p].Highlight.Enabled = false
                espObjects[p].Billboard.Enabled = false
            end
            if drawingCache.Skeletons[p] then for _, l in pairs(drawingCache.Skeletons[p]) do l.Visible = false end end
            if drawingCache.Tracers[p] then drawingCache.Tracers[p].Visible = false end
        end
    end

    -- ESP Cleanup
    for p, data in pairs(espObjects) do
        if not p.Parent or not p.Character then
            pcall(function() data.Highlight:Destroy() end)
            pcall(function() data.Billboard:Destroy() end)
            espObjects[p] = nil
            if drawingCache.Skeletons[p] then for _, l in pairs(drawingCache.Skeletons[p]) do l:Remove() end drawingCache.Skeletons[p] = nil end
            if drawingCache.Tracers[p] then drawingCache.Tracers[p]:Remove() drawingCache.Tracers[p] = nil end
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
    adv:AddToggle("Skeletons", false, function(s) Visuals.Skeleton = s end)
    adv:AddToggle("Tracers", false, function(s) Visuals.Tracers = s end)
    adv:AddSlider("Zoom / FOV", 30, 120, 70, function(v) Visuals.Zoom = v end)
    adv:AddKeybind("Shortcut")
    
    local extras = UI:AddFeatureTile("Visuals", "Extras", false, function(s) Visuals.Crosshair = s end)
    extras:AddToggle("Crosshair", false, function(s) Visuals.Crosshair = s end)
    extras:AddSlider("Max Distance", 100, 5000, 1000, function(v) Visuals.MaxDist = v end)
    extras:AddKeybind("Shortcut")
end

Visuals.Init()
return Visuals
