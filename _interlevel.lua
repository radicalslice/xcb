function _draw_interlevel()
  _draw_game()
  rectfill(24,32,112,72,0)
  print("level ".._level_index.." clear!", 34, 34, 9)
  print("time remaining: "..flr(_game_timer).."S", 34, 42, 9)
  print("time added: ".._checkpoints[_level_index+1].."S",34,50,9)
  print("press "..BUTTON_X.." or "..BUTTON_O,34,60,9)
end

function _update_interlevel()
  local now = time()
  local dt = now - last_ts
  
  if player.boosting then
    player.boosting = false
  end
  player:update(dt, player.y, player.angle, true)
  if player.x >= level.x_max + 128 then 
    player.x = level.x_max
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

  if _timers.input_freeze.ttl == 0 and (btnp(4) or btnp(5)) then
    _level_index += 1

    -- reset player x value
    player.x = 40

    -- pass in last_y_drawn so the level hopefully connects to previous one...
    local ranges, jumps, x_max = parse_ranges(_levels[_level_index], flr(player.x - (flr(player.x) % 8)), _last_y_drawn + 8)

    level = {
      ranges = ranges,
      jumps = jumps,
      x_max = x_max,
      config = _configs[_level_index],
    }

    _map_table = load_level_map_data(level) 

    _game_timer += _checkpoints[_level_index]

    _obsman:init()
    
    player.ddx = _PLAYER_DDX

    printh("game state switch: interlevel->game")
    last_ts = time()
    __update = _update_game
    __draw = _draw_game
  end
end
