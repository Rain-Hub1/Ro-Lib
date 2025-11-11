local RoLib = {}
RoLib.__index = RoLib

local TweenService = game:GetService("TweenService")

function RoLib:new(className, properties)
    if self.WindowFrame and not properties.Parent then
        properties.Parent = self.WindowFrame
    end
    local inst = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        inst[prop] = value
    end
    return inst
end

function RoLib:_CreateDropdown(parent, config, theme, searchFrame)
    local isOpen = false
    local selectedOption = {Name = nil, Url = nil}

    local mainFrame = self:new("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = theme.Primary,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = parent
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = mainFrame })

    local copyLabel = self:new("TextLabel", {
        Name = "CopyLabel",
        Size = UDim2.new(1, -35, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.SourceSans,
        Text = "Select a Link",
        TextColor3 = theme.MutedText,
        TextSize = 14,
        Parent = mainFrame
    })

    self:new("Frame", {
        Name = "Separator",
        Size = UDim2.new(0, 1, 0.6, 0),
        Position = UDim2.new(1, -35, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.MutedText,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local arrowButton = self:new("ImageButton", {
        Name = "ArrowButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -17, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://74748765898106",
        Parent = mainFrame
    })

    local dropdownBody = self:new("Frame", {
        Name = "DropdownBody",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = theme.Primary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 2,
        Parent = mainFrame
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = dropdownBody })
    self:new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = dropdownBody })

    local totalHeight = 0
    for name, url in pairs(config.Url or {}) do
        totalHeight = totalHeight + 35
        local optionButton = self:new("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = theme.Primary,
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSans,
            Text = "  " .. name,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 14,
            Parent = dropdownBody
        })
        optionButton.MouseButton1Click:Connect(function()
            selectedOption.Name = name
            selectedOption.Url = url
            copyLabel.Text = name
            copyLabel.TextColor3 = theme.Text
            isOpen = true 
            arrowButton.MouseButton1Click:Fire() 
        end)
    end

    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    arrowButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen and searchFrame.Visible == false then
            searchFrame.Visible = true
            local fadeTween = TweenService:Create(searchFrame, tweenInfo, {BackgroundTransparency = 1})
            fadeTween:Play()
        end
        
        TweenService:Create(arrowButton, tweenInfo, {Rotation = isOpen and 180 or 0}):Play()
        TweenService:Create(dropdownBody, tweenInfo, {Size = isOpen and UDim2.new(1, 0, 0, totalHeight + 5) or UDim2.new(1, 0, 0, 0)}):Play()
    end)

    copyLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if selectedOption.Url then
                setclipboard(selectedOption.Url)
                copyLabel.Text = selectedOption.Name .. " Copied!"
                task.wait(2)
                copyLabel.Text = selectedOption.Name
            end
        end
    end)
end

function RoLib:_CreateSearch(parent, theme)
    local isSearchOpen = false
    local searchFrame = self:new("Frame", {
        Name = "SearchFrame",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = parent
    })

    local searchButton = self:new("ImageButton", {
        Name = "SearchButton",
        Size = UDim2.new(0, 35, 1, 0),
        Position = UDim2.new(1, -35, 0, 0),
        BackgroundColor3 = theme.Primary,
        Image = "rbxassetid://118176716068919",
        Parent = searchFrame
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = searchButton })

    local searchBox = self:new("TextBox", {
        Name = "SearchBox",
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(1, -35, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = theme.Primary,
        PlaceholderText = "Search...",
        PlaceholderColor3 = theme.MutedText,
        Font = Enum.Font.SourceSans,
        TextColor3 = theme.Text,
        TextSize = 14,
        ClipsDescendants = true,
        Parent = searchFrame
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = searchBox })

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    searchButton.MouseButton1Click:Connect(function()
        isSearchOpen = not isSearchOpen
        local goalSize = isSearchOpen and UDim2.new(1, -45, 1, 0) or UDim2.new(0, 0, 1, 0)
        local goalPos = isSearchOpen and UDim2.new(0, 0, 0, 0) or UDim2.new(1, -35, 0, 0)
        TweenService:Create(searchBox, tweenInfo, {Size = goalSize, Position = goalPos}):Play()
    end)
    return searchFrame
end

function RoLib:_KeySystem(mainWindow, config)
    local keyConfig = config.KeyS
    local theme = keyConfig.Theme or config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(20, 20, 20), Primary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(80, 80, 255), Text = Color3.fromRGB(255, 255, 255), MutedText = Color3.fromRGB(150, 150, 150) } }
    local Theme = Colors[theme]
    mainWindow.Visible = false
    local overlay = self:new("Frame", { Name = "KeyOverlay", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Colors.Darker.Background, BackgroundTransparency = 0.5, Parent = mainWindow.Parent })
    local keyWindow = self:new("Frame", { Name = "KeyWindow", Size = UDim2.fromOffset(keyConfig.Size[1], keyConfig.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = overlay })
    self:new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyWindow })
    self:new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = keyWindow })
    
    local contentFrame = self:new("Frame", { Name = "ContentFrame", Size = UDim2.new(1, -20, 1, -50), Position = UDim2.new(0.5, 0, 0, 40), AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, Parent = keyWindow })
    self:new("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = contentFrame })
    
    self:new("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.Primary, Text = keyConfig.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 18, Parent = keyWindow })

    local keyInput = self:new("TextBox", { Name = "KeyInput", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Primary, PlaceholderText = "Enter Key...", PlaceholderColor3 = Theme.MutedText, Text = "", Font = Enum.Font.SourceSans, TextColor3 = Theme.Text, TextSize = 14, ClearTextOnFocus = false, Parent = contentFrame })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyInput })

    local verifyButton = self:new("TextButton", { Name = "VerifyButton", Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Accent, Text = "VERIFY", Font = Enum.Font.SourceSansBold, TextColor3 = Theme.Text, TextSize = 16, Parent = contentFrame })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = verifyButton })

    local searchFrame = self:_CreateSearch(contentFrame, Theme)
    self:_CreateDropdown(contentFrame, keyConfig, Theme, searchFrame)

    verifyButton.MouseButton1Click:Connect(function()
        local isValid = false
        for _, validKey in ipairs(keyConfig.Key) do if keyInput.Text == validKey then isValid = true break end end
        if isValid then overlay:Destroy() mainWindow.Visible = true else
            verifyButton.Text = "INVALID KEY" verifyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(2)
            verifyButton.Text = "VERIFY" verifyButton.BackgroundColor3 = Theme.Accent
        end
    end)
end

function RoLib:Window(config)
    local self = setmetatable({}, RoLib)
    config.Size = config.Size or {410, 305}
    config.Title = config.Title or "Ro Lib"
    config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(25, 25, 25), Primary = Color3.fromRGB(35, 35, 35), Text = Color3.fromRGB(255, 255, 255) } }
    local Theme = Colors[config.Theme]
    self.ScreenGui = self:new("ScreenGui", { Name = "RoLib_Gui", ResetOnSpawn = false, Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") })
    self.WindowFrame = self:new("Frame", { Name = "Window", Size = UDim2.fromOffset(config.Size[1], config.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = self.ScreenGui })
    self:new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.WindowFrame })
    self:new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = self.WindowFrame })
    self.Tbar = self:new("Frame", { Name = "Tbar", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Primary, BorderSizePixel = 0, Parent = self.WindowFrame })
    self.Title = self:new("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = config.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 16, Parent = self.Tbar })
    local dragging, dragStart, startPos
    self.Tbar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = self.WindowFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
    self.Tbar.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then local delta = input.Position - dragStart self.WindowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    if config.Key and config.KeyS then self:_KeySystem(self.WindowFrame, config) end
    return self
end

return RoLib
