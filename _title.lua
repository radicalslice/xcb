function _draw_title()
  -- _draw_game()
  cls()
  palt(11, true)
  palt(0, false)
  rectfill(0,0,127,127,7)
  -- sky
  rectfill(-16,0,144,32,12)
  -- backdrop
  for i=0,224,32 do
    -- mtns
    map(17,1,i,24,4,2)
    -- trees
    map(9,1, i, 30, 4, 3)
  end

  -- flat bit
  for i=0,2 do
    map(21, 0, (i*24), 48, 3, 5)
  end
  -- downward ramp
  for i=0,6 do
    map(27, 0, 72+(i*8), 56+(i*8), 1, 5)
  end
  -- dude
  spr(128, 50, 50, 2, 2)
  print("\^w\^tx c b", 8, 57, 12)

  print("press "..BUTTON_X.." or "..BUTTON_O, 8, 107, 12)
  -- palt()

  print("v0.4.0", 1, 1, 6)
  print("@kitasuna", 92, 1, 6)
end


function _update_title()
  _timers.input_freeze:update(_now)

  _timers.interlevel:update(_now)

  if _timers.input_freeze.ttl == 0 and (btnp(4) or btnp(5)) and _timers.interlevel.ttl <= 0 then
    anytime_init()
    _timers.interlevel:init(0.2, _now)
    _init_wipe(0.4)
  end
end
