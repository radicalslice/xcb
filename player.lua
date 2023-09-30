_PLAYER_MAXDX = 3 -- when on the ground
_PLAYER_MAXDY = 5
_PLAYER_STATE_ONGROUND = 0
_PLAYER_STATE_INSKY = 2
player = {
  reset = function(p)
    p.x = 0
    p.y = 16 -- player's actual y value
    p.y_base = 64 -- baseline y value for the level
    p.dx = 0
    p.dx_max = _PLAYER_MAXDX
    p.ddx = 0.2
    p.dy = 1 -- give it some initial dy
    p.ddy = 0.5 -- basically gravity
    p.angle = -3
    p.state = _PLAYER_STATE_INSKY
  end,
  draw = function(p)
    spr(4+flr(p.angle), p.x, p.y, 1, 1)
    print(flr(p.angle), p.x, p.y-12, 11)
  end,
  boosty = function(p, boosted_dy, y_ground)
    p.dy = min(-1, (p.dx / _PLAYER_MAXDX) * boosted_dy)
    -- make sure we're just above ground level first
    p.y = p.y - 0.1
    p.dx -= p.dx\3
    -- p.dx -= min(p.dx\3, abs(p.dy)*2)
    p.state = _PLAYER_STATE_INSKY
    printh("boosted,(x,y),yg,dy: ("..p.x..","..p.y.."),"..y_ground..","..p.dy)
  end,
  bouncy = function(p, boosted_dy)
    p.dy = boosted_dy
    -- make sure we're just above ground level first
    p.y = p.y - 0.1
    p.state = _PLAYER_STATE_INSKY
    p.dx -= p.dx\3
    printh("bounced at x: "..p.x)
  end,
  near_ground = function(p, y_ground)
   return abs(p.y - y_ground) < 1 or p.y > y_ground
  end,
  update = function(p, y_ground, ground_angle)
    -- printh("begin update, PY: "..p.y..", YG: "..y_ground..", S: "..p.state)

    local friction = 0.85
    local airres = 0.99
    -- manipulate dx value
    if btn(4) then
      if p.state == _PLAYER_STATE_ONGROUND then -- on ground, btn held
        p.dx = min(p.dx_max, p.dx + p.ddx)
      elseif p.state == _PLAYER_STATE_INSKY then
        -- air resistance
        p.dx *= airres
      end
    elseif p.state == _PLAYER_STATE_INSKY then -- in air
      -- air resistance
      if p.dx > p.dx_max then
        p.dx *= airres
      end
    else -- on ground, no btn input
      -- apply friction
      p.dx *= friction
    end

    if btn(1) then
      if p.state == _PLAYER_STATE_INSKY then
        p.angle = min(3, p.angle + 0.3)
      end
    elseif btn(0) then
      if p.state == _PLAYER_STATE_INSKY and abs(p.dy) > 2 then
        -- extra airres, decreased grav
        printh("extra airres")
        p.angle = max(-3, p.angle - 0.1)
        p.dx *= airres
        p.dy -= (p.ddy * 0.3)
      end
    end

    -- apply velocity
    p.x += p.dx

    if btn(5) then
      p.y = 32
      p.dy = 1
      p.dx = 0
      p.angle = -3
      p.state = _PLAYER_STATE_INSKY
    end


    -- 0) check if we're floating!
    if p:get_state() == _PLAYER_STATE_ONGROUND and p.y < y_ground then
      p.state = _PLAYER_STATE_INSKY
    end
   
    -- 1) Update dy, y
    if p:get_state() == _PLAYER_STATE_INSKY then
      p.dy = min(_PLAYER_MAXDY, p.dy + p.ddy)
      p.y = min(p.y + p.dy, y_ground)
      -- bounce if we hit the ground
      -- landing from a jump
      if p:near_ground(y_ground)
        and flr(p.angle) != ground_angle
        and abs(p.dy) > 1 then
        printh("hop 1: "..p.y)
        p.angle = ground_angle
        p:bouncy(-2)
        return
      end 
    end

    -- manipulate angle, if player is not on a ramp
    --[[
    ADD THIS BACK LATER
    if p:get_state() != _PLAYER_STATE_ONRAMP then
      if btn(0) then -- holding back arrow
        if p.angle > -3 then
          p.angle = max(p.angle - 0.25, -3)
          printh("angle adj 0")
        end
      end

      -- reset angle if back is not held and player is grounded
      if not btn(0) and p:get_state() == _PLAYER_STATE_ONGROUND then
        p.angle = (1 - 0.3) * p.angle -- linear interpolation
        printh("angle adj 1")
        if p.angle < 0 and p.angle > -0.1 then
          p.angle = 0
          printh("angle adj 2")
        end
      end
    end
    --]]


    -- force angle if we're on --a ramp-- the ground
    -- ... and velocity is not negative?
    -- if p:get_state() == _PLAYER_STATE_ONGROUND then
    if p.y >= y_ground and p.dy >= 0 then
      p.angle = ground_angle
      -- printh("changed angle to "..p.angle.." at ("..p.x..","..p.y.."), YG: "..y_ground..", DY: "..p.dy)
      p.y = y_ground
      p.dy = 0
      p.state = _PLAYER_STATE_ONGROUND
    end

    -- adjust angle if we're on ground
    --[[
    if p:get_state() == _PLAYER_STATE_ONGROUND and abs(p.angle - ground_angle) > 0.2 then
        -- if we're moving from the "lean back" direction
        -- to the "flat" direction...
        -- use interpolation to adjust gradually
        printh("gradual: "..p.y..","..p.angle)
        p.angle = (1 - 0.2) * p.angle -- linear interpolation

        printh("angle adj 5")
        p.dy = 0
        p.y = p.y_ground
    end
    ]]--

    --[[
        -- stop gravity and force player to ground level,
        -- adjusting angle to ground angle
        p.dy = 0
        p.y = p.y_ground
        p.angle = ground_angle
        -- reset max velocity
        p.dx_max = _PLAYER_MAXDX 
    end

    -- force near the ground if they're close
    if p:near_ground() and p.dy > 0 then
      printh("forced ground")
      p.y = p.y_ground
      p.dy = 0
    end
    --]]

  end,
  get_board_center = function(p)
    return flr(p.x + 4), flr(p.y + 8)
  end,
  get_state = function(p)
    return p.state
    --[[
    if p.y < p.y_ground then
      return _PLAYER_STATE_INSKY
    elseif p.y_ground < p.y_base and p.dy == 0 then
      return _PLAYER_STATE_ONRAMP
    end

    return _PLAYER_STATE_ONGROUND
      --]]
  end
}
