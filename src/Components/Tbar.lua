local Tbar = {}
Tbar.__index = Tbar

local Creator = require(script.Parent.Parent.Utils.Creator)

function Tbar.new(windowObject, config)
    config.Title = config.Title or "Ro Lib"
    config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Primary = Color3.fromRGB(35, 35, 35), Text = Color3.fromRGB(255, 255, 255), Error = Color3.fromRGB(192, 57, 43) } }
    local Theme = Colors[config.Theme]

    local tbarFrame = Creator.new("Frame", { Name = "Tbar", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Primary, BorderSizePixel = 0, Parent = windowObject.WindowFrame })
    local titleLabel = Creator.new("TextLabel", { Name = "Title", Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = config.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = tbarFrame })
    
    local closeButton = Creator.new("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Error,
        Text = "X",
        TextColor3 = Theme.Text,
        Font = Enum.Font.SourceSansBold,
        TextSize = 14,
        Parent = tbarFrame
    })
    Creator.new("UICorner", {CornerRadius = UDim.new(1,0), Parent = closeButton})
    closeButton.MouseButton1Click:Connect(function() windowObject:Close() end)

    local self = setmetatable({
        Tbar = tbarFrame,
        Title = titleLabel
    }, Tbar)

    return self
end

function Tbar:SetTitle(newTitle)
    self.Title.Text = newTitle
end

return Tbar
