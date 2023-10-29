function _init()
  _update = _update_game
  _draw = _draw_game
  player:reset()

  get_tile_from_pos = _get_tile_from_pos(0, 0)

  last_ts = time()

  printh("--init")
end

