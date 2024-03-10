level = {}
-- Map[XPos][mapx, mapy, sprnum]
_map_table = {}
_camera_x_offset = 24

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
function parse_ranges(str)
  -- 80,basic:
  local ranges = {}
  -- assume we start from y = LAST_FLAT
  local last_flat = LAST_FLAT
  local x_max = 0
  foreach(split(str, "\n"), function(substr)
    -- {x_start, ramp_type, x_end, y_value}
    local vals = split(substr, ",")
    --[[ 
    printh("x_start: "..vals[1])
    printh("ramp_type: "..vals[2])
    printh("x_length: "..vals[3])
    ]]--
    local x_start = vals[1]
    local ramp_type = vals[2]
    local x_end = x_start + vals[3]
    if x_end > x_max then
      x_max = x_end
      printh("new x_max: "..x_max)
    end
    local range = {x_start = x_start, x_end = x_end}
    if ramp_type == "bup" then
      -- trying to shadow
      local my_flat = last_flat
      range.f = function(x_curr)
        return my_flat - (x_curr - vals[1]), -1
      end
    elseif ramp_type == "bdown" then
      local my_flat = last_flat
      range.f = function(x_curr)
        -- somehow this -16 value works? I have no idea why yet
        return my_flat - 16 - ((x_end - x_start) * -((x_curr - x_start) / (x_end - x_start))), 1
        -- this one is curvy and kinda owns
        -- return y_base - ((x_end - x_curr) * -((x_curr - x_start) / (x_end - x_start))), 2
      end
    elseif ramp_type == "ddown" then
      local my_flat = last_flat
      range.f = function(x_curr)
        -- somehow this -16 value works? I have no idea why yet
        return my_flat - ((x_end - x_start) * -((x_curr - x_start) / (x_end - x_start))), 1
        -- this one is curvy and kinda owns
        -- return y_base - ((x_end - x_curr) * -((x_curr - x_start) / (x_end - x_start))), 2
      end
    elseif ramp_type == "flat" then
      last_flat = vals[4]
      range.f = function(x_curr)
          return vals[4], 0
      end
    end
    add(ranges, range)
  end)
  return ranges, x_max
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
      printh("found jump with dy: "..b.dy)
      return b.dy
    end
  end
  return 0
end
