function new_timer(now, f)
  return {
    ttl = 0,
    last_t = now,
    f = f,
    init = function(t, ttl, last_t)
      t.ttl = ttl
      t.last_t = last_t
    end,
    -- add allows us to add some add'l time to the timer
    add = function(t, addl_t)
      t.ttl += addl_t
    end,
    update = function(t, now)
      if t.ttl == 0 then
        return
      end
      t.ttl = t.ttl - (now - t.last_t)
      t.last_t = now
      if t.ttl <= 0 then
        t.ttl = 0
        t:f()
      end
    end,
  }
end

function init_timers()
  -- player's boosting timer
  _timers.boost = new_timer(
    0,
    function(t)
      printh("boost timer expired")
      _q.add_event("expr_boost")
    end
    )

  -- for a pose when landing
  _timers.pose = new_timer(
    0,
    function(t)
      t.ttl = 0.3
      printh("expired pose stop")
      player.pose = false
    end
    )

  -- for a sakurai stop when boosting
  _timers.sakurai = new_timer(
    0,
    function(t)
      printh("expired sakurai stop")
      __update = _update_game
      __draw = _draw_game
      _timers.boost:init(2,time())
      player.juice -= 1
      player.dx_max = _PLAYER_DX_MAX_BOOSTED
      player.dx = _PLAYER_DX_MAX_BOOSTED
      player.boosting = true
    end
    )

  -- for stopping the speed pin cycler
  _timers.speedpin = new_timer(
    0,
    function(t)
      t.ttl = 0.3
      printh("expired speed pin timer")
      player.pinned = false
    end
    )

  -- for stopping the okami particles 
  _timers.okami = new_timer(
    0,
    function(t)
      printh("expired okami timer")
    end
    )
end
