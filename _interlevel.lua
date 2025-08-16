_last_level_index = 1
-- two values for tracking when the player holds down up or down arrows
_down_charge = 0
_up_charge = 0

function _draw_interlevel()
  _draw_game()
  -- text box
  -- rectfill(24,32,112,72,0)
  -- print("level ".._last_level_index.." clear!", 34, 34, 9)
  -- print("time remaining: "..flr(_game_timer.clock).."S", 34, 42, 9)
  -- print("time added: ".._checkpoints[_last_level_index+1].."S",34,50,9)
  -- print("press "..BUTTON_X.." or "..BUTTON_O,34,60,9)
  -- branching arrows
  palt(0, false)

  local up_arrow_x = 55
  local down_arrow_x = 55

  if btn(2) then
    up_arrow_x += rnd(2) - 1
  end
  if btn(3) then
    down_arrow_x += rnd(2) - 1
  end

  spr(114,up_arrow_x,72 - (_up_charge * 2))
  spr(114,down_arrow_x,81 + (_down_charge * 2),1,1,false,true)
  dshad("(some level a)", 65, 68)
  dshad("(some level b)", 65, 88)
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
  if player.x >= level.x_max + 144 then 
    player.x = level.x_max
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

  _timers.interlevel:update()
  if _timers.input_freeze.ttl == 0 and (_up_charge > 2 or _down_charge > 2) and _timers.interlevel.ttl == 0 then
    _timers.interlevel:init(0.2, _now)
    _up_charge,_down_charge = 0,0
    _init_wipe(0.4)
    _level_index += 1
  end
end
