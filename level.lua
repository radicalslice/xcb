level = {}

-- ramp templates
v2 = {
  basic = {
    dup = 16,
    ddown = 48,
    fup = function(x_start, x_end)
      return function(y_base, x_curr)
        return y_base - (x_curr - x_start), -1
      end
    end,
    fdown = function(x_start, x_end)
      return function(y_base, x_curr)
        -- somehow this -32 value works? I have no idea why yet
        return y_base - 32 - ((x_end - x_start) * -((x_curr - x_start) / (x_end - x_start))), 1
        -- this one is curvy and kinda owns
        -- return y_base - ((x_end - x_curr) * -((x_curr - x_start) / (x_end - x_start))), 2
      end
    end,
  },
}

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


-- String -> Level
function parse_level(str)
  -- 80,basic:
  local ranges = {}
  local jumps = {}
  foreach(split(str, ":"), function(substr)
    local vals = split(substr, ",")
    local ramp = v2[vals[2]]
    local midpoint = vals[1] + ramp.dup
    add(ranges, {
      x_start = vals[1],
      x_end = midpoint,
      f = ramp.fup(vals[1], midpoint),
      })
    add(jumps, {
      x = midpoint,
      dy = -4.5,
      used = false
    })
    add(ranges, {
      x_start = midpoint,
      x_end = midpoint + ramp.ddown,
      f = ramp.fdown(vals[1], midpoint+ramp.ddown),
      })
  end)
  return {ranges = ranges, jumps = jumps}
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
--
-- Int -> Level -> Int
function find_jump2(x, level)
  local found = false
  for b in all(level.jumps) do
    if x >= b.x then
      return b.dy
    end
  end
  return 0
end
