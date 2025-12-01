# `Ro` Lib

## `Load`
```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Source.lua"))()
```

## `Window`
```lua
local Win = Lib:Window({
  Title = "My Window!"
})
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

## `Toggle`
```lua
local Toggle = Tab:Toggle({
  Name = "My toggle",
  Desc = "On!",
  Defalth = true,
  Callback = function(V)
    print(V)
  end
})
```

## `Full` Example
```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Source.lua"))()

local Win = Lib:Window({
  Title = "My window!"
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
  Defalth = true,
  Callback = function(v)
    print("Toggle: " .. v)
  end
})

local Toggle2 = Tab:Toggle({
  Name = "My toggle",
  Desc = "Off!",
  Defalth = false,
  Callback = function(v)
    print("Toggle: " .. v)
  end
})
