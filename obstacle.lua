_obsman = {
  -- we'll put obstacles waiting to spawn here
  queue = {},
  -- and spawned obstacles here
  obstacles = {},
  init = function(m)
    m.queue,m.obstacles = {},{}
  end,
  parselvl = function(m,lvlstr)
    local x_curr = 0
    foreach(split(lvlstr, "\n"), function(substr)
      local vals = split(substr, ",")
      if substr == "" or vals[1] == "--" then
        return
      end
      if vals[1] == "obs" then
        add(m.queue, {spawn_x=x_curr,plane=vals[2],sprite=vals[3] and vals[3] or 181})
        x_curr += 8
      -- handle obs ramps
      elseif vals[4] == "obs" then
        -- using a throwaway sprite here, it will be overwritten
        add(m.queue, {spawn_x=x_curr+26,plane=0,sprite=115})
        add(m.queue, {spawn_x=x_curr+32,plane=0})
        x_curr += 8
      else
        x_curr += vals[2]
      end
    end)
  end,
  update = function(m)
    foreach(m.obstacles, function(obs)
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
      if obs.sprite != nil then
        spr(obs.sprite, obs.x, obs.y)
      end

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

