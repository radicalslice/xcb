VictoryScreen = {}

function VictoryScreen:new(o)
  o = o or {
    header = "nice boardin'!",
    levels = {},
    score = _savedboardscore,
    from_title = false,
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function VictoryScreen:draw()
  cls()
  palt(11, false)
  print("\^w\^t\^o9ff"..self.header, 11, 1, 7)
  local y = 18
  local x = 8

  for i, level in ipairs(self.levels) do
    local x = ((i-1) % 2 ~= 0 and 72 or 8)
    local y = 14 + (((i-1) \ 2) * 35)
    print("\^o9ff"..level, x, y, 7) 
    print_boardscore(self.score:lookup(level), x, y+6)
  end

  print("\^o9ff"..BUTTON_X.."/"..BUTTON_O..": return to title", 20, 120, 7)
end

function VictoryScreen:update()
  _timers.show_title:update(_now)
  _timers.show_title2:update(_now)

  if btnp(4) or btnp(5) then
    _init_wipe(0.4)
    if self.from_title then
      _timers.show_title2:init(0.2, _now)
    else
      _timers.show_title:init(0.2, _now)
    end
  end
end

function print_boardscore(score, x, y)
  for outerkey, innertable in pairs(score) do
    if outerkey != "name" then
      if t != "name" then 
        spr((innertable.val and 158 or 174), x+2, y)
        print(innertable.label, x+12, y + 3, (innertable.val and 7 or 5))
        y+=9
      end
    end
  end
end
