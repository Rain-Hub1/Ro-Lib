local Window = {}

local Creator = require(script.Parent.Parent.Utils.Creator)

function Window.new(config)
    config.Size = config.Size or {410, 305}
    config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(25, 25, 25), Primary = Color3.fromRGB(35, 35, 35) } }
    local Theme = Colors[config.Theme]

    local screenGui = Creator.new("ScreenGui", { Name = "RoLib_Gui", ResetOnSpawn = false, Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") })
    local windowFrame = Creator.new("Frame", { Name = "Window", Size = UDim2.fromOffset(config.Size[1], config.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, Parent = screenGui })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = windowFrame })
    Creator.new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = windowFrame })
    
    return {
        ScreenGui = screenGui,
        WindowFrame = windowFrame
    }
end

return Window
