function _draw_victory()
  cls()
  print("victory!", 48, 64, 9)
  print("press "..BUTTON_X.." or "..BUTTON_O.." to restart", 14, 107, 9)
end

function _update_victory()
  if btnp(4) or btnp(5) then
    anytime_init()
  end
end
