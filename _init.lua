function _init()
  __update = _update_game
  __draw = _draw_game
  player:reset()
  _game_timer = _checkpoints[1]
  _level_index = 1

  get_tile_from_pos = _get_tile_from_pos(0, 0)

  last_ts = time()

  -- FX setup
  _FX = {
    parts = {},
  }
  
  _q = qico()
  _q.add_topics("expr_boost")
  _q.add_subs("expr_boost", {player.handle_expr_boost})


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

  printh("--init")

  -- parse this level to be rendered from x=0, y=Y_BASE
  local ranges, jumps, x_max = parse_ranges(_level1, 0, Y_BASE)

  level = {
    ranges = ranges,
    jumps = jumps,
    x_max = x_max,
    config = _configs[_level_index],
  }

  _map_table = load_level_map_data(level) 
end

function gen_flat_tile(x, y)
  return {x=x,y=y,map_x=21 + ((x / 8) % 3),map_y=0,height=5}
end

function load_level_map_data(level)
  local map_table = {}
  local last_angle = 0 -- use this to track when there's a transition between ramp/flat
  for x_curr=0, level.x_max do
    local range = find_range(x_curr, level)
    if range != nil then
      y_updated, angle = range.f(x_curr)
    end
    if x_curr % 8 == 0 then
      if angle == 0 then
        add(
          map_table,
          gen_flat_tile(x_curr, y_updated - 8)
        )
      last_angle = 0
      elseif angle == -1 then
        local map_x = 24
        if last_angle == -1 then map_x = 25 end
        add(map_table,{x=x_curr,y=y_updated-8,map_x=map_x,map_y=0,height=5})
        last_angle = -1
      elseif angle == 1 then
        local map_x = 27
        if last_angle == -1 then map_x = 26 end
        add(map_table,{x=x_curr,y=y_updated,map_x=map_x,map_y=0,height=5})
        last_angle = 1
      end
    end
  end

  return map_table
end

function _update60()
  __update()
end

function _draw()
  __draw()
end
