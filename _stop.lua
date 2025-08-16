function _draw_stop()
  cls()

  align_camera(player.x)

  palt(11, true)
  palt(0, false)
  pal(7, 0)
  draw_course(player.x)
  camera(_camera_x, _camera_y)
  pal()
  palt()

  -- player over background
  player:draw()

  local colors = {9,10,12}
  foreach(_lines, function(l) 
    local sinof, cosof = sin(l.angle/360), cos(l.angle/360)
    line(
      player.x + l.r * cosof,
      player.y + player.plane - 6 + l.r * sinof,
      player.x + (l.inner_r+4) * cosof,
      player.y + player.plane + (l.inner_r+4) * sinof,
      rnd(colors)
    )
  end)

  camera()
end

function make_lines()
  _lines = {}
  for i=1,30 do
    local r = flr(24 + rnd(32))
    _lines[i] = {
      angle = i * 13,
      r = r,
      inner_r = r \ 2,
    }
  end
end

function _update_stop(dt)
  _timers.sakurai:update(_now)
  foreach(_lines, function(l) 
    l.inner_r *= 0.8
    l.r *= 0.90
  end)
end
