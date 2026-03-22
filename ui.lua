-- [[ AAC CORE - UI ENGINE (STRICT SHOOTER) ]]
-- A minimalist, tactical interface for Roblox shooters.

local UI = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ CONFIGURATION ]]
UI.Config = {
    WindowSize = UDim2.new(0, 600, 0, 400),
    AccentColor = Color3.fromRGB(200, 30, 30), -- Crimson Red
    BgColor = Color3.fromRGB(18, 18, 18),
    SidebarColor = Color3.fromRGB(12, 12, 12),
    TileColor = Color3.fromRGB(25, 25, 25),
    Font = Enum.Font.GothamBold,
    AnimSpeed = 0.2
}

UI.Refs = {}
UI.Pages = {}
UI.CurrentPage = nil
UI.IsVisible = true

-- [[ UTILS ]]
local function createTween(obj, props)
    local info = TweenInfo.new(UI.Config.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- [[ UI INITIALIZATION ]]
function UI:Init()
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "AAC_S"
    MainGui.IgnoreGuiInset = true
    MainGui.Parent = (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui
    UI.Refs.MainGui = MainGui
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UI.Config.WindowSize
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = UI.Config.BgColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = MainGui
    UI.Refs.MainFrame = MainFrame
    
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(40, 40, 40)
    Border.Thickness = 1
    Border.Parent = MainFrame
    
    -- Accent Line
    local TopLine = Instance.new("Frame")
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BackgroundColor3 = UI.Config.AccentColor
    TopLine.BorderSizePixel = 0
    TopLine.Parent = MainFrame
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -2)
    Sidebar.Position = UDim2.new(0, 0, 0, 2)
    Sidebar.BackgroundColor3 = UI.Config.SidebarColor
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    UI.Refs.Sidebar = Sidebar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "AAC / ELITE"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.Parent = Sidebar
    
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 0, 35)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "TACTICAL INTERFACE"
    SubTitle.TextColor3 = UI.Config.AccentColor
    SubTitle.Font = UI.Config.Font
    SubTitle.TextSize = 8
    SubTitle.Parent = Sidebar
    
    local BtnList = Instance.new("Frame")
    BtnList.Name = "BtnList"
    BtnList.Size = UDim2.new(1, 0, 1, -80)
    BtnList.Position = UDim2.new(0, 0, 0, 70)
    BtnList.BackgroundTransparency = 1
    BtnList.Parent = Sidebar
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = BtnList
    
    UI.Refs.BtnList = BtnList
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -2)
    ContentArea.Position = UDim2.new(0, 160, 0, 2)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    UI.Refs.ContentArea = ContentArea
    
    -- Settings Overlay
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.Visible = false
    Overlay.ZIndex = 100
    Overlay.Parent = MainFrame
    UI.Refs.Overlay = Overlay
    
    local OverlayFrame = Instance.new("Frame")
    OverlayFrame.Name = "OverlayFrame"
    OverlayFrame.Size = UDim2.new(0, 250, 0, 300)
    OverlayFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    OverlayFrame.BackgroundColor3 = UI.Config.BgColor
    OverlayFrame.BorderSizePixel = 0
    OverlayFrame.Parent = Overlay
    
    Instance.new("UIStroke", OverlayFrame).Color = UI.Config.AccentColor
    
    local OverlayTitle = Instance.new("TextLabel")
    OverlayTitle.Size = UDim2.new(1, -40, 0, 40)
    OverlayTitle.Position = UDim2.new(0, 20, 0, 0)
    OverlayTitle.BackgroundTransparency = 1
    OverlayTitle.TextSize = 14
    OverlayTitle.Font = UI.Config.Font
    OverlayTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    OverlayTitle.TextXAlignment = Enum.TextXAlignment.Left
    OverlayTitle.Parent = OverlayFrame
    UI.Refs.OverlayTitle = OverlayTitle
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.Font = UI.Config.Font
    CloseBtn.TextSize = 16
    CloseBtn.Parent = OverlayFrame
    
    CloseBtn.MouseButton1Click:Connect(function()
        Overlay.Visible = false
    end)
    
    local SettingsCont = Instance.new("ScrollingFrame")
    SettingsCont.Size = UDim2.new(1, -20, 1, -50)
    SettingsCont.Position = UDim2.new(0, 10, 0, 45)
    SettingsCont.BackgroundTransparency = 1
    SettingsCont.BorderSizePixel = 0
    SettingsCont.ScrollBarThickness = 2
    SettingsCont.ScrollBarImageColor3 = UI.Config.AccentColor
    SettingsCont.Parent = OverlayFrame
    UI.Refs.SettingsCont = SettingsCont
    
    Instance.new("UIListLayout", SettingsCont).Padding = UDim.new(0, 5)
    
    -- Dragging Support
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    -- Toggle UI (RightShift)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
            UI:Toggle()
        end
    end)
end

function UI:Toggle()
    UI.IsVisible = not UI.IsVisible
    if UI.IsVisible then
        UI.Refs.MainFrame.Visible = true
        createTween(UI.Refs.MainFrame, {Position = UDim2.new(0.5, -300, 0.5, -200)})
    else
        local t = createTween(UI.Refs.MainFrame, {Position = UDim2.new(0.5, -300, 1.5, 0)})
        t.Completed:Wait()
        if not UI.IsVisible then UI.Refs.MainFrame.Visible = false end
    end
end

function UI:CreatePage(name)
    local page = {
        Name = name,
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
    
    local Layout = Instance.new("UIGridLayout")
    Layout.CellSize = UDim2.new(0, 135, 0, 100)
    Layout.CellPadding = UDim2.new(0, 10, 0, 10)
    Layout.Parent = page.Container
    
    UI.Pages[name] = page
    
    -- Sidebar Button
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = UI.Config.SidebarColor
    Btn.BorderSizePixel = 0
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = UI.Config.Font
    Btn.TextSize = 12
    Btn.Parent = UI.Refs.BtnList
    
    local SelInd = Instance.new("Frame")
    SelInd.Size = UDim2.new(0, 4, 1, 0)
    SelInd.BackgroundColor3 = UI.Config.AccentColor
    SelInd.BorderSizePixel = 0
    SelInd.BackgroundTransparency = 1
    SelInd.Visible = false
    SelInd.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        UI:SwitchPage(name)
    end)
    
    page.Btn = Btn
    page.Ind = SelInd
    
    return page
end

function UI:SwitchPage(name)
    if UI.CurrentPage then
        UI.Pages[UI.CurrentPage].Container.Visible = false
        createTween(UI.Pages[UI.CurrentPage].Btn, {TextColor3 = Color3.fromRGB(150, 150, 150)})
        UI.Pages[UI.CurrentPage].Ind.Visible = false
    end
    UI.CurrentPage = name
    UI.Pages[name].Container.Visible = true
    createTween(UI.Pages[name].Btn, {TextColor3 = Color3.fromRGB(255, 255, 255)})
    UI.Pages[name].Ind.Visible = true
end

function UI:AddFeatureTile(pageName, title, default, callback)
    local page = UI.Pages[pageName]
    local tile = Instance.new("Frame")
    tile.BackgroundColor3 = UI.Config.TileColor
    tile.BorderSizePixel = 0
    tile.Parent = page.Container
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1
    Stroke.Parent = tile
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = tile
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0.4, 0)
    Label.Position = UDim2.new(0, 0, 0.2, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title:upper()
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = UI.Config.Font
    Label.TextSize = 10
    Label.Parent = tile
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, 0, 0.2, 0)
    Status.Position = UDim2.new(0, 0, 0.6, 0)
    Status.BackgroundTransparency = 1
    Status.Text = default and "ACTIVE" or "DISABLED"
    Status.TextColor3 = default and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)
    Status.Font = UI.Config.Font
    Status.TextSize = 8
    Status.Parent = tile
    
    local state = default
    local function update()
        Status.Text = state and "ACTIVE" or "DISABLED"
        Status.TextColor3 = state and UI.Config.AccentColor or Color3.fromRGB(100, 100, 100)
        Stroke.Color = state and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)
        callback(state)
    end
    
    Btn.MouseButton1Click:Connect(function()
        state = not state
        update()
    end)
    
    -- Right-Click Settings
    local settingFrame = Instance.new("Frame")
    settingFrame.Size = UDim2.new(1, 0, 1, 0)
    settingFrame.BackgroundTransparency = 1
    settingFrame.Visible = false
    settingFrame.Parent = UI.Refs.SettingsCont
    Instance.new("UIListLayout", settingFrame).Padding = UDim.new(0, 5)
    
    Btn.MouseButton2Click:Connect(function()
        for _, child in pairs(UI.Refs.SettingsCont:GetChildren()) do
            if child:IsA("Frame") then child.Visible = false end
        end
        settingFrame.Visible = true
        UI.Refs.OverlayTitle.Text = title:upper() .. " SETTINGS"
        UI.Refs.Overlay.Visible = true
    end)
    
    local sAPI = {}
    function sAPI:AddToggle(sTitle, sDefault, sCallback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        f.Parent = settingFrame
        
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = sTitle
        l.TextColor3 = Color3.fromRGB(200, 200, 200)
        l.Font = UI.Config.Font
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 40, 0, 20)
        b.Position = UDim2.new(1, -45, 0.5, -10)
        b.BackgroundColor3 = sDefault and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)
        b.Text = ""
        b.Parent = f
        
        local sState = sDefault
        b.MouseButton1Click:Connect(function()
            sState = not sState
            b.BackgroundColor3 = sState and UI.Config.AccentColor or Color3.fromRGB(40, 40, 40)
            sCallback(sState)
        end)
    end
    
    function sAPI:AddSlider(sTitle, min, max, sDefault, sCallback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 50)
        f.BackgroundTransparency = 1
        f.Parent = settingFrame
        
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 20)
        l.BackgroundTransparency = 1
        l.Text = sTitle .. ": " .. sDefault
        l.TextColor3 = Color3.fromRGB(200, 200, 200)
        l.Font = UI.Config.Font
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, -10, 0, 6)
        bg.Position = UDim2.new(0, 0, 0, 30)
        bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        bg.Parent = f
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((sDefault - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = UI.Config.AccentColor
        fill.Parent = bg
        
        local function move(input)
            local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            l.Text = sTitle .. ": " .. val
            sCallback(val)
        end
        
        local dragging = false
        bg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move(input) end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end
    
    return sAPI
end

return UI
