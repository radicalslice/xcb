level = {
   ranges = {
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
     {
       x_min = 200, 
       x_max = 216,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_min) \ 2), -1
       end,
     },
     {
       x_min = 216, 
       x_max = 232,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_max - x_curr) \ 2), 1
       end,
     },
     {
       x_min = 234, 
       x_max = 250,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_min) \ 2), -1
       end,
     },
     {
       x_min = 250, 
       x_max = 266,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_max - x_curr) \ 2), 1
       end,
     },
     {
       x_min = 300, 
       x_max = 324,
       f = function(r, y_base, x_curr)
        return y_base - ((x_curr - r.x_min) * 1.5), -3
       end,
     },
     {
       x_min = 324, 
       x_max = 348,
       f = function(r, y_base, x_curr)
        return y_base - ((r.x_max - x_curr) * 1.5), 3
       end,
     },
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
       x = 324,
       dy = -4.5,
       used = false,
     },
     {
       x = 215,
       dy = -2.5,
       used = false,
     },
     {
       x = 250,
       dy = -2.5,
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
