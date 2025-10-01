_bigtree_x,_bigtree_dx = 0,0.6
_mountain_x = 0
_mountain_dx = 0.2
_camera_x_offset = 32
_game_timer = {
  clock = 0,
  expired = false,
}
_frame_counter = 0
_last_y_drawn = 0
_camera_freeze = false
_game_state = "main"
Y_BASE = 80


_debug = {
  msgs = true,
  pose = true,
  pinflash = true,
  pinparticles = true,
  sakurai = true,
}


_timers = {}
_shake = 0

function _update_game(dt)
  -- update timers
  _timers.boost:update(_now)
  _timers.pose:update(_now)
  _timers.sakurai:update(_now)
  _timers.speedpin:update(_now)
  _timers.okami:update(_now)
  _timers.pregameover:update(_now)
  if (_level_index == 1) then
    _timers.snow:update(_now)
  end

  _q.proc()

  check_spawn(player.x)
  _obsman:update()

  -- update meter color if boosting
  local meter_color = 12
  local meter_width = 28
  if player.boosting then
  -- else
    meter_color = player.board_cycler:get_color()
    meter_width = 40
  end
  _FX.speedo:update(player.dx, player.dx_max, meter_width, meter_color)
    
  if _game_timer.clock > 0 then
    _game_timer.clock -= dt
  elseif _game_timer.clock <= 0 and _game_timer.expired == false then
    _q.add_event("timeover")
    _game_timer.expired = true
  end

  if player.dx > 0 then
    _bigtree_x -= (_bigtree_dx * player.dx)
    _mountain_x -= (_mountain_dx * player.dx)
  end

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
     _timers.input_freeze:init(0.5,_now)
     player.ddx = _PLAYER_DDX
     -- prevent the gameover time from triggering if the player has already init'd it
     _timers.pregameover.ttl = 0
     _last_level_index = _level_index
     _up_charge,_down_charge = 0,0
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

  foreach(_FX.trails, function(t) 
    if t[1].x < player.x - 64 then
      del(_FX.trails, t)
    end
  end)

  foreach(_FX.snow, function(c) 
    c.x -= c.dx
    c.y += c.dx
    if c.x < -32 or c.y > 132 then
      del(_FX.snow, c)
    end
  end)

  foreach(_FX.notifs, function(n) 
    n:update(dt)
    if n.ttl <= 0 then
      del(_FX.notifs, c)
    end
  end)

  player:update(dt, y_ground, angle)

  -- check for collision between player and obstacles
  local pbb = player:get_bb()
  foreach(_obsman.obstacles, function(obs)
    if player.plane == obs.plane then
      local found_collides = collides_new(pbb, obs:get_bb())
      if found_collides then
        _q.add_event("obs_coll")
        printh("obs:player "..obs.plane..","..player.plane)
      end
    end
  end)
end

_camera_y = 0
_last_camera_y_offset = 0
_camera_x = 0
function align_camera(player_x)
  local y_ground = Y_BASE
  -- Look ahead to try and prep camera, this is based on the ground a little bit ahead
  -- Changed this from 24 to 48 and it made it better, somehow, on the downward slopes
  local range = find_range(player_x + 48, level)
  if range != nil then
    y_ground, _ = range.f(player_x + 48)
  end

  _camera_x = player_x - _camera_x_offset
  _camera_y = flr(player.y - Y_BASE)
  if player.y - y_ground < -1 then
    local adj = flr((player.y - y_ground) * 0.5)
    _last_camera_y_offset = adj
  elseif _last_camera_y_offset != 0 then
    _last_camera_y_offset += 1
  end

  _camera_y -= _last_camera_y_offset
end

function draw_course(player_x)
  local last_x_drawn = 0
  for tile in all(_map_table) do 
    if tile.x < player_x + 136 then
      local true_x = tile.x - player_x + _camera_x_offset
      local true_y = tile.y - _camera_y
      rectfill(true_x, true_y+8, true_x+8, 132, level.config.tiles[8])
      map(tile.map_x,
        tile.map_y,
        true_x,
        true_y,
        1,
        5) -- height of 5, hardcoding for now
      last_x_drawn = tile.x
      _last_y_drawn = tile.y
    end
  end

  -- this is for drawing beyond the calculated end of a level
  if player_x + 132 > level.x_max then
    local x_start = level.x_max
    local y_offset = _last_y_drawn - _camera_y
    for i=x_start,x_start+256,8 do
      local true_x = i - player_x + _camera_x_offset
      local true_y = _last_y_drawn - _camera_y
      rectfill(true_x, y_offset+8, true_x+8, 132, level.config.tiles[8])
      map(
        level.config.tiles[7],
        0,
        true_x,
        y_offset,
        1,
        5
      )
      y_offset += 8 
    end
  end
end

function _draw_game()
  cls()

  -- add in the shake, if any
  local shakex = (4 - rnd(8)) * _shake
  local shakey = (4 - rnd(8)) * _shake

  if shakex != 0 or shakey != 0 then
    camera(shakex, shakey)
  end

  local config = level.config

  if config.draw_f != nil then
    config.draw_f()
  else
    -- palette swappies
    config.sky_f() 

    pal() 

    palt(11, true)
    palt(0, false)

    -- parallax-y mountain tiles
    -- sunset_mtns()
    -- night_mtns()
    -- sun / moon / etc
    config.sun_f()

    config.mtn_f()

    for i=0,224,32 do
      map(
        config.tiles[1],
        config.tiles[2],
        _mountain_x + i,
        config.tiles[3],
        4,
        2
      )
    end

    pal()

    palt(11, true)
    palt(0, false)
    

    config.snow_f()
    -- random trees
    for i=0,224,32 do
      map(9,1, _bigtree_x + i, config.tiles[4], 4, config.tree_tileheight)
    end

    -- Snow below trees and above course
    rectfill(-16,52,144,128,7)

    -- foreground trees
    if config.foreground then
      for i=0,224,32 do
        map(9,4, _bigtree_x + i, config.tiles[4] + 12, 4, 1)
      end
    end
    pal()

    palt(11, true)
    palt(0, false)
  end

  draw_course(player.x)

  align_camera(player.x)

  camera(_camera_x, _camera_y)

  palt()


  -- draw any obstacles
  foreach(_obsman.obstacles, function(obs)
    obs:draw()
  end)

  foreach(_FX.trails, function(t)
    for crc in all(t) do 
      circfill(crc.x,crc.y,crc.rad,(config.trailcolor or 6))  
    end
  end)

  -- player over background
  player:draw()

  foreach(_FX.parts, function(p)
    p:draw()
  end)

  camera()

  foreach(_FX.notifs, function(n)
    n:draw()
  end)

  palt(11, true)
  foreach(_FX.snow, function(c) 
    spr(118, c.x, c.y)
  end)

  -- draw menu over everything
  -- rectfill(112, 0, 128, 24, 0)
  for i=1,3 do
    spr(82, 1, 82 - (i*6))
  end
  for i=1,player.juice do
    spr(67, 1, 82 - (i*6))
  end
  if player.juice % 1 == _PLAYER_JUICE_ADD then
    spr(83, 1, 82 - (ceil(player.juice)*6))
  end

  -- rectfill(0,120,128,128,0)
  _FX.speedo:draw()

  local text_color, border_color = 12, 1
  local c = _game_timer.clock
  if c < 5 then
    text_color, border_color = 8, 2
  end
  circfill(124, 2, 20, 0)
  -- rectfill(112, 0, 128, 24, 0)
  if c > 5 or c == 0 or c % 1 > 0.5 then
    print("\^w\^t"..flr(max(0, c)), 112, 2, border_color)
    print("\^w\^t"..flr(max(0, c)), 113, 3, text_color)
  end
  -- print("("..flr(time())..")", 76, 12, 9)
  -- end menu draw
 
  if _debug.msgs then
    -- draw_ctrls(12, 108, 9)
    -- player debug stuff
    -- print("X: "..flr(player.x), 56, 100, 9)
    -- print("cpu: "..stat(1), 56, 100, 9)
    -- print("plr: "..flr(player.x)..","..flr(player.y)..","..player.plane, 56, 94, 9)
    -- print("level: "..level.name, 56, 106, 9)
    -- if #(_obsman.obstacles) > 0 then
      -- print("obs[1]: ".._obsman.obstacles[1].y, 56, 114, 9)
    -- end
    -- print("dx_max: "..player.dx_max, 56, 112, 9)
    -- print("juice: "..player.juice, 56, 120, 9)
    -- print("style: "..player.style, 56, 120, 9)
    -- print(count(_FX.parts), 56, 120, 9)
  end
end
