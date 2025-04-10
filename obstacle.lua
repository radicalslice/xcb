_obsman = {
  -- we'll put obstacles waiting to spawn here
  queue = {},
  -- and spawned obstacles here
  obstacles = {},
  init = function(m)
    m.queue,m.obstacles = {},{}
  end,
  -- parses level data but only looks at the obstacles
  parselvl = function(m,lvlstr)
    local x_curr = 0
    foreach(split(lvlstr, "\n"), function(substr)
      local vals = split(substr, ",")
      if vals[1] == "obs" then
        printh("added  obs!"..x_curr..","..vals[2])
        add(m.queue, new_q_obstacle(x_curr, vals[2]))
      else
        x_curr += vals[2]
      end
    end)
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

function new_obstacle(elevation, plane)
  local obsy = (plane == 6) and (elevation+8) or elevation
  printh("Obstacle at elevation "..elevation.." and plane "..plane)
  return {
    x = 130 + _camera_x,
    y = obsy,
    plane = plane,
    draw = function(obs)
      spr(66, obs.x, obs.y)

      -- draw bb
      -- local bb = obs:get_bb()
      -- rect(bb[1],bb[2],bb[3],bb[4],11)
    end,
    update = function(obs)
      -- we don't need this because the camera is already in motion!
      -- obs.x -= dx 
    end,
    get_bb = function(obs)
      return {flr(obs.x),flr(obs.y),flr(obs.x)+7,flr(obs.y)+5}
    end
  }
end

-- Given player's current x value,
-- check if we need to spawn in any obstacles
function check_spawn(x_curr)
  foreach(_obsman.queue, function(obs)
    -- check the x pos and return if we need to spawn
    if x_curr + 128 > obs.spawn_x then
      local elevation = find_elevation(obs.spawn_x, _elevations)
      printh("Spawn at: "..obs.spawn_x..", elevation: "..(elevation)..", player: "..player.y)
      -- we'll use a 14px cheat to align to the course
      add(_obsman.obstacles, new_obstacle(elevation, obs.plane))
      del(_obsman.queue, obs)
    end
  end)
end

