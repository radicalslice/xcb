function _draw_interlevel()
  _draw_game()
end

function _update_interlevel()
  local now = time()
  local dt = now - last_ts
  player:update(dt, player.y, player.angle)

  if btnp(4) or btnp(5) then
    _update60 = _update_victory
    _draw = _draw_victory
  end
end
