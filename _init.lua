function _init()
  _update = _update_game
  _draw = _draw_game
  player:reset()

  get_tile_from_pos = _get_tile_from_pos(0, 0)

  last_ts = time()

  printh("--init")

  local level1 = [[
0,flat,80,72
80,bup,16
96,bdown,32
96,flat,84,88
180,bup,16
196,bdown,16,
212,flat,128,88,
340,bup,16,
356,flat,128,72,
484,ddown,64,
548,flat,128,135]]

  local jumps1 = [[
96,-4.5
196,-3.5
356,-5.5]]

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
  local ranges = parse_ranges(level1)


  local jumps = parse_jumps(jumps1)

  level = {
    ranges = ranges,
    jumps = jumps,
  }
end

