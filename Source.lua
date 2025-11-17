local RoLib = {}

function new(c, p)
 local k = Instance.new(c)
  for pp, v in pairs(p or {}) do
   k[pp] = v
  end
 return k
end

function RoLib:Window()
end

function RoLib:Demo()
  RoLib:Window()
end

return RoLib
