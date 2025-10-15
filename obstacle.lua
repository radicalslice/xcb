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
      if substr == "" then
        return
      end
      local vals = split(substr, ",")
      if vals[1] == "obs" then
        add(m.queue, {spawn_x=x_curr,plane=vals[2],sprite=vals[3]})
        x_curr += 8
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

function new_obstacle(elevation, plane, sprite)
  local obsy = elevation
  if plane == 6 then
    obsy = elevation + 8
  elseif plane == -6 then
    obsy = elevation - 8
  end
  return {
    x = 126 + _camera_x,
    y = obsy,
    sprite = sprite,
    plane = plane,
    draw = function(obs)
      spr(obs.sprite, obs.x, obs.y)

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
      add(_obsman.obstacles, new_obstacle(elevation, obs.plane, obs.sprite))
      del(_obsman.queue, obs)
    end
  end)
end

