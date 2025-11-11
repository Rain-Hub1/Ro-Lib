local Tbar = {}

local Creator = require(script.Parent.Parent.Utils.Creator)

function Tbar.new(parent, config)
    config.Title = config.Title or "Ro Lib"
    config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Primary = Color3.fromRGB(35, 35, 35), Text = Color3.fromRGB(255, 255, 255) } }
    local Theme = Colors[config.Theme]

    local tbarFrame = Creator.new("Frame", { Name = "Tbar", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Primary, BorderSizePixel = 0, Parent = parent })
    local titleLabel = Creator.new("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = config.Title, Font = Enum.Font.SourceSansSemibold, TextColor3 = Theme.Text, TextSize = 16, Parent = tbarFrame })
    
    return {
        Tbar = tbarFrame,
        Title = titleLabel
    }
end

return Tbar
