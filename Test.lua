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
    
    local Icon = new("ImageLabel", {
      Name = "Icon",
      Size = UDim2.new(0, 24, 0, 24),
      Position = UDim2.new(0.5, -12, 0.5, -12),
      BackgroundTransparency = 1,
      Image = "rbxassetid://7734053495",
      ImageColor3 = Theme.TextColor,
      Parent = MinimizeBtn
    })
    
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
      Size = UDim2.new(1, -Theme.Padding, 0, 0), 
      AutomaticSize = Enum.AutomaticSize.Y,
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
      PaddingTop = UDim.new(0, 6),
      PaddingBottom = UDim.new(0, 6),
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
        PaddingRight = UDim.new(0, Theme.Padding + 40),
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
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, 6, 0.5, -0),
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
        Size = UDim2.new(0, 14, 0, 14),
        Position = toggled and UDim2.new(1, -16, 0.5, -0) or UDim2.new(0, 2, 0.5, -0),
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
      
      local currentCallback = Info.Callback
      
      local function Toggle()
        toggled = not toggled
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if toggled then
          TweenService:Create(SwitchContainer, tweenInfo, {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
          TweenService:Create(SwitchCircle, tweenInfo, {Position = UDim2.new(1, -16, 0.5, -0)}):Play()
        else
          TweenService:Create(SwitchContainer, tweenInfo, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
          TweenService:Create(SwitchCircle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -0)}):Play()
        end
        
        if currentCallback then
          pcall(currentCallback, toggled)
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
        SetDefault = function(value)
          if value ~= toggled then
            Toggle()
          end
        end,
        SetName = function(text)
          ToggleName.Text = text
        end,
        SetDesc = function(text)
          if not ToggleDesc then
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
              Text = text,
              LayoutOrder = 2,
              Parent = TextContainer
            })
          else
            ToggleDesc.Text = text
          end
        end,
        SetCallback = function(callback)
          currentCallback = callback
        end,
        Get = function()
          return toggled
        end
      }
    end
    
    function TabApp:Button(Info)
      local Info = Info or {}
      
      local ButtonFrame = new("Frame", {
        Name = "Button",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.TertiaryBg,
        Parent = TabContent
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ButtonFrame })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = Theme.StrokeThickness - 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = ButtonFrame
      })
      
      new("UIPadding", {
        PaddingLeft = UDim.new(0, Theme.Padding),
        PaddingRight = UDim.new(0, Theme.Padding),
        PaddingTop = UDim.new(0, Theme.Padding / 2),
        PaddingBottom = UDim.new(0, Theme.Padding / 2),
        Parent = ButtonFrame
      })
      
      local TextContainer = new("Frame", {
        Name = "TextContainer",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = ButtonFrame
      })
      
      new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = TextContainer
      })
      
      local ButtonName = new("TextLabel", {
        Name = "ButtonName",
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
        Text = Info.Name or "Button",
        LayoutOrder = 1,
        Parent = TextContainer
      })
      
      local ButtonDesc
      if Info.Desc and Info.Desc ~= "" then
        ButtonDesc = new("TextLabel", {
          Name = "ButtonDesc",
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
      
      local ButtonClick = new("TextButton", {
        Name = "ButtonClick",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = ButtonFrame
      })
      
      local currentCallback = Info.Callback
      
      ButtonClick.MouseButton1Click:Connect(function()
        if currentCallback then
          pcall(currentCallback)
        end
      end)
      
      ButtonClick.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SecondaryBg}):Play()
      end)
      
      ButtonClick.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.TertiaryBg}):Play()
      end)
      
      return {
        SetName = function(text)
          ButtonName.Text = text
        end,
        SetDesc = function(text)
          if not ButtonDesc then
            ButtonDesc = new("TextLabel", {
              Name = "ButtonDesc",
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
              Text = text,
              LayoutOrder = 2,
              Parent = TextContainer
            })
          else
            ButtonDesc.Text = text
          end
        end,
        SetCallback = function(callback)
          currentCallback = callback
        end
      }
    end
    
    function TabApp:Dropdown(Info)
      local Info = Info or {}
      local Options = Info.Op or {}
      local Multi = Info.Multi or false
      local selectedOptions = {}
      
      if Info.Default then
        if Multi then
          selectedOptions = type(Info.Default) == "table" and Info.Default or {Info.Default}
        else
          selectedOptions = {Info.Default}
        end
      end
      
      local DropdownFrame = new("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.TertiaryBg,
        Parent = TabContent
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropdownFrame })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = Theme.StrokeThickness - 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = DropdownFrame
      })
      
      new("UIPadding", {
        PaddingLeft = UDim.new(0, Theme.Padding),
        PaddingRight = UDim.new(0, Theme.Padding + 50),
        PaddingTop = UDim.new(0, Theme.Padding / 2),
        PaddingBottom = UDim.new(0, Theme.Padding / 2),
        Parent = DropdownFrame
      })
      
      local TextContainer = new("Frame", {
        Name = "TextContainer",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = DropdownFrame
      })
      
      new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = TextContainer
      })
      
      local DropdownName = new("TextLabel", {
        Name = "DropdownName",
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
        Text = Info.Name or "Dropdown",
        LayoutOrder = 1,
        Parent = TextContainer
      })
      
      local DropdownDesc
      if Info.Desc and Info.Desc ~= "" then
        DropdownDesc = new("TextLabel", {
          Name = "DropdownDesc",
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
      
      local DropdownButton = new("Frame", {
        Name = "DropdownButton",
        Size = UDim2.new(0, 44, 0, 23),
        Position = UDim2.new(1, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.SecondaryBg,
        Parent = DropdownFrame
      })
      
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = DropdownButton })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = DropdownButton
      })
      
      local ArrowIcon = new("ImageLabel", {
        Name = "ArrowIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10709768939",
        ImageColor3 = Theme.TextColor,
        Parent = DropdownButton
      })
      
      local ToggleButton = new("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = DropdownFrame
      })
      
      local OptionsMenu = new("Frame", {
        Name = "OptionsMenu",
        Size = UDim2.new(0, 200, 0, 0),
        Position = UDim2.new(1, -210, 0, 0),
        BackgroundColor3 = Theme.SecondaryBg,
        Visible = false,
        ZIndex = 100,
        Parent = s
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = OptionsMenu })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = Theme.StrokeThickness,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = OptionsMenu
      })
      
      new("UISizeConstraint", {
        MaxSize = Vector2.new(200, 250),
        Parent = OptionsMenu
      })
      
      local MenuHeader = new("Frame", {
        Name = "MenuHeader",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Theme.TertiaryBg,
        Parent = OptionsMenu
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MenuHeader })
      
      local SearchBox = new("TextBox", {
        Name = "SearchBox",
        Size = UDim2.new(1, -45, 0, 25),
        Position = UDim2.new(0, 8, 0, 5),
        BackgroundColor3 = Theme.SecondaryBg,
        TextColor3 = Theme.TextColor,
        PlaceholderText = "Search...",
        PlaceholderColor3 = Theme.TextColorDesc,
        Text = "",
        TextSize = 13,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = MenuHeader
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = SearchBox })
      new("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = SearchBox
      })
      
      local SearchButton = new("ImageButton", {
        Name = "SearchButton",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -33, 0, 5),
        BackgroundColor3 = Theme.AccentColor,
        Image = "rbxassetid://10734943674",
        ImageColor3 = Theme.TextColor,
        Parent = MenuHeader
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = SearchButton })
      
      local OptionsScroller = new("ScrollingFrame", {
        Name = "OptionsScroller",
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarImageColor3 = Theme.AccentColor,
        Parent = OptionsMenu
      })
      
      new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = OptionsScroller
      })
      
      new("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = OptionsScroller
      })
      
      local isOpen = false
      local currentCallback = Info.Callback
      local draggingMenu = false
      local menuDragStart = nil
      local menuStartPos = nil
      
      local ClickDetector = new("TextButton", {
        Name = "ClickDetector",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 99,
        Visible = false,
        Modal = false,
        Parent = s
      })
      
      MenuHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          draggingMenu = true
          menuDragStart = input.Position
          menuStartPos = OptionsMenu.Position
          
          input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
              draggingMenu = false
            end
          end)
        end
      end)
      
      game:GetService("UserInputService").InputChanged:Connect(function(input)
        if draggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
          local delta = input.Position - menuDragStart
          local newPos = UDim2.new(
            menuStartPos.X.Scale,
            menuStartPos.X.Offset + delta.X,
            menuStartPos.Y.Scale,
            menuStartPos.Y.Offset + delta.Y
          )
          OptionsMenu.Position = newPos
        end
      end)
      
      local function TruncateText(text, maxLength)
        if #text > maxLength then
          return string.sub(text, 1, maxLength) .. "..."
        end
        return text
      end
      
      local function UpdateMenuPosition()
        local screenSize = s.AbsoluteSize
        local absolutePos = DropdownFrame.AbsolutePosition
        local absoluteSize = DropdownFrame.AbsoluteSize
        local menuWidth = 200
        local menuHeight = math.min(250, 35 + (#Options * 30) + 20)
        
        local posX = absolutePos.X + absoluteSize.X - menuWidth
        local posY = absolutePos.Y + absoluteSize.Y + 5
        
        if posX + menuWidth > screenSize.X then
          posX = screenSize.X - menuWidth - 10
        end
        if posX < 10 then
          posX = 10
        end
        
        if posY + menuHeight > screenSize.Y then
          posY = absolutePos.Y - menuHeight - 5
        end
        if posY < 10 then
          posY = 10
        end
        
        OptionsMenu.Position = UDim2.new(0, posX, 0, posY)
      end
      
      local function CloseMenu()
        if isOpen then
          isOpen = false
          TweenService:Create(OptionsMenu, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 200, 0, 0)
          }):Play()
          task.wait(0.2)
          OptionsMenu.Visible = false
          ClickDetector.Visible = false
          TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
          TweenService:Create(DropdownButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SecondaryBg}):Play()
        end
      end
      
      ClickDetector.MouseButton1Click:Connect(function()
        if not draggingMenu then
          CloseMenu()
        end
      end)
      
      local function CreateOption(optionText, index)
        local isSelected = false
        for _, selected in ipairs(selectedOptions) do
          if selected == optionText then
            isSelected = true
            break
          end
        end
        
        local displayText = TruncateText(optionText, 22)
        
        local OptionButton = new("TextButton", {
          Name = "Option_" .. index,
          Size = UDim2.new(1, 0, 0, 28),
          BackgroundColor3 = isSelected and Theme.AccentColor or Theme.TertiaryBg,
          Text = "",
          LayoutOrder = index,
          Parent = OptionsScroller
        })
        
        new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = OptionButton })
        
        local OptionLabel = new("TextLabel", {
          Name = "OptionLabel",
          Size = UDim2.new(1, -25, 1, 0),
          Position = UDim2.new(0, 8, 0, 0),
          BackgroundTransparency = 1,
          Text = displayText,
          TextColor3 = Theme.TextColor,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextSize = 13,
          Font = Enum.Font.SourceSans,
          Parent = OptionButton
        })
        
        local CheckMark = new("TextLabel", {
          Name = "CheckMark",
          Size = UDim2.new(0, 0, 0, 0),
          Position = UDim2.new(1, -20, 0.5, 0),
          AnchorPoint = Vector2.new(0, 0.5),
          BackgroundTransparency = 1,
          Text = "✓",
          TextColor3 = Color3.fromRGB(255, 255, 255),
          TextSize = 16,
          Font = Enum.Font.SourceSansBold,
          Visible = isSelected,
          Parent = OptionButton
        })
        
        if isSelected then
          CheckMark.Size = UDim2.new(0, 16, 0, 16)
        end
        
        OptionButton.MouseButton1Click:Connect(function()
          if Multi then
            local found = false
            for i, selected in ipairs(selectedOptions) do
              if selected == optionText then
                table.remove(selectedOptions, i)
                found = true
                OptionButton.BackgroundColor3 = Theme.TertiaryBg
                CheckMark.Visible = false
                TweenService:Create(CheckMark, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                break
              end
            end
            if not found then
              table.insert(selectedOptions, optionText)
              OptionButton.BackgroundColor3 = Theme.AccentColor
              CheckMark.Visible = true
              TweenService:Create(CheckMark, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)}):Play()
            end
          else
            for _, child in pairs(OptionsScroller:GetChildren()) do
              if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.TertiaryBg
                local oldCheck = child:FindFirstChild("CheckMark")
                if oldCheck then
                  oldCheck.Visible = false
                  TweenService:Create(oldCheck, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                end
              end
            end
            selectedOptions = {optionText}
            OptionButton.BackgroundColor3 = Theme.AccentColor
            CheckMark.Visible = true
            TweenService:Create(CheckMark, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)}):Play()
            CloseMenu()
          end
          
          if currentCallback then
            pcall(currentCallback, Multi and selectedOptions or selectedOptions[1])
          end
        end)
        
        OptionButton.MouseEnter:Connect(function()
          if OptionButton.BackgroundColor3 ~= Theme.AccentColor then
            TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SecondaryBg}):Play()
          end
        end)
        
        OptionButton.MouseLeave:Connect(function()
          local targetColor = Theme.TertiaryBg
          for _, selected in ipairs(selectedOptions) do
            if selected == optionText then
              targetColor = Theme.AccentColor
              break
            end
          end
          TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = targetColor}):Play()
        end)
      end
      
      for i, option in ipairs(Options) do
        CreateOption(option, i)
      end
      
      SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchBox.Text:lower()
        for _, child in pairs(OptionsScroller:GetChildren()) do
          if child:IsA("TextButton") then
            local label = child:FindFirstChild("OptionLabel")
            if label then
              local optionText = label.Text:lower()
              child.Visible = searchText == "" or optionText:find(searchText, 1, true) ~= nil
            end
          end
        end
      end)
      
      ToggleButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
          UpdateMenuPosition()
          OptionsMenu.Visible = true
          ClickDetector.Visible = true
          local targetHeight = math.min(250, 35 + (#Options * 30) + 20)
          TweenService:Create(OptionsMenu, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 200, 0, targetHeight)
          }):Play()
          TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {Rotation = 180}):Play()
          TweenService:Create(DropdownButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentColor}):Play()
        else
          CloseMenu()
        end
      end)
      
      ToggleButton.MouseEnter:Connect(function()
        if not isOpen then
          TweenService:Create(DropdownFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SecondaryBg}):Play()
        end
      end)
      
      ToggleButton.MouseLeave:Connect(function()
        if not isOpen then
          TweenService:Create(DropdownFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.TertiaryBg}):Play()
        end
      end)
      
      return {
        AddOp = function(newOptions)
          for _, option in ipairs(newOptions) do
            table.insert(Options, option)
            CreateOption(option, #Options)
          end
        end,
        SetName = function(text)
          DropdownName.Text = text
        end,
        SetDefault = function(defaults)
          if Multi then
            selectedOptions = type(defaults) == "table" and defaults or {defaults}
          else
            selectedOptions = type(defaults) == "table" and defaults or {defaults}
          end
          for _, child in pairs(OptionsScroller:GetChildren()) do
            if child:IsA("TextButton") then
              local label = child:FindFirstChild("OptionLabel")
              if label then
                local isSelected = false
                for _, selected in ipairs(selectedOptions) do
                  if label.Text:find(selected, 1, true) then
                    isSelected = true
                    break
                  end
                end
                child.BackgroundColor3 = isSelected and Theme.AccentColor or Theme.TertiaryBg
                local checkMark = child:FindFirstChild("CheckMark")
                if checkMark then
                  checkMark.Visible = isSelected
                  checkMark.Size = isSelected and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 0, 0, 0)
                end
              end
            end
          end
        end,
        SetDesc = function(text)
          if not DropdownDesc then
            DropdownDesc = new("TextLabel", {
              Name = "DropdownDesc",
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
              Text = text,
              LayoutOrder = 2,
              Parent = TextContainer
            })
          else
            DropdownDesc.Text = text
          end
        end,
        SetMulti = function(value)
          Multi = value
        end,
        SetOptions = function(newOptions)
          Options = newOptions
          for _, child in pairs(OptionsScroller:GetChildren()) do
            if child:IsA("TextButton") then
              child:Destroy()
            end
          end
          for i, option in ipairs(Options) do
            CreateOption(option, i)
          end
        end,
        SetCallback = function(callback)
          currentCallback = callback
        end,
        Get = function()
          return Multi and selectedOptions or selectedOptions[1]
        end,
        Clear = function()
          selectedOptions = {}
          for _, child in pairs(OptionsScroller:GetChildren()) do
            if child:IsA("TextButton") then
              child.BackgroundColor3 = Theme.TertiaryBg
              local checkMark = child:FindFirstChild("CheckMark")
              if checkMark then
                checkMark.Visible = false
                TweenService:Create(checkMark, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
              end
            end
          end
        end
      }
    end
    
    function TabApp:Slider(Info)
      local Info = Info or {}
      local minValue = Info.MinV or 0
      local maxValue = Info.MaxV or 100
      local currentValue = Info.Default or minValue
      
      local SliderFrame = new("Frame", {
        Name = "Slider",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.TertiaryBg,
        Parent = TabContent
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SliderFrame })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = Theme.StrokeThickness - 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = SliderFrame
      })
      
      new("UIPadding", {
        PaddingLeft = UDim.new(0, Theme.Padding),
        PaddingRight = UDim.new(0, Theme.Padding + 50),
        PaddingTop = UDim.new(0, Theme.Padding / 2),
        PaddingBottom = UDim.new(0, Theme.Padding / 2),
        Parent = SliderFrame
      })
      
      local TextContainer = new("Frame", {
        Name = "TextContainer",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = SliderFrame
      })
      
      new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = TextContainer
      })
      
      local SliderName = new("TextLabel", {
        Name = "SliderName",
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
        Text = Info.Name or "Slider",
        LayoutOrder = 1,
        Parent = TextContainer
      })
      
      local SliderDesc
      if Info.Desc and Info.Desc ~= "" then
        SliderDesc = new("TextLabel", {
          Name = "SliderDesc",
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
      
      local SliderButton = new("Frame", {
        Name = "SliderButton",
        Size = UDim2.new(0, 44, 0, 23),
        Position = UDim2.new(1, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.SecondaryBg,
        Parent = SliderFrame
      })
      
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderButton })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = SliderButton
      })
      
      local SliderIcon = new("ImageLabel", {
        Name = "SliderIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10734950309",
        ImageColor3 = Theme.TextColor,
        Parent = SliderButton
      })
      
      local SliderToggleButton = new("TextButton", {
        Name = "SliderToggleButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = SliderFrame
      })
      
      local SliderMenu = new("Frame", {
        Name = "SliderMenu",
        Size = UDim2.new(0, 200, 0, 0),
        Position = UDim2.new(1, -210, 0, 0),
        BackgroundColor3 = Theme.SecondaryBg,
        Visible = false,
        ZIndex = 100,
        Parent = s
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SliderMenu })
      new("UIStroke", {
        Color = Theme.BorderColor,
        Thickness = Theme.StrokeThickness,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = SliderMenu
      })
      
      new("UISizeConstraint", {
        MaxSize = Vector2.new(200, 150),
        Parent = SliderMenu
      })
      
      local MenuHeader = new("Frame", {
        Name = "MenuHeader",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Theme.TertiaryBg,
        Parent = SliderMenu
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MenuHeader })
      
      local InputBox = new("TextBox", {
        Name = "InputBox",
        Size = UDim2.new(1, -16, 0, 25),
        Position = UDim2.new(0, 8, 0, 5),
        BackgroundColor3 = Theme.SecondaryBg,
        TextColor3 = Theme.TextColor,
        PlaceholderText = "Enter value...",
        PlaceholderColor3 = Theme.TextColorDesc,
        Text = tostring(currentValue),
        TextSize = 13,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        Parent = MenuHeader
      })
      
      new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = InputBox })
      new("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = InputBox
      })
      
      local SliderMenuContent = new("Frame", {
        Name = "SliderMenuContent",
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1,
        Parent = SliderMenu
      })
      
      new("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = SliderMenuContent
      })
      
      local SliderBar = new("Frame", {
        Name = "SliderBar",
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0.5, -3),
        BackgroundColor3 = Theme.SecondaryBg,
        Parent = SliderMenuContent
      })
      
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderBar })
      
      local SliderFill = new("Frame", {
        Name = "SliderFill",
        Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0),
        BackgroundColor3 = Theme.AccentColor,
        Parent = SliderBar
      })
      
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderFill })
      
      local SliderKnob = new("Frame", {
        Name = "SliderKnob",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = SliderBar
      })
      
      new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderKnob })
      new("UIStroke", {
        Color = Theme.AccentColor,
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = SliderKnob
      })
      
      local isOpen = false
      local currentCallback = Info.Callback
      local draggingSlider = false
      local draggingMenu = false
      local menuDragStart = nil
      local menuStartPos = nil
      
      local ClickDetector = new("TextButton", {
        Name = "ClickDetector",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 99,
        Visible = false,
        Modal = false,
        Parent = s
      })
      
      MenuHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          draggingMenu = true
          menuDragStart = input.Position
          menuStartPos = SliderMenu.Position
          
          input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
              draggingMenu = false
            end
          end)
        end
      end)
      
      game:GetService("UserInputService").InputChanged:Connect(function(input)
        if draggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
          local delta = input.Position - menuDragStart
          local newPos = UDim2.new(
            menuStartPos.X.Scale,
            menuStartPos.X.Offset + delta.X,
            menuStartPos.Y.Scale,
            menuStartPos.Y.Offset + delta.Y
          )
          SliderMenu.Position = newPos
        end
      end)
      
      local function UpdateMenuPosition()
        local screenSize = s.AbsoluteSize
        local absolutePos = SliderFrame.AbsolutePosition
        local absoluteSize = SliderFrame.AbsoluteSize
        local menuWidth = 200
        local menuHeight = 150
        
        local posX = absolutePos.X + absoluteSize.X - menuWidth
        local posY = absolutePos.Y + absoluteSize.Y + 5
        
        if posX + menuWidth > screenSize.X then
          posX = screenSize.X - menuWidth - 10
        end
        if posX < 10 then
          posX = 10
        end
        
        if posY + menuHeight > screenSize.Y then
          posY = absolutePos.Y - menuHeight - 5
        end
        if posY < 10 then
          posY = 10
        end
        
        SliderMenu.Position = UDim2.new(0, posX, 0, posY)
      end
      
      local function CloseMenu()
        if isOpen then
          isOpen = false
          TweenService:Create(SliderMenu, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 200, 0, 0)
          }):Play()
          task.wait(0.2)
          SliderMenu.Visible = false
          ClickDetector.Visible = false
          TweenService:Create(SliderIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
          TweenService:Create(SliderButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SecondaryBg}):Play()
        end
      end
      
      ClickDetector.MouseButton1Click:Connect(function()
        if not draggingMenu then
          CloseMenu()
        end
      end)
      
      local function UpdateValue(value)
        currentValue = math.clamp(value, minValue, maxValue)
        local percent = (currentValue - minValue) / (maxValue - minValue)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderKnob.Position = UDim2.new(percent, -8, 0.5, -8)
        InputBox.Text = tostring(currentValue)
        
        if currentCallback then
          pcall(currentCallback, currentValue)
        end
      end
      
      local function UpdateSlider(input)
        local barPos = SliderBar.AbsolutePosition.X
        local barSize = SliderBar.AbsoluteSize.X
        local mousePos = input.Position.X
        
        local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
        local value = math.floor(minValue + (maxValue - minValue) * percent)
        UpdateValue(value)
      end
      
      SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          draggingSlider = true
          UpdateSlider(input)
          
          input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
              draggingSlider = false
            end
          end)
        end
      end)
      
      game:GetService("UserInputService").InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
          UpdateSlider(input)
        end
      end)
      
      InputBox.FocusLost:Connect(function(enterPressed)
        local value = tonumber(InputBox.Text)
        if value then
          UpdateValue(value)
        else
          InputBox.Text = tostring(currentValue)
        end
      end)
      
      SliderToggleButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
          UpdateMenuPosition()
          SliderMenu.Visible = true
          ClickDetector.Visible = true
          TweenService:Create(SliderMenu, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 200, 0, 150)
          }):Play()
          TweenService:Create(SliderIcon, TweenInfo.new(0.2), {Rotation = 180}):Play()
          TweenService:Create(SliderButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentColor}):Play()
        else
          CloseMenu()
        end
      end)
      
      SliderToggleButton.MouseEnter:Connect(function()
        if not isOpen then
          TweenService:Create(SliderFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SecondaryBg}):Play()
        end
      end)
      
      SliderToggleButton.MouseLeave:Connect(function()
        if not isOpen then
          TweenService:Create(SliderFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.TertiaryBg}):Play()
        end
      end)
      
      return {
        SetName = function(text)
          SliderName.Text = text
        end,
        SetDesc = function(text)
          if not SliderDesc then
            SliderDesc = new("TextLabel", {
              Name = "SliderDesc",
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
              Text = text,
              LayoutOrder = 2,
              Parent = TextContainer
            })
          else
            SliderDesc.Text = text
          end
        end,
        SetDefault = function(value)
          UpdateValue(value)
        end,
        SetMinV = function(value)
          minValue = value
          UpdateValue(currentValue)
        end,
        SetMaxV = function(value)
          maxValue = value
          UpdateValue(currentValue)
        end,
        SetCallback = function(callback)
          currentCallback = callback
        end,
        Get = function()
          return currentValue
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

return Lib
