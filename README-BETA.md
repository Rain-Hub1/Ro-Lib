# `Ro` Lib | Beta

# `Full` Example
```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Test.lua"))()

local Win = Lib:Window({
  Title = "My window!"
})

local MinWin = Win:MinimizeWin({
  Format = "Circle"
})

local Tab = Win:Tab({
  Name = "My tab!"
})

local Label = Tab:Label({
  Name = "My label!"
})

local Toggle = Tab:Toggle({
  Name = "My toggle",
  Desc = "On!",
  Default = true,
  Callback = function(v)
    print("Toggle: " .. v)
  end
})

local Toggle2 = Tab:Toggle({
  Name = "My toggle",
  Desc = "Off!",
  Default = false,
  Callback = function(v)
    print("Toggle: " .. v)
  end
})

local Button = Tab:Button({
  Name = "My",
  Desc = "Button!",
  Callback = function()
    print("Click!")
  end
})

local Dropdown = Tab:Dropdown({
  Name = "My",
  Desc = "Dropdown",
  Op = {"Options", "Multi!"},
  Default = "Options",
  Multi = true,
  Callback = function(v)
    print("Value: " .. v)
  end
})

local Slider = Tab:Slider({
  Name = "My",
  Desc = "Slider!",
  Default = 1,
  MinV = 1,
  MaxV = 10,
  Callback = function(v)
    print("Value: " .. v)
  end
})
