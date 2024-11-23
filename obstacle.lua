_obsman = {
  -- we'll put obstacles waiting to spawn here
  queue = {},
  -- and spawned obstacles here
  obstacles = {},
  init = function(m)
    m.queue,m.obstacles = {},{}
  end,
  test = function(m)
    -- load up some test obstacles
    for j=1,20 do
      add(m.queue, new_q_obstacle(128*j + 128, flr(rnd(2))))
    end
  end,
  update = function(m)
    foreach(m.obstacles, function(obs)
      obs:update()
      if obs.x < player.x - 32 then
        del(m.obstacles, obs)
      end
    end)

  end,
}

function new_q_obstacle(spawn_x, plane)
  return {spawn_x=spawn_x, plane=plane}
end

function new_obstacle(plane, elevation)
  local obsy = (plane == 1) and elevation or (elevation - 8)
  return {
    x = 130 + _camera_x,
    y = obsy,
    plane = plane,
    draw = function(obs)
      rectfill(
      obs.x,
      obs.y - 8,
      obs.x + 8,
      obs.y,
      obs.plane==1 and 1 or 14)

      -- draw bb
      local bb = obs:get_bb()
      rect(bb[1],bb[2],bb[3],bb[4],11)
    end,
    update = function(obs)
      -- we don't need this because the camera is already in motion!
      -- obs.x -= dx 
    end,
    get_bb = function(obs)
      return {flr(obs.x)+1,flr(obs.y)-6,flr(obs.x)+7,flr(obs.y)}
    end
  }
end

-- Given player's current x value,
-- check if we need to spawn in any obstacles
function check_spawn(x_curr)
  foreach(_obsman.queue, function(obs)
    -- check the x pos and return if we need to spawn
    if x_curr + 128 > obs.spawn_x then
      local elevation = find_elevation(x_curr+128, _elevations)
      -- we'll use a 16px cheat to align to the course
      add(_obsman.obstacles, new_obstacle(obs.plane, elevation + 14))
      del(_obsman.queue, obs)
    end
  end)
end

