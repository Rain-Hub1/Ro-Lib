local RoLib = {}
RoLib.__index = RoLib

local function CreateNew(className, properties)
    local inst = Instance.new(className)
    for prop, value in pairs(properties or {}) do inst[prop] = value end
    return inst
end

local function ApplyDrag(mainFrame, dragFrame)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = mainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragFrame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local WindowComponent = {}
WindowComponent.__index = WindowComponent
function WindowComponent.new(config)
    config.Size = config.Size or {410, 305}; config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(25, 25, 25), Primary = Color3.fromRGB(35, 35, 35) } }; local Theme = Colors[config.Theme]
    local screenGui = CreateNew("ScreenGui", { Name = "RoLib_Gui", ResetOnSpawn = false, Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") })
    local windowFrame = CreateNew("Frame", { Name = "Window", Size = UDim2.fromOffset(config.Size[1], config.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = screenGui })
    CreateNew("UICorner", { CornerRadius = UDim.new(0, 6), Parent = windowFrame }); CreateNew("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = windowFrame })
    return setmetatable({ ScreenGui = screenGui, WindowFrame = windowFrame }, WindowComponent)
end
function WindowComponent:SetTitle(newTitle) if self.Tbar and self.Tbar.Title then self.Tbar:SetTitle(newTitle) end end

local TbarComponent = {}
TbarComponent.__index = TbarComponent
function TbarComponent.new(parent, config)
    config.Title = config.Title or "Ro Lib"; config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Primary = Color3.fromRGB(35, 35, 35), Text = Color3.fromRGB(255, 255, 255) } }; local Theme = Colors[config.Theme]
    local tbarFrame = CreateNew("Frame", { Name = "Tbar", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Primary, BorderSizePixel = 0, Parent = parent })
    local titleLabel = CreateNew("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = config.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 16, Parent = tbarFrame })
    return setmetatable({ Tbar = tbarFrame, Title = titleLabel }, TbarComponent)
end
function TbarComponent:SetTitle(newTitle) self.Title.Text = newTitle end

function RoLib:_KeySystem(mainWindow, config)
    local keyConfig = config.KeyS; local theme = keyConfig.Theme or config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(20, 20, 20), Primary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(80, 80, 255), Text = Color3.fromRGB(255, 255, 255), MutedText = Color3.fromRGB(150, 150, 150) } }; local Theme = Colors[theme]
    mainWindow.Visible = false
    local overlay = CreateNew("Frame", { Name = "KeyOverlay", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Colors.Darker.Background, BackgroundTransparency = 0.5, Parent = mainWindow.Parent })
    local keyWindow = CreateNew("Frame", { Name = "KeyWindow", Size = UDim2.fromOffset(keyConfig.Size[1], keyConfig.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = overlay })
    CreateNew("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyWindow }); CreateNew("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = keyWindow })
    CreateNew("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, Text = keyConfig.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 18, Parent = keyWindow })
    local keyInput = CreateNew("TextBox", { Name = "KeyInput", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0.5, 0, 0, 60), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Primary, PlaceholderText = "Enter Key...", PlaceholderColor3 = Theme.MutedText, Font = Enum.Font.SourceSans, TextColor3 = Theme.Text, TextSize = 14, Parent = keyWindow })
    CreateNew("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyInput })
    local verifyButton = CreateNew("TextButton", { Name = "VerifyButton", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0.5, 0, 0, 105), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Accent, Text = "VERIFY", Font = Enum.Font.SourceSansBold, TextColor3 = Theme.Text, TextSize = 16, Parent = keyWindow })
    CreateNew("UICorner", { CornerRadius = UDim.new(0, 4), Parent = verifyButton })
    local urlContainer = CreateNew("Frame", { Name = "UrlContainer", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0.5, 0, 1, -15), AnchorPoint = Vector2.new(0.5, 1), BackgroundTransparency = 1, Parent = keyWindow })
    CreateNew("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 10), Parent = urlContainer })
    for name, url in pairs(keyConfig.Url or {}) do
        local urlButton = CreateNew("TextButton", { Name = name, Size = UDim2.new(0.45, 0, 1, 0), BackgroundColor3 = Theme.Primary, Text = name, Font = Enum.Font.SourceSans, TextColor3 = Theme.MutedText, TextSize = 14, Parent = urlContainer })
        CreateNew("UICorner", { CornerRadius = UDim.new(0, 4), Parent = urlButton })
        urlButton.MouseButton1Click:Connect(function() setclipboard(url); urlButton.Text = "Copied!"; task.wait(2); urlButton.Text = name end)
    end
    verifyButton.MouseButton1Click:Connect(function()
        local isValid = false; for _, validKey in ipairs(keyConfig.Key) do if keyInput.Text == validKey then isValid = true; break end end
        if isValid then overlay:Destroy(); mainWindow.Visible = true else
            verifyButton.Text = "INVALID KEY"; verifyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50); task.wait(2)
            verifyButton.Text = "VERIFY"; verifyButton.BackgroundColor3 = Theme.Accent
        end
    end)
end

function RoLib:Window(config)
    local windowObject = WindowComponent.new(config)
    local tbarObject = TbarComponent.new(windowObject.WindowFrame, config)
    ApplyDrag(windowObject.WindowFrame, tbarObject.Tbar)
    windowObject.Tbar = tbarObject
    if config.Key and config.KeyS then self:_KeySystem(windowObject.WindowFrame, config) end
    return windowObject
end

function RoLib:Demo()
    return self:Window({
        Title = "Demo Title",
        Size = {410, 305},
        Key = true,
        KeyS = {
            Title = "Key System Demo Title",
            Size = {250, 200}, Key = {"Demo key", "Other demo key"},
            Url = { ["Google"] = "https://google.com",
            ["Github"] = "https://github.com" },
            Theme = "Darker"
        },
        Theme = "Darker"
    })
end

return RoLib
