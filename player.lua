_PLAYER_DX_MAX = 1.5 -- when on the ground
_PLAYER_DX_MAX_BOOSTED = 2.2
_PLAYER_DY_MAX = 3
_PLAYER_STATE_ONGROUND = "on_ground"
_PLAYER_STATE_SKYUP = "skyup"
_PLAYER_STATE_SKYDOWN = "skydown"
_PLAYER_STATE_HOPUP = "hopup"
_PLAYER_STATE_HOPDOWN = "hopdown"
_PLAYER_GRAVITY = 0.15
_PLAYER_JUICE_ADD = 1
_PLAYER_JUICE_MAX = 3
_PLAYER_AIRTIMER_0 = 0.5
_PLAYER_BOOST_TIME = 2 --seconds
_PLAYER_BOOST_BONUS = 1 --seconds, extra time for a successful boost landing
_PLAYER_HOP_PENALTY = 0.7
_PLAYER_TRICK_THROTTLE = 0.9
_PLAYER_TKSTATE_OFF = "off"
_PLAYER_TKSTATE_TRICKING = "tricking"
_PLAYER_TKSTATE_REWARD = "reward"
_PLAYER_TRICK_TTL = 1
_friction = 0.85
_airres = 0.99
trick_cycler_1 = new_cycler(0.04, {11, 7})
player = {
  reset = function(p)
    p.x = 0
    p.dx_max = _PLAYER_DX_MAX
    p.y = Y_BASE -- player's actual y value
    p.dx = 0
    p.ddx = 0.02 -- initial ddx
    p.dy = 1 -- give it some initial dy
    p.ddy = _PLAYER_GRAVITY
    p.angle = 0
    p.state = _PLAYER_STATE_ONGROUND
    p.board_cycler = new_cycler(0.05, {8,9,10})
    p.tricking = false
    p.trick_state = _PLAYER_TKSTATE_OFF
    p.boosting = false
    p.juice = 3
    p.style = 0
    p.airtimer = 0
    p.last_trick_ttl = nil -- need this for a UI thing...
    p.pose = false
  end,
  change_state = function(p, state)
    printh("State change: "..p.state.."->"..state)
    p.state = state
  end,
  draw = function(p)
    palt(11, true)
    palt(0, false)
    if p.boosting then
      pal(8, p.board_cycler:get_color())
    end
    local base_sprite = 11 + 2*p.angle
    if player.pose then base_sprite = 34 + 2*p.angle end
    if player.trick_state == _PLAYER_TKSTATE_TRICKING and 
      (player.state == _PLAYER_STATE_SKYUP or player.state == _PLAYER_STATE_SKYDOWN) then
      base_sprite = 40 + 2*p.angle
    elseif player.trick_state == _PLAYER_TKSTATE_TRICKING and player.state == _PLAYER_STATE_ONGROUND then
      base_sprite = 7
    end


    spr(base_sprite, p.x-10, p.y-6, 2, 2)

    for i=1,player.juice do
      spr(96, p.x-13 - (i*2) , p.y - 11 + (i*5))
    end

    if p.trick_state == _PLAYER_TKSTATE_TRICKING or p.trick_state == _PLAYER_TKSTATE_REWARD then
      -- base rectangle
      local color_window = 11
      if p.trick_state == _PLAYER_TKSTATE_REWARD then
        color_window = trick_cycler_1:get_color()
      end
      rectfill(p.x - 13, p.y - 11, p.x - 13 + 19, p.y - 10, 9)

      -- green bit
      local leftx = (p.x - 13) + flr(19 * (_timers.trick.window_min / _PLAYER_TRICK_TTL))
      local rightx = (p.x - 13) + flr(19 * (_timers.trick.window_max / _PLAYER_TRICK_TTL)) 
      rectfill(leftx, p.y - 11, rightx, p.y - 10, color_window)

      -- cursor, draw over the green bit
      local rightedge = p.x - 13 + flr(19 * (p.last_trick_ttl != nil and p.last_trick_ttl or _timers.trick.ttl / _PLAYER_TRICK_TTL))
      rectfill(rightedge, p.y - 11, rightedge, p.y - 10, 4)
    end

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
  update = function(p, dt, y_ground, ground_angle, block_input)

    -- update board cycler
    p.board_cycler:update(dt)

    -- update trick cyclers
    trick_cycler_1:update(dt)

    local pstate = p:get_state()
    if pstate == _PLAYER_STATE_ONGROUND 
      or pstate == _PLAYER_STATE_SKYUP
      or pstate == _PLAYER_STATE_SKYDOWN
      or pstate == _PLAYER_STATE_HOPUP
      or pstate == _PLAYER_STATE_HOPDOWN then
      player_state_funcs[pstate](p, dt, y_ground, ground_angle, block_input)

      if p:get_state() == _PLAYER_STATE_ONGROUND then
        add(_FX.parts, new_part(
          p.x + 4 - rnd(6),
          p.y + 12 - rnd(4),
          function() return sin(rnd()) * -1 end,
          function() return 0 end,
          {7},
          nil,
          flr(rnd(2)) + 1,
          1,
          false,
          0
        ))
      end

      -- printh("player.y: "..player.y)
      return
    end

  end,
  get_board_center_x = function(p)
    return flr(p.x + 3)
  end,
  get_state = function(p)
    return p.state
  end,
}

player_state_funcs = {
  on_ground = function(p, dt, y_ground, ground_angle, block_input)
    p.angle = ground_angle

    p.dx = min(p.dx_max, p.dx + p.ddx)

    -- apply velocity
    local slow_factors = {0.95, 0.9, 0.8}
    if abs(ground_angle) >= 1 then
      p.x += p.dx * slow_factors[abs(ground_angle)]
    else
      p.x += p.dx
    end

    if flr(p.y) != y_ground then
      p.y = y_ground
    end

    if btnp(5) and
      not block_input and
      not p.boosting and
      p.trick_state != _PLAYER_TKSTATE_TRICKING and
      p.juice > 0 then
        p.juice -= 1
        p.dx_max = _PLAYER_DX_MAX_BOOSTED
        p.boosting = true
        _timers.boost:init(2,time())
        printh("player boosted")
    elseif btnp(4) and
      not block_input and
      p.trick_state != _PLAYER_TKSTATE_TRICKING and 
      p.trick_state != _PLAYER_TKSTATE_REWARD
      then
      p = start_tricking(p)
    elseif btnp(4) and
      not block_input and
      p.trick_state == _PLAYER_TKSTATE_TRICKING then
      p = stop_tricking(p)
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

    if btnp(4) and
      p.trick_state == _PLAYER_TKSTATE_TRICKING then
      p = stop_tricking(p)
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

    if btnp(4) and
      p.trick_state == _PLAYER_TKSTATE_TRICKING then
      p = stop_tricking(p)
    end

    p = move_in_y(p, y_ground)

    -- hop or land
    if p:near_ground(y_ground) then

      -- we missed the landing! so we'll hop
      if flr(p.angle) != ground_angle then
        p.dy = -2
        -- make sure we're just above ground level first
        p.y = p.y - 0.1
        p.dx *= _PLAYER_HOP_PENALTY
        p.dx_max = _PLAYER_DX_MAX
        p:change_state(_PLAYER_STATE_HOPUP)
        -- do the shake
        _shake = 1
        for i=0,20 do 
          add(_FX.parts,
            new_part(
              p.x + rnd(3),
              p.y + 11 - rnd(4),
              function() return sin(rnd()) * 3 end,
              function() return -rnd(7) end,
              {7},
              rnd() > 0.8 and 6 or nil,
              3 + rnd(3),
              0.5 + rnd(0.5),
              true,
              0.15
            ))
        end
      else
        -- angle is the same, so land
        -- nearing the ground slowly, so force downward
        p.y = y_ground
        p.angle = ground_angle
        p:change_state(_PLAYER_STATE_ONGROUND)
        p.juice = min(_PLAYER_JUICE_MAX, p.juice + _PLAYER_JUICE_ADD)
        if p.boosting then
          _timers.boost:add(_PLAYER_BOOST_BONUS)
        end

        -- speed pin if timer was low enough
        if p.airtimer < _PLAYER_AIRTIMER_0 then
          p.dx = p.dx_max
          p.airtimer = 0
        end

        -- sakurai stop
        _timers.sakurai:init(0.20,time())
        p.pose = true
        add(
          _FX.doppels,
          new_doppel(11,p.x-8,p.y-4)
        )
        _update60 = _update_stop
        _draw = _draw_stop
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
  p.dy = min(_PLAYER_DY_MAX, p.dy + p.ddy)
  p.y = min(p.y + p.dy, y_ground)
  return p
end

function start_tricking(p)
  printh("in start tricking")
  p.trick_state =  _PLAYER_TKSTATE_TRICKING
  p.dx_max *= _PLAYER_TRICK_THROTTLE
  _timers.trick:init(_PLAYER_TRICK_TTL,time())
  local window_min = (_PLAYER_TRICK_TTL / 4) + rnd(_PLAYER_TRICK_TTL / 4)
  _timers.trick.window_min = window_min
  _timers.trick.window_max = window_min + _PLAYER_TRICK_TTL / (p.boosting and 8 or 4)
  _timers.trick.points = p.boosting and 2 or 1
  return p
end

function stop_tricking(p)
  printh("in stop tricking")
  -- if timer.ttl is within window_min and window_max, you get some style points
  if _timers.trick.ttl > _timers.trick.window_min and
    _timers.trick.ttl < _timers.trick.window_max then
    p.style += _timers.trick.points
    trick_cycler_1.colors = {11, 7}
  else 
    -- deduct some speed 
    p.dx *= 0.5
    trick_cycler_1.colors = {8, 7}
  end
  _timers.trick_reward:init(1,time())
  p.last_trick_ttl = _timers.trick.ttl
  _timers.trick.ttl = 0
  player.trick_state = _PLAYER_TKSTATE_REWARD

  -- reset the max dx
  if player.boosting then
    player.dx_max = _PLAYER_DX_MAX_BOOSTED
  else
    player.dx_max = _PLAYER_DX_MAX
  end
  
  return p
end
