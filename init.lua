local RoLib = {}
RoLib.__index = RoLib

local Creator = {}
function Creator.new(className, properties)
    local inst = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        inst[prop] = value
    end
    return inst
end

function Creator.Drag(mainFrame, dragFrame)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
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
    config.Size = config.Size or {410, 305}
    config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(25, 25, 25), Primary = Color3.fromRGB(35, 35, 35), Text = Color3.fromRGB(255,255,255), Success = Color3.fromRGB(40, 180, 99), Info = Color3.fromRGB(52, 152, 219), Error = Color3.fromRGB(231, 76, 60) } }
    local Theme = Colors[config.Theme]
    local screenGui = Creator.new("ScreenGui", { Name = "RoLib_Gui", ResetOnSpawn = false, Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") })
    local windowFrame = Creator.new("Frame", { Name = "Window", Size = UDim2.fromOffset(config.Size[1], config.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true, Parent = screenGui })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = windowFrame })
    Creator.new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = windowFrame })
    return setmetatable({ ScreenGui = screenGui, WindowFrame = windowFrame, Theme = Theme, State = "default" }, WindowComponent)
end
function WindowComponent:SetTitle(newTitle)
    if self.Tbar and self.Tbar.Title then
        self.Tbar:SetTitle(newTitle)
    end
end
function WindowComponent:Notify(text, level, duration)
    level = level or "info"
    duration = duration or 3
    local banner = Creator.new("Frame", { Name = "NotificationBanner", Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, -30), BackgroundColor3 = self.Theme[level:sub(1,1):upper()..level:sub(2)] or self.Theme.Info, BorderSizePixel = 0, Parent = self.WindowFrame })
    Creator.new("TextLabel", { Name = "NotificationLabel", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Font = Enum.Font.SourceSans, Text = text, TextColor3 = self.Theme.Text, TextSize = 14, Parent = banner })
    game:GetService("TweenService"):Create(banner, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(duration)
    game:GetService("TweenService"):Create(banner, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, -30)}):Play()
    task.wait(0.3)
    banner:Destroy()
end
function WindowComponent:SetState(newState)
    self.State = newState
    local overlay = self.WindowFrame:FindFirstChild("StateOverlay")
    if overlay then
        overlay:Destroy()
    end
    if self.State == "loading" then
        local stateOverlay = Creator.new("Frame", { Name = "StateOverlay", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = self.Theme.Background, BackgroundTransparency = 0.2, Parent = self.WindowFrame })
        local loadingIcon = Creator.new("ImageLabel", { Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://5092958905", Parent = stateOverlay })
        game:GetService("TweenService"):Create(loadingIcon, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()
    end
end
function WindowComponent:Close()
    self.ScreenGui:Destroy()
end

local TbarComponent = {}
TbarComponent.__index = TbarComponent
function TbarComponent.new(windowObject, config)
    config.Title = config.Title or "Ro Lib"
    config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Primary = Color3.fromRGB(35, 35, 35), Text = Color3.fromRGB(255, 255, 255), Error = Color3.fromRGB(192, 57, 43) } }
    local Theme = Colors[config.Theme]
    local tbarFrame = Creator.new("Frame", { Name = "Tbar", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Primary, BorderSizePixel = 0, Parent = windowObject.WindowFrame })
    local titleLabel = Creator.new("TextLabel", { Name = "Title", Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = config.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = tbarFrame })
    local closeButton = Creator.new("TextButton", { Name = "CloseButton", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -15, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Error, Text = "X", TextColor3 = Theme.Text, Font = Enum.Font.SourceSansBold, TextSize = 14, Parent = tbarFrame })
    Creator.new("UICorner", {CornerRadius = UDim.new(1,0), Parent = closeButton})
    closeButton.MouseButton1Click:Connect(function()
        windowObject:Close()
    end)
    return setmetatable({ Tbar = tbarFrame, Title = titleLabel }, TbarComponent)
end
function TbarComponent:SetTitle(newTitle)
    self.Title.Text = newTitle
end

function RoLib:_KeySystem(windowObject, config)
    local keyConfig = config.KeyS
    local theme = keyConfig.Theme or config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(20, 20, 20), Primary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(80, 80, 255), Text = Color3.fromRGB(255, 255, 255), MutedText = Color3.fromRGB(150, 150, 150), Error = Color3.fromRGB(200, 50, 50) } }
    local Theme = Colors[theme]
    windowObject.WindowFrame.Visible = false
    local overlay = Creator.new("Frame", { Name = "KeyOverlay", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Colors.Darker.Background, BackgroundTransparency = 0.5, Parent = windowObject.ScreenGui })
    local keyWindow = Creator.new("Frame", { Name = "KeyWindow", Size = UDim2.fromOffset(keyConfig.Size[1], keyConfig.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = overlay })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyWindow })
    Creator.new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = keyWindow })
    Creator.new("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, Text = keyConfig.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 18, Parent = keyWindow })
    local keyInput = Creator.new("TextBox", { Name = "KeyInput", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0.5, 0, 0, 60), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Primary, PlaceholderText = "Enter Key...", PlaceholderColor3 = Theme.MutedText, Font = Enum.Font.SourceSans, TextColor3 = Theme.Text, TextSize = 14, Parent = keyWindow })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyInput })
    local verifyButton = Creator.new("TextButton", { Name = "VerifyButton", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0.5, 0, 0, 105), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Accent, Text = "VERIFY", Font = Enum.Font.SourceSansBold, TextColor3 = Theme.Text, TextSize = 16, Parent = keyWindow })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = verifyButton })
    verifyButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text
        local isValid = false
        if keyConfig.Webhook then
            local success, result = pcall(function()
                return game:GetService("HttpService"):RequestAsync({Url = keyConfig.Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode({key = key})})
            end)
            if success and result.Success and result.Body then
                local decodedBody = game:GetService("HttpService"):JSONDecode(result.Body)
                isValid = decodedBody.valid
            end
        else
            for _, validKey in ipairs(keyConfig.Key) do
                if key == validKey then
                    isValid = true
                    break
                end
            end
        end
        if isValid then
            overlay:Destroy()
            windowObject.WindowFrame.Visible = true
            if keyConfig.MOTD then
                windowObject:Notify(keyConfig.MOTD, "success", 5)
            end
        else
            verifyButton.Text = "Invalid key"
            verifyButton.BackgroundColor3 = Theme.Error
            task.wait(2)
            verifyButton.Text = "Verify"
            verifyButton.BackgroundColor3 = Theme.Accent
        end
    end)
end

function RoLib:Window(config)
    local windowObject = WindowComponent.new(config)
    local tbarObject = TbarComponent.new(windowObject, config)
    Creator.Drag(windowObject.WindowFrame, tbarObject.Tbar)
    windowObject.Tbar = tbarObject
    if config.Key and config.KeyS then
        self:_KeySystem(windowObject, config)
    end
    return windowObject
end

function RoLib:Demo()
    return self:Window({
        Title = "Ro Lib Sentient",
        Size = {500, 400},
        Key = true,
        KeyS = {
            Title = "Authentication Required",
            Size = {300, 220},
            Key = {"root"},
            MOTD = "Welcome, Operator."
        }
    })
end

return RoLib
