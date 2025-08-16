level = {}
_level_index = 1
_level_count = 4
-- Map[XPos][mapx, mapy, sprnum]
_map_table = {}
-- []{x_pos, y_elevation}
_elevations = {}

-- how much time to add to the remaining time at each interlevel
_checkpoints = {30,32,32,20}

_configs = {
  {
    name = "aTTICUS",
    mountain_tile_x = 17,
    mountain_tile_y = 1,
    mountain_pos_y = 24,
    tree_pos_y = 30,
    tree_tileheight = 3,
    foreground = false,
    clouds = false,
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
      circfill(24, 24, 4, 10)
      circ(24, 24, 6, 10)
      circ(24, 24, 8, 10)
      spr(98, 24, 25, 2, 1)
      spr(98, 8, 15, 2, 1, true)
      spr(116, 16, 20, 2, 1)
    end,
  },
  {
    name = "cOINFLIP",
    mountain_tile_x = 17,
    mountain_tile_y = 1,
    mountain_pos_y = 24,
    tree_pos_y = 30,
    tree_tileheight = 3,
    foreground = false,
    clouds = true,
    mtn_f = function() end,
    sky_f = function()
      rectfill(-16,0,144,63,12)
    end,
    sun_f = function()
      circfill(52, 10, 5, 10)
    end,
    snow_f = function() end,
  },
  {
    name = "sOLAR rUN",
    mountain_tile_x = 13,
    mountain_tile_y = 3,
    mountain_pos_y = 28,
    tree_pos_y = 40,
    tree_tileheight = 2,
    foreground = true,
    clouds = true,
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
    snow_f = function() end,
  },
  {
    name = "wULF dEN",
    mountain_tile_x = 13,
    mountain_tile_y = 3,
    mountain_pos_y = 28,
    tree_pos_y = 40,
    tree_tileheight = 2,
    foreground = true,
    clouds = true,
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
[[
ddown,512
bup,8,-2
bdown,8
ddown,32
flat,256
bup,16,-2.5
bdown,16
flat,256
obs,6
flat,112
bup,16,-2.5
bdown,16
flat,256
obs,0
flat,176
obs,0
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
obs,0
flat,80
obs,6
flat,64
ddown,128]],
[[
ddown,144
flat,88
obs,0
flat,64
obs,6
flat,32
bup,16,-2.5
bdown,16
flat,112
bup,16,-2.5
bdown,16
flat,56
obs,0
flat,112
bup,8,-2
bdown,8
flat,72
obs,0
flat,96
bup,16,-2.5
bdown,16
flat,64
bup,8,-2
bdown,8
flat,88
obs,0
ddown,24
flat,56
obs,6
flat,64
bup,8,-2
bdown,8
flat,96
bup,16,-2.5
flat,112
obs,0
flat,48
obs,6
flat,48
obs,0
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,48
bup,16,-2.5
bdown,16
flat,112
obs,6
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
obs,6
flat,56
obs,0
ddown,64
flat,64
bup,8,-2
bdown,8
flat,16
bup,16,-2.5
flat,96
ddown,128]],
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
obs,6
flat,64
obs,6
flat,64
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
flat,72
obs,0
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
obs,6
flat,56
obs,0
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
obs,0
flat,96
obs,6
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
ddown,60
flat,60
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
    local x_start = x_curr
    local ramp_type = vals[1]
    local x_end = x_start + vals[2]
    local range = {x_start = x_start, x_end = x_end}
    -- {ramp_type, x_end, y_value, jump_dy}
    if ramp_type == "bup" then
      -- trying to shadow
      local my_flat = last_flat
      range.f = function(x_pos)
        return my_flat - (x_pos - x_start), -1
      end
      local jump = {
        used = false,
        x = x_end,
        dy = vals[3],
      }
      last_flat = last_flat - vals[2]
      add(jumps, jump)
    elseif ramp_type == "bdown" then
      local my_flat = last_flat
      -- {ramp_type, x_end, y_value}
      range.f = function(x_curr)
        -- i think this -16 works because our ramps are (so far) always 16 px high and wide
        return my_flat - ((x_end - x_start) * -((x_curr - x_start) / (x_end - x_start))), 1
        -- this one is curvy and kinda owns
        -- return y_base - ((x_end - x_curr) * -((x_curr - x_start) / (x_end - x_start))), 2
      end
      last_flat = last_flat + vals[2]
    elseif ramp_type == "ddown" then
    -- {ramp_type, x_end, y_value}
      local my_flat = last_flat
      range.f = function(x_curr)
        return my_flat - ((x_end - x_start) * -((x_curr - x_start) / (x_end - x_start))), 1
      end
      last_flat = last_flat + vals[2]
    elseif ramp_type == "flat" then
    -- {ramp_type, x_end, y_value, new_x_flat}
      local my_flat = last_flat
      range.f = function(x_curr)
          return my_flat, 0
      end
    end
    if ramp_type != "obs" then
      add(ranges, range)
      x_curr = x_end
    end
  end)

  -- here, add some extra flat and a downward slope to accommodate level transitions
  -- add(ranges, 
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
    -- printh("elevation pair: "..j[1]..","..j[2])
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
