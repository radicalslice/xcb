function _draw_title()
  -- _draw_game()
  cls()
  palt(11, true)
  palt(0, false)
  rectfill(0,0,127,127,7)
  -- sky
  rectfill(0, 0, 128, 128, 12)
  -- clouds
  local cloudheight = 6
  local gapheight = 3
  local next_y = 0
  while cloudheight > 0 do
    rectfill(0, next_y, 128, next_y + cloudheight, 7) 
    next_y = next_y + cloudheight + gapheight
    cloudheight -= 1
    gapheight += 1
  end

  -- new stuff
  circfill(24, 24, 4, 10)
  circ(24, 24, 6, 10)
  circ(24, 24, 8, 10)
  spr(98, 24, 25, 2, 1)
  spr(98, 8, 15, 2, 1, true)
  spr(116, 16, 20, 2, 1)

  -- flat bit
  rectfill(0, 84, 88, 132, 7)
  rectfill(88, 100, 116, 132, 7)
  for i=0,2 do
    map(21, 0, (i*24), 48, 3, 5)
  end
  -- downward ramp
  for i=0,6 do
    map(27, 0, 72+(i*8), 56+(i*8), 1, 5)
  end
  -- dude
  spr(128, 50, 50, 2, 2)
  print("\^w\^t\^o610x c b", 4, 57, 12)

  print("\^o610"..BUTTON_X..": sTART", 4, 90, 12)
  print("\^o610"..BUTTON_O..": vIEW bOARDSCORE", 4, 98, 12)
  -- palt()

  print("v1.0-alpha", 1, 1, 6)
  print("game by @kitasuna", 4, 112, 6)
  print("music by @mabbees", 4, 120, 6)

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

  if _timers.input_freeze.ttl == 0 and btnp(5) then
    _init_wipe(0.4)
    _timers.show_boardscore:init(0.2, _now)
  end

  if _timers.input_freeze.ttl == 0 and btnp(4)  and _timers.interlevel.ttl <= 0 then
    anytime_init()
    _timers.interlevel:init(0.2, _now)
    _init_wipe(0.4)
    -- music(-1,100)
    -- music(0,300)
    star_mode_off()
  end
end
