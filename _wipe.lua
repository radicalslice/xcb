-- current ttl
_wipe_ttl = 0
-- value the last time ttl was set
_wipe_ttl0 = 0

function _draw_wipe()
  if _wipe_ttl > 0 then
    local factor = (_wipe_ttl0 - _wipe_ttl)/_wipe_ttl0
    rectfill(0, 128 - (256 * factor), 128, 256 - (256 * factor), 0)
  end
end

function _update_wipe(dt)
  _wipe_ttl = max(0, _wipe_ttl - dt)
end

function _init_wipe(ttl)
  _wipe_ttl = ttl
  _wipe_ttl0 = ttl
end
