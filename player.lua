_PLAYER_DX_MAX = 1.5 -- when on the ground
_PLAYER_DX_MAX_BOOSTED = 2.2
_PLAYER_MAXDY = 3
_PLAYER_INIT_DDX = 0.02
_PLAYER_STATE_ONGROUND = "on_ground"
_PLAYER_STATE_SKYUP = "skyup"
_PLAYER_STATE_SKYDOWN = "skydown"
_PLAYER_STATE_HOPUP = "hopup"
_PLAYER_STATE_HOPDOWN = "hopdown"
_PLAYER_STATE_INSKY = 2
_PLAYER_GRAVITY = 0.15
_PLAYER_JUICE_ADD = 1
_PLAYER_JUICE_MAX = 3
_PLAYER_AIRTIMER_0 = 0.5
_friction = 0.85
_airres = 0.99 -- disabled for now
player = {
  reset = function(p)
    p.x = 0
    p.dx_max = _PLAYER_DX_MAX
    p.y = Y_BASE -- player's actual y value
    p.dx = 0
    p.ddx = _PLAYER_INIT_DDX
    p.dy = 1 -- give it some initial dy
    p.ddy = _PLAYER_GRAVITY
    p.angle = 0
    p.state = _PLAYER_STATE_ONGROUND
    p.board_cycler = new_cycler(0.05, {8,9,10})
    p.trick = nil
    p.juice = 0
    p.airtimer = 0
  end,
  change_state = function(p, state)
    printh("State change: "..p.state.."->"..state)
    p.state = state
  end,
  draw = function(p)
    palt(11, true)
    palt(0, false)
    if p.dx_max == _PLAYER_DX_MAX_BOOSTED then
      pal(8, p.board_cycler:get_color())
    end
    spr(34 + (2*p.angle), p.x-10, p.y-6, 2, 2)
    pal()
    palt()
  end,
  start_jump = function(p, boosted_dy)
    p.dy = mid(-1, boosted_dy, (p.dx / _PLAYER_DX_MAX) * boosted_dy)
    printh("New dy: "..p.dy)
    -- make sure we're just above ground level first
    p.y = p.y - 0.1
    p.dx -= p.dx * 0.2
    p.airtimer = 0
    p:change_state(_PLAYER_STATE_SKYUP)
  end,
  near_ground = function(p, y_ground)
   return abs(p.y - y_ground) < 1 or p.y > y_ground
  end,
  update = function(p, dt, y_ground, ground_angle)

    -- update board cycler
    p.board_cycler:update(dt)

    if p:get_state() == _PLAYER_STATE_ONGROUND 
      or p:get_state() == _PLAYER_STATE_SKYUP
      or p:get_state() == _PLAYER_STATE_SKYDOWN
      or p:get_state() == _PLAYER_STATE_HOPUP
      or p:get_state() == _PLAYER_STATE_HOPDOWN then
      player_state_funcs[p:get_state()](p, dt, y_ground, ground_angle)

      -- cheating and putting this outside of state_funcs
      if p.dx > 0.3 then
        local colors = {6}
        -- randomize color array sometimes
        -- if rnd() > 0.6 then colors = {8, 2, 8} end
        add(_FX.parts, new_part(p.x - 8 + (1 - rnd(2)), p.y + 9 + (2 - rnd(4)), -1, 1, colors, 1, 0.2))
      end

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

player_state_funcs = {
  on_ground = function(p, dt, y_ground, ground_angle)
    p.angle = ground_angle

    p.dx = min(p.dx_max, p.dx + p.ddx)
      --[[
      -- old stuff, we used to use this before auto-input
      p.dx *= _friction
      if p.dx < 0.1 then
        p.dx = 0
      end
      ]]--

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
  skyup = function(p, dt, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    -- air resistance
    p.dx *= _airres

    -- increase airtimer
    p.airtimer += dt

    -- tweak angle 
    if btnp(1) then
        p.angle = min(1, p.angle + 1)
        p.airtimer = 0
    elseif btnp(0) then
      p.angle = max(-1, p.angle - 1)
      p.airtimer = 0
      if abs(p.dy) > 2 then
        -- extra airres, decreased grav
        p.dx *= _airres
        p.dy -= (p.ddy * 0.3)
      end
    end

    local prev_dy = p.dy

    p = move_in_y(p, y_ground)

    if prev_dy <= 0 and p.dy > 0 then
      -- if we're switching from rise to fall, switch states
      p:change_state(_PLAYER_STATE_SKYDOWN)
    end
  end,
  skydown = function(p, dt, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    -- air resistance
    p.dx *= _airres

    -- increase airtimer
    p.airtimer += dt

    -- tweak angle
    if btnp(1) then
      p.angle = min(1, p.angle + 1)
      p.airtimer = 0
    elseif btnp(0) then
      p.airtimer = 0
      p.angle = max(-1, p.angle - 1)
      if abs(p.dy) > 2 then
        -- extra airres, decreased grav
        p.dx *= _airres
        p.dy -= (p.ddy * 0.3)
      end
    end

    p = move_in_y(p, y_ground)

    -- hop or land
    if p:near_ground(y_ground) then

      if flr(p.angle) != ground_angle then
        local rounded_angle = flr(p.angle)

        p.dy = -2
        -- make sure we're just above ground level first
        p.y = p.y - 0.1
        p.dx -= p.dx/3
        p:change_state(_PLAYER_STATE_HOPUP)
      else
        -- angle is the same, so land
        -- nearing the ground slowly, so force downward
        p.y = y_ground
        p.angle = ground_angle
        p:change_state(_PLAYER_STATE_ONGROUND)
        p.juice = min(_PLAYER_JUICE_MAX, p.juice + _PLAYER_JUICE_ADD)

        -- check airtimer, if it's small enough, print a message...
        if p.airtimer < _PLAYER_AIRTIMER_0 then
          p.dx = p.dx_max
          printh("LANDED WITHIN: "..p.airtimer)
        end

        -- increase max_dx and set a timer to expire
        -- player.dx_max = _PLAYER_DX_MAX_BOOSTED
        -- _timers.boost:init(2,time())
      end
    end 
  end,
  hopup = function(p, dt, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    local prev_dy = p.dy

    p = move_in_y(p, y_ground)

    if prev_dy <= 0 and p.dy > 0 then
      -- if we're switching from rise to fall, switch states
      p:change_state(_PLAYER_STATE_HOPDOWN)
    end
  end,
  hopdown = function(p, dt, y_ground, ground_angle)
    -- apply velocity
    p.x += p.dx

    p = move_in_y(p, y_ground)

    -- land the hop
    if p:near_ground(y_ground) then
      p.y = y_ground
      p.angle = ground_angle
      p:change_state(_PLAYER_STATE_ONGROUND)
    end

  end,
}

function move_in_y(p, y_ground)
  p.dy = min(_PLAYER_MAXDY, p.dy + p.ddy)
  p.y = min(p.y + p.dy, y_ground)
  return p
end
