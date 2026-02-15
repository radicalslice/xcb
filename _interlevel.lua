-- two values for tracking when the player holds down up or down arrows
_down_charge = 0
_up_charge = 0


function _draw_interlevel()
  _draw_game()

  palt(0, false)
  local up_arrow_x = 66
  local down_arrow_x = 66

  if btn(2) then
    up_arrow_x += rnd(2) - 1
  end
  if btn(3) then
    down_arrow_x += rnd(2) - 1
  end

  if _level_config.branches != nil and #_FX.headsup == 0 then
    print("\^o9ffHOLD",63,78,7)
    spr(114,up_arrow_x,69 - (_up_charge * 4))
    spr(114,down_arrow_x,85 + (_down_charge * 4),1,1,false,true)
    print("\^o9ff".._level_configs[_level_config.branches[1]].name, 76, 67, 7)
    print("\^o9ff".._level_configs[_level_config.branches[2]].name, 76, 90, 7)
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

  foreach(_FX.headsup, function(h) 
    h:update(dt)
    if h.ttl <= 0 then
      del(_FX.headsup, h)
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

  _timers.addlheadsup:update()

  if _level_config.branches != nil then
    -- play or stop arrow charing sfx
    if not btn(2) and not btn(3) then
      sfx(5, -2)
    elseif stat(19) != 5 and _timers.interlevel.ttl == 0 and (btn(2) or btn(3)) then
      sfx(5, 3)
    end

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
  end

  _timers.interlevel:update()

  if _level_index == 5 or _level_index == 6 then
    -- do nothing, just wait for victory screen
    _timers.show_boardscore2:update()
    return
  end

  if (_up_charge > 1.2 or _down_charge > 1.2 or _level_config.branches == nil) and _wipe_ttl == 0 and #_FX.headsup == 0 then
    _timers.interlevel:init(0.2, _now)
    sfx(5, -2)
    _init_wipe(0.4)

    if _level_config.branches == nil then
      _level_index += 1
      _maptrails:add(_level_config.notif_f1)
    elseif _up_charge > 1.2 then
      _level_index = _level_config.branches[1]
      _maptrails:add(_level_config.notif_f1up)
    else 
      _level_index = _level_config.branches[2]
      _maptrails:add(_level_config.notif_f1down)
    end
  end
end
