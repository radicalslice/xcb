_PLAYER_MAXDX = 3 -- when on the ground
_PLAYER_MAXDY = 5
_PLAYER_STATE_ONGROUND = "on_ground"
_PLAYER_STATE_SKYUP = "skyup"
_PLAYER_STATE_SKYDOWN = "skydown"
_PLAYER_STATE_HOPUP = "hopup"
_PLAYER_STATE_HOPDOWN = "hopdown"
_PLAYER_STATE_INSKY = 2
_PLAYER_STATE_FALLEN = 3
_friction = 0.85
_airres = 0.99
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
    p.angle = -1
    p.state = _PLAYER_STATE_SKYDOWN
  end,
  change_state = function(p, state)
    printh("State change: "..p.state.."->"..state)
    p.state = state
  end,
  draw = function(p)
    if p:get_state() == _PLAYER_STATE_FALLEN then
      spr(8, p.x-6, p.y-10, 1, 1)
      spr(9, p.x, p.y, 1, 1)
      return
    end
    spr(4+flr(p.angle), p.x, p.y, 1, 1)
    print(flr(p.angle), p.x, p.y-12, 11)
  end,
  boosty = function(p, boosted_dy, y_ground)
    p.dy = min(-1, (p.dx / _PLAYER_MAXDX) * boosted_dy)
    -- make sure we're just above ground level first
    p.y = p.y - 0.1
    p.dx -= p.dx\3
    -- p.dx -= min(p.dx\3, abs(p.dy)*2)
    p:change_state(_PLAYER_STATE_SKYUP)
    printh("boosted,(x,y),yg,dy: ("..p.x..","..p.y.."),"..y_ground..","..p.dy)
  end,
  near_ground = function(p, y_ground)
   return abs(p.y - y_ground) < 1 or p.y > y_ground
  end,
  update = function(p, y_ground, ground_angle)

    if btn(5) then
      p.y = 32
      p.dy = 1
      p.dx = 0
      p.angle = -1
      p:change_state(_PLAYER_STATE_SKYDOWN)
      return
    end

    if p:get_state() == _PLAYER_STATE_ONGROUND 
      or p:get_state() == _PLAYER_STATE_SKYUP
      or p:get_state() == _PLAYER_STATE_SKYDOWN
      or p:get_state() == _PLAYER_STATE_HOPUP
      or p:get_state() == _PLAYER_STATE_HOPDOWN then
      player_state_funcs[p:get_state()](p, y_ground, ground_angle)
      return
    end

    if p:get_state() == _PLAYER_STATE_FALLEN then
      -- update position only
      p.dx *= _friction
      p.x += p.dx
      return
    end

  end,
  get_board_center_x = function(p)
    return flr(p.x + 3)
  end,
  get_state = function(p)
    return p.state
  end
}

-- table of [player angle]: ground angles[]
-- if we find a match, that makes player crash!
crash_lut = {}
crash_lut[-3] = {0}
crash_lut[-2] = {}
crash_lut[-1] = {2,3}
crash_lut[0] = {2,3}
crash_lut[1] = {-3,-2,-1}
crash_lut[2] = {0,-1,-2,-3}
crash_lut[3] = {-3,-2,-1,0,1,2,3}

player_state_funcs = {
  on_ground = function(p, y_ground, ground_angle)
    if btn(4) then
      p.dx = min(p.dx_max, p.dx + p.ddx)
    else -- on ground, no btn input
      p.dx *= _friction
    end

    -- apply velocity
    p.x += p.dx

    if flr(p.y) != y_ground then
      p.angle = ground_angle
      p.y = y_ground
    end
  end,
  skyup = function(p, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    -- air resistance
    p.dx *= _airres

    -- tweak angle 
    if btn(1) then
        p.angle = min(3, p.angle + 0.3)
    elseif btn(0) then
      if abs(p.dy) > 2 then
        -- extra airres, decreased grav
        p.angle = max(-3, p.angle - 0.1)
        p.dx *= _airres
        p.dy -= (p.ddy * 0.3)
      end
    end

    local prev_dy = p.dy
    p.dy = min(_PLAYER_MAXDY, p.dy + p.ddy)
    p.y = min(p.y + p.dy, y_ground)
    if prev_dy <= 0 and p.dy > 0 then
      -- if we're switching from rise to fall, switch states
      p:change_state(_PLAYER_STATE_SKYDOWN)
    end
  end,
  skydown = function(p, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    -- air resistance
    p.dx *= _airres

    -- tweak angle
    if btn(1) then
        p.angle = min(3, p.angle + 0.3)
    elseif btn(0) then
      if abs(p.dy) > 2 then
        -- extra airres, decreased grav
        p.angle = max(-3, p.angle - 0.1)
        p.dx *= _airres
        p.dy -= (p.ddy * 0.3)
      end
    end

    p.dy = min(_PLAYER_MAXDY, p.dy + p.ddy)
    p.y = min(p.y + p.dy, y_ground)

    -- hop, crash, or land
    if p:near_ground(y_ground) then

      if flr(p.angle) != ground_angle then
        local rounded_angle = flr(p.angle)

        -- either hop or crash
        if crash_lut[rounded_angle] != nil
        and exists(ground_angle, crash_lut[rounded_angle]) then
          p.state = _PLAYER_STATE_FALLEN
        elseif abs(p.dy) > 1 then
          p.angle = ground_angle
          p.dy = -2
          -- make sure we're just above ground level first
          p.y = p.y - 0.1
          p:change_state(_PLAYER_STATE_SKYUP)
          p.dx -= p.dx\3
          p:change_state(_PLAYER_STATE_HOPUP)
        else
          -- nearing the ground slowly, so force downward
          p.y = y_ground
          p.angle = ground_angle
          p:change_state(_PLAYER_STATE_ONGROUND)
        end

      else
        -- angle is the same, so land
        -- nearing the ground slowly, so force downward
        p.y = y_ground
        p.angle = ground_angle
        p:change_state(_PLAYER_STATE_ONGROUND)
      end
    end 
  end,
  hopup = function(p, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    local prev_dy = p.dy
    p.dy = min(_PLAYER_MAXDY, p.dy + p.ddy)
    p.y = min(p.y + p.dy, y_ground)
    if prev_dy <= 0 and p.dy > 0 then
      -- if we're switching from rise to fall, switch states
      p:change_state(_PLAYER_STATE_HOPDOWN)
    end
  end,
  hopdown = function(p, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    p.dy = min(_PLAYER_MAXDY, p.dy + p.ddy)
    p.y = min(p.y + p.dy, y_ground)

    -- land the hop
    if p:near_ground(y_ground) then
      p.y = y_ground
      p.angle = ground_angle
      p:change_state(_PLAYER_STATE_ONGROUND)
    end

  end,
}
