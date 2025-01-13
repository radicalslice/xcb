function _draw_interlevel()
  _draw_game()
  rectfill(24,32,112,72,0)
  print("level ".._level_index.." clear!", 34, 34, 9)
  print("time remaining: "..flr(_game_timer).."S", 34, 42, 9)
  print("time added: ".._checkpoints[_level_index+1].."S",34,50,9)
  print("press "..BUTTON_X.." or "..BUTTON_O,34,60,9)
end

function _update_interlevel()
  printh("Camera: ".._camera_x..",".._camera_y)
  local now = time()
  local dt = now - last_ts
  
  if player.boosting then
    player.boosting = false
  end
  player:update(dt, player.y+player.dx, 1, true)
  if player.x >= level.x_max + 144 and not _camera_freeze then 
    player.x = level.x_max
    player.y = _last_y_drawn + 8
    _FX.trails = {}
  end

  foreach(_FX.parts, function(part) 
    part:update(dt)
    if part.ttl <= 0 then
      del(_FX.parts, part)
    end
  end)

  _timers.input_freeze:update(now)
  if _level_index == 1 then
    foreach(_FX.snow, function(c) 
      c.x -= c.dx
      c.y += c.dx
      if c.x < -32 or c.y > 132 then
        del(_FX.snow, c)
      end
    end)
    _timers.snow:update(now)
  end

  _timers.interlevel:update(now)
  if _timers.input_freeze.ttl == 0 and (btnp(4) or btnp(5)) and _timers.interlevel.ttl == 0 then
    _camera_freeze = true
    _timers.interlevel:init(1.5, now)
  end
end
