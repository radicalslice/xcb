function _update_game()
  local now = time()
  local dt = now - last_ts

  local board_pos_x = player:get_board_center_x()
  local y_ground = player.y_base
  local range = find_range(board_pos_x, level)
  local angle = 0 -- assume flat ground

  if range != nil then
    y_ground, angle = range:f(player.y_base, board_pos_x)
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

function _draw_game()
  cls()
  palt(15, true)

  local LEVEL_MAX = 256

  -- map(0, 0, 0, 0, 8, 8)
  camera(player.x - 24, 0)

  local y_base = 72
  for x_curr=player.x-64,player.x+112 do
    local y_updated = y_base
    local angle = 0
    -- check for range
    local range = find_range(x_curr, level)
    if range != nil then
      y_updated, angle = range:f(y_base, x_curr)
    end
    pset(x_curr, y_updated, 12)
  end

  -- player over background
  player:draw()

  -- draw some dang background
  for i=player.x-64,player.x+112 do
    if flr(i) % 12 == 0 then
      spr(10, i, 76)
    end
  end

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

  pal()

end
