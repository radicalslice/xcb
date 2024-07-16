function _draw_stop()
  _draw_game()
end

function _update_stop()
  local now = time()
  _update_game()
  _timers.sakurai:update(now)
  printh("stopped")
end
