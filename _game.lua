_bigtree_x = 0
_smalltree_x = 0
_bigtree_dx = 0.6
_smalltree_dx = 0.2
_camera_x_offset = 24
Y_BASE = 88
_timers = {}

function _update_game()
  local now = time()
  local dt = now - last_ts

  -- update timers
  _timers.boost:update(now)

  _bigtree_x -= (_bigtree_dx * player.dx)
  _smalltree_x -= (_smalltree_dx * player.dx)

  if _bigtree_x < -127 then _bigtree_x = 0 end
  if _smalltree_x < -127 then _smalltree_x = 0 end

  local board_pos_x = player:get_board_center_x()
  local y_ground = Y_BASE
  local range = find_range(board_pos_x, level)
  local angle = 0 -- assume flat ground
  if range != nil then
    y_ground, angle = range.f(board_pos_x)
  else
    cls()
    stop("Done!")
  end

  -- Check for any jumps
  local added_dy = find_jump(board_pos_x + player.dx, level)
  if added_dy != 0 and player:near_ground(y_ground) then
    player:start_jump(added_dy)
  end

  -- handle FX
  foreach(_FX.parts, function(part) 
    part:update(dt)
    if part.ttl <= 0 then
      del(_FX.parts, part)
    end
  end)

  player:update(dt, y_ground, angle)

  last_ts = now

end

_last_sprite_at = 0
_camera_y = 0
_last_camera_y_offset = 0
_camera_x = 0
function _draw_game()
  cls()

  local y_ground = Y_BASE
  -- Look ahead to try and prep camera
  local range = find_range(player:get_board_center_x() + 24, level)
  if range != nil then
    y_ground, _ = range.f(player:get_board_center_x() + 24)
  end

  _camera_x = player.x - _camera_x_offset
  _camera_y = flr(player.y - Y_BASE)
  if player.y - y_ground < -1 then
    local adj = flr((player.y - y_ground) * 0.5)
    _last_camera_y_offset = adj
  elseif _last_camera_y_offset != 0 then
    _last_camera_y_offset += 1
  end

  _camera_y -= _last_camera_y_offset

  -- sky
  rectfill(0,8,128,63,12)

  palt(11, true)
  palt(0, false)
  -- parallax-y mountain tiles
  for i=0,224,32 do
    map(17,0, _smalltree_x + i, 24, 4, 1)
  end
  -- random trees
  for i=0,224,32 do
    map(17,2, _bigtree_x + i, 28, 4, 3)
  end

  -- Lower half (snow)
  rectfill(0,52,128,128,7)

  local LEVEL_MAX = 256

  -- the sky
  map(0, 0, 0, 0, 16, 2)

  -- if player.y - 64 > 16
  -- move camera downwards by player.y - 64
  --[[
  if player.y - _camera_y < (64 - 24) then
    _camera_y -= 1
  end
  if player.y - _camera_y > (64 + 24) then
    _camera_y += 1
  end
  ]]--


  for tile in all(_map_table) do 
    map(tile.map_x,
      tile.map_y,
      tile.x - player.x + _camera_x_offset,
      tile.y - _camera_y,
      1,
      tile.height)
  end

  camera(_camera_x, _camera_y)

  palt()

  foreach(_FX.parts, function(p)
    p:draw()
  end)

  -- player over background
  player:draw()

  camera()
  
  draw_ctrls(12, 108, 9)
  -- player debug stuff
  -- print("ST: "..player:get_state(), 96, 24, 10)
  print("X/Y: "..flr(player.x).."/"..flr(player.y), 56, 100, 9)
  -- print("Y: "..player.y, 56, 96, 10)
  print("dx: "..player.dx, 56, 106, 9)
  print("dx_max: "..player.dx_max, 56, 112, 9)
  -- print("juice: "..player.juice, 56, 120, 9)
  print("boostttl: ".._timers.boost.ttl, 56, 120, 9)
end
