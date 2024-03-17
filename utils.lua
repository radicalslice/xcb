get_tile_from_pos = nil
function _get_tile_from_pos(start_tile_x, start_tile_y)
  return function(pos_x, pos_y)
    return (pos_x \ 8) + start_tile_x, (pos_y \ 8) + start_tile_y
  end
end

function exists(e, tbl)
  for i=1,#tbl do
    if tbl[i] == e then
      return true
    end
  end
  return false
end

function draw_ctrls(x, y, clr)
  -- draw controls on screen
  print("⬅️", x-4, y+5, btn(0) and 11 or clr)
  print("⬆️", x, y, btn(2) and 11 or clr)
  print("➡️", x+4, y+5, btn(1) and 11 or clr)
  print("⬇️", x, y+10, btn(3) and 11 or clr)
  print("❎", x+13, y+8, btn(4) and 11 or clr)
  print("🅾️", x+21, y+5, btn(5) and 11 or clr)
 
end


function new_cycler(cycle_ttl, colors) 
  return {
    cycle_ttl = cycle_ttl,
    colors = colors,
    current = 1, -- current index into colors
    update = function(self, dt)
      self.cycle_ttl -= dt 
      if self.cycle_ttl <= 0 then
        self.current += 1
        if self.current > #self.colors then
          self.current = 1
        end
        self.cycle_ttl = cycle_ttl
      end
    end,
    get_color = function(self)
      return self.colors[self.current]
    end,
  }
end
