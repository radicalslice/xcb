function _init()
  _update60 = _update_game
  _draw = _draw_game
  player:reset()
  _game_timer = 28

  get_tile_from_pos = _get_tile_from_pos(0, 0)

  last_ts = time()

  -- player's boosting timer
  _timers.boost = new_timer(
    0,
    function()
      printh("did the boost timer expiration")
      player.dx_max = _PLAYER_DX_MAX
      player.boosting = false
    end
  )

  _timers.trick = new_timer(
    0,
    function()
      if player.trick_state == _PLAYER_TKSTATE_TRICKING then
        player.trick_state = _PLAYER_TKSTATE_REWARD
        player.dx *= 0.5
        _timers.trick_reward:init(1,time())
        player.last_trick_ttl = 0
        trick_cycler_1.colors = {8, 7}
      end
      if player.boosting then
        player.dx_max = _PLAYER_DX_MAX_BOOSTED
      else
        player.dx_max = _PLAYER_DX_MAX
      end
    end
    )
 _timers.trick.window_min = 0
 _timers.trick.window_max = 0

 _timers.trick_reward = new_timer(
   0,
   function()
     printh("did trick reward timer expiration!")
     player.trick_state = _PLAYER_TKSTATE_OFF
     player.last_trick_ttl = nil
   end
   )

  printh("--init")

  -- parse this level to be rendered from x=0, y=Y_BASE
  local ranges, jumps, x_max = parse_ranges(_level0, 0, Y_BASE)

  level = {
    ranges = ranges,
    jumps = jumps,
    x_max = x_max,
  }

  _map_table = load_level_map_data(level) 
end

function gen_flat_tile(x, y)
  return {x=x,y=y,map_x=21 + ((x / 8) % 3),map_y=0,height=6}
end

function load_level_map_data(level)
  local map_table = {}
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
      elseif angle == -1 then
        add(map_table,{x=x_curr,y=y_updated-8,map_x=24,map_y=0,height=5})
        if x_curr % 16 != 0 then
          --bonus corner tile
          add(map_table,{x=x_curr,y=y_updated-8,map_x=26,map_y=0,height=1})
        else
          add(map_table,{x=x_curr,y=y_updated-16,map_x=26,map_y=1,height=1})
        end
      elseif angle == 1 then
        add(map_table,{x=x_curr,y=y_updated,map_x=25,map_y=0,height=5})
      end
    end
  end

  return map_table
end
