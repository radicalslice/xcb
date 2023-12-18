level = {
   ranges = {
     -- REGULAR RAMP
     {
       x_start = 80, 
       x_end = 96,
       f = function(r, y_base, x_curr)
        return y_base - (x_curr - r.x_start), -2
       end,
     },
     {
       x_start = 96, 
       x_end = 112,
       f = function(r, y_base, x_curr)
        return y_base - (r.x_end - x_curr), 2
       end,
     },
     {
       x_start = 200, 
       x_end = 216,
       f = function(r, y_base, x_curr)
        return y_base - 2 * (x_curr - r.x_start), -3
       end,
     },
     {
       x_start = 216, 
       x_end = 232,
       f = function(r, y_base, x_curr)
        return y_base - 2 * (r.x_end - x_curr), 3
       end,
     },
     -- END REGULAR RAMP
     -- TWO TINY RAMPS
     {
       x_start = 300, 
       x_end = 314,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_start) \ 2), -1
       end,
     },
     {
       x_start = 314, 
       x_end = 328,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_end - x_curr) \ 2), 1
       end,
     },
     {
       x_start = 332, 
       x_end = 346,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_start) \ 2), -1
       end,
     },
     {
       x_start = 346, 
       x_end = 360,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_end - x_curr) \ 2), 1
       end,
     },
     -- END TWO TINY RAMPS
     --[[
     -- BIG TALL RAMP
     {
       x_start = 290, 
       x_end = 314,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_start) * 1.5), -3
       end,
     },
     {
       x_start = 314, 
       x_end = 338,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_end - x_curr) * 1.5), 3
       end,
     },
     -- END BIG TALL RAMP
     -- REGULAR RAMP
     {
       x_start = 400, 
       x_end = 416,
       f = function(r, y_base, x_curr)
        return y_base - (x_curr - r.x_start), -2
       end,
     },
     {
       x_start = 416, 
       x_end = 432,
       f = function(r, y_base, x_curr)
        return y_base - (r.x_end - x_curr), 2
       end,
     },
     -- END REGULAR RAMP
     -- BIG TALL RAMP
     {
       x_start = 436, 
       x_end = 462,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_start) * 1.5), -3
       end,
     },
     {
       x_start = 462, 
       x_end = 488,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_end - x_curr) * 1.5), 3
       end,
     },
     -- END BIG TALL RAMP
     ]]--
   },
   jumps = {
     {
       x = 96,
       dy = -4.5,
       used = false,
     },
     {
       x = 216,
       dy = -4,
       used = false,
     },
     {
       x = 314,
       dy = -2,
       used = false,
     },
     --[[
     {
       x = 346,
       dy = -2,
       used = false,
     },
     {
       x = 242,
       dy = -2.5,
       used = false,
     },
     {
       x = 314,
       dy = -4.5,
       used = false,
     },
     {
       x = 416,
       dy = -4.5,
       used = false,
     },
     {
       x = 462,
       dy = -4.5,
       used = false,
     },
   ]]--
   }
}

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
