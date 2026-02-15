function _draw_gameover()
  _draw_game()
  print("\^w\^t\^o7ffgame", 32, 48, 8)
  print("\^w\^t\^o7ffover", 66, 48, 8)
  print("\^o8ffpress "..BUTTON_X.." or "..BUTTON_O.." to restart", 14, 100, 7)
end

function _update_gameover()
  if btnp(4) or btnp(5) then
    __update = _update_title
    __draw = _draw_title
    _level_index = 0
    _timers.input_freeze:init(0.4, _now)
  end
end
