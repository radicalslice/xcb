function _draw_victory()
  cls()
  print("victory!", 48, 64, 9)
end

function _update_victory()
  if btnp(4) or btnp(5) then
    _init()
  end
end
