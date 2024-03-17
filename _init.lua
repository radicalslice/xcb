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
      printh("did the timer expiration")
      player.dx_max = _PLAYER_DX_MAX
    end
  )

  printh("--init")

  -- x_start, type, x_length, height for flats
  local level1 = [[
flat,64,72
ddown,128
flat,128,200
bup,16,-3.5
bdown,16
flat,64,200
bup,16,-3.5
bdown,16
flat,96,200
bup,16,-3.5
bdown,16
flat,8,200
ddown,64
flat,96,264
bup,16,-3.5
bdown,16
flat,24,264
bup,16,-3.5
bdown,16
flat,96,264,
bup,16,-2.5
flat,96,248,
ddown,64
flat,96,312,
bup,16,-2.5
flat,16,296
bup,16,-3.5
bdown,16
flat,8,296
ddown,64
flat,128,360]]


  local levelf = [[
flat,64,72
ddown,128
flat,128,200
bup,16,-3.5
bdown,16
flat,1200,200]]

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

