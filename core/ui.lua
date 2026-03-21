-- [[ NEXUS CORE - UI ENGINE (AURA / FLUX DESIGN) ]]
-- A premium, high-end interface focusing on glassmorphism and smooth animations.

local UI = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- [[ CONFIGURATION & THEME ]]
UI.Config = {
    WindowSize = UDim2.new(0, 680, 0, 480),
    AccentColor = Color3.fromRGB(0, 150, 255),
    BgColor = Color3.fromRGB(8, 8, 8),
    SidebarWidth = 60,
    AnimSpeed = 0.3
}

UI.Pages = {}
UI.CurrentPage = nil
UI.IsVisible = true

-- [[ UI INITIALIZATION ]]
function UI.Init()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "Nexus_Aura"
    MainGui.IgnoreGuiInset = true
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UI.Config.WindowSize
    MainFrame.Position = UDim2.new(0.5, -340, 0.5, -240)
    MainFrame.BackgroundColor3 = UI.Config.BgColor
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGui
    UI.MainFrame = MainFrame
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame
    
    -- Sub-containers
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, UI.Config.SidebarWidth, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    UI.Sidebar = Sidebar
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -UI.Config.SidebarWidth, 1, 0)
    ContentArea.Position = UDim2.new(0, UI.Config.SidebarWidth, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    UI.ContentArea = ContentArea
    
    -- Overlay for settings (Context Menu)
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(0.4, 0, 1, 0)
    Overlay.Position = UDim2.new(1, 0, 0, 0) -- Hidden by default
    Overlay.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = MainFrame
    UI.Overlay = Overlay
    
    local OverlayStroke = Instance.new("UIStroke")
    OverlayStroke.Color = UI.Config.AccentColor
    OverlayStroke.Thickness = 1
    OverlayStroke.Transparency = 0.8
    OverlayStroke.Parent = Overlay
    
    -- Dragging Support
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Protection
    if getgenv then getgenv().Nexus_UI = MainGui end
    MainGui.Parent = CoreGui
    
    print("[NEXUS] 💎 UI Aura Engine successfully loaded!")
end

-- [[ NAVIGATION API ]]
function UI:SwitchPage(name)
    if UI.CurrentPage == name then return end
    
    for pageName, page in pairs(UI.Pages) do
        page.Container.Visible = (pageName == name)
    end
    UI.CurrentPage = name
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
    page.Container.Parent = UI.ContentArea
    
    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0, 180, 0, 140)
    layout.CellPadding = UDim2.new(0, 15, 0, 15)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page.Container
    
    UI.Pages[name] = page
    
    -- [[ FEATURE TILE API ]]
    function page:AddFeatureTile(title, icon, default, callback)
        local tile = Instance.new("Frame")
        tile.Name = title .. "Tile"
        tile.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tile.Parent = page.Container
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = tile
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = default and UI.Config.AccentColor or Color3.fromRGB(50, 50, 50)
        stroke.Thickness = 1.2
        stroke.Transparency = 0.4
        stroke.Parent = tile
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = tile
        
        local ico = Instance.new("ImageLabel")
        ico.Size = UDim2.new(0, 40, 0, 40)
        ico.Position = UDim2.new(0.5, -20, 0.2, 0)
        ico.Image = icon or ""
        ico.BackgroundTransparency = 1
        ico.ImageColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        ico.Parent = tile
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 0, 0.65, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.Parent = tile
        
        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(1, 0, 0, 15)
        status.Position = UDim2.new(0, 0, 0.8, 0)
        status.BackgroundTransparency = 1
        status.Text = default and "ENABLED" or "DISABLED"
        status.TextColor3 = default and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)
        status.Font = Enum.Font.Gotham
        status.TextSize = 10
        status.Parent = tile
        
        local state = default
        
        -- Settings container for this feature
        local settingsContainer = Instance.new("ScrollingFrame")
        settingsContainer.Name = title .. "Settings"
        settingsContainer.Size = UDim2.new(1, -20, 1, -60)
        settingsContainer.Position = UDim2.new(0, 10, 0, 50)
        settingsContainer.BackgroundTransparency = 1
        settingsContainer.BorderSizePixel = 0
        settingsContainer.Visible = false
        settingsContainer.Parent = UI.Overlay
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = settingsContainer
        
        -- Left Click: Toggle
        button.MouseButton1Click:Connect(function()
            state = not state
            stroke.Color = state and UI.Config.AccentColor or Color3.fromRGB(50, 50, 50)
            ico.ImageColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
            status.Text = state and "ENABLED" or "DISABLED"
            status.TextColor3 = state and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)
            
            pcall(function() callback(state) end)
        end)
        
        -- Right Click: Open Settings
        button.MouseButton2Click:Connect(function()
            -- Hide all other setting containers
            for _, child in pairs(UI.Overlay:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            
            settingsContainer.Visible = true
            TweenService:Create(UI.Overlay, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Position = UDim2.new(0.6, 0, 0, 0)}):Play()
        end)
        
        -- API for settings
        local settingsAPI = {}
        
        function settingsAPI:AddToggle(t_title, t_default, t_callback)
            local t_frame = Instance.new("Frame")
            t_frame.Name = t_title .. "Toggle"
            t_frame.Size = UDim2.new(1, -10, 0, 35)
            t_frame.BackgroundTransparency = 1
            t_frame.Parent = settingsContainer
            
            local t_label = Instance.new("TextLabel")
            t_label.Size = UDim2.new(0.7, 0, 1, 0)
            t_label.BackgroundTransparency = 1
            t_label.Text = t_title
            t_label.TextColor3 = Color3.fromRGB(200, 200, 200)
            t_label.Font = Enum.Font.Gotham
            t_label.TextSize = 13
            t_label.TextXAlignment = Enum.TextXAlignment.Left
            t_label.Parent = t_frame
            
            local t_btn = Instance.new("TextButton")
            t_btn.Size = UDim2.new(0, 40, 0, 20)
            t_btn.Position = UDim2.new(1, -45, 0.5, -10)
            t_btn.BackgroundColor3 = t_default and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)
            t_btn.Text = ""
            t_btn.Parent = t_frame
            
            local t_corner = Instance.new("UICorner")
            t_corner.CornerRadius = UDim.new(0, 10)
            t_corner.Parent = t_btn
            
            local t_circle = Instance.new("Frame")
            t_circle.Size = UDim2.new(0, 16, 0, 16)
            t_circle.Position = t_default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            t_circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            t_circle.Parent = t_btn
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = t_circle
            
            local t_state = t_default
            t_btn.MouseButton1Click:Connect(function()
                t_state = not t_state
                TweenService:Create(t_btn, TweenInfo.new(0.2), {BackgroundColor3 = t_state and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(t_circle, TweenInfo.new(0.2), {Position = t_state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(function() t_callback(t_state) end)
            end)
        end
        
        function settingsAPI:AddSlider(s_title, min, max, s_default, s_callback)
            local s_frame = Instance.new("Frame")
            s_frame.Name = s_title .. "Slider"
            s_frame.Size = UDim2.new(1, -10, 0, 50)
            s_frame.BackgroundTransparency = 1
            s_frame.Parent = settingsContainer
            
            local s_label = Instance.new("TextLabel")
            s_label.Size = UDim2.new(0.7, 0, 0, 20)
            s_label.BackgroundTransparency = 1
            s_label.Text = s_title
            s_label.TextColor3 = Color3.fromRGB(200, 200, 200)
            s_label.Font = Enum.Font.Gotham
            s_label.TextSize = 12
            s_label.TextXAlignment = Enum.TextXAlignment.Left
            s_label.Parent = s_frame
            
            local val_label = Instance.new("TextLabel")
            val_label.Size = UDim2.new(0.3, 0, 0, 20)
            val_label.Position = UDim2.new(0.7, 0, 0, 0)
            val_label.BackgroundTransparency = 1
            val_label.Text = tostring(s_default)
            val_label.TextColor3 = UI.Config.AccentColor
            val_label.Font = Enum.Font.GothamBold
            val_label.TextSize = 12
            val_label.TextXAlignment = Enum.TextXAlignment.Right
            val_label.Parent = s_frame
            
            local s_bar = Instance.new("Frame")
            s_bar.Size = UDim2.new(1, 0, 0, 4)
            s_bar.Position = UDim2.new(0, 0, 0, 35)
            s_bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            s_bar.BorderSizePixel = 0
            s_bar.Parent = s_frame
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = s_bar
            
            local s_fill = Instance.new("Frame")
            local startPercent = (s_default - min) / (max - min)
            s_fill.Size = UDim2.new(startPercent, 0, 1, 0)
            s_fill.BackgroundColor3 = UI.Config.AccentColor
            s_fill.BorderSizePixel = 0
            s_fill.Parent = s_bar
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = s_fill
            
            local sliding = false
            local function update(input)
                local pos = math.clamp((input.Position.X - s_bar.AbsolutePosition.X) / s_bar.AbsoluteSize.X, 0, 1)
                s_fill.Size = UDim2.new(pos, 0, 1, 0)
                local value = math.floor(min + (max - min) * pos)
                if max <= 1 then -- Handle decimals
                    value = math.round((min + (max - min) * pos) * 100) / 100
                end
                val_label.Text = tostring(value)
                pcall(function() s_callback(value) end)
            end
            
            s_bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    update(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
        end
        
        return settingsAPI
    end
    
    -- Overlay Header & Close
    local OverlayTitle = Instance.new("TextLabel")
    OverlayTitle.Size = UDim2.new(1, 0, 0, 50)
    OverlayTitle.BackgroundTransparency = 1
    OverlayTitle.Text = "SETTINGS"
    OverlayTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    OverlayTitle.Font = Enum.Font.GothamBold
    OverlayTitle.TextSize = 16
    OverlayTitle.Parent = Overlay
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.TextSize = 20
    CloseBtn.Parent = Overlay
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Overlay, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 0, 0, 0)}):Play()
    end)
    
    -- Sidebar Button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 40)
    btn.Position = UDim2.new(0.5, -20, 0, 20 + (#UI.Sidebar:GetChildren() * 50))
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = ""
    btn.Parent = UI.Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local ico = Instance.new("ImageLabel")
    ico.Size = UDim2.new(0.6, 0, 0.6, 0)
    ico.Position = UDim2.new(0.2, 0, 0.2, 0)
    ico.Image = icon or ""
    ico.BackgroundTransparency = 1
    ico.ImageColor3 = Color3.fromRGB(150, 150, 150)
    ico.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        UI:SwitchPage(name)
        TweenService:Create(ico, TweenInfo.new(0.3), {ImageColor3 = UI.Config.AccentColor}):Play()
    end)
    
    -- Initialize first page
    if not UI.CurrentPage then
        UI:SwitchPage(name)
    end
    
    return page
end

return UI
