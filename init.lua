local RoLib = {}
RoLib.__index = RoLib

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local IconsURL = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
local Icons = loadstring(game:HttpGetAsync and game:HttpGetAsync(IconsURL) or HttpService:GetAsync(IconsURL))()
Icons.SetIconsType("lucide")

local Creator = {
    Font = "rbxassetid://12187365364",
    Theme = nil,
    Themes = nil,
    Icons = Icons,
    Signals = {},
    Objects = {},
    Request = http_request or (syn and syn.request) or request,
    DefaultProperties = {
        ScreenGui = {ResetOnSpawn = false, ZIndexBehavior = "Sibling"},
        Frame = {BorderSizePixel = 0, BackgroundColor3 = Color3.new(1,1,1)},
        TextLabel = {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Text = "", RichText = true, TextColor3 = Color3.new(1,1,1), TextSize = 14},
        TextButton = {BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Text = "", AutoButtonColor= false, TextColor3 = Color3.new(1,1,1), TextSize = 14},
        TextBox = {BackgroundColor3 = Color3.new(1, 1, 1), BorderColor3 = Color3.new(0, 0, 0), ClearTextOnFocus = false, Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14},
        ImageLabel = {BackgroundTransparency = 1, BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0},
        ImageButton = {BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, AutoButtonColor = false},
        UIListLayout = {SortOrder = "LayoutOrder"},
        ScrollingFrame = {ScrollBarImageTransparency = 1, BorderSizePixel = 0},
    },
    ThemeFallbacks = {
        White = Color3.new(1,1,1), Black = Color3.new(0,0,0), Dialog = "Accent", Background = "Accent", WindowBackground = "Background",
        WindowShadow = "Black", WindowTopbarTitle = "Text", TabBackground = "Hover", TabTitle = "Text", TabIcon = "Icon",
        ElementBackground = "Text", ElementTitle = "Text", ElementDesc = "Text", ElementIcon = "Icon", Toggle = "Button", Checkbox = "Button", CheckboxIcon = "White",
    }
}

function Creator.New(Name, Properties, Children)
    local Object = Instance.new(Name)
    for Name, Value in next, Creator.DefaultProperties[Name] or {} do
        Object[Name] = Value
    end
    for Name, Value in next, Properties or {} do
        if Name ~= "ThemeTag" then
            Object[Name] = Value
        end
    end
    for _, Child in next, Children or {} do
        Child.Parent = Object
    end
    if Properties and Properties.ThemeTag then
        RoLib.AddThemeObject(Object, Properties.ThemeTag)
    end
    return Object
end

function Creator.Tween(Object, Time, Properties, ...)
    return TweenService:Create(Object, TweenInfo.new(Time, ...), Properties)
end

function Creator.Drag(mainFrame, dragFrames)
    local dragging, dragStart, startPos
    if not dragFrames or typeof(dragFrames) ~= "table" then
        dragFrames = {mainFrame}
    end
    local function update(input)
        if not dragging then return end
        local delta = input.Position - dragStart
        Creator.Tween(mainFrame, 0.02, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end
    for _, dragFrame in pairs(dragFrames) do
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
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end
end

Icons.Init(Creator.New, "Icon")

local function KeySystem(Config, func)
    local EnteredKey
    local screenGui = Creator.New("ScreenGui", {Name = "KeySystemGui", ZIndexBehavior = "Sibling", ResetOnSpawn = false, Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")})
    local overlay = Creator.New("Frame", {Name = "Overlay", Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.5, Parent = screenGui})
    local mainDialog = Creator.New("Frame", {Name = "MainDialog", Size = UDim2.new(0, 430, 0, 0), AutomaticSize = "Y", Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromHex("#101010"), Parent = overlay})
    Creator.New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = mainDialog})
    
    local mainFrame = Creator.New("Frame", {Name = "MainFrame", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = mainDialog})
    local mainLayout = Creator.New("UIListLayout", {Padding = UDim.new(0, 18), FillDirection = "Vertical", Parent = mainFrame})
    Creator.New("UIPadding", {PaddingTop = UDim.new(0, 16), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16), Parent = mainFrame})

    local title = Creator.New("TextLabel", {Text = Config.Title, FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold), TextSize = 20, TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, AutomaticSize = "XY", Parent = mainFrame})
    
    if Config.KeySystem.Note and Config.KeySystem.Note ~= "" then
        Creator.New("TextLabel", {Size = UDim2.new(1,0,0,0), AutomaticSize = "Y", FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium), TextXAlignment = "Left", Text = Config.KeySystem.Note, TextSize = 18, TextTransparency = .4, TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, RichText = true, TextWrapped = true, Parent = mainFrame})
    end

    local inputFrame = Creator.New("Frame", {Name = "InputFrame", Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Color3.fromHex("#18181b"), Parent = mainFrame})
    Creator.New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = inputFrame})
    local inputBox = Creator.New("TextBox", {Name = "Input", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, PlaceholderText = "Enter Key", PlaceholderColor3 = Color3.fromHex("#7a7a7a"), Text = "", TextColor3 = Color3.new(1,1,1), TextSize = 14, Parent = inputFrame})
    inputBox:GetPropertyChangedSignal("Text"):Connect(function() EnteredKey = inputBox.Text end)

    local buttonsContainer = Creator.New("Frame", {Size = UDim2.new(1,0,0,42), BackgroundTransparency = 1, Parent = mainFrame})
    local buttonsLayout = Creator.New("UIListLayout", {Padding = UDim.new(0, 9), FillDirection = "Horizontal", Parent = buttonsContainer})

    local function createButton(text, icon, callback, variant, parent)
        local btn = Creator.New("TextButton", {Name = text, Size = UDim2.new(1, 0, 1, 0), AutomaticSize = "X", BackgroundColor3 = (variant == "Primary" and Color3.fromHex("#52525b") or Color3.fromHex("#18181b")), Text = text, TextColor3 = Color3.new(1,1,1), FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium), Parent = parent})
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
        Creator.New("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = btn})
        if callback then btn.MouseButton1Click:Connect(callback) end
        return btn
    end

    createButton("Exit", "log-out", function() screenGui:Destroy() end, "Tertiary", buttonsContainer)
    if Config.KeySystem.URL then
        createButton("Get Key", "key", function() setclipboard(Config.KeySystem.URL) end, "Secondary", buttonsContainer)
    end

    local submitButton = createButton("Submit", "arrow-right", nil, "Primary", buttonsContainer)
    submitButton.LayoutOrder = 99
    buttonsLayout.HorizontalAlignment = "Right"

    local function handleSuccess(key)
        screenGui:Destroy()
        if Config.KeySystem.SaveKey then
            writefile((Config.Folder or "RoLib") .. "/" .. (Config.Title or "Default") .. ".key", tostring(key))
        end
        task.wait(0.4)
        func(true)
    end

    submitButton.MouseButton1Click:Connect(function()
        local key = tostring(EnteredKey or "empty")
        local isKey = type(Config.KeySystem.Key) == "table" and table.find(Config.KeySystem.Key, key) or Config.KeySystem.Key == key
        if isKey then
            handleSuccess(key)
        else
            RoLib:Notify({Title = "Key System: Error", Content = "Invalid key.", Icon = "triangle-alert"})
        end
    end)
end

function RoLib:Notify(Config)
    local screenGui = Creator.New("ScreenGui", {Name = "NotificationGui", ZIndexBehavior = "Sibling", ResetOnSpawn = false, Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")})
    local notificationFrame = Creator.New("Frame", {Name = "Notification", Size = UDim2.new(0, 300, 0, 60), Position = UDim2.new(1, 20, 1, -80), AnchorPoint = Vector2.new(1, 1), BackgroundColor3 = Color3.fromHex("#18181b"), Parent = screenGui})
    Creator.New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = notificationFrame})
    Creator.New("TextLabel", {Name = "Title", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Text = Config.Title or "Notification", TextColor3 = Color3.new(1,1,1), TextXAlignment = "Left", FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold), Parent = notificationFrame})
    Creator.New("TextLabel", {Name = "Content", Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Text = Config.Content or "", TextColor3 = Color3.fromHex("#a1a1aa"), TextXAlignment = "Left", Parent = notificationFrame})
    
    local showTween = Creator.Tween(notificationFrame, 0.3, {Position = UDim2.new(1, -20, 1, -80)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local hideTween = Creator.Tween(notificationFrame, 0.3, {Position = UDim2.new(1, 20, 1, -80)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    
    showTween:Play()
    task.wait((Config.Duration or 5) + 0.3)
    hideTween:Play()
    hideTween.Completed:Wait()
    screenGui:Destroy()
end

function RoLib:Window(config)
    local self = setmetatable({}, RoLib)
    
    local function onReady()
        local screenGui = Creator.New("ScreenGui", {Name = "RoLib_UI", Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")})
        local windowFrame = Creator.New("Frame", {Name = "Window", Size = UDim2.fromOffset(config.Size[1], config.Size[2]), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromHex("#101010"), Parent = screenGui})
        Creator.New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = windowFrame})
        
        local tbar = Creator.New("Frame", {Name = "Tbar", Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromHex("#18181b"), Parent = windowFrame})
        Creator.New("TextLabel", {Name = "Title", Size = UDim2.new(1, 0, 1, 0), Text = config.Title or "Ro Lib", TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, Parent = tbar})
        
        Creator.Drag(windowFrame, {tbar})
        
        self.Window = windowFrame
        self.ScreenGui = screenGui
    end

    if config.KeySystem and config.KeySystem.Enabled then
        KeySystem(config, onReady)
    else
        onReady()
    end

    return self
end

function RoLib:Demo()
    return self:Window({
        Title = "Ro Lib Assimilated",
        Size = {500, 400},
        KeySystem = {
            Enabled = true,
            Title = "Authentication",
            Note = "Please enter your key to continue.",
            URL = "https://your-key-system.com/get-key",
            Key = {"root"}
        }
    })
end

return RoLib
