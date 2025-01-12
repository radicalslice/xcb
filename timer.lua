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
      _q.add_event("expr_boost")
    end
    )

  -- for a pose when landing
  _timers.pose = new_timer(
    0,
    function(t)
      -- t.ttl = 0.3
      player.pose = false
    end
    )

  -- for a sakurai stop when boosting
  _timers.sakurai = new_timer(
    0,
    function(t)
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
      player.pinned = false
    end
    )

  -- for stopping the okami particles 
  _timers.okami = new_timer(
    0,
    function(t) end
    )
  
  -- for stopping button presses from advancing
  _timers.input_freeze = new_timer(
    0,
    function(t) end
  )

  -- for screen transitions
  _timers.wipe = new_timer(
    0,
    function(t) end
  )

  -- for emitting snow
  _timers.snow = new_timer(
    0,
    function(t)
      local y = -80 + (flr(rnd(7)) * 10)
      local x = 90 + (flr(rnd(18)) * 8)
      -- local y, x = 64, 64
      local dx = 1+rnd(1)
      add(_FX.snow, {x=x, y=y, dx=dx})
      printh("added snow! "..#_FX.snow..", x: "..x.." y: "..y.." dx: "..dx)
      t:init(0.05, time())
    end
  )

  -- for when the timer runs out and we move to gameover state
  _timers.gameover = new_timer(
    0,
    function(t)
      __update = _update_gameover
      __draw = _draw_gameover
    end
  )
end
