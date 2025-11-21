local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local RoLib = {}

local function new(className, properties)
    local instance = Instance.new(className)
    for prop, value in properties do
        instance[prop] = value
    end
    instance.Parent = properties.Parent
    return instance
end

local tweenInfo = TweenInfo.new(
    0.2,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

function RoLib:Window(config)
    local coreGui = game:GetService("CoreGui")

    local screenGui = new("ScreenGui", {
        Name = (config.Title or "Untitled"):gsub("[^%w_]", "_") .. "_UI",
        ResetOnSpawn = false,
        Parent = coreGui,
    })

    local mainFrame = new("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, config.Size[1], 0, config.Size[2]),
        Position = UDim2.new(0.5, -config.Size[1] / 2, 0.5, -config.Size[2] / 2), 
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = screenGui,
    })

    new("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = mainFrame,
    })

    local titleBar = new("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = mainFrame,
    })

    new("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = titleBar,
    })

    new("Frame", {
        BorderSizePixel = 0,
        BackgroundColor3 = titleBar.BackgroundColor3,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        Parent = titleBar,
    })

    new("TextLabel", {
        Name = "Title",
        Text = config.Title or "Demo title",
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    })

    local closeButton = new("ImageButton", {
        Name = "CloseButton",
        Image = "rbxassetid://10747384394",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -28, 0.5, -10),
        BackgroundTransparency = 1,
        Parent = titleBar,
    })

    local minimizeButton = new("ImageButton", {
        Name = "MinimizeButton",
        Image = "rbxassetid://10723435342",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundTransparency = 1,
        Parent = titleBar,
    })

    local contentFrame = new("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        Parent = mainFrame,
    })

    new("TextLabel", {
        Text = "Conteúdo Principal",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = contentFrame,
    })

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    minimizeButton.MouseButton1Click:Connect(function()
        local isCurrentlyMinimized = mainFrame.Size.Y.Offset == 35

        if not isCurrentlyMinimized then
            local minimizedSize = UDim2.new(0, config.Size[1], 0, 35)
            local minimizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = minimizedSize})
            
            contentFrame.Visible = false 
            minimizeButton.Image = "rbxassetid://10723435261"
            
            minimizeTween:Play()
        else
            local maximizedSize = UDim2.new(0, config.Size[1], 0, config.Size[2])
            local maximizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = maximizedSize})
            
            maximizeTween:Play()
            maximizeTween.Completed:Wait() 
            
            contentFrame.Visible = true 
            minimizeButton.Image = "rbxassetid://10723435342"
        end
    end)
    
    return mainFrame
end

return RoLib
