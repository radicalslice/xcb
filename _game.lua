function _update_game()
  local board_pos_x = player:get_board_center_x()
  local y_ground = player.y_base
  local range = find_range(board_pos_x, level)
  local angle = 0 -- assume flat ground

  if range != nil then
    y_ground, angle = range:f(player.y_base, board_pos_x)
  end

  -- Check for any boosts
  local boosted_dy = find_boost(board_pos_x + player.dx, level)
  if boosted_dy != 0 and player:near_ground(y_ground) then
    player:boosty(boosted_dy, y_ground)
  end

  player:update(y_ground, angle)

end

function _draw_game()
  cls()
  palt(15, true)

  -- map(0, 0, 0, 0, 8, 8)
  camera(player.x - 24, 0)


  local y_base = 72
  for x_curr=-64,512 do
    local y_inner = y_base
    local angle = 0
    -- check for range
    local range = find_range(x_curr, level)
    if range != nil then
      y_inner, angle = range:f(y_base, x_curr)
    end
    pset(x_curr, y_inner, 12)
  end

  -- player over background
  player:draw()

  -- draw some dang background
  for i=-32,2056 do
    if i % 4 == 0 then
      line(i, 80, i, 82, 2)
    end
  end

  camera()
  
  draw_ctrls(12, 96)
  -- player debug stuff
  -- print("ST: "..player:get_state(), 96, 24, 10)
  -- print("DX: "..player.dx, 96, 30, 10)
  -- print("DY: "..player.dy, 96, 36, 10)
  -- print("Y: "..player.y, 80, 42, 10)

  pal()

end
