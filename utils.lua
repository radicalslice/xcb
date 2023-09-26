get_tile_from_pos = nil
function _get_tile_from_pos(start_tile_x, start_tile_y)
  return function(pos_x, pos_y)
    return (pos_x \ 8) + start_tile_x, (pos_y \ 8) + start_tile_y
  end
end

function draw_ctrls()
  -- draw controls on screen
  print("⬅️", 96, 5, btn(0) and 11 or 7)
  print("⬆️", 100, 0, btn(2) and 11 or 7)
  print("➡️", 104, 5, btn(1) and 11 or 7)
  print("⬇️", 100, 10, btn(3) and 11 or 7)
  print("❎", 113, 8, btn(4) and 11 or 7)
  print("🅾️", 121, 5, btn(5) and 11 or 7)
 
end
