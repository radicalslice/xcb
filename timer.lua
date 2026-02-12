function new_timer(now, f)
  return {
    ttl = 0,
    last_t = now,
    f = f,
    init = function(t, ttl, last_t)
      t.ttl = ttl
      t.last_t = last_t
    end,
    add = function(t, addl_t)
      t.ttl += addl_t
    end,
    update = function(t)
      if t.ttl == 0 then
        return
      end
      t.ttl = t.ttl - (_now - t.last_t)
      t.last_t = _now
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

  sakurai_f_base = function(t)
      __update = _update_game
      __draw = _draw_game
      _timers.boost:init(2,time())
      player.juice -= 1
      player.dx_max = _PLAYER_DX_MAX_BOOSTED
      player.dx = _PLAYER_DX_INIT_BOOSTED
      player.boosting = true
      return t
  end

  sakurai_f_ext = compose(
    sakurai_f_base,
    function(t)
      music(1)
    end
  )

  -- for a sakurai stop when boosting
  _timers.sakurai = new_timer(
    0,
    sakurai_f_base
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

  _timers.show_boardscore = new_timer(
    0,
    function(t) 
      local victory = VictoryScreen:new({header = "all boardscore", levels = _level_names})
      __update = function() victory:update() end
      __draw = function() victory:draw() end
    end
  )

  _timers.show_title = new_timer(
    0,
    function(t) 
      anytime_init()
      __update = _update_title
      __draw = _draw_title
    end
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
      t:init(0.05, time())
    end
  )

  -- for the little interlevel "animation" and wipe
  _timers.interlevel = new_timer(
    0,
    function(t)
      -- reset player x value
      player.x = 40
      player.y = Y_BASE

      -- pass in last_y_drawn so the level hopefully connects to previous one...
      -- pass in 0 for the player's x position because it doesn't matter here
      local ranges, jumps, x_max = parse_ranges(_levels[_level_index])

      printh("Loading config for level ".._level_index)
      _level_config = _level_configs[_level_index]

      local levelname = _level_config.name
      _level = {
        name = levelname,
        ranges = ranges,
        jumps = jumps,
        x_max = x_max,
        score = _boardscore:lookup(levelname),
        started_at = _last_ts, -- for calculating elapsed time on level
      }

      -- assume true for the nomiss score
      _level.score.nomiss = true


      for t,v in pairs(_level.score) do
        printh(t..":"..(v and "true" or "false")) 
      end

      add(_FX.notifs, new_notif(_level.name))

      _map_table, _elevations = load_level_map_data() 

      _game_timer.clock += _checkpoints[_level_index]

      _obsman:init()
      _obsman:parselvl(_levels[_level_index])

      _itemmgr:init(_level_config.item_pos)
      
      player.boosting_time = 0
      player.ddx = _PLAYER_DDX
      player.dx = _PLAYER_DX_MAX
      add(player.level_history, _level.name)

      _camera_freeze = false
      _interlevel_wipego = false
      _game_state = "main"
      __update = _update_game
      __draw = _draw_game
    end
  )

  -- for when the timer runs out and we want to move to gameover state
  _timers.pregameover = new_timer(
    0,
    function(t)
      _q.add_event("pregameover_expr")
    end
  )
end

_timermgr = {
  handle_playerstop = function()
    music(-1, 1000)
    _timers.pregameover:init(2,time())
  end
}
