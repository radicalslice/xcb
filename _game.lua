_bigtree_x = 0
_mountain_x = 0
_bigtree_dx = 0.6
_mountain_dx = 0.2
_camera_x_offset = 24
_game_timer = 0
_frame_counter = 0
_last_y_drawn = 0
Y_BASE = 88
_debug = {
  msgs = true,
  pinflash = true,
  pinparticles = true,
  pose = true,
  idle = false,
  sakurai = true,
}
_timers = {}
_shake = 0

function _update_game()
  local now = time()
  local dt = now - last_ts

  -- update timers
  _timers.boost:update(now)
  _timers.pose:update(now)
  _timers.sakurai:update(now)
  _timers.speedpin:update(now)
  _timers.okami:update(now)

  _q.proc()

  _game_timer -= dt
  if _game_timer < 0 then
    _game_timer = 0
    __update = _update_gameover
    __draw = _draw_gameover
  end

  _bigtree_x -= (_bigtree_dx * player.dx)
  _mountain_x -= (_mountain_dx * player.dx)

  if _bigtree_x < -127 then _bigtree_x = 0 end
  if _mountain_x < -127 then _mountain_x = 0 end

  -- squash shake if it's > 0
  if _shake > 0 then
   _shake = _shake*0.95
   if (_shake<0.1) then _shake=0 end
 end

  local board_pos_x = player:get_board_center_x()
  local y_ground = Y_BASE
  local range = find_range(board_pos_x, level)
  local angle = 0 -- assume flat ground
  if range != nil then
    y_ground, angle = range.f(board_pos_x)
  else
    cls()
    -- force player to stop boosting
    if _level_index == _level_count then
      __update = _update_victory
      __draw = _draw_victory
    else 
      _timers.boost:f()
      _timers.input_freeze:init(0.5,now)
      __update = _update_interlevel
      __draw = _draw_interlevel
    end
    return
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
function align_camera()
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
end

function draw_course()
  local last_x_drawn = 0
  for tile in all(_map_table) do 
    if tile.x < player.x + 136 then
      map(tile.map_x,
        tile.map_y,
        tile.x - player.x + _camera_x_offset,
        tile.y - _camera_y,
        1,
        tile.height)
      last_x_drawn = tile.x
      _last_y_drawn = tile.y
    end
  end

  -- printh("P.Y, LYD: "..player.y..",".._last_y_drawn)
  if player.x + 128 > level.x_max then
    local x_start = player.x > level.x_max and (player.x - (player.x % 8)) - 32 or level.x_max
    for i=x_start,x_start+144,8 do
      local tile = gen_flat_tile(i, _last_y_drawn)
      map(
        tile.map_x,
        tile.map_y,
        tile.x - player.x + _camera_x_offset,
        tile.y - _camera_y,
        1,
        tile.height
      )
    end
  end
end

function _draw_game()
  cls()

  align_camera()

  -- add in the shake, if any
  local shakex = (4 - rnd(8)) * _shake
  local shakey = (4 - rnd(8)) * _shake

  camera(shakex, shakey)

  -- palate swappies
  level.config.sky_f() 

  -- clouds
  if level.config.clouds then
    map(0, 0, -16, 0, 18, 1)
  end

  -- sky
  rectfill(-16,0,144,63,12)
  pal() 

  palt(11, true)
  palt(0, false)

  -- parallax-y mountain tiles
  -- sunset_mtns()
  -- night_mtns()
  -- sun / moon / etc
  level.config.sun_f()

  level.config.mtn_f()

  for i=0,224,32 do
    map(
      level.config.mountain_tile_x,
      level.config.mountain_tile_y,
      _mountain_x + i,
      level.config.mountain_pos_y,
      4,
      2
    )
  end

  pal()

  palt(11, true)
  palt(0, false)
  

  level.config.snow_f()

  -- random trees
  for i=0,224,32 do
    map(9,1, _bigtree_x + i, level.config.tree_pos_y, 4, level.config.tree_tileheight)
  end

  -- Snow below trees and above course
  rectfill(-16,52,144,128,7)

  -- foreground trees
  if level.config.foreground then
    for i=0,224,32 do
      map(9,4, _bigtree_x + i, level.config.tree_pos_y + 12, 4, 1)
    end
  end
  pal()

  palt(11, true)
  palt(0, false)

  draw_course()
  camera(_camera_x, _camera_y)

  palt()


  -- player over background
  player:draw()

  foreach(_FX.parts, function(p)
    p:draw()
  end)

  camera()


  -- draw menu over everything
  palt(11, true)
  rectfill(0, 0, 9, 128, 0)
  for i=1,3 do
    spr(112, 1, 82 - (i*6))
  end
  for i=1,player.juice do
    spr(96, 1, 82 - (i*6))
  end
  if player.juice % 1 == _PLAYER_JUICE_ADD then
    spr(113, 1, 82 - (ceil(player.juice)*6))
  end

  local meter_max = 97
  local meter_color = 12
  if not player.boosting then
    meter_max = 131 - ((player.dx / player.dx_max) << 5)
  else
    meter_max = 118 - ((player.dx / player.dx_max) << 5)
    meter_color = player.board_cycler:get_color()
  end
  rectfill(1,126,7,meter_max,meter_color)
  rect(0,85,8,98,1)
  rect(0,98,8,127,1)
  for i=0,8,2 do
    pset(i, 98, 12)
  end

  circfill(6, 4, 15, 0)
  local text_color, border_color = 12, 1
  if _game_timer < 5 then
    text_color, border_color = 8, 2
  end
  if _game_timer > 5 or _game_timer % 1 > 0.5 then
    print("\^w\^t"..flr(_game_timer), 1, 2, border_color)
    print("\^w\^t"..flr(_game_timer), 2, 3, text_color)
  end
  -- print("("..flr(time())..")", 76, 12, 9)
  -- end menu draw
 
  if _debug.msgs then
    -- draw_ctrls(12, 108, 9)
    -- player debug stuff
    -- print("X: "..flr(player.x), 56, 100, 9)
    -- print("Y: "..player.y, 56, 96, 10)
    -- print("dx: "..player.dx, 56, 106, 9)
    -- print("dx_max: "..player.dx_max, 56, 112, 9)
    -- print("juice: "..player.juice, 56, 120, 9)
    -- print("style: "..player.style, 56, 120, 9)
    -- print(count(_FX.parts), 56, 120, 9)
  end
end
