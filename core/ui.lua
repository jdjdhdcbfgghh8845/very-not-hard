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
UI.IsVisible = false

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
    
    -- [[ HYPER-MASTERPIECE LAYERS ]]
    local GridOverlay = Instance.new("ImageLabel")
    GridOverlay.Name = "GridOverlay"
    GridOverlay.Size = UDim2.new(1.5, 0, 1.5, 0)
    GridOverlay.Position = UDim2.new(-0.25, 0, -0.25, 0)
    GridOverlay.BackgroundTransparency = 1
    GridOverlay.Image = "rbxassetid://13247341381"
    GridOverlay.ImageTransparency = 0.98
    GridOverlay.ZIndex = 0
    GridOverlay.Parent = MainFrame
    
    local NoiseOverlay = Instance.new("ImageLabel")
    NoiseOverlay.Name = "NoiseOverlay"
    NoiseOverlay.Size = UDim2.new(1, 0, 1, 0)
    NoiseOverlay.BackgroundTransparency = 1
    NoiseOverlay.Image = "rbxassetid://16124707185"
    NoiseOverlay.ImageTransparency = 0.98
    NoiseOverlay.ZIndex = 1
    NoiseOverlay.Parent = MainFrame
    
    -- Optimized Parallax
    local targetDX, targetDY = 0, 0
    game:GetService("RunService").Heartbeat:Connect(function()
        if not UI.IsVisible or not UI.ParallaxEnabled then return end
        local mPos = UserInputService:GetMouseLocation()
        local screen = workspace.CurrentCamera.ViewportSize
        targetDX = (mPos.X - screen.X/2) / 60
        targetDY = (mPos.Y - screen.Y/2) / 60
        NoiseOverlay.Position = NoiseOverlay.Position:Lerp(UDim2.new(0, targetDX, 0, targetDY), 0.1)
        GridOverlay.Position = GridOverlay.Position:Lerp(UDim2.new(-0.25, targetDX * 1.5, -0.25, targetDY * 1.5), 0.1)
    end)
    
    -- [[ TOP HEADER ]]
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Header.BackgroundTransparency = 0.4
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local Telemetry = Instance.new("Frame")
    Telemetry.Name = "Telemetry"
    Telemetry.Size = UDim2.new(0, 200, 1, 0)
    Telemetry.Position = UDim2.new(1, -210, 0, 0)
    Telemetry.BackgroundTransparency = 1
    Telemetry.Parent = Header
    
    local SessionLabel = Instance.new("TextLabel")
    SessionLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    SessionLabel.Position = UDim2.new(0, -100, 0, 0)
    SessionLabel.BackgroundTransparency = 1
    SessionLabel.Text = "SESSION: 00:00:00"
    SessionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SessionLabel.Font = Enum.Font.GothamBold
    SessionLabel.TextSize = 8
    SessionLabel.TextXAlignment = Enum.TextXAlignment.Right
    SessionLabel.Parent = Telemetry
    
    local RAMLabel = Instance.new("TextLabel")
    RAMLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    RAMLabel.Position = UDim2.new(0, -100, 0.5, 0)
    RAMLabel.BackgroundTransparency = 1
    RAMLabel.Text = "RAM: 0 MB"
    RAMLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    RAMLabel.Font = Enum.Font.GothamBold
    RAMLabel.TextSize = 8
    RAMLabel.TextXAlignment = Enum.TextXAlignment.Right
    RAMLabel.Parent = Telemetry
    
    local startTime = tick()
    task.spawn(function()
        while true do
            local elapsed = tick() - startTime
            local h = math.floor(elapsed / 3600)
            local m = math.floor((elapsed % 3600) / 60)
            local s = math.floor(elapsed % 60)
            SessionLabel.Text = string.format("SESSION: %02d:%02d:%02d", h, m, s)
            pcall(function()
                local mem = game:GetService("Stats"):GetTotalMemoryUsageMb()
                RAMLabel.Text = string.format("RAM: %.1f MB", mem)
            end)
            task.wait(1)
        end
    end)
    
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeaderLine.BackgroundTransparency = 0.95
    HeaderLine.BorderSizePixel = 0
    HeaderLine.Parent = Header
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 14)
    HeaderCorner.Parent = Header
    
    local HeaderBlock = Instance.new("Frame")
    HeaderBlock.Size = UDim2.new(1, 0, 0, 10)
    HeaderBlock.Position = UDim2.new(0, 0, 1, -10)
    HeaderBlock.BackgroundColor3 = Header.BackgroundColor3
    HeaderBlock.BackgroundTransparency = Header.BackgroundTransparency
    HeaderBlock.BorderSizePixel = 0
    HeaderBlock.Parent = Header
    
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
    
    local SessionLabel = Instance.new("TextLabel")
    SessionLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    SessionLabel.Position = UDim2.new(0, -100, 0, 0)
    SessionLabel.BackgroundTransparency = 1
    SessionLabel.Text = "SESSION: 00:00:00"
    SessionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SessionLabel.Font = Enum.Font.GothamBold
    SessionLabel.TextSize = 8
    SessionLabel.TextXAlignment = Enum.TextXAlignment.Right
    SessionLabel.Parent = Telemetry
    
    local RAMLabel = Instance.new("TextLabel")
    RAMLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    RAMLabel.Position = UDim2.new(0, -100, 0.5, 0)
    RAMLabel.BackgroundTransparency = 1
    RAMLabel.Text = "RAM: 0 MB"
    RAMLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    RAMLabel.Font = Enum.Font.GothamBold
    RAMLabel.TextSize = 8
    RAMLabel.TextXAlignment = Enum.TextXAlignment.Right
    RAMLabel.Parent = Telemetry
    
    local startTime = tick()
    task.spawn(function()
        while true do
            local elapsed = tick() - startTime
            local h = math.floor(elapsed / 3600)
            local m = math.floor((elapsed % 3600) / 60)
            local s = math.floor(elapsed % 60)
            SessionLabel.Text = string.format("SESSION: %02d:%02d:%02d", h, m, s)
            
            pcall(function()
                local mem = game:GetService("Stats"):GetTotalMemoryUsageMb()
                RAMLabel.Text = string.format("RAM: %.1f MB", mem)
            end)
            task.wait(1)
        end
    end)
    
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
    AvatarImg.Size = UDim2.new(0, 30, 0, 30)
    AvatarImg.Position = UDim2.new(1, -250, 0.5, -15) -- Move outside telemetry text
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    AvatarImg.Parent = Header
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
    
    -- [[ ATMOSPHERIC PARTICLES ]]
    local ParticleCont = Instance.new("Frame")
    ParticleCont.Size = UDim2.new(1, 0, 1, 0)
    ParticleCont.BackgroundTransparency = 1
    ParticleCont.ZIndex = 0
    ParticleCont.Parent = MainFrame
    
    task.spawn(function()
        for i = 1, 15 do
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, 1, 0, 1)
            p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            p.BackgroundTransparency = 0.9
            p.BorderSizePixel = 0
            p.Parent = ParticleCont
            
            local function move()
                if not UI.IsVisible then task.wait(0.5) move() return end
                p.Position = UDim2.new(math.random(), 0, math.random(), 0)
                local t = TweenService:Create(p, TweenInfo.new(math.random(10, 20), Enum.EasingStyle.Linear), {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    BackgroundTransparency = math.random(7, 9) / 10
                })
                t:Play()
                t.Completed:Wait()
                move()
            end
            task.spawn(move)
            task.wait(0.1) -- Staggered spawn
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
    Sidebar.BackgroundTransparency = 0.4
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 2
    Sidebar.Parent = MainFrame
    UI.Refs.Sidebar = Sidebar
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 14)
    SidebarCorner.Parent = Sidebar
    
    local SidebarTopBlock = Instance.new("Frame")
    SidebarTopBlock.Size = UDim2.new(1, 0, 0, 15)
    SidebarTopBlock.BackgroundColor3 = Sidebar.BackgroundColor3
    SidebarTopBlock.BackgroundTransparency = Sidebar.BackgroundTransparency
    SidebarTopBlock.BorderSizePixel = 0
    SidebarTopBlock.ZIndex = Sidebar.ZIndex
    SidebarTopBlock.Parent = Sidebar
    
    local HamburgerBtn = Instance.new("TextButton")
    HamburgerBtn.Name = "Hamburger"
    HamburgerBtn.Size = UDim2.new(0, 30, 0, 30)
    HamburgerBtn.Position = UDim2.new(0, 17, 0, 10)
    HamburgerBtn.BackgroundTransparency = 1
    HamburgerBtn.Text = ""
    HamburgerBtn.Parent = Sidebar
    
    local function createBar(yOffset)
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, 18, 0, 2)
        bar.Position = UDim2.new(0.5, -9, 0.5, yOffset)
        bar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        bar.BorderSizePixel = 0
        bar.Parent = HamburgerBtn
        return bar
    end
    
    local bar1 = createBar(-5)
    local bar2 = createBar(0)
    local bar3 = createBar(5)
    
    HamburgerBtn.MouseEnter:Connect(function()
        TweenService:Create(bar1, TweenInfo.new(0.2), {BackgroundColor3 = UI.Config.AccentColor}):Play()
        TweenService:Create(bar2, TweenInfo.new(0.2), {BackgroundColor3 = UI.Config.AccentColor}):Play()
        TweenService:Create(bar3, TweenInfo.new(0.2), {BackgroundColor3 = UI.Config.AccentColor}):Play()
    end)
    HamburgerBtn.MouseLeave:Connect(function()
        TweenService:Create(bar1, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        TweenService:Create(bar2, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        TweenService:Create(bar3, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)
    
    UI.SidebarExpanded = false
    HamburgerBtn.MouseButton1Click:Connect(function()
        UI.SidebarExpanded = not UI.SidebarExpanded
        local targetWidth = UI.SidebarExpanded and 160 or UI.Config.SidebarWidth
        TweenService:Create(Sidebar, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, targetWidth, 1, -45)}):Play()
        TweenService:Create(UI.Refs.ContentArea, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, targetWidth, 0, 45),
            Size = UDim2.new(1, -targetWidth, 1, -45)
        }):Play()
        
        for _, child in pairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") and child.Name ~= "Hamburger" then
                local label = child:FindFirstChild("Label")
                if label then
                    TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = UI.SidebarExpanded and 0 or 1}):Play()
                end
            end
        end
    end)
    
    -- Settings Button at Sidebar Bottom
    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Name = "SettingsBtn"
    SettingsBtn.Size = UDim2.new(1, -20, 0, 38)
    SettingsBtn.Position = UDim2.new(0, 10, 1, -50)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SettingsBtn.BackgroundTransparency = 0.5
    SettingsBtn.Text = ""
    SettingsBtn.Parent = Sidebar
    
    Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 10)
    local s_stroke = Instance.new("UIStroke")
    s_stroke.Color = Color3.fromRGB(255, 255, 255)
    s_stroke.Thickness = 1
    s_stroke.Transparency = 0.9
    s_stroke.Parent = SettingsBtn
    
    local s_ico = Instance.new("ImageLabel")
    s_ico.Name = "Icon"
    s_ico.Size = UDim2.new(0, 20, 0, 20)
    s_ico.Position = UDim2.new(0, 11, 0.5, -10)
    s_ico.BackgroundTransparency = 1
    s_ico.Image = "rbxassetid://6031289524"
    s_ico.ImageColor3 = Color3.fromRGB(255, 255, 255)
    s_ico.ZIndex = 5
    s_ico.ScaleType = Enum.ScaleType.Fit
    s_ico.Parent = SettingsBtn
    
    local s_label = Instance.new("TextLabel")
    s_label.Name = "Label"
    s_label.Size = UDim2.new(1, -45, 1, 0)
    s_label.Position = UDim2.new(0, 35, 0, 0)
    s_label.BackgroundTransparency = 1
    s_label.Text = "SETTINGS"
    s_label.TextColor3 = Color3.fromRGB(255, 255, 255)
    s_label.Font = Enum.Font.GothamBold
    s_label.TextSize = 11
    s_label.TextXAlignment = Enum.TextXAlignment.Left
    s_label.TextTransparency = 1
    s_label.Parent = SettingsBtn
    
    SettingsBtn.MouseButton1Click:Connect(function()
        UI:SwitchPage("Settings")
    end)
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -UI.Config.SidebarWidth, 1, -45)
    ContentArea.Position = UDim2.new(0, UI.Config.SidebarWidth, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    UI.Refs.ContentArea = ContentArea
    
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(0, 280, 1, 0)
    Overlay.Position = UDim2.new(1, 0, 0, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Overlay.BackgroundTransparency = 0.05
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = MainFrame
    UI.Refs.Overlay = Overlay
    
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
    
    local TargetParent = CoreGui
    pcall(function() MainGui.Parent = TargetParent end)
    if MainGui.Parent ~= TargetParent then
        MainGui.Parent = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    end
    
    MainGui.DisplayOrder = 999
    MainGui.Enabled = true
    UI.IsVisible = true
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    GlowFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
    GlowFrame.ImageTransparency = 0.3
    GlobalBlur.Size = 15
    
    -- Settings Page
    local settingsPage = UI:CreatePage("Settings", "rbxassetid://7072714652", true)
    local uiSettings = settingsPage:AddFeatureTile("UI Config", "rbxassetid://10709771131", true, function(state) end)
    uiSettings:AddToggle("Blur Effect", true, function(s) GlobalBlur.Enabled = s end)
    uiSettings:AddToggle("Particles", true, function(s) ParticleCont.Visible = s end)
    uiSettings:AddToggle("Parallax", true, function(s) UI.ParallaxEnabled = s end)
    UI.ParallaxEnabled = true
    
    UI:SwitchPage("Combat")
    
    if getgenv then getgenv().Nexus_UI = MainGui end
    print("[NEXUS] 💎 UI Hyper-Masterpiece Engine ready!")
end

function UI:Toggle()
    UI.IsVisible = not UI.IsVisible
    local targetPos = UI.IsVisible and UDim2.new(0.5, -350, 0.5, -225) or UDim2.new(0.5, -350, 1.5, 0)
    local targetBlur = UI.IsVisible and 15 or 0
    local targetGlow = UI.IsVisible and 0.3 or 1
    TweenService:Create(UI.Refs.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    TweenService:Create(UI.Refs.GlowFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos + UDim2.new(0, -25, 0, -25), ImageTransparency = targetGlow}):Play()
    TweenService:Create(GlobalBlur, TweenInfo.new(0.5), {Size = targetBlur}):Play()
end

function UI:SwitchPage(name)
    if UI.CurrentPage == name then return end
    if UI.CurrentPage and UI.Pages[UI.CurrentPage] then UI.Pages[UI.CurrentPage].Container.Visible = false end
    UI.CurrentPage = name
    if UI.Pages[name] then UI.Pages[name].Container.Visible = true end
    
    for _, btn in pairs(UI.Refs.Sidebar:GetChildren()) do
        if btn:IsA("TextButton") and btn.Name ~= "Hamburger" then
            local isMatch = (btn.Name == name .. "Btn") or (name == "Settings" and btn.Name == "SettingsBtn")
            local icon = btn:FindFirstChild("Icon")
            local frame = btn:FindFirstChild("Frame")
            local stroke = btn:FindFirstChild("UIStroke")
            if icon then 
                TweenService:Create(icon, TweenInfo.new(0.3), {ImageColor3 = isMatch and UI.Config.AccentColor or Color3.fromRGB(180, 180, 180)}):Play() 
            end
            if frame then TweenService:Create(frame, TweenInfo.new(0.3), {Size = isMatch and UDim2.new(0, 2, 0, 16) or UDim2.new(0, 2, 0, 0), Position = isMatch and UDim2.new(0, -6, 0.5, -8) or UDim2.new(0, -6, 0.5, 0)}):Play() end
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = isMatch and 0.6 or 0.9}):Play() end
        end
    end
end

function UI:CreatePage(name, icon, hideSidebar)
    local page = {Container = Instance.new("ScrollingFrame")}
    page.Container.Name = name .. "Page"
    page.Container.Size = UDim2.new(1, -20, 1, -20)
    page.Container.Position = UDim2.new(0, 10, 0, 10)
    page.Container.BackgroundTransparency = 1
    page.Container.BorderSizePixel = 0
    page.Container.ScrollBarThickness = 0
    page.Container.Visible = false
    page.Container.Parent = UI.Refs.ContentArea
    
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0, 172, 0, 115)
    layout.CellPadding = UDim2.new(0, 12, 0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page.Container
    
    UI.Pages[name] = page
    
    if not hideSidebar then
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Btn"
        btn.Size = UDim2.new(1, -20, 0, 38)
        btn.Position = UDim2.new(0, 10, 0, 50 + (UI:GetPageCount() * 45))
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.BackgroundTransparency = 0.5
        btn.Text = ""
        btn.Parent = UI.Refs.Sidebar
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local bstroke = Instance.new("UIStroke")
        bstroke.Color = Color3.fromRGB(255, 255, 255)
        bstroke.Thickness = 1
        bstroke.Transparency = 0.9
        bstroke.Parent = btn
        
        local bico = Instance.new("ImageLabel")
        bico.Name = "Icon"
        bico.Size = UDim2.new(0, 20, 0, 20)
        bico.Position = UDim2.new(0, 11, 0.5, -10)
        bico.BackgroundTransparency = 1
        bico.Image = icon or ""
        bico.ImageColor3 = Color3.fromRGB(180, 180, 180)
        bico.ZIndex = 5
        bico.ScaleType = Enum.ScaleType.Fit
        bico.Parent = btn
        
        local blbl = Instance.new("TextLabel")
        blbl.Name = "Label"
        blbl.Size = UDim2.new(1, -45, 1, 0)
        blbl.Position = UDim2.new(0, 38, 0, 0)
        blbl.BackgroundTransparency = 1
        blbl.Text = name:upper()
        blbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        blbl.Font = Enum.Font.GothamBold
        blbl.TextSize = 11
        blbl.TextXAlignment = Enum.TextXAlignment.Left
        blbl.TextTransparency = 1
        blbl.Parent = btn
        
        local bindic = Instance.new("Frame")
        bindic.Name = "Frame"
        bindic.Size = UDim2.new(0, 2, 0, 0)
        bindic.Position = UDim2.new(0, -6, 0.5, 0)
        bindic.BackgroundColor3 = UI.Config.AccentColor
        bindic.BorderSizePixel = 0
        bindic.Parent = btn
        
        btn.MouseButton1Click:Connect(function() UI:SwitchPage(name) end)
    end
    
    function page:AddFeatureTile(title, ficon, default, fcallback)
        local tile = Instance.new("Frame")
        tile.Name = title .. "Tile"
        tile.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tile.BackgroundTransparency = 0.5
        tile.Parent = page.Container
        
        local techID = Instance.new("TextLabel")
        techID.Size = UDim2.new(0, 40, 0, 10)
        techID.Position = UDim2.new(1, -45, 0, 5)
        techID.BackgroundTransparency = 1
        techID.Text = "0x" .. string.format("%X", math.random(100, 999))
        techID.TextColor3 = Color3.fromRGB(255, 255, 255)
        techID.TextTransparency = 0.8
        techID.Font = Enum.Font.Code
        techID.TextSize = 8
        techID.Parent = tile
        
        Instance.new("UICorner", tile).CornerRadius = UDim.new(0, 12)
        local tstroke = Instance.new("UIStroke")
        tstroke.Color = default and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255)
        tstroke.Thickness = 1.2
        tstroke.Transparency = default and 0.4 or 0.8
        tstroke.Parent = tile
        
        local tbtn = Instance.new("TextButton")
        tbtn.Size = UDim2.new(1, 0, 1, 0)
        tbtn.BackgroundTransparency = 1
        tbtn.Text = ""
        tbtn.Parent = tile
        
        local tico = Instance.new("ImageLabel")
        tico.Name = "IconLabel"
        tico.Size = UDim2.new(0, 32, 0, 32)
        tico.Position = UDim2.new(0.5, -16, 0.15, 0)
        tico.BackgroundTransparency = 1
        tico.Image = ficon or ""
        tico.ImageColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
        tico.ZIndex = 5
        tico.ScaleType = Enum.ScaleType.Fit
        tico.Parent = tile
        
        local tlbl = Instance.new("TextLabel")
        tlbl.Size = UDim2.new(1, 0, 0, 20)
        tlbl.Position = UDim2.new(0, 0, 0.55, 0)
        tlbl.BackgroundTransparency = 1
        tlbl.Text = title:upper()
        tlbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        tlbl.Font = Enum.Font.GothamBlack
        tlbl.TextSize = 10
        tlbl.Parent = tile
        
        local tstat = Instance.new("TextLabel")
        tstat.Size = UDim2.new(1, 0, 0, 15)
        tstat.Position = UDim2.new(0, 0, 0.72, 0)
        tstat.BackgroundTransparency = 1
        tstat.Text = default and "ACTIVE" or "OFF"
        tstat.TextColor3 = default and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)
        tstat.Font = Enum.Font.GothamBold
        tstat.TextSize = 9
        tstat.Parent = tile
        
        local fstate = default
        tbtn.MouseButton1Click:Connect(function()
            fstate = not fstate
            TweenService:Create(tstroke, TweenInfo.new(0.2), {Color = fstate and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255), Transparency = 0.4}):Play()
            TweenService:Create(tico, TweenInfo.new(0.2), {ImageColor3 = fstate and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)}):Play()
            tstat.Text = fstate and "ACTIVE" or "OFF"
            TweenService:Create(tstat, TweenInfo.new(0.2), {TextColor3 = fstate and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)}):Play()
            pcall(function() fcallback(fstate) end)
        end)
        
        local sCont = Instance.new("ScrollingFrame")
        sCont.Name = title .. "Settings"
        sCont.Size = UDim2.new(1, -30, 1, -80)
        sCont.Position = UDim2.new(0, 15, 0, 65)
        sCont.BackgroundTransparency = 1
        sCont.BorderSizePixel = 0
        sCont.Visible = false
        sCont.Parent = UI.Refs.Overlay
        
        Instance.new("UIListLayout", sCont).Padding = UDim.new(0, 12)
        
        tbtn.MouseButton2Click:Connect(function()
            for _, child in pairs(UI.Refs.Overlay:GetChildren()) do if child:IsA("ScrollingFrame") then child.Visible = false end end
            sCont.Visible = true
            UI.Refs.OverlayTitle.Text = title:upper()
            TweenService:Create(UI.Refs.Overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.6, 0, 0, 0)}):Play()
        end)
        
        local sAPI = {}
        function sAPI:AddToggle(stitle, sdefault, scallback)
            local sf = Instance.new("Frame")
            sf.Size = UDim2.new(1, 0, 0, 35)
            sf.BackgroundTransparency = 1
            sf.Parent = sCont
            
            local slbl = Instance.new("TextLabel")
            slbl.Size = UDim2.new(0.7, 0, 1, 0)
            slbl.BackgroundTransparency = 1
            slbl.Text = stitle
            slbl.TextColor3 = Color3.fromRGB(180, 180, 180)
            slbl.Font = Enum.Font.Gotham
            slbl.TextSize = 12
            slbl.TextXAlignment = Enum.TextXAlignment.Left
            slbl.Parent = sf
            
            local sbtn = Instance.new("TextButton")
            sbtn.Size = UDim2.new(0, 36, 0, 18)
            sbtn.Position = UDim2.new(1, -36, 0.5, -9)
            sbtn.BackgroundColor3 = sdefault and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)
            sbtn.Text = ""
            sbtn.Parent = sf
            Instance.new("UICorner", sbtn).CornerRadius = UDim.new(1, 0)
            
            local scirc = Instance.new("Frame")
            scirc.Size = UDim2.new(0, 14, 0, 14)
            scirc.Position = sdefault and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            scirc.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            scirc.Parent = sbtn
            Instance.new("UICorner", scirc).CornerRadius = UDim.new(1, 0)
            
            local sstate = sdefault
            sbtn.MouseButton1Click:Connect(function()
                sstate = not sstate
                TweenService:Create(sbtn, TweenInfo.new(0.2), {BackgroundColor3 = sstate and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(scirc, TweenInfo.new(0.2), {Position = sstate and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                pcall(function() scallback(sstate) end)
            end)
        end
        return sAPI
    end
    return page
end

function UI:GetPageCount()
    local count = 0
    for name, _ in pairs(UI.Pages) do if name ~= "Settings" then count = count + 1 end end
    return count
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then UI:Toggle() end
end)

return UI
