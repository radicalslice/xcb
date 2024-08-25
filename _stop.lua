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

  camera()
end

function _update_stop()
  local now = time()
  -- _update_game()
  _timers.sakurai:update(now)
  printh("stopped")
end
