BoardScore = {}
function BoardScore:new(o)
  local base = {}
  for n in all(_level_names) do 
    add(base, {
      name = n,
      nomiss = false,
      boosttime = false,
      juicebox = false,
    })
  end
  o = o or base
  setmetatable(o, self)
  self.__index = self
  return o
end

function BoardScore:load()
  -- load from local
  for i, level_name in ipairs(_level_names) do
    local score = dget(i) 
    -- printh("Got score "..score.." for level "..level_name)
    local level = self:lookup(level_name)
    if score & 1 > 0 then
      level["nomiss"] = true 
    end
    if score & 1 << 1 > 0 then
      level["boosttime"] = true 
    end
    if score & 1 << 2 > 0 then
      level["juicebox"] = true 
    end
  end
end

function BoardScore:save()
  --save to local
  for i, level in ipairs(self) do -- foreach level...
    -- printh("saving level index: "..i)
    local score = 0     
    for k, val in pairs(level) do
      if k == "nomiss" and val then
        score |= 1 << 0
      end
      if k == "boosttime" and val then
        score |= 1 << 1
      end
      if k == "juicebox" and val then
        score |= 1 << 2
      end
    end
    dset(i, score)
    -- printh("Saved score "..score.." for level "..level.name)
  end
end

function BoardScore:lookup(level_name)
  for i=1,#self do
    if self[i].name == level_name then
      return self[i]
    end
  end
end

function BoardScore:update(level_name, key, value)
  for i=1,#self do
    if self[i].name == level_name then
      self[i][key] = value
    end
  end
end

-- for adding current run to previous runs
function BoardScore:merge(run)
  for i=1,#run do
    -- printh("Got run level: "..run[i].name)
    local self_level = self:lookup(run[i].name)
    for score_name, val in pairs(run[i]) do
      if score_name != "name" then
        self_level[score_name] = val or self_level[score_name]
      end
    end
  end
end
