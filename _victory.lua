function _draw_victory()
  cls()
  print("victory!", 48, 64, 9)
end

function _update_victory()
  if btnp(4) or btnp(5) then
    __update = _update_title
    __draw = _draw_title
    _timers.input_freeze:init(0.2, last_ts)
  end
end
