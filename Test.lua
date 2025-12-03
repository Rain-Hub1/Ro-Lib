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
  local Name = Info.Name or "Window"
  local Size = Info.Size or UDim2.new(0.3, 0, 0.4, 0)
  local Position = Info.Position or UDim2.new(0.5, 0, 0.5, 0)
  
  local Window = new("Frame", {
    Size = Size,
    Position = Position,
    BackgroundColor3 = Theme.SecondaryBg,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0.5)
  })
  
  new("UICorner", {
    CornerRadius = Theme.CornerRadius,
    Parent = Window
  })
  
  local TitleBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, Theme.TbarHeight),
    BackgroundColor3 = Theme.PrimaryBg,
    BorderSizePixel = 0,
    Parent = Window
  })
  
  new("UICorner", {
    CornerRadius = UDim.new(0, Theme.CornerRadius.Offset - 2),
    Parent = TitleBar
  })
  
  local Title = new("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = Theme.TextColor,
    TextSize = 18,
    Font = Enum.Font.SourceSansBold,
    Text = Name,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar
  })
  
  local ContentContainer = new("Frame", {
    Size = UDim2.new(1, 0, 1, -Theme.TbarHeight),
    Position = UDim2.new(0, 0, 0, Theme.TbarHeight),
    BackgroundColor3 = Theme.SecondaryBg,
    BorderSizePixel = 0,
    Parent = Window
  })
  
  local TabBar = new("Frame", {
    Size = UDim2.new(0, Theme.TabWidth, 1, 0),
    BackgroundColor3 = Theme.PrimaryBg,
    BorderSizePixel = 0,
    Parent = ContentContainer
  })
  
  local TabScroller = new("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = Theme.TertiaryBg,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = TabBar
  })
  
  new("UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 5),
    Parent = TabScroller
  })
  
  local ContentScroller = new("ScrollingFrame", {
    Size = UDim2.new(1, -Theme.TabWidth, 1, 0),
    Position = UDim2.new(0, Theme.TabWidth, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = Theme.TertiaryBg,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = ContentContainer
  })
  
  new("UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, Theme.Padding),
    Parent = ContentScroller
  })
  
  local drag = false
  local dragStart = Vector2.new(0, 0)
  local initialPos = UDim2.new(0, 0, 0, 0)
  
  TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      drag = true
      dragStart = input.Position
      initialPos = Window.Position
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          drag = false
        end
      end)
    end
  end)
  
  RunService.RenderStepped:Connect(function()
    if drag then
      local delta = game:GetService("UserInputService"):GetMouseLocation() - dragStart
      Window.Position = UDim2.new(initialPos.Scale.X, initialPos.Offset + delta.X, initialPos.Scale.Y, initialPos.Offset + delta.Y)
    end
  end)
  
  local Tabs = {}
  local selectedTab = nil
  
  local WinApp = {
    Window = Window,
    Content = ContentScroller,
    AddTab = function(Info)
      local Info = Info or {}
      local Name = Info.Name or "Tab"
      local LayoutOrder = Info.LayoutOrder or #Tabs + 1
      
      local TabContent = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = LayoutOrder,
        Parent = ContentScroller
      })
      
      new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, Theme.Padding),
        Parent = TabContent
      })
      
      local TabButton = new("TextButton", {
        Size = UDim2.new(1, 0, 0, Theme.TbarHeight),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextColor,
        TextSize = 16,
        Font = Enum.Font.SourceSansBold,
        Text = Name,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = LayoutOrder,
        Parent = TabScroller
      })
      
      local Selection = new("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = Theme.AccentColor,
        BorderSizePixel = 0,
        Visible = false,
        Parent = TabButton
      })
      
      local TabApp = {
        Button = TabButton,
        Content = TabContent,
        SelectTab = function()
          if selectedTab then
            selectedTab.Content.Visible = false
            selectedTab.Button.BackgroundColor3 = Theme.PrimaryBg
            selectedTab.Button.TextColor3 = Theme.TextColor
            selectedTab.Button.Selection.Visible = false
          end
          
          TabContent.Visible = true
          TabButton.BackgroundColor3 = Theme.SecondaryBg
          TabButton.TextColor3 = Theme.TextColor
          Selection.Visible = true
          selectedTab = TabApp
          
          local children = ContentScroller:GetChildren()
          local totalHeight = 0
          for _, child in pairs(children) do
              if child.Visible and child:IsA("Frame") then
                  local listLayout = child:FindFirstChildOfClass("UIListLayout")
                  if listLayout then
                      local contentHeight = 0
                      local visibleChildren = 0
                      for _, item in pairs(child:GetChildren()) do
                          if item:IsA("Frame") or item:IsA("TextLabel") or item:IsA("TextButton") or item:IsA("TextBox") or item:IsA("ImageLabel") or item:IsA("ImageButton") then
                              contentHeight = contentHeight + item.Size.Y.Offset
                              visibleChildren = visibleChildren + 1
                          end
                      end
                      
                      local padding = listLayout.Padding.Offset
                      local finalHeight = contentHeight + (padding * (visibleChildren - 1))
                      child.Size = UDim2.new(1, 0, 0, finalHeight)
                      totalHeight = totalHeight + finalHeight + Theme.Padding
                  end
              end
          end
          ContentScroller.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        end,
        AddSection = function(Info)
          local Info = Info or {}
          local Name = Info.Name or "Section"
          local LayoutOrder = Info.LayoutOrder or #TabContent:GetChildren() + 1
          
          local Section = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = LayoutOrder,
            Parent = TabContent
          })
          
          new("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, Theme.Padding),
            Parent = Section
          })
          
          local SectionTitle = new("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextColor,
            TextSize = 18,
            Font = Enum.Font.SourceSansBold,
            Text = Name,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Section
          })
          
          local SectionApp = {
            Section = Section,
            Title = SectionTitle,
            AddToggle = function(Info)
              local Info = Info or {}
              local Name = Info.Name or "Toggle"
              local Description = Info.Description or "Description"
              local Callback = Info.Callback or function() end
              local Default = Info.Default or false
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local ToggleContainer = new("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.TertiaryBg,
                BorderSizePixel = 0,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = ToggleContainer
              })
              
              local NameLabel = new("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                Text = Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleContainer
              })
              
              local DescLabel = new("TextLabel", {
                Size = UDim2.new(1, -70, 0, 15),
                Position = UDim2.new(0, 10, 0, 25),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColorDesc,
                TextSize = 12,
                Font = Enum.Font.SourceSans,
                Text = Description,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleContainer
              })
              
              local ToggleButton = new("TextButton", {
                Size = UDim2.new(0, 50, 0, 30),
                Position = UDim2.new(1, -60, 0.5, -15),
                BackgroundColor3 = Default and Theme.AccentColor or Theme.PrimaryBg,
                BorderSizePixel = 0,
                Text = "",
                Parent = ToggleContainer
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = ToggleButton
              })
              
              local Toggled = Default
              
              local function UpdateToggle()
                local color = Toggled and Theme.AccentColor or Theme.PrimaryBg
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
                Callback(Toggled)
              end
              
              ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                UpdateToggle()
              end)
              
              local ToggleApp = {
                Container = ToggleContainer,
                Button = ToggleButton,
                SetName = function(newName)
                  NameLabel.Text = newName
                end,
                SetDescription = function(newDesc)
                  DescLabel.Text = newDesc
                end,
                SetCallback = function(newCallback)
                  Callback = newCallback
                  if Toggled then Callback(Toggled) end
                end,
                Set = function(state)
                  Toggled = state
                  UpdateToggle()
                end,
                Get = function()
                  return Toggled
                end
              }
              
              if Default then UpdateToggle() end
              
              return ToggleApp
            end,
            AddSlider = function(Info)
              local Info = Info or {}
              local Name = Info.Name or "Slider"
              local Description = Info.Description or "Description"
              local Callback = Info.Callback or function() end
              local Default = Info.Default or 0
              local Min = Info.Min or 0
              local Max = Info.Max or 100
              local Decimals = Info.Decimals or 0
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local SliderContainer = new("Frame", {
                Size = UDim2.new(1, 0, 0, 70),
                BackgroundColor3 = Theme.TertiaryBg,
                BorderSizePixel = 0,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = SliderContainer
              })
              
              local NameLabel = new("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                Text = Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderContainer
              })
              
              local DescLabel = new("TextLabel", {
                Size = UDim2.new(1, -70, 0, 15),
                Position = UDim2.new(0, 10, 0, 25),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColorDesc,
                TextSize = 12,
                Font = Enum.Font.SourceSans,
                Text = Description,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderContainer
              })
              
              local ValueLabel = new("TextLabel", {
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -65, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSansBold,
                Text = string.format("%." .. Decimals .. "f", Default),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderContainer
              })
              
              local SliderBar = new("Frame", {
                Size = UDim2.new(1, -20, 0, 10),
                Position = UDim2.new(0, 10, 0, 50),
                BackgroundColor3 = Theme.PrimaryBg,
                BorderSizePixel = 0,
                Parent = SliderContainer
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = SliderBar
              })
              
              local SliderFill = new("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Theme.AccentColor,
                BorderSizePixel = 0,
                Parent = SliderBar
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = SliderFill
              })
              
              local SliderHandle = new("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, -10, 0.5, -10),
                BackgroundColor3 = Theme.AccentColor,
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = SliderBar
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SliderHandle
              })
              
              local CurrentValue = Default
              
              local function UpdateSlider(xPos)
                local barWidth = SliderBar.AbsoluteSize.X
                local newX = math.min(math.max(xPos, 0), barWidth)
                local percentage = newX / barWidth
                local calculatedValue = Min + (Max - Min) * percentage
                
                -- Arredondar para o número correto de casas decimais
                local multiplier = 10 ^ Decimals
                CurrentValue = math.floor(calculatedValue * multiplier + 0.5) / multiplier
                
                -- Limitar o valor aos limites Min e Max
                CurrentValue = math.min(math.max(CurrentValue, Min), Max)
                
                local newFillScale = (CurrentValue - Min) / (Max - Min)
                SliderFill.Size = UDim2.new(newFillScale, 0, 1, 0)
                
                local handlePos = newFillScale * barWidth
                SliderHandle.Position = UDim2.new(0, handlePos - 10, 0.5, -10)
                
                ValueLabel.Text = string.format("%." .. Decimals .. "f", CurrentValue)
                Callback(CurrentValue)
              end
              
              -- Inicializar o estado do Slider
              local initialPercentage = (Default - Min) / (Max - Min)
              SliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
              
              local handlePos = initialPercentage * SliderBar.AbsoluteSize.X
              SliderHandle.Position = UDim2.new(0, handlePos - 10, 0.5, -10)
              
              local isDragging = false
              
              local function getMousePos(input)
                  return input.Position.X - SliderBar.AbsolutePosition.X
              end
              
              local function startDrag(input)
                  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                      isDragging = true
                      local xPos = getMousePos(input)
                      UpdateSlider(xPos)
                  end
              end
              
              local function stopDrag(input)
                  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                      isDragging = false
                  end
              end
              
              SliderBar.InputBegan:Connect(startDrag)
              SliderBar.InputEnded:Connect(stopDrag)
              SliderHandle.InputBegan:Connect(startDrag)
              SliderHandle.InputEnded:Connect(stopDrag)
              
              game:GetService("UserInputService").InputChanged:Connect(function(input)
                  if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                      local xPos = getMousePos(input)
                      UpdateSlider(xPos)
                  end
              end)
              
              local SliderApp = {
                Container = SliderContainer,
                SetName = function(newName)
                  NameLabel.Text = newName
                end,
                SetDescription = function(newDesc)
                  DescLabel.Text = newDesc
                end,
                SetCallback = function(newCallback)
                  Callback = newCallback
                  Callback(CurrentValue)
                end,
                Set = function(value)
                  local percentage = (value - Min) / (Max - Min)
                  local barWidth = SliderBar.AbsoluteSize.X
                  local xPos = percentage * barWidth
                  UpdateSlider(xPos)
                end,
                Get = function()
                  return CurrentValue
                end
              }
              
              Callback(CurrentValue)
              
              return SliderApp
            end,
            AddButton = function(Info)
              local Info = Info or {}
              local Name = Info.Name or "Button"
              local Callback = Info.Callback or function() end
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local Button = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.AccentColor,
                BorderSizePixel = 0,
                Text = Name,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSansBold,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = Button
              })
              
              Button.MouseButton1Click:Connect(Callback)
              
              local ButtonApp = {
                Button = Button,
                SetName = function(newName)
                  Button.Text = newName
                end,
                SetCallback = function(newCallback)
                  Callback = newCallback
                end
              }
              
              return ButtonApp
            end,
            AddLabel = function(Info)
              local Info = Info or {}
              local Text = Info.Text or "Label"
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              local Font = Info.Font or Enum.Font.SourceSans
              local Size = Info.Size or 16
              local Color = Info.Color or Theme.TextColor
              local Alignment = Info.Alignment or Enum.TextXAlignment.Left
              
              local Label = new("TextLabel", {
                Size = UDim2.new(1, 0, 0, Size + 5),
                BackgroundTransparency = 1,
                TextColor3 = Color,
                TextSize = Size,
                Font = Font,
                Text = Text,
                TextXAlignment = Alignment,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              local LabelApp = {
                Label = Label,
                SetText = function(newText)
                  Label.Text = newText
                end,
                SetSize = function(newSize)
                  Label.Size = UDim2.new(1, 0, 0, newSize + 5)
                  Label.TextSize = newSize
                end,
                SetColor = function(newColor)
                  Label.TextColor3 = newColor
                end
              }
              
              return LabelApp
            end,
            AddTextBox = function(Info)
              local Info = Info or {}
              local Name = Info.Name or "TextBox"
              local Description = Info.Description or "Description"
              local Callback = Info.Callback or function() end
              local Default = Info.Default or ""
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local TextBoxContainer = new("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.TertiaryBg,
                BorderSizePixel = 0,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = TextBoxContainer
              })
              
              local NameLabel = new("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                Text = Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextBoxContainer
              })
              
              local TextBox = new("TextBox", {
                Size = UDim2.new(1, -120, 0, 30),
                Position = UDim2.new(0, 110, 0.5, -15),
                BackgroundColor3 = Theme.PrimaryBg,
                BorderSizePixel = 0,
                Text = Default,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                PlaceholderText = Description,
                PlaceholderColor3 = Theme.TextColorDesc,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = TextBoxContainer
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = TextBox
              })
              
              TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                  Callback(TextBox.Text)
                end
              end)
              
              local TextBoxApp = {
                Container = TextBoxContainer,
                TextBox = TextBox,
                SetName = function(newName)
                  NameLabel.Text = newName
                end,
                SetDescription = function(newDesc)
                  TextBox.PlaceholderText = newDesc
                end,
                SetCallback = function(newCallback)
                  Callback = newCallback
                end,
                Set = function(newText)
                  TextBox.Text = newText
                  Callback(newText)
                end,
                Get = function()
                  return TextBox.Text
                end
              }
              
              return TextBoxApp
            end,
            AddDropdown = function(Info)
              local Info = Info or {}
              local Name = Info.Name or "Dropdown"
              local Options = Info.Options or {"Option 1", "Option 2"}
              local Description = Info.Description or "Description"
              local Callback = Info.Callback or function() end
              local Multi = Info.Multi or false
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local DropdownContainer = new("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.TertiaryBg,
                BorderSizePixel = 0,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = DropdownContainer
              })
              
              local NameLabel = new("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                Text = Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownContainer
              })
              
              local DropdownButton = new("TextButton", {
                Size = UDim2.new(1, -120, 0, 30),
                Position = UDim2.new(0, 110, 0.5, -15),
                BackgroundColor3 = Theme.PrimaryBg,
                BorderSizePixel = 0,
                Text = Multi and "Select Options" or "Select Option",
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = DropdownContainer
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = DropdownButton
              })
              
              local Arrow = new("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -25, 0.5, -10),
                BackgroundTransparency = 1,
                Image = "http://www.roblox.com/asset/?id=262176313", -- Icon: Down Arrow
                ImageColor3 = Theme.TextColor,
                Parent = DropdownButton
              })
              
              local DropdownDesc = new("TextLabel", {
                Size = UDim2.new(1, -120, 0, 15),
                Position = UDim2.new(0, 110, 0, 25),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColorDesc,
                TextSize = 12,
                Font = Enum.Font.SourceSans,
                Text = Description,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownContainer
              })
              
              local OptionsFrame = new("Frame", {
                Size = UDim2.new(1, -120, 0, 0),
                Position = UDim2.new(0, 110, 1, 5),
                BackgroundColor3 = Theme.PrimaryBg,
                BorderSizePixel = 0,
                ZIndex = 3,
                Visible = false,
                Parent = DropdownContainer
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = OptionsFrame
              })
              
              local OptionsScroller = new("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 6,
                ScrollBarImageColor3 = Theme.TertiaryBg,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                Parent = OptionsFrame
              })
              
              local OptionsLayout = new("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = OptionsScroller
              })
              
              local selectedOptions = {}
              local currentCallback = Callback
              
              local function UpdateButtonText()
                if Multi then
                  if #selectedOptions == 0 then
                    DropdownButton.Text = "Select Options"
                  else
                    DropdownButton.Text = table.concat(selectedOptions, ", ")
                  end
                else
                  DropdownButton.Text = #selectedOptions > 0 and selectedOptions[1] or "Select Option"
                end
              end
              
              local function UpdateCanvasSize()
                local totalHeight = 0
                local children = OptionsScroller:GetChildren()
                local visibleChildren = 0
                for _, child in pairs(children) do
                    if child:IsA("TextButton") then
                        totalHeight = totalHeight + child.Size.Y.Offset
                        visibleChildren = visibleChildren + 1
                    end
                end
                
                local padding = OptionsLayout.Padding.Offset
                local finalHeight = totalHeight + (padding * (visibleChildren - 1))
                OptionsFrame.Size = UDim2.new(1, -120, 0, math.min(150, finalHeight)) -- Limita a altura máxima
                OptionsScroller.CanvasSize = UDim2.new(0, 0, 0, finalHeight)
              end
              
              local function CreateOption(optionText, index)
                local OptionButton = new("TextButton", {
                  Size = UDim2.new(1, 0, 0, 25),
                  BackgroundColor3 = Theme.TertiaryBg,
                  BorderSizePixel = 0,
                  Text = optionText,
                  TextColor3 = Theme.TextColor,
                  TextSize = 14,
                  Font = Enum.Font.SourceSans,
                  TextXAlignment = Enum.TextXAlignment.Left,
                  TextWrapped = true,
                  Parent = OptionsScroller
                })
                
                new("UICorner", {
                  CornerRadius = UDim.new(0, 4),
                  Parent = OptionButton
                })
                
                OptionButton.MouseEnter:Connect(function()
                  if not table.find(selectedOptions, optionText) then
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentColorHover}):Play()
                  end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                  if not table.find(selectedOptions, optionText) then
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Theme.TertiaryBg}):Play()
                  else
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentColorSelected}):Play()
                  end
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                  if Multi then
                    local index = table.find(selectedOptions, optionText)
                    if index then
                      table.remove(selectedOptions, index)
                      OptionButton.BackgroundColor3 = Theme.TertiaryBg
                    else
                      table.insert(selectedOptions, optionText)
                      OptionButton.BackgroundColor3 = Theme.AccentColorSelected
                    end
                  else
                    selectedOptions = {optionText}
                    for _, child in pairs(OptionsScroller:GetChildren()) do
                      if child:IsA("TextButton") then
                        child.BackgroundColor3 = Theme.TertiaryBg
                      end
                    end
                    OptionButton.BackgroundColor3 = Theme.AccentColorSelected
                    OptionsFrame.Visible = false
                    Arrow.Rotation = 0
                  end
                  
                  UpdateButtonText()
                  currentCallback(Multi and selectedOptions or selectedOptions[1])
                end)
                
                if table.find(selectedOptions, optionText) then
                  OptionButton.BackgroundColor3 = Theme.AccentColorSelected
                end
              end
              
              for i, option in ipairs(Options) do
                CreateOption(option, i)
              end
              
              OptionsScroller.ChildAdded:Connect(UpdateCanvasSize)
              OptionsScroller.ChildRemoved:Connect(UpdateCanvasSize)
              
              DropdownButton.MouseButton1Click:Connect(function()
                OptionsFrame.Visible = not OptionsFrame.Visible
                Arrow.Rotation = OptionsFrame.Visible and 180 or 0
                if OptionsFrame.Visible then
                    UpdateCanvasSize()
                end
              end)
              
              local DropdownApp = {
                Container = DropdownContainer,
                Button = DropdownButton,
                SetName = function(newName)
                  NameLabel.Text = newName
                end,
                SetDescription = function(text)
                  DropdownDesc.Text = text
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
                    end
                  end
                end
              }
              return DropdownApp
            end,
            AddCustomDropdown = function(Info)
              local Info = Info or {}
              local Name = Info.Name or "CustomDropdown"
              local Options = Info.Options or {}
              local Description = Info.Description or "Description"
              local Callback = Info.Callback or function() end
              local Multi = Info.Multi or false
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local DropdownContainer = new("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.TertiaryBg,
                BorderSizePixel = 0,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = DropdownContainer
              })
              
              local NameLabel = new("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                Text = Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownContainer
              })
              
              local DropdownButton = new("TextButton", {
                Size = UDim2.new(1, -120, 0, 30),
                Position = UDim2.new(0, 110, 0.5, -15),
                BackgroundColor3 = Theme.PrimaryBg,
                BorderSizePixel = 0,
                Text = Multi and "Select Options" or "Select Option",
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = DropdownContainer
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = DropdownButton
              })
              
              local Arrow = new("ImageLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -25, 0.5, -10),
                BackgroundTransparency = 1,
                Image = "http://www.roblox.com/asset/?id=262176313", -- Icon: Down Arrow
                ImageColor3 = Theme.TextColor,
                Parent = DropdownButton
              })
              
              local DropdownDesc = new("TextLabel", {
                Size = UDim2.new(1, -120, 0, 15),
                Position = UDim2.new(0, 110, 0, 25),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColorDesc,
                TextSize = 12,
                Font = Enum.Font.SourceSans,
                Text = Description,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownContainer
              })
              
              local OptionsFrame = new("Frame", {
                Size = UDim2.new(1, -120, 0, 0),
                Position = UDim2.new(0, 110, 1, 5),
                BackgroundColor3 = Theme.PrimaryBg,
                BorderSizePixel = 0,
                ZIndex = 3,
                Visible = false,
                Parent = DropdownContainer
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = OptionsFrame
              })
              
              local OptionsScroller = new("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 6,
                ScrollBarImageColor3 = Theme.TertiaryBg,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                Parent = OptionsFrame
              })
              
              local OptionsLayout = new("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = OptionsScroller
              })
              
              local selectedOptions = {}
              local currentCallback = Callback
              
              local function UpdateButtonText()
                if Multi then
                  if #selectedOptions == 0 then
                    DropdownButton.Text = "Select Options"
                  else
                    DropdownButton.Text = table.concat(selectedOptions, ", ")
                  end
                else
                  DropdownButton.Text = #selectedOptions > 0 and selectedOptions[1] or "Select Option"
                end
              end
              
              local function UpdateCanvasSize()
                local totalHeight = 0
                local children = OptionsScroller:GetChildren()
                local visibleChildren = 0
                for _, child in pairs(children) do
                    if child:IsA("TextButton") or child:IsA("Frame") then
                        totalHeight = totalHeight + child.Size.Y.Offset
                        visibleChildren = visibleChildren + 1
                    end
                end
                
                local padding = OptionsLayout.Padding.Offset
                local finalHeight = totalHeight + (padding * (visibleChildren - 1))
                OptionsFrame.Size = UDim2.new(1, -120, 0, math.min(150, finalHeight))
                OptionsScroller.CanvasSize = UDim2.new(0, 0, 0, finalHeight)
              end
              
              local function CreateOption(optionData, index)
                local optionText = optionData.Text or "Option"
                local optionType = optionData.Type or "Text"
                
                if optionType == "Text" then
                    local OptionButton = new("TextButton", {
                      Size = UDim2.new(1, 0, 0, 25),
                      BackgroundColor3 = Theme.TertiaryBg,
                      BorderSizePixel = 0,
                      Text = optionText,
                      TextColor3 = Theme.TextColor,
                      TextSize = 14,
                      Font = Enum.Font.SourceSans,
                      TextXAlignment = Enum.TextXAlignment.Left,
                      TextWrapped = true,
                      Parent = OptionsScroller
                    })
                    
                    new("UICorner", {
                      CornerRadius = UDim.new(0, 4),
                      Parent = OptionButton
                    })
                    
                    OptionButton.MouseEnter:Connect(function()
                      if not table.find(selectedOptions, optionText) then
                        TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentColorHover}):Play()
                      end
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                      if not table.find(selectedOptions, optionText) then
                        TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Theme.TertiaryBg}):Play()
                      else
                        TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentColorSelected}):Play()
                      end
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                      if Multi then
                        local index = table.find(selectedOptions, optionText)
                        if index then
                          table.remove(selectedOptions, index)
                          OptionButton.BackgroundColor3 = Theme.TertiaryBg
                        else
                          table.insert(selectedOptions, optionText)
                          OptionButton.BackgroundColor3 = Theme.AccentColorSelected
                        end
                      else
                        selectedOptions = {optionText}
                        for _, child in pairs(OptionsScroller:GetChildren()) do
                          if child:IsA("TextButton") then
                            child.BackgroundColor3 = Theme.TertiaryBg
                          end
                        end
                        OptionButton.BackgroundColor3 = Theme.AccentColorSelected
                        OptionsFrame.Visible = false
                        Arrow.Rotation = 0
                      end
                      
                      UpdateButtonText()
                      currentCallback(Multi and selectedOptions or selectedOptions[1])
                    end)
                    
                    if table.find(selectedOptions, optionText) then
                      OptionButton.BackgroundColor3 = Theme.AccentColorSelected
                    end
                elseif optionType == "Separator" then
                    new("Frame", {
                        Size = UDim2.new(1, 0, 0, 2),
                        BackgroundColor3 = Theme.BorderColor,
                        BorderSizePixel = 0,
                        Parent = OptionsScroller
                    })
                elseif optionType == "Header" then
                    new("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundTransparency = 1,
                        TextColor3 = Theme.TextColor,
                        TextSize = 16,
                        Font = Enum.Font.SourceSansBold,
                        Text = optionText,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = OptionsScroller
                    })
                end
              end
              
              for i, option in ipairs(Options) do
                CreateOption(option, i)
              end
              
              OptionsScroller.ChildAdded:Connect(UpdateCanvasSize)
              OptionsScroller.ChildRemoved:Connect(UpdateCanvasSize)
              
              DropdownButton.MouseButton1Click:Connect(function()
                OptionsFrame.Visible = not OptionsFrame.Visible
                Arrow.Rotation = OptionsFrame.Visible and 180 or 0
                if OptionsFrame.Visible then
                    UpdateCanvasSize()
                end
              end)
              
              local DropdownApp = {
                Container = DropdownContainer,
                Button = DropdownButton,
                SetName = function(newName)
                  NameLabel.Text = newName
                end,
                SetDescription = function(text)
                  DropdownDesc.Text = text
                end,
                SetOptions = function(newOptions)
                  Options = newOptions
                  for _, child in pairs(OptionsScroller:GetChildren()) do
                    if child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("Frame") then
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
                    end
                  end
                end
              }
              return DropdownApp
            end,
            AddLabel = function(Info)
              local Info = Info or {}
              local Text = Info.Text or "Label"
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              local Font = Info.Font or Enum.Font.SourceSans
              local Size = Info.Size or 16
              local Color = Info.Color or Theme.TextColor
              local Alignment = Info.Alignment or Enum.TextXAlignment.Left
              
              local Label = new("TextLabel", {
                Size = UDim2.new(1, 0, 0, Size + 5),
                BackgroundTransparency = 1,
                TextColor3 = Color,
                TextSize = Size,
                Font = Font,
                Text = Text,
                TextXAlignment = Alignment,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              local LabelApp = {
                Label = Label,
                SetText = function(newText)
                  Label.Text = newText
                end,
                SetSize = function(newSize)
                  Label.Size = UDim2.new(1, 0, 0, newSize + 5)
                  Label.TextSize = newSize
                end,
                SetColor = function(newColor)
                  Label.TextColor3 = newColor
                end
              }
              
              return LabelApp
            end,
            AddImage = function(Info)
              local Info = Info or {}
              local Image = Info.Image or "rbxassetid://242459423"
              local Scale = Info.Scale or UDim2.new(1, 0, 0, 100)
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local ImageLabel = new("ImageLabel", {
                Size = Scale,
                BackgroundTransparency = 1,
                Image = Image,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              local ImageApp = {
                Image = ImageLabel,
                SetImage = function(newImage)
                  ImageLabel.Image = newImage
                end,
                SetScale = function(newScale)
                  ImageLabel.Size = newScale
                end
              }
              
              return ImageApp
            end,
            AddColorPicker = function(Info)
              local Info = Info or {}
              local Name = Info.Name or "ColorPicker"
              local Description = Info.Description or "Description"
              local Callback = Info.Callback or function() end
              local Default = Info.Default or Color3.new(1, 1, 1)
              local LayoutOrder = Info.LayoutOrder or #Section:GetChildren() + 1
              
              local ColorPickerContainer = new("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.TertiaryBg,
                BorderSizePixel = 0,
                LayoutOrder = LayoutOrder,
                Parent = Section
              })
              
              new("UICorner", {
                CornerRadius = Theme.CornerRadius,
                Parent = ColorPickerContainer
              })
              
              local NameLabel = new("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.SourceSans,
                Text = Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorPickerContainer
              })
              
              local ColorDisplay = new("Frame", {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -60, 0.5, -15),
                BackgroundColor3 = Default,
                BorderSizePixel = 0,
                Parent = ColorPickerContainer
              })
              
              new("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = ColorDisplay
              })
              
              local currentCallback = Callback
              local currentColor = Default
              
              ColorDisplay.MouseButton1Click:Connect(function()
                local colorPicker = new("Frame", {
                  Size = UDim2.new(0, 250, 0, 250),
                  Position = UDim2.new(0.5, 0, 0.5, 0),
                  BackgroundColor3 = Theme.PrimaryBg,
                  BorderSizePixel = 0,
                  AnchorPoint = Vector2.new(0.5, 0.5),
                  ZIndex = 10,
                  Parent = Window
                })
                
                new("UICorner", {
                  CornerRadius = Theme.CornerRadius,
                  Parent = colorPicker
                })
                
                local colorWheel = new("Frame", {
                  Size = UDim2.new(1, -20, 1, -60),
                  Position = UDim2.new(0, 10, 0, 10),
                  BackgroundColor3 = Color3.new(1, 0, 0), -- Placeholder, will be replaced by a gradient
                  BorderSizePixel = 0,
                  Parent = colorPicker
                })
                
                local saturationValue = new("Frame", {
                  Size = UDim2.new(1, 0, 1, 0),
                  BackgroundTransparency = 0,
                  BackgroundColor3 = Color3.new(1, 1, 1),
                  Parent = colorWheel
                })
                
                local hueGradient = new("Frame", {
                  Size = UDim2.new(1, 0, 1, 0),
                  BackgroundTransparency = 0,
                  Parent = saturationValue
                })
                
                new("UIGradient", {
                  Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
                  }),
                  Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                  }),
                  Rotation = 90,
                  Parent = hueGradient
                })
                
                local SaturationGradient = new("UIGradient", {
                  Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
                  }),
                  Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 0)
                  }),
                  Rotation = 0,
                  Parent = saturationValue
                })
                
                local CloseButton = new("TextButton", {
                  Size = UDim2.new(1, -20, 0, 30),
                  Position = UDim2.new(0, 10, 1, -40),
                  BackgroundColor3 = Theme.AccentColor,
                  BorderSizePixel = 0,
                  Text = "Close",
                  TextColor3 = Theme.TextColor,
                  TextSize = 16,
                  Font = Enum.Font.SourceSansBold,
                  Parent = colorPicker
                })
                
                new("UICorner", {
                  CornerRadius = UDim.new(0, 6),
                  Parent = CloseButton
                })
                
                CloseButton.MouseButton1Click:Connect(function()
                  colorPicker:Destroy()
                end)
                
                local isPicking = false
                local hue = 0
                
                local function hsvToRgb(h, s, v)
                  local i = math.floor(h * 6)
                  local f = h * 6 - i
                  local p = v * (1 - s)
                  local q = v * (1 - f * s)
                  local t = v * (1 - (1 - f) * s)
                  
                  local r, g, b
                  if i == 0 then r, g, b = v, t, p
                  elseif i == 1 then r, g, b = q, v, p
                  elseif i == 2 then r, g, b = p, v, t
                  elseif i == 3 then r, g, b = p, q, v
                  elseif i == 4 then r, g, b = t, p, v
                  else r, g, b = v, p, q end
                  
                  return Color3.new(r, g, b)
                end
                
                local function UpdateColor(input)
                  local x = input.Position.X - colorWheel.AbsolutePosition.X
                  local y = input.Position.Y - colorWheel.AbsolutePosition.Y
                  
                  local xRatio = math.min(math.max(x / colorWheel.AbsoluteSize.X, 0), 1)
                  local yRatio = math.min(math.max(y / colorWheel.AbsoluteSize.Y, 0), 1)
                  
                  local saturation = xRatio
                  local value = 1 - yRatio
                  
                  currentColor = hsvToRgb(hue, saturation, value)
                  ColorDisplay.BackgroundColor3 = currentColor
                  currentCallback(currentColor)
                end
                
                colorWheel.InputBegan:Connect(function(input)
                  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isPicking = true
                    UpdateColor(input)
                  end
                end)
                
                colorWheel.InputEnded:Connect(function(input)
                  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isPicking = false
                  end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                  if isPicking and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateColor(input)
                  end
                end)
                
                -- Hue Slider
                local HueSliderBar = new("Frame", {
                  Size = UDim2.new(1, -20, 0, 10),
                  Position = UDim2.new(0, 10, 0, 220),
                  BackgroundColor3 = Color3.new(1, 1, 1),
                  BorderSizePixel = 0,
                  Parent = colorPicker
                })
                
                new("UIGradient", {
                  Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
                    ColorSequenceKeypoint.new(1/6, Color3.new(1, 1, 0)),
                    ColorSequenceKeypoint.new(2/6, Color3.new(0, 1, 0)),
                    ColorSequenceKeypoint.new(3/6, Color3.new(0, 1, 1)),
                    ColorSequenceKeypoint.new(4/6, Color3.new(0, 0, 1)),
                    ColorSequenceKeypoint.new(5/6, Color3.new(1, 0, 1)),
                    ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
                  }),
                  Rotation = 0,
                  Parent = HueSliderBar
                })
                
                new("UICorner", {
                  CornerRadius = UDim.new(0, 5),
                  Parent = HueSliderBar
                })
                
                local HueHandle = new("Frame", {
                  Size = UDim2.new(0, 15, 0, 15),
                  Position = UDim2.new(0, -7, 0.5, -7),
                  BackgroundColor3 = Color3.new(1, 1, 1),
                  BorderSizePixel = 1,
                  BorderColor3 = Color3.new(0, 0, 0),
                  ZIndex = 2,
                  Parent = HueSliderBar
                })
                
                new("UICorner", {
                  CornerRadius = UDim.new(0, 7),
                  Parent = HueHandle
                })
                
                local isHueDragging = false
                
                local function UpdateHue(xPos)
                  local barWidth = HueSliderBar.AbsoluteSize.X
                  local newX = math.min(math.max(xPos, 0), barWidth)
                  hue = newX / barWidth
                  
                  local r, g, b = currentColor:ToHSV()
                  currentColor = hsvToRgb(hue, g, b)
                  
                  colorWheel.BackgroundColor3 = hsvToRgb(hue, 1, 1)
                  HueHandle.Position = UDim2.new(0, newX - 7, 0.5, -7)
                  
                  ColorDisplay.BackgroundColor3 = currentColor
                  currentCallback(currentColor)
                end
                
                HueSliderBar.InputBegan:Connect(function(input)
                  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isHueDragging = true
                    local xPos = input.Position.X - HueSliderBar.AbsolutePosition.X
                    UpdateHue(xPos)
                  end
                end)
                
                HueSliderBar.InputEnded:Connect(function(input)
                  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isHueDragging = false
                  end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                  if isHueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local xPos = input.Position.X - HueSliderBar.AbsolutePosition.X
                    UpdateHue(xPos)
                  end
                end)
              end)
              
              local ColorPickerApp = {
                Container = ColorPickerContainer,
                Display = ColorDisplay,
                SetName = function(newName)
                  NameLabel.Text = newName
                end,
                SetDescription = function(newDesc)
                  -- No visible description for ColorPicker
                end,
                SetCallback = function(newCallback)
                  currentCallback = newCallback
                end,
                Set = function(newColor)
                  currentColor = newColor
                  ColorDisplay.BackgroundColor3 = newColor
                  currentCallback(newColor)
                end,
                Get = function()
                  return currentColor
                end
              }
              
              return ColorPickerApp
            end,
          }
          return SectionApp
        end,
      }
      Tabs[TabApp] = true
      
      TabButton.MouseButton1Click:Connect(TabApp.SelectTab)
      
      return TabApp
    end,
  }
  
  if #TabScroller:GetChildren() == 1 then
      TabApp:SelectTab()
  end
  
  return WinApp
end

return Lib
