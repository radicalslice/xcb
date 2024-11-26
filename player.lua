_PLAYER_DX_MAX = 1.5 -- when on the ground
_PLAYER_DX_MAX_BOOSTED = 2.2
_PLAYER_DY_MAX = 3
_PLAYER_STATE_ONGROUND = "on_ground"
_PLAYER_STATE_SKYUP = "skyup"
_PLAYER_STATE_SKYDOWN = "skydown"
_PLAYER_STATE_HOPUP = "hopup"
_PLAYER_STATE_HOPDOWN = "hopdown"
_PLAYER_GRAVITY = 0.15
_PLAYER_JUICE_ADD = 0.5
_PLAYER_JUICE_MAX = 3
_PLAYER_AIRTIMER_0 = 0.2
_PLAYER_BOOST_TIME = 2 --seconds
_PLAYER_BOOST_BONUS = 1 --seconds, extra time for a successful boost landing
_PLAYER_HOP_PENALTY = 0.7
_friction = 0.85
_airres = 0.99
player = {
  reset = function(p)
    p.x = 20
    p.dx_max = _PLAYER_DX_MAX
    p.y = Y_BASE -- player's actual y value
    p.dx = 0
    p.ddx = 0.02 -- initial ddx
    p.dy = 1 -- give it some initial dy
    p.ddy = _PLAYER_GRAVITY
    p.angle = 0
    p.state = _PLAYER_STATE_ONGROUND
    p.board_cycler = new_cycler(0.05, {9,10,12})
    p.speedpin_cycler = new_cycler(0.05, {9,10,12})
    p.boosting = false
    p.juice = 3
    p.style = 0
    p.airtimer = 0
    p.pose = false
    p.pinned = false
    p.frame_timer = 0
    p.plane = 0
    p.planedy = 0
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
    if p.pinned and _debug.pinflash then
      pal(0, p.speedpin_cycler:get_color())
    end
    local base_sprite = 11 + 2*p.angle

    if p.state == _PLAYER_STATE_ONGROUND then
      if p.planedy > 0 then
        base_sprite = 46
      elseif p.planedy < 0 then
        base_sprite = 38
      end
    end

    if player.pose and _debug.pose then base_sprite = 34 + 2*p.angle end

    local draw_y = p.y - 4
    draw_y -= p.plane

    spr(base_sprite, p.x-10, draw_y, 2, 2)
        
    p.last_sprite = base_sprite

    -- draw bb
    local bb = p:get_bb()
    rect(bb[1],bb[2],bb[3],bb[4],11)

    pal()
    palt()
  end,
  get_bb = function(p)
    return {flr(p.x - 8), flr(p.y+7 - p.plane), flr(p.x+4), flr(p.y+11-p.plane)}
  end,
  start_jump = function(p, boosted_dy)
    p.dy = mid(-1, boosted_dy, (p.dx / p.dx_max) * boosted_dy)
    -- make sure we're just above ground level first
    p.y = p.y - 0.1
    p.dx -= p.dx * 0.1
    p.airtimer = 0
    p:change_state(_PLAYER_STATE_SKYUP)
  end,
  near_ground = function(p, y_ground)
   return abs(p.y - y_ground) < 1 or p.y > y_ground
  end,
  update = function(p, dt, y_ground, ground_angle, block_input)

    p.frame_timer += dt
    if p.frame_timer >= 2 then
      p.frame_timer = 0
    end

    -- update board cycler
    p.board_cycler:update(dt)

    -- update outline cycler for speedpin
    p.speedpin_cycler:update(dt)

    local pstate = p:get_state()
    if pstate == _PLAYER_STATE_ONGROUND 
      or pstate == _PLAYER_STATE_SKYUP
      or pstate == _PLAYER_STATE_SKYDOWN
      or pstate == _PLAYER_STATE_HOPUP
      or pstate == _PLAYER_STATE_HOPDOWN then
      player_state_funcs[pstate](p, dt, y_ground, ground_angle, block_input)

      local f = function()
        return p.speedpin_cycler:get_color()
      end
      if p:get_state() == _PLAYER_STATE_ONGROUND and p.planedy == 0 then
        add(_FX.parts, new_part(
          p.x - rnd(2),
          p.y - p.plane + 12 - rnd(4),
          function() return sin(rnd()) * -1 end,
          function() return 0 end,
          {7}, -- regular color
          _timers.okami.ttl > 0 and f or nil, -- colorf
          nil,
          flr(rnd(2)) + 1,
          0.4,
          false,
          0
        ))
      end

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
      p.juice >= 1 then
      if _debug.sakurai then
        _timers.sakurai:init(0.5,time())
        make_lines()
        __update = _update_stop
        __draw = _draw_stop
      else
        _timers.sakurai:init(0.01,time())
      end
        
    end

    if btnp(2) and p.plane == 0 then
      p.planedy = 0.5
      add(_FX.trails, {})
    elseif btnp(3) and p.plane == 6 then
      p.planedy = -0.5
      add(_FX.trails, {})
    end

    if p.planedy ~= 0 then
      p.plane += p.planedy
      add(_FX.trails[#_FX.trails], {x=player.x, y=player.y-player.plane+10, rad=flr(rnd(2))+1})
    end
    if p.plane <= 0 or p.plane >= 6 then
      p.planedy = 0
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
        if p.boosting then
          p.handle_expr_boost()
          _timers.boost.ttl = 0
        end
        -- do the shake
        _shake = 1
        for i=0,20 do 
          add(_FX.parts,
            new_part(
              p.x + rnd(3),
              p.y + p.plane + 11 - rnd(4),
              function() return sin(rnd()) * 3 end,
              function() return -rnd(7) end,
              {7},
              nil,
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
        if p.boosting and _debug.pinparticles then
          _timers.boost:add(_PLAYER_BOOST_BONUS)
          _timers.okami:init(0.2,time())
        end

        -- speed pin if timer was low enough
        if p.airtimer < _PLAYER_AIRTIMER_0 then
          p.dx = p.dx_max
          p.airtimer = 0
          -- for stopping the speed pin cycler
          p.pinned = true
          _timers.speedpin:init(0.2,time())
        end

        -- for stopping the pose
        _timers.pose:init(0.25,time())
        p.pose = true
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

player.handle_expr_boost = function()
  player.dx_max = _PLAYER_DX_MAX
  player.boosting = false
end

player.handle_obs_coll = function()
  player.dx = player.dx * 0.93
end

function move_in_y(p, y_ground)
  p.dy = min(_PLAYER_DY_MAX, p.dy + p.ddy)
  p.y = min(p.y + p.dy, y_ground)
  return p
end
