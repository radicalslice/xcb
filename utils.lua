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

-- type BoundingBox = [float, float, float, float]
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
  -- Count length of string
  -- Add padding to left and right
  local charwidth = #msg * 5
  return {
    msg = msg,
    ttl = 2, -- seconds, dawg
    draw = function(self)
      if self.ttl > 0 then
        rect(128-charwidth-1, 115, 127, 127, 4)
        rect(128-charwidth, 116, 126, 126, 9)
        rectfill(128 - charwidth+1, 117, 125, 125, 0)
        print("\^o410"..msg, 132 - charwidth, 119, 9)
      end
    end,
    update = function(self, dt)
      self.ttl -= dt
    end,
  }
end

-- using this to reset sensible defaults
-- after I jack up the pal for other things
function basepal()
    pal() 
    palt(11, true)
    palt(0, false)
end

-- continue playing main level
-- theme, but turn off channel 4
-- so it will be muted when the
-- next pattern starts playing
function star_mode_off()
  if not _debug.music then
    return
  end
	local chan_id = 3
	local bitflag = 1 << 6
	for sfx_id=0,12 do
		local addr = 0x3100 + 4*sfx_id + chan_id
		poke(addr, @addr | bitflag)
	end
end

-- play a short power up jingle
-- then segway into the main
-- level theme with channel 4
-- turned on for extra 
function star_mode_on()
  if not _debug.music then
    return
  end
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
