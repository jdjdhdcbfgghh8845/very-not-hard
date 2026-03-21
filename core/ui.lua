-- [[ NEXUS CORE - UI ENGINE (AURA / FLUX DESIGN) ]]
-- A premium, high-end interface focusing on glassmorphism and smooth animations.

local UI = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- [[ CONFIGURATION & THEME ]]
UI.Config = {
    WindowSize = UDim2.new(0, 700, 0, 450),
    AccentColor = Color3.fromRGB(0, 180, 255),
    BgColor = Color3.fromRGB(10, 10, 10),
    SidebarWidth = 65,
    AnimSpeed = 0.3
}

UI.Pages = {}
UI.Refs = {} -- Dedicated table for instance references
UI.CurrentPage = nil
UI.IsVisible = true

-- [[ UTILS - BLUR ]]
local function createBlur()
    local blur = game:GetService("Lighting"):FindFirstChild("NexusBlur") or Instance.new("BlurEffect")
    blur.Name = "NexusBlur"
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    return blur
end

local GlobalBlur = createBlur()

-- [[ UI INITIALIZATION ]]
function UI.Init()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "Nexus_Elite"
    MainGui.IgnoreGuiInset = true
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UI.Refs.MainGui = MainGui
    
    -- Main Container (Outer Glow)
    local GlowFrame = Instance.new("ImageLabel")
    GlowFrame.Name = "GlowFrame"
    GlowFrame.Size = UI.Config.WindowSize + UDim2.new(0, 50, 0, 50)
    GlowFrame.Position = UDim2.new(0.5, -375, 0.5, -225 + 1000) -- Offset for init
    GlowFrame.BackgroundTransparency = 1
    GlowFrame.Image = "rbxassetid://6014264734"
    GlowFrame.ImageColor3 = UI.Config.AccentColor
    GlowFrame.ImageTransparency = 1
    GlowFrame.Parent = MainGui
    UI.Refs.GlowFrame = GlowFrame
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UI.Config.WindowSize
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225 + 1000)
    MainFrame.BackgroundColor3 = UI.Config.BgColor
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGui
    UI.Refs.MainFrame = MainFrame
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
    
    -- [[ TOP HEADER ]]
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Header.BackgroundTransparency = 0.4
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, 0)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeaderLine.BackgroundTransparency = 0.9
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "NEXUS"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 100, 1, 0)
    VersionLabel.Position = UDim2.new(0, 95, 0, 2)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "[ V" .. _G.Nexus.Version .. " ]"
    VersionLabel.TextColor3 = UI.Config.AccentColor
    VersionLabel.Font = Enum.Font.GothamBold
    VersionLabel.TextSize = 10
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = Header
    
    -- [[ MASTERPIECE TELEMETRY ]]
    local Telemetry = Instance.new("Frame")
    Telemetry.Name = "Telemetry"
    Telemetry.Size = UDim2.new(0, 200, 1, 0)
    Telemetry.Position = UDim2.new(1, -210, 0, 0)
    Telemetry.BackgroundTransparency = 1
    Telemetry.Parent = Header
    
    local FPSLabel = Instance.new("TextLabel")
    FPSLabel.Size = UDim2.new(0.5, 0, 1, 0)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Text = "60 FPS"
    FPSLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    FPSLabel.Font = Enum.Font.GothamMedium
    FPSLabel.TextSize = 10
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
    FPSLabel.Parent = Telemetry
    
    local PingLabel = Instance.new("TextLabel")
    PingLabel.Size = UDim2.new(0.5, 0, 1, 0)
    PingLabel.Position = UDim2.new(0.5, 0, 0, 0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "20 MS"
    PingLabel.TextColor3 = UI.Config.AccentColor
    PingLabel.Font = Enum.Font.GothamMedium
    PingLabel.TextSize = 10
    PingLabel.TextXAlignment = Enum.TextXAlignment.Right
    PingLabel.Parent = Telemetry
    
    task.spawn(function()
        local lastTime = tick()
        local frameCount = 0
        while true do
            frameCount = frameCount + 1
            if tick() - lastTime >= 1 then
                FPSLabel.Text = frameCount .. " FPS"
                frameCount = 0
                lastTime = tick()
                pcall(function()
                    PingLabel.Text = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():split("(")[1] .. "MS"
                end)
            end
            task.wait()
        end
    end)
    
    -- [[ PLAYER AVATAR ]]
    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(0, 28, 0, 28)
    AvatarImg.Position = UDim2.new(0, -40, 0.5, -14)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    AvatarImg.Parent = Telemetry
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
    
    -- [[ ATMOSPHERIC PARTICLES ]]
    local ParticleCont = Instance.new("Frame")
    ParticleCont.Size = UDim2.new(1, 0, 1, 0)
    ParticleCont.BackgroundTransparency = 1
    ParticleCont.ZIndex = 0
    ParticleCont.Parent = MainFrame
    
    task.spawn(function()
        for i = 1, 25 do
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, 1, 0, 1)
            p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            p.BackgroundTransparency = 0.8
            p.BorderSizePixel = 0
            p.Parent = ParticleCont
            
            local function move()
                p.Position = UDim2.new(math.random(), 0, math.random(), 0)
                local t = TweenService:Create(p, TweenInfo.new(math.random(10, 20), Enum.EasingStyle.Linear), {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    BackgroundTransparency = math.random(5, 9) / 10
                })
                t:Play()
                t.Completed:Wait()
                move()
            end
            task.spawn(move)
        end
    end)
    
    -- [[ LIGHT SWEEP EFFECT ]]
    local Sweep = Instance.new("Frame")
    Sweep.Name = "Sweep"
    Sweep.Size = UDim2.new(0.4, 0, 3, 0)
    Sweep.Position = UDim2.new(-1.5, 0, -1, 0)
    Sweep.BackgroundTransparency = 0.92
    Sweep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Sweep.Rotation = 35
    Sweep.ZIndex = 5
    Sweep.Parent = MainFrame
    
    Instance.new("UIGradient", Sweep).Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(1, 1)
    })
    
    task.spawn(function()
        while true do
            Sweep.Position = UDim2.new(-1.5, 0, -0.5, 0)
            local t = TweenService:Create(Sweep, TweenInfo.new(4, Enum.EasingStyle.Linear), {Position = UDim2.new(2, 0, -0.5, 0)})
            t:Play()
            t.Completed:Wait()
            task.wait(2)
        end
    end)
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.8
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    
    -- Sub-containers
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, UI.Config.SidebarWidth, 1, -45)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Sidebar.BackgroundTransparency = 0.7
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    UI.Refs.Sidebar = Sidebar
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -UI.Config.SidebarWidth, 1, -45)
    ContentArea.Position = UDim2.new(0, UI.Config.SidebarWidth, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    UI.Refs.ContentArea = ContentArea
    
    -- Overlay for settings (Context Menu)
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(0, 280, 1, 0) -- Fixed width for precision
    Overlay.Position = UDim2.new(1, 0, 0, 0) -- Hidden
    Overlay.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Overlay.BackgroundTransparency = 0.05 -- Very sharp glass
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = MainFrame
    UI.Refs.Overlay = Overlay
    
    local OverlayLine = Instance.new("Frame")
    OverlayLine.Size = UDim2.new(0, 1, 1, 0)
    OverlayLine.BackgroundColor3 = UI.Config.AccentColor
    OverlayLine.BackgroundTransparency = 0.5
    OverlayLine.BorderSizePixel = 0
    OverlayLine.Parent = Overlay
    
    local OverlayHeader = Instance.new("Frame")
    OverlayHeader.Size = UDim2.new(1, 0, 0, 45)
    OverlayHeader.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OverlayHeader.BackgroundTransparency = 0.4
    OverlayHeader.Parent = Overlay
    
    local OverlayTitle = Instance.new("TextLabel")
    OverlayTitle.Name = "OverlayTitle"
    OverlayTitle.Size = UDim2.new(1, -60, 1, 0)
    OverlayTitle.Position = UDim2.new(0, 20, 0, 0)
    OverlayTitle.BackgroundTransparency = 1
    OverlayTitle.Text = "SETTINGS"
    OverlayTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    OverlayTitle.Font = Enum.Font.GothamBlack
    OverlayTitle.TextSize = 13
    OverlayTitle.TextXAlignment = Enum.TextXAlignment.Left
    OverlayTitle.Parent = OverlayHeader
    UI.Refs.OverlayTitle = OverlayTitle
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.Parent = OverlayHeader
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(UI.Refs.Overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
    end)
    
    -- Dragging Support
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            MainFrame.Position = newPos
            GlowFrame.Position = newPos + UDim2.new(0, -25, 0, -25)
        end
    end)
    
    -- Protection
    if getgenv then getgenv().Nexus_UI = MainGui end
    MainGui.Parent = CoreGui
    UI:Toggle() -- Show by default
    
    print("[NEXUS] 💎 UI Vitreous Engine successfully loaded!")
end

-- [[ TOGGLE UI ]]
function UI:Toggle()
    UI.IsVisible = not UI.IsVisible
    
    local targetPos = UI.IsVisible and UDim2.new(0.5, -350, 0.5, -225) or UDim2.new(0.5, -350, 1.5, 0)
    local targetBlur = UI.IsVisible and 15 or 0
    
    TweenService:Create(UI.Refs.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    TweenService:Create(UI.Refs.GlowFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos + UDim2.new(0, -25, 0, -25), ImageTransparency = UI.IsVisible and 0.3 or 1}):Play()
    TweenService:Create(GlobalBlur, TweenInfo.new(0.5), {Size = targetBlur}):Play()
    
    if UI.IsVisible then UI.Refs.MainGui.Enabled = true
    else task.delay(0.5, function() if not UI.IsVisible then UI.Refs.MainGui.Enabled = false end end) end
end

-- [[ NAVIGATION API ]]
function UI:SwitchPage(name)
    if UI.CurrentPage then UI.Pages[UI.CurrentPage].Container.Visible = false end
    UI.CurrentPage = name
    UI.Pages[name].Container.Visible = true
end

function UI:CreatePage(name, icon)
    local page = {
        Container = Instance.new("ScrollingFrame")
    }
    page.Container.Name = name .. "Page"
    page.Container.Size = UDim2.new(1, -20, 1, -20)
    page.Container.Position = UDim2.new(0, 10, 0, 10)
    page.Container.BackgroundTransparency = 1
    page.Container.BorderSizePixel = 0
    page.Container.ScrollBarThickness = 0
    page.Container.Visible = false
    page.Container.Parent = UI.Refs.ContentArea
    
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0, 172, 0, 115) -- Denser layout
    layout.CellPadding = UDim2.new(0, 12, 0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page.Container
    
    UI.Pages[name] = page
    
    -- [[ SIDEBAR BUTTON ]]
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Size = UDim2.new(0, 38, 0, 38)
    btn.Position = UDim2.new(0.5, -19, 0, 20 + (UI:GetPageCount() * 50))
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BackgroundTransparency = 0.5
    btn.Text = ""
    btn.Parent = UI.Refs.Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.9
    btnStroke.Parent = btn
    
    local btnIco = Instance.new("ImageLabel")
    btnIco.Name = "ImageLabel"
    btnIco.Size = UDim2.new(0, 20, 0, 20)
    btnIco.Position = UDim2.new(0.5, -10, 0.5, -10)
    btnIco.Image = icon or ""
    btnIco.BackgroundTransparency = 1
    btnIco.ImageColor3 = Color3.fromRGB(120, 120, 120)
    btnIco.Parent = btn
    
    local btnIndicator = Instance.new("Frame")
    btnIndicator.Name = "Frame"
    btnIndicator.Size = UDim2.new(0, 2, 0, 0)
    btnIndicator.Position = UDim2.new(1, 8, 0.5, 0)
    btnIndicator.BackgroundColor3 = UI.Config.AccentColor
    btnIndicator.BorderSizePixel = 0
    btnIndicator.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        UI:SwitchPage(name)
        for _, otherBtn in pairs(UI.Refs.Sidebar:GetChildren()) do
            if otherBtn:IsA("TextButton") then
                TweenService:Create(otherBtn.ImageLabel, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(120, 120, 120)}):Play()
                TweenService:Create(otherBtn.Frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 2, 0, 0), Position = UDim2.new(1, 8, 0.5, 0)}):Play()
                TweenService:Create(otherBtn.UIStroke, TweenInfo.new(0.3), {Transparency = 0.9}):Play()
            end
        end
        TweenService:Create(btnIco, TweenInfo.new(0.3), {ImageColor3 = UI.Config.AccentColor}):Play()
        TweenService:Create(btnIndicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 2, 0, 16), Position = UDim2.new(1, 8, 0.5, -8)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.3), {Transparency = 0.6}):Play()
    end)
    
    -- [[ FEATURE TILE API ]]
    function page:AddFeatureTile(title, f_icon, default, f_callback)
        local tile = Instance.new("Frame")
        tile.Name = title .. "Tile"
        tile.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tile.BackgroundTransparency = 0.5
        tile.Parent = page.Container
        
        local t_corner = Instance.new("UICorner")
        t_corner.CornerRadius = UDim.new(0, 12)
        t_corner.Parent = tile
        
        local t_gradient = Instance.new("UIGradient")
        t_gradient.Rotation = 90
        t_gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
        })
        t_gradient.Parent = tile
        
        local t_stroke = Instance.new("UIStroke")
        t_stroke.Color = default and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255)
        t_stroke.Thickness = 1.2
        t_stroke.Transparency = default and 0.4 or 0.8
        t_stroke.Parent = tile
        
        local t_btn = Instance.new("TextButton")
        t_btn.Size = UDim2.new(1, 0, 1, 0)
        t_btn.BackgroundTransparency = 1
        t_btn.Text = ""
        t_btn.Parent = tile
        
        -- Icon Glow
        local t_glow = Instance.new("ImageLabel")
        t_glow.Size = UDim2.new(0, 60, 0, 60)
        t_glow.Position = UDim2.new(0.5, -30, 0.15, -15)
        t_glow.Image = "rbxassetid://6014264734"
        t_glow.ImageColor3 = default and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255)
        t_glow.ImageTransparency = 0.85
        t_glow.BackgroundTransparency = 1
        t_glow.Parent = tile
        
        local t_ico = Instance.new("ImageLabel")
        t_ico.Size = UDim2.new(0, 30, 0, 30)
        t_ico.Position = UDim2.new(0.5, -15, 0.15, 0)
        t_ico.Image = f_icon or ""
        t_ico.BackgroundTransparency = 1
        t_ico.ImageColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
        t_ico.Parent = tile
        
        local t_label = Instance.new("TextLabel")
        t_label.Size = UDim2.new(1, 0, 0, 20)
        t_label.Position = UDim2.new(0, 0, 0.55, 0)
        t_label.BackgroundTransparency = 1
        t_label.Text = title:upper()
        t_label.TextColor3 = Color3.fromRGB(255, 255, 255)
        t_label.Font = Enum.Font.GothamBlack
        t_label.TextSize = 10
        t_label.Parent = tile
        
        local t_status = Instance.new("TextLabel")
        t_status.Size = UDim2.new(1, 0, 0, 15)
        t_status.Position = UDim2.new(0, 0, 0.72, 0)
        t_status.BackgroundTransparency = 1
        t_status.Text = default and "ACTIVE" or "OFF"
        t_status.TextColor3 = default and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)
        t_status.Font = Enum.Font.GothamBold
        t_status.TextSize = 9
        t_status.Parent = tile
        
        local f_state = default
        
        t_btn.MouseEnter:Connect(function()
            TweenService:Create(tile, TweenInfo.new(0.2), {BackgroundTransparency = 0.35}):Play()
            TweenService:Create(t_stroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
            TweenService:Create(t_glow, TweenInfo.new(0.2), {ImageTransparency = 0.6}):Play()
        end)
        t_btn.MouseLeave:Connect(function()
            TweenService:Create(tile, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            TweenService:Create(t_stroke, TweenInfo.new(0.2), {Transparency = f_state and 0.4 or 0.8}):Play()
            TweenService:Create(t_glow, TweenInfo.new(0.2), {ImageTransparency = 0.85}):Play()
        end)
        
        t_btn.MouseButton1Click:Connect(function()
            f_state = not f_state
            TweenService:Create(t_stroke, TweenInfo.new(0.2), {Color = f_state and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255), Transparency = 0.4}):Play()
            TweenService:Create(t_ico, TweenInfo.new(0.2), {ImageColor3 = f_state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)}):Play()
            TweenService:Create(t_glow, TweenInfo.new(0.2), {ImageColor3 = f_state and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255)}):Play()
            t_status.Text = f_state and "ACTIVE" or "OFF"
            TweenService:Create(t_status, TweenInfo.new(0.2), {TextColor3 = f_state and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)}):Play()
            pcall(function() f_callback(f_state) end)
        end)
        
        -- [[ SETTINGS OVERLAY LOGIC ]]
        local settingsContainer = Instance.new("ScrollingFrame")
        settingsContainer.Name = title .. "Settings"
        settingsContainer.Size = UDim2.new(1, -30, 1, -80)
        settingsContainer.Position = UDim2.new(0, 15, 0, 65)
        settingsContainer.BackgroundTransparency = 1
        settingsContainer.BorderSizePixel = 0
        settingsContainer.Visible = false
        settingsContainer.Parent = UI.Refs.Overlay
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 12)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = settingsContainer
        
        t_btn.MouseButton2Click:Connect(function()
            for _, child in pairs(UI.Refs.Overlay:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            settingsContainer.Visible = true
            UI.Refs.OverlayTitle.Text = title:upper()
            TweenService:Create(UI.Refs.Overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.6, 0, 0, 0)}):Play()
        end)
        
        local settingsAPI = {}
        
        function settingsAPI:AddToggle(s_title, s_default, s_callback)
            local s_frame = Instance.new("Frame")
            s_frame.Size = UDim2.new(1, 0, 0, 35)
            s_frame.BackgroundTransparency = 1
            s_frame.Parent = settingsContainer
            
            local s_label = Instance.new("TextLabel")
            s_label.Size = UDim2.new(0.7, 0, 1, 0)
            s_label.BackgroundTransparency = 1
            s_label.Text = s_title
            s_label.TextColor3 = Color3.fromRGB(180, 180, 180)
            s_label.Font = Enum.Font.Gotham
            s_label.TextSize = 12
            s_label.TextXAlignment = Enum.TextXAlignment.Left
            s_label.Parent = s_frame
            
            local s_btn = Instance.new("TextButton")
            s_btn.Size = UDim2.new(0, 36, 0, 18)
            s_btn.Position = UDim2.new(1, -36, 0.5, -9)
            s_btn.BackgroundColor3 = s_default and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)
            s_btn.Text = ""
            s_btn.Parent = s_frame
            Instance.new("UICorner", s_btn).CornerRadius = UDim.new(1, 0)
            
            local s_circle = Instance.new("Frame")
            s_circle.Size = UDim2.new(0, 14, 0, 14)
            s_circle.Position = s_default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            s_circle.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            s_circle.Parent = s_btn
            Instance.new("UICorner", s_circle).CornerRadius = UDim.new(1, 0)
            
            local s_state = s_default
            s_btn.MouseButton1Click:Connect(function()
                s_state = not s_state
                TweenService:Create(s_btn, TweenInfo.new(0.2), {BackgroundColor3 = s_state and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(s_circle, TweenInfo.new(0.2), {Position = s_state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                pcall(function() s_callback(s_state) end)
            end)
        end
        
        function settingsAPI:AddSlider(sl_title, min, max, sl_default, sl_callback)
            local sl_frame = Instance.new("Frame")
            sl_frame.Size = UDim2.new(1, 0, 0, 45)
            sl_frame.BackgroundTransparency = 1
            sl_frame.Parent = settingsContainer
            
            local sl_label = Instance.new("TextLabel")
            sl_label.Size = UDim2.new(0.7, 0, 0, 20)
            sl_label.BackgroundTransparency = 1
            sl_label.Text = sl_title
            sl_label.TextColor3 = Color3.fromRGB(180, 180, 180)
            sl_label.Font = Enum.Font.Gotham
            sl_label.TextSize = 11
            sl_label.TextXAlignment = Enum.TextXAlignment.Left
            sl_label.Parent = sl_frame
            
            local sl_val = Instance.new("TextLabel")
            sl_val.Size = UDim2.new(0.3, 0, 0, 20)
            sl_val.Position = UDim2.new(0.7, 0, 0, 0)
            sl_val.BackgroundTransparency = 1
            sl_val.Text = tostring(sl_default)
            sl_val.TextColor3 = UI.Config.AccentColor
            sl_val.Font = Enum.Font.GothamBold
            sl_val.TextSize = 11
            sl_val.TextXAlignment = Enum.TextXAlignment.Right
            sl_val.Parent = sl_frame
            
            local sl_bar = Instance.new("Frame")
            sl_bar.Size = UDim2.new(1, 0, 0, 4)
            sl_bar.Position = UDim2.new(0, 0, 0, 30)
            sl_bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sl_bar.BorderSizePixel = 0
            sl_bar.Parent = sl_frame
            Instance.new("UICorner", sl_bar).CornerRadius = UDim.new(1, 0)
            
            local sl_fill = Instance.new("Frame")
            local startPercent = (sl_default - min) / (max - min)
            sl_fill.Size = UDim2.new(startPercent, 0, 1, 0)
            sl_fill.BackgroundColor3 = UI.Config.AccentColor
            sl_fill.BorderSizePixel = 0
            sl_fill.Parent = sl_bar
            Instance.new("UICorner", sl_fill).CornerRadius = UDim.new(1, 0)
            
            local sliding = false
            local function update(input)
                local pos = math.clamp((input.Position.X - sl_bar.AbsolutePosition.X) / sl_bar.AbsoluteSize.X, 0, 1)
                sl_fill.Size = UDim2.new(pos, 0, 1, 0)
                local value = math.floor(min + (max - min) * pos)
                if max <= 1 then value = math.round((min + (max - min) * pos) * 100) / 100 end
                sl_val.Text = tostring(value)
                pcall(function() sl_callback(value) end)
            end
            sl_bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true update(input) end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
        end
        return settingsAPI
    end
    
    -- Initialize first page
    if UI:GetPageCount() == 1 then
        UI:SwitchPage(name)
        TweenService:Create(btnIco, TweenInfo.new(0.3), {ImageColor3 = UI.Config.AccentColor}):Play()
        TweenService:Create(btnIndicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 2, 0, 20), Position = UDim2.new(1, 8, 0.5, -10)}):Play()
    end
    
    return page
end

-- [[ HELPER: PAGE COUNT ]]
function UI:GetPageCount()
    local count = 0
    for _ in pairs(UI.Pages) do count = count + 1 end
    return count
end

-- [[ KEYBIND LISTENER ]]
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        UI:Toggle()
    end
end)

return UI
