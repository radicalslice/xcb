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

-- As in: [x0,y0,x1,y1], the corners of the bounding box
-- collides_new :: BoundingBox -> BoundingBox -> Bool
function collides_new(s1,s2)
  if (
    s1[1] < s2[3]
    and s1[3] > s2[1]
    and s1[4] > s2[2]
    and s1[2] < s2[4]
    ) then
    return true
  end

  return false
end

function new_notif(msg)
  return {
    msg = msg,
    ttl = 2, -- seconds, dawg
    draw = function(self)
      if self.ttl > 0 then
        rect(64-1, 105, 127, 127, 9)
        rect(64, 106, 126, 126, 7)
        rectfill(64+1, 107, 125, 125, 0)
        spr(160, 69, 109, 6, 1)
        spr(176, 117, 110)
        print("\^o9ff"..msg, 69, 119, 7)
        _maptrails:draw()
        if flr(self.ttl * 60) % 10 < 7 then
          _level_config.notif_f0()
        end
      end
    end,
    update = function(self, dt)
      self.ttl -= dt
    end,
  }
end

function new_headsup(msg)
  return {
    init_ttl = 1.5,
    ttl = 1.5,
    draw = function(self)
      if self.ttl > 0 then
        local x = player.x
        for char in all(msg) do
          y = player.y - 16 + sin(time() - x / 40)*2
          x = print("\^o9ff"..char, x, y - (16 * (self.init_ttl - self.ttl) / self.init_ttl), 7)
        end
      end
    end,
    update = function(self, dt)
      self.ttl -= dt
    end,
  }
end

function basepal()
    pal() 
    palt(11, true)
    palt(0, false)
end

function star_mode_off()
	local chan_id = 3
	local bitflag = 1 << 6
	for sfx_id=0,12 do
		local addr = 0x3100 + 4*sfx_id + chan_id
		poke(addr, @addr | bitflag)
	end
end

function star_mode_on()
	local chan_id = 3
	local bitflag = 1 << 6
	for sfx_id=0,12 do
		local addr = 0x3100 + 4*sfx_id + chan_id
		poke(addr, @addr & ~bitflag)
	end
end

function compose(f, g)
  return function(...) return f(g(...)) end
end
