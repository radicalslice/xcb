function _draw_gameover()
  cls()
  print("game over", 48, 64, 8)
end

function _update_gameover()
  if btnp(4) or btnp(5) then
    _init()
  end
end
