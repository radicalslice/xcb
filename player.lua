_PLAYER_MAXDX = 1.5 -- when on the ground
_PLAYER_MAXDY = 5
_PLAYER_INIT_DDX = 0.01
_PLAYER_MAX_DDX = 0.2
_PLAYER_STATE_ONGROUND = "on_ground"
_PLAYER_STATE_SKYUP = "skyup"
_PLAYER_STATE_SKYDOWN = "skydown"
_PLAYER_STATE_HOPUP = "hopup"
_PLAYER_STATE_HOPDOWN = "hopdown"
_PLAYER_STATE_INSKY = 2
_PLAYER_STATE_FALLEN = 3
_PLAYER_GRAVITY = 0.2
_friction = 0.85
_airres = 0.995
player = {
  reset = function(p)
    p.x = 0
    p.y = 72 -- player's actual y value
    p.y_base = 72 -- baseline y value for the level
    p.dx = 0
    p.ddx = _PLAYER_INIT_DDX
    p.dy = 1 -- give it some initial dy
    p.ddy = _PLAYER_GRAVITY
    p.angle = 0
    p.state = _PLAYER_STATE_ONGROUND
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
    palt(11, true)
    palt(0, false)
    spr(34 + (2*p.angle), p.x, p.y-12, 2, 2)
    palt()

    -- print(flr(p.angle), p.x, p.y-12, 11)
  end,
  start_jump = function(p, boosted_dy)
    p.dy = min(-1, (p.dx / _PLAYER_MAXDX) * boosted_dy)
    -- make sure we're just above ground level first
    p.y = p.y - 0.1
    p.dx -= p.dx * 0.2
    p:change_state(_PLAYER_STATE_SKYUP)
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

      -- cheating and putting this outside of state_funcs
      if p.dx > 0.3 then
        local colors = {6}
        -- randomize color array sometimes
        -- if rnd() > 0.6 then colors = {8, 2, 8} end
        add(_FX.parts, new_part(p.x + 12 + (1 - rnd(2)), p.y + 2 + (2 - rnd(4)), -1, 1, colors, 1, 0.2))
      end

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
--[[
crash_lut[-3] = {0}
crash_lut[-2] = {}
crash_lut[-1] = {2,3}
crash_lut[0] = {2,3}
crash_lut[1] = {-3,-2,-1}
crash_lut[2] = {0,-1,-2,-3}
crash_lut[3] = {-3,-2,-1,0,1,2,3}
]]--

player_state_funcs = {
  on_ground = function(p, y_ground, ground_angle)
    p.angle = ground_angle

    if true or btn(4) then
      p.dx = min(_PLAYER_MAXDX, p.dx + p.ddx)
    else -- on ground, no btn input
      p.dx *= _friction
      if p.dx < 0.1 then
        p.dx = 0
      end
    end

    -- apply velocity
    local slow_factors = {0.95, 0.9, 0.8}
    if true and abs(ground_angle) >= 1 then
      p.x += p.dx * slow_factors[abs(ground_angle)]
    else
      p.x += p.dx
    end

    if flr(p.y) != y_ground then
      p.y = y_ground
    end
  end,
  skyup = function(p, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    -- air resistance
    p.dx *= _airres

    -- tweak angle 
    if btnp(1) then
        p.angle = min(1, p.angle + 1)
    elseif btnp(0) then
      p.angle = max(-1, p.angle - 1)
      if abs(p.dy) > 2 then
        -- extra airres, decreased grav
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
    if btnp(1) then
      p.angle = min(1, p.angle + 1)
    elseif btnp(0) then
      p.angle = max(-1, p.angle - 1)
      if abs(p.dy) > 2 then
        -- extra airres, decreased grav
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
        else
          p.dy = -2
          -- make sure we're just above ground level first
          p.y = p.y - 0.1
          p.dx -= p.dx/3
          p:change_state(_PLAYER_STATE_HOPUP)
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
