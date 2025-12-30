-- two values for tracking when the player holds down up or down arrows
_down_charge = 0
_up_charge = 0


function _draw_interlevel()
  _draw_game()

  palt(0, false)
  local up_arrow_x = 55
  local down_arrow_x = 55

  if btn(2) then
    up_arrow_x += rnd(2) - 1
  end
  if btn(3) then
    down_arrow_x += rnd(2) - 1
  end

  if _level_index == _level_count and _timers.interlevel.ttl == 0 then
    dshad("victory!", 70, 64)
    if _timers.input_freeze.ttl == 0 then
      dshad("press "..BUTTON_X.." or "..BUTTON_O, 58, 80)
      dshad(" to restart", 62, 88)
    end
  elseif _level_config.branches != nil then
    spr(114,up_arrow_x,72 - (_up_charge * 4))
    spr(114,down_arrow_x,81 + (_down_charge * 4),1,1,false,true)
    dshad(_level_configs[_level_config.branches[1]].name, 65, 68)
    dshad(_level_configs[_level_config.branches[2]].name, 65, 88)
  end

  palt(0, true)

end

function _update_interlevel(dt)
  _bigtree_x -= (_bigtree_dx * player.dx)
  _mountain_x -= (_mountain_dx * player.dx)

  if _bigtree_x < -127 then _bigtree_x = 0 end
  if _mountain_x < -127 then _mountain_x = 0 end
  
  if player.boosting then
    player.boosting = false
  end
  if player.x >= _level.x_max + 144 then 
    player.x = _level.x_max
    player.y = _last_y_drawn
    _FX.trails = {}
  end
  player:update(dt, player.y+player.dx, 1, true)
  align_camera(player.x)

  foreach(_FX.parts, function(part) 
    part:update(dt)
    if part.ttl <= 0 then
      del(_FX.parts, part)
    end
  end)

  _timers.input_freeze:update()
  if _level_index == 1 then
    foreach(_FX.snow, function(c) 
      c.x -= c.dx
      c.y += c.dx
      if c.x < -32 or c.y > 132 then
        del(_FX.snow, c)
      end
    end)
    _timers.snow:update()
  end

  if _level_index != _level_count then
    if btn(2) then
      _up_charge += dt
    elseif _up_charge > 0 then
      _up_charge = max(0, _up_charge - (dt * 3))
    end

    if btn(3) then
      _down_charge += dt
    elseif _down_charge > 0 then
      _down_charge = max(0, _down_charge - (dt * 3))
    end
  elseif _timers.input_freeze.ttl == 0 and (btnp(4) or btnp(5)) then
      anytime_init()
  end

  _timers.interlevel:update()
  if _timers.input_freeze.ttl == 0 and (_up_charge > 1.2 or _down_charge > 1.2) and _timers.interlevel.ttl == 0 then
    _timers.interlevel:init(0.2, _now)
    _init_wipe(0.4)
    if _up_charge > 1.2 then
      _level_index = _level_config.branches[1]
    else 
      _level_index = _level_config.branches[2]
    end

    _up_charge,_down_charge = 0,0
  end
end
