local RoLib = {}
RoLib.__index = RoLib

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

function RoLib:_KeySystem(mainWindow, config)
    local keyConfig = config.KeyS
    local theme = keyConfig.Theme or config.Theme or "Darker"
    local Colors = {
        Darker = {
            Background = Color3.fromRGB(20, 20, 20),
            Primary = Color3.fromRGB(30, 30, 30),
            Accent = Color3.fromRGB(80, 80, 255),
            Text = Color3.fromRGB(255, 255, 255),
            MutedText = Color3.fromRGB(150, 150, 150)
        }
    }
    local Theme = Colors[theme]
    mainWindow.Visible = false
    local overlay = self:new("Frame", {
        Name = "KeyOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Colors.Darker.Background,
        BackgroundTransparency = 0.5,
        Parent = mainWindow.Parent
    })
    local keyWindow = self:new("Frame", {
        Name = "KeyWindow",
        Size = UDim2.fromOffset(keyConfig.Size[1], keyConfig.Size[2]),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = overlay
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyWindow })
    self:new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = keyWindow })
    self:new("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Primary,
        Text = keyConfig.Title,
        Font = Enum.Font.SourceSansSemibold,
        TextColor3 = Theme.Text,
        TextSize = 18,
        Parent = keyWindow
    })
    local keyInput = self:new("TextBox", {
        Name = "KeyInput",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0.5, 0, 0, 60),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme.Primary,
        PlaceholderText = "Enter Key...",
        PlaceholderColor3 = Theme.MutedText,
        Text = "",
        Font = Enum.Font.SourceSans,
        TextColor3 = Theme.Text,
        TextSize = 14,
        ClearTextOnFocus = false,
        Parent = keyWindow
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyInput })
    local verifyButton = self:new("TextButton", {
        Name = "VerifyButton",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0.5, 0, 0, 105),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme.Accent,
        Text = "VERIFY",
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Theme.Text,
        TextSize = 16,
        Parent = keyWindow
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = verifyButton })
    local urlContainer = self:new("Frame", {
        Name = "UrlContainer",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0.5, 0, 1, -15),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Parent = keyWindow
    })
    self:new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = urlContainer
    })
    local order = 0
    for name, url in pairs(keyConfig.Url or {}) do
        order = order + 1
        local urlButton = self:new("TextButton", {
            Name = name,
            Size = UDim2.new(0.45, 0, 1, 0),
            BackgroundColor3 = Theme.Primary,
            Text = name,
            Font = Enum.Font.SourceSans,
            TextColor3 = Theme.MutedText,
            TextSize = 14,
            LayoutOrder = order,
            Parent = urlContainer
        })
        self:new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = urlButton })
        urlButton.MouseButton1Click:Connect(function()
            setclipboard(url)
            urlButton.Text = "Copied!"
            task.wait(2)
            urlButton.Text = name
        end)
    end
    verifyButton.MouseButton1Click:Connect(function()
        local inputKey = keyInput.Text
        local isValid = false
        for _, validKey in ipairs(keyConfig.Key) do
            if inputKey == validKey then
                isValid = true
                break
            end
        end
        if isValid then
            overlay:Destroy()
            mainWindow.Visible = true
        else
            verifyButton.Text = "INVALID KEY"
            verifyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(2)
            verifyButton.Text = "VERIFY"
            verifyButton.BackgroundColor3 = Theme.Accent
        end
    end)
end

function RoLib:Window(config)
    local self = setmetatable({}, RoLib)
    config.Size = config.Size or {410, 305}
    config.Title = config.Title or "Ro Lib"
    config.Theme = config.Theme or "Darker"
    local Colors = {
        Darker = {
            Background = Color3.fromRGB(25, 25, 25),
            Primary = Color3.fromRGB(35, 35, 35),
            Text = Color3.fromRGB(255, 255, 255)
        }
    }
    local Theme = Colors[config.Theme]
    self.ScreenGui = self:new("ScreenGui", {
        Name = "RoLib_Gui",
        ResetOnSpawn = false,
        Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    })
    self.WindowFrame = self:new("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(config.Size[1], config.Size[2]),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    self:new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = self.WindowFrame })
    self:new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = self.WindowFrame })
    self.Tbar = self:new("Frame", {
        Name = "Tbar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = self.WindowFrame
    })
    self.Title = self:new("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Title,
        Font = Enum.Font.SourceSansSemibold,
        TextColor3 = Theme.Text,
        TextSize = 16,
        Parent = self.Tbar
    })
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    self.Tbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.WindowFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.Tbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                self.WindowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    if config.Key and config.KeyS then
        self:_KeySystem(self.WindowFrame, config)
    end
    return self
end

return RoLib
