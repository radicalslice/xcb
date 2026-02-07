_level = {}
_level_index = 1
_level_count = 6
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
    tree_tileheight = 3,
    foreground = false,
    branches = {2, 3},
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
    -- mountain tile x, mountain tile y, mountain pos y, tree pos y, flat map x
    tiles = {17,1,24,30,21,24,27,7},
    branches = {4, 5},
    tree_tileheight = 3,
    foreground = false,
    mtn_f = function() end,
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
    branches = {4, 5},
    tree_tileheight = 3,
    trailcolor = 3,
    foreground = false,
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
    -- mountain tile x, mountain tile y, mountain pos y, tree pos y, flat map x
    tiles = { 13,3,28,40,21,24,27,7},
    branches = {6, 6},
    tree_tileheight = 2,
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
    -- mountain tile x, mountain tile y, mountain pos y, tree pos y, flat map x
    tiles = { 13,3,28,40,21,24,27,7},
    branches = {6, 6},
    tree_tileheight = 2,
    foreground = true,
    trailcolor = 5,
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
    -- mountain tile x, mountain tile y, mountain pos y, tree pos y, flat map x
    tiles = { 13,3,28,40,21,24,27,7},
    tree_tileheight = 2,
    foreground = true,
    trailcolor = 5,
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

-- ramps
--[[
-- one star --
- mini -
bup,8,-2
bdown,8
- normie -
bup,16,-2.5
bdown,16
- normie x2 -
bup,16,-2.5
bdown,16
flat,16
bup,16,-2.5
bdown,16
- flat -
bup,16,-2.5
flat,16
-- two star --
- mini -
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
- normie -
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
- flat -
bup,16,-2.5
flat,16
bup,16,-2.5
flat,16
-- three star --
- mini -
bdown,8
flat,32
bup,8,-2
bdown,8
flat,16
bup,8,-2
bdown,8
- normie -
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,24
flat,16
bup,8,-2
bdown,32
--]]
_levels = {
-- loft ladder
[[
ddown,256
bup,8,-2
bdown,8
ddown,32
flat,256
bup,16,-2.5
bdown,16
flat,112
obs,6,160
bup,16,-2.5
bdown,16
flat,112
bup,16,-2.5
bdown,16
flat,256
obs,0,160
flat,176
obs,0,160
flat,256
bup,16,-2.5
bdown,16
flat,112
bup,8,-2
bdown,8
flat,96
ddown,24
flat,176
ddown,24
flat,24
bup,16,-2.5
bdown,16
flat,112
bup,16,-2.5
bdown,16
flat,80
bup,16,-2.5
bdown,16
flat,112
bup,16,-2.5
bdown,16
flat,32
ddown,32
flat,176
obs,0,160
flat,80
obs,6,160
flat,64
ddown,128]],
-- coinflip
[[
ddown,144
flat,88
obs,0,160
flat,64
obs,6,160
flat,32
bup,16,-2.5
bdown,16
flat,112
bup,16,-2.5
bdown,16
flat,56
obs,0,160
flat,112
bup,8,-2
bdown,8
flat,72
obs,0,160
flat,96
bup,16,-2.5
bdown,16
flat,64
bup,8,-2
bdown,8
flat,88
obs,0,160
ddown,24
flat,56
obs,6,160
flat,64
bup,8,-2
bdown,8
flat,96
bup,16,-2.5
flat,112
obs,0,160
flat,48
obs,6,160
flat,48
obs,0,160
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,48
bup,16,-2.5
bdown,16
flat,112
obs,6,160
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
obs,6,160
flat,56
obs,0,160
ddown,64
flat,64
bup,8,-2
bdown,8
flat,16
bup,16,-2.5
flat,96
ddown,128]],
-- in the weeds
[[
ddown,144
flat,144

--,short weave
obs,6,115
flat,48
obs,0,115
flat,48
obs,6,115
flat,48

--,down into long weave
ddown,56
flat,56
obs,0,115
obs,0,96
obs,0,97
obs,0,115
flat,32
obs,6,115
obs,6,96
obs,6,115
flat,96


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
ddown,48
flat,32
bup,8,-2
bdown,8
flat,72
obs,6,115
flat,48
obs,0,115
flat,96
bup,8,-2
bdown,8
flat,64
obs,0,96
obs,0,115
obs,0,115
obs,0,97
flat,32
obs,6,115
obs,6,97
obs,6,115
flat,128

--,down into nothing, down time
ddown,64
flat,96

--,down into long weave
ddown,56
flat,56
obs,0,115
obs,0,97
obs,0,115
obs,0,96
flat,32
obs,6,115
obs,6,115
obs,6,97
flat,96

--,first obs ramp
bup,8,-2,obs
bdown,8
flat,96

--,down into long weave
ddown,56
flat,56
obs,6,115
obs,6,96
obs,6,115
obs,6,115
flat,32
obs,0,115
obs,0,97
obs,0,115
flat,48

--,obsramps with short weave
bup,8,-2,obs
bdown,8
flat,96
obs,6,115
flat,96


--,ddown into obsramp into short weave
ddown,96
flat,48
bup,8,-2,obs
bdown,8
flat,80
obs,6,115
flat,48
obs,0,115
flat,48
obs,6,115
flat,96

--,down into short weave
ddown,96
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
ddown,48
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
ddown,96
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

ddown,128]],
-- half-light
[[
ddown,144
flat,128
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,152
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
flat,152
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,64
obs,6,160
flat,64
obs,6,160
flat,64
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
flat,72
obs,0,160
flat,112
bup,8,-2
bdown,8
flat,48
ddown,32
flat,16
bup,8,-2
bdown,8
flat,8
ddown,48
flat,88
obs,6,160
flat,56
obs,0,160
flat,32
bup,16,-2.5
flat,48
ddown,72
bup,8,-2
bdown,8
ddown,72
flat,32
bup,8,-2
ddown,64
flat,64
obs,0,160
flat,96
obs,6,160
ddown,32
flat,8
bup,8,-2
bdown,8
flat,16
bup,8,-2
ddown,72
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
ddown,64
flat,96
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
ddown,24
flat,16
bup,8,-2
ddown,32
flat,96
ddown,128]],
-- improbable
[[
ddown,144
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
ddown,40
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
ddown,40
flat,128
obs,0
ddown,48
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
ddown,40
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
ddown,128]],
-- scoopsylvania
[[
ddown,144
flat,96
bup,8,-2
bdown,16
ddown,112
flat,64
bup,8,-2
bdown,8
flat,48
bup,16,-2.5
bdown,16
ddown,40
bup,8,-2
bdown,8
ddown,40
flat,64
bup,16,-2
flat,64
bup,16,-2.5
bdown,8
ddown,48
flat,16
bup,8,-2
bdown,8
ddown,96
flat,112
bup,8,-2
bdown,8
flat,16
bup,16,-2
flat,24
bup,16,-2
flat,64
bup,8,-2
bdown,8
ddown,96
flat,64
bup,8,-2
bdown,8
flat,40
bup,8,-2
bdown,8
flat,40
bup,16,-2.5
bdown,16
flat,8
ddown,32
flat,8
bup,16,-2.5
bdown,16
ddown,56
flat,8
bup,16,-2.5
bdown,16
ddown,96
flat,8
bup,16,-2.5
bdown,16
ddown,56
flat,64
bup,16,-2.5
bdown,16
flat,96
ddown,128]]
}

-- String -> []Range
function parse_ranges(str, x_base, y_base)
  local ranges = {}
  local jumps = {}
  local last_flat = y_base
  local x_curr = x_base
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
    elseif ramp_type == "ddown" then
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
  -- 96,-4.5
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
