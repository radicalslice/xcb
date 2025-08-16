-- new_part ::
--  InitialX :: Int ->
--  InitialY :: Int ->
--  () -> InitialVX :: Float  -> 
--  () -> InitialVY :: Float ->
--  []Color -> 
--  []Color ->
--  InitSize :: Int ->
--  Ttl :: Float ->
--  Shrink :: Bool ->
--  Gravity :: Float 
function new_part(x, y, fvx, fvy, fillcolors, colorf, edgecolor, start_size, ttl, shrink, gravity)
  local newP = {
    colors = fillcolors,
    colorf = colorf,
    edgecolor = edgecolor,
    x = x,
    y = y,
    ttl = ttl,
    max_ttl = ttl,
    size = start_size,
    max_size = start_size,
    shrink = shrink,
    gravity = gravity
  }

  newP.vel_x = fvx()
  newP.vel_y = fvy()

  newP.draw = function(p)
    local idx = (p.ttl * #p.colors) \ p.max_ttl

    if idx >= #p.colors then idx = #p.colors - 1 end

    local color = nil
    if colorf == nil then
      color = p.colors[idx + 1]
    else 
      color = colorf()
    end 

    circfill(
    p.x,
    p.y,
    p.size,
    color
    )

    if p.edgecolor != nil then
      circ(p.x,p.y,p.size+1,p.edgecolor)
    end
  end

  newP.update = function(p, dt)
    p.y += p.vel_y
    p.vel_y = p.vel_y * 0.8
    p.vel_y = min(p.vel_y + p.gravity, 5)

    p.x += p.vel_x  
    p.vel_x = p.vel_x * 0.8

    p.ttl -= dt

    if shrink then
      p.size = (p.ttl * p.max_size) \ p.max_ttl
    end
  end

  return newP
end

-- Let's pull this into some code generation stuff later...
-- This is for a vertical meter
--[[
function new_meter(x, y, width, height, max_val, color, draw_frame_f)
  return {
    color = color,
    curr_val = 0,
    max_val = max_val,
    draw_frame_f = draw_frame_f,
    x = x,
    y = y,
    width = width,
    height = height,
    update = function(m, curr_val, max_val, height, color)
      m.curr_val = curr_val
      m.max_val = max_val
      m.color = color
      m.height = height
    end,
    draw = function(m)
      rectfill(m.x,m.y,m.x+m.width,m.y-(m.curr_val / m.max_val) * m.height,m.color)
      draw_frame_f(m)
    end,
  }
end
]]--
-- Horizontal meter
function new_meter(x, y, width, height, max_val, color, draw_frame_f)
  return {
    color = color,
    curr_val = 0,
    max_val = max_val,
    draw_frame_f = draw_frame_f,
    x = x,
    y = y,
    width = width,
    height = height,
    update = function(m, curr_val, max_val, width, color)
      m.curr_val = curr_val
      m.max_val = max_val
      m.color = color
      m.width = width
    end,
    draw = function(m)
      rectfill(m.x,m.y,m.x+(m.curr_val / m.max_val) * m.width,m.y+m.height,m.color)
      draw_frame_f(m)
    end,
  }
end
