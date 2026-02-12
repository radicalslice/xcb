VictoryScreen = {}

function VictoryScreen:new(o)
  o = o or {
    header = "nice boardin'!",
    levels = {}
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function VictoryScreen:draw()
  cls()
  palt(11, false)
  print("\^w\^t\^o410"..self.header, 12, 0, 9)
  local y = 18
  local x = 8

  for i, level in ipairs(self.levels) do
    local x = ((i-1) % 2 ~= 0 and 72 or 8)
    local y = 14 + (((i-1) \ 2) * 35)
    print("\^o410"..level, x, y, 9) 
    print_boardscore(_savedboardscore:lookup(level), x, y+6)
  end

  --[[
  print("\^o410"..player.level_history[2], 72, 18, 9) 
  print_boardscore(_boardscore:lookup(player.level_history[2]), 72, 24)

  print("\^o410"..player.level_history[3], 8, 54, 9) 
  print_boardscore(_boardscore:lookup(player.level_history[3]), 8, 60)

  print("\^o410"..player.level_history[4], 72, 54, 9) 
  print_boardscore(_boardscore:lookup(player.level_history[4]), 72, 60)
  --]]

  -- if _timers.input_freeze.ttl == 0 then
  print("\^o410"..BUTTON_X.."/"..BUTTON_O..": return to title", 20, 120, 9)
  -- end
end

function VictoryScreen:update()
  _timers.show_title:update(_now)

  if btnp(4) or btnp(5) then
    _init_wipe(0.4)
    _timers.show_title:init(0.2, _now)
  end
end

function print_boardscore(score, x, y)
  for t, v in pairs(score) do
    if t != "name" then 
      spr((v and 158 or 174), x+2, y)
      print(t, x+12, y + 3, (v and 7 or 5))
      y+=9
    end
  end
end
