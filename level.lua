level = {
   ranges = {
     -- REGULAR RAMP
     {
       x_min = 80, 
       x_max = 96,
       f = function(r, y_base, x_curr)
        return y_base - (x_curr - r.x_min), -2
       end,
     },
     {
       x_min = 96, 
       x_max = 112,
       f = function(r, y_base, x_curr)
        return y_base - (r.x_max - x_curr), 2
       end,
     },
     -- END REGULAR RAMP
     -- TWO TINY RAMPS
     {
       x_min = 200, 
       x_max = 214,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_min) \ 2), -1
       end,
     },
     {
       x_min = 214, 
       x_max = 228,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_max - x_curr) \ 2), 1
       end,
     },
     {
       x_min = 228, 
       x_max = 242,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_min) \ 2), -1
       end,
     },
     {
       x_min = 242, 
       x_max = 256,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_max - x_curr) \ 2), 1
       end,
     },
     -- END TWO TINY RAMPS
     -- BIG TALL RAMP
     {
       x_min = 290, 
       x_max = 314,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_min) * 1.5), -3
       end,
     },
     {
       x_min = 314, 
       x_max = 338,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_max - x_curr) * 1.5), 3
       end,
     },
     -- END BIG TALL RAMP
     -- REGULAR RAMP
     {
       x_min = 400, 
       x_max = 416,
       f = function(r, y_base, x_curr)
        return y_base - (x_curr - r.x_min), -2
       end,
     },
     {
       x_min = 416, 
       x_max = 432,
       f = function(r, y_base, x_curr)
        return y_base - (r.x_max - x_curr), 2
       end,
     },
     -- END REGULAR RAMP
     -- BIG TALL RAMP
     {
       x_min = 436, 
       x_max = 462,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_min) * 1.5), -3
       end,
     },
     {
       x_min = 462, 
       x_max = 488,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_max - x_curr) * 1.5), 3
       end,
     },
     -- END BIG TALL RAMP
     --[[
     {
       x_min = 120, 
       x_max = 144,
       f = function(r, y_base, x_curr)
        return y_base - flr((x_curr - r.x_min) / 2), -2
       end,
     },
     {
       x_min = 144, 
       x_max = 168,
       f = function(r, y_base, x_curr)
        return y_base - flr((r.x_max - x_curr) / 2), 2
       end,
     },
     {
       x_min = 164, 
       x_max = 182,
       f = function(r, y_base, x_curr)
        return y_base - (x_curr - r.x_min), -3
       end,
     },
     ]]--
   },
   boosts = {
     {
       x = 96,
       dy = -4.5,
       used = false,
     },
     {
       x = 214,
       dy = -2.5,
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
     --[[
     {
       x = 144,
       dy = -3.5,
       used = false,
     },
     {
       x = 182,
       dy = -6.5,
       used = false,
     },
     {
       x = 280,
       dy = -3,
       used = false,
     },
     ]]--
   }
}

-- Int -> Level -> ?Range
function find_range(x, level)
  local found = false
  for r in all(level.ranges) do
    if x >= r.x_min and x < r.x_max then
      return r
    end
  end
  return nil
end

-- Int -> Level -> Int
function find_boost(x, level)
  local found = false
  for b in all(level.boosts) do
    if x >= b.x and b.used == false then
      b.used = true
      return b.dy
    end
  end
  return 0
end
--
-- Int -> Level -> Int
function find_boost2(x, level)
  local found = false
  for b in all(level.boosts) do
    if x >= b.x then
      return b.dy
    end
  end
  return 0
end
