function _draw_interlevel()
  _draw_game()
  print("interlevel", 0, 0, 9)
end

function _update_interlevel()
  local now = time()
  local dt = now - last_ts
  -- should add a flag here to disallow button presses
  player:update(dt, player.y, player.angle, true)

  if btnp(4) or btnp(5) then
    -- pass in last_y_drawn so the level hopefully connects to previous one...
    local ranges, jumps, x_max = parse_ranges(_level0, flr(player.x - (flr(player.x) % 8)), _last_y_drawn + 8)

    level = {
      ranges = ranges,
      jumps = jumps,
      x_max = x_max,
    }

    _map_table = load_level_map_data(level) 

    _game_timer += _checkpoints[1]

    printh("game state switch: interlevel->game")
    _update60 = _update_game
    _draw = _draw_game
  end
end
