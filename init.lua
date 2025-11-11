local RoLib = {}
RoLib.__index = RoLib

local Creator = require(script.src.Utils.Creator)
local WindowComponent = require(script.src.Components.Window)
local TbarComponent = require(script.src.Components.Tbar)

function RoLib:new(className, properties)
    return Creator.new(className, properties)
end

function RoLib:_KeySystem(mainWindow, config)
    local keyConfig = config.KeyS
    local theme = keyConfig.Theme or config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(20, 20, 20), Primary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(80, 80, 255), Text = Color3.fromRGB(255, 255, 255), MutedText = Color3.fromRGB(150, 150, 150) } }
    local Theme = Colors[theme]
    mainWindow.Visible = false
    local overlay = Creator.new("Frame", { Name = "KeyOverlay", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Colors.Darker.Background, BackgroundTransparency = 0.5, Parent = mainWindow.Parent })
    local keyWindow = Creator.new("Frame", { Name = "KeyWindow", Size = UDim2.fromOffset(keyConfig.Size[1], keyConfig.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = overlay })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyWindow })
    Creator.new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = keyWindow })
    Creator.new("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Primary, Text = keyConfig.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 18, Parent = keyWindow })
    local keyInput = Creator.new("TextBox", { Name = "KeyInput", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0.5, 0, 0, 60), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Primary, PlaceholderText = "Enter Key...", PlaceholderColor3 = Theme.MutedText, Font = Enum.Font.SourceSans, TextColor3 = Theme.Text, TextSize = 14, Parent = keyWindow })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyInput })
    local verifyButton = Creator.new("TextButton", { Name = "VerifyButton", Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0.5, 0, 0, 105), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Theme.Accent, Text = "VERIFY", Font = Enum.Font.SourceSansBold, TextColor3 = Theme.Text, TextSize = 16, Parent = keyWindow })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = verifyButton })
    local urlContainer = Creator.new("Frame", { Name = "UrlContainer", Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0.5, 0, 1, -15), AnchorPoint = Vector2.new(0.5, 1), BackgroundTransparency = 1, Parent = keyWindow })
    Creator.new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 10), Parent = urlContainer })
    for name, url in pairs(keyConfig.Url or {}) do
        local urlButton = Creator.new("TextButton", { Name = name, Size = UDim2.new(0.45, 0, 1, 0), BackgroundColor3 = Theme.Primary, Text = name, Font = Enum.Font.SourceSans, TextColor3 = Theme.MutedText, TextSize = 14, Parent = urlContainer })
        Creator.new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = urlButton })
        urlButton.MouseButton1Click:Connect(function() setclipboard(url) urlButton.Text = "Copied!" task.wait(2) urlButton.Text = name end)
    end
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
    local windowObjects = WindowComponent.new(config)
    local tbarObjects = TbarComponent.new(windowObjects.WindowFrame, config)
    Creator.Drag(windowObjects.WindowFrame, tbarObjects.Tbar)
    self.ScreenGui = windowObjects.ScreenGui
    self.WindowFrame = windowObjects.WindowFrame
    self.Tbar = tbarObjects.Tbar
    self.Title = tbarObjects.Title
    if config.Key and config.KeyS then
        self:_KeySystem(self.WindowFrame, config)
    end
    return self
end

function RoLib:Demo()
    return self:Window({
        Title = "Demo Title",
        Size = {410, 305},
        Key = true,
        KeyS = {
            Title = "Key System Demo Title",
            Size = {250, 200},
            Key = {"Demo key", "Other demo key"},
            Url = {
                ["Google"] = "https://google.com",
                ["Github"] = "https://github.com"
            },
            Theme = "Darker"
        },
        Theme = "Darker"
    })
end

return RoLib
