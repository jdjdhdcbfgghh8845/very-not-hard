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
    GlassTransparency = 0.35, -- Highly transparent
    SidebarWidth = 65,
    AnimSpeed = 0.3
}

UI.Pages = {}
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
    MainGui.Name = "Nexus_Vitreous"
    MainGui.IgnoreGuiInset = true
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Container (Glow Layer)
    local GlowFrame = Instance.new("ImageLabel")
    GlowFrame.Name = "GlowFrame"
    GlowFrame.Size = UI.Config.WindowSize + UDim2.new(0, 40, 0, 40)
    GlowFrame.Position = UDim2.new(0.5, -370, 0.5, -245)
    GlowFrame.BackgroundTransparency = 1
    GlowFrame.Image = "rbxassetid://6015667352" -- Soft shadow asset
    GlowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
    GlowFrame.ImageTransparency = 0.4
    GlowFrame.Parent = MainGui
    
    -- Main Frame (The Glass)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UI.Config.WindowSize
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    MainFrame.BackgroundColor3 = UI.Config.BgColor
    MainFrame.BackgroundTransparency = UI.Config.GlassTransparency
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainGui
    UI.MainFrame = MainFrame
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame
    
    -- Gloss Overlay (Reflection)
    local Gloss = Instance.new("Frame")
    Gloss.Name = "Gloss"
    Gloss.Size = UDim2.new(2, 0, 2, 0)
    Gloss.Position = UDim2.new(-1, 0, -1, 0)
    Gloss.BackgroundTransparency = 0.95
    Gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Gloss.Rotation = 45
    Gloss.Parent = MainFrame
    
    local GlossGradient = Instance.new("UIGradient")
    GlossGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    GlossGradient.Parent = Gloss
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Thickness = 1.2
    MainStroke.Transparency = 0.8
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    
    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
    })
    StrokeGradient.Parent = MainStroke
    
    -- Sub-containers
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, UI.Config.SidebarWidth, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Sidebar.BackgroundTransparency = 0.6
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    UI.Sidebar = Sidebar
    
    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SidebarLine.BackgroundTransparency = 0.9
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar
    
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
    Overlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Overlay.BackgroundTransparency = 0.2
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 10
    Overlay.Parent = MainFrame
    UI.Overlay = Overlay
    
    local OverlayStroke = Instance.new("UIStroke")
    OverlayStroke.Color = UI.Config.AccentColor
    OverlayStroke.Thickness = 1
    OverlayStroke.Transparency = 0.6
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
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            MainFrame.Position = newPos
            GlowFrame.Position = newPos + UDim2.new(0, -20, 0, -20)
        end
    end)
    
    -- Protection
    if getgenv then getgenv().Nexus_UI = MainGui end
    MainGui.Parent = CoreGui
    
    print("[NEXUS] 💎 UI Vitreous Engine successfully loaded!")
end

-- [[ TOGGLE UI ]]
function UI:Toggle()
    UI.IsVisible = not UI.IsVisible
    
    local targetPos = UI.IsVisible and UDim2.new(0.5, -350, 0.5, -225) or UDim2.new(0.5, -350, 1.5, 0)
    local targetBlur = UI.IsVisible and 15 or 0
    
    TweenService:Create(UI.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    TweenService:Create(UI.Overlay.Parent.GlowFrame, TweenInfo.new(0.5), {Position = targetPos + UDim2.new(0, -20, 0, -20), ImageTransparency = UI.IsVisible and 0.4 or 1}):Play()
    TweenService:Create(GlobalBlur, TweenInfo.new(0.5), {Size = targetBlur}):Play()
    
    if UI.IsVisible then
        UI.MainFrame.Parent.Enabled = true
    else
        task.delay(0.5, function() if not UI.IsVisible then UI.MainFrame.Parent.Enabled = false end end)
    end
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
    layout.CellSize = UDim2.new(0, 185, 0, 130)
    layout.CellPadding = UDim2.new(0, 15, 0, 15)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page.Container
    
    UI.Pages[name] = page
    
    -- [[ SIDEBAR BUTTON ]]
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Btn"
    btn.Size = UDim2.new(0, 42, 0, 42)
    btn.Position = UDim2.new(0.5, -21, 0, 25 + (UI:GetPageCount() * 55))
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = UI.Sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local btnIco = Instance.new("ImageLabel")
    btnIco.Name = "ImageLabel" -- Added Name for easy lookup in click handler
    btnIco.Size = UDim2.new(0, 22, 0, 22)
    btnIco.Position = UDim2.new(0.5, -11, 0.5, -11)
    btnIco.Image = icon or ""
    btnIco.BackgroundTransparency = 1
    btnIco.ImageColor3 = Color3.fromRGB(150, 150, 150)
    btnIco.Parent = btn
    
    local btnIndicator = Instance.new("Frame")
    btnIndicator.Name = "Frame" -- Added Name for easy lookup in click handler
    btnIndicator.Size = UDim2.new(0, 2, 0, 0)
    btnIndicator.Position = UDim2.new(1, 8, 0.5, 0)
    btnIndicator.BackgroundColor3 = UI.Config.AccentColor
    btnIndicator.BorderSizePixel = 0
    btnIndicator.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        UI:SwitchPage(name)
        -- Reset all buttons
        for _, otherBtn in pairs(UI.Sidebar:GetChildren()) do
            if otherBtn:IsA("TextButton") then
                TweenService:Create(otherBtn.ImageLabel, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                TweenService:Create(otherBtn.Frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 2, 0, 0), Position = UDim2.new(1, 8, 0.5, 0)}):Play()
            end
        end
        -- Highlight current
        TweenService:Create(btnIco, TweenInfo.new(0.3), {ImageColor3 = UI.Config.AccentColor}):Play()
        TweenService:Create(btnIndicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 2, 0, 20), Position = UDim2.new(1, 8, 0.5, -10)}):Play()
    end)
    
    -- [[ FEATURE TILE API ]]
    function page:AddFeatureTile(title, f_icon, default, f_callback)
        local tile = Instance.new("Frame")
        tile.Name = title .. "Tile"
        tile.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tile.BackgroundTransparency = 0.7
        tile.Parent = page.Container
        
        local t_corner = Instance.new("UICorner")
        t_corner.CornerRadius = UDim.new(0, 14)
        t_corner.Parent = tile
        
        local t_stroke = Instance.new("UIStroke")
        t_stroke.Color = default and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255)
        t_stroke.Thickness = 1
        t_stroke.Transparency = default and 0.5 or 0.85
        t_stroke.Parent = tile
        
        local t_btn = Instance.new("TextButton")
        t_btn.Size = UDim2.new(1, 0, 1, 0)
        t_btn.BackgroundTransparency = 1
        t_btn.Text = ""
        t_btn.Parent = tile
        
        local t_ico = Instance.new("ImageLabel")
        t_ico.Size = UDim2.new(0, 32, 0, 32)
        t_ico.Position = UDim2.new(0.5, -16, 0.25, 0)
        t_ico.Image = f_icon or ""
        t_ico.BackgroundTransparency = 1
        t_ico.ImageColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        t_ico.Parent = tile
        
        local t_label = Instance.new("TextLabel")
        t_label.Size = UDim2.new(1, 0, 0, 20)
        t_label.Position = UDim2.new(0, 0, 0.65, 0)
        t_label.BackgroundTransparency = 1
        t_label.Text = title:upper()
        t_label.TextColor3 = Color3.fromRGB(255, 255, 255)
        t_label.Font = Enum.Font.GothamBold
        t_label.TextSize = 11
        t_label.Parent = tile
        
        local t_status = Instance.new("Frame")
        t_status.Size = UDim2.new(0, 4, 0, 4)
        t_status.Position = UDim2.new(0.5, -2, 0.85, 0)
        t_status.BackgroundColor3 = default and UI.Config.AccentColor or Color3.fromRGB(80, 80, 80)
        t_status.Parent = tile
        Instance.new("UICorner", t_status).CornerRadius = UDim.new(1, 0)
        
        local f_state = default
        
        t_btn.MouseEnter:Connect(function()
            TweenService:Create(tile, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            TweenService:Create(t_stroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
        end)
        t_btn.MouseLeave:Connect(function()
            TweenService:Create(tile, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
            TweenService:Create(t_stroke, TweenInfo.new(0.2), {Transparency = f_state and 0.5 or 0.85}):Play()
        end)
        
        t_btn.MouseButton1Click:Connect(function()
            f_state = not f_state
            TweenService:Create(t_stroke, TweenInfo.new(0.2), {Color = f_state and UI.Config.AccentColor or Color3.fromRGB(255, 255, 255), Transparency = 0.4}):Play()
            TweenService:Create(t_ico, TweenInfo.new(0.2), {ImageColor3 = f_state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)}):Play()
            TweenService:Create(t_status, TweenInfo.new(0.2), {BackgroundColor3 = f_state and UI.Config.AccentColor or Color3.fromRGB(80, 80, 80)}):Play()
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
        settingsContainer.Parent = UI.Overlay
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 12)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = settingsContainer
        
        t_btn.MouseButton2Click:Connect(function()
            for _, child in pairs(UI.Overlay:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            settingsContainer.Visible = true
            UI.Overlay.OverlayTitle.Text = title:upper()
            TweenService:Create(UI.Overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.6, 0, 0, 0)}):Play()
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
