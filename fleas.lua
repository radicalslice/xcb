_FX = {
  parts = {}
}
function new_part(x, y, fvx, fvy, fillcolors, edgecolor, start_size, ttl, gravity)
  local newP = {
    colors = fillcolors,
    edgecolor = edgecolor,
    x = x,
    y = y,
    ttl = ttl,
    max_ttl = ttl,
    size = start_size,
    max_size = start_size,
    gravity = gravity
  }
  -- newP.vel_x = sin(rnd()) * vx
  -- newP.vel_y = cos(rnd()) * vy
  newP.vel_x = fvx()
  newP.vel_y = fvy()

  newP.draw = function(p)
    -- {5,6,8,9,14,14}
    -- {dark grey, light grey, red, orange, pink, pink}

    local idx = (p.ttl * #p.colors) \ p.max_ttl

    if idx >= #p.colors then idx = #p.colors - 1 end


    circfill(
    p.x,
    p.y,
    p.size,
    p.colors[idx + 1]
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

    p.size = (p.ttl * p.max_size) \ p.max_ttl
  end

  return newP
end
