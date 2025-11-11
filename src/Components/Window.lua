local Window = {}
Window.__index = Window

local Creator = require(script.Parent.Parent.Utils.Creator)

function Window.new(config)
    config.Size = config.Size or {410, 305}
    config.Theme = config.Theme or "Darker"
    local Colors = { Darker = { Background = Color3.fromRGB(25, 25, 25), Primary = Color3.fromRGB(35, 35, 35), Text = Color3.fromRGB(255,255,255), Success = Color3.fromRGB(40, 180, 99), Info = Color3.fromRGB(52, 152, 219), Error = Color3.fromRGB(231, 76, 60) } }
    local Theme = Colors[config.Theme]

    local screenGui = Creator.new("ScreenGui", { Name = "RoLib_Gui", ResetOnSpawn = false, Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") })
    local windowFrame = Creator.new("Frame", { Name = "Window", Size = UDim2.fromOffset(config.Size[1], config.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true, Parent = screenGui })
    Creator.new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = windowFrame })
    Creator.new("UIStroke", { Color = Theme.Primary, Thickness = 2, Parent = windowFrame })
    
    local self = setmetatable({
        ScreenGui = screenGui,
        WindowFrame = windowFrame,
        Theme = Theme,
        State = "default"
    }, Window)
    
    return self
end

function Window:SetTitle(newTitle)
    if self.Tbar and self.Tbar.Title then
        self.Tbar:SetTitle(newTitle)
    end
end

function Window:Notify(text, level, duration)
    level = level or "info"
    duration = duration or 3
    
    local banner = Creator.new("Frame", {
        Name = "NotificationBanner",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, -30),
        BackgroundColor3 = self.Theme[level:sub(1,1):upper()..level:sub(2)] or self.Theme.Info,
        BorderSizePixel = 0,
        Parent = self.WindowFrame
    })
    local label = Creator.new("TextLabel", {
        Name = "NotificationLabel",
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Font = Enum.Font.SourceSans,
        Text = text,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Parent = banner
    })
    
    game:GetService("TweenService"):Create(banner, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(duration)
    game:GetService("TweenService"):Create(banner, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, -30)}):Play()
    task.wait(0.3)
    banner:Destroy()
end

function Window:SetState(newState)
    self.State = newState
    
    local overlay = self.WindowFrame:FindFirstChild("StateOverlay")
    if overlay then overlay:Destroy() end

    if self.State == "loading" then
        local stateOverlay = Creator.new("Frame", {
            Name = "StateOverlay",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = self.Theme.Background,
            BackgroundTransparency = 0.2,
            Parent = self.WindowFrame
        })
        local loadingIcon = Creator.new("ImageLabel", {
            Size = UDim2.new(0, 40, 0, 40),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://5092958905", -- Exemplo de ícone de loading
            Parent = stateOverlay
        })
        game:GetService("TweenService"):Create(loadingIcon, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()
    end
end

function Window:Close()
    self.ScreenGui:Destroy()
end

return Window
