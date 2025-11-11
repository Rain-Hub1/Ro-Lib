local RoLib = {}
RoLib.__index = RoLib

local Creator = require(script.src.Utils.Creator)
local WindowComponent = require(script.src.Components.Window)
local TbarComponent = require(script.src.Components.Tbar)

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
            local success, result = pcall(function() return game:GetService("HttpService"):RequestAsync({Url = keyConfig.Webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode({key = key})}) end)
            if success and result.Success and result.Body then
                local decodedBody = game:GetService("HttpService"):JSONDecode(result.Body)
                isValid = decodedBody.valid
            end
        else
            for _, validKey in ipairs(keyConfig.Key) do if key == validKey then isValid = true; break end end
        end

        if isValid then
            overlay:Destroy()
            windowObject.WindowFrame.Visible = true
            if keyConfig.MOTD then windowObject:Notify(keyConfig.MOTD, "success", 5) end
        else
            verifyButton.Text = "INVALID KEY"
            verifyButton.BackgroundColor3 = Theme.Error
            task.wait(2)
            verifyButton.Text = "VERIFY"
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
    local demoWindow = self:Window({
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

    demoWindow:Notify("System Initialized.", "info", 4)
    
    task.wait(5)
    demoWindow:SetTitle("Dashboard")
    demoWindow:SetState("loading")
    
    task.wait(2)
    demoWindow:SetState("default")
    demoWindow:Notify("Data loaded successfully!", "success", 3)
    
    return demoWindow
end

return RoLib
