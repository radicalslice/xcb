function _draw_title()
  -- _draw_game()
  cls()
  palt(11, true)
  palt(0, false)
  rectfill(0,0,127,127,7)
  -- sky
  rectfill(0, 0, 128, 128, 12)
  -- clouds
  local cloudheight = 5
  local gapheight = 3
  local next_y = 0
  while cloudheight > 1 do
    rectfill(0, next_y, 128, next_y + cloudheight, 7) 
    next_y = next_y + cloudheight + gapheight
    cloudheight -= 1
    gapheight += 1
  end

  rectfill(0, 110, 90, 132, 7)

  print("\^w\^t\^x64\^o7ff snowpeel", -8, 34, 12)
  print("\^o7ff"..BUTTON_X.." sTART", 22, 54, 12)
  print("\^o7ff"..BUTTON_O.." vIEW bOARDSCORE", 22, 64, 12)

  for i=0,2 do
    map(21, 0, (i*24), 74, 3, 5)
  end
  -- downward ramp
  for i=0,6 do
    map(27, 0, 72+(i*8), 81+(i*8), 1, 5)
  end
  -- dude
  spr(128, 50, 80, 2, 2)

  print("v1.0", 1, 1, 6)
  print("game by @kitasuna", 4, 115, 6)
  print("music by @mabbees", 4, 122, 6)

  foreach(_FX.snow, function(c) 
    spr(118, c.x, c.y)
  end)
end


function _update_title()
  _timers.input_freeze:update(_now)

  _timers.snow:update(_now)

  _timers.show_boardscore:update(_now)

  foreach(_FX.snow, function(c) 
    c.x -= c.dx
    c.y += c.dx
    if c.x < -32 or c.y > 132 then
      del(_FX.snow, c)
    end
  end)

  _timers.interlevel:update(_now)

  if _timers.input_freeze.ttl == 0 and btnp(4) then
    _init_wipe(0.4)
    _timers.show_boardscore:init(0.2, _now)
  end

  if _timers.input_freeze.ttl == 0 and btnp(5) and _timers.interlevel.ttl <= 0 then
    anytime_init()
    _timers.interlevel:init(0.2, _now)
    _init_wipe(0.4)
    music(-1,100)
    music(0,300)
    star_mode_off()
  end
end
