local Lib = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local function new(className, properties)
  local instance = Instance.new(className)
  for prop, value in pairs(properties or {}) do
    instance[prop] = value
  end
  return instance
end

local Theme = {
    PrimaryBg = Color3.fromRGB(28, 28, 28),      
    SecondaryBg = Color3.fromRGB(38, 38, 38),   
    TertiaryBg = Color3.fromRGB(48, 48, 48),    
    AccentColor = Color3.fromRGB(60, 140, 255), 
    AccentColorHover = Color3.fromRGB(80, 160, 255), 
    AccentColorSelected = Color3.fromRGB(40, 100, 200), 
    TextColor = Color3.fromRGB(230, 230, 230),  
    TextColorDesc = Color3.fromRGB(180, 180, 180), 
    BorderColor = Color3.fromRGB(60, 60, 60),   
    CornerRadius = UDim.new(0, 8),             
    StrokeThickness = 2,                        
    Padding = 10,                               
    TbarHeight = 35,                            
    TabWidth = 120,                             
}

function Lib:Window(Info)
  local Info = Info or {}
  local WinApp = {}
  local CoreGui = game:GetService("CoreGui")
  
  if CoreGui:FindFirstChild("RoLib") then
    CoreGui.RoLib:Destroy()
  end
  
  local s = new("ScreenGui", {
    Name = "RoLib",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
  })

  local Win = new("Frame", {
    Name = "Win",
    Size = UDim2.new(0, 480, 0, 350), 
    Position = UDim2.new(0.5, -240, 0.5, -175), 
    BackgroundColor3 = Theme.PrimaryBg,
    Parent = s
  })
  
  new("UICorner", { CornerRadius = Theme.CornerRadius, Parent = Win })
  new("UIStroke", {
    Color = Theme.BorderColor,
    Thickness = Theme.StrokeThickness,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = Win
  })

  local Tbar = new("Frame", {
    Name = "Tbar",
    Size = UDim2.new(1, 0, 0, Theme.TbarHeight),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Theme.SecondaryBg,
    Parent = Win
  })
  
  new("UICorner", { CornerRadius = Theme.CornerRadius, Parent = Tbar })
  new("UIStroke", {
    Color = Theme.BorderColor,
    Thickness = Theme.StrokeThickness,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = Tbar
  })

  local Title = new("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -60, 0, 20),
    Position = UDim2.new(0, Theme.Padding, 0, (Theme.TbarHeight - 20) / 2),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextColor,
    TextScaled = false, 
    TextSize = 16,
    Font = Enum.Font.SourceSansBold,
    Text = Info.Title or "RoLib UI",
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Tbar
  })
  
  local CloseBtn = new("TextButton", {
    Name = "CloseBtn",
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -Theme.Padding - 25, 0, (Theme.TbarHeight - 25) / 2),
    TextColor3 = Theme.TextColor,
    BackgroundColor3 = Theme.TertiaryBg, 
    Text = "X",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 18,
    Parent = Tbar
  })

  new("UICorner", { CornerRadius = Theme.CornerRadius, Parent = CloseBtn })
  new("UIStroke", {
    Color = Theme.BorderColor,
    Thickness = Theme.StrokeThickness,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = CloseBtn
  })
  
  CloseBtn.MouseButton1Click:Connect(function()
    s:Destroy()
  end)

  function WinApp:MinimizeWin(Info)
    local Info = Info or {}
    local Format = Info.Format or "Circle"
    local minimized = false
    
    local MinimizeBtn = new("TextButton", {
      Name = "MinimizeBtn",
      Size = UDim2.new(0, 40, 0, 40),
      Position = UDim2.new(0.5, -20, 1, -60),
      AnchorPoint = Vector2.new(0.5, 0),
      BackgroundColor3 = Theme.SecondaryBg,
      Text = "",
      Visible = false,
      Parent = s
    })
    
    if Format == "Circle" then
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = MinimizeBtn })
    elseif Format == "Square" then
      new("UICorner", { CornerRadius = UDim.new(0, 0), Parent = MinimizeBtn })
    elseif Format == "SquareBorder" then
      new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = MinimizeBtn })
    end
    
    new("UIStroke", {
      Color = Theme.BorderColor,
      Thickness = Theme.StrokeThickness,
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
      Parent = MinimizeBtn
    })
    
    -- Ícone dentro do botão
    local Icon = new("ImageLabel", {
      Name = "Icon",
      Size = UDim2.new(0, 24, 0, 24),
      Position = UDim2.new(0.5, -12, 0.5, -12),
      BackgroundTransparency = 1,
      Image = "rbxassetid://7734053495",
      ImageColor3 = Theme.TextColor,
      Parent = MinimizeBtn
    })
    
    -- Drag do botão minimizado
    local draggingBtn = false
    local btnDragStart = nil
    local btnStartPos = nil
    
    MinimizeBtn.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true
        btnDragStart = input.Position
        btnStartPos = MinimizeBtn.Position
        
        input.Changed:Connect(function()
          if input.UserInputState == Enum.UserInputState.End then
            draggingBtn = false
          end
        end)
      end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
      if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        MinimizeBtn.Position = UDim2.new(
          btnStartPos.X.Scale,
          btnStartPos.X.Offset + delta.X,
          btnStartPos.Y.Scale,
          btnStartPos.Y.Offset + delta.Y
        )
      end
    end)
    
    local function ToggleMinimize()
      if draggingBtn then return end
      
      minimized = not minimized
      
      local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
      
      if minimized then
        TweenService:Create(Win, tweenInfo, {
          Size = UDim2.new(0, 0, 0, 0),
          Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.3)
        Win.Visible = false
        MinimizeBtn.Visible = true
        TweenService:Create(Icon, TweenInfo.new(0.2), {Rotation = 180}):Play()
      else
        Win.Visible = true
        MinimizeBtn.Visible = false
        
        TweenService:Create(Win, tweenInfo, {
          Size = UDim2.new(0, 480, 0, 350),
          Position = UDim2.new(0.5, -240, 0.5, -175)
        }):Play()
        
        TweenService:Create(Icon, TweenInfo.new(0.2), {Rotation = 0}):Play()
      end
    end
    
    local MinimizeTbarBtn = new("TextButton", {
      Name = "MinimizeTbarBtn",
      Size = UDim2.new(0, 25, 0, 25),
      Position = UDim2.new(1, -Theme.Padding - 55, 0, (Theme.TbarHeight - 25) / 2),
      TextColor3 = Theme.TextColor,
      BackgroundColor3 = Theme.TertiaryBg,
      Text = "—",
      Font = Enum.Font.SourceSansSemibold,
      TextSize = 18,
      Parent = Tbar
    })
    
    new("UICorner", { CornerRadius = Theme.CornerRadius, Parent = MinimizeTbarBtn })
    new("UIStroke", {
      Color = Theme.BorderColor,
      Thickness = Theme.StrokeThickness,
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
      Parent = MinimizeTbarBtn
    })
    
    MinimizeTbarBtn.MouseButton1Click:Connect(ToggleMinimize)
    MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize)
    
    MinimizeBtn.MouseEnter:Connect(function()
      if not draggingBtn then
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 45, 0, 45)}):Play()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentColor}):Play()
      end
    end)
    
    MinimizeBtn.MouseLeave:Connect(function()
      if not draggingBtn then
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 40, 0, 40)}):Play()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SecondaryBg}):Play()
      end
    end)
    
    return {
      Toggle = ToggleMinimize,
      IsMinimized = function() return minimized end
    }
  end

  local dragging = false
  local dragStart = nil
  local startPos = nil

  Tbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = Win.Position
      
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end)

  game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      local delta = input.Position - dragStart
      Win.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
      )
    end
  end)
  
  local ContentFrame = new("Frame", {
    Name = "ContentFrame",
    Size = UDim2.new(1, 0, 1, -Theme.TbarHeight),
    Position = UDim2.new(0, 0, 0, Theme.TbarHeight),
    BackgroundTransparency = 1,
    Parent = Win
  })

  new("UIListLayout", {
      FillDirection = Enum.FillDirection.Horizontal, 
      HorizontalAlignment = Enum.HorizontalAlignment.Left,
      VerticalAlignment = Enum.VerticalAlignment.Top,
      Padding = UDim.new(0, Theme.Padding),
      Parent = ContentFrame
  })
  
  new("UIPadding", {
      PaddingLeft = UDim.new(0, Theme.Padding),
      PaddingRight = UDim.new(0, Theme.Padding),
      PaddingTop = UDim.new(0, Theme.Padding), 
      PaddingBottom = UDim.new(0, Theme.Padding),
      Parent = ContentFrame
  })

  local TabBar, EleScroller, TabScroller, ContentContainer
  
  local function initializeContainers()
      if TabBar then return end

      ContentContainer = new("Frame", {
          Name = "ContentContainer",
          Size = UDim2.new(1, -Theme.TabWidth - Theme.Padding, 1, 0),
          BackgroundTransparency = 1,
          Parent = ContentFrame,
          LayoutOrder = 1
      })

      EleScroller = new("ScrollingFrame", {
        Name = "EleScroller",
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundColor3 = Theme.SecondaryBg,
        BorderSizePixel = 0,
        ScrollBarThickness = 6, 
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, 
        ScrollBarImageColor3 = Theme.AccentColor,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
        Parent = ContentContainer
      })
      
      new("UICorner", { CornerRadius = Theme.CornerRadius, Parent = EleScroller })
      new("UIStroke", {
          Color = Theme.BorderColor,
          Thickness = Theme.StrokeThickness,
          ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
          Parent = EleScroller
      })

      new("UIListLayout", {
        Name = "ContentLayout",
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, Theme.Padding / 2),
        Parent = EleScroller
      })

      new("UIPadding", {
          PaddingLeft = UDim.new(0, Theme.Padding),
          PaddingRight = UDim.new(0, Theme.Padding),
          PaddingTop = UDim.new(0, Theme.Padding),
          PaddingBottom = UDim.new(0, Theme.Padding),
          Parent = EleScroller
      })

      TabBar = new("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, Theme.TabWidth, 1, 0), 
        BackgroundColor3 = Theme.SecondaryBg,
        ClipsDescendants = true,
        Parent = ContentFrame,
        LayoutOrder = 2
      })
      
      new("UICorner", { CornerRadius = Theme.CornerRadius, Parent = TabBar })
      new("UIStroke", {
          Color = Theme.BorderColor,
          Thickness = Theme.StrokeThickness,
          ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
          Parent = TabBar
      })

      TabScroller = new("ScrollingFrame", {
        Name = "TabScroller",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6, 
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, 
        ScrollBarImageColor3 = Theme.AccentColor,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right,
        Parent = TabBar
      })

      new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5), 
        Parent = TabScroller
      })

      new("UIPadding", {
          PaddingTop = UDim.new(0, Theme.Padding/2),
          PaddingBottom = UDim.new(0, Theme.Padding/2),
          Parent = TabScroller
      })
  end

  function WinApp:Tab(Info)
    local Info = Info or {}
    local TabApp = {}
    
    initializeContainers()

    local Tab = new("TextButton", {
      Name = Info.Name or "Tab",
      Size = UDim2.new(1, -Theme.Padding, 0, 30), 
      BackgroundColor3 = Theme.PrimaryBg,
      Text = Info.Name or "Tab",
      TextXAlignment = Enum.TextXAlignment.Left,
      TextWrapped = true,
      TextScaled = false,
      TextSize = 14,
      Font = Enum.Font.SourceSansSemibold,
      TextColor3 = Theme.TextColor,
      LayoutOrder = #TabScroller:GetChildren(),
      Parent = TabScroller
    })

    new("UICorner", { CornerRadius = Theme.CornerRadius - UDim.new(0, 2), Parent = Tab })
    new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = Theme.StrokeThickness,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = Tab
    })

    new("UIPadding", {
      PaddingLeft = UDim.new(0, Theme.Padding),
      PaddingRight = UDim.new(0, Theme.Padding),
      PaddingTop = UDim.new(0, 4),
      PaddingBottom = UDim.new(0, 4),
      Parent = Tab
    })

    local TabContent = new("Frame", {
        Name = Tab.Name .. "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = EleScroller,
        Visible = false
    })

    new("UIListLayout", {
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Left,
      SortOrder = Enum.SortOrder.LayoutOrder,
      Padding = UDim.new(0, Theme.Padding / 2), 
      Parent = TabContent
    })

    function TabApp:SelectTab()
      for _, child in pairs(EleScroller:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("Content") then
          child.Visible = false
        end
      end

      for _, btn in pairs(TabScroller:GetChildren()) do
        if btn:IsA("TextButton") then
          TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.PrimaryBg}):Play()
          btn.TextColor3 = Theme.TextColor
        end
      end
      
      TabContent.Visible = true
      TweenService:Create(Tab, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentColorSelected}):Play()
      Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
      
      EleScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    end

    Tab.MouseButton1Click:Connect(function()
      TabApp:SelectTab()
    end)
    
    Tab.MouseEnter:Connect(function()
        if Tab.BackgroundColor3 ~= Theme.AccentColorSelected then
            TweenService:Create(Tab, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SecondaryBg}):Play()
        end
    end)

    Tab.MouseLeave:Connect(function()
        if Tab.BackgroundColor3 ~= Theme.AccentColorSelected then
            TweenService:Create(Tab, TweenInfo.new(0.1), {BackgroundColor3 = Theme.PrimaryBg}):Play()
        end
    end)

    function TabApp:Label(Info)
      local Info = Info or {}
      
      local Title = new("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 0), 
        AutomaticSize = Enum.AutomaticSize.Y, 
        BackgroundColor3 = Theme.TertiaryBg, 
        TextColor3 = Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrap = true,
        TextWrapped = true,
        TextScaled = false,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        Text = Info.Name or "Label",
        Parent = TabContent
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Title })
      new("UIStroke", {
          Color = Theme.BorderColor,
          Thickness = Theme.StrokeThickness -1, 
          ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
          Parent = Title
      })

      new("UIPadding", {
        PaddingLeft = UDim.new(0, Theme.Padding),
        PaddingRight = UDim.new(0, Theme.Padding),
        PaddingTop = UDim.new(0, Theme.Padding / 2),
        PaddingBottom = UDim.new(0, Theme.Padding / 2),        
        Parent = Title
      })
      
      return Title
    end
    
    function TabApp:Toggle(Info)
      local Info = Info or {}
      local toggled = Info.Default or false
      
      local ToggleFrame = new("Frame", {
        Name = "Toggle",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.TertiaryBg,
        Parent = TabContent
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleFrame })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = Theme.StrokeThickness - 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = ToggleFrame
      })
      
      new("UIPadding", {
        PaddingLeft = UDim.new(0, Theme.Padding),
        PaddingRight = UDim.new(0, Theme.Padding + 50),
        PaddingTop = UDim.new(0, Theme.Padding / 2),
        PaddingBottom = UDim.new(0, Theme.Padding / 2),
        Parent = ToggleFrame
      })
      
      local TextContainer = new("Frame", {
        Name = "TextContainer",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Parent = ToggleFrame
      })
      
      new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = TextContainer
      })
      
      local ToggleName = new("TextLabel", {
        Name = "ToggleName",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextScaled = false,
        TextSize = 14,
        Font = Enum.Font.SourceSansSemibold,
        Text = Info.Name or "Toggle",
        LayoutOrder = 1,
        Parent = TextContainer
      })
      
      local ToggleDesc
      if Info.Desc and Info.Desc ~= "" then
        ToggleDesc = new("TextLabel", {
          Name = "ToggleDesc",
          Size = UDim2.new(1, 0, 0, 0),
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          TextColor3 = Theme.TextColorDesc,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Top,
          TextWrapped = true,
          TextScaled = false,
          TextSize = 12,
          Font = Enum.Font.SourceSans,
          Text = Info.Desc,
          LayoutOrder = 2,
          Parent = TextContainer
        })
      end
      
      local SwitchContainer = new("Frame", {
        Name = "SwitchContainer",
        Size = UDim2.new(0, 44, 0, 23),
        Position = UDim2.new(1, 8, 0.5, -0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = toggled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35),
        Parent = ToggleFrame
      })
      
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SwitchContainer })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = SwitchContainer
      })
      
      local SwitchCircle = new("Frame", {
        Name = "SwitchCircle",
        Size = UDim2.new(0, 18, 0, 18),
        Position = toggled and UDim2.new(1, -21, 0.5, -0) or UDim2.new(0, 3, 0.5, -0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = SwitchContainer
      })
      
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SwitchCircle })
      
      local ToggleButton = new("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = ToggleFrame
      })
      
      local function Toggle()
        toggled = not toggled
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if toggled then
          TweenService:Create(SwitchContainer, tweenInfo, {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
          TweenService:Create(SwitchCircle, tweenInfo, {Position = UDim2.new(1, -21, 0.5, -0)}):Play()
        else
          TweenService:Create(SwitchContainer, tweenInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
          TweenService:Create(SwitchCircle, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -0)}):Play()
        end
        
        if Info.Callback then
          pcall(Info.Callback, toggled)
        end
      end
      
      ToggleButton.MouseButton1Click:Connect(Toggle)
      
      ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SecondaryBg}):Play()
      end)
      
      ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.TertiaryBg}):Play()
      end)
      
      return {
        Set = function(value)
          if value ~= toggled then
            Toggle()
          end
        end,
        Get = function()
          return toggled
        end
      }
    end
    
    if #TabScroller:GetChildren() == 1 then
        TabApp:SelectTab()
    end
    
    return TabApp
  end
  return WinApp
end

function Demo()
  local Win = Lib:Window({
    Title = "Ro Lib Demo Title"
  })
  
  local MinimizeWin = Win:MinimizeWin({
    Format = "Circle"
  })
  
  local Tab1 = Win:Tab({
    Name = "Aba Principal"
  })
  
  Tab1:Label({
    Name = "Esta é uma demonstração de como o elemento Label se ajusta a um texto extremamente longo, garantindo que todo o conteúdo seja exibido corretamente através da quebra de linha automática."
  })
  
  local toggle1 = Tab1:Toggle({
    Name = "Toggle Simples",
    Desc = "Este é um toggle básico sem descrição muito longa",
    Default = false,
    Callback = function(value)
      print("Toggle 1:", value)
    end
  })

  Tab1:Toggle({
    Name = "Toggle com Texto Longo",
    Desc = "Esta é uma demonstração de como o toggle se comporta com textos extremamente longos tanto no nome quanto na descrição, garantindo que o switch permaneça sempre visível e clicável sem que o texto invada seu espaço.",
    Default = true,
    Callback = function(value)
      print("Toggle 2:", value)
    end
  })
  
  Tab1:Label({
    Name = "Este é um Label separador de Layout com um texto um pouco longo para manter a coerência visual."
  })
  
  local Tab2 = Win:Tab({
    Name = "Configurações"
  })
  
  Tab2:Label({
    Name = "Esta aba é reservada para ajustes finos e configurações avançadas do sistema."
  })

  Tab2:Toggle({
    Name = "Auto Save",
    Default = false,
    Callback = function(value)
      print("Auto Save:", value)
    end
  })

  Tab2:Toggle({
    Name = "Notificações",
    Desc = "Receba alertas sobre eventos importantes",
    Default = true,
    Callback = function(value)
      print("Notificações:", value)
    end
  })

  Tab1:Toggle({
    Name = "Notificações 2",
    Desc = "Receba alertas sobre eventos importantes",
    Default = true,
    Callback = function(value)
      print("Notificações:", value)
    end
  })
  
  Tab1:SelectTab()
end
Demo()

return Lib
