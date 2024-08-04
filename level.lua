level = {}
-- Map[XPos][mapx, mapy, sprnum]
_map_table = {}

-- how much time to add to the remaining time at each interlevel
_checkpoints = {20}

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
_level1 = [[
flat,32
ddown,96
flat,96
bup,16,-2.5
bdown,16
flat,96
bup,8,-2
bdown,8
flat,96
bup,16,-2.5
bdown,16
flat,64
ddown,24
flat,64
bup,8,-2
bdown,8
flat,96
bup,16,-2.5
flat,96
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,8
bup,16,-2.5
bdown,16
flat,64
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,96
bup,16,-2.5
flat,32
bup,8,-2
bdown,8
flat,64
bup,16,-2.5
flat,40
ddown,64
flat,64
bup,8,-2
bdown,8
flat,16
bup,16,-2.5
flat,16
bup,16,-2.5
flat,16
flat,128]]
-- type, x_length, height for flats
-- this levelX one is pretty sick, you can ride a boost through like the entire thing..
_levelX = [[
flat,128
bup,8,-1.5
bdown,8
flat,32
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,128
bup,8,-2
bdown,64
flat,128
bup,24,-2
bdown,64,-2
flat,16
bup,24,-2
flat,32
bup,8,-2
bdown,128
flat,128]]
--[[
_menagMini = [[
flat,128
bup,8,-2
bdown,8
flat,128
bup,8,-2
bdown,8
flat,128
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,128
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,128
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,16
bup,8,-2
bdown,8
flat,128
bup,8,-2
bdown,8
flat,32
bup,8,-2
bdown,8
flat,16
bup,8,-2
bdown,8
flat,128]]--
--[[
_menagFlats = [[
flat,128
bup,16,-2.5
flat,128
bup,16,-2.5
flat,128
bup,16,-2.5
flat,16
bup,16,-2.5
flat,128
bup,16,-2.5
flat,16
bup,16,-2.5
flat,16
bdown,24
flat,128
bup,16,-2.5
flat,16
bup,16,-2.5
flat,16
bdown,24
flat,128]]--
--[[
_menagReg = [[
flat,128
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,16
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,16
bup,16,-2.5
bdown,16
flat,128
bup,16,-2.5
bdown,16
flat,16
bup,16,-2.5
bdown,24
flat,16
bup,8,-2
bdown,32
flat,128
bup,16,-2.5
bdown,16
flat,16
bup,16,-2.5
bdown,16
flat,24
bup,8,-2
bdown,32
flat,128]]--


-- Steep guys
function ramp2u(r, y_base, x_curr)
  return y_base - 2 * (x_curr - r.x_start), -3
end
function ramp2d(r, y_base, x_curr)
  return y_base - 2 * (r.x_end - x_curr), 3
end

-- Shallow boys
function ramp1u(r, y_base, x_curr)
 return y_base - ((x_curr - r.x_start) \ 2), -1
end
function ramp1d(r, y_base, x_curr)
 return y_base - ((r.x_end - x_curr) \ 2), 1
end


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
        -- somehow this -16 value works? I have no idea why yet
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
    add(ranges, range)
    x_curr = x_end
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
  local found = false
  for r in all(level.ranges) do
    if x >= r.x_start and x < r.x_end then
      return r
    end
  end
  return nil
end

-- Int -> Level -> Int
function find_jump(x, level)
  local found = false
  for b in all(level.jumps) do
    if x >= b.x and b.used == false then
      b.used = true
      return b.dy
    end
  end
  return 0
end
