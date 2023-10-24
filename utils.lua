get_tile_from_pos = nil
function _get_tile_from_pos(start_tile_x, start_tile_y)
  return function(pos_x, pos_y)
    return (pos_x \ 8) + start_tile_x, (pos_y \ 8) + start_tile_y
  end
end

function exists(e, tbl)
  for i=1,#tbl do
    if tbl[i] == e then
      return true
    end
  end
  return false
end

function draw_ctrls(x, y)
  -- draw controls on screen
  print("⬅️", x-4, y+5, btn(0) and 11 or 7)
  print("⬆️", x, y, btn(2) and 11 or 7)
  print("➡️", x+4, y+5, btn(1) and 11 or 7)
  print("⬇️", x, y+10, btn(3) and 11 or 7)
  print("❎", x+13, y+8, btn(4) and 11 or 7)
  print("🅾️", x+21, y+5, btn(5) and 11 or 7)
 
end
