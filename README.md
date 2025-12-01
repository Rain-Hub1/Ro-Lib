# `Ro` Lib

## `Load`
```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Source.lua"))()
```

## `Load` | Beta
```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Test.lua"))()
```

## `Window`
```lua
local Win = Lib:Window({
  Title = "My Window!"
})
```

### `Extra` MinimizeWin
```lua
local MinWin = Win:MinimizeWin({
  Format = "Circle"
})

--[[
  Circle,
  Square,
  SquareBorder
]]
```

## `Tab`
```lua
local Tab = Win:Tab({
  Name = "My Tab!"
})
```

## `Label`
```lua
local Label = Tab:Label({
  Name = "My label!"
})
```

## `Button` | New
```lua
local Button = Tab:Button({
  Name = "My",
  Desc = "Button!",
  Callback = function()
    print("Click!")
  end
})
```

## `Toggle`
```lua
local Toggle = Tab:Toggle({
  Name = "My toggle",
  Desc = "On!",
  Default = true,
  Callback = function(V)
    print(V)
  end
})
```

## `Dropdown` | New
```lua
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
```

## `Full` Example
```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Source.lua"))()

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
