local Lib = {}

local LibInfo = {
  Name = "Ro Lib",
  Version = 1.0
}

function new(c, p)
  local k = Instance.new(c)
   for pp, v in pairs(p or {}) do
    k[pp] = v
   end
  return k
end

function Lib:Window(Info)
  local Info = Info or {}
  local CoreGui = game:GetService("CoreGui")
  
  if CoreGui:FindFirstChild("Ro Lib") then
   CoreGui:FindFirstChild("Ro Lib"):Destroy()
  end
 
  local s = new("ScreenGui", {
   Name = "Ro Lib",
   Parent = CoreGui
  })
 
  local Win = new("Frame", {
   Size = UDim2.new(0, 410, 0, 305),
   Position = UDim2.new(0, 410, 0, 15),
   BackgroundColor3 = Color3.fromHex("#fb542b"),
   Parent = s
  })
 
  new("UICorner", {
   Parent = Win
  })
 
  local Tbar = new("Frame", {
   Size = UDim2.new(0, 410, 0, 35),
   Position = UDim2.new(0, 0, 0, 0),
   BackgroundColor3 = Color3.fromHex("#ff4113"),
   Parent = Win
  })
 
  new("UICorner", {
   Parent = Tbar
  })
 
  local Title = Info.Title or "Window"
end

function Lib:Demo()
 Lib:Window({
  Title = "Test"
 })
end

print(" Library Loaded!")
print(" <-- Info -->")
print("  Version: " .. LibInfo.Version)
print("  Name: " .. LibInfo.Name)
return Lib
