function _init()
  _update60 = _update_game
  _draw = _draw_game
  player:reset()

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
      printh("did the trick timer expiration")
      player.tricking = false
      if player.boosting then
        player.dx_max = _PLAYER_DX_MAX_BOOSTED
      else 
        player.dx_max = _PLAYER_DX_MAX
      end
    end
  )

  printh("--init")

  -- type, x_length, height for flats
  local level1 = [[
flat,96
ddown,64
flat,256
bup,16,-3.5
bdown,16
flat,256
bup,16,-3.5
bdown,16
flat,192
ddown,16
flat,128
bup,16,-3.5
bdown,32
flat,192
bup,16,-3.5
bdown,16
flat,32
bup,16,-3.5
bdown,16
flat,96
bup,16,-2.5
flat,96
ddown,64
flat,96
bup,16,-2.5
flat,16
bup,16,-3.5
bdown,16
flat,8
ddown,64
flat,128]]

  local ranges, jumps, x_max = parse_ranges(level1)

  level = {
    ranges = ranges,
    jumps = jumps,
  }

  -- load map data for this level
  for x_curr=0, x_max do
    local range = find_range(x_curr, level)
    if range != nil then
      y_updated, angle = range.f(x_curr)
    end
    if x_curr % 8 == 0 then
      if angle == 0 then
        local flat_tile = 21 + flr(rnd(3))
        add(_map_table,{x=x_curr,y=y_updated-8,map_x=flat_tile,map_y=0,height=4})
      elseif angle == -1 then
        add(_map_table,{x=x_curr,y=y_updated-8,map_x=24,map_y=0,height=5})
        if x_curr % 16 != 0 then
          --bonus corner tile
          add(_map_table,{x=x_curr,y=y_updated-8,map_x=26,map_y=0,height=1})
        else
          add(_map_table,{x=x_curr,y=y_updated-16,map_x=26,map_y=1,height=1})
        end
      elseif angle == 1 then
        add(_map_table,{x=x_curr,y=y_updated,map_x=25,map_y=0,height=5})
      end
    end
  end
end

