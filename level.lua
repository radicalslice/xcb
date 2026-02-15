_level = {}
_level_index = 1
_level_config = {}
-- Map[XPos][mapx, mapy, sprnum]
_map_table = {}
-- []{x_pos, y_elevation}
_elevations = {}
_level_names = {
"lOFT lADDER",
"cOINFLIP",
"iN tHE wEEDS",
"hALF-lIGHT",
"iMPROBABLE",
"sCOOPSYLVANIA",
}

-- how much time to add to the remaining time at each interlevel
_checkpoints = {40,35,45,35,35,25}

_level_configs = {
  {
    name = _level_names[1],
    -- mountain tile x, mountain tile y, mountain pos y, tree pos y, flat map x,ramp left start,ramp right end,fill color for under course
    tiles = {17,1,24,30,21,24,27,7},
    item_pos = {1828, 240},
    tree_tileheight = 3,
    foreground = false,
    notif_f0 = function()
      rectfill(69, 111, 70, 113, 9)
    end,
    notif_f1 = function()
      rectfill(69, 111, 70, 113, 9)
      for x=72,78,2 do
        pset(x, 112, 9)
      end
    end,
    draw_f = function()
      rectfill(0, 0, 128, 128, 12)
      local cloudheight = 6
      local gapheight = 3
      local next_y = 0
      while cloudheight > 0 do
        rectfill(0, next_y, 128, next_y + cloudheight, 7) 
        next_y = next_y + cloudheight + gapheight
        cloudheight -= 1
        gapheight += 1
      end
      circ(24, 24, 6, 10)
      circ(24, 24, 8, 10)
      spr(98, 24, 25, 2, 1)
      spr(98, 8, 15, 2, 1, true)
      spr(116, 16, 20, 2, 1)
    end,
  },
  {
    name = _level_names[2],
    tiles = {17,1,24,30,21,24,27,7},
    item_pos = {1040, 130},
    branches = {3, 4},
    tree_tileheight = 3,
    notif_f0 = function()
      rectfill(80, 111, 81, 113, 9)
    end,
    notif_f1up = function()
      rectfill(80, 111, 81, 113, 9)
      spr(177, 77, 109, 2, 1)
    end,
    notif_f1down = function()
      rectfill(80, 111, 81, 113, 9)
      spr(193, 77, 109, 2, 1)
    end,
    foreground = false,
    sky_f = function()
      rectfill(-16,0,144,63,12)
    end,
    sun_f = function()
      circfill(52, 10, 5, 10)
    end,
  },
  {
    name = _level_names[3],
    tiles = { 17,1,24,30,29,32,35,4},
    item_pos = {2342, 320},
    branches = {5, 6},
    tree_tileheight = 3,
    trailcolor = 3,
    foreground = false,
    notif_f0 = function()
      rectfill(93, 109, 94, 111, 9)
    end,
    notif_f1up = function()
      rectfill(93, 109, 94, 111, 9)
      spr(179, 93, 109, 2, 1)
    end,
    notif_f1down = function()
      rectfill(93, 109, 94, 111, 9)
      spr(179, 93, 109, 2, 1)
      spr(196, 101, 109, 2, 1)
    end,
    draw_f = function()
      rectfill(0, 0, 128, 128, 12)
      line(0,1,128,1,1)
      line(0,3,128,3,1)
      line(0,5,128,5,1)
      circfill(52, 10, 5, 10)
      circ(52, 10, 8, 10)
    end,
  },
  {
    name = _level_names[4],
    tiles = { 13,3,28,40,21,24,27,7},
    item_pos = {2440, 465},
    branches = {5, 6},
    tree_tileheight = 2,
    notif_f0 = function()
      rectfill(93, 113, 94, 115, 9)
    end,
    notif_f1up = function()
      rectfill(93, 113, 94, 115, 9)
      spr(180, 101, 109)
      spr(195, 93, 109)
    end,
    notif_f1down = function()
      rectfill(93, 113, 94, 115, 9)
      spr(195, 93, 109, 2, 1)
    end,
    foreground = true,
    mtn_f = function()
      pal(6, 5)
      pal(7, 6)
    end,
    sky_f = function()
      pal(12, 9)
      rectfill(-16,0,144,63,12)
    end,
    sun_f = function()
      circfill(88, 20, 5, 8)
    end,
  },
  {
    name = _level_names[5],
    tiles = { 13,3,28,40,21,24,27,7},
    item_pos = {1300, 38},
    tree_tileheight = 2,
    foreground = true,
    trailcolor = 5,
    notif_f0 = function()
      rectfill(107, 109, 108, 111, 9)
    end,
    mtn_f = function()
      pal(6, 0)
      pal(7, 6)
      pal(7, 5)
    end,
    course_f = function()
      pal(6, 7)
      pal(7, 6)
    end,
    sky_f = function()
      -- pal(12, 9)
      rectfill(-16,0,144,63,2)
    end,
    sun_f = function()
      circfill(88, 20, 5, 9)
    end,
    snow_f = function()
      pal(7, 6)
      pal(3, 5)
    end,
  },
  {
    name = _level_names[6],
    tiles = { 13,3,28,40,21,24,27,7},
    item_pos = {1950, 720},
    tree_tileheight = 2,
    foreground = true,
    trailcolor = 5,
    notif_f0 = function()
      rectfill(107, 113, 108, 115, 9)
    end,
    mtn_f = function()
      pal(6, 0)
      pal(7, 6)
      pal(7, 5)
    end,
    sky_f = function()
      pal(12, 1)
    end,
    sun_f = function()
      circfill(100, 28, 3, 7)
    end,
    snow_f = function()
      pal(7, 6)
      pal(3, 5)
    end,
    course_f = function()
      pal(6, 7)
      pal(7, 6)
    end,
  },
}

_levels = {
-- loft ladder
[[
bdown,192
bup,8,-2
bdown,8
bdown,32
flat,128
bup,16,-2.5
bdown,16
flat,96
obs,6,181
bup,16,-2.5
bdown,16
flat,96
bup,16,-2.5
bdown,16
flat,128
obs,0,181
flat,176
obs,0,181
flat,128
bup,16,-2.5
bdown,16
flat,96
bup,16,-2.5
bdown,16
flat,112
bup,8,-2
bdown,8
flat,96
bdown,24
flat,112
bdown,24
flat,24
bup,16,-2.5
bdown,16
flat,96
bup,16,-2.5
bdown,16
flat,80
bup,16,-2.5
bdown,16
flat,96
obs,6,181
flat,64
obs,0,181
flat,64
bup,16,-2.5
bdown,16
flat,32
bdown,32
flat,112
obs,0,181
flat,80
obs,6,181
flat,64
bdown,128]],
-- coinflip
[[
bdown,144
flat,88
obs,0,181
flat,64
obs,6,181
flat,32
bup,16,-2.5
bdown,16
flat,112
bup,16,-2.5
bdown,16
flat,56
obs,0,181
flat,112
bup,8,-2
bdown,8
flat,72
obs,0,181
flat,96
bup,16,-2.5
bdown,16
flat,96
bup,8,-2
bdown,8
flat,88
obs,0,181
bdown,24
flat,56
obs,6,181
flat,64
bup,8,-2
bdown,8
flat,96
bup,16,-2.5
flat,112
obs,0,181
flat,48
obs,6,181
flat,48
obs,0,181
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,48
bup,16,-2.5
bdown,16
flat,112
obs,6,181
flat,64
bup,8,-2
bdown,8
flat,16
bup,16,-2
bdown,16
flat,112
bup,16,-2.5
flat,48
bup,8,-2
bdown,8
flat,64
bup,16,-2.5
flat,56
obs,6,181
flat,56
obs,0,181
bdown,64
flat,64
bup,8,-2
bdown,8
flat,16
bup,16,-2.5
flat,96
bdown,128]],
-- in the weeds
[[
bdown,144
flat,64
bup,8,-2
bdown,8

--,short weave
obs,6,115
flat,64
obs,0,115
flat,48
obs,6,115
flat,48

--,down into long weave
bup,8,-2
bdown,8
bdown,56
flat,48
obs,0,115
obs,0,96
obs,0,97
obs,0,115
flat,32
obs,6,115
obs,6,96
obs,6,115
bup,8,-2
bdown,8
flat,80
bup,8,-2
bdown,8


--,short weave
obs,6,115
flat,48
obs,0,115
flat,48
obs,6,115
flat,48

--, hop into short weave
bup,8,-2
bdown,8
flat,64
obs,0,115
flat,48
obs,6,115
obs,6,96
obs,6,115
flat,48
obs,0,115
flat,48

--,down into ramp into long weave
bdown,48
flat,32
bup,8,-2
bdown,8
flat,72
obs,6,115
flat,96
obs,0,115
flat,96
bup,8,-2
bdown,8
flat,64
obs,0,96
obs,0,115
obs,0,115
obs,0,97
bup,8,-2
bdown,8
flat,64
obs,6,115
obs,6,97
obs,6,115
flat,64

--,short hop then down into nothing, down time
bdown,48
flat,32

--,down into long weave
bup,8,-2
bdown,8
bdown,48
flat,56
obs,0,115
obs,0,97
obs,0,115
obs,0,96
flat,32
obs,6,115
obs,6,115
obs,6,97
flat,80

--,first obs ramp
bup,8,-2,obs
bdown,8
--,10
flat,96

--,down into long weave
bup,8,-2
bdown,8
flat,16
bdown,56
flat,56
obs,6,115
obs,6,115
flat,56
obs,0,97
obs,0,115
flat,48

--,obsramps with short weave
bup,8,-2,obs
bdown,8
flat,96
obs,6,115
flat,64


--,bdown into obsramp into short weave
bdown,32
flat,48
bup,8,-2,obs
bdown,8
flat,80
obs,6,115
flat,48
obs,0,115
flat,48
obs,6,115
flat,64
bup,8,-2
bdown,8

--,down into short weave
bdown,96
flat,48
obs,0,115
obs,0,115
flat,32
obs,6,115
obs,6,115
obs,6,96
obs,6,115
flat,32
obs,0,115
obs,0,96
obs,0,115
obs,0,97
flat,32


--,down into coda weave
bdown,48
flat,96
obs,6,115
flat,32
obs,0,115
flat,32
obs,6,115
flat,32
obs,0,115
flat,24
obs,6,115
flat,24
bup,8,-2
bdown,8
flat,32

--,coda ramps
bdown,96
flat,48
bup,8,-2
bdown,8
flat,48
bup,8,-2
bdown,8
flat,48
bup,8,-2
bdown,8
flat,96
bup,8,-2,obs
bdown,8
flat,48
obs,6,115
obs,6,97
obs,6,115
obs,6,96
obs,6,115
flat,64

--,final leap
bup,8,-2
bdown,8
flat,16

bdown,128]],
-- half-light
[[
bdown,112
flat,96
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,112
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
flat,112
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,64
obs,6,181
flat,64
obs,6,181
flat,64
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
--,pairs end
flat,72
obs,0,181
flat,112
bup,8,-2
bdown,8
flat,48
bdown,32
flat,64
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,16
bdown,48
flat,64
obs,6,181
flat,56
obs,0,181
flat,32
bup,16,-2.5
flat,48
bdown,32
flat,64
bup,16,-2.5
flat,48
bdown,32
flat,48
bup,8,-2
bdown,8
flat,16
bup,8,-2
bdown,32
flat,96
bup,16,-2.5
flat,96
bup,8,-2
bdown,8
flat,40
bup,8,-2
bdown,8
flat,16
bup,16,-2.5
bdown,64
flat,96
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,24
flat,16
bup,8,-2
bdown,32
flat,96
bdown,128]],
-- improbable
[[
bdown,144
flat,96
bup,8,-2
bdown,8
flat,96
bup,8,-2
bdown,8
flat,96
bup,8,-2
bdown,8
flat,56
obs,0
flat,40
obs,6
flat,96
--,imp0
bup,8,-2
bdown,8
flat,16
bup,48,-2.5
flat,128
obs,0
flat,48
obs,6
--,backdown
bup,8,-2
bdown,8
flat,16
bdown,40
flat,128
obs,0
--,imp1
bup,16,-2.5
bdown,16
flat,16
bup,64,-2.5
flat,128
obs,0
flat,48
obs,6
--,backdown
bup,8,-2
bdown,8
flat,16
bdown,40
flat,128
obs,0
bdown,48
flat,128
--,imp2
bup,24,-2.5
bdown,8
flat,16
bup,80,-2.5
flat,128
obs,0
flat,48
obs,6
--,backdown
bup,8,-2
bdown,8
flat,16
bdown,40
flat,128
obs,0
flat,32
obs,6
flat,32
obs,0
flat,128
--,up up up
bup,8,-2
bdown,8
flat,16
bup,32,-2.5
flat,64
bup,16,-2.5
bdown,8
flat,16
bup,48,-2.5
flat,64
bup,24,-2.5
bdown,8
flat,16
bup,64,-2.5
flat,64
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,64
obs,0
flat,40
obs,6
flat,40
obs,0
flat,96
bdown,128]],
-- scoopsylvania
[[
bdown,144
flat,96
bup,8,-2
bdown,16
bdown,112
flat,64
bup,8,-2
bdown,8
flat,48
bup,16,-2.5
bdown,16
bdown,40
bup,8,-2
bdown,8
bdown,40
flat,64
bup,16,-2
flat,64
bup,16,-2.5
bdown,8
bdown,48
bup,8,-2
bdown,8
bdown,96
flat,112
bup,8,-2
bdown,8
bup,16,-2
flat,24
bup,16,-2
flat,64
bup,8,-2
bdown,8
bdown,96
flat,64
bup,8,-2
bdown,8
flat,40
bup,8,-2
bdown,8
flat,40
bup,16,-2.5
bdown,48
flat,8
bup,16,-2.5
bdown,16
bdown,56
bup,16,-2.5
bdown,16
bdown,96
bup,16,-2.5
bdown,16
bdown,56
flat,64
bup,16,-2.5
bdown,16
flat,256
bdown,128]]
}

-- String -> []Range
function parse_ranges(str)
  local ranges = {}
  local jumps = {}
  local x_curr = 0
  local last_flat = 8
  foreach(split(str, "\n"), function(substr)
    local vals = split(substr, ",")
    if substr == "" or vals[1] == "--" then
      return
    end
    local x_start = x_curr
    local ramp_type, x_end = vals[1], x_start + vals[2]
    local range = {x_start = x_start, x_end = x_end}
    -- pinning this value because we might modify it below
    local my_flat = last_flat
    -- {ramp_type, x_end, y_value, jump_dy}
    if ramp_type == "bup" then
      range.f = function(x_pos)
        return my_flat - x_pos + x_start, -1
      end
      if vals[4] != nil then
        range.map = {33, 5}
      end
      local jump = {
        used = false,
        x = x_end,
        dy = vals[3],
      }
      last_flat = last_flat - vals[2]
      add(jumps, jump)
    elseif ramp_type == "bdown" then
      -- {ramp_type, x_end, y_value}
      range.f = function(x_curr)
        return my_flat + x_curr - x_start, 1
      end
      last_flat = last_flat + vals[2]
    elseif ramp_type == "flat" then
    -- {ramp_type, x_end, y_value, new_x_flat}
      range.f = function(x_curr)
          return my_flat, 0
      end
    end

    if ramp_type != "obs" then
      add(ranges, range)
      x_curr = x_end
    elseif ramp_type == "obs" then
      add(ranges, {x_start = x_curr, x_end = x_curr+8, f = function(x_curr)
        return my_flat, 0
      end})
      x_curr += 8
    end
  end)

  return ranges, jumps, x_curr
end

-- String -> []Jump
function parse_jumps(str)
  local jumps = {}
  foreach(split(str, "\n"), function(substr)
    -- {x_start, ramp_type, x_end, y_value}
    local vals = split(substr, ",")
    local jump = {
      used = false,
      x = vals[1],
      dy = vals[2],
    }
    add(jumps, jump)
  end)

  return jumps
end

-- Int -> Level -> ?Range
function find_range(x, level)
  for r in all(level.ranges) do
    if x >= r.x_start and x < r.x_end then
      return r
    end
  end
  return nil
end

-- Int -> _elevations -> y_elevation
function find_elevation(x, es)
  -- x
  for i, j in pairs(es) do
    if es[i+1] and x >= j[1] and x < es[i+1][1] then
      return es[i][2]
    end
  end
  -- assume last elevation if we go this far
  return es[#es][2]
end

-- Int -> Level -> Int
function find_jump(x, level)
  for b in all(level.jumps) do
    if x >= b.x and b.used == false then
      b.used = true
      return b.dy
    end
  end
  return 0
end
