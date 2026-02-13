MapTrails = {}
function MapTrails:new(o)
  local base = {}
  o = o or base
  setmetatable(o, self)
  self.__index = self
  return o
end

function MapTrails:add(f)
  add(self, f)
end

function MapTrails:draw()
  for i, f in ipairs(self) do -- foreach draw function we've accumulated
    f()
  end
end
