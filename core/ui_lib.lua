--[[
    UI LIBRARY (v4.0)
    A standalone, modular-ready interface system with tiles and overlays.
]]

local Library = {}
local G = getgenv and getgenv() or _G

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- [[ COLORS & THEMES ]]
Library.Theme = {
    Main = Color3.fromRGB(12, 12, 13),
    Accent = Color3.fromRGB(255, 255, 255),
    Tile = Color3.fromRGB(22, 22, 23),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Stroke = Color3.fromRGB(60, 60, 60)
}

-- Registry for UI Sync
G.ConfigRegistry = G.ConfigRegistry or {}

-- [[ UTILS ]]
local function create(className, properties)
    local ins = Instance.new(className)
    for k, v in pairs(properties) do
        if k ~= "Parent" then ins[k] = v end
    end
    ins.Parent = properties.Parent
    return ins
end

local function applyTween(ins, props, time)
    local tween = TweenService:Create(ins, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart), props)
    tween:Play()
    return tween
end

-- [[ MAIN WINDOW ]]
function Library:CreateWindow(title)
    local MainGui = create("ScreenGui", {
        Name = "ModularHackUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    local MainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 650, 0, 500),
        Position = UDim2.new(0.5, -325, 0.5, -250),
        BackgroundColor3 = Library.Theme.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        Parent = MainGui
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = MainFrame})
    create("UIStroke", {Color = Library.Theme.Accent, Thickness = 1.2, Transparency = 0.5, Parent = MainFrame})

    -- Sidebar
    local Sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 16),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Sidebar})

    local SidebarList = create("UIListLayout", {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Sidebar
    })
    create("UIPadding", {PaddingTop = UDim.new(0, 10), Parent = Sidebar})

    -- Content Area
    local ContentArea = create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -160, 1, -20),
        Position = UDim2.new(0, 155, 0, 10),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    -- Settings Overlay
    local SettingsOverlay = create("Frame", {
        Name = "SettingsOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Library.Theme.Main,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 50,
        Visible = false,
        Parent = ContentArea
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SettingsOverlay})

    local BackButton = create("TextButton", {
        Name = "BackButton",
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Text = "< BACK",
        TextColor3 = Library.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ZIndex = 51,
        Parent = SettingsOverlay
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = BackButton})

    local OverlayTitle = create("TextLabel", {
        Name = "OverlayTitle",
        Size = UDim2.new(1, -120, 0, 30),
        Position = UDim2.new(0, 115, 0, 10),
        BackgroundTransparency = 1,
        Text = "FEATURE SETTINGS",
        TextColor3 = Library.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 51,
        Parent = SettingsOverlay
    })

    -- Internal State
    local currentTab = nil
    local pages = {}

    local function switchTab(name)
        if currentTab == name then return end
        SettingsOverlay.Visible = false
        for n, p in pairs(pages) do p.Visible = (n == name) end
        currentTab = name
    end

    BackButton.MouseButton1Click:Connect(function()
        SettingsOverlay.Visible = false
        if currentTab and pages[currentTab] then pages[currentTab].Visible = true end
        for _, c in pairs(SettingsOverlay:GetChildren()) do
            if c:IsA("ScrollingFrame") then c.Visible = false end
        end
    end)

    -- Toggle GUI
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- API EXPORTS
    local WindowAPI = {}

    function WindowAPI:AddTab(name, icon)
        local tabBtn = create("TextButton", {
            Size = UDim2.new(0.9, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(25, 25, 26),
            Text = icon .. "  " .. name,
            TextColor3 = Library.Theme.SubText,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            Parent = Sidebar
        })
        create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = tabBtn})

        local page = create("ScrollingFrame", {
            Name = name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentArea
        })
        local grid = create("UIGridLayout", {
            CellSize = UDim2.new(0, 150, 0, 130),
            CellPadding = UDim2.new(0, 10, 0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page
        })
        grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 20)
        end)

        pages[name] = page
        tabBtn.MouseButton1Click:Connect(function() switchTab(name) end)

        if not currentTab then switchTab(name) end

        -- Page API
        local PageAPI = {}
        
        function PageAPI:AddTile(featureName, defaultState, callback)
            local tile = create("Frame", {
                BackgroundColor3 = Library.Theme.Tile,
                BorderSizePixel = 0,
                Parent = page
            })
            create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = tile})
            local stroke = create("UIStroke", {
                Color = defaultState and Library.Theme.Accent or Library.Theme.Stroke,
                Thickness = 1.5, Transparency = 0.5, Parent = tile
            })

            local btn = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = tile})
            local lbl = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0.6, 0),
                BackgroundTransparency = 1, Text = featureName, TextColor3 = Library.Theme.Text, Font = Enum.Font.GothamBold, Parent = tile
            })
            local status = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.8, 0),
                BackgroundTransparency = 1, Text = defaultState and "ENABLED" or "DISABLED",
                TextColor3 = defaultState and Color3.fromRGB(0, 255, 150) or Library.Theme.SubText,
                Font = Enum.Font.GothamBold, TextSize = 10, Parent = tile
            })

            local state = defaultState
            local function updateUI(s)
                state = s
                applyTween(stroke, {Color = state and Library.Theme.Accent or Library.Theme.Stroke})
                status.Text = state and "ENABLED" or "DISABLED"
                status.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Library.Theme.SubText
            end

            btn.MouseButton1Click:Connect(function()
                state = not state
                updateUI(state)
                callback(state)
            end)

            -- Registry for Hotkeys
            G.ConfigRegistry[featureName] = updateUI

            -- Settings Overlay Container
            local settingsContainer = create("ScrollingFrame", {
                Name = featureName .. "Settings",
                Size = UDim2.new(1, -20, 1, -60), Position = UDim2.new(0, 10, 0, 50),
                BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, Parent = SettingsOverlay
            })
            local list = create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = settingsContainer})

            btn.MouseButton2Click:Connect(function()
                OverlayTitle.Text = featureName:upper() .. " SETTINGS"
                page.Visible = false
                SettingsOverlay.Visible = true
                settingsContainer.Visible = true
            end)

            -- Tile Settings API
            local TileAPI = {}
            function TileAPI:AddToggle(toggleName, default, cb)
                local toggleFrame = create("Frame", {
                    Size = UDim2.new(0.95, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(30, 30, 32), Parent = settingsContainer
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = toggleFrame})
                
                local tBtn = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = toggleFrame})
                local tLbl = create("TextLabel", {
                    Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = toggleName .. ":", TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = toggleFrame
                })
                local tVal = create("TextLabel", {
                    Size = UDim2.new(0.3, 0, 1, 0), Position = UDim2.new(0.65, 0, 0, 0),
                    BackgroundTransparency = 1, Text = default and "ON" or "OFF",
                    TextColor3 = default and Color3.fromRGB(0, 255, 150) or Library.Theme.SubText,
                    Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = toggleFrame
                })

                local tState = default
                local function updateToggle(s)
                    tState = s
                    tVal.Text = tState and "ON" or "OFF"
                    tVal.TextColor3 = tState and Color3.fromRGB(0, 255, 150) or Library.Theme.SubText
                    cb(tState)
                end
                tBtn.MouseButton1Click:Connect(function() updateToggle(not tState) end)
                G.ConfigRegistry[toggleName] = updateToggle
            end

            function TileAPI:AddSlider(sliderName, start, stop, default, cb)
                local sliderFrame = create("Frame", {
                    Size = UDim2.new(0.95, 0, 0, 50), BackgroundColor3 = Color3.fromRGB(30, 30, 32), Parent = settingsContainer
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = sliderFrame})
                
                local sLbl = create("TextLabel", {
                    Size = UDim2.new(0.6, 0, 0, 25), Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1, Text = sliderName .. ":", TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = sliderFrame
                })
                local sVal = create("TextLabel", {
                    Size = UDim2.new(0.3, 0, 0, 25), Position = UDim2.new(0.65, 0, 0, 5),
                    BackgroundTransparency = 1, Text = tostring(default), TextColor3 = Library.Theme.Accent,
                    Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = sliderFrame
                })

                local sliderBtn = create("TextButton", {
                    Size = UDim2.new(0.9, 0, 0, 10), Position = UDim2.new(0.05, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 48), Text = "", Parent = sliderFrame
                })
                local sliderBar = create("Frame", {
                    Size = UDim2.new((default-start)/(stop-start), 0, 1, 0),
                    BackgroundColor3 = Library.Theme.Accent, Parent = sliderBtn
                })

                local function updateSlider(value)
                    local percent = math.clamp((value-start)/(stop-start), 0, 1)
                    sliderBar.Size = UDim2.new(percent, 0, 1, 0)
                    sVal.Text = tostring(math.round(value * 100) / 100)
                    cb(value)
                end

                local dragging = false
                local function move()
                    local pos = math.clamp((UserInputService:GetMouseLocation().X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
                    local val = start + (stop - start) * pos
                    updateSlider(val)
                end
                sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move() end end)
                
                G.ConfigRegistry[sliderName] = updateSlider
            end

            return TileAPI, settingsContainer
        end

        return PageAPI
    end

    return WindowAPI
end

return Library
