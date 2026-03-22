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
    BgColor = Color3.fromRGB(15, 15, 15),
    SidebarColor = Color3.fromRGB(10, 10, 10),
    TileColor = Color3.fromRGB(22, 22, 22),
    Font = Enum.Font.GothamBold,
    AnimSpeed = 0.2
}

UI.Refs = {}
UI.Pages = {}
UI.Keybinds = {} -- { [FeatureName] = Enum.KeyCode }
UI.CurrentPage = nil
UI.IsVisible = true

-- Shared Registry for Keybinds/Config
_G.AAC.ConfigRegistry = _G.AAC.ConfigRegistry or {}

-- [[ UTILS ]]
local function createTween(obj, props)
    local info = TweenInfo.new(UI.Config.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- [[ UI NOTIFICATION SYSTEM ]]
function UI:Notify(text, duration)
    duration = duration or 3
    local s = Instance.new("ScreenGui", CoreGui)
    s.Name = "AAC_Notify"
    
    local f = Instance.new("Frame", s)
    f.Size = UDim2.new(0, 260, 0, 60)
    f.Position = UDim2.new(0.5, -130, 0, -100)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    local st = Instance.new("UIStroke", f)
    st.Color = UI.Config.AccentColor
    st.Thickness = 1.5
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -20, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text:upper()
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Font = UI.Config.Font
    l.TextSize = 11
    
    createTween(f, {Position = UDim2.new(0.5, -130, 0, 40)})
    task.delay(duration, function()
        createTween(f, {Position = UDim2.new(0.5, -130, 0, -100)})
        task.wait(0.5)
        s:Destroy()
    end)
end

-- [[ THEME ENGINE ]]
function UI:UpdateAccentColor(newColor)
    UI.Config.AccentColor = newColor
    if UI.Refs.TopLine then UI.Refs.TopLine.BackgroundColor3 = newColor end
    for _, obj in pairs(UI.Refs.MainGui:GetDescendants()) do
        if obj:IsA("UIStroke") and obj.Color ~= Color3.fromRGB(40, 40, 40) then
            obj.Color = newColor
        elseif (obj:IsA("Frame") or obj:IsA("TextButton")) and obj.Name == "Indicator" then
            obj.BackgroundColor3 = newColor
        end
    end
end

-- [[ KEYBIND PROMPT ]]
function UI:PromptKeybind(feature, buttonLabel)
    local oldText = buttonLabel.Text
    buttonLabel.Text = "..."
    local conn
    conn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            UI.Keybinds[feature] = input.KeyCode
            buttonLabel.Text = "[" .. input.KeyCode.Name .. "]"
            conn:Disconnect()
            UI:Notify("BOUND: " .. feature .. " TO " .. input.KeyCode.Name)
        end
    end)
end

-- [[ UI INITIALIZATION ]]
function UI:Init()
    local MainGui = Instance.new("ScreenGui", CoreGui)
    MainGui.Name = "AAC_S"
    MainGui.IgnoreGuiInset = true
    UI.Refs.MainGui = MainGui
    
    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Size = UI.Config.WindowSize
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = UI.Config.BgColor
    MainFrame.BorderSizePixel = 0
    UI.Refs.MainFrame = MainFrame
    
    local TopLine = Instance.new("Frame", MainFrame)
    TopLine.Size = UDim2.new(1, 0, 0, 2)
    TopLine.BackgroundColor3 = UI.Config.AccentColor
    TopLine.BorderSizePixel = 0
    UI.Refs.TopLine = TopLine
    
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 160, 1, -2)
    Sidebar.Position = UDim2.new(0, 0, 0, 2)
    Sidebar.BackgroundColor3 = UI.Config.SidebarColor
    Sidebar.BorderSizePixel = 0
    UI.Refs.Sidebar = Sidebar
    
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -170, 1, -12)
    ContentArea.Position = UDim2.new(0, 165, 0, 7)
    ContentArea.BackgroundTransparency = 1
    UI.Refs.ContentArea = ContentArea
    
    local Overlay = Instance.new("Frame", MainFrame)
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0,0,0)
    Overlay.BackgroundTransparency = 0.6
    Overlay.Visible = false
    Overlay.ZIndex = 100
    UI.Refs.Overlay = Overlay
    
    local OverlayFrame = Instance.new("Frame", Overlay)
    OverlayFrame.Size = UDim2.new(0, 300, 0, 350)
    OverlayFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    OverlayFrame.BackgroundColor3 = UI.Config.BgColor
    OverlayFrame.BorderSizePixel = 0
    Instance.new("UIStroke", OverlayFrame).Color = UI.Config.AccentColor
    
    local OverlayTitle = Instance.new("TextLabel", OverlayFrame)
    OverlayTitle.Size = UDim2.new(1, 0, 0, 40)
    OverlayTitle.BackgroundTransparency = 1
    OverlayTitle.TextColor3 = Color3.new(1,1,1)
    OverlayTitle.Font = UI.Config.Font
    OverlayTitle.TextSize = 14
    UI.Refs.OverlayTitle = OverlayTitle
    
    local CloseBtn = Instance.new("TextButton", OverlayFrame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.MouseButton1Click:Connect(function() Overlay.Visible = false end)
    
    local SettingsCont = Instance.new("ScrollingFrame", OverlayFrame)
    SettingsCont.Size = UDim2.new(1, -20, 1, -50)
    SettingsCont.Position = UDim2.new(0, 10, 0, 45)
    SettingsCont.BackgroundTransparency = 1
    SettingsCont.BorderSizePixel = 0
    SettingsCont.CanvasSize = UDim2.new(0, 0, 0, 0)
    Instance.new("UIListLayout", SettingsCont).Padding = UDim.new(0, 5)
    UI.Refs.SettingsCont = SettingsCont

    -- Keybind Listener
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightShift then UI:Toggle() end
        for feature, key in pairs(UI.Keybinds) do
            if input.KeyCode == key then
                local reg = _G.AAC.ConfigRegistry
                if reg[feature] then
                    local s = not (reg[feature.."_State"] or false)
                    reg[feature.."_State"] = s
                    reg[feature](s)
                    UI:Notify(feature .. ": " .. (s and "ON" or "OFF"))
                end
            end
        end
    end)
    
    -- Dragging
    local dragging, dragStart, startPos
    Sidebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function UI:Toggle()
    UI.IsVisible = not UI.IsVisible
    if UI.IsVisible then
        UI.Refs.MainFrame.Visible = true
        createTween(UI.Refs.MainFrame, {Position = UDim2.new(0.5, -300, 0.5, -200)})
    else
        createTween(UI.Refs.MainFrame, {Position = UDim2.new(0.5, -300, 1.5, 0)})
        task.delay(UI.Config.AnimSpeed, function() if not UI.IsVisible then UI.Refs.MainFrame.Visible = false end end)
    end
end

function UI:CreatePage(name)
    local page = {Name = name, Container = Instance.new("ScrollingFrame", UI.Refs.ContentArea)}
    page.Container.Size = UDim2.new(1, 0, 1, 0)
    page.Container.BackgroundTransparency = 1
    page.Container.BorderSizePixel = 0
    page.Container.Visible = false
    local layout = Instance.new("UIGridLayout", page.Container)
    layout.CellSize = UDim2.new(0, 135, 0, 100)
    layout.CellPadding = UDim2.new(0, 10, 0, 10)
    
    local btn = Instance.new("TextButton", UI.Refs.Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, 70 + (#UI.Refs.Sidebar:GetChildren() - 2) * 45)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    btn.BorderSizePixel = 0
    btn.Text = name:upper()
    btn.TextColor3 = Color3.fromRGB(150,150,150)
    btn.Font = UI.Config.Font
    btn.TextSize = 11
    
    local ind = Instance.new("Frame", btn)
    ind.Name = "Indicator"
    ind.Size = UDim2.new(0, 2, 1, 0)
    ind.BackgroundColor3 = UI.Config.AccentColor
    ind.BorderSizePixel = 0
    ind.Visible = false
    
    btn.MouseButton1Click:Connect(function() UI:SwitchPage(name) end)
    UI.Pages[name] = page
    page.Btn = btn
    page.Ind = ind
    return page
end

function UI:SwitchPage(name)
    for k, p in pairs(UI.Pages) do
        p.Container.Visible = (k == name)
        p.Ind.Visible = (k == name)
        p.Btn.TextColor3 = (k == name) and Color3.new(1,1,1) or Color3.fromRGB(150,150,150)
    end
end

function UI:AddFeatureTile(pageName, title, default, callback)
    local page = UI.Pages[pageName]
    local tile = Instance.new("Frame", page.Container)
    tile.BackgroundColor3 = UI.Config.TileColor
    tile.BorderSizePixel = 0
    local stroke = Instance.new("UIStroke", tile)
    stroke.Color = Color3.fromRGB(40,40,40)
    
    local btn = Instance.new("TextButton", tile)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local label = Instance.new("TextLabel", tile)
    label.Size = UDim2.new(1, 0, 0.4, 0)
    label.Position = UDim2.new(0, 0, 0.2, 0)
    label.BackgroundTransparency = 1
    label.Text = title:upper()
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = UI.Config.Font
    label.TextSize = 10
    
    local status = Instance.new("TextLabel", tile)
    status.Size = UDim2.new(1, 0, 0.2, 0)
    status.Position = UDim2.new(0, 0, 0.6, 0)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(150,150,150)
    status.Font = UI.Config.Font
    status.TextSize = 8
    
    local state = default
    local function update()
        status.Text = state and "ACTIVE" or "DISABLED"
        stroke.Color = state and UI.Config.AccentColor or Color3.fromRGB(40,40,40)
        _G.AAC.ConfigRegistry[title] = callback
        _G.AAC.ConfigRegistry[title.."_State"] = state
        callback(state)
    end
    update()
    btn.MouseButton1Click:Connect(function() state = not state update() end)
    
    local sFrame = Instance.new("Frame", UI.Refs.SettingsCont)
    sFrame.Size = UDim2.new(1, 0, 0, 0)
    sFrame.BackgroundTransparency = 1
    sFrame.Visible = false
    local sLayout = Instance.new("UIListLayout", sFrame)
    sLayout.Padding = UDim.new(0, 5)
    sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sFrame.Size = UDim2.new(1, 0, 0, sLayout.AbsoluteContentSize.Y) end)
    
    btn.MouseButton2Click:Connect(function()
        for _, c in pairs(UI.Refs.SettingsCont:GetChildren()) do if c:IsA("Frame") then c.Visible = false end end
        sFrame.Visible = true
        UI.Refs.OverlayTitle.Text = title:upper() .. " SETTINGS"
        UI.Refs.Overlay.Visible = true
    end)
    
    local sAPI = {}
    function sAPI:AddToggle(tText, tDefault, tCallback)
        local f = Instance.new("Frame", sFrame)
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = tText:upper()
        l.TextColor3 = Color3.new(1,1,1)
        l.Font = UI.Config.Font
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0, 40, 0, 20)
        b.Position = UDim2.new(1, -45, 0.5, -10)
        b.BackgroundColor3 = tDefault and UI.Config.AccentColor or Color3.fromRGB(40,40,40)
        b.Text = ""
        local tState = tDefault
        b.MouseButton1Click:Connect(function()
            tState = not tState
            b.BackgroundColor3 = tState and UI.Config.AccentColor or Color3.fromRGB(40,40,40)
            tCallback(tState)
        end)
    end
    
    function sAPI:AddSlider(sText, min, max, sDefault, sCallback)
        local f = Instance.new("Frame", sFrame)
        f.Size = UDim2.new(1, 0, 0, 45)
        f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, 0, 0, 20)
        l.BackgroundTransparency = 1
        l.Text = sText:upper() .. ": " .. sDefault
        l.TextColor3 = Color3.new(1,1,1)
        l.Font = UI.Config.Font
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        
        local sbg = Instance.new("Frame", f)
        sbg.Size = UDim2.new(1, -10, 0, 4)
        sbg.Position = UDim2.new(0, 5, 0, 30)
        sbg.BackgroundColor3 = Color3.fromRGB(40,40,40)
        sbg.BorderSizePixel = 0
        local sfill = Instance.new("Frame", sbg)
        sfill.Size = UDim2.new((sDefault - min) / (max - min), 0, 1, 0)
        sfill.BackgroundColor3 = UI.Config.AccentColor
        sfill.BorderSizePixel = 0
        sfill.Name = "Indicator"
        
        local function update(input)
            local p = math.clamp((input.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * p)
            sfill.Size = UDim2.new(p, 0, 1, 0)
            l.Text = sText:upper() .. ": " .. val
            sCallback(val)
        end
        sbg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then update(input) end end)
        -- Keybind button
    end

    function sAPI:AddKeybind(kbText)
        local f = Instance.new("Frame", sFrame)
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = kbText:upper()
        l.TextColor3 = Color3.new(1,1,1)
        l.Font = UI.Config.Font
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0, 60, 0, 20)
        b.Position = UDim2.new(1, -65, 0.5, -10)
        b.BackgroundColor3 = Color3.fromRGB(40,40,40)
        b.Text = "[NONE]"
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = UI.Config.Font
        b.TextSize = 8
        b.MouseButton1Click:Connect(function() UI:PromptKeybind(title, b) end)
    end
    
    return sAPI
end

return UI
