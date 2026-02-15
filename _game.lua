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
_last_music_idx = -1
Y_BASE = 80

_debug = {
  msgs = true,
}

_timers = {}
_shake = 0

function _update_game(dt)
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

  local meter_color = 12
  local meter_width = 28
  if player.boosting then
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
 local range = find_range(board_pos_x, _level)
 local angle = 0 -- assume flat ground
 if range != nil then
   y_ground, angle = range.f(board_pos_x)
 else
   _timers.boost:f()
   star_mode_off()
   player.ddx = _PLAYER_DDX
   -- prevent the gameover time from triggering if the player has already init'd it
   _timers.pregameover.ttl = 0

   local boosttime = player.boosting_time / (_now - _level.started_at)
   printh("Boosttime: "..boosttime)
   if boosttime > 0.66 then
      _boardscore:update(_level.name, "boosttime", true)
   end

   if _level_index == 5 or _level_index == 6 then
     -- music(-1, 200)
     -- music(14, 100)
     -- show boardscore a couple seconds after finishing
     _timers.show_boardscore2:init(3,_now)
      _savedboardscore:merge(_boardscore)
      _savedboardscore:save()
   end

   __update = _update_interlevel
   __draw = _draw_interlevel
   return

 end

  -- Check for any jumps
  local added_dy = find_jump(board_pos_x + player.dx, _level)
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
    t[1].ttl -= dt
    if t[1].ttl <= 0 then
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
        sfx(4, 3)
        _q.add_event("obs_coll")
      end
    end
  end)

  -- check for collision between player and item
  if _itemmgr.visible == true and collides_new(player:get_big_bb(), _itemmgr:get_bb()) then
    _itemmgr.visible = false
    sfx(3, 3)
    _boardscore:update(_level.name, "juicebox", true)
  end
end

_camera_y = 0
_last_camera_y_offset = 0
_camera_x = 0
function align_camera(player_x)
  local y_ground = Y_BASE
  -- Look ahead to try and prep camera, this is based on the ground a little bit ahead
  -- Changed this from 24 to 48 and it made it better, somehow, on the downward slopes
  local range = find_range(player_x + 48, _level)
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
      rectfill(true_x, true_y+8, true_x+8, 132, _level_config.tiles[8])
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
  if player_x + 132 > _level.x_max then
    local x_start = _level.x_max
    local y_offset = _last_y_drawn - _camera_y
    for i=x_start,x_start+256,8 do
      local true_x = i - player_x + _camera_x_offset
      local true_y = _last_y_drawn - _camera_y
      rectfill(true_x, y_offset+8, true_x+8, 132, _level_config.tiles[8])
      map(
        _level_config.tiles[7],
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


  if _level_config.draw_f != nil then
    _level_config.draw_f()
  else
    -- palette swappies
    if _level_config.sky_f != nil then
      _level_config.sky_f() 
    end

    basepal()

    if _level_config.sun_f != nil then
      _level_config.sun_f()
    end

    if _level_config.mtn_f != nil then
      _level_config.mtn_f()
    end

    for i=0,224,32 do
      map(
        _level_config.tiles[1],
        _level_config.tiles[2],
        _mountain_x + i,
        _level_config.tiles[3],
        4,
        2
      )
    end

    basepal()
    

    if _level_config.snow_f != nil then
      _level_config.snow_f()
    end
    -- random trees
    for i=0,224,32 do
      map(9,1, _bigtree_x + i, _level_config.tiles[4], 4, _level_config.tree_tileheight)
    end

    -- Snow below trees and above course
    rectfill(-16,52,144,128,7)

    -- foreground trees
    if _level_config.foreground then
      for i=0,224,32 do
        map(9,4, _bigtree_x + i, _level_config.tiles[4] + 12, 4, 1)
      end
    end
    basepal()
  end

  if _level_config.course_f != nil then
    _level_config.course_f()
  end
  draw_course(player.x)
  basepal()

  align_camera(player.x)

  camera(_camera_x, _camera_y)

  palt()

  -- draw any obstacles
  foreach(_obsman.obstacles, function(obs)
    obs:draw()
  end)

  _itemmgr:draw()

  foreach(_FX.trails, function(t)
    for crc in all(t) do 
      circfill(crc.x,crc.y,crc.rad,(_level_config.trailcolor or 6))  
    end
  end)

  -- player over background
  player:draw()

  foreach(_FX.parts, function(p)
    if _frame_counter % p.mod != 0 then
      p:draw()
    end
  end)

  camera()

  foreach(_FX.notifs, function(n)
    n:draw()
  end)

  basepal()
  foreach(_FX.snow, function(c) 
    spr(118, c.x, c.y)
  end)

  -- draw menu over everything
  for i=1,3 do
    spr(82, 1, 82 - (i*6))
  end
  for i=1,player.juice do
    spr(67, 1, 82 - (i*6))
  end
  if player.juice % 1 == _PLAYER_JUICE_ADD then
    spr(83, 1, 82 - (ceil(player.juice)*6))
  end

  _FX.speedo:draw()

  local text_color, border_color = 12, 1
  local c = _game_timer.clock
  if c < 5 then
    text_color, border_color = 8, 2
  end
  circfill(124, 2, 20, 0)
  if c > 5 or c == 0 or c % 1 > 0.5 then
    print("\^w\^t"..flr(max(0, c)), 112, 2, border_color)
    print("\^w\^t"..flr(max(0, c)), 113, 3, text_color)
  end
  -- end menu draw
 
  if _debug.msgs then
    -- print("\^o7ffnomiss: "..(_level.score.nomiss and "true" or "false"), 0, 0, 9)
    -- print("\^o7ffboosting t: "..player.boosting_time, 0, 6, 9)
    -- print("\^o7ffjuice: "..(_level.score.juicebox and "true" or "false"), 0, 12, 9)
    -- print("\^o7ffvis: "..(_itemmgr.visible and "true" or "false"), 0, 18, 9)
    print("\^o7ffPXY: "..flr(player.x)..","..flr(player.y), 0, 24, 9)
  end
end
