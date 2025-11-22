local Lib = {}

local LibInfo = {
  Name = "Ro Lib",
  Bugs = "No bugs.",
  Version = "1.0"
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
  
  local CloseBtn = new("ImageButton", {
   Size = UDim2.new(0, 30, 0, 30),
   Position = UDim2.new(0, 400, 0, 30),
   Image = "rblxassetid://10747384394",
   BackgroundColor3 = Color3.fromHex("#fb542b"),
   Parent = Tbar
  })

  CloseBtn.MouseButton1Click:Connect(function()
    s:Destroy()
  end)
  
  local Title = Info.Title or "Window"
  print("Title: " .. Title)
end

function Lib:Demo()
 Lib:Window({
  Title = "Test"
 })
end

print(" Library Loaded!")
print(" <-- Info -->")
print("  Bugs: " .. LibInfo.Bugs)
print("  Name: " .. LibInfo.Name)
print("  Version: " .. LibInfo.Version)
return Lib
