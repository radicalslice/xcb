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
  for i, snow in pairs(_FX.snow) do
    pset(snow.x, snow.y, 6)
  end
  palt()
end


function _update_title()
  last_ts = time()

  if #_FX.snow < 40 then
    local snow_y = rnd(128) - 32
    local snow_dx = 3.1
    local snow_osc = rnd(3)
    add(_FX.snow, {x=128, y=snow_y, dx=snow_dx, osc=snow_osc})
  end

  for i, snow in pairs(_FX.snow) do
    snow.x-=snow.dx 
    snow.y = snow.y + (sin(snow.x)*snow.osc) + rnd(2)
    if snow.x < 0 then
      del(_FX.snow, snow)
    end
  end

  if btn(4) or btn(5) then
    anytime_init()
    __update = _update_game
    __draw = _draw_game
  end
end
