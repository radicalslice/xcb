function _draw_gameover()
  cls()
  print("game over", 48, 64, 8)
end

function _update_gameover()
  last_ts = time()
  if btnp(4) or btnp(5) then
    __update = _update_title
    __draw = _draw_title
    _timers.input_freeze:init(0.2, last_ts)
  end
end
