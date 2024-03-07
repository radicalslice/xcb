LAST_FLAT = 72
_bigtree_x = 128
_smalltree_x = 0
_bigtree_dx = 1
_smalltree_dx = 0.5
function _update_game()
  local now = time()
  local dt = now - last_ts

  local board_pos_x = player:get_board_center_x()
  local y_ground = player.y_base
  local range = find_range(board_pos_x, level)
  local angle = 0 -- assume flat ground

  _bigtree_x -= (_bigtree_dx * player.dx)
  _smalltree_x -= (_smalltree_dx * player.dx)

  if _bigtree_x < -127 then _bigtree_x = 128 end
  if _smalltree_x < -127 then _smalltree_x = 0 end

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

  player:update(y_ground, angle)

  last_ts = now

end

-- Map[XPos][SpriteIndex]
_sprite_table = {}
_last_sprite_at = 0
_camera_y = 0
function _draw_game()
  cls()

  rectfill(0,0,128,128,6)
  rectfill(0,63,128,66,5)
  rectfill(0,16,128,63,12)

  palt(11, true)
  palt(0, false)
  map(17,0, _smalltree_x, 50, 4, 2)
  map(17,0, _smalltree_x+32, 50, 4, 2)
  map(17,0, _smalltree_x+64, 50, 4, 2)
  map(17,0, _smalltree_x+96, 50, 4, 2)
  map(17,0, _smalltree_x+128, 50, 4, 2)
  map(17,0, _smalltree_x+128+32, 50, 4, 2)
  map(17,0, _smalltree_x+128+64, 50, 4, 2)
  map(17,0, _smalltree_x+128+96, 50, 4, 2)
  map(17,2, _bigtree_x, 50, 1, 2)
  map(17,2, _bigtree_x+128, 50, 1, 2)
  palt()
  -- map(0,0,0,0,16,1)
  -- repeatingtrees
  -- mset(4,6,10)
  -- mset(5,6,11)
  -- mset(4,7,26)
  -- mset(5,7,27)
  for i = 0,1 do 
    -- map(17,0,i*128-player.x%128,48,16,3)
  end
  local LEVEL_MAX = 256

  map(0, 0, 0, 0, 16, 8)
  -- if player.y - 64 > 16
  -- move camera downwards by player.y - 64
  if player.y - _camera_y < (64 - 24) then
    _camera_y -= 1
  end
  if player.y - _camera_y > (64 + 24) then
    _camera_y += 1
  end
  camera(player.x - 24, _camera_y)

  local y_base = 72
  palt(11, true)
  for x_curr=flr(player.x-64),flr(player.x+112) do
    local y_updated = y_base
    local angle = 0
    -- check for range
    local range = find_range(x_curr, level)
    if range != nil then
      y_updated, angle = range.f(x_curr)
    end
    if x_curr % 6 == 0 and x_curr > _last_sprite_at then
      if angle == 0 then
        -- spr(0, x_curr, y_updated-4, 3, 2)
        -- sprite_table[x_curr] = 0 + flr(rnd(3))
        add(_sprite_table, {x=x_curr-2, y=y_updated-4, sprnum=0+flr(rnd(3))})
        add(_sprite_table, {x=x_curr-2, y=y_updated+4, sprnum=16+flr(rnd(3))})
        _last_sprite_at = x_curr
      end
    end
    if angle == -1 then
      -- spr(3, x_curr, y_updated - 4, 1, 1) 
      line(x_curr, y_updated, x_curr+2, y_updated-1, 7)
    elseif angle == 1 then
      -- spr(4, x_curr, y_updated - 4, 1, 1) 
      line(x_curr, y_updated, x_curr+2, y_updated+3, 7)
    elseif angle != 0 then
      -- pset(x_curr, y_updated, 12)
    end
  end
  -- printh("SPrite table length: "..#_sprite_table)
  for v in all(_sprite_table) do
    -- clean up old entries
    if v.x < (player.x - 140) then
      del(_sprite_table, v)
    end
    spr(v.sprnum, v.x, v.y)
  end

  palt()

  -- player over background
  player:draw()

  -- draw some dang background
  --[[
  for i=player.x-64,player.x+112 do
    if flr(i) % 12 == 0 then
      spr(10, i, 76)
    end
  end
  ]]--

  foreach(_FX.parts, function(p)
    p:draw()
  end)

  camera()
  
  draw_ctrls(12, 96)
  -- player debug stuff
  -- print("ST: "..player:get_state(), 96, 24, 10)
  print("X/Y: "..flr(player.x).."/"..flr(player.y), 56, 88, 10)
  -- print("Y: "..player.y, 56, 96, 10)
  print("DX: "..player.dx, 56, 96, 10)
  print("angle: "..player.angle, 56, 102, 10)
  -- print("DDX: "..player.ddx, 56, 102, 10)
  -- print("Y: "..player.y, 80, 42, 10)
  -- print(stat(0), 80,  110, 12)
  -- print("CPU: "..stat(1), 80,  118, 12)

end
