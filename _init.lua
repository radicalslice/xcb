-- anytime_init resets all our globals and game state
function anytime_init()

    player:reset()

    _level_index = 1
    _game_timer = _checkpoints[_level_index]

    -- FX setup
    _FX = {
      parts = {},
    }

    -- parse this level to be rendered from x=0, y=Y_BASE
    local ranges, jumps, x_max = parse_ranges(_levels[_level_index], 0, Y_BASE)

    level = {
      ranges = ranges,
      jumps = jumps,
      x_max = x_max,
      config = _configs[_level_index],
    }

    _obsman:init()
    _obsman:test()

    _map_table, _elevations = load_level_map_data(level) 

    --[[
     expr_boost: Fired by boost timer to tell the player to stop boosting
     obs_call: Fired by main game loop when player and obstacle collide
    ]]--
    _q = qico()
    _q.add_topics("expr_boost|obs_coll")
    _q.add_subs("expr_boost", {player.handle_expr_boost})
    _q.add_subs("obs_coll", {player.handle_obs_coll})
end

function _init()
  printh("--init")

  last_ts = time()

  init_timers()
  _timers.input_freeze:init(0.1, last_ts)

  -- need this for title screen, so we'll set it up in here
  _FX = {
    parts = {},
  }

  anytime_init()
  __update = _update_game
  __draw = _draw_game
end

function gen_flat_tile(x, y)
  return {x=x,y=y,map_x=21 + ((x / 8) % 3),map_y=0,height=5}
end

function load_level_map_data(level)
  local map_table = {}
  local elevations = {}
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
        add(elevations, {x_curr, y_updated})
      last_angle = 0
      elseif angle == -1 then
        local map_x = 24
        if last_angle == -1 then map_x = 25 end
        add(map_table,{x=x_curr,y=y_updated-8,map_x=map_x,map_y=0,height=5})
        last_angle = -1
        add(elevations, {x_curr, y_updated})
      elseif angle == 1 then
        local map_x = 27
        if last_angle == -1 then map_x = 26 end
        add(map_table,{x=x_curr,y=y_updated,map_x=map_x,map_y=0,height=5})
        last_angle = 1
        add(elevations, {x_curr, y_updated})
      end
    end
  end

  return map_table, elevations
end

function _update60()
  _frame_counter += 1
  __update()
end

function _draw()
  __draw()
end
