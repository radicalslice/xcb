-- globals for controlling time stuff
_now = 0
_last_ts = 0

-- anytime_init resets all our globals and game state
-- used when first starting the game, and when restarting after game over or victory state
-- NOT used during interlevel changes
function anytime_init()

    player:reset()

    _level_index = 1
    _game_timer = _checkpoints[_level_index]

    -- little extra code to draw the split in
    -- the speedometer
    local my_f = function(m)
      rect(2,121,43,126,6)
      line(32,121,32,126,6)
    end
    -- FX setup
    _FX = {
      parts = {},
      trails = {},
      -- clouds = {},
      -- x,y, width,height, max_val, color, draw_frame_f
      speedo = new_meter(3,121,32,4,_PLAYER_DX_MAX,10,my_f),
      snow = {},
    }

    -- parse this level to be rendered from x=0, y=Y_BASE
    local ranges, jumps, x_max = parse_ranges(_levels[_level_index], 0, Y_BASE)

    level = {
      ranges = ranges,
      jumps = jumps,
      x_max = x_max,
      config = _configs[_level_index],
    }

    -- _obsman:init()
    -- _obsman:test()

    _map_table, _elevations = load_level_map_data(level) 

    --[[
     expr_boost: Fired by boost timer to tell the player to stop boosting
     obs_call: Fired by main game loop when player and obstacle collide
    ]]--
    _q = qico()
    _q.add_topics("expr_boost|obs_coll|timeover")
    _q.add_subs("expr_boost", {player.handle_expr_boost})
    _q.add_subs("obs_coll", {player.handle_obs_coll})
    _q.add_subs("timeover", {player.handle_timeover})
end

function _init()
  printh("--init")

  _now = time()
  _last_ts = _now

  init_timers()
  _timers.input_freeze:init(0.1, _last_ts)
  _timers.snow:init(0.05, _last_ts)

  anytime_init()
  __update = _update_title
  __draw = _draw_title
end

function gen_flat_tile(x, y)
  return {x=x,y=y,map_x=21 + ((x / 8) % 3),map_y=0}
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
          {x=x_curr,y=y_updated -8 ,map_x=21 + ((x_curr / 8) % 3),map_y=0} -- generates flat tile
        )
        add(elevations, {x_curr, y_updated})
      last_angle = 0
      elseif angle == -1 then
        local map_x = 24
        if last_angle == -1 then map_x = 25 end
        add(map_table,{x=x_curr,y=y_updated-8,map_x=map_x,map_y=0})
        last_angle = -1
        add(elevations, {x_curr, y_updated})
      elseif angle == 1 then
        local map_x = 27
        if last_angle == -1 then map_x = 26 end
        add(map_table,{x=x_curr,y=y_updated,map_x=map_x,map_y=0})
        last_angle = 1
        add(elevations, {x_curr, y_updated})
      end
    end
  end

  return map_table, elevations
end

function _update60()
  _frame_counter += 1
  _now = time()
  local dt = _now - _last_ts
  __update(dt)
  _update_wipe(dt)
  _last_ts = _now
end

function _draw()
  __draw()
  _draw_wipe()
end
