ItemMgr = {}
function ItemMgr:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function ItemMgr:init(pos)
  self.x = pos[1]
  self.y = pos[2]
  self.visible = true
end

function ItemMgr:update(dt)
end

function ItemMgr:get_bb()
  return {flr(self.x),flr(self.y),flr(self.x)+7,flr(self.y)+10}
end

function ItemMgr:draw()
  if not self.visible then
    return
  end
  palt(11, true)
  palt(0, false)
  spr(157, self.x, self.y, 1, 2)
  palt()
  -- local bb = self:get_bb()
  -- rect(bb[1],bb[2],bb[3],bb[4],11)
end

