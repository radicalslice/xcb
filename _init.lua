function _init()
  _update60 = _update_game
  _draw = _draw_game
  player:reset()

  get_tile_from_pos = _get_tile_from_pos(0, 0)

  last_ts = time()

  printh("--init")

  -- x_start, type, x_length, height for flats
  local level1 = [[
0,flat,80,72
80,bup,16
96,bdown,32
96,flat,80,88
176,bup,16
192,bdown,16,
208,flat,128,88,
336,bup,16,
352,flat,128,72,
480,ddown,64,
544,flat,128,135]]

  local jumps1 = [[
96,-3.5
192,-3.5
352,-3.5]]

--[[
  local level2 = [[
0,flat,80,72
80,bup,16
96,bdown,16
112,flat,16,72
128,ddown,64]]
  local jumps2 = [[
96,-5.5]]
--]]
  local ranges, x_max = parse_ranges(level1)

  local jumps = parse_jumps(jumps1)

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
    -- if x_curr % 6 == 0 and x_curr > _last_sprite_at then
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
      -- _last_sprite_at = x_curr
    end
  end
end

