function _draw_stop()
  cls()

  align_camera()

  palt(11, true)
  palt(0, false)
  pal(7, 0)
  -- pal(5, 7)
  -- pal(6, 0)
  draw_course()
  camera(_camera_x, _camera_y)
  pal()
  palt()

  -- player over background
  player:draw()

  local colors = {9,10,12}
  foreach(_lines, function(l) 
    printh("draw with angle: "..l.angle)
    line(
      player.x + l.r * cos(l.angle/360),
      player.y + l.r * sin(l.angle/360),
      player.x + l.inner_r * cos(l.angle/360),
      player.y + l.inner_r * sin(l.angle/360),
      colors[flr(rnd(#colors)) + 1]
    )
  end)

  camera()
end

function make_lines()
  _lines = {}
  for i=1,30 do
    local r = flr(24 + rnd(32))
    printh("make line with angle: "..i)
    _lines[i] = {
      angle = i * 13,
      r = r,
      inner_r = r \ 2,
    }
  end
end

function _update_stop()
  local now = time()
  -- _update_game()
  _timers.sakurai:update(now)
  foreach(_lines, function(l) 
    l.inner_r *= 0.8
    l.r *= 0.90
  end)
end
