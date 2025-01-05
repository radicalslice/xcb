advance_title = false

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
  palt()

  if _timers.wipe.ttl > 0 then
    -- this ensures we draw the game to the right / after the wipe
    -- set it to half of the value that we use to init the wipe timer below
    if _timers.wipe.ttl < 0.25 then
      _draw_game()
    end
    local x0 = -128 + (256 * (_timers.wipe.ttl * 2))
    rectfill(x0, 0, x0+128, 128, 0)
  end
end


function _update_title()
  last_ts = time()
  _timers.input_freeze:update(last_ts)
  _timers.wipe:update(last_ts)

  if _timers.input_freeze.ttl == 0 and (btnp(4) or btnp(5)) then
    anytime_init()
    _timers.wipe:init(0.5, last_ts)
    advance_title = true
  end

  if advance_title and _timers.wipe.ttl == 0 then
    __update = _update_game
    __draw = _draw_game
    advance_title = false
  end

end
